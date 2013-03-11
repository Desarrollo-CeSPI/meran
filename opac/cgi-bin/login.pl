#!/usr/bin/perl
use strict;
require Exporter;

use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use CGI;

my $query = new CGI;

my ($template, $t_params)= C4::Output::gettemplate("opac-main.tmpl", 'opac');

$t_params->{'opac'};
my ($session)= C4::AR::Auth::inicializarAuth($t_params);

$t_params->{'partial_template'}= "opac-login.inc";
# $t_params->{'content_title'} = C4::AR::Filtros::i18n("Ingresar");
C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
