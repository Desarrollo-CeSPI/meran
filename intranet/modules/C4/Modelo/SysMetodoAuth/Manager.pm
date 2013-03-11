package C4::Modelo::SysMetodoAuth::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::SysMetodoAuth;

sub object_class { 'C4::Modelo::SysMetodoAuth' }

__PACKAGE__->make_manager_methods('sys_metodo_auth');

sub get_max_orden {
    my $db          = C4::Modelo::SysMetodoAuth->new()->db;
    my $sth         = $db->dbh->prepare("SELECT MAX(orden) FROM sys_metodo_auth");
    $sth->execute();
    my $max         = $sth->fetchrow;
    $sth->finish;
    return $max;
}


1;

