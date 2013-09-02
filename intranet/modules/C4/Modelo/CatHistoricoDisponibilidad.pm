package C4::Modelo::CatHistoricoDisponibilidad;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'cat_historico_disponibilidad',

    columns => [
         id_detalle     => { type => 'serial', overflow => 'truncate', not_null => 1 },
         id3            => { type => 'integer', overflow => 'truncate', length => 11, not_null => 1 },
         detalle        => { type => 'varchar', overflow => 'truncate', length => 30, not_null => 1 },
         timestamp      => { type => 'timestamp', not_null => 1 },
         tipo_prestamo  => { type => 'varchar', overflow => 'truncate', length => 40, not_null => 1},
    ],

    primary_key_columns => ['id_detalle'],

    relationships => [
        nivel3 => {
#             class       => 'C4::Modelo::CatNivel3',
            class       => 'C4::Modelo::CatRegistroMarcN3',
            key_columns => { id3 => 'id' },
            type        => 'one to one',
        },
   ],
);

sub getId_detalle {
    my ($self) = shift;
    return ( $self->id_detalle );
}

sub getDetalle {
    my ($self) = shift;
    return ( $self->detalle );
}

sub setDetalle {
    my ($self)        = shift;
    my ($detalle) = @_;
    $self->detalle($detalle);
}

sub getId3 {
    my ($self) = shift;
    return ( $self->id3 );
}

sub setId3 {
    my ($self) = shift;
    my ($id3)  = @_;
    $self->id3($id3);
}

sub getFecha {
    my ($self) = shift;
    my $dateformat = C4::Date::get_date_format();
    return C4::Date::format_date( substr($self->timestamp,0,10), $dateformat );
}

sub getTipo_prestamo{
    my ($self) = shift;
    return ($self->tipo_prestamo);
}

sub setTipo_prestamo{
    my ($self) = shift;
    my ($tipo_prestamo) = @_;
    $self->tipo_prestamo($tipo_prestamo);
}

sub getTimestamp {
    my ($self) = shift;
    return ( $self->timestamp );
}

=item
agregar
Funcion que agrega al historico de disponibilidad
=cut

sub agregar {
    my ($self)      = shift;
    my ($data_hash) = @_;


#     $self->debug("HISTORICO DE DISPONIBILIDAD ==> ".$data_hash->{'id3'});
#     $self->debug("HISTORICO DE DISPONIBILIDAD ==> ".$data_hash->{'detalle'});
#     $self->debug("HISTORICO DE DISPONIBILIDAD ==> ".$data_hash->{'tipo_prestamo'});

    #Asignando data...
    $self->setId3( $data_hash->{'id3'} );
    $self->setDetalle( $data_hash->{'detalle'} );
    $self->setTipo_prestamo( $data_hash->{'tipo_prestamo'} );
    $self->save();

#     $self->debug("SE AGREGO EL HISTORICO DE DISPONIBILIDAD");
}

1;

