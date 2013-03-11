package C4::Modelo::CatControlSeudonimoTema::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatControlSeudonimoTema;

sub object_class { 'C4::Modelo::CatControlSeudonimoTema' }

__PACKAGE__->make_manager_methods('cat_control_seudonimo_tema');

1;

