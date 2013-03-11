package C4::Modelo::BackgroundJob::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::BackgroundJob;

sub object_class { 'C4::Modelo::BackgroundJob' }

__PACKAGE__->make_manager_methods('background_job');

1;

