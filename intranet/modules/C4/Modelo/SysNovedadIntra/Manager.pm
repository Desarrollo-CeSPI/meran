package C4::Modelo::SysNovedadIntra::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::SysNovedadIntra;

sub object_class { 'C4::Modelo::SysNovedadIntra' }

__PACKAGE__->make_manager_methods('sys_novedad_intra');

1;
