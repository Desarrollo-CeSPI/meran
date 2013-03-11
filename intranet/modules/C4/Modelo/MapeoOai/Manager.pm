package C4::Modelo::MapeoOai::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::MapeoOai;

sub object_class { 'C4::Modelo::MapeoOai' }

__PACKAGE__->make_manager_methods('mapeo_oai');

1;