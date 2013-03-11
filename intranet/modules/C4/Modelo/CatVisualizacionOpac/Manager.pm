package C4::Modelo::CatVisualizacionOpac::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatVisualizacionOpac;

sub object_class { 'C4::Modelo::CatVisualizacionOpac' }

__PACKAGE__->make_manager_methods('cat_visualizacion_opac');

sub get_max_orden {
    my $db          = C4::Modelo::CatVisualizacionOpac->new()->db;
    my $sth         = $db->dbh->prepare("SELECT MAX(orden) FROM cat_visualizacion_opac");
    $sth->execute();
    my $max         = $sth->fetchrow;
    $sth->finish;
    return $max;
}

sub get_max_orden_subcampo {
    my ($campo) = @_;
    my $db          = C4::Modelo::CatVisualizacionOpac->new()->db;
    my $sql         = "SELECT MAX(orden_subcampo) FROM cat_visualizacion_opac WHERE campo='".$campo."'";
    my $sth         = $db->dbh->prepare($sql);
    $sth->execute();
    my $max         = $sth->fetchrow;
    $sth->finish;
    return $max;
}

1;

