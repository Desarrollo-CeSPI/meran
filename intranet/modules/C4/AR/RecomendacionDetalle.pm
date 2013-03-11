package C4::AR::RecomendacionDetalle;

use strict;
require Exporter;
use DBI;
use C4::Modelo::AdqRecomendacion;
use C4::Modelo::AdqRecomendacion::Manager;
use C4::Modelo::AdqRecomendacionDetalle;
use C4::Modelo::AdqRecomendacionDetalle::Manager;

use vars qw(@EXPORT @ISA);
@ISA=qw(Exporter);
@EXPORT=qw(  
    &agregarDetalleARecomendacion;
    &getDetalleRecomendacionPorId;
    &eliminarDetalleRecomendacion;
   
);


sub getDetalleRecomendacionPorId {
    my ($params) = @_;
    my $detalleTemp;
    my @filtros;

    if ($params){
        push (@filtros, ( id => { eq => $params}));
        $detalleTemp = C4::Modelo::AdqRecomendacionDetalle::Manager->get_adq_recomendacion_detalle( query => \@filtros );
        return $detalleTemp->[0]
    }
 
    return 0;
}


sub eliminarDetalleRecomendacion {

     my ($id_rec_det, $msg_object) = @_;
    
     my $msg_object= C4::AR::Mensajes::create();
    
     my $detalle = C4::AR::RecomendacionDetalle::getDetalleRecomendacionPorId($id_rec_det);
 
     eval {
         $detalle->eliminar();
         $msg_object->{'error'}= 0;
         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'RC00', 'params' => []} ) ;
     };
 
     if ($@){
         #Se loguea error de Base de Datos
         &C4::AR::Mensajes::printErrorDB($@, 'B411','OPAC');
         #Se setea error para el usuario
         $msg_object->{'error'}= 1;
         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'RC01', 'params' => []} ) ;
     }

     return ($msg_object);
}



sub agregarDetalleARecomendacion{
  my ($obj, $recom_id) = @_;
   
  my %datos_recomendacion;

  my $msg_object;

  $datos_recomendacion{'id_recomendacion'}      = $recom_id;
  $datos_recomendacion{'nivel_2'}               = $obj->{'idNivel2'};
  $datos_recomendacion{'autor'}                 = $obj->{'autor'};
  $datos_recomendacion{'titulo'}                = $obj->{'titulo'};
  $datos_recomendacion{'lugar_publicacion'}     = $obj->{'lugar_publicacion'};
  $datos_recomendacion{'editorial'}             = $obj->{'editorial'};
  $datos_recomendacion{'fecha'}                 = $obj->{'fecha'};
  $datos_recomendacion{'isbn_issn'}             = $obj->{'isbn_issn'};
  $datos_recomendacion{'cantidad_ejemplares'}   = $obj->{'cant_ejemplares'};
  $datos_recomendacion{'motivo_propuesta'}      = $obj->{'motivo_propuesta'};
  $datos_recomendacion{'comentarios'}           = $obj->{'comment'};
  $datos_recomendacion{'idNivel1'}              = $obj->{'catalogo_search_hidden'};
  $datos_recomendacion{'reservar'}              = $obj->{'reservar'} || 0;
  
  # checkeo de XSS
  foreach my $dato (%datos_recomendacion){
    if($dato =~ m/script/){
      C4::AR::Debug::debug("entro a la expresion regular");
      C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'B410', 'params' => []} ) ;
      $msg_object->{'error'}= 1;
    }
  }
  
  my $recomendacion_detalle = C4::Modelo::AdqRecomendacionDetalle->new(); 

  my $db = $recomendacion_detalle->db;
  if (!($msg_object->{'error'})){
           
          # entro si no hay algun error, todos los campos ingresados son validos
          $db->{connect_options}->{AutoCommit} = 0;
          $db->begin_work;
          eval{
                  $recomendacion_detalle->agregarRecomendacionDetalle(\%datos_recomendacion);
                     
                  $msg_object->{'error'} = 0;
                  C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A001', 'params' => []});
                  $db->commit;
          };
          if ($@){
                  # TODO falta definir el mensaje "amigable" para el usuario informando que no se pudo agregar el proveedor
                  &C4::AR::Mensajes::printErrorDB($@, 'B410','OPAC');
                  $msg_object->{'error'}= 1;
                  C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'B410', 'params' => []} ) ;
                  $db->rollback;
              }
              $db->{connect_options}->{AutoCommit} = 1;
    }
    return ($msg_object,$recomendacion_detalle->getId());
}


END { }       # module clean-up code here (global destructor)

1;
__END__

