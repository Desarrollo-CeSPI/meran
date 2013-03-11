package C4::Modelo::LogoEtiquetas;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'logoEtiquetas',

    columns => [
        id              => { type => 'serial', overflow => 'truncate', length => 16 },
        nombre          => { type => 'varchar', overflow => 'truncate', not_null => 1, length => 256 },
        imagenPath      => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1 },
        ancho           => { type => 'varchar', overflow => 'truncate', length => 128 },
        alto            => { type => 'varchar', overflow => 'truncate', length => 128 },
    ],

    primary_key_columns => [ 'id' ],

);


sub agregar{

    my ($self) = shift;
    my ($data_hash) = @_;

    $self->setImagenPath($data_hash->{'imagenPath'});
    $self->setNombre('DEO-booklabels');

    $self->save();

}

sub getId{
    my ($self) = shift;

    return ($self->id);
}

sub getNombre{
    my ($self) = shift;

    return ($self->nombre);
}

sub setNombre{
    my ($self) = shift;
    my ($nombre) = @_;

    $self->nombre($nombre);
}

sub getAncho{
    my ($self) = shift;

    return $self->ancho;
}

sub setAncho{
    my ($self)  = shift;
    my ($ancho) = @_;

    $self->ancho($ancho);
}

sub getAlto{
    my ($self) = shift;

    return $self->alto;
}

sub setAlto{
    my ($self) = shift;
    my ($alto) = @_;

    $self->alto($alto);
}


sub getImagenPath{
    my ($self) = shift;

    return $self->imagenPath;
}

sub setImagenPath{
    my ($self) = shift;
    my ($imagenPath) = @_;

    $self->imagenPath($imagenPath);
}

# FIN GETTERS Y SETTERS

1;
