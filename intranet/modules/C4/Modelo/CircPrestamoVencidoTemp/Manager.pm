package C4::Modelo::CircPrestamoVencidoTemp::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CircPrestamoVencidoTemp;

sub object_class { 'C4::Modelo::CircPrestamoVencidoTemp' }

__PACKAGE__->make_manager_methods('circ_prestamo_vencido_temp');

1;

