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

use CGI;
use C4::AR::VisualizacionOpac;

my $input = new CGI;

my $mensajeError = $input->param('mensajeError')||"";

my ($template, $nro_socio, $cookie)= get_template_and_user({
                    template_name => "catalogacion/kohaToMARC.tmpl",
			        query => $input,
			        type => "intranet",
			        authnotrequired => 0,
			        flagsrequired => {  ui => 'ANY', 
                                        tipo_documento => 'ANY', 
                                        accion => 'CONSULTA', 
                                        entorno => 'undefined'},
			        debug => 1,
			 });


 my @tablas = ['biblio','biblioitems','items','bibliosubject','bibliosubtitle','additionalauthors','publisher','isbns', 'nivel1', 'nivel2', 'nivel3'];


 my $selectTablasKoha=CGI::scrolling_list(  	-name      => 'tablasKoha',
 						-id	   => 'tablasKoha',
						-values    => @tablas,
                                		-size      => 1,
						-onChange  => 'SelectTablasKohaChange()',
                                  	);


$template->param(
 			tablasKoha  => $selectTablasKoha,
			mensajeError => $mensajeError,
);

output_html_with_http_headers $cookie, $template->output;