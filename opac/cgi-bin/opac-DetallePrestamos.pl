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
use CGI;
use C4::AR::Auth;
use C4::Date;
use C4::AR::Reservas; 
use Date::Manip;

my $input = new CGI;

my ($template, $session, $t_params)= get_template_and_user({
								template_name   => "opac-DetallePrestamos.tmpl",
								query           => $input,
								type            => "opac",
								authnotrequired => 0,
								flagsrequired   => {  ui            => 'ANY', 
                                                    tipo_documento  => 'ANY', 
                                                    accion          => 'CONSULTA', 
                                                    entorno         => 'undefined'},
								debug => 1,
			     });

my $ini                             = $input->param('page') || 0;
my $orden                           = 'titulo';
my $url                             = C4::AR::Utilidades::getUrlPrefix()."/opac-prestamos_vigentes.pl?token=".$input->param('token');
my $nro_socio                       = C4::AR::Auth::getSessionNroSocio($session);
my ($ini,$pageNumber,$cantR)        = C4::AR::Utilidades::InitPaginador($ini);
my ($cantidad,$prestamos)           = C4::AR::Prestamos::getHistorialPrestamosVigentesParaTemplate($nro_socio,$ini,$cantR,$orden);

$t_params->{'paginador'}            = C4::AR::Utilidades::crearPaginadorOPAC($cantidad, $cantR, $pageNumber,$url,$t_params);
$t_params->{'prestamos'}            = $prestamos;
$t_params->{'cantidad_prestamos'}   = $cantidad;
$t_params->{'content_title'}        = C4::AR::Filtros::i18n("Pr&eacute;stamos Vigentes");
$t_params->{'partial_template'}     = "opac-prestamos_vigentes.inc";

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);