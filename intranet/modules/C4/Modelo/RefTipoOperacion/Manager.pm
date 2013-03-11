package C4::Modelo::RefTipoOperacion::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::RefTipoOperacion;

sub object_class { 'C4::Modelo::RefTipoOperacion' }

__PACKAGE__->make_manager_methods('ref_tipo_operacion');

1;

