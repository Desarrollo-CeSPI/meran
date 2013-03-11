package C4::Modelo::PrefAbout::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::PrefAbout;

sub object_class {'C4::Modelo::PrefAbout'}

__PACKAGE__->make_manager_methods('pref_about');

1;
