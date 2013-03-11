package C4::Modelo::PortadaOpac::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::PortadaOpac;

sub object_class { 'C4::Modelo::PortadaOpac' }

__PACKAGE__->make_manager_methods('portada_opac');

1;

