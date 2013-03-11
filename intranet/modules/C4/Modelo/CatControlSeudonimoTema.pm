package C4::Modelo::CatControlSeudonimoTema;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'cat_control_seudonimo_tema',

    columns => [
        id_tema             => { type => 'integer', overflow => 'truncate', not_null => 1 },
        id_tema_seudonimo   => { type => 'integer', overflow => 'truncate', not_null => 1 },
    ],

    primary_key_columns => [ 'id_tema', 'id_tema_seudonimo' ],


    relationships =>
        [
        tema => 
        {
            class       => 'C4::Modelo::CatTema',
            key_columns => { id_tema => 'id' },
            type        => 'one to one',
        },
        seudonimo => 
        {
            class       => 'C4::Modelo::CatTema',
            key_columns => { id_tema_seudonimo => 'id' },
            type        => 'one to one',
        },
        ],
    );

sub agregar{
    my ($self)=shift;
    my ($id_tema,$id_tema_seudonimo)=@_;

    $self->setIdTema($id_tema);
    $self->setIdTemaSeudonimo($id_tema_seudonimo);

    $self->save();
}

sub getIdTema{
    my ($self)=shift;
    return ($self->id_tema);
}

sub setIdTema{
    my ($self)=shift;
    my ($id_tema) = @_;
    return ($self->id_tema($id_tema));
}

sub getIdTemaSeudonimo{
    my ($self)=shift;
    return ($self->id_tema_seudonimo);
}

sub setIdTemaSeudonimo{
    my ($self)=shift;
    my ($id_tema_seudonimo) = @_;
    return ($self->id_tema_seudonimo($id_tema_seudonimo));
}

1;

