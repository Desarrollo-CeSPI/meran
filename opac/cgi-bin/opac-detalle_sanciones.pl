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
require Exporter;

use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use C4::Date;
use CGI;

my $query = new CGI;

my ($template, $session, $t_params)= get_template_and_user({
                                    template_name   => "opac-main.tmpl",
                                    query           => $query,
                                    type            => "opac",
                                    authnotrequired => 0,
                                    flagsrequired   => {  ui            => 'ANY', 
                                                        tipo_documento  => 'ANY', 
                                                        accion          => 'CONSULTA', 
                                                        entorno         => 'undefined'},
            });

$t_params->{'opac'};

my $nro_socio   = C4::AR::Auth::getSessionNroSocio();
my $sanciones   = C4::AR::Sanciones::tieneSanciones($nro_socio);

#C4::AR::Debug::debug("sancionado : ".$san."-----------------------------");
#C4::AR::Utilidades::printHASH($san);
#my $dateformat  = C4::Date::get_date_format();
#if ($san){
#    if ($san->{'id3'}){
#        my $aux = C4::AR::Nivel1::getNivel1FromId3($san->{'id3'});
#        #FALTA ARMAR EL TIPO DE PRESTAMO, DE DONDE LO SACAMOS???
#        $san->{'description'}.=": ".$aux->getTitulo." (".$aux->getAutor.") ";
#    }
#    $san->{'fecha_final'}       = format_date($san->getFecha_final,$dateformat);
#    $san->{'fecha_comienzo'}    = format_date($san->getFecha_comienzo,$dateformat);
#    $t_params->{'sancion'}      = $san;
#}

if ($sanciones){
	$t_params->{'sanciones'} = $sanciones;
}

$t_params->{'content_title'}    = C4::AR::Filtros::i18n("Sanciones");

$t_params->{'partial_template'} = "opac-detalle_sanciones.inc";
C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);