package C4::AR::Presupuestos;

use strict;
require Exporter;
use DBI;
use C4::Modelo::AdqPresupuestoDetalle;
use C4::Modelo::AdqPresupuestoDetalle::Manager;
use C4::AR::PedidoCotizacionDetalle;


use vars qw(@EXPORT @ISA);
@ISA=qw(Exporter);
@EXPORT=qw(  
    &getAdqPresupuestoDetalle;
    $getAdqRenglonPresupuestoDetalle;
    &actualizarPresupuesto;
    &getAdqPresupuestos;
    &getPresupuestoPorID;
    &addPresupuesto;

);

# =item
#   Esta funcion agrega un Presupuesto
#       Parametros: HASH   { id_proveedor , pedido_cotizacion_id (padre del detalle) }     
# =cut
sub addPresupuesto{

    my ($param)         = @_;
    my $presupuesto     = C4::Modelo::AdqPresupuesto->new();
    my $msg_object      = C4::AR::Mensajes::create();
    my $db              = $presupuesto->db;

    if (!($msg_object->{'error'})){
        # entro si no hay algun error, todos los campos ingresados son validos
        $db->{connect_options}->{AutoCommit} = 0;
        $db->begin_work;
          
        eval{              
            my %parametros;
            $parametros{'id_proveedor'}                     = $param->{'id_proveedor'};
            $parametros{'ref_estado_presupuesto_id'}        = '1';
            $parametros{'pedido_cotizacion_id'}             = $param->{'pedido_cotizacion_id'};
                   
            # agrega un presupuesto y tiene que hacer: por cada pedido_cotizacion_detalle un presupuesto_detalle
            $presupuesto->addPresupuesto(\%parametros);
               
            # se va a agregar presupuesto_detalle con el id_presupuesto recien ingresado
            my $id_presupuesto = $presupuesto->getId();  
            
            # traer todos los pedidos_cotizacion_detalle consultando por el id del padre (pedido_cotizacion)            
            my $pedidos_cotizacion_detalle = C4::AR::PedidoCotizacionDetalle::getPedidosCotizacionPorPadre($param->{'pedido_cotizacion_id'});       
            
            # pedido_cotizacion_detalle
            for(my $i=0; $i<scalar(@{$pedidos_cotizacion_detalle}); $i++){
                my %params;
                $params{'id_presupuesto'}                   = $id_presupuesto;
                $params{'nro_renglon'}                      = $pedidos_cotizacion_detalle->[$i]->getNroRenglon();               
                $params{'cantidad_ejemplares'}              = $pedidos_cotizacion_detalle->[$i]->getCantidadEjemplares();
                   
                my $presupuesto_detalle                     = C4::Modelo::AdqPresupuestoDetalle->new(db => $db);    
                $presupuesto_detalle->addPresupuestoDetalle(\%params);
            }       
    
            $msg_object->{'error'} = 0;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A035', 'params' => []});
            $db->commit;
       };
        if ($@){
        # TODO falta definir el mensaje "amigable" para el usuario informando que no se pudo agregar el proveedor
            &C4::AR::Mensajes::printErrorDB($@, 'B449',"INTRA");
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'B449', 'params' => []} ) ;
            $db->rollback;
        }
        $db->{connect_options}->{AutoCommit} = 1;
    }
    return ($msg_object);
}

  
sub getAdqPresupuestos{
    my $presupuestos = C4::Modelo::AdqPresupuesto::Manager->get_adq_presupuesto;
    my @results;

    foreach my $presupuesto (@$presupuestos) {
        push (@results, $presupuesto);
    }

    return(\@results);
}



sub getPresupuestoPorID{
     my ( $id_presupuesto, $db) = @_;
     my @result;
  
     $db = $db || C4::Modelo::AdqPresupuesto->new()->db;

     my $presupuesto= C4::Modelo::AdqPresupuesto::Manager->get_adq_presupuesto(   
                                                                    db => $db,
                                                                    query   => [ id => { eq => $id_presupuesto} ],
                                                                );
     return $presupuesto->[0];  
}



# -------- Retorna todos los detalles para el presupuesto con id $id_presupuesto ----------------------------

sub getAdqPresupuestoDetalle{
    my ( $id_presupuesto, $db) = @_;
    my @results; 

    $db = $db || C4::Modelo::AdqPresupuestoDetalle->new()->db;

    my $detalle_array_ref = C4::Modelo::AdqPresupuestoDetalle::Manager->get_adq_presupuesto_detalle(   
                                                                    db => $db,
                                                                    query   => [ adq_presupuesto_id => { eq => $id_presupuesto} ],
                                                                    sort_by => 'nro_renglon',
                                                                );
      
     foreach my $detalle_pres (@$detalle_array_ref) {
        push (@results, $detalle_pres);
     } 
    
    
    if(scalar(@results) > 0){
        return (\@results);
    }else{
        return 0;
    }
}

# -----------------------------------------------------------------------------------------------------------

# -------- Retorna el renglon nro: $nro_renglon para el presupuesto con id $id_presupuesto ------------------


sub getAdqRenglonPresupuestoDetalle{
    my ( $id_presupuesto, $nro_renglon ,$db) = @_;
    my @results; 

    $db = $db || C4::Modelo::AdqPresupuestoDetalle->new()->db;

    my $renglon_ref = C4::Modelo::AdqPresupuestoDetalle::Manager->get_adq_presupuesto_detalle(   
                                                                    db => $db,
                                                                    query   => [ adq_presupuesto_id => { eq => $id_presupuesto}, nro_renglon => { eq => $nro_renglon} ],
#                                                                
                                                                );
    return $renglon_ref->[0];
    
}

# ------------------------------------------------------------------------------------------------------------

sub actualizarPresupuesto{
    
     my ($obj) = @_;

     my $tabla_array_ref = $obj->{'table'};
     my $pres=$obj->{'id_presupuesto'};

     my $msg_object= C4::AR::Mensajes::create();
    
     my $adq_presupuesto_detalle = C4::Modelo::AdqPresupuestoDetalle->new();
         
     my $db = $adq_presupuesto_detalle->db;
     
     $db->{connect_options}->{AutoCommit} = 0;
     $db->begin_work;
    
     my $pres_detalle = C4::AR::Presupuestos::getAdqPresupuestoDetalle($pres,$db); 
      eval{
              my $i=0;
              for my $detalle (@$pres_detalle){ 
                    my $cantidad= $tabla_array_ref->[$i]->{'Cantidad'};
                    my $precio_unitario= $tabla_array_ref->[$i]->{'PrecioUnitario'};
                    
                    
                    # --------------- VALIDACIONES DE DATOS INGRESADOS----------------------
                    if($cantidad ne "") {
                          if (!($msg_object->{'error'}) && ( ((&C4::AR::Validator::countAlphaChars($cantidad) != 0)) || (&C4::AR::Validator::countSymbolChars($cantidad) != 0) || (&C4::AR::Validator::countNumericChars($cantidad) == 0))){

                                  $msg_object->{'error'}= 1;
                                  C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A029', 'params' => []} ) ;
                                  
                          }
                    } else {
                        $msg_object->{'error'}= 1;
                        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A030', 'params' => []} ) ;        
                    }
                        
                    if($precio_unitario ne "") {
                          if (!($msg_object->{'error'}) && ( ((&C4::AR::Validator::countAlphaChars($precio_unitario) != 0)) || (C4::AR::Validator::isValidReal($precio_unitario) != 1) || (&C4::AR::Validator::countNumericChars($precio_unitario == 0)))){
                                  $msg_object->{'error'}= 1;
                                  C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A031', 'params' => []} ) ;
                          }
                    } else {
                          $msg_object->{'error'}= 1;
                          C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A032', 'params' => []} ) ;  
                    }
                    
                    # ---------------FIN VALIDACIONES ----------------------------------------                     
                    
                    $detalle->setPrecioUnitario($precio_unitario);
                    $detalle->setCantidad($cantidad);
                    $detalle->save();
                    $i++;     
              }
        
              if (!($msg_object->{'error'})){
                 
                    $msg_object->{'error'}= 0;
                    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A027', 'params' => []});
                    $db->commit;
              }   
          };
          if ($@){
                    &C4::AR::Mensajes::printErrorDB($@, 'A028',"INTRA");
                    $msg_object->{'error'}= 1;
                    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A028', 'params' => []} ) ;
                    $db->rollback;
          }
          return ($msg_object);
      }

       
END { }       # module clean-up code here (global destructor)

1;
__END__

