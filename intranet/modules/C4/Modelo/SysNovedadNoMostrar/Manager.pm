package C4::Modelo::SysNovedadNoMostrar::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::SysNovedadNoMostrar;

sub object_class { 'C4::Modelo::SysNovedadNoMostrar' }

__PACKAGE__->make_manager_methods('sys_novedad_no_mostrar');

1;
