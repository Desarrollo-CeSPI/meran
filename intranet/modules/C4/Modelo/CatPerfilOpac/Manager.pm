package C4::Modelo::CatPerfilOpac::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatPerfilOpac;

sub object_class { 'C4::Modelo::CatPerfilOpac' }

__PACKAGE__->make_manager_methods('cat_perfil_opac');

1;

