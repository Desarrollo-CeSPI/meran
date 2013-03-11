package C4::Modelo::PrefServidorZ3950::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::PrefServidorZ3950;

sub object_class { 'C4::Modelo::PrefServidorZ3950' }

__PACKAGE__->make_manager_methods('pref_servidor_z3950');

1;

