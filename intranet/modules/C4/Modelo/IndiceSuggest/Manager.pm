package C4::Modelo::IndiceSuggest::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::IndiceSuggest;

sub object_class { 'C4::Modelo::IndiceSuggest' }

__PACKAGE__->make_manager_methods('indice_suggest');

1;

