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
use C4::AR::Auth;
use CGI;

my $input = new CGI;

my ($template, $session, $t_params)= C4::AR::Auth::get_template_and_user({
									template_name   => "reports/usuarios.tmpl",
									query           => $input,
									type            => "intranet",
									authnotrequired => 0,
                                    flagsrequired   => {  ui            => 'ANY', 
                                                        tipo_documento  => 'ANY', 
                                                        accion          => 'CONSULTA', 
                                                        entorno         => 'undefined'},
});


     my  $ui= $input->param('ui_name') || C4::AR::Preferencias::getValorPreferencia("defaultUI");
     my $ComboUI=C4::AR::Utilidades::generarComboUI();
     my %params;
 
     $params{'default'}= 'SIN SELECCIONAR';
     my $comboCategoriasDeSocio= C4::AR::Utilidades::generarComboCategoriasDeSocio(\%params);

  
     $t_params->{'unidades'}= $ComboUI;
     $t_params->{'categories'}= $comboCategoriasDeSocio;

     $t_params->{'regulares'} = C4::AR::Utilidades::generarComboDeEstados();


C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);