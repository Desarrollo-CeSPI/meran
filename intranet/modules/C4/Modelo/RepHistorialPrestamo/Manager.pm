package C4::Modelo::RepHistorialPrestamo::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::RepHistorialPrestamo;

sub object_class { 'C4::Modelo::RepHistorialPrestamo' }

__PACKAGE__->make_manager_methods('rep_historial_prestamo');

1;

