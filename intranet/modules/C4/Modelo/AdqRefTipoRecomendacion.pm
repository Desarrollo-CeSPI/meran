package C4::Modelo::AdqRefTipoRecomendacion;

use strict;
use utf8;
use C4::AR::Permisos;
use C4::AR::Utilidades;


use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'adq_ref_tipo_recomendacion',

    columns => [
        id                              => { type => 'integer', overflow => 'truncate', not_null => 1 },
        tipo_recomendacion              => { type => 'varchar', overflow => 'truncate',length => 255, not_null => 1},
    ],


    relationships =>
    [

    ],
    
    primary_key_columns => [ 'id' ],
    unique_key          => ['id'],

);

#----------------------------------- GETTERS y SETTERS------------------------------------------------

sub setTipoRecomendacion{
    my ($self)    = shift;
    my ($tipoRec) = @_;
    utf8::encode($tipoRec);
    $self->tipo_recomendacion($tipoRec);
}

sub getId{
    my ($self) = shift;
    return ($self->id);
}

sub getTipoRecomendacion{
    my ($self) = shift;
    return ($self->tipo_recomendacion);

}

#----------------------------------- FIN GETTERS y SETTERS----------------------------------------------
