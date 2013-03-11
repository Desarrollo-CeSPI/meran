package C4::Modelo::PrefAbout;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'pref_about',

    columns => [
        id              => { type => 'int', overflow => 'truncate', length => 11, not_null => 1 },
        descripcion     => { type => 'text', overflow => 'truncate', length => 65535 },
    ],

    primary_key_columns => [ 'id' ],
);

1;


sub updateInfoAbout{
    my ($self)   = shift;
    my ($params) = @_;

    $self->setDescripcion($params);

    $self->save();
}


# ------SETTERS--------------------

sub setDescripcion{
    my ($self)   = shift;
    my ($descripcion) = @_;
    $self->descripcion($descripcion);
}


# ------GETTERS--------------------

sub getDescriptcion{
    my ($self) = shift;
    return ($self->descripcion);
}
