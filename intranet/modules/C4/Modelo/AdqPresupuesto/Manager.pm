package C4::Modelo::AdqPresupuesto::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::AdqPresupuesto;

sub object_class { 'C4::Modelo::AdqPresupuesto' }

__PACKAGE__->make_manager_methods('adq_presupuesto');

1;