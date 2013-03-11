package C4::Modelo::AdqProveedorTipoMaterial::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::AdqProveedorTipoMaterial;

sub object_class { 'C4::Modelo::AdqProveedorTipoMaterial' }

__PACKAGE__->make_manager_methods('adq_proveedor_tipo_material');

1;
