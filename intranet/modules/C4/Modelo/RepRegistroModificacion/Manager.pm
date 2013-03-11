package C4::Modelo::RepRegistroModificacion::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::RepRegistroModificacion;

sub object_class { 'C4::Modelo::RepRegistroModificacion' }

__PACKAGE__->make_manager_methods('rep_registro_modificacion');

1;

