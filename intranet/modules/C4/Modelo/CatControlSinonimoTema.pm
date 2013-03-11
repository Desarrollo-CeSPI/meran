package C4::Modelo::CatControlSinonimoTema;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'cat_control_sinonimo_tema',

    columns => [
        id   => { type => 'serial', overflow => 'truncate', not_null => 1 },
        tema => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1 },
    ],

    primary_key_columns => [ 'id', 'tema' ],
);


sub agregar{

    my ($self)=shift;
    my ($sinonimo,$id_tema)=@_;

    $self->setTema($sinonimo);
    $self->setId($id_tema);

    $self->save();
}

sub getId{
    my ($self)=shift;
    return ($self->id);
}

sub setId{
    my ($self)=shift;
    my ($id) = @_;
    return ($self->id($id));
}

sub getTema{
    my ($self)=shift;
    return ($self->tema);
}

sub setTema{
    my ($self)=shift;
    my ($tema) = @_;
    return ($self->tema($tema));
}

1;

