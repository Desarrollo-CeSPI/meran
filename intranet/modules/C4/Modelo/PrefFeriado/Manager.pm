package C4::Modelo::PrefFeriado::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::PrefFeriado;

sub object_class { 'C4::Modelo::PrefFeriado' }

__PACKAGE__->make_manager_methods('pref_feriado');

1;

