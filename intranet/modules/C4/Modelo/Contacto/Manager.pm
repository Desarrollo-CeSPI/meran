package C4::Modelo::Contacto::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::Contacto;

sub object_class { 'C4::Modelo::Contacto' }

__PACKAGE__->make_manager_methods('contacto');

1;

