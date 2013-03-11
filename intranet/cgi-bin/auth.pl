#!/usr/bin/perl

use strict;

use C4::AR::Auth;
use CGI;
use CGI::Session;

my $cgi = new CGI;

my ($template, $t_params)   = C4::Output::gettemplate("auth.tmpl", 'intranet');

my $session                 = CGI::Session->load() || CGI::Session->new();

if ($session->param('codMsg')){
  $t_params->{'mensaje'}    = C4::AR::Mensajes::getMensaje($session->param('codMsg'),'intranet');
}

my ($session) = C4::AR::Auth::inicializarAuth($t_params);

$t_params->{'sessionClose'} = $cgi->param('sessionClose') || 0;

if ($t_params->{'sessionClose'}){
  $t_params->{'mensaje'}    = C4::AR::Mensajes::getMensaje('U358','intranet');
}

$t_params->{'loginAttempt'} = $cgi->param('loginAttempt') || 0;

$t_params->{'mostrar_captcha'} = $cgi->param('mostrarCaptcha') || 0;

if ($t_params->{'loginAttempt'} & !($t_params->{'mostrar_captcha'}) ){
  $t_params->{'mensaje'}    = C4::AR::Mensajes::getMensaje('U357','intranet');
}

$t_params->{'re_captcha_public_key'} = C4::AR::Preferencias::getValorPreferencia('re_captcha_public_key');

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
