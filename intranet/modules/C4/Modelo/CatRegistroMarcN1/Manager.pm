package C4::Modelo::CatRegistroMarcN1::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatRegistroMarcN1;

sub object_class { 'C4::Modelo::CatRegistroMarcN1' }

__PACKAGE__->make_manager_methods('cat_registro_marc_n1');

1;

