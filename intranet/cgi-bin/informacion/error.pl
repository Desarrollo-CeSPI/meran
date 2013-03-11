#!/usr/bin/perl

use strict;
require Exporter;

use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use C4::AR::Preferencias;
use CGI;
use CGI::Session;

#eval{
	my $query = new CGI;

	my ($template, $t_params)   = C4::Output::gettemplate("informacion/error.tmpl", 'intranet');

	my $session                 = CGI::Session->load();
	my $message_error           = "404";

	if ($ENV{'REDIRECT_STATUS'}  eq "404") {
	    $message_error = C4::AR::Preferencias::getValorPreferencia('404_error_message') || $message_error;
	} elsif ($ENV{'REDIRECT_STATUS'}  eq "500") {
	    $message_error = C4::AR::Preferencias::getValorPreferencia('500_error_message') || $message_error;
	}  

	$t_params->{'message_error'}      = $message_error;

	C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
# } or do{	
# 	my $session                 = CGI::Session->load();
# 	my $message_error           = "404";
# 	my ($template, $t_params)   = C4::Output::gettemplate("informacion/error_html.tmpl", 'intranet');

# 	C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
# }	