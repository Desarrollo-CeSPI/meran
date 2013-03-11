package C4::Modelo::RefTipoDocumento::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::RefTipoDocumento;

sub object_class { 'C4::Modelo::RefTipoDocumento' }

__PACKAGE__->make_manager_methods('ref_tipo_documento');

1;

