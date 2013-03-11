package C4::Modelo::PrefTablaReferencia::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::PrefTablaReferencia;

sub object_class { 'C4::Modelo::PrefTablaReferencia' }

__PACKAGE__->make_manager_methods('pref_tabla_referencia');

1;

