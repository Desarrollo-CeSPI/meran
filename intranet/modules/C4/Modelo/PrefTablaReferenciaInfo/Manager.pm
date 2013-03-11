package C4::Modelo::PrefTablaReferenciaInfo::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::PrefTablaReferenciaInfo;

sub object_class { 'C4::Modelo::PrefTablaReferenciaInfo' }

__PACKAGE__->make_manager_methods('pref_tabla_referencia_info');

1;

