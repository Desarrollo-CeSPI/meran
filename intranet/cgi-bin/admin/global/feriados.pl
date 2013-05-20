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
use C4::Output;
use C4::Context;
use C4::AR::Utilidades;
use Date::Manip;
use C4::Date;
my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user({
                        template_name => "admin/global/feriados.tmpl",
                        query => $input,
                        type => "intranet",
                        authnotrequired => 0,
                        flagsrequired => {  ui => 'ANY', 
                                            tipo_documento => 'ANY', 
                                            accion => 'CONSULTA', 
                                            entorno => 'undefined'},
                        debug => 1,
			    });


my $feriadosh =$input->param('feriadosh');
&saveholidays($feriadosh);

my ($cant,@feriados)=getholidays();
my @loop_data;

for (my $i=0; $i < $cant; $i++){
	my %row_data;
	my @fecha = split('-',@feriados[$i]);
	$row_data{anio} = $fecha[0];
	$row_data{mes} = $fecha[1] - 1; # Porque en la inicializacion javascript los meses van del 0 al 11
	$row_data{dia} = $fecha[2];
	push(@loop_data, \%row_data);
}

$t_params->{'loop'}= \@loop_data;
$t_params->{'cant'}= $cant;

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);