package C4::Modelo::CircReglaTipoSancion::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CircReglaTipoSancion;

sub object_class { 'C4::Modelo::CircReglaTipoSancion' }

__PACKAGE__->make_manager_methods('circ_regla_tipo_sancion');

1;

