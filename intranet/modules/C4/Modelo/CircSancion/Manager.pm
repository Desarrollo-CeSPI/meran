package C4::Modelo::CircSancion::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CircSancion;

sub object_class { 'C4::Modelo::CircSancion' }

__PACKAGE__->make_manager_methods('circ_sancion');

1;

