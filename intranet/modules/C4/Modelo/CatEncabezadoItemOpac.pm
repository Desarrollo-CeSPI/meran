package C4::Modelo::CatEncabezadoItemOpac;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'cat_encabezado_item_opac',

    columns => [
        idencabezado => { type => 'integer', overflow => 'truncate', not_null => 1 },
        itemtype     => { type => 'varchar', overflow => 'truncate', length => 4, not_null => 1 },
    ],

    primary_key_columns => [ 'idencabezado', 'itemtype' ],
);

sub agregar{
	my ($self)=shift;

	my ($data_hash) = @_;

	$self->setTipoDocumento($data_hash->{'tipo_documento'});
	$self->setIdEncabezado($data_hash->{'idencabezado'});
	
	$self->save();
}

sub getIdEncabezado{
    my ($self)=shift;

    return $self->idencabezado;
}

sub setIdEncabezado{
    my ($self) = shift;
    my ($idencabezado) = @_;

    $self->idencabezado($idencabezado);
}

sub getTipoDocumento{
    my ($self)=shift;

    return $self->itemtype;
}

sub setTipoDocumento{
    my ($self) = shift;
    my ($tipo_documento) = @_;

    $self->itemtype($tipo_documento);
}

1;

