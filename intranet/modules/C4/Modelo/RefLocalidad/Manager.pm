package C4::Modelo::RefLocalidad::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::RefLocalidad;

sub object_class { 'C4::Modelo::RefLocalidad' }

__PACKAGE__->make_manager_methods('ref_localidad');

1;

