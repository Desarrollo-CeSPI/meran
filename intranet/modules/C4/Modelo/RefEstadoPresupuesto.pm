package C4::Modelo::RefEstadoPresupuesto;

use strict;
use utf8;
use C4::AR::Permisos;
use C4::AR::Utilidades;



use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'ref_estado_presupuesto',

    columns => [
        id                              => { type => 'integer', overflow => 'truncate', not_null => 1 },
        nombre                          => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1},
    ],


    relationships =>
    [
    ],
    
    primary_key_columns => [ 'id' ],
    unique_key => ['id','nombre'],

);

#----------------------------------- GETTERS y SETTERS------------------------------------------------

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

