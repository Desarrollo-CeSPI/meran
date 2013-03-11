package C4::Modelo::PrefEstructuraCampoMarc::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::PrefEstructuraCampoMarc;

sub object_class { 'C4::Modelo::PrefEstructuraCampoMarc' }

__PACKAGE__->make_manager_methods('pref_estructura_campo_marc');

1;

