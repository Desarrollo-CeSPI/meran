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
use C4::AR::Utilidades;
use JSON;

my $input           = new CGI;
my $editing         = $input->param('value') && $input->param('id');
my $authnotrequired = 0;

# esta editando el nombre sin JSON
if($editing){

    my ($template, $session, $t_params)  = get_template_and_user({  
                    template_name => "includes/partials/metodosAuth/modificar_value.tmpl",
                    query => $input,
                    type => "intranet",
                    authnotrequired => 0,
                    flagsrequired => {  ui => 'ANY', 
                                        tipo_documento => 'ANY', 
                                        accion => 'CONSULTA', 
                                        entorno => 'undefined', 
                                        tipo_permiso => 'general'},
                    debug => 1,
     });
                                  
    my $value               = $input->param('value');
    my $idMetodo            = $input->param('id');  
    my $info                = C4::AR::Auth::updateNameMetodo($idMetodo,$value);
    $t_params->{'value'}    = $value;
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

}else{
#JSON comun

    my $obj             = $input->param('obj');
    $obj                = C4::AR::Utilidades::from_json_ISO($obj);
    my $tipoAccion      = $obj->{'tipoAccion'};

    if($tipoAccion eq "ACTUALIZAR_ORDEN"){

        my ($user, $session, $flags)= checkauth(  $input, 
                                                  $authnotrequired, 
                                                  {   ui                => 'ANY', 
                                                      tipo_documento    => 'ANY', 
                                                      accion            => 'CONSULTA', 
                                                      entorno           => 'undefined'}, 
                                                  'intranet'
                                      );
        my $newOrderArray       = $obj->{'newOrderArray'};
        my $info                = C4::AR::Auth::updateAuthOrder($newOrderArray);
        my $infoOperacionJSON   = to_json $info;
        C4::AR::Auth::print_header($session);
        print $infoOperacionJSON;  
    }
    elsif($tipoAccion eq "CHANGE_ENABLE"){

        my ($user, $session, $flags)= checkauth(  $input, 
                                                  $authnotrequired, 
                                                  {   ui                => 'ANY', 
                                                      tipo_documento    => 'ANY', 
                                                      accion            => 'CONSULTA', 
                                                      entorno           => 'undefined'}, 
                                                  'intranet'
                                      );
                                      
        my $newValue            = $obj->{'newValue'};
        my $idMetodo            = $obj->{'idMetodo'};
        my $info                = C4::AR::Auth::changeEnable($newValue,$idMetodo);
        my $infoOperacionJSON   = to_json $info;
        C4::AR::Auth::print_header($session);
        print $infoOperacionJSON;  

    }
    elsif($tipoAccion eq "MOSTRAR_AGREGAR_METODO"){
    
    
        my ($template, $session, $t_params) = get_template_and_user({
	        template_name   => "admin/global/agregar_metodo_auth.tmpl",
	        query           => $input,
	        type            => "intranet",
	        authnotrequired => 0,
	        flagsrequired   => { ui => 'ANY', tipo_documento => 'ANY', accion => 'CONSULTA', entorno => 'undefined'},
	        debug           => 1,
	    });

        C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
    }
    elsif($tipoAccion eq "AGREGAR_METODO"){

        my ($user, $session, $flags)= checkauth(  $input, 
                                                  $authnotrequired, 
                                                  {   ui                => 'ANY', 
                                                      tipo_documento    => 'ANY', 
                                                      accion            => 'CONSULTA', 
                                                      entorno           => 'undefined'}, 
                                                  'intranet'
                                      );
                                      
        my $nameMetodo          = $obj->{'metodo'};
        my $info                = C4::AR::Auth::addMethod($nameMetodo);
        
        my $infoOperacionJSON   = to_json $info;
        C4::AR::Auth::print_header($session);
        print $infoOperacionJSON;  

    }
}