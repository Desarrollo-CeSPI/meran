package C4::Modelo::LogoEtiquetas::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::LogoEtiquetas;

sub object_class { 'C4::Modelo::LogoEtiquetas' }

__PACKAGE__->make_manager_methods('logoEtiquetas');

1;
