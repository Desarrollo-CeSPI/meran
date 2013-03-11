package C4::Modelo::CatRegistroMarcN3::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatRegistroMarcN3;

sub object_class { 'C4::Modelo::CatRegistroMarcN3' }

__PACKAGE__->make_manager_methods('cat_registro_marc_n3');

sub get_maximum_codigo_barra {
    my ($class, %args) = @_;

    my $db = $args{'db'} || C4::Modelo::CatRegistroMarcN3->new()->db;
    my $sth = $db->dbh->prepare("SELECT MAX(CAST(substr(codigo_barra,length(?)) AS UNSIGNED)) FROM cat_registro_marc_n3 where codigo_barra like ? ");
    $sth->execute($args{'like'},$args{'like'});
    my  $max  = $sth->fetchrow;
    $sth->finish;
    return $max;
}

1;

