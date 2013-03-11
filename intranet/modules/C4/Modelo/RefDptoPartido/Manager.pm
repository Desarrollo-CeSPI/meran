package C4::Modelo::RefDptoPartido::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::RefDptoPartido;

sub object_class { 'C4::Modelo::RefDptoPartido' }

__PACKAGE__->make_manager_methods('ref_dpto_partido');

1;

