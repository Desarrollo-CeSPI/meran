#!/usr/bin/perl
use strict;
require Exporter;
use CGI;
use C4::AR::Auth;


my $input=new CGI;

my ($template, $session, $t_params)= get_template_and_user({
								template_name => "informacion/error.tmpl",
								query => $input,
								type => "opac",
								authnotrequired => 1,
								flagsrequired => {  ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'undefined'},
			     });



my $session                 = CGI::Session->load();
my $message_error           = "404";

if ($ENV{'REDIRECT_STATUS'}  eq "404") {
    $message_error = C4::AR::Preferencias::getValorPreferencia('404_error_message') || $message_error;
} elsif ($ENV{'REDIRECT_STATUS'}  eq "500") {
    $message_error = C4::AR::Preferencias::getValorPreferencia('500_error_message') || $message_error;
}  

$t_params->{'message_error'}        = $message_error;


C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
