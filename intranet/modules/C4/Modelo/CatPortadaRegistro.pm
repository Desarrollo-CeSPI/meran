package C4::Modelo::CatPortadaRegistro;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'cat_portada_registro',

    columns => [
        id       => { type => 'serial', overflow => 'truncate'},
        isbn => { type => 'varchar', overflow => 'truncate', length => 50,not_null => 1},
        small => { type => 'varchar', overflow => 'truncate', length => 500},
        medium => { type => 'varchar', overflow => 'truncate', length => 500},
        large  => { type => 'varchar', overflow => 'truncate', length => 500},
    ],

    primary_key_columns => [ 'id' ],
);

sub getId{
    my ($self) = shift;
    return ($self->id);
}

sub setId{
    my ($self) = shift;
    my ($id) = @_;
    $self->id($id);
}

sub getIsbn{
    my ($self) = shift;
    return ($self->isbn);
}

sub setIsbn{
    my ($self) = shift;
    my ($isbn) = @_;
    $self->isbn($isbn);
}

sub getSmall{
    my ($self) = shift;
    return ($self->small);
}

sub setSmall{
    my ($self) = shift;
    my ($small) = @_;
    $self->small($small);
}

sub getMedium{
    my ($self) = shift;
    return ($self->medium);
}

sub setMedium{
    my ($self) = shift;
    my ($medium) = @_;
    $self->medium($medium);
}

sub getLarge{
    my ($self) = shift;
    return ($self->large);
}

sub setLarge{
    my ($self) = shift;
    my ($large) = @_;
    $self->large($large);
}

1;

