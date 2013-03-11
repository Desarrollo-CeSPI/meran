package C4::Modelo::CatZ3950Resultado::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatZ3950Resultado;

sub object_class { 'C4::Modelo::CatZ3950Resultado' }

__PACKAGE__->make_manager_methods('cat_z3950_resultado');

1;

