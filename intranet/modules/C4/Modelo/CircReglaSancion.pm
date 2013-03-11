package C4::Modelo::CircReglaSancion;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'circ_regla_sancion',

    columns => [
        regla_sancion => { type => 'serial', overflow => 'truncate', not_null => 1 },
        dias_sancion     => { type => 'integer', overflow => 'truncate', default => '0', not_null => 1 },
        dias_demora        => { type => 'integer', overflow => 'truncate', default => '0', not_null => 1 },
    ],

    primary_key_columns => [ 'regla_sancion' ],
);


sub getRegla_sancion{
    my ($self) = shift;
    return ($self->regla_sancion);
}

sub setRegla_sancion{
    my ($self) = shift;
    my ($regla_sancion) = @_;
    $self->regla_sancion($regla_sancion);
}

sub getDias_sancion{
    my ($self) = shift;
    return ($self->dias_sancion);
}

sub setDias_sancion{
    my ($self) = shift;
    my ($dias_sancion) = @_;
    $self->dias_sancion($dias_sancion);
}

sub getDias_demora{
    my ($self) = shift;
    return ($self->dias_demora);
}

sub setDias_demora{
    my ($self) = shift;
    my ($dias_demora) = @_;
    $self->dias_demora($dias_demora);
}

1;

