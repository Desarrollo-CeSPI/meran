package C4::Modelo::IoImportacionIsoRegistro::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::IoImportacionIsoRegistro;

sub object_class { 'C4::Modelo::IoImportacionIsoRegistro' }

__PACKAGE__->make_manager_methods('io_importacion_iso_registro');

1;
