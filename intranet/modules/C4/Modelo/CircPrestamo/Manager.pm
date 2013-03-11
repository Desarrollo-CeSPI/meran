package C4::Modelo::CircPrestamo::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CircPrestamo;

sub object_class { 'C4::Modelo::CircPrestamo' }

__PACKAGE__->make_manager_methods('circ_prestamo');

1;

