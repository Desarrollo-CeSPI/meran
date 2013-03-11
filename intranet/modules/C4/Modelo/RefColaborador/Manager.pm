package C4::Modelo::RefColaborador::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::RefColaborador;

sub object_class { 'C4::Modelo::RefColaborador' }

__PACKAGE__->make_manager_methods('ref_colaborador');

1;

