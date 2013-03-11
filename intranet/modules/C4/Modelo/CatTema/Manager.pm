package C4::Modelo::CatTema::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatTema;

sub object_class { 'C4::Modelo::CatTema' }

__PACKAGE__->make_manager_methods('cat_tema');

1;

