package C4::Modelo::IndiceSugerencia::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::IndiceSugerencia;

sub object_class { 'C4::Modelo::IndiceSugerencia' }

__PACKAGE__->make_manager_methods('indice_sugerencia');

1;

