package C4::Modelo::PrefPreferenciaSistema::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::PrefPreferenciaSistema;

sub object_class { 'C4::Modelo::PrefPreferenciaSistema' }

__PACKAGE__->make_manager_methods('pref_preferencia_sistema');

1;

