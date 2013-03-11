#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;

my $input = new CGI;

my ($template, $session, $t_params, $socio)  = get_template_and_user({
                            template_name       => "admin/z3950/z3950servers.tmpl",
                            query               => $input,
                            type                => "intranet",
                            authnotrequired     => 0,
                            flagsrequired       => {    ui              => 'ANY', 
                                                        tipo_documento  => 'ANY', 
                                                        accion          => 'CONSULTA', 
                                                        entorno         => 'undefined'},
                            debug               => 1,
                 });

# TODO: obtener los datos de los servers z3950
#my $preferencias_catalogo       = C4::AR::Preferencias::getPreferenciasByCategoria('catalogo');
#$t_params->{'preferencias'}     = $preferencias_catalogo;
$t_params->{'page_sub_title'}   = C4::AR::Filtros::i18n("Preferencias de Servidores z3950");   
C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
