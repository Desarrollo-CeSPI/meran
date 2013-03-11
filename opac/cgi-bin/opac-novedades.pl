#!/usr/bin/perl
use strict;
require Exporter;
use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use CGI;
use C4::AR::Novedades;

my $query = new CGI;

my ($template, $session, $t_params)= get_template_and_user({
                                template_name   => "opac-novedades_result.tmpl",
                                query           => $query,
                                type            => "opac",
                                authnotrequired => 1,
                                flagsrequired   => {  ui            => 'ANY', 
                                                    tipo_documento  => 'ANY', 
                                                    accion          => 'CONSULTA', 
                                                    entorno         => 'undefined'},
            });

$t_params->{'content_title'}    = C4::AR::Filtros::i18n("Novedades de la Biblioteca");
my ($cantidad, $novedades)      = C4::AR::Novedades::getNovedadesByFecha();
$t_params->{'novedades'}        = $novedades;
$t_params->{'cantidad'}         = $cantidad;

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
