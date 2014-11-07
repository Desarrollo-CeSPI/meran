package C4::Modelo::IndiceBusqueda::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::IndiceBusqueda;

sub object_class { 'C4::Modelo::IndiceBusqueda' }

__PACKAGE__->make_manager_methods('indice_busqueda');

sub get_maximum_timestamp {
    my ($class, %args) = @_;

    my $db = $args{'db'} || C4::Modelo::IndiceBusqueda->new()->db;
    my $sth = $db->dbh->prepare("SELECT MAX(timestamp) FROM indice_busqueda");
    $sth->execute();
    my  $max  = $sth->fetchrow;
    $sth->finish;
    return $max;
}

sub get_minimum_timestamp {
    my ($class, %args) = @_;

    my $db = $args{'db'} || C4::Modelo::IndiceBusqueda->new()->db;
    my $sth = $db->dbh->prepare("SELECT MIN(timestamp) FROM indice_busqueda");
    $sth->execute();
    my  $min  = $sth->fetchrow;
    $sth->finish;
    return $min;
}


1;

