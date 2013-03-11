package C4::Modelo::PrefCategoriaUnidadInformacion::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::PrefCategoriaUnidadInformacion;

sub object_class { 'C4::Modelo::PrefCategoriaUnidadInformacion' }

__PACKAGE__->make_manager_methods('pref_categoria_unidad_informacion');

1;

