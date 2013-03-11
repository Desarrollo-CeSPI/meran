#!/usr/bin/perl

use strict;
require Exporter;

use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use C4::Context;
use C4::AR::Preferencias;
use CGI;
use CGI::Session;

my $session                 = CGI::Session->load();
my $message_error           = "404";
my ($template, $t_params)   = C4::Output::gettemplate("informacion/error_html.tmpl", 'intranet');

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
