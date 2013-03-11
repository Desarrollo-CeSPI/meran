#!/usr/bin/perl
use strict;
require Exporter;

use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use CGI;

my $query = new CGI;

my ($template, $session, $t_params)= get_template_and_user({
                                    template_name => "includes/opac-sanciones_info.inc",
                                    query => $query,
                                    type => "opac",
                                    authnotrequired => 0,
                                    flagsrequired => {      ui => 'ANY', 
                                                            tipo_documento => 'ANY', 
                                                            accion => 'CONSULTA', 
                                                            entorno => 'undefined'},
            });

# my ($template, $t_params)= C4::Output::gettemplate("opac-main.tmpl", 'opac');
# my ($session) = CGI::Session->load();

# $t_params->{'opac'};

my $nro_socio               = C4::AR::Auth::getSessionNroSocio();
my $sanc                    = C4::AR::Sanciones::estaSancionado($nro_socio);
$t_params->{'sancionado'}   = $sanc;

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
