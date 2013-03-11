package C4::Modelo::AdqProveedorFormaEnvio;

use strict;
use utf8;
use C4::AR::Permisos;
use C4::AR::Utilidades;


use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'adq_proveedor_forma_envio',

    columns => [

        adq_proveedor_id    => { type => 'integer', overflow => 'truncate', length => 11, not_null => 1 },
        adq_forma_envio_id  => { type => 'integer', overflow => 'truncate', length => 11, not_null => 1},
    ],

    relationships =>
        [
          forma_envio_ref => 
          {
            class       => 'C4::Modelo::AdqFormaEnvio',
            key_columns => { adq_forma_envio_id => 'id' },
            type        => 'one to one',
          },
          proveedor_ref => 
          {
            class       => 'C4::Modelo::AdqProveedor',
            key_columns => { adq_proveedor_id => 'id' },
            type        => 'one to one',
          },
      ],


    primary_key_columns => [ 'adq_proveedor_id' ,'adq_forma_envio_id'],

);

# ************************************************* FUNCIONES DEL MODELO | FORMA ENVIO *********************************************************

# Agrega una forma de envio a un proveedor
# parametros: id_proveedor, id_forma_envio
sub agregarFormaDeEnvioProveedor{

    my ($self) = shift;
    my ($data) = @_;

    $self->setProveedorId($data->{'id_proveedor'});
    $self->setFormaEnvioId($data->{'id_forma_envio'});

    $self->save();
    
}

# Elimina una forma de envio a un proveedor
# parametros: id_proveedor, id_forma_envio
sub eliminar{

    my ($self)      = shift;
    my ($params)    = @_;

    $self->delete();    
}

# ************************************************************Getter y Setter*******************************************************************

sub setProveedorId{
    my ($self)         = shift;
    my ($id_proveedor) = @_;
    $self->adq_proveedor_id($id_proveedor);
}

sub setFormaEnvioId{
    my ($self)           = shift;
    my ($id_forma_envio) = @_;
    $self->adq_forma_envio_id($id_forma_envio);
}

sub getFormaEnvioId{
    my ($self) = shift;
    return ($self->adq_forma_envio_id);
}

# *******************************************************FIN Getter y Setter**************************************************************

1;
