package C4::Modelo::AdqPedidoCotizacion;

use strict;
use utf8;
use C4::Modelo::AdqPedidoCotizacion;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'adq_pedido_cotizacion',

    columns => [
        id                       => { type => 'integer', overflow => 'truncate', not_null => 1 },
        fecha                    => { type => 'timestamp', not_null => 1},
    ],
    
    primary_key_columns => [ 'id' ],
    unique_key          => ['id'],

);

#------------------------------------- FUNCIONES DEL MODELO -------------------------------------------

sub addPedidoCotizacion{
    my ($self)   = shift;
    my ($params) = @_;

    $self->save();
}

#----------------------------------- FIN - FUNCIONES DEL MODELO -------------------------------------------



#-------------------------------------- GETTERS y SETTERS------------------------------------------------

sub setId{
    my ($self) = shift;
    my ($id)   = @_;
    $self->id($id);
}

sub setFecha{
    my ($self)  = shift;
    my ($fecha) = @_;
    $self->fecha($fecha);
}


sub getId{
    my ($self) = shift;
    return ($self->id);
}

sub getFecha{
    my ($self) = shift;
    return ($self->fecha);
}

#----------------------------------- FIN - GETTERS y SETTERS------------------------------------------------
