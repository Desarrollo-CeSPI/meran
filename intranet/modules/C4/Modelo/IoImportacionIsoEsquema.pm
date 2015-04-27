package C4::Modelo::IoImportacionIsoEsquema;

use strict;
use utf8;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'io_importacion_iso_esquema',

    columns => [
        id                        => { type => 'integer', overflow => 'truncate', length => 11, not_null => 1 },
        nombre                    => { type => 'varchar',     overflow => 'truncate', length => 255,  not_null => 1},
        descripcion               => { type => 'text', overflow => 'truncate'},
    ],


    relationships =>
    [
      detalle =>
      {
         class       => 'C4::Modelo::IoImportacionIsoEsquemaDetalle',
         key_columns => {id => 'id_importacion_esquema' },
         type        => 'one to many',
       },

    ],

    primary_key_columns => [ 'id' ],
    unique_key          => ['id'],

);

#----------------------------------- FUNCIONES DEL MODELO ------------------------------------------------

sub agregar{
    my ($self)   = shift;
    my ($params) = @_;

    $self->setNombre($params->{'nombre'});
    $self->setDescripcion($params->{'descripcion'});

    $self->save();
}
#----------------------------------- FIN - FUNCIONES DEL MODELO -------------------------------------------



#----------------------------------- GETTERS y SETTERS------------------------------------------------

sub setNombre{
    my ($self) = shift;
    my ($nombre) = @_;
    utf8::encode($nombre);
    $self->nombre($nombre);
}

sub setDescripcion{
    my ($self)  = shift;
    my ($descripcion) = @_;
    $self->descripcion($descripcion);
}

sub getId{
    my ($self) = shift;
    return ($self->id);
}

sub getNombre{
    my ($self) = shift;
    return $self->nombre;
}

sub getDescripcion{
    my ($self)  = shift;
    return $self->descripcion;
}


sub getDetalleSubcamposByCampoDestino{
    my ($self)  = shift;
    my ($campo) = @_;

    require C4::Modelo::IoImportacionIsoEsquemaDetalle;
    require C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager;

    my @filtros;
    push(@filtros,(id_importacion_esquema   => { eq => $self->getId }));
    push(@filtros,(campo_destino            => { eq => $campo}));

    my $detalleTemp = C4::Modelo::IoImportacionIsoEsquemaDetalle->new();
    my $ordenAux= $detalleTemp->sortByString('orden');
    my $detalle_completo = C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager->get_io_importacion_iso_esquema_detalle(
                                                                                        query => \@filtros,
                                                                                        distinct => 1,
                                                                                        select => [ 'subcampo_destino' ],
                                                                                        );
    ########### FIXME!
    return $detalle_completo;
}

sub getDetalleByCampoSubcampoDestino{
    my ($self)  = shift;
    my ($campo,$subcampo) = @_;

    require C4::Modelo::IoImportacionIsoEsquemaDetalle;
    require C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager;

    my @filtros;
    push(@filtros,(id_importacion_esquema   => { eq => $self->getId }));
    push(@filtros,(campo_destino            => { eq => $campo}));
    push(@filtros,(subcampo_destino         => { eq => $subcampo }));

    my $detalleTemp = C4::Modelo::IoImportacionIsoEsquemaDetalle->new();
    my $ordenAux= $detalleTemp->sortByString('orden');
    my $detalle_completo = C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager->get_io_importacion_iso_esquema_detalle(
                                                                                        query => \@filtros,
                                                                                        sort_by => $ordenAux,
     );

    return $detalle_completo;
}


sub getDetalleDestino{
    my ($self)  = shift;

    require C4::Modelo::IoImportacionIsoEsquemaDetalle;
    require C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager;

    my @filtros;
    push(@filtros,(id_importacion_esquema   => { eq => $self->getId }));
    push(@filtros,(campo_destino            => { ne => undef}));
    push(@filtros,(subcampo_destino         => { ne => undef}));

    my $detalleTemp = C4::Modelo::IoImportacionIsoEsquemaDetalle->new();
    my $ordenAux= $detalleTemp->sortByString('orden');
    my $detalle_completo = C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager->get_io_importacion_iso_esquema_detalle(
                                                                                        distinct => 1,
                                                                                        select => [ 'campo_destino','subcampo_destino' ],
                                                                                        query => \@filtros,
                                                                                        sort_by => $ordenAux,
     );

    return $detalle_completo;
}



sub getDetalleByCampoSubcampoOrigen{
    my ($self)  = shift;
    my ($campo,$subcampo) = @_;

    require C4::Modelo::IoImportacionIsoEsquemaDetalle;
    require C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager;

    my @filtros;
    push(@filtros,(id_importacion_esquema   => { eq => $self->getId }));
    push(@filtros,(campo_origen            => { eq => [lc($campo),uc($campo)]}));
    push(@filtros,(subcampo_origen            => { eq => $subcampo}));
    push(@filtros,(campo_destino            => { ne => undef}));
    my $detalleTemp = C4::Modelo::IoImportacionIsoEsquemaDetalle->new();
    my $ordenAux= $detalleTemp->sortByString('orden');
    my $detalle_completo = C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager->get_io_importacion_iso_esquema_detalle(
                                                                                        query => \@filtros,
                                                                                        distinct => 1,
                                                                                        select => ['campo_destino', 'subcampo_destino' ],
                                                                                        );
    ########### FIXME!
    return $detalle_completo->[0];
}