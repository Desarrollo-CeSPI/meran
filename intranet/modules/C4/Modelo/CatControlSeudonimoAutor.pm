package C4::Modelo::CatControlSeudonimoAutor;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'cat_control_seudonimo_autor',

    columns => [
        id_autor            => { type => 'integer', overflow => 'truncate', not_null => 1 },
        id_autor_seudonimo  => { type => 'integer', overflow => 'truncate', not_null => 1 },
    ],

    primary_key_columns => [ 'id_autor', 'id_autor_seudonimo' ],

    relationships =>
    [
      autor => 
      {
        class       => 'C4::Modelo::CatAutor',
        key_columns => { id_autor => 'id' },
        type        => 'one to one',
      },
      seudonimo => 
      {
        class       => 'C4::Modelo::CatAutor',
        key_columns => { id_autor_seudonimo => 'id' },
        type        => 'one to one',
      },
    ],
);

sub agregar{
    my ($self)=shift;
    my ($id_autor,$id_autor_seudonimo)=@_;

    $self->setIdAutor($id_autor);
    $self->setIdAutorSeudonimo($id_autor_seudonimo);

    $self->save();
}

sub getIdAutor{
    my ($self)=shift;
    return ($self->id_autor);
}

sub setIdAutor{
    my ($self)=shift;
    my ($id_autor) = @_;
    return ($self->id_autor($id_autor));
}

sub getIdAutorSeudonimo{
    my ($self)=shift;
    return ($self->id_autor_seudonimo);
}

sub setIdAutorSeudonimo{
    my ($self)=shift;
    my ($id_autor_seudonimo) = @_;
    return ($self->id_autor_seudonimo($id_autor_seudonimo));
}

1;

