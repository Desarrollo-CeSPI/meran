package C4::Modelo::CatRefTipoNivel3::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatRefTipoNivel3;

sub object_class { 'C4::Modelo::CatRefTipoNivel3' }

__PACKAGE__->make_manager_methods('cat_ref_tipo_nivel3');

1;

