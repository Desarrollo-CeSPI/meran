package C4::Modelo::CircReserva::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CircReserva;

sub object_class { 'C4::Modelo::CircReserva' }

__PACKAGE__->make_manager_methods('circ_reserva');

1;

