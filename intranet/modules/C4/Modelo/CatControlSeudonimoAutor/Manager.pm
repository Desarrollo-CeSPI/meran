package C4::Modelo::CatControlSeudonimoAutor::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatControlSeudonimoAutor;

sub object_class { 'C4::Modelo::CatControlSeudonimoAutor' }

__PACKAGE__->make_manager_methods('cat_control_seudonimo_autor');

1;

