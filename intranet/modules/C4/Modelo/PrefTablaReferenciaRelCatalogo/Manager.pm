package C4::Modelo::PrefTablaReferenciaRelCatalogo::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::PrefTablaReferenciaRelCatalogo;

sub object_class { 'C4::Modelo::PrefTablaReferenciaRelCatalogo' }

__PACKAGE__->make_manager_methods('pref_tabla_referencia_rel_catalogo');

1;

