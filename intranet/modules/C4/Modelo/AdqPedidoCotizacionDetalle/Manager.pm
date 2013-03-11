package C4::Modelo::AdqPedidoCotizacionDetalle::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::AdqPedidoCotizacionDetalle;

sub object_class { 'C4::Modelo::AdqPedidoCotizacionDetalle' }

__PACKAGE__->make_manager_methods('adq_pedido_cotizacion_detalle');

1;
