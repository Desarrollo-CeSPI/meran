package C4::Modelo::RefEstado::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::RefEstado;

sub object_class { 'C4::Modelo::RefEstado' }

__PACKAGE__->make_manager_methods('ref_estado');

1;

