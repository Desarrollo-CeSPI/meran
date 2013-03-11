package C4::Modelo::CatFavoritosOpac;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'cat_favoritos_opac',

    columns => [
        nro_socio     => { type => 'varchar', overflow => 'truncate', not_null => 1, length => 16 },
        id1           => { type => 'integer', overflow => 'truncate', not_null => 1, length => 11 },
    ],

    primary_key_columns => [ 'nro_socio','id1' ],

    relationships =>
    [
      socio =>
      {
        class       => 'C4::Modelo::UsrSocio',
        key_columns => { nro_socio => 'nro_socio' },
        type        => 'one to one',
      },
    ]
);


sub toString{
	my ($self) = shift;

    return ($self->getRate);
}

sub getObjeto{
	my ($self) = shift;
	my ($socio,$id1) = @_;

	my $objecto= C4::Modelo::CatFavoritosOpac->new(nro_socio => $socio, id1 => $id1);
	$objecto->load();
	return $objecto;
}


sub getId1{
    my ($self) = shift;

    return ($self->id1);
}

sub setId1{
    my ($self) = shift;
    my ($id1) = @_;

    $self->id1($id1);
}


sub getNroSocio{
    my ($self) = shift;

    return (C4::AR::Utilidades::trim($self->nro_socio));
}

sub setNroSocio{
    my ($self) = shift;
    my ($nro_socio) = @_;

    $self->nro_socio($nro_socio);
}

1;

