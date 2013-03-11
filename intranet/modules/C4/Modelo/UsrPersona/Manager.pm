package C4::Modelo::UsrPersona::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::UsrPersona;

sub object_class { 'C4::Modelo::UsrPersona' }

__PACKAGE__->make_manager_methods('usr_persona');

1;

