package C4::Modelo::CatZ3950Cola::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatZ3950Cola;

sub object_class { 'C4::Modelo::CatZ3950Cola' }

__PACKAGE__->make_manager_methods('cat_z3950_cola');

1;

