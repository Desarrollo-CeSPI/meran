package C4::Modelo::PrefEstructuraSubcampoMarc::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::PrefEstructuraSubcampoMarc;

sub object_class { 'C4::Modelo::PrefEstructuraSubcampoMarc' }

__PACKAGE__->make_manager_methods('pref_estructura_subcampo_marc');

1;

