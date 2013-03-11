package C4::Modelo::CatRegistroMarcN2Cover;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'cat_registro_marc_n2_cover',

    columns => [
        id              => { type => 'serial', overflow => 'truncate', length => 11 },
        id2             => { type => 'integer', overflow => 'truncate', not_null => 1 },
        image_name      => { type => 'varchar', overflow => 'truncate', not_null => 1, length => 256, },
    ],

    primary_key_columns => [ 'id' ],

    relationships => [
        nivel2    => {
            class       => 'C4::Modelo::CatRegistroMarcN2',
            key_columns => { id2 => 'id' },
            type        => 'one to one',
        },
    ],

);


sub agregar{

    my ($self)              = shift;
    my ($image_name, $id2)  = @_;

    $self->setImageName($image_name);
    $self->setId2($id2);

    $self->save();

}

sub getId{
    my ($self) = shift;

    return ($self->id);
}

sub getId2{
    my ($self) = shift;

    return ($self->id2);
}

sub setId2{
    my ($self) = shift;
    my ($id2)  = @_;

    $self->id2($id2);
}

sub getImageName{
    my ($self) = shift;

    return $self->image_name;
}

sub setImageName{
    my ($self)      = shift;
    my ($imageName) = @_;

    $self->image_name($imageName);
}

# FIN GETTERS Y SETTERS

1;