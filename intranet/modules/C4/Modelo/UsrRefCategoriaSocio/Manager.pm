package C4::Modelo::UsrRefCategoriaSocio::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::UsrRefCategoriaSocio;

sub object_class { 'C4::Modelo::UsrRefCategoriaSocio' }

__PACKAGE__->make_manager_methods('usr_ref_categoria_socio');

1;
