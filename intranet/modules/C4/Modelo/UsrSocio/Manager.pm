package C4::Modelo::UsrSocio::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::UsrSocio;

sub object_class { 'C4::Modelo::UsrSocio' }

__PACKAGE__->make_manager_methods('usr_socio');

1;

