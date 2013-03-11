package C4::Modelo::CircTipoSancion::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CircTipoSancion;

sub object_class { 'C4::Modelo::CircTipoSancion' }

__PACKAGE__->make_manager_methods('circ_tipo_sancion');

1;

