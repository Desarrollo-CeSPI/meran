package C4::Modelo::CircReglaSancion::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CircReglaSancion;

sub object_class { 'C4::Modelo::CircReglaSancion' }

__PACKAGE__->make_manager_methods('circ_regla_sancion');

1;

