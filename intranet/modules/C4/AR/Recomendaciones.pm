package C4::AR::Recomendaciones;

use strict;
require Exporter;
use DBI;
use C4::Modelo::AdqRecomendacion;
use C4::Modelo::AdqRecomendacion::Manager;
use C4::Modelo::AdqRecomendacionDetalle;
use C4::Modelo::AdqRecomendacionDetalle::Manager;
use C4::AR::RecomendacionDetalle;

use vars qw(@EXPORT @ISA);
@ISA=qw(Exporter);
@EXPORT=qw(  
    &agregarRecomendacion;
    &getRecomendacionesActivas;
    &getRecomendacionDetallePorId;
    &getRecomendaciones;
    &getRecomendacionDetalle;
    &editarCantidadEjemplares;
    &getRecomendacionPorId;
    &updateRecomendacionDetalle;
    &eliminarRecomendacion;
    &getRecomendacionesDeUsuario
);


sub eliminarDetallesRecomendacion{
      my ($params, $msg_object) = @_;
  
      my $detalles =  C4::AR::Recomendaciones::getRecomendacionDetalle($params);
      
      if ($detalles){
  
          foreach my $det (@$detalles){
              C4::AR::Utilidades::printHASH($det);
              if ($msg_object->{'error'} == 0){
                  $msg_object = C4::AR::RecomendacionDetalle::eliminarDetalleRecomendacion($det->getId()); 
              } else {
                  return $msg_object;
              }
          }

      } else {
            $msg_object->{'error'}= 0;
      }
      return $msg_object;
}


sub eliminarRecomendacion {

     my ($id_rec) = @_;
    
     my $msg_object= C4::AR::Mensajes::create();
    
     my $recomendacion = C4::AR::Recomendaciones::getRecomendacionPorId($id_rec);
 
     C4::AR::Recomendaciones::eliminarDetallesRecomendacion($id_rec, $msg_object);

     if ($msg_object->{'error'} == 0){
          eval {
              $recomendacion->eliminar();
              $msg_object->{'error'}= 0;
              C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'RC02', 'params' => []} ) ;
          };
      
          if ($@){
              #Se loguea error de Base de Datos
              &C4::AR::Mensajes::printErrorDB($@, 'B412','OPAC');
              #Se setea error para el usuario
              $msg_object->{'error'}= 1;
              C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'RC03', 'params' => []} ) ;
          }
          
          return ($msg_object);
     }
     return ($msg_object);
}



=item
    Esta funcion edita la cantidad de ejemplares de una recomendacion
    Parametros: 
                 HASH: {id_recomendacion_detalle},{cantidad de ejemplares}
=cut
sub editarCantidadEjemplares{
#   Recibe la informacion del objeto JSON.

    my ($params)        =@_;
    my $msg_object      = C4::AR::Mensajes::create();

    my $recomendacion   = getRecomendacionDetallePorId($params->{'id_recomendacion_detalle'});

    $recomendacion->setearCantidad($params->{'cantidad_ejemplares'});
}

=item
    Esta funcion agrega una recomendacion y su detalle
    Parametros: 
                HASH: {cat_nivel2_id},{autor},{titulo},{lugar_publicacion},{editorial},{fecha_publicacion}, 
                      {coleccion}, {isbn_issn}, {cantidad_ejemplares}, 
                      {motivo_propuesta}, {comentario}, {reserva_material}
=cut
sub agregarRecomendacion{
    my ($usr_socio_id) = @_;

    my $recomendacion = C4::Modelo::AdqRecomendacion->new();
    my $msg_object= C4::AR::Mensajes::create();
    my $db = $recomendacion->db;

# TODO
    #_verificarDatosProveedor($param,$msg_object);

    if (!($msg_object->{'error'})){
           
          # entro si no hay algun error, todos los campos ingresados son validos
          $db->{connect_options}->{AutoCommit} = 0;
          $db->begin_work;
          eval{
                
              $recomendacion->agregarRecomendacion($usr_socio_id);
            
              $msg_object->{'error'} = 0;
              C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A001', 'params' => []});
              $db->commit;

            };
            if ($@){
              # TODO falta definir el mensaje "amigable" para el usuario informando que no se pudo agregar el proveedor
                  &C4::AR::Mensajes::printErrorDB($@, 'B410',"OPAC");
                  $msg_object->{'error'}= 1;
                  C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'B410', 'params' => []} ) ;
                  $db->rollback;
              }

              $db->{connect_options}->{AutoCommit} = 1;
    }
    return ($recomendacion->getId());
}

=item
    Esta funcion devuelve las recomendaciones activas, con su detalle
=cut
sub getRecomendacionesActivas{

    my ($params) = @_;

    my $db                                      = C4::Modelo::AdqRecomendacionDetalle->new()->db;
    my $recomendaciones_activas_array_ref       = C4::Modelo::AdqRecomendacionDetalle::Manager->get_adq_recomendacion_detalle(   
                                                                    db => $db,
                                                                    query   => [ activa => 1 ],
                                                                    require_objects     => ['ref_adq_recomendacion'],
                                                                );

    return ($recomendaciones_activas_array_ref);
}


sub getRecomendacionesDeUsuario{

    my ($userid) = @_;
    

    my $db                                      = C4::Modelo::AdqRecomendacion->new()->db;
    my $recomendaciones_de_usuario       = C4::Modelo::AdqRecomendacion::Manager->get_adq_recomendacion(   
                                                                    db => $db,
                                                                    query   => [ usr_socio_id => $userid ],
                                                         
                                                                );

    return ($recomendaciones_de_usuario);
}



sub getRecomendaciones{

    my ($ini,$cantR)=@_;
    
#     my ($params) = @_;

    my $db                                      = C4::Modelo::AdqRecomendacion->new()->db;
    
    my $recomendaciones_activas_array_ref       = C4::Modelo::AdqRecomendacion::Manager->get_adq_recomendacion(   
                                                                    db => $db,
                                                                    query   => [ activa => 1 ],
                                                                    limit   => $cantR,
                                                                    offset  => $ini,
                                                                );

    
    my $cantidad= C4::Modelo::AdqRecomendacion::Manager->get_adq_recomendacion_count(   
                                                                    db => $db,
                                                                    query   => [ activa => 1 ],
                                                                );
     

    return($cantidad,$recomendaciones_activas_array_ref);

#     return ($recomendaciones_activas_array_ref);
}

=item
    Recupera un registro de recomendacion_detalle
    Retorna un objeto o 0 si no existe
=cut
sub getRecomendacionDetallePorId{

    my ($params) = @_;

    my $db                = C4::Modelo::AdqRecomendacionDetalle->new()->db;
    my $recomendacion     = C4::Modelo::AdqRecomendacionDetalle::Manager->get_adq_recomendacion_detalle(   
                                                                    db => $db,
                                                                    query   => [ id  => { eq => $params} ],
                                                                );          
                                         
    if( scalar(@$recomendacion) > 0){
        return ($recomendacion->[0]);
    }else{
        return 0;
    }
}



sub getRecomendacionDetalle{

    my ($params) = @_;


    my $db                = C4::Modelo::AdqRecomendacionDetalle->new()->db;
    my $recomendacion     = C4::Modelo::AdqRecomendacionDetalle::Manager->get_adq_recomendacion_detalle(   
                                                                    db => $db,
                                                                    query   => [ adq_recomendacion_id => { eq => $params} ],
                                                                );                                                    
    if( scalar(@$recomendacion) > 0){
        return ($recomendacion);
    
    }
}



=item
    Recupera un registro de recomendacion
    Retorna un objeto o 0 si no existe
=cut


sub getRecomendacionPorId{

    my ($params, $db) = @_;
    my $recomendacion     = C4::Modelo::AdqRecomendacion::Manager->get_adq_recomendacion(   
                                                                    db => $db,
                                                                    query   => [ id  => { eq => $params} ],
                                                                );
                                                                
    if( scalar($recomendacion) > 0){
        return ($recomendacion->[0]);

    }else{
        return 0;
    }
}


=item
    Actualiza la info de una recomendacion
=cut
sub updateRecomendacionDetalle{

    my ($params) = @_;
    
    my $recomendacion = getRecomendacionDetallePorId($params->{'id_recomendacion'});
    
    my $db = $recomendacion->db;
    my $msg_object;
    
    #TODO _verificarDatosRecomendacion($params,$msg_object);
    
    if (!($msg_object->{'error'})){
    
          $db->{connect_options}->{AutoCommit} = 0;
          $db->begin_work;
          eval{
              $recomendacion->updateRecomendacionDetalle($params);
              

              $msg_object->{'error'}= 0;
              C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A034', 'params' => []});
              $db->commit;
          };

          if ($@){
          # TODO falta definir el mensaje "amigable" para el usuario informando que no se pudo editar el proveedor
              &C4::AR::Mensajes::printErrorDB($@, 'B449',"INTRA");
              $msg_object->{'error'}= 1;
              C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'B449', 'params' => []} ) ;
              $db->rollback;
          }

    }
    return ($msg_object);
    
}

sub _verificarDatosRecomendacion {

     my ($data, $msg_object)    = @_;
     my $checkStatus;

     my $cat_nivel_2            = $data->{'cat_nivel'};
     my $autor                  = $data->{'autor'};
     my $titulo                 = $data->{'titulo'};
     my $lugar_publicacion      = $data->{'lugar_publicacion'};
     my $editorial              = $data->{'editorial'};
     my $fecha_publicacion      = $data->{'fecha_publicacion'};
     my $coleccion              = $data->{'coleccion'};
     my $isbn                   = $data->{'isbn'};
     my $cantidad_ejemplares    = $data->{'cantidad_ejemplares'};
     my $motivo_propuesta       = $data->{'motivo_propuesta'};
     my $comentario             = $data->{'comentario'};
     my $reserva_material       = $data->{'reserva_material'};    
     
     #TODO: 
 
}

END { }       # module clean-up code here (global destructor)

1;
__END__
