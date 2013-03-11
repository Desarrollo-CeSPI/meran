package C4::Modelo::RefDisponibilidad::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::RefDisponibilidad;

sub object_class { 'C4::Modelo::RefDisponibilidad' }

__PACKAGE__->make_manager_methods('ref_disponibilidad');

1;

