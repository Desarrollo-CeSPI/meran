package C4::Modelo::CatPortadaRegistro::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatPortadaRegistro;

sub object_class { 'C4::Modelo::CatPortadaRegistro' }

__PACKAGE__->make_manager_methods('cat_portada_registro');

1;

