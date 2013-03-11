#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use CGI;
use C4::AR::Logos;

my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user({
									template_name   => "admin/logos.tmpl",
									query           => $input,
									type            => "intranet",
									authnotrequired => 0,
									flagsrequired   => {  ui            => 'ANY', 
                                                        tipo_documento  => 'ANY', 
                                                        accion          => 'CONSULTA', 
                                                        entorno         => 'usuarios'},
									debug           => 1,
			    });
			    
my $obj        = $input->Vars; 

my $accion  = $obj->{'tipoAccion'} || undef;	

if ($accion) {

    if ($accion eq "ADD") {	
        
        my $msg_object          = C4::AR::Logos::agregarLogo($obj,$input->upload('imagen'));
        my $codMsg              = C4::AR::Mensajes::getFirstCodeError($msg_object);
        
        $t_params->{'mensaje'}  = C4::AR::Mensajes::getMensaje($codMsg,'INTRA');
        
        if (C4::AR::Mensajes::hayError($msg_object)){
            $t_params->{'mensaje_class'} = "alert-error";
        }else{
            $t_params->{'mensaje_class'} = "alert-success";
        }
    
    } elsif ($accion eq "MOD") {

        my $msg_object          = C4::AR::Logos::modificarLogo($obj);
        my $codMsg              = C4::AR::Mensajes::getFirstCodeError($msg_object);
        
        $t_params->{'mensaje'}  = C4::AR::Mensajes::getMensaje($codMsg,'INTRA');
        
        if (C4::AR::Mensajes::hayError($msg_object)){
            $t_params->{'mensaje_class'} = "alert-error";
        }else{
            $t_params->{'mensaje_class'} = "alert-success";
        }

    } elsif ($accion eq "ADD_UI") {   
        
        my $msg_object          = C4::AR::Logos::agregarLogoUI($obj,$input->upload('imagen'));
        my $codMsg              = C4::AR::Mensajes::getFirstCodeError($msg_object);
        
        $t_params->{'mensaje'}  = C4::AR::Mensajes::getMensaje($codMsg,'INTRA');
        
        if (C4::AR::Mensajes::hayError($msg_object)){
            $t_params->{'mensaje_class'} = "alert-error";
        }else{
            $t_params->{'mensaje_class'} = "alert-success";
        }
    
    } elsif ($accion eq "MOD_UI") {

        my $msg_object          = C4::AR::Logos::modificarLogoUI($obj);
        my $codMsg              = C4::AR::Mensajes::getFirstCodeError($msg_object);
        
        $t_params->{'mensaje'}  = C4::AR::Mensajes::getMensaje($codMsg,'INTRA');
        
        if (C4::AR::Mensajes::hayError($msg_object)){
            $t_params->{'mensaje_class'} = "alert-error";
        }else{
            $t_params->{'mensaje_class'} = "alert-success";
        }
    }
    
}	    

$t_params->{'logosPath'}        = C4::Context->config('logosOpacPath');
$t_params->{'page_sub_title'}   = C4::AR::Filtros::i18n("Logos");

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);