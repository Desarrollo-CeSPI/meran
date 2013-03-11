#!/usr/bin/perl

use strict;
require Exporter;

use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use C4::Context;
use CGI;

my $query = new CGI;

my ($template, $params)= C4::Output::gettemplate("changepassword.tmpl", 'intranet');


C4::AR::Auth::output_html_with_http_headers($template, $params);


