#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use JSON;
use CGI;
use CGI::Session;

my $input = new CGI;

my ($template, $session, $t_params)= get_template_and_user({
                                    template_name   => "opac-main.tmpl",
                                    query           => $input,
                                    type            => "opac",
                                    authnotrequired => 0,
                                    change_password => 1, #-> indicamos a checkauth que ya estamos cambiando la password
                                    flagsrequired   => {    ui              => 'ANY', 
                                                            tipo_documento  => 'ANY', 
                                                            accion          => 'CONSULTA', 
                                                            entorno         => 'undefined'},
            });   


my $session                     = CGI::Session->load();
my ($template, $t_params)       = C4::Output::gettemplate("opac-main.tmpl", 'opac');

$t_params->{'mensaje'}          = C4::AR::Mensajes::getMensaje($session->param("codMsg"),'OPAC',[]);
$t_params->{'nro_socio'}        = C4::AR::Auth::getSessionNroSocio();
$t_params->{'partial_template'} = "opac-change-password.inc";
$t_params->{'noAjaxRequests'}   = 1;
$t_params->{'nroRandom'}        = C4::AR::Auth::getSessionNroRandom();

#preferencias para generar nueva password
$t_params->{'minPassLength'}            = C4::AR::Preferencias::getValorPreferencia('minPassLength');
$t_params->{'minPassSymbol'}            = C4::AR::Preferencias::getValorPreferencia('minPassSymbol');
$t_params->{'minPassAlpha'}             = C4::AR::Preferencias::getValorPreferencia('minPassAlpha');
$t_params->{'minPassNumeric'}           = C4::AR::Preferencias::getValorPreferencia('minPassNumeric');

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);