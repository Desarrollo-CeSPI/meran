package C4::Modelo::CatVisualizacionIntra::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use C4::Modelo::CatVisualizacionIntra;

sub object_class { 'C4::Modelo::CatVisualizacionIntra' }

__PACKAGE__->make_manager_methods('cat_visualizacion_intra');

sub get_max_orden {
    my $db          = C4::Modelo::CatVisualizacionIntra->new()->db;
    my $sth         = $db->dbh->prepare("SELECT MAX(orden) FROM cat_visualizacion_intra");
    $sth->execute();
    my $max         = $sth->fetchrow;
    $sth->finish;
    return $max;
}

sub get_max_orden_subcampo {
    my ($campo) = @_;
    my $db          = C4::Modelo::CatVisualizacionIntra->new()->db;
    my $sql         = "SELECT MAX(orden_subcampo) FROM cat_visualizacion_intra WHERE campo='".$campo."'";
    my $sth         = $db->dbh->prepare($sql);
    $sth->execute();
    my $max         = $sth->fetchrow;
    $sth->finish;
    return $max;
}

1;
