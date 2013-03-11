package C4::Modelo::PrefIndicadorSecundario::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::PrefIndicadorSecundario;

sub object_class { 'C4::Modelo::PrefIndicadorSecundario' }

__PACKAGE__->make_manager_methods('pref_indicador_secundario');

1;

