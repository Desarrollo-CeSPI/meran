package C4::Modelo::CatEstructuraCatalogacion::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatEstructuraCatalogacion;

sub object_class { 'C4::Modelo::CatEstructuraCatalogacion' }

__PACKAGE__->make_manager_methods('cat_estructura_catalogacion');

1;

