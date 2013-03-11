package C4::Modelo::IndiceBusqueda::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::IndiceBusqueda;

sub object_class { 'C4::Modelo::IndiceBusqueda' }

__PACKAGE__->make_manager_methods('indice_busqueda');

1;

