package C4::Modelo::AdqPresupuestoDetalle;

use strict;
use utf8;
use C4::AR::Permisos;
use C4::AR::Utilidades;
use C4::Modelo::AdqPresupuesto;
use C4::Modelo::AdqRecomendacionDetalle;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'adq_presupuesto_detalle',

    columns => [
        id                                 => { type => 'integer', overflow => 'truncate', not_null => 1 },
        adq_presupuesto_id                 => { type => 'integer', overflow => 'truncate', not_null => 1 },
        precio_unitario                    => { type => 'float', not_null => 1},
        cantidad                           => { type => 'integer', overflow => 'truncate', not_null => 1},
        seleccionado                       => { type => 'integer', overflow => 'truncate', length => 11, not_null => 1 },
        nro_renglon                        => { type => 'integer', overflow => 'truncate', length => 11, not_null => 1 },

    ],


    relationships =>
    [
      ref_presupuesto => 
      {
         class       => 'C4::Modelo::AdqPresupuesto',
         key_columns => {adq_presupuesto_id => 'id' },
         type        => 'one to one',
       },

    ],
    
    primary_key_columns => [ 'id' ],
    unique_key          => ['id'],

);

#----------------------------------- FUNCIONES DEL MODELO ------------------------------------------------

sub addPresupuestoDetalle{
    my ($self)   = shift;
    my ($params) = @_;

    $self->setAdqPresupuestoId($params->{'id_presupuesto'});
    $self->setNroRenglon($params->{'nro_renglon'});
    $self->setPrecioUnitario(0);
    $self->setCantidad($params->{'cantidad_ejemplares'});
    $self->setSeleccionado(1);
    $self->save();
}
#----------------------------------- FIN - FUNCIONES DEL MODELO -------------------------------------------


#----------------------------------- GETTERS y SETTERS------------------------------------------------


sub setAdqPresupuestoId {
    my ($self)        = shift;
    my ($presupuesto) = @_;
    utf8::encode($presupuesto);
    $self->adq_presupuesto_id($presupuesto);
}

sub setNroRenglon  {
    my ($self)        = shift;
    my ($nro_renglon) = @_;
    $self->nro_renglon($nro_renglon);
}

sub setPrecioUnitario {
    my ($self)   = shift;
    my ($precio) = @_;

    $self->precio_unitario($precio);
}

sub setCantidad {
    my ($self)     = shift;
    my ($cantidad) = @_;
    utf8::encode($cantidad);
    $self->cantidad($cantidad);
}

sub setSeleccionado {
    my ($self)         = shift;
    my ($seleccionado) = @_;
    utf8::encode($seleccionado);
    $self->seleccionado($seleccionado);
}

sub getId{
    my ($self) = shift;
    return ($self->id);
}

sub getAdqPresupuestoId{
    my ($self) = shift;
    return ($self->adq_presupuesto_id);
}


sub getNroRenglon {
    my ($self) = shift;
    return ($self->nro_renglon);
}


sub getPrecioUnitario  {
    my ($self) = shift;
    return ($self->precio_unitario);
}

sub getCantidad  {
    my ($self) = shift;
    return ($self->cantidad);
}

sub getSeleccionado  {
    my ($self) = shift;
    return ($self->seleccionado);

}
