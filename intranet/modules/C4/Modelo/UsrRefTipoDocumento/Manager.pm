package C4::Modelo::UsrRefTipoDocumento::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::UsrRefTipoDocumento;

sub object_class { 'C4::Modelo::UsrRefTipoDocumento' }

__PACKAGE__->make_manager_methods('usr_ref_tipo_documento');

1;

