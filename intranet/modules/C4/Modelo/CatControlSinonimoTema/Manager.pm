package C4::Modelo::CatControlSinonimoTema::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatControlSinonimoTema;

sub object_class { 'C4::Modelo::CatControlSinonimoTema' }

__PACKAGE__->make_manager_methods('cat_control_sinonimo_tema');

1;

