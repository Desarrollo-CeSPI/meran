package C4::Modelo::UsrLoginAttempts::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::UsrLoginAttempts;

sub object_class { 'C4::Modelo::UsrLoginAttempts' }

__PACKAGE__->make_manager_methods('usr_login_attempts');

1;

