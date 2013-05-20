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

my $input = new CGI;

my ($template, $session, $t_params)= get_template_and_user({
								template_name => "opac-main.tmpl",
								query => $input,
								type => "opac",
								authnotrequired => 0,
                                flagsrequired => {  ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'undefined'},
								debug => 1,
			});

my $ini                         = $input->param('page') || 0;
my $orden                       = 'id DESC';
my $url                         = C4::AR::Utilidades::getUrlPrefix()."/opac-historial_prestamos.pl?token=".$input->param('token');
my $nro_socio                   = C4::AR::Auth::getSessionNroSocio($session);
my ($ini,$pageNumber,$cantR)    = &C4::AR::Utilidades::InitPaginador($ini);
my ($cantidad,$prestamos)       = C4::AR::Prestamos::getHistorialPrestamosParaTemplate($nro_socio,$ini,$cantR,$orden);

$t_params->{'paginador'}        = C4::AR::Utilidades::crearPaginadorOPAC($cantidad, $cantR, $pageNumber,$url,$t_params);
$t_params->{'prestamos'}        = $prestamos;
$t_params->{'cantidad'}         = $cantidad;
$t_params->{'content_title'}    = C4::AR::Filtros::i18n("Historial de pr&eacute;stamos");
$t_params->{'partial_template'} = "opac-historial_prestamos.inc";

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);