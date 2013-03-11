package C4::Modelo::RefSoporte::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::RefSoporte;

sub object_class { 'C4::Modelo::RefSoporte' }

__PACKAGE__->make_manager_methods('ref_soporte');

1;

