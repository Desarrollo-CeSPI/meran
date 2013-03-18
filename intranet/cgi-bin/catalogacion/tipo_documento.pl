#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use CGI;
use C4::AR::TipoDocumento;

my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user({
									template_name       => "catalogacion/tipoDocumento.tmpl",
									query               => $input,
									type                => "intranet",
									authnotrequired     => 0,
									flagsrequired       => {    ui              => 'ANY', 
                                                                tipo_documento  => 'ANY', 
                                                                accion          => 'CONSULTA', 
                                                                entorno         => 'usuarios'},
									debug               => 1,
			    });

#si estamos modificando un tipo de doc, viene el post por aca
my $obj = $input->Vars; 

if($obj->{'tipoAccion'} eq "MOD"){

	my $msg_object 	= C4::AR::TipoDocumento::modTipoDocumento($obj,$input->upload('imagen'));

	my $codMsg 		= C4::AR::Mensajes::getFirstCodeError($msg_object);
        
    $t_params->{'mensaje'} = C4::AR::Mensajes::getMensaje($codMsg,'INTRA');

    if (C4::AR::Mensajes::hayError($msg_object)){
        $t_params->{'mensaje_class'} = "alert-error";
    }else{
        $t_params->{'mensaje_class'} = "alert-success";
    }

}elsif($obj->{'tipoAccion'} eq "ADD"){

	my $msg_object 	= C4::AR::TipoDocumento::agregarTipoDocumento($obj,$input->upload('imagen'));

	my $codMsg 		= C4::AR::Mensajes::getFirstCodeError($msg_object);
        
    $t_params->{'mensaje'} = C4::AR::Mensajes::getMensaje($codMsg,'INTRA');

    if (C4::AR::Mensajes::hayError($msg_object)){
        $t_params->{'mensaje_class'} = "alert-error";
    }else{
        $t_params->{'mensaje_class'} = "alert-success";
    }

}

$t_params->{'page_sub_title'}   = C4::AR::Filtros::i18n("Tipo de documento");

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);