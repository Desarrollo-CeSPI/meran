package C4::Modelo::AdqProveedorFormaEnvio::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::AdqProveedorFormaEnvio;

sub object_class { 'C4::Modelo::AdqProveedorFormaEnvio' }

__PACKAGE__->make_manager_methods('adq_proveedor_forma_envio');

1;