package C4::Modelo::RepHistorialBusqueda::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::RepHistorialBusqueda;

sub object_class { 'C4::Modelo::RepHistorialBusqueda' }

__PACKAGE__->make_manager_methods('rep_historial_busqueda');

1;

