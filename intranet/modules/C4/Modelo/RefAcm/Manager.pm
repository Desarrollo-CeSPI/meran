package C4::Modelo::RefAcm::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::RefAcm;

sub object_class { 'C4::Modelo::RefAcm' }

__PACKAGE__->make_manager_methods('ref_acm');

1;

