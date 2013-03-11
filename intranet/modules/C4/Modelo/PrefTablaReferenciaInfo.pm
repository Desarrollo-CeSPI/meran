package C4::Modelo::PrefTablaReferenciaInfo;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'pref_tabla_referencia_info',

    columns => [
        orden      => { type => 'varchar', overflow => 'truncate', length => 20, not_null => 1 },
        referencia => { type => 'varchar', overflow => 'truncate', length => 30, not_null => 1 },
        similares  => { type => 'varchar', overflow => 'truncate', length => 20, not_null => 1 },
    ],

    primary_key_columns => [ 'referencia' ],
);

sub getOrden{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->orden));
}

sub setOrden{
    my ($self) = shift;
    my ($orden) = @_;
    $self->orden($orden);
}

sub getReferencia{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->referencia));
}

sub setReferencia{
    my ($self) = shift;
    my ($referencia) = @_;
    $self->referencia($referencia);
}

sub getSimilares{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->similares));
}

sub setSimilares{
    my ($self) = shift;
    my ($similares) = @_;
    $self->similares($similares);
}

1;

