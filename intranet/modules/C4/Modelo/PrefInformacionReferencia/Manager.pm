package C4::Modelo::PrefInformacionReferencia::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::PrefInformacionReferencia;

sub object_class { 'C4::Modelo::PrefInformacionReferencia' }

__PACKAGE__->make_manager_methods('pref_informacion_referencia');

1;

