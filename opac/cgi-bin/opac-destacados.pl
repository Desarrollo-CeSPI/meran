#!/usr/bin/perl

use strict;
use CGI;
use C4::Output;
use C4::AR::Auth;
use C4::AR::Nivel2;

my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user ({
                                        template_name   => 'opac-main.tmpl',
                                        query           => $input,
                                        type            => "opac",
                                        authnotrequired => 1,
                                        flagsrequired   => {  ui            => 'ANY', 
                                                            tipo_documento  => 'ANY', 
                                                            accion          => 'CONSULTA', 
                                                            entorno         => 'undefined'},
                                        debug           => 1,
                 });



my ($rating, $promoted, $promoted_count, $count_rating)= C4::AR::Nivel2::getDestacados();

$t_params->{'rating'} = $rating;

$t_params->{'promoted'} = $promoted;
$t_params->{'promoted_count'} = $promoted_count;
$t_params->{'count_rating'} = $count_rating;
$t_params->{'partial_template'}     = "opac-destacados.inc";

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
