package C4::Modelo::CircRefTipoPrestamo::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CircRefTipoPrestamo;

sub object_class { 'C4::Modelo::CircRefTipoPrestamo' }

__PACKAGE__->make_manager_methods('circ_ref_tipo_prestamo');

1;

