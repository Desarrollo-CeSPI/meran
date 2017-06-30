package C4::Modelo::RepEstadistica::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::RepEstadistica;

sub object_class { 'C4::Modelo::RepEstadistica' }

__PACKAGE__->make_manager_methods('rep_estadistica');

1;

