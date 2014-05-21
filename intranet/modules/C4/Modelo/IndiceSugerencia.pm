package C4::Modelo::IndiceSugerencia;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'indice_sugerencia',

    columns => [
        id              => { type => 'serial', overflow => 'truncate', not_null => 1 },
        keyword         => { type => 'text', overflow => 'truncate', not_null => 1 },
        trigrams        => { type => 'text', overflow => 'truncate', not_null => 1 },
        freq            => { type => 'integer', default => '0', not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],
);

sub getId{
    my ($self)  = shift;
    return $self->id;
}

sub setId{
    my ($self)  = shift;
    my ($id)   = @_;
    $self->id($id);
}

sub getKeyword{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->keyword));
}

sub setKeyword{
    my ($self)          = shift;
    my ($keyword)   = @_;
    $self->keyword($keyword);
}

sub getTrigrams{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->trigrams));
}

sub setTrigrams{
    my ($self)          = shift;
    my ($trigrams)   = @_;
    $self->trigrams($trigrams);
}

sub getFreq{
    my ($self)  = shift;
    return $self->freq;
}

sub setFreq{
    my ($self)  = shift;
    my ($freq)   = @_;
    $self->freq($freq);
}
1;

