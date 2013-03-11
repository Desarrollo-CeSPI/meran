package C4::Modelo::RefAdqMoneda::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::RefAdqMoneda;

sub object_class { 'C4::Modelo::RefAdqMoneda' }

__PACKAGE__->make_manager_methods('ref_adq_moneda');

1;