#!/usr/bin/perl
use strict;
require Exporter;
use CGI;
use C4::AR::Auth;         # checkauth, getnro_socio.

use C4::Date;

my $query = new CGI;

my $input = $query;

my ($template, $session, $t_params)= get_template_and_user({
                                    template_name => "opac-main.tmpl",
                                    query => $query,
                                    type => "opac",
                                    authnotrequired => 0,
                                    flagsrequired => {  ui => 'ANY', 
                                                        tipo_documento => 'ANY', 
                                                        accion => 'CONSULTA', 
                                                        entorno => 'undefined'},
             });


$t_params->{'partial_template'}= "opac-favoritos.inc";
$t_params->{'content_title'}= C4::AR::Filtros::i18n("Mis favoritos");

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

1;
