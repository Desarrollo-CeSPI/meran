#!/usr/bin/perl

use strict;
require Exporter;

use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use C4::Context;
use CGI;
use CGI::Session;

my $query = new CGI;

my ($template, $t_params)= C4::Output::gettemplate("informacion.tmpl", 'intranet');

my $session = CGI::Session->load();
##En este pl, se muestran todos los mensajes al usuario con respecto a la falta de permisos,
#sin destruir la sesion del usuario, permitiendo asi que navegue por donde tiene permisos
$t_params->{'mensaje'}= C4::AR::Mensajes::getMensaje($session->param("codMsg"),'INTRA',[]);



my $socio = C4::AR::Auth::getSessionSocioObject();


$t_params->{'mensaje_class'}= "alert-error";

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
