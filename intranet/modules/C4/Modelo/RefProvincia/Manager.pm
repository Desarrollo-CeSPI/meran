package C4::Modelo::RefProvincia::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::RefProvincia;

sub object_class { 'C4::Modelo::RefProvincia' }

__PACKAGE__->make_manager_methods('ref_provincia');

1;

