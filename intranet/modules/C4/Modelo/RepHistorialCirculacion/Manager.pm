package C4::Modelo::RepHistorialCirculacion::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::RepHistorialCirculacion;

sub object_class { 'C4::Modelo::RepHistorialCirculacion' }

__PACKAGE__->make_manager_methods('rep_historial_circulacion');

1;

