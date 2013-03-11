package C4::Modelo::RefEstadoPresupuesto::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::RefEstadoPresupuesto;

sub object_class { 'C4::Modelo::RefEstadoPresupuesto' }

__PACKAGE__->make_manager_methods('ref_estado_presupuesto');

1;