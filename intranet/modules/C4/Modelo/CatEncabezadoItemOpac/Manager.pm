package C4::Modelo::CatEncabezadoItemOpac::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatEncabezadoItemOpac;

sub object_class { 'C4::Modelo::CatEncabezadoItemOpac' }

__PACKAGE__->make_manager_methods('cat_encabezado_item_opac');

1;

