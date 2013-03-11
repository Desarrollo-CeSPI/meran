package C4::Modelo::CatControlSinonimoEditorial;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'cat_control_sinonimo_editorial',

    columns => [
        id   => { type => 'serial', overflow => 'truncate', not_null => 1 },
        editorial => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1 },
    ],

    primary_key_columns => [ 'id', 'editorial' ],
);


sub agregar{

    my ($self)=shift;
    my ($sinonimo,$id_editorial)=@_;

    $self->setEditorial($sinonimo);
    $self->setId($id_editorial);

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

sub getEditorial{
    my ($self)=shift;
    return ($self->editorial);
}

sub setEditorial{
    my ($self)=shift;
    my ($editorial) = @_;
    return ($self->editorial($editorial));
}

1;

