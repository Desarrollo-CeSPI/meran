package C4::Modelo::PrefUnidadInformacion::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::PrefUnidadInformacion;

sub object_class { 'C4::Modelo::PrefUnidadInformacion' }

__PACKAGE__->make_manager_methods('pref_unidad_informacion');

1;

