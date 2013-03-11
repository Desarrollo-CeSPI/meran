package C4::Modelo::AdqRefTipoRecomendacion::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::AdqRefTipoRecomendacion;

sub object_class { 'C4::Modelo::AdqRefTipoRecomendacion' }

__PACKAGE__->make_manager_methods('adq_ref_tipo_recomendacion');

1;