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
use CGI;
use C4::AR::Auth;
use C4::AR::Sanciones;
use JSON;

my $input       = new CGI;
my $obj         = $input->param('obj');
$obj            = C4::AR::Utilidades::from_json_ISO($obj);
my $tipoAccion  = $obj->{'accion'};
my $orden; # usado para el order_by de las consultas
my $sentido_orden;

my ($template, $session, $t_params) =  get_template_and_user ({
            template_name   => 'circ/sancionesResult.tmpl',
            query           => $input,
            type            => "intranet",
            authnotrequired => 0,
            flagsrequired   => {    ui => 'ANY', 
                                    tipo_documento => 'ANY', 
                                    accion => 'CONSULTA', 
                                    entorno => 'circ_sanciones',
                                    tipo_permiso => 'circulacion'},
    });


if($tipoAccion eq "MOSTRAR_SANCIONES"){

    if ($obj->{'orden'} eq "nro_socio"){
        $orden = "nro_socio";   
    } elsif ($obj->{'orden'} eq "apellido"){
        $orden = "persona.apellido";
    } elsif ($obj->{'orden'} eq "fecha_inicio"){
        $orden = "fecha_comienzo";
    } elsif ($obj->{'orden'} eq "legajo"){
        $orden = "persona.legajo";
    } else {
        $orden  = 'persona.apellido';
    }
   
    if ($obj->{'sentido_orden'} == "1"){
        $obj->{'sentido_orden'}= "ASC";
    }else { 
        $obj->{'sentido_orden'}= "DESC";
    }
    
    $orden                  .= " ";
    $orden                  .= $obj->{'sentido_orden'}||"ASC";
    my $ini                         = $obj->{'ini'} || 1;

    my $funcion                     = $obj->{'funcion'};
    my ($ini,$pageNumber,$cantR)    = C4::AR::Utilidades::InitPaginador($ini);   
    my ($cantidad,$sanciones)       = C4::AR::Sanciones::sanciones($orden,$ini,$cantR);
    
    $t_params->{'paginador'}        = C4::AR::Utilidades::crearPaginador($cantidad,$cantR,$pageNumber,$funcion,$t_params);
    $t_params->{'cant'}             = $cantidad;
    $t_params->{'SANCIONES'}        = $sanciones;
    $t_params->{'CANT_SANCIONES'}   = scalar(@$sanciones);
    
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
    
}#end if($tipoAccion eq "MOSTRAR_SANCIONES")

elsif($tipoAccion eq "ELIMINAR_SANCIONES"){

    my $authnotrequired= 0;
    my ($userid, $session, $flags)= checkauth(      $input, 
                                                    $authnotrequired, 
                                                    {   ui              => 'ANY', 
                                                        tipo_documento  => 'ANY', 
                                                        accion          => 'BAJA', 
                                                        entorno         => 'circ_sanciones',
                                                        tipo_permiso => 'circulacion'}, 
                                                        'intranet'
                                    );

    my $sanciones_ids     = $obj->{'datosArray'};
    my $Message_arrayref  = C4::AR::Sanciones::eliminarSanciones($userid,$sanciones_ids);

    my $infoOperacionJSON = to_json $Message_arrayref;
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;

}#end if($tipoAccion eq "ELIMINAR_SANCIONES")

elsif($tipoAccion eq "BUSCAR_SANCIONES"){

    $orden                          = $obj->{'orden'}||'persona.apellido';
    my $ini                         = $obj->{'ini'} || 1;
    my $funcion                     = $obj->{'funcion'};
    my ($ini,$pageNumber,$cantR)    = C4::AR::Utilidades::InitPaginador($ini);   
    my ($cantidad,$sanciones)       = C4::AR::Sanciones::getSancionesLike($obj->{'string'},$ini,$cantR);
    
    $t_params->{'paginador'}        = C4::AR::Utilidades::crearPaginador($cantidad,$cantR,$pageNumber,$funcion,$t_params);
    $t_params->{'cant'}             = $cantidad;
    $t_params->{'SANCIONES'}        = $sanciones;
    $t_params->{'CANT_SANCIONES'}   = scalar(@$sanciones);
    
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
    
} #end if($accion eq "BUSCAR_SANCIONES")