#!/usr/bin/perl
use strict;
require Exporter;

use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use CGI;

my $query = new CGI;
my $params = $query->Vars;

my ($template, $t_params)= C4::Output::gettemplate("opac-main.tmpl", 'opac',1);

$t_params->{'type'}='opac';

my $key = $t_params->{'key'} = $params->{"key"};

my $recaptcha_challenge_field = $t_params->{'recaptcha_challenge_field'} = $query->param("key");
my $recaptcha_response_field = $t_params->{'recaptcha_response_field'} = $query->param("key");

my ($session) = C4::AR::Auth::inicializarAuth($t_params);

my ($validLink) = C4::AR::Auth::checkRecoverLink($key);

if ($validLink){
    if ($query->param("new_password1") && $query->param("new_password2")){
    	$t_params->{'message'} = C4::AR::Auth::changePasswordFromRecover($params);
        $t_params->{'partial_template'}= "_message.inc";
    }else{
	   $t_params->{'partial_template'}     = "opac-change-password-recovery.inc";
    }
}else{
    $t_params->{'partial_template'}= "_message.inc";
    $t_params->{'message'} = C4::AR::Mensajes::getMensaje('U602','opac');;
	
}
C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
