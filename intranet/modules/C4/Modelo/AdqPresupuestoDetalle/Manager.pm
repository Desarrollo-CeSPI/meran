package C4::Modelo::AdqPresupuestoDetalle::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::AdqPresupuestoDetalle;

sub object_class { 'C4::Modelo::AdqPresupuestoDetalle' }

__PACKAGE__->make_manager_methods('adq_presupuesto_detalle');

1;