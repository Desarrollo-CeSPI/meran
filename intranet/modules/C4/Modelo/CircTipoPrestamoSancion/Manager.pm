package C4::Modelo::CircTipoPrestamoSancion::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CircTipoPrestamoSancion;

sub object_class { 'C4::Modelo::CircTipoPrestamoSancion' }

__PACKAGE__->make_manager_methods('circ_tipo_prestamo_sancion');

1;

