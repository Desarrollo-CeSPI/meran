package C4::Modelo::CatAyudaMarc::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatAyudaMarc;

sub object_class { 'C4::Modelo::CatAyudaMarc' }

__PACKAGE__->make_manager_methods('cat_ayuda_marc');

1;