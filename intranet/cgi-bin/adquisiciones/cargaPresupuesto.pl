#!usr/bin/perl

# use strict;
use C4::AR::Auth;
use CGI;
use C4::AR::Proveedores;

my $input = new CGI;

my $combo_proveedores   = &C4::AR::Utilidades::generarComboProveedores();
my $combo_presupuestos  = &C4::AR::Utilidades::generarComboPresupuestos();

my ($template, $session, $t_params)= get_template_and_user({
                                template_name   => "adquisiciones/cargaPresupuesto.tmpl",
                                query           => $input,
                                type            => "intranet",
                                authnotrequired => 0,
                                flagsrequired   => {    ui => 'ANY', 
                                                        tipo_documento => 'ANY', 
                                                        accion => 'ALTA', 
                                                        tipo_permiso => 'general',
                                                        entorno => 'adq_intra'}, # FIXME
                                debug           => 1,
                 });

my $monedas = C4::AR::Proveedores::getMonedasProveedor($id_proveedor);

$t_params->{'monedas'}              = $monedas;
$t_params->{'combo_proveedores'}    = $combo_proveedores;
$t_params->{'combo_presupuestos'}   = $combo_presupuestos;
$t_params->{'page_sub_title'}       = C4::AR::Filtros::i18n("Presupuestos");

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
