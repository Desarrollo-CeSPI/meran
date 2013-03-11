package C4::Modelo::IoImportacionIsoEsquema::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::IoImportacionIsoEsquema;

sub object_class { 'C4::Modelo::IoImportacionIsoEsquema' }

__PACKAGE__->make_manager_methods('io_importacion_iso_esquema');

1;
