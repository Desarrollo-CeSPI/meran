package C4::Modelo::AdqPresupuesto;

use strict;
use utf8;
use C4::AR::Permisos;
use C4::AR::Utilidades;
use C4::Modelo::AdqProveedor;
use C4::Modelo::RefEstadoPresupuesto;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'adq_presupuesto',

    columns => [
        id                              => { type => 'integer', overflow => 'truncate', not_null => 1 },
        proveedor_id                    => { type => 'integer', overflow => 'truncate', not_null => 1},
        fecha                           => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1},
        ref_estado_presupuesto_id       => { type => 'integer', overflow => 'truncate', not_null => 1},
        ref_pedido_cotizacion_id        => { type => 'integer', overflow => 'truncate', not_null => 1},

    ],


    relationships =>
    [
      ref_proveedor => 
      {
         class       => 'C4::Modelo::AdqProveedor',
         key_columns => {proveedor_id => 'id' },
         type        => 'one to one',
       },
      
      ref_estado_presupuesto => 
      {
        class       => 'C4::Modelo::RefEstadoPresupuesto',
        key_columns => {ref_estado_presupuesto_id => 'id' },
        type        => 'one to one',
      },
      
      ref_pedido_cotizacion => 

      {
        class       => 'C4::Modelo::AdqPedidoCotizacion',
        key_columns => {ref_pedido_cotizacion_id => 'id' },
        type        => 'one to one',
      },

    ],
    
    primary_key_columns => [ 'id' ],
    unique_key          => ['id'],

);

#----------------------------------- FUNCIONES DEL MODELO ------------------------------------------------

sub addPresupuesto{
    my ($self)   = shift;
    my ($params) = @_;

    $self->setProveedorId($params->{'id_proveedor'});
    $self->setRefEstadoPresupuestoId(1);
    $self->setRefPedidoCotizacionId($params->{'pedido_cotizacion_id'});
    
    $self->save();
}
#----------------------------------- FIN - FUNCIONES DEL MODELO -------------------------------------------



#----------------------------------- GETTERS y SETTERS------------------------------------------------

sub setProveedorId{
    my ($self) = shift;
    my ($prov) = @_;
    utf8::encode($prov);
    $self->proveedor_id ($prov);
}

sub setFecha{
    my ($self)  = shift;
    my ($fecha) = @_;
    $self->fecha($fecha);
}

sub setRefEstadoPresupuestoId{
    my ($self)   = shift;
    my ($estado) = @_;
    utf8::encode($estado);
    $self->ref_estado_presupuesto_id($estado);
}

sub setRefPedidoCotizacionId{
    my ($self)   = shift;
    my ($pedido) = @_;
    utf8::encode($pedido);
    $self->ref_pedido_cotizacion_id($pedido);
}

sub getId{
    my ($self) = shift;
    return ($self->id);
}

sub getFecha{
    my ($self) = shift;
    return ($self->fecha);
}

sub getProveedorId{
    my ($self) = shift;
    return ($self->proveedor_id);
}

sub getRefEstadoPresupuestoId{
    my ($self) = shift;
    return ($self->ref_estado_presupuesto_id);
}

sub getRefPedidoCotizacionId{
    my ($self) = shift;
    return ($self-> ref_pedido_cotizacion_id);
}
