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
use C4::AR::Novedades;
my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user({
									template_name   => "admin/portada_opac.tmpl",
									query           => $input,
									type            => "intranet",
									authnotrequired => 0,
									flagsrequired   => {  ui => 'ANY', 
                                                        accion => 'TODOS', 
                                                        entorno => 'usuarios'},
									debug => 1,
			    });


my $obj         = $input->param('obj');

my $editing     = 0;
 
if ($obj){
	$obj=C4::AR::Utilidades::from_json_ISO($obj);
}else{
    $obj = $input->Vars; 
}


my $accion      = $obj->{'tipoAccion'} || undef;

if ($accion){
    if ($accion eq "ADD"){
        my $msg_object = C4::AR::Novedades::addPortadaOpac($obj,$input->upload('imagen'));
        my $codMsg = C4::AR::Mensajes::getFirstCodeError($msg_object);
        
        $t_params->{'mensaje'} = C4::AR::Mensajes::getMensaje($codMsg,'INTRA');
        if (C4::AR::Mensajes::hayError($msg_object)){
            $t_params->{'mensaje_class'} = "alert-error";
        }else{
            $t_params->{'mensaje_class'} = "alert-success";
        }
    }elsif ($accion eq "DEL"){
        my $msg_object = C4::AR::Novedades::delPortadaOpac($obj->{'id_portada'});

        my $codMsg = C4::AR::Mensajes::getFirstCodeError($msg_object);
        
        $t_params->{'mensaje'} = C4::AR::Mensajes::getMensaje($codMsg,'INTRA');
        if (C4::AR::Mensajes::hayError($msg_object)){
            $t_params->{'mensaje_class'} = "alert-error";
        }else{
            $t_params->{'mensaje_class'} = "alert-success";
        }
    }elsif ($accion eq "SHOW_MOD_PORTADA"){

        my $portada = C4::AR::Novedades::getPortadaOpacById($obj->{'id_portada'});
        
        $editing = 1;

		my ($template, $session, $t_params) = get_template_and_user({
		                                    template_name   => "includes/form_portada_opac.inc",
		                                    query           => $input,
		                                    type            => "intranet",
		                                    authnotrequired => 0,
		                                    flagsrequired   => {  ui => 'ANY', 
		                                                        accion => 'TODOS', 
		                                                        entorno => 'usuarios'},
		                                    debug => 1,
		                });
		
		$t_params->{'editing'} = $editing;
        $t_params->{'portada'} = $portada;

	    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

    }elsif ($accion eq "SHOW_ADD_PORTADA"){


        my ($template, $session, $t_params) = get_template_and_user({
                                            template_name   => "includes/form_portada_opac.inc",
                                            query           => $input,
                                            type            => "intranet",
                                            authnotrequired => 0,
                                            flagsrequired   => {  ui => 'ANY', 
                                                                accion => 'TODOS', 
                                                                entorno => 'usuarios'},
                                            debug => 1,
                        });
        
        C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

    }elsif ($accion eq "MOD"){
        my $msg_object = C4::AR::Novedades::modPortadaOpac($obj);

        my $codMsg = C4::AR::Mensajes::getFirstCodeError($msg_object);
        
        $t_params->{'mensaje'} = C4::AR::Mensajes::getMensaje($codMsg,'INTRA');
        if (C4::AR::Mensajes::hayError($msg_object)){
            $t_params->{'mensaje_class'} = "alert-error";
        }else{
            $t_params->{'mensaje_class'} = "alert-success";
        }
    
    }elsif ($accion eq "ORDEN"){
        my $msg_object = C4::AR::Novedades::ordenPortadaOpac($obj);
    }    
}

if (!$editing){
	my $portada            = C4::AR::Novedades::getPortadaOpac();
    $t_params->{'portada'} = $portada;
    $t_params->{'cantidad'} = scalar(@$portada);
	C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}