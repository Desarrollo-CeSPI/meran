package C4::Modelo::IoImportacionIso::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::IoImportacionIso;

sub object_class { 'C4::Modelo::IoImportacionIso' }

__PACKAGE__->make_manager_methods('io_importacion_iso');

1;
