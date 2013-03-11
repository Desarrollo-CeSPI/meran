package C4::Modelo::CatEditorial::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatEditorial;

sub object_class { 'C4::Modelo::CatEditorial' }

__PACKAGE__->make_manager_methods('cat_editorial');

1;

