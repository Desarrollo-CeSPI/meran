package C4::Modelo::RefNivelBibliografico::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::RefNivelBibliografico;

sub object_class { 'C4::Modelo::RefNivelBibliografico' }

__PACKAGE__->make_manager_methods('ref_nivel_bibliografico');

1;

