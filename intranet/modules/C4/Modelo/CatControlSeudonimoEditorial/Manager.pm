package C4::Modelo::CatControlSeudonimoEditorial::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatControlSeudonimoEditorial;

sub object_class { 'C4::Modelo::CatControlSeudonimoEditorial' }

__PACKAGE__->make_manager_methods('cat_control_seudonimo_editorial');

1;

