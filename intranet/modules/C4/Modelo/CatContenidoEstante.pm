package C4::Modelo::CatContenidoEstante;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'cat_contenido_estante',

    columns => [
        id_estante  => { type => 'integer', overflow => 'truncate', not_null => 1 },
        id2         => { type => 'integer', overflow => 'truncate', not_null => 1 },
    ],

  primary_key_columns => [ 'id_estante','id2' ],

    relationships => [
        estante  => {
            class       => 'C4::Modelo::CatEstante',
            key_columns => { id_estante => 'id' },
            type        => 'one to one',
        },

        nivel2  => {
            class       => 'C4::Modelo::CatRegistroMarcN2',
            key_columns => { id2 => 'id' },
            type        => 'one to one',
        },
    ],
);

use C4::Modelo::CatEstante;

sub getId2{
    my ($self) = shift;
    return ($self->id2);
}

sub setId2{
    my ($self) = shift;
    my ($id2) = @_;
    $self->id2($id2);
}

sub getId_estante{
    my ($self) = shift;
    return ($self->id_estante);
}

sub setId_estante{
    my ($self) = shift;
    my ($id_estante) = @_;
    $self->id_estante($id_estante);
}
1;

