package C4::Modelo::AdqProveedorTipoMaterial;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'adq_proveedor_tipo_material',

    columns => [
        proveedor_id        => { type => 'integer', overflow => 'truncate', length => 11, not_null => 1},
        tipo_material_id    => { type => 'integer', overflow => 'truncate', length => 11, not_null => 1},
    ],
    
     relationships =>
        [
          material_ref => 
          {
            class       => 'C4::Modelo::AdqTipoMaterial',
            key_columns => { tipo_material_id => 'id' },
            type        => 'one to one',
          },
          proveedor_ref => 
          {
            class       => 'C4::Modelo::AdqProveedor',
            key_columns => { proveedor_id => 'id' },
            type        => 'one to one',
          },
      ],

    primary_key_columns => [ 'proveedor_id', 'tipo_material_id' ],

);

# ************************************************* FUNCIONES DEL MODELO | TIPO MATERIAL ********************************************************

# Agrega un tipo de material a un proveedor
# parametros: id_proveedor, id_tipo_material
sub agregarMaterialProveedor{

    my ($self) = shift;
    my ($data) = @_;

    $self->setProveedorId($data->{'id_proveedor'});
    $self->setMaterialId($data->{'id_material'});

    $self->save();
    
}

# Elimina una material a un proveedor
# parametros: id_proveedor, id_material
sub eliminar{

    my ($self)      = shift;
    my ($params)    = @_;

    $self->delete();    
}



# ************************************************************Getter y Setter*******************************************************************

sub setProveedorId{
    my ($self)         = shift;
    my ($id_proveedor) = @_;
    $self->proveedor_id($id_proveedor);
}

sub setMaterialId{
    my ($self)        = shift;
    my ($id_material) = @_;
    $self->tipo_material_id($id_material);
}

sub getMaterialId{
    my ($self) = shift;
    return ($self->tipo_material_id);
}

# *********************************************************FIN Getter y Setter*****************************************************************

1;
