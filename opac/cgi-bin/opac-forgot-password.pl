#!/usr/bin/perl
use strict;
require Exporter;

use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use CGI;

my $query = new CGI;
my $params = $query->Vars;

my ($template, $t_params)= C4::Output::gettemplate("opac-main.tmpl", 'opac',1);

$t_params->{'partial_template'}= "opac-forgot-password.inc";
$t_params->{'type'}='opac';

my $user_id = $t_params->{'user-id'} = $query->param("user-id");

my ($session) = C4::AR::Auth::inicializarAuth($t_params);

if (!C4::AR::Utilidades::validateString($user_id)){
	
	$t_params->{'sessionClose'} = $query->param('sessionClose') || 0;
	
	if ($t_params->{'sessionClose'}){
	  $t_params->{'mensaje'} = C4::AR::Mensajes::getMensaje('U358','intranet');
	}
	
	$t_params->{'loginAttempt'} = $query->param('loginAttempt') || 0;
	
	if ($t_params->{'loginAttempt'}){
	  $t_params->{'mensaje'} = C4::AR::Mensajes::getMensaje('U357','intranet');
	}
	
	if ($session->param('codMsg')){
	  $t_params->{'mensaje'} = C4::AR::Mensajes::getMensaje($session->param('codMsg'),'opac');
	}
	
}else{

	my ($error, $msg);
	eval{
		($error, $msg) = C4::AR::Auth::recoverPassword($params);
		$t_params->{'message'} = $msg;
	};
	
	if ($@){	
		my $mensaje = $t_params->{'message'}  = C4::AR::Mensajes::getMensaje('U606','opac');
		C4::AR::Mensajes::printErrorDB($@, 'U606',"opac");
	}elsif
		(!$error){
		  $t_params->{'partial_template'}= "_message.inc";
	}
}

$t_params->{'re_captcha_public_key'} = C4::AR::Preferencias::getValorPreferencia('re_captcha_public_key');

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
