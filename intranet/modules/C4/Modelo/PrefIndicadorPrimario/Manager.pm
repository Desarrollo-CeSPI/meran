package C4::Modelo::PrefIndicadorPrimario::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::PrefIndicadorPrimario;

sub object_class { 'C4::Modelo::PrefIndicadorPrimario' }

__PACKAGE__->make_manager_methods('pref_indicador_primario');

1;

