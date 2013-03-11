package C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::IoImportacionIsoEsquemaDetalle;

sub object_class { 'C4::Modelo::IoImportacionIsoEsquemaDetalle' }

__PACKAGE__->make_manager_methods('io_importacion_iso_esquema_detalle');

1;
