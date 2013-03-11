package C4::AR::PedidoCotizacionDetalle;

use strict;
require Exporter;
use DBI;
use C4::Modelo::AdqPedidoCotizacionDetalle;
use C4::Modelo::AdqPedidoCotizacionDetalle::Manager;

use vars qw(@EXPORT @ISA);
@ISA=qw(Exporter);
@EXPORT=qw(  
    &existeEjemplarEnPedidoCotizacion;
    &addPedidoCotizacionDetalle;
    &getPedidoCotizacionConDetallePorId;
    &getPedidosCotizacionPorPadre;
    &getCantRenglonesByPedidoPadre;
);


=item
    Esta funcion devuelve un bool, verifica que el ejemplar no este en el mismo pedido cotizacion_detalle
    Parametros: (id del ejemplar a chequear, id del pedido_cotizacion padre)
        HASH { id_ejemplar, id_pedido_cotizacion, $db }
=cut
sub existeEjemplarEnPedidoCotizacion{
    my ($id_ejemplar, $id_pedido_cotizacion, $db) = @_;
    my @filtros;

    my $db            = $db;
    push (@filtros, ( adq_pedido_cotizacion_id => { eq => $id_pedido_cotizacion}));
    push (@filtros, (cat_nivel2_id => { eq => $id_ejemplar}));
    
    my $ejemplares_array  = C4::Modelo::AdqPedidoCotizacionDetalle::Manager->get_adq_pedido_cotizacion_detalle(   
                                                                    db => $db,
                                                                    query => \@filtros,
                                                                );

    if(scalar(@$ejemplares_array) > 0){
        return 1;
    }else{
        return 0;
    }
}


=item
    Esta funcion devuelve la cantidad de renglones de un pedido
    Parametros: (El id del pedido_cotizacion padre)
        HASH { id_pedido_cotizacion }
=cut
sub getCantRenglonesByPedidoPadre{

    my ($params, $db) = @_;
    my @filtros;

    my $db            = $db;
    push (@filtros, ( adq_pedido_cotizacion_id => { eq => $params}));
    
    my $pedidos_cotizacion_array  = C4::Modelo::AdqPedidoCotizacionDetalle::Manager->get_adq_pedido_cotizacion_detalle(   
                                                                    db => $db,
                                                                    query => \@filtros,
                                                                );
    return @$pedidos_cotizacion_array;
}

=item
    Esta funcion agrega un pedido cotizacion
    Parametros: (El id es AUTO_INCREMENT y la fecha CURRENT_TIMESTAMP)
        HASH { id_pedido_cotizacion, cantidades_ejemplares }
=cut
sub addPedidoCotizacionDetalle{

    my ($params)            = @_;
    my $pedido_cotizacion   = C4::Modelo::AdqPedidoCotizacionDetalle->new();
    my $msg_object          = C4::AR::Mensajes::create();
    my $db                  = $pedido_cotizacion->db;
   

    if (!($msg_object->{'error'})){
          # entro si no hay algun error, todos los campos ingresados son validos
          $db->{connect_options}->{AutoCommit} = 0;
          $db->begin_work;

          eval{
       
              $pedido_cotizacion->addPedidoCotizacionDetalle($params);
              
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
    return ($msg_object);
}



=item
    Esta funcion devuelve el pedido_cotizacion_detalle por su id
    Parametros: id_pedido_cotizacion_detalle
=cut
sub getPedidoCotizacionConDetallePorId{

    my ($params) = @_;
    my @filtros;

    my $db                           = C4::Modelo::AdqPedidoCotizacionDetalle->new()->db;
    push (@filtros, ( id => { eq => $params}));
    
    my $pedido_cotizacion            = C4::Modelo::AdqPedidoCotizacionDetalle::Manager->get_adq_pedido_cotizacion_detalle(   
                                                                    db => $db,
                                                                    query => \@filtros,
                                                                );
    return $pedido_cotizacion->[0];
}


=item
    Esta funcion devuelve los pedidos_cotizacion_detalle que tengan el pedido_cotizacion (padre) 
    con el id recibido como parametro
    Parametros: id_pedido_cotizacion (padre)
=cut
sub getPedidosCotizacionPorPadre{

    my ($params) = @_;
    my @filtros;

    my $db = C4::Modelo::AdqPedidoCotizacionDetalle->new()->db;
    push (@filtros, ( adq_pedido_cotizacion_id => { eq => $params}));
    
    my $pedido_cotizacion            = C4::Modelo::AdqPedidoCotizacionDetalle::Manager->get_adq_pedido_cotizacion_detalle(   
                                                                    db => $db,
                                                                    query => \@filtros,
                                                                );
    return $pedido_cotizacion;
}


END { }       # module clean-up code here (global destructor)

1;
__END__
