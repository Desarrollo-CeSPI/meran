package C4::Modelo::MapeoOai;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'mapeo_oai',

    columns => [
        id                  => { type => 'serial', overflow => 'truncate', not_null => 1 },
        campo           => { type => 'character', overflow => 'truncate', length => 3, not_null => 1 },
        subcampo        => { type => 'character', overflow => 'truncate', length => 3, not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],

);

sub getId1{
    my ($self)  = shift;

    return $self->id;
}

sub getCampo{
    my ($self) = shift;

    return $self->campo;
}

sub getSubCampo{
    my ($self) = shift;

    my @char_array = split(//,$self->subcampo);


    return @char_array[0];
}

sub setCampo{
    my ($self)  = shift;
    my ($campo) = @_;

    $self->campo($campo);
}

sub setSubCampo{
    my ($self)  = shift;
    my ($subcampo) = @_;

    $self->subcampo($subcampo);
}

1;