#!/usr/bin/perl
use strict;
require Exporter;
use C4::AR::Auth;
use CGI;
use C4::AR::MensajesContacto;

my $query = new CGI;

my ($template, $session, $t_params)= C4::AR::Auth::get_template_and_user({
									template_name   => "mensajes_contacto.tmpl",
									query           => $query,
									type            => "intranet",
									authnotrequired => 0,
                                    flagsrequired   => {  ui            => 'ANY', 
                                                        tipo_documento  => 'ANY', 
                                                        accion          => 'TODOS', 
                                                        entorno         => 'undefined'},
});

my ($msjNoLeidos, $cant)            = C4::AR::MensajesContacto::noLeidos();
my ($ultimos_no_leidos)             = C4::AR::MensajesContacto::ultimosNoLeidos($msjNoLeidos);

$t_params->{'ultimos_no_leidos'}    = $ultimos_no_leidos;
$t_params->{'cant_noleidos'}        = $cant;

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
