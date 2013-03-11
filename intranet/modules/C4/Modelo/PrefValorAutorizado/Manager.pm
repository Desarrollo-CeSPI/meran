package C4::Modelo::PrefValorAutorizado::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::PrefValorAutorizado;

sub object_class { 'C4::Modelo::PrefValorAutorizado' }

__PACKAGE__->make_manager_methods('pref_valor_autorizado');

1;

