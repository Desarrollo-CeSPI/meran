package C4::Modelo::CatAutor::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatAutor;

sub object_class { 'C4::Modelo::CatAutor' }

__PACKAGE__->make_manager_methods('cat_autor');

1;

