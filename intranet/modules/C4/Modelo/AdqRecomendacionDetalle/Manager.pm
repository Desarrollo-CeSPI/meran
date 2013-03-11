package C4::Modelo::AdqRecomendacionDetalle::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::AdqRecomendacionDetalle;

sub object_class { 'C4::Modelo::AdqRecomendacionDetalle' }

__PACKAGE__->make_manager_methods('adq_recomendacion_detalle');

1;