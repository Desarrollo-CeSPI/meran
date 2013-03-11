package C4::Modelo::PermCatalogo::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::PermCatalogo;

sub object_class { 'C4::Modelo::PermCatalogo' }

__PACKAGE__->make_manager_methods('perm_catalogo');

1;

