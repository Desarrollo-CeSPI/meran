package C4::Modelo::AdqTipoMaterial::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::AdqTipoMaterial;

sub object_class { 'C4::Modelo::AdqTipoMaterial' }

__PACKAGE__->make_manager_methods('adq_tipo_material');

1;
