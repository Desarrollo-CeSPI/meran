package C4::Modelo::CircTipoPrestamoSancion;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'circ_tipo_prestamo_sancion',

    columns => [
        tipo_sancion    => { type => 'integer', overflow => 'truncate', not_null => 1 },
        tipo_prestamo   => { type => 'character', overflow => 'truncate', length => 2, not_null => 1 }
    ],

    primary_key_columns => [ 'tipo_sancion', 'tipo_prestamo' ],
	
	relationships => [
	    ref_tipo_sancion => {
            class      => 'C4::Modelo::CircTipoSancion',
            column_map => { tipo_sancion => 'tipo_sancion' },
            type       => 'one to one',
        },
	    ref_tipo_prestamo => {
            class      => 'C4::Modelo::CircRefTipoPrestamo',
            column_map => { tipo_prestamo => 'id_tipo_prestamo' },
            type       => 'one to one',
        },

    ],

);


sub getTipo_prestamo{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->tipo_prestamo));
}

sub setTipo_prestamo{
    my ($self) = shift;
    my ($tipo_prestamo) = @_;
    $self->tipo_prestamo($tipo_prestamo);
}

sub getTipo_sancion{
    my ($self) = shift;
    return ($self->tipo_sancion);
}

sub setTipo_sancion{
    my ($self) = shift;
    my ($tipo_sancion) = @_;
    $self->tipo_sancion($tipo_sancion);
}

1;

