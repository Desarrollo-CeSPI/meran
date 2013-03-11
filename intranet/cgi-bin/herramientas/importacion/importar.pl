#!/usr/bin/perl
use strict;
require Exporter;

use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use CGI;


my $query = new CGI;

my ($template, $session, $t_params)= get_template_and_user({
                                    template_name => "/herramientas/importacion/importaciones.tmpl",
                                    query => $query,
                                    type => "intranet",
                                    authnotrequired => 0,
                                    flagsrequired => {  ui => 'ANY',
                                                        tipo_documento => 'ANY',
                                                        accion => 'CONSULTA',
                                                        entorno => 'undefined'},
                                    debug => 1,
            });

$t_params->{'page_sub_title'} = C4::AR::Filtros::i18n("Importaciones");

C4::AR::Auth::output_html_with_http_headers($template, $t_params,$session);
