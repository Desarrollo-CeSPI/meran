package C4::Modelo::CatContenidoEstante::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatContenidoEstante;

sub object_class { 'C4::Modelo::CatContenidoEstante' }

__PACKAGE__->make_manager_methods('cat_contenido_estante');

1;

