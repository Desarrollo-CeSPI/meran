package C4::Modelo::CatRegistroMarcN2Analitica::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatRegistroMarcN2Analitica;

sub object_class { 'C4::Modelo::CatRegistroMarcN2Analitica' }

__PACKAGE__->make_manager_methods('cat_registro_marc_n2_analitica');

1;

