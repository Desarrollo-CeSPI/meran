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
use C4::AR::ImportacionIsoMARC;

my $input           = new CGI;
my $obj             = $input->param('obj');
my $editing         = $input->param('value') || $input->param('id');
my $editing_esquema = $input->param('edit_esquema') || 0;
my ($template, $session, $t_params);

my $show_template = 1;

if (!$editing){
	$obj=C4::AR::Utilidades::from_json_ISO($obj);
	my $tipoAccion  = $obj->{'accion'}||""; 
	
	if($tipoAccion eq "OBTENER_ESQUEMA"){
	
	
		($template, $session, $t_params)  = get_template_and_user({  
		                    template_name => "herramientas/importacion/detalle_esquema.tmpl",
		                    query => $input,
		                    type => "intranet",
		                    authnotrequired => 0,
		                    flagsrequired => {  ui => 'ANY', 
		                                        tipo_documento => 'ANY', 
		                                        accion => 'MODIFICACION', 
		                                        entorno => 'permisos', 
		                                        tipo_permiso => 'general'},
		                    debug => 1,
		                });
	
	    my $id_esquema = $obj->{'esquema'} || 0;

        my $ini             = $obj->{'ini'};   
	    my ($ini,$pageNumber,$cantR)= C4::AR::Utilidades::InitPaginador($ini);
	    
	    $t_params->{'ini'}          = $obj->{'ini'} = $ini;
	    $t_params->{'cantR'}        = $obj->{'cantR'} = $cantR;
	    
	    my $campo_search            = $obj->{'filtro'};
	    my ($detalle_esquema,$esquema,$cantidad_total)  = C4::AR::ImportacionIsoMARC::getEsquema($id_esquema,$campo_search,$ini,$cantR);

	    C4::AR::Debug::debug("ESQUEMA EN DETALLE: ".$esquema);
        $t_params->{'esquema'} = $detalle_esquema;
        if ($esquema){
	        $t_params->{'info_esquema'} = $esquema;
	        $t_params->{'esquema_title'} = $esquema->getNombre;
        }
        $t_params->{'id_esquema'}   = $id_esquema;
        $t_params->{'cantidad'}     = $cantidad_total;
        $t_params->{'paginador'}          = C4::AR::Utilidades::crearPaginador($cantidad_total,$cantR, $pageNumber,$obj->{'funcion'},$t_params);
        
	}
    elsif($tipoAccion eq "AGREGAR_CAMPO"){ #DELETE WHEN AGREGAR_CAMPO_A_ESQUEMA completed
              ($template, $session, $t_params)  = get_template_and_user({  
                            template_name => "herramientas/importacion/detalle_esquema.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'MODIFICACION', 
                                                entorno => 'permisos', 
                                                tipo_permiso => 'general'},
                            debug => 1,
                        });
    
        my $id_esquema = $obj->{'esquema'} || 0;
        
        my ($row,$msg_code) = C4::AR::ImportacionIsoMARC::addCampo($id_esquema);
        
        if ($msg_code){
            my $esquema_added = "ZZZ\$z > ZZZ\$z";
            my @params_mensaje = ();
            
            push (@params_mensaje,($esquema_added));
            
            $t_params->{'table_error_message'} = C4::AR::Mensajes::getMensaje($msg_code,'INTRA',\@params_mensaje);
        }
        my ($detalle_esquema,$esquema)  = C4::AR::ImportacionIsoMARC::getEsquema($id_esquema);
        
        $t_params->{'esquema'} = $detalle_esquema;
        $t_params->{'info_esquema'} = $esquema;
        $t_params->{'esquema_title'} = $esquema->getNombre;
        $t_params->{'id_esquema'} = $id_esquema;
        
    }elsif($tipoAccion eq "ELIMINAR_CAMPO"){
              ($template, $session, $t_params)  = get_template_and_user({  
                            template_name => "herramientas/importacion/detalle_esquema.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'MODIFICACION', 
                                                entorno => 'permisos', 
                                                tipo_permiso => 'general'},
                            debug => 1,
                        });
    
        my $id_row = $obj->{'id_row'} || 0;
        
        my ($id_esquema,$msg_code) = C4::AR::ImportacionIsoMARC::delCampo($id_row);
        
        if ($msg_code){
            $t_params->{'table_error_message'} = C4::AR::Mensajes::getMensaje($msg_code,'INTRA');
        }
        my ($detalle_esquema,$esquema)  = C4::AR::ImportacionIsoMARC::getEsquema($id_esquema);
        
        $t_params->{'esquema'} = $detalle_esquema;
        $t_params->{'info_esquema'} = $esquema;
        $t_params->{'esquema_title'} = $esquema->getNombre;
        $t_params->{'id_esquema'} = $id_esquema;
        
    }elsif($tipoAccion eq "ELIMINAR_CAMPO_ONE"){
              ($template, $session, $t_params)  = get_template_and_user({  
                            template_name => "herramientas/importacion/detalle_esquema.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'MODIFICACION', 
                                                entorno => 'permisos', 
                                                tipo_permiso => 'general'},
                            debug => 1,
                        });
    
        my $id_row = $obj->{'id_row'} || 0;
        
        my ($id_esquema,$msg_code) = C4::AR::ImportacionIsoMARC::delCampoOne($id_row);
        
        if ($msg_code){
            $t_params->{'table_error_message'} = C4::AR::Mensajes::getMensaje($msg_code,'INTRA');
        }
        my ($detalle_esquema,$esquema)  = C4::AR::ImportacionIsoMARC::getEsquema($id_esquema);
        
        $t_params->{'esquema'} = $detalle_esquema;
        $t_params->{'info_esquema'} = $esquema;
        $t_params->{'esquema_title'} = $esquema->getNombre;
        $t_params->{'id_esquema'} = $id_esquema;
        
    }
    elsif($tipoAccion eq "NUEVO_ESQUEMA"){
              ($template, $session, $t_params)  = get_template_and_user({  
                            template_name => "herramientas/importacion/detalle_esquema.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'MODIFICACION', 
                                                entorno => 'permisos', 
                                                tipo_permiso => 'general'},
                            debug => 1,
                        });
    
        my $title       = $obj->{'esquema_title'};
        my $descripcion = C4::AR::Filtros::i18n("Desc. del esquema");
        
        my ($esquema_new,$msg_code) = C4::AR::ImportacionIsoMARC::addEsquema($title,$descripcion);
        
        if ($msg_code){
            $t_params->{'table_error_message'} = C4::AR::Mensajes::getMensaje($msg_code,'INTRA');
        }

        my ($detalle_esquema,$esquema)  = C4::AR::ImportacionIsoMARC::getEsquema($esquema_new->getId);
        
        $t_params->{'esquema'} = $detalle_esquema;
        $t_params->{'info_esquema'} = $esquema;
        $t_params->{'esquema_title'} = $esquema->getNombre;
        $t_params->{'id_esquema'} = $esquema->getId;
    }
    elsif($tipoAccion eq "ELIMINAR_ESQUEMA"){
              ($template, $session, $t_params)  = get_template_and_user({  
                            template_name => "herramientas/importacion/detalle_esquema.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'MODIFICACION', 
                                                entorno => 'permisos', 
                                                tipo_permiso => 'general'},
                            debug => 1,
                        });
    
        my $id_esquema          = $obj->{'id_esquema'};
        my ($msg_code) = C4::AR::ImportacionIsoMARC::delEsquema($id_esquema);
        
        if ($msg_code){
            $t_params->{'table_error_message_esquema'} = C4::AR::Mensajes::getMensaje($msg_code,'INTRA');
        }

    }elsif($tipoAccion eq "MOSTRAR_AGREGAR_CAMPO_A_ESQUEMA"){
              ($template, $session, $t_params)  = get_template_and_user({  
                            template_name => "herramientas/importacion/add_campo_esquema.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'MODIFICACION', 
                                                entorno => 'permisos', 
                                                tipo_permiso => 'general'},
                            debug => 1,
                        });
            $t_params->{'selectCampoX'} = C4::AR::Utilidades::generarComboCampoX('eleccionCampoX()');                       
            $t_params->{'id_esquema'}   = $obj->{'esquema'};                       

    }elsif($tipoAccion eq "AGREGAR_CAMPO_A_ESQUEMA"){
              ($template, $session, $t_params)  = get_template_and_user({  
                            template_name => "herramientas/importacion/add_campo_esquema.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'MODIFICACION', 
                                                entorno => 'permisos', 
                                                tipo_permiso => 'general'},
                            debug => 1,
                        });

            my ($Message_arrayref) = C4::AR::ImportacionIsoMARC::addCampoAEsquema($obj);     

            $show_template  = 0;
            my $infoOperacionJSON=to_json $Message_arrayref;

            C4::AR::Auth::print_header($session);
            print $infoOperacionJSON;
                             
    }elsif($tipoAccion eq "MOSTRAR_TABLA_ORDEN_ESQUEMA"){
              ($template, $session, $t_params)  = get_template_and_user({  
                            template_name => "herramientas/importacion/orden_esquema_campos.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'MODIFICACION', 
                                                entorno => 'permisos', 
                                                tipo_permiso => 'general'},
                            debug => 1,
                        });

            eval{
	            my ($esquema,$row) = C4::AR::ImportacionIsoMARC::getOrdenEsquema($obj);
	            
	            $t_params->{'esquema'} = $esquema;
	            $t_params->{'esquema_padre'} = $row;
            };
                           

    }elsif($tipoAccion eq "ACTUALIZAR_ORDEN_ESQUEMA"){
              ($template, $session, $t_params)  = get_template_and_user({  
                            template_name => "herramientas/importacion/orden_esquema_campos.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'MODIFICACION', 
                                                entorno => 'permisos', 
                                                tipo_permiso => 'general'},
                            debug => 1,
                        });
                        
        my $info = C4::AR::ImportacionIsoMARC::updateNewOrder($obj);                        

    }    
}else{
	
	my $valor;
	
	if ($editing_esquema){
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
        
        $valor = C4::AR::ImportacionIsoMARC::editarEsquema($string_ref,$value);
		
	}else{
		
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
	    
	    $valor = C4::AR::ImportacionIsoMARC::editarValorEsquema($string_ref,$value);
	
	}	

    $t_params->{'value'} = $valor;
}

if ($show_template){
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}