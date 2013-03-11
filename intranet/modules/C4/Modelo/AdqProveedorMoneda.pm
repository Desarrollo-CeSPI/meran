package C4::Modelo::AdqProveedorMoneda;

use strict;
use utf8;
# use DBI;
use C4::AR::Permisos;
use C4::AR::Utilidades;
use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'adq_ref_proveedor_moneda',

    columns => [
        adq_proveedor_id    => { type => 'integer', overflow => 'truncate', length => 11, not_null => 1 },
        adq_ref_moneda_id   => { type => 'integer', overflow => 'truncate', length => 11, not_null => 1},
    ],

    relationships =>
        [
          moneda_ref => 
          {
            class       => 'C4::Modelo::RefAdqMoneda',
            key_columns => { adq_ref_moneda_id => 'id' },
            type        => 'one to one',
          },
          proveedor_ref => 
          {
            class       => 'C4::Modelo::AdqProveedor',
            key_columns => { adq_proveedor_id => 'id' },
            type        => 'one to one',
          },
      ],


    primary_key_columns => [ 'adq_proveedor_id' ,'adq_ref_moneda_id'],

);


# ************************************************************** FUNCIONES *******************************************************************

# Elimina una moneda a un proveedor
# parametros: id_proveedor, id_moneda
sub eliminar{
    my ($self)      = shift;
    my ($params)    = @_;

    $self->delete();    
}


# Agrega una moneda a un proveedor
# parametros: id_proveedor, id_moneda
sub agregarMonedaProveedor{
    my ($self) = shift;
    my ($data) = @_;

    $self->setProveedorId($data->{'id_proveedor'});
    $self->setMonedaId($data->{'id_moneda'});

    $self->save();
}

# *********************************************************** FIN - FUNCIONES *****************************************************************




# ********************************************************Getter y Setter*******************************************************************

sub setProveedorId{
    my ($self)         = shift;
    my ($id_proveedor) = @_;
    $self->adq_proveedor_id($id_proveedor);
}

sub setMonedaId{
    my ($self)      = shift;
    my ($id_moneda) = @_;
    $self->adq_ref_moneda_id($id_moneda);
}

# ******************************************************FIN Getter y Setter*******************************************************************


1;
