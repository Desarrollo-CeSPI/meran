package C4::Modelo::RepBusqueda::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::RepBusqueda;

sub object_class { 'C4::Modelo::RepBusqueda' }

__PACKAGE__->make_manager_methods('rep_busqueda');

1;

