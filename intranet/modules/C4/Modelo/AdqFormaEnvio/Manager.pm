package C4::Modelo::AdqFormaEnvio::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::AdqFormaEnvio;

sub object_class { 'C4::Modelo::AdqFormaEnvio' }

__PACKAGE__->make_manager_methods('adq_forma_envio');

1;