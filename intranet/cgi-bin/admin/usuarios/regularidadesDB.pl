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
use JSON;

my $input           = new CGI;
my $obj             = $input->param('obj');
my $editing         = $input->param('value') || $input->param('id');
my $editing_esquema = $input->param('edit_esquema') || 0;
my ($template, $session, $t_params);

my $show_template = 1;

my $edit = $input->param('edit');

if($edit){

        ($template, $session, $t_params)  = get_template_and_user({  
                            template_name => "includes/partials/modificar_value.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'CONSULTA', 
                                                entorno => 'permisos', 
                                                tipo_permiso => 'general'},
                            debug => 1,
                        });
    
        my $string_ref = $input->param('id');
        my $value = $input->param('value');
        my $valor = C4::AR::Usuarios::editarRegularidadEsquema($string_ref,$value);


        $t_params->{'value'} = $valor;

        C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}