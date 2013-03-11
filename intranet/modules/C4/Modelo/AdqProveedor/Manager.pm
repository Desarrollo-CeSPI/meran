package C4::Modelo::AdqProveedor::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::AdqProveedor;

sub object_class { 'C4::Modelo::AdqProveedor' }

__PACKAGE__->make_manager_methods('adq_proveedor');

1;