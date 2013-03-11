package C4::Modelo::ImagenesNovedadesOpac::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::ImagenesNovedadesOpac;

sub object_class { 'C4::Modelo::ImagenesNovedadesOpac' }

__PACKAGE__->make_manager_methods('imagenes_novedades_opac');

1;
