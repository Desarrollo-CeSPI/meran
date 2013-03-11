#!/usr/bin/perl
use strict;
use CGI;
use C4::AR::Auth;



my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user ({
                                        template_name   => 'z3950/filtradoZ3950.tmpl',
                                        query       => $input,
                                        type        => "intranet",
                                        authnotrequired => 0,
                                        flagsrequired => {  ui => 'ANY', 
                                                            tipo_documento => 'ANY', 
                                                            accion => 'CONSULTA', 
                                                            entorno => 'undefined'},
                                        debug => 1,
                 });

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
