package C4::Modelo::CatAnalitica::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatAnalitica;

sub object_class { 'C4::Modelo::CatAnalitica' }

__PACKAGE__->make_manager_methods('cat_analitica');

1;

