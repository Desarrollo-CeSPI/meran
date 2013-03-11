#!/usr/bin/perl
#script para seleccionar la tabla de referencia que se quiere administrar 
#escrito el 8/9/2006 por einar@info.unlp.edu.ar
#
#Copyright (C) 2003-2006  Linti, Facultad de Inform�tica, UNLP
#This file is part of Koha-UNLP
#
#This program is free software; you can redistribute it and/or
#modify it under the terms of the GNU General Public License
#as published by the Free Software Foundation; either version 2
#of the License, or (at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program; if not, write to the Free Software
#Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.


use strict;
use CGI;
use C4::AR::Auth;

use C4::AR::Utilidades;

my $input = new CGI;
my ($template, $session, $t_params) = C4::AR::Auth::get_template_and_user({
									template_name => "admin/global/refs.tmpl",
									query => $input,
									type => "intranet",
									authnotrequired => 0,
									flagsrequired => {  ui => 'ANY', 
                                                        tipo_documento => 'ANY', 
                                                        accion => 'CONSULTA', 
                                                        entorno => 'undefined'},
									debug => 1,
			    });

my %tablas=buscarTablasdeReferencias;

my $lista_Refs=CGI::scrolling_list(      
					-name      => 'editandotabla',
                                        -values    => \%tablas,
                                        #-labels    => \%paises,
					-size	   => 1,
					-onChange  => 'hacerSubmit()',
                                 );
$t_params->{'lista'}= $lista_Refs;

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

