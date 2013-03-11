package C4::Modelo::CatRegistroMarcN2::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatRegistroMarcN2;

sub object_class { 'C4::Modelo::CatRegistroMarcN2' }

__PACKAGE__->make_manager_methods('cat_registro_marc_n2');

1;

