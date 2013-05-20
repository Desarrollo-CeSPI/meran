#!/usr/bin/perl
#
# Meran - MERAN UNLP is a ILS (Integrated Library System) wich provides Catalog,
# Circulation and User's Management. It's written in Perl, and uses Apache2
# Web-Server, MySQL database and Sphinx 2 indexing.
# Copyright (C) 2009-2013 Grupo de desarrollo de Meran CeSPI-UNLP
#
# This file is part of Meran.
#
# Meran is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Meran is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Meran.  If not, see <http://www.gnu.org/licenses/>.
#

use strict;
use C4::AR::Auth;
use CGI;
use C4::AR::Nivel3 qw(getNivel3FromId3);
my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user({
                                        template_name => "catalogacion/estructura/detalleEjemplar.tmpl",
                                        query => $input,
                                        type => "intranet",
                                        authnotrequired => 0,
                                        flagsrequired   => {    ui => 'ANY', 
                                                                tipo_documento => 'ANY', 
                                                                accion => 'CONSULTA', 
                                                                entorno => 'datos_nivel1'},
                                        debug => 1,
    });


my $obj=$input->param('obj');
if($obj) {
    $obj=C4::AR::Utilidades::from_json_ISO($obj);
    my $tipo= $obj->{'tipo'};
    my $id3 = $obj->{'id3'};

    if($tipo eq "VER_HISTORICO_DISPONIBILIDAD"){

    my ($template, $session, $t_params) = get_template_and_user({
                                            template_name => "catalogacion/estructura/detalleEjemplarDisponibilidad.tmpl",
                                            query => $input,
                                            type => "intranet",
                                            authnotrequired => 0,
                                            flagsrequired   => {    ui => 'ANY', 
                                                                    tipo_documento => 'ANY', 
                                                                    accion => 'CONSULTA', 
                                                                    entorno => 'datos_nivel3'},
                                            debug => 1,
        });

    my $ini = $obj->{'ini'} || 0;

    my $nivel3 = C4::AR::Nivel3::getNivel3FromId3($id3);

    if ($nivel3) {
        my ($ini,$pageNumber,$cantR)    =   C4::AR::Utilidades::InitPaginador($ini);
        my ($cant_historico,$historico_disponibilidad) = C4::AR::Nivel3::getHistoricoDisponibilidad($id3,$ini,$cantR);

        $t_params->{'paginador'} = C4::AR::Utilidades::crearPaginador($cant_historico,$cantR, $pageNumber,$obj->{'funcion'},$t_params);
        $t_params->{'nivel3'} = $nivel3;
        $t_params->{'historico_disponibilidad'} = $historico_disponibilidad;
        $t_params->{'cant_historico'} = $cant_historico;
    }

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

    }
    elsif($tipo eq "VER_HISTORICO_CIRCULACION"){

    my ($template, $session, $t_params) = get_template_and_user({
                                            template_name   => "catalogacion/estructura/detalleEjemplarCirculacion.tmpl",
                                            query           => $input,
                                            type            => "intranet",
                                            authnotrequired => 0,
                                            flagsrequired   => {    ui              => 'ANY', 
                                                                    tipo_documento  => 'ANY', 
                                                                    accion          => 'CONSULTA', 
                                                                    entorno         => 'datos_nivel3'},
                                            debug => 1,
        });

    my $ini = $obj->{'ini'} || 0;

    my $nivel3 = C4::AR::Nivel3::getNivel3FromId3($id3);

    if ($nivel3) {
        my $fecha_inicial   = $obj->{'fecha_inicial'};
        my $fecha_final     = $obj->{'fecha_final'};
        my $orden           = $obj->{'orden'} || 'fecha DESC';

        my ($ini,$pageNumber,$cantR)    =   C4::AR::Utilidades::InitPaginador($ini);
        my ($cant_historico,$historico_circulacion) = C4::AR::Nivel3::getHistoricoCirculacion($id3,$ini,$cantR,$fecha_inicial,$fecha_final,$orden);

        $t_params->{'paginador'} = C4::AR::Utilidades::crearPaginador($cant_historico,$cantR, $pageNumber,$obj->{'funcion'},$t_params);
        $t_params->{'nivel3'}                   = $nivel3;
        $t_params->{'fecha_inicial'}            = $fecha_inicial;
        $t_params->{'fecha_final'}              = $fecha_final;
        $t_params->{'historico_circulacion'}    = $historico_circulacion;
        $t_params->{'cant_historico'}           = $cant_historico;
    }

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

    }
}
else {
    my ($template, $session, $t_params) = get_template_and_user({
                                            template_name => "catalogacion/estructura/detalleEjemplar.tmpl",
                                            query => $input,
                                            type => "intranet",
                                            authnotrequired => 0,
                                            flagsrequired   => {    ui => 'ANY', 
                                                                    tipo_documento => 'ANY', 
                                                                    accion => 'CONSULTA', 
                                                                    entorno => 'datos_nivel3'},
                                            debug => 1,
        });

    my $id3     = $input->param('id3');
    my $nivel3  = C4::AR::Nivel3::getNivel3FromId3($id3);

    if ($nivel3) {
        $t_params->{'nivel3'} = $nivel3;
	    if ($nivel3->estaPrestado){
	        my $prestamo = C4::AR::Prestamos::getPrestamoDeId3($nivel3->id);
	        $t_params->{'prestamo'} = $prestamo; 
	        if($prestamo){
	            $t_params->{'socio_prestamo'} = $prestamo->socio;  
	            }
	    }
	    #traemos el socio de la reserva, si es que existe
	    my $socio_reserva               = C4::AR::Reservas::getSocioFromReserva($nivel3->getId3());
	    $t_params->{'socio_reserva'}    = $socio_reserva; 
	    
	    C4::AR::Debug::debug("socio reserva : ".$socio_reserva);

    }    

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}