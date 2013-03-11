package C4::Modelo::SysExternosMeran::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::SysExternosMeran;

sub object_class { 'C4::Modelo::SysExternosMeran' }

__PACKAGE__->make_manager_methods('sys_externos_meran');

1;

