package C4::Modelo::RefSignatura::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::RefSignatura;

sub object_class { 'C4::Modelo::RefSignatura' }

__PACKAGE__->make_manager_methods('ref_signatura');

1;

