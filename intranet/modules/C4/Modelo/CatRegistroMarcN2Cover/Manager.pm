package C4::Modelo::CatRegistroMarcN2Cover::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatRegistroMarcN2Cover;

sub object_class { 'C4::Modelo::CatRegistroMarcN2Cover' }

__PACKAGE__->make_manager_methods('cat_registro_marc_n2_cover');

1;