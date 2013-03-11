package C4::Modelo::CatEncabezadoCampoOpac::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatEncabezadoCampoOpac;

sub object_class { 'C4::Modelo::CatEncabezadoCampoOpac' }

__PACKAGE__->make_manager_methods('cat_encabezado_campo_opac');

1;

