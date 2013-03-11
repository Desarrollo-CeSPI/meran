#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use CGI;
use C4::AR::Proveedores;
use C4::AR::PedidoCotizacionDetalle;

my $input                   = new CGI;
my $id_pedido_cotizacion    = $input->param('id_pedido_cotizacion');
my $tipoAccion              = $input->param('action');
my $pedidos_cotizacion      = C4::AR::PedidoCotizacionDetalle::getPedidosCotizacionPorPadre($id_pedido_cotizacion);

my ($template, $session, $t_params);

if ($tipoAccion eq "DETALLE") {
# se muestra la informacion del pedido_cotizacion
 
    ($template, $session, $t_params) =  C4::AR::Auth::get_template_and_user ({
        template_name   => '/adquisiciones/datosPedidoCotizacion.tmpl',
        query           => $input,
        type            => "intranet",
        authnotrequired => 0,
        flagsrequired   => {    ui => 'ANY', 
                                tipo_documento => 'ANY', 
                                accion => 'CONSULTA', 
                                tipo_permiso => 'general',
                                entorno => 'adq_intra'},
    });
    
    $t_params->{'pedido_cotizacion'} = $pedidos_cotizacion;
}

$t_params->{'page_sub_title'}       = C4::AR::Filtros::i18n("Pedidos de Cotizacion");
$t_params->{'pedido_cotizacion_id'} = $id_pedido_cotizacion;

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
