package C4::Modelo::IoImportacionIsoEsquemaDetalle;

use strict;
use utf8;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'io_importacion_iso_esquema_detalle',

    columns => [
        id                          => { type => 'integer',     overflow => 'truncate', length => 11,   not_null => 1 },
        id_importacion_esquema      => { type => 'integer',     overflow => 'truncate', length => 11,   not_null => 1},
        campo_origen                => { type => 'character',   overflow => 'truncate', length => 3,    not_null => 1},
        subcampo_origen             => { type => 'character',   overflow => 'truncate', length => 1,    not_null => 1},
        campo_destino               => { type => 'character',   overflow => 'truncate', length => 3,    },
        subcampo_destino            => { type => 'character',   overflow => 'truncate', length => 1,    },
        nivel                       => { type => 'integer',     overflow => 'truncate', length => 2,   },
        ignorar                     => { type => 'integer',     overflow => 'truncate', length => 2,   not_null => 1, default => 0},
        orden                       => { type => 'integer',     overflow => 'truncate', length => 2, default => 0  },
        separador                   => { type => 'varchar', 	overflow => 'truncate', length => 32},


    ],


    relationships =>
    [
      esquema =>
      {
        class       => 'C4::Modelo::IoImportacionIsoEsquema',
         key_columns => {id_importacion_esquema => 'id' },
         type        => 'one to one',
       },

    ],

    primary_key_columns => [ 'id' ],
    unique_key          => ['id_importacion_esquema','campo_origen','subcampo_origen','campo_destino','subcampo_destino','orden']
);

#----------------------------------- FUNCIONES DEL MODELO ------------------------------------------------

sub agregar{
    my ($self)   = shift;
    my ($params) = @_;

    $self->setIdImportacionEsquema($params->{'id_importacion_esquema'});
    $self->setCampoOrigen($params->{'campo'});
    $self->setSubcampoOrigen(lc($params->{'subcampo'}));

    $self->save();
}
#----------------------------------- FIN - FUNCIONES DEL MODELO -------------------------------------------



#----------------------------------- GETTERS y SETTERS------------------------------------------------

#esto arma el destino dependiendo del campo y subcampo, y busca todo ese conjunto
sub getDestino{
    my ($self) = shift;

    my $campo_origen = $self->getCampoOrigen;
    my $subcampo_origen = $self->getSubcampoOrigen;
    
    my @filtros;

    push(@filtros,(id_importacion_esquema => {eq => $self->getIdImportacionEsquema}));
    push (@filtros, (campo_origen => {eq =>$campo_origen}) );
    push (@filtros, (subcampo_origen => {eq =>$subcampo_origen}) );

    my $matches = C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager->get_io_importacion_iso_esquema_detalle(query => \@filtros,);
    
    
    my $destino_string = "";
    foreach my $destino (@$matches){
    	if (C4::AR::Utilidades::validateString($destino->getCampoDestino)){
    	   $destino_string .= $destino->getCampoDestino."\$".(lc $destino->getSubcampoDestino)." ";
    	}
    }
    
    return $destino_string;
	
}

sub setIdImportacionEsquema {
    my ($self) = shift;
    my ($esquema) = @_;
    $self->id_importacion_esquema($esquema);
}

sub setCampoOrigen{
    my ($self)  = shift;
    my ($campo) = @_;
    $self->campo_origen($campo);
}

sub setSubcampoOrigen{
    my ($self)  = shift;
    my ($subcampo) = @_;
    $self->subcampo_origen($subcampo);
}

sub setCampoDestino{
    my ($self)  = shift;
    my ($campo) = @_;
    $self->campo_destino($campo);
}

sub setSubcampoDestino{
    my ($self)  = shift;
    my ($subcampo) = @_;
    $self->subcampo_destino($subcampo);
}

sub getId{
    my ($self) = shift;
    return ($self->id);
}

sub getIdImportacionEsquema {
    my ($self) = shift;
    return $self->id_importacion_esquema;
}

sub getCampoOrigen{
    my ($self)  = shift;
    return $self->campo_origen;
}

sub getSubcampoOrigen{
    my ($self)  = shift;
    return $self->subcampo_origen;
}

sub getCampoDestino{
    my ($self)  = shift;
    return $self->campo_destino;
}

sub getSubcampoDestino{
    my ($self)  = shift;
    return $self->subcampo_destino;
}

sub getNivel{
    my ($self)  = shift;
    return $self->nivel;
}

sub setNivel{
    my ($self)  = shift;
    my ($nivel) = @_;
    $self->nivel($nivel);
}

sub getIgnorar{
    my ($self)  = shift;
    return $self->ignorar;
}

sub getIgnorarFront{
    my ($self)  = shift;
    return (C4::AR::Utilidades::translateYesNo_fromNumber($self->ignorar));
}

sub setIgnorar{
    my ($self)  = shift;
    my ($value) = @_;

    $self->ignorar($value);
}

sub setIgnorarFront{
    my ($self)  = shift;
    my ($value) = @_;
    use C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager;

    $value = C4::AR::Utilidades::translateYesNo_toNumber($value);
    my @filtros;

    push(@filtros,(id_importacion_esquema => {eq => $self->getIdImportacionEsquema}));
    push(@filtros,(campo_origen => {eq => $self->getCampoOrigen}));
    push(@filtros,(subcampo_origen => {eq => $self->getSubcampoOrigen}));

    my $detalle_esquema = C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager->update_io_importacion_iso_esquema_detalle(
                                                                                                        where => \@filtros,
                                                                                                        set => { ignorar => $value },
    );    
}

sub getOrden{
    my ($self)  = shift;
    return ($self->orden);
}

sub setOrden{
    my ($self)  = shift;
    my ($orden) = @_;
    $self->orden($orden);
}

sub getSeparador{
    my ($self)  = shift;
    my $value = $self->separador; 
    chop($value); #quito el | agregado 
    return ($value); 
}

sub setSeparador{
    my ($self)  = shift;
    my ($separador) = @_;
    
    if (!C4::AR::Utilidades::validateString($separador)){
        $separador = " ";
    }
    $self->separador($separador."|"); # se agrega el | para delimitar el string (PROBLEMA DE STRINGS EN MYSQL: QUITA LOS ESPACIOS FINALES)
}

sub setNextOrden{
    my ($self)  = shift;
    
    use C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager;
    
    my @filtros;

    push(@filtros,(id_importacion_esquema => {eq => $self->getIdImportacionEsquema}));
    push(@filtros,(campo_origen => {eq => $self->getCampoOrigen}));
    push(@filtros,(subcampo_origen => {eq => $self->getSubcampoOrigen}));

    my $detalle_esquema = C4::Modelo::IoImportacionIsoEsquemaDetalle::Manager->get_io_importacion_iso_esquema_detalle(
                                                                                                        query => \@filtros,
                                                                                                        sort_by => ['orden DESC'],
    );
    
    my $new_orden = $detalle_esquema->[0]->getOrden();

    $self->setOrden(++$new_orden);    
	
}
