package C4::Modelo::ImagenesNovedadesOpac;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'imagenes_novedades_opac',

    columns => [
        id                  => { type => 'integer', overflow => 'truncate', length => 11, not_null => 1 },
        image_name          => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1},
        id_novedad          => { type => 'integer', overflow => 'truncate', length => 11, not_null => 1},
    ],

    primary_key_columns => [ 'id' ],
    
    relationships =>
    [
      novedad => 
      {
        class       => 'C4::Modelo::SysNovedad',
        key_columns => { id_novedad => 'id' },
        type        => 'many to one',
      },
    ]

);

# ************************************************************ FUNCIONES *****************************************************************

=item
    Agrega una tupla en la tabla
=cut
sub saveImagenNovedad{

    my ($self) = shift;
    my ($image_name, $id_novedad) = @_;

    $self->setImageName($image_name);
    $self->setIdNovedad($id_novedad);

    $self->save();

}


# *********************************************************** FIN FUNCIONES ***************************************************************



# ***************************************************** Getter y Setter *******************************************************************


sub setImageName{

    my ($self)   = shift;
    my ($image_name) = @_;
    #FIXME: hash del nombre de imagen
    
    $self->image_name($image_name);
    
}

sub setIdNovedad{

    my ($self) = shift;
    my ($id_novedad) = @_;
    $self->id_novedad($id_novedad);
    
}

sub getIdNovedad{

    my ($self) = shift;
    return ($self->id_novedad);
    
}

sub getImageName{

    my ($self)   = shift;
    return($self->image_name)
}

sub getId{

    my ($self)   = shift;
    return($self->id)
}

# *************************************************** FIN - Getter y Setter *****************************************************************

1;
