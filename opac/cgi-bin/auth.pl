#!/usr/bin/perl
use strict;
require Exporter;

use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use CGI;

my $query = new CGI;


my ($template, $t_params)= C4::Output::gettemplate("opac-main.tmpl", 'opac',1);

$t_params->{'type'}='opac';

my $session = CGI::Session->load() || CGI::Session->new();
$t_params->{'username_input'}       = $session->param('username_input');

my $codMensaje = $session->param('codMsg') || $session->param('codMSG') || 0;


my ($session) = C4::AR::Auth::inicializarAuth($t_params);

$t_params->{'partial_template'}= "opac-login.inc";

my $sessionClose = $t_params->{'sessionClose'} = $query->param('sessionClose') || 0;


$t_params->{'mostrar_captcha'}      = $query->param('mostrarCaptcha') || 0;
my $fail                            = $t_params->{'loginFailed'}          =  $query->param('loginFailed')|| 0;
$t_params->{'loginAttempt'}         = $query->param('loginAttempt') || 0;
$t_params->{'mostrar_fondo_home'}   = 1;

if ($t_params->{'loginAttempt'} & !($t_params->{'mostrar_captcha'}) ){
  $t_params->{'mensaje'}    = C4::AR::Mensajes::getMensaje('U310','opac');
}

$t_params->{'mensaje'} = C4::AR::Mensajes::getMensaje($codMensaje,'OPAC'); 

if ($t_params->{'sessionClose'}){ 
  $t_params->{'mensaje'} = C4::AR::Mensajes::getMensaje('U358','opac');
}
if ($fail){
    $t_params->{'class_mensaje'} = "alert-error";	
}

$t_params->{'re_captcha_public_key'} = C4::AR::Preferencias::getValorPreferencia('re_captcha_public_key');


C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
