package C4::Modelo::CatEstante::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatEstante;

sub object_class { 'C4::Modelo::CatEstante' }

__PACKAGE__->make_manager_methods('cat_estante');

1;

