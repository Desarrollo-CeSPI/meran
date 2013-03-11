package C4::Modelo::SysNovedad::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::SysNovedad;

sub object_class { 'C4::Modelo::SysNovedad' }

__PACKAGE__->make_manager_methods('sys_novedad');

1;

