package C4::Modelo::CatHistoricoDisponibilidad::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatHistoricoDisponibilidad;

sub object_class { 'C4::Modelo::CatHistoricoDisponibilidad' }

__PACKAGE__->make_manager_methods('cat_historico_disponibilidad');

1;

