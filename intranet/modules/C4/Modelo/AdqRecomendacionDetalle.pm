package C4::Modelo::AdqRecomendacionDetalle;

use strict;
use utf8;
use C4::AR::Permisos;
use C4::AR::Utilidades;
use C4::Modelo::AdqRecomendacion;
use C4::Modelo::AdqRecomendacionDetalle;
#use C4::Modelo::CatRegistroMarcN2;
use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'adq_recomendacion_detalle',

    columns => [  

          id                    => { type => 'integer', overflow => 'truncate', not_null => 1 },  
          adq_recomendacion_id  => { type => 'integer', overflow => 'truncate', not_null => 1 },  
          cat_nivel2_id         => { type => 'integer', overflow => 'truncate', not_null => 1 },
          autor                 => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1},
          titulo                => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1},
          lugar_publicacion     => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1},
          editorial             => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1},
          fecha_publicacion     => { type => 'varchar', overflow => 'truncate'},
          coleccion             => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1},
          isbn_issn             => { type => 'varchar', overflow => 'truncate', length => 45, not_null => 1},
          cantidad_ejemplares   => { type => 'integer', overflow => 'truncate', length => 5, not_null => 1 },  
          motivo_propuesta      => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1},
          comentario            => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1},
          reserva_material      => { type => 'integer', overflow => 'truncate', not_null => 1 },
        
    ],

    relationships =>
    [
      ref_adq_recomendacion => 
      {
         class       => 'C4::Modelo::AdqRecomendacion',
         key_columns => {adq_recomendacion_id => 'id' },
         type        => 'one to one',
       },
      
      ref_cat_nivel2 => 
      {
        class       => 'C4::Modelo::CatRegistroMarcN2',
        key_columns => { cat_nivel2_id => 'id' },
        type        => 'one to one',
      },

    ],
    
    primary_key_columns => [ 'id' ],
    unique_key          => ['id'],

);


sub eliminar{
    my ($self)      = shift;
    my ($params)    = @_;

    $self->delete();    
}

sub agregarRecomendacionDetalle{
    my ($self)   = shift;
    my ($params) = @_;

    $self->setAdqRecomendacionId($params->{'id_recomendacion'});
    
    if ($params->{'nivel_2'}) {
      $self->setCatNivel2Id($params->{'nivel_2'});
    }
    $self->setAutor($params->{'autor'});
    $self->setTitulo($params->{'titulo'});
    $self->setLugarPublicacion($params->{'lugar_publicacion'});
    $self->setEditorial($params->{'editorial'});
    $self->setFechaPublicacion($params->{'fecha'});
    $self->setColeccion($params->{'coleccion'});
    $self->setIsbnIssn($params->{'isbn_issn'});
    $self->setCantidadEjemplares($params->{'cantidad_ejemplares'});
    $self->setMotivoPropuesta($params->{'motivo_propuesta'});
    $self->setComentario($params->{'comentarios'});
    $self->setReservaMaterial($params->{'reservar'});
  
    $self->save();

}

sub setearCantidad{
    my ($self)     = shift;
    my ($cantidad) = @_;
    $self->setCantidadEjemplares($cantidad);
    $self->save();
}

sub updateRecomendacionDetalle{

    my ($self)   = shift;
    my ($params) = @_;

    $self->setCatNivel2Id($params->{'cat_nivel'});
    $self->setAutor($params->{'autor'});
    $self->setTitulo($params->{'titulo'});
    $self->setLugarPublicacion($params->{'lugar_publicacion'});
    $self->setEditorial($params->{'editorial'});
    $self->setFechaPublicacion($params->{'fecha_publicacion'});
    $self->setColeccion($params->{'coleccion'});
    $self->setIsbnIssn($params->{'isbn'});
    $self->setCantidadEjemplares($params->{'cantidad_ejemplares'});
    $self->setMotivoPropuesta($params->{'motivo_propuesta'});
    $self->setComentario($params->{'comentario'});
    $self->setReservaMaterial($params->{'reserva_material'});

    $self->save();
}


#----------------------------------- GETTERS y SETTERS------------------------------------------------

sub setAdqRecomendacionId{
    my ($self)          = shift;
    my ($recomendacion) = @_;
    utf8::encode($recomendacion);
    $self->adq_recomendacion_id($recomendacion);
}

sub setCatNivel2Id{
    my ($self) = shift;
    my ($cat)  = @_;
    $self->cat_nivel2_id($cat);
}

sub setAutor{
    my ($self)  = shift;
    my ($autor) = @_;
    utf8::encode($autor);
    $self->autor($autor);
}

sub setTitulo{
    my ($self)   = shift;
    my ($titulo) = @_;
    utf8::encode($titulo);
    $self->titulo($titulo);
}

sub setLugarPublicacion{
    my ($self)         = shift;
    my ($lugar_public) = @_;
    utf8::encode($lugar_public);
    $self->lugar_publicacion($lugar_public);
}

sub setEditorial{
    my ($self)      = shift;
    my ($editorial) = @_;
    utf8::encode($editorial);
    $self->editorial($editorial);
}

sub setFechaPublicacion{
    my ($self)         = shift;
    my ($fecha_public) = @_;
    utf8::encode($fecha_public);
    $self->fecha_publicacion($fecha_public);
}

sub setColeccion{
    my ($self)      = shift;
    my ($coleccion) = @_;
    utf8::encode($coleccion);
    $self->coleccion($coleccion);
}

sub setIsbnIssn {
    my ($self) = shift;
    my ($isbn_issn) = @_;
    utf8::encode($isbn_issn);
    $self->isbn_issn($isbn_issn);
}

sub setCantidadEjemplares {
    my ($self)            = shift;
    my ($cant_ejemplares) = @_;
    if (C4::AR::Validator::countAlphaChars($cant_ejemplares) == 0){
      $self->cantidad_ejemplares($cant_ejemplares);
    }  

 
}

sub setMotivoPropuesta {
    my ($self)   = shift;
    my ($motivo) = @_;
    utf8::encode($motivo);
    $self->motivo_propuesta($motivo);
}

sub setComentario {
    my ($self)       = shift;
    my ($comentario) = @_;
    utf8::encode($comentario);
    $self->comentario($comentario);
}

sub setReservaMaterial {
    my ($self)             = shift;
    my ($reserva_material) = @_;
    $self->reserva_material($reserva_material);
}

sub getId{
    my ($self) = shift;
    return ($self->id);
}

sub getAdqRecomendacionId{
    my ($self) = shift;
    return ($self->adq_recomendacion_id);
}

sub getCatNivel2Id{
    my ($self) = shift;
    return ($self->cat_nivel2_id);
}

sub getAutor{
    my ($self) = shift;
    return ($self->autor);
}

sub getTitulo{
    my ($self) = shift;
    return ($self->titulo);
}

sub getLugarPublicacion{
    my ($self) = shift;
    return ($self->lugar_publicacion);
}

sub getEditorial{
    my ($self) = shift;
    return ($self->editorial);
}

sub getFechaPublicacion{
    my ($self) = shift;
    return ($self->fecha_publicacion);
}

sub getColeccion{
    my ($self) = shift;
    return ($self->coleccion);
}

sub getIsbnIssn{
    my ($self) = shift;
    return ($self->isbn_issn);
}

sub getCantidadEjemplares{
    my ($self) = shift;
    return ($self->cantidad_ejemplares);
}

sub getMotivoPropuesta{
    my ($self) = shift;
    return ($self->motivo_propuesta);
}
        
sub getComentario{
    my ($self) = shift;
    return ($self->comentario);
}
 
sub getReservaMaterial{
    my ($self) = shift;
    return ($self->reserva_material);
}   

#----------------------------------- FIN GETTERS y SETTERS------------------------------------------------          
