package C4::Modelo::SysNovedadIntraNoMostrar::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::SysNovedadIntraNoMostrar;

sub object_class { 'C4::Modelo::SysNovedadIntraNoMostrar' }

__PACKAGE__->make_manager_methods('sys_novedad_intra_no_mostrar');

1;
