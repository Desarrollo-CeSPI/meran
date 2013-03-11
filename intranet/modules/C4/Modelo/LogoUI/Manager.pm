package C4::Modelo::LogoUI::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::LogoUI;

sub object_class { 'C4::Modelo::LogoUI' }

__PACKAGE__->make_manager_methods('logoUI');

1;
