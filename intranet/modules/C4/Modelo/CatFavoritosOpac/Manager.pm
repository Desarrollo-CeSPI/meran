package C4::Modelo::CatFavoritosOpac::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatFavoritosOpac;

sub object_class { 'C4::Modelo::CatFavoritosOpac' }

__PACKAGE__->make_manager_methods('cat_favoritos_opac');

1;

