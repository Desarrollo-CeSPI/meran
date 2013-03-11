package C4::Modelo::SistSesion::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::SistSesion;

sub object_class { 'C4::Modelo::SistSesion' }

__PACKAGE__->make_manager_methods('sist_sesion');

1;

