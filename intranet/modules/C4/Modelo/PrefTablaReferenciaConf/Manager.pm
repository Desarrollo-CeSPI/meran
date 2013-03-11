package C4::Modelo::PrefTablaReferenciaConf::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::PrefTablaReferenciaConf;

sub object_class { 'C4::Modelo::PrefTablaReferenciaConf' }

__PACKAGE__->make_manager_methods('pref_tabla_referencia_conf');

1;

