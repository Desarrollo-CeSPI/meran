package C4::Modelo::PortadaOpac;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'portada_opac',

    columns => [
        id             => { type => 'serial', overflow => 'truncate', not_null => 1 },
        image_path     => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1 },
        footer         => { type => 'text', overflow => 'truncate', not_null => 0 },
        footer_title   => { type => 'varchar', overflow => 'truncate', length => 64, not_null => 1 },
        orden          => { type => 'integer', length => 10, default => 1, not_null => 1 },
    ],
    primary_key_columns => [ 'id' ],
);

sub agregar{
    my ($self) = shift;
    my ($data_hash) = @_;

    $self->setImagePath($data_hash->{'image_path'});
    $self->setFooter($data_hash->{'footer'});
    $self->setOrden($data_hash->{'orden'});

    $self->save();
}

sub getImagePath{
    my ($self) = shift;

    return ($self->image_path);
}

sub setImagePath{
    my ($self) = shift;
    my ($path) = @_;

    $self->image_path($path);
}

sub getFooter{
    my ($self) = shift;

    return ($self->footer);
}

sub setFooter{
    my ($self) = shift;
    my ($footer) = @_;

    $self->footer($footer);
}

sub getFooterTitle{
    my ($self) = shift;

    return ($self->footer_title);
}

sub setFooterTitle{
    my ($self) = shift;
    my ($footer_title) = @_;

    $self->footer_title($footer_title);
}

sub getOrden{
    my ($self) = shift;

    return ($self->orden);
}

sub setOrden{
    my ($self) = shift;
    my ($orden) = @_;

    $self->orden($orden);
}

1;

