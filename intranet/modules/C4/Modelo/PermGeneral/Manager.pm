package C4::Modelo::PermGeneral::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::PermGeneral;

sub object_class { 'C4::Modelo::PermGeneral' }

__PACKAGE__->make_manager_methods('perm_general');

1;

