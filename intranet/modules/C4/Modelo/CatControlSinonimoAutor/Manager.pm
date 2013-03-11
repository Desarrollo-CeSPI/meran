package C4::Modelo::CatControlSinonimoAutor::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatControlSinonimoAutor;

sub object_class { 'C4::Modelo::CatControlSinonimoAutor' }

__PACKAGE__->make_manager_methods('cat_control_sinonimo_autor');

1;

