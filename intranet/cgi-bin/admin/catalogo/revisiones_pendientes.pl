#!/usr/bin/perl
use strict;
use C4::AR::Auth;
use CGI;
use C4::AR::Prestamos;

my $input = new CGI;

my ($template, $session, $t_params) = C4::AR::Auth::get_template_and_user({
									template_name   => "admin/revisiones_pendientes.tmpl",
									query           => $input,
									type            => "intranet",
									authnotrequired => 0,
                                    flagsrequired   => {  ui            => 'ANY', 
                                                        tipo_documento  => 'ANY', 
                                                        accion          => 'ALTA', 
                                                        entorno         => 'undefined'},
});

my $revisiones   = C4::AR::Nivel2::getRevisionesPendientes();
$t_params->{'revisiones'}  = $revisiones;
$t_params->{'cantidad'}   = $revisiones?scalar(@$revisiones):0;

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
