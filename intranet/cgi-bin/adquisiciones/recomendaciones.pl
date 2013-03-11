#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use C4::Modelo::AdqRecomendacion;
use CGI;

my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user({
                                    template_name   => "adquisiciones/recomendaciones.tmpl",
                                    query           => $input,
                                    type            => "intranet",
                                    authnotrequired => 0,
                                    flagsrequired   => {    ui => 'ANY', 
                                                            tipo_documento => 'ANY', 
                                                            accion => 'CONSULTA', 
                                                            tipo_permiso => 'general',
                                                            entorno => 'adq_intra'}, # FIXME
                                    debug           => 1,
                });



C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
1;