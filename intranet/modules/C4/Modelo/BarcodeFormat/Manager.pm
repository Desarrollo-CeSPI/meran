package C4::Modelo::BarcodeFormat::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::BarcodeFormat;

sub object_class { 'C4::Modelo::BarcodeFormat' }

__PACKAGE__->make_manager_methods('barcode_format');

1;

