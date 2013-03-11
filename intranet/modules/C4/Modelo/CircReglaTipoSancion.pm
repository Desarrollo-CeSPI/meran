package C4::Modelo::CircReglaTipoSancion;

use strict;
use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'circ_regla_tipo_sancion',

    columns => [
        tipo_sancion     => { type => 'integer', overflow => 'truncate', not_null => 1 },
        regla_sancion    => { type => 'integer', overflow => 'truncate', not_null => 1 },
        orden            => { type => 'integer', overflow => 'truncate', default => 1, not_null => 1 },
        cantidad         => { type => 'integer', overflow => 'truncate', default => 1, not_null => 1 },
    ],

    primary_key_columns => [ 'tipo_sancion', 'regla_sancion' ],

    relationships => [
        ref_regla => {
            class      => 'C4::Modelo::CircReglaSancion',
            column_map => { regla_sancion => 'regla_sancion' },
            type       => 'one to one',
        },
        sancion => {
            class      => 'C4::Modelo::CircTipoSancion',
            column_map => { tipo_sancion => 'tipo_sancion' },
            type       => 'one to one',
        },
    ],
);

sub getTipo_sancion{
    my ($self) = shift;
    return ($self->tipo_sancion);
}

sub setTipo_sancion{
    my ($self) = shift;
    my ($tipo_sancion) = @_;
    $self->tipo_sancion($tipo_sancion);
}

sub getRegla_sancion{
    my ($self) = shift;
    return ($self->regla_sancion);
}

sub setRegla_sancion{
    my ($self) = shift;
    my ($regla_sancion) = @_;
    $self->regla_sancion($regla_sancion);
}

sub getOrden{
    my ($self) = shift;
    return ($self->orden);
}

sub setOrden{
    my ($self) = shift;
    my ($orden) = @_;
    $self->orden($orden);
}

sub getCantidad{
    my ($self) = shift;
    return ($self->cantidad);
}

sub setCantidad{
    my ($self) = shift;
    my ($cantidad) = @_;
    $self->cantidad($cantidad);
}
1;

