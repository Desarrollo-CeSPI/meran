package C4::Modelo::UsrRefEstado::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::UsrRefEstado;

sub object_class { 'C4::Modelo::UsrRefEstado' }

__PACKAGE__->make_manager_methods('usr_ref_estado');

1;

