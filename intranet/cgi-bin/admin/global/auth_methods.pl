#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;
use C4::Output;

my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user({
                        template_name   => "admin/global/authMethods.tmpl",
                        query           => $input,
                        type            => "intranet",
                        authnotrequired => 0,
                        flagsrequired   => {    ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'CONSULTA', 
                                                entorno => 'undefined'},
                        debug           => 1,
			    });

my $metodos_auth                    = C4::AR::Preferencias::getMetodosAuthAll();
$t_params->{'metodos'}              = $metodos_auth;
$t_params->{'page_sub_title'}       = C4::AR::Filtros::i18n("M&eacute;todos de Autenticaci&oacute;n");
C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
