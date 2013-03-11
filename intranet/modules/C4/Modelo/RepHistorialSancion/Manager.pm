package C4::Modelo::RepHistorialSancion::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::RepHistorialSancion;

sub object_class { 'C4::Modelo::RepHistorialSancion' }

__PACKAGE__->make_manager_methods('rep_historial_sancion');

1;

