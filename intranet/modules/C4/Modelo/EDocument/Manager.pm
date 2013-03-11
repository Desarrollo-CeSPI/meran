package C4::Modelo::EDocument::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::EDocument;

sub object_class { 'C4::Modelo::EDocument' }

__PACKAGE__->make_manager_methods('e_document');

1;

