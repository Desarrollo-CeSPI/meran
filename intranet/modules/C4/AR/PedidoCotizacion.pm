package C4::AR::PedidoCotizacion;

use strict;
require Exporter;
use DBI;
use C4::AR::Nivel2;
use C4::AR::Recomendaciones;
use C4::Modelo::AdqPedidoCotizacion;
use C4::Modelo::AdqPedidoCotizacion::Manager;
use C4::Modelo::AdqPedidoCotizacionDetalle;
use C4::Modelo::AdqPedidoCotizacionDetalle::Manager;
use C4::AR::Recomendaciones;
use C4::AR::PedidoCotizacion;
use C4::AR::PedidoCotizacionDetalle;

use vars qw(@EXPORT @ISA);
@ISA=qw(Exporter);
@EXPORT=qw(  
            &getAdqPedidosCotizacion;
            &getPresupuestosPedidoCotizacion;
            &getAdqPedidoCotizacionDetalle;
            &addPedidoCotizacion;
            &addPedidoCotizacion;
            &getPedidosCotizacionConDetalle;
            &getPedidosCotizacion;
            &appendPedidoCotizacion;
);


sub getPresupuestosPedidoCotizacion{
      my ($params)        =@_;
      
      my $db = C4::Modelo::AdqPresupuesto->new()->db;
      my $presupuestos = C4::Modelo::AdqPresupuesto::Manager->get_adq_presupuesto(   
                                                                    db => $db,
                                                                    query  => [ ref_pedido_cotizacion_id => $params],
                                                                );
      my @results;

      foreach my $pres (@$presupuestos) {
          push (@results, $pres);
      }

      return(\@results);

}

=item
    Esta funcion agrega pedido/s cotizacion_detalle a un pedido_cotizacion ya existente
    Parametros: (El id del pedido_cotizacion y los ids de los ejemplares a agregar)
=cut
sub appendPedidoCotizacion{

    my ($param)              = @_;
    my $msg_object           = C4::AR::Mensajes::create();
    my $pedido_cotizacion    = C4::Modelo::AdqPedidoCotizacion->new();
    my $db                   = $pedido_cotizacion->db;
    my $bool_existe_ejemplar = 0; # bool para el mensaje al cliente, donde chequea que no se agregue el mismo ejemplar dos veces

    if (!($msg_object->{'error'})){
        $db->{connect_options}->{AutoCommit} = 0;
        $db->begin_work;
    
        eval{            
            my $id_pedido_cotizacion = $param->{'pedido_cotizacion_id'};      
            
            # recorremos el array de ids de ejemplares, para por cada id obtenerlo y pasarle la info a agregar a un pedido_detalle
            for(my $i=0; $i<scalar(@{$param->{'ejemplares_ids_array'}}); $i++){

                # chequeamos que el ejemplar no este ya agregado en la base, al mismo pedido_cotizacion
              if(C4::AR::PedidoCotizacionDetalle::existeEjemplarEnPedidoCotizacion($param->{'ejemplares_ids_array'}->[$i],$id_pedido_cotizacion,$db))
              {         
              # existe el ejemplar en la base, cortar la transaccion y mostrar un mensaje al usuario.
                $msg_object->{'error'}= 1;
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A042', 'params' => []} ) ;
                $db->rollback;
                $bool_existe_ejemplar = 1;

              }else{
         
                # nivel 2
                my $ejemplar_n2 = C4::AR::Nivel2::getNivel2FromId2($param->{'ejemplares_ids_array'}->[$i]);
                # nivel 1
                my $ejemplar_n1 = C4::AR::Nivel1::getNivel1FromId1($ejemplar_n2->getId1());
                
                my %params;
                   
                # FIXME: cambiar 'recomendacion' por 'pedido_cotizacion', pero en TODOS los metodos       
                $params{'id_pedido_recomendacion'}         = $id_pedido_cotizacion; 
                 
                # ver esto:               
                $params{'cat_nivel2_id'}                    = $param->{'ejemplares_ids_array'}->[$i]; 
                $params{'autor'}                            = $ejemplar_n1->getAutor(); 
                $params{'titulo'}                           = $ejemplar_n1->getTitulo(); 
                $params{'lugar_publicacion'}                = $ejemplar_n2->getCiudadPublicacion(); 
                $params{'editorial'}                        = $ejemplar_n2->getEditor();
                $params{'fecha_publicacion'}                = $ejemplar_n2->getAnio_publicacion();
                $params{'coleccion'}                        = ""; # no encontre la coleccion en nivel1 ni en nivel2
                $params{'isbn_issn'}                        = $ejemplar_n2->getISSN();
                $params{'adq_recomendacion_detalle'}        = 'NULL';      
                $params{'cantidad_ejemplares'}              = $param->{'cant_ejemplares_array'}->[0];
                               
                # si le paso:  ->new($db)  se rompe          
                my $pedido_cotizacion_detalle               = C4::Modelo::AdqPedidoCotizacionDetalle->new(db=>$db);    
                              
                # sacar el maximo
                $params{'nro_renglon'}                      = (C4::AR::PedidoCotizacionDetalle::getCantRenglonesByPedidoPadre($id_pedido_cotizacion,$db) + 1);
                
                $pedido_cotizacion_detalle->addPedidoCotizacionDetalle(\%params);    
              }
            } 
            
            # nos fijamos si hay que commitear o ya hizo rollback
            if(!$bool_existe_ejemplar){  
                $msg_object->{'error'} = 0;
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A041', 'params' => []});
                $db->commit;      
            }   
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


sub getAdqPedidoCotizacionDetalle{
    my ( $id_pedido, $db) = @_;
 
    my @results; 

    $db = $db || C4::Modelo::AdqPedidoCotizacionDetalle->new()->db;

    my $detalle_array_ref = C4::Modelo::AdqPedidoCotizacionDetalle::Manager->get_adq_pedido_cotizacion_detalle(   
                                                                    db => $db,
                                                                    query   => [ adq_pedido_cotizacion_id => { eq => $id_pedido } ],
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


sub getAdqPedidosCotizacion{
    
    my $db = C4::Modelo::AdqPedidoCotizacion->new()->db;
    my $pedidos_cotizacion = C4::Modelo::AdqPedidoCotizacion::Manager->get_adq_pedido_cotizacion(   
                                                                    db => $db,
                                                                );

    my @results;

    foreach my $pedido (@$pedidos_cotizacion) {
        push (@results, $pedido);
    }

    return(\@results);
}


=item
    Esta funcion agrega un pedido cotizacion
    Parametros: (El id es AUTO_INCREMENT y la fecha CURRENT_TIMESTAMP)
        HASH { recomendaciones_array, cantidad_ejemplares_array } => para el pedido_cotizacion_detalle
=cut
sub addPedidoCotizacion{

    my ($param)             = @_;
    #my $id_recomendacion    = $param->{'id_recomendacion'};
    my $pedido_cotizacion   = C4::Modelo::AdqPedidoCotizacion->new();
    my $msg_object          = C4::AR::Mensajes::create();
    my $db                  = $pedido_cotizacion->db;

    if (!($msg_object->{'error'})){
        $db->{connect_options}->{AutoCommit} = 0;
        $db->begin_work;
    
        eval{            
                      
            $pedido_cotizacion->addPedidoCotizacion();
            my $id_pedido_cotizacion = $pedido_cotizacion->getId();         
            my %params;          
            $params{'id_pedido_recomendacion'}         = $id_pedido_cotizacion;
            
            # recorremos el array de recomendaciones, para por cada recomendacion_detalle agregar un pedido_detalle
            for(my $i=0; $i<scalar(@{$param->{'recomendaciones_array'}}); $i++){
            
                my $recomendacion_detalle   = C4::AR::Recomendaciones::getRecomendacionDetallePorId($param->{'recomendaciones_array'}->[$i]);
                
                my $id_recomendacion_padre  = $recomendacion_detalle->getAdqRecomendacionId();
                
                my $recomendacion_padre     = C4::AR::Recomendaciones::getRecomendacionPorId($id_recomendacion_padre, $db);
                $recomendacion_padre->desactivar();
                               
                $params{'cat_nivel2_id'}                    = $recomendacion_detalle->getCatNivel2Id(); 
                $params{'autor'}                            = $recomendacion_detalle->getAutor(); 
                $params{'titulo'}                           = $recomendacion_detalle->getTitulo(); 
                $params{'lugar_publicacion'}                = $recomendacion_detalle->getLugarPublicacion(); 
                $params{'editorial'}                        = $recomendacion_detalle->getEditorial();
                $params{'fecha_publicacion'}                = $recomendacion_detalle->getFechaPublicacion();
                $params{'coleccion'}                        = $recomendacion_detalle->getColeccion();
                $params{'isbn_issn'}                        = $recomendacion_detalle->getIsbnIssn();
                $params{'adq_recomendacion_detalle'}        = $recomendacion_detalle->getId();      
                $params{'cantidad_ejemplares'}              = $param->{'cantidad_ejemplares_array'}->[$i];
                $params{'nro_renglon'}                      = $i + 1;
                      
                my $pedido_cotizacion_detalle               = C4::Modelo::AdqPedidoCotizacionDetalle->new(db => $db);    
                
                $pedido_cotizacion_detalle->addPedidoCotizacionDetalle(\%params);    

            }   
    
            $msg_object->{'error'} = 0;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A033', 'params' => []});
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

=item
    Esta funcion devuelve los pedidos de recomendacion, con su detalle
=cut
sub getPedidosCotizacionConDetalle{

    my ($params) = @_;

    my $db                                      = C4::Modelo::AdqPedidoCotizacionDetalle->new()->db;
    my $pedidos_cotizacion_array_ref            = C4::Modelo::AdqPedidoCotizacionDetalle::Manager->get_adq_pedido_cotizacion_detalle(   
                                                                    db => $db,
                                                                    sort(nro_renglon),
                                                                    require_objects     => ['ref_adq_pedido_cotizacion'],
                                                                );

    return ($pedidos_cotizacion_array_ref);
}

=item
    Esta funcion devuelve los pedidos de cotizacion
=cut
sub getPedidosCotizacion{

    my ($params) = @_;

    my $db                                      = C4::Modelo::AdqPedidoCotizacion->new()->db;
    my $pedidos_cotizacion_array_ref            = C4::Modelo::AdqPedidoCotizacion::Manager->get_adq_pedido_cotizacion(   
                                                                    db => $db,
                                                                );

    return ($pedidos_cotizacion_array_ref);
}

END { }       # module clean-up code here (global destructor)

1;
__END__

