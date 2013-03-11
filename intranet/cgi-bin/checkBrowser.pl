#!/usr/bin/perl
use strict;
require Exporter;
use C4::AR::Auth;
use CGI;

my $input           = new CGI;
my $acepto_browser  = $input->param('acepto_browser');

my ($template, $session, $t_params)= C4::AR::Auth::get_template_and_user({
									template_name   => "checkBrowser.tmpl",
									query           => $input,
									type            => "intranet",
									authnotrequired => 1,
                                    flagsrequired   => {  ui            => 'ANY', 
                                                        tipo_documento  => 'ANY', 
                                                        accion          => 'CONSULTA', 
                                                        entorno         => 'undefined'},
});

if($acepto_browser){
    # ya acepto en el tmpl, lo seteamos en la session
    $session->param('check_browser_allowed', '1');
    my $url = C4::AR::Utilidades::getUrlPrefix().'/mainpage.pl?token='.$session->param('token');
    C4::AR::Auth::redirectTo($url); 
}

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
