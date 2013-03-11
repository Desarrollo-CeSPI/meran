#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use C4::AR::Utilidades;
use CGI;

my $input = new CGI;

my $combo_pedidos_cot = &C4::AR::Utilidades::generarComboPedidosCotizacion();

my ($template, $session, $t_params) = get_template_and_user({
                                template_name   => "adquisiciones/compararPresupuestos.tmpl",
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

$t_params->{'combo_pedidos'}    = $combo_pedidos_cot;

$t_params->{'page_sub_title'}   = C4::AR::Filtros::i18n("Presupuestos");

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
