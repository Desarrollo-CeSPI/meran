package C4::Modelo::RefIdioma::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::RefIdioma;

sub object_class { 'C4::Modelo::RefIdioma' }

__PACKAGE__->make_manager_methods('ref_idioma');

1;

