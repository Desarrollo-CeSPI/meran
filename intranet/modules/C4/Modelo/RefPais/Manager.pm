package C4::Modelo::RefPais::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::RefPais;

sub object_class { 'C4::Modelo::RefPais' }

__PACKAGE__->make_manager_methods('ref_pais');

1;

