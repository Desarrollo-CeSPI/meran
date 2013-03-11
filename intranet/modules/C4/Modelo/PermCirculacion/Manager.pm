package C4::Modelo::PermCirculacion::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::PermCirculacion;

sub object_class { 'C4::Modelo::PermCirculacion' }

__PACKAGE__->make_manager_methods('perm_circulacion');

1;

