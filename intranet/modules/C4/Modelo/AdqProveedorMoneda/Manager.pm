package C4::Modelo::AdqProveedorMoneda::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::AdqProveedorMoneda;

sub object_class { 'C4::Modelo::AdqProveedorMoneda' }

__PACKAGE__->make_manager_methods('adq_ref_proveedor_moneda');

1;
