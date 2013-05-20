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

use C4::AR::Busquedas;

my $input=new CGI;

my ($template, $session, $t_params) = get_template_and_user({
								template_name => "opac-MARCdetail.tmpl",
								query => $input,
								type => "opac",
								authnotrequired => 1,
								flagsrequired => {  ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'undefined'},
                        });

my $obj=C4::AR::Utilidades::from_json_ISO($input->param('obj'));
my $idNivel3=$obj->{'id3'};

my $MARCDetail_array = C4::AR::Busquedas::MARCDetail($idNivel3,'opac');
my $marc_record	= C4::AR::Busquedas::MARCRecordById3WithReferences($idNivel3);

$t_params->{'MARCDetail_array'}= $MARCDetail_array;
$t_params->{'detalle_marc'}= $marc_record->as_formatted;


C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);