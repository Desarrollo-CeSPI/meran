package C4::Modelo::CatRating::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatRating;

sub object_class { 'C4::Modelo::CatRating' }

__PACKAGE__->make_manager_methods('cat_rating');

1;

