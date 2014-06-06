package C4::AR::Sanciones;

#
# Modulo para hacer calculos de dias a sancionar
#

use strict;
require Exporter;
use C4::Context;
use C4::Date;
use Date::Manip;
use C4::Modelo::CircSancion;
use C4::Modelo::CircSancion::Manager;

use vars qw(@EXPORT @ISA);
@ISA=qw(Exporter);
@EXPORT=qw( 
    getSancionesLike
    tieneSanciones
    eliminarSanciones
    sanciones
    permisoParaPrestamo
    estaSancionado
    tieneLibroVencido
    getSociosSancionados
    diasDeSancion
    getTipoSancion
);


=item 
Busca las sanciones segun lo ingresado en el cliente: apellido, nombre, nro_socio.
Tambien filtrando por fecha, para mostrar las sanciones actuales.
=cut
sub getSancionesLike {

    my ($str,$ini,$cantR) = @_;
    my $sanciones_array_ref;
    my @filtros;
    
    my $dateformat  = C4::Date::get_date_format();
    my $hoy         = C4::Date::format_date_in_iso(ParseDate("today"), $dateformat);
    
    my @searchstring_array= split(' ',$str);
    
    C4::AR::Utilidades::printARRAY(\@searchstring_array);

    #Primero filtro sanciones
    
    push (@filtros,(fecha_comienzo  => { le => $hoy },fecha_final     => { ge => $hoy}));

    foreach my $s (@searchstring_array){ 
                push (  @filtros, ( or   => [   
                                                'socio.persona.nombre'    => { like => $s.'%'},   
                                                'socio.persona.nombre'    => { like => '% '.$s.'%'},
                                                apellido            => { like => $s.'%'},
                                                apellido            => { like => '% '.$s.'%'},
                                                nro_documento       => { like => '%'.$s.'%' }, 
                                                legajo              => { like => '%'.$s.'%' },
                                                nro_socio           => { like => '%'.$s.'%' }          
                                            ],
         ));
    }

    $sanciones_array_ref = C4::Modelo::CircSancion::Manager->get_circ_sancion( 
                                        query           => \@filtros,
                                        select          => ['circ_sancion.*'],
                                        with_objects    => ['socio','socio.persona','nivel3'],
                                        limit   => $cantR,
                                        offset  => $ini,
                                ); 
                                
   my $sanciones_array_ref_count = C4::Modelo::CircSancion::Manager->get_circ_sancion_count( query => \@filtros,
                                                                                            with_objects  => ['socio','socio.persona','nivel3'],
                                                                                           ); 
  return ($sanciones_array_ref_count,$sanciones_array_ref);

}



sub tieneSanciones {
  #Se buscan todas las sanciones actuales de un socio
  my ($nro_socio)=@_;

  my $dateformat = C4::Date::get_date_format();
  my $hoy=C4::Date::format_date_in_iso(ParseDate("today"), $dateformat);
  
  my $sanciones_array_ref = C4::Modelo::CircSancion::Manager->get_circ_sancion (   
                                  query => [ 
                                      nro_socio     => { eq => $nro_socio },
                                      fecha_comienzo  =>
 { le => $hoy },
                                      fecha_final     =>
 { ge => $hoy},
                                    ],
                                                                    require_objetcs => ['ref_tipo_prestamo_sancion','nivel3','tipo_sancion.ref_tipo_prestamo'],
                  );
  if (scalar(@$sanciones_array_ref) == 0){
        return 0;
  }else{
    return(\@$sanciones_array_ref);
  }
}


sub tieneSancionPendiente {
  #Se buscan todas las sanciones pendientes de un socio
  my ($nro_socio,$db)=@_;

    use C4::Modelo::CircSancion::Manager;
    my $sanciones_array_ref = C4::Modelo::CircSancion::Manager->get_circ_sancion( db=> $db,
                            query => [ nro_socio => { eq => $nro_socio },
                                       fecha_comienzo => { eq => undef },
                                       fecha_final => { eq => undef }] 
                            );

  if (scalar($sanciones_array_ref->[0])){
      return($sanciones_array_ref->[0] || 0);
  }else{
      return (0);
  }
}


sub permisoParaPrestamo {
#Esta funcion retorna un par donde el primer parametro indica si el usuario puede realizar una reserva o se le puede realizar un prestamo y el segundo indica en caso de e
#star sancionado la fecha en la que la sancion finaliza
    my ($nro_socio, $tipo_prestamo, $es_reserva) = @_;

    my $deudaOsancion   = 0; #Se supone que no esta sancionado
    my $hasta           = undef;
    my $cod_error;
    my %status_hash     = {};
    
    if (tieneLibroVencido($nro_socio)) {
        $deudaOsancion  = 1; #Tiene libros vencidos 
        C4::AR::Debug::debug("Sanciones::permisoParaPrestamo => tieneLibroVencido ");
        if ($es_reserva){
            $cod_error      = 'S206';
        } else {
            $cod_error      = 'S204';
        }
    }
  elsif (my $sancion = estaSancionado($nro_socio, $tipo_prestamo)) {
        $deudaOsancion  = 1; #Tiene una sancion vigente
        $hasta          = $sancion->getFecha_final;
        $cod_error      = 'S205';
        C4::AR::Debug::debug("Sanciones::permisoParaPrestamo => estaSancionado ");
    }

    $status_hash{'deudaSancion'} = $deudaOsancion;
    $status_hash{'hasta'}        = $hasta;
    $status_hash{'cod_error'}    = $cod_error;
    
    return(\%status_hash);
}


sub estaSancionado {
  #Esta funcion determina si un usuario ($nro_socio) tiene derecho (o sea no esta sancionado) a retirar un ejemplar para un tipo de prestamo ($tipo_prestamo)
  my ($nro_socio, $tipo_prestamo)=@_;

  my $dateformat = C4::Date::get_date_format();
  my $hoy=C4::Date::format_date_in_iso(ParseDate("today"), $dateformat);

  my $sanciones_array_ref = C4::Modelo::CircSancion::Manager->get_circ_sancion (
                                                                                query => [ 
                                                                                    nro_socio     => { eq => $nro_socio },
                                                                                    fecha_comienzo  => { le => $hoy },
                                                                                    fecha_final     => { ge => $hoy},
                                                                                    ],
                                                                                require_objetcs => ['ref_tipo_sancion','reserva','ref_tipo_sancion.ref_tipo_prestamo'],
                                                                                select => ['*'],
                                                                                );
                                                                                
  foreach my $sancion (@$sanciones_array_ref){
    #Es una sanción Manual? Se aplica a todos los tipos de préstamo!
    if ( $sancion->getTipo_sancion eq -1 ){ return $sancion; }

    foreach my $tipo ($sancion->ref_tipo_prestamo_sancion){
      if ( $tipo->getTipo_prestamo eq $tipo_prestamo ){ return $sancion; }
    }
  }
  
  return (0);
}

sub tieneLibroVencido {
  #Esta funcion determina si un usuario ($nro_socio) tiene algun biblio vencido que no le permite realizar reservas o prestamos
  my ($nro_socio,$db)=@_;

  my $prestamos_array_ref=C4::AR::Prestamos::getPrestamosDeSocio($nro_socio,$db);

  my $dateformat = C4::Date::get_date_format();
  my $hoy=C4::Date::format_date_in_iso(ParseDate("today"), $dateformat);
  foreach my $prestamo (@$prestamos_array_ref) {
           C4::AR::Debug::debug("El prestamo del Nivel3 -- ".$prestamo->getId3." -- esta vencido? : ".$prestamo->estaVencido);
        if ($prestamo->estaVencido){
                C4::AR::Debug::debug("EL EJEMPLAR CON ID ".$prestamo->nivel3->getId." DEL USUARIO ".$prestamo->socio->getNro_socio." ESTA VENCIDO!!!!!!!!!!!!!");
          return(1);
        }
  }
  return(0);
}

sub getSociosSancionados {
#Esta funcion retorna los socios sancionados para un determinado tipo de prestamo o su tipo_prestamo es 0 (o sea es una sancion por 
#no retirar una reserva)
  my ($tipo_prestamo)=@_;

  my $dateformat = C4::Date::get_date_format();
  my $hoy=C4::Date::format_date_in_iso(ParseDate("today"), $dateformat);
  
  my $sanciones_array_ref = C4::Modelo::CircSancion::Manager->get_circ_sancion (   
                                                                query => [ 
                                                                    fecha_comienzo  => { le => $hoy },
                                                                    fecha_final     => { ge => $hoy},
                                                                    tipo_prestamo   => { eq => $tipo_prestamo },
                                                                    or   => [
                                                                      tipo_prestamo => { eq => 0 },
                                                                                                          ],
                                                                  ],
                                                                select => ['nro_socio'],
                                                                with_objects => [ 'ref_tipo_prestamo_sancion' ]
                  );

  my @socios_sancionados;
  foreach my $sancion (@$sanciones_array_ref){
    push (@socios_sancionados,$sancion->getNro_socio);
  }

  return(\@socios_sancionados);
}


sub diasDeSancion {
# Retorna la cantidad de dias de sancion que corresponden a una devolucion
# Si retorna 0 (cero) entonces no corresponde una sancion
# Recibe la fecha de devolucion (returndate), la fecha hasta la que podia devolverse (date_due), la categoria del usuario (categorycode) y el tipo de prestamo (issuecode)
    my ($fecha_devolucion, $fecha_vencimiento, $categoria, $tipo_prestamo)=@_;


      C4::AR::Debug::debug("EN DiasDeSancion ?");


    if (Date_Cmp($fecha_vencimiento, $fecha_devolucion) >= 0) {
        #Si es un prestamo especial debe devolverlo antes de una determinada hora
        if ($tipo_prestamo ne 'ES'){return(0);}
        else{#Prestamo especial
            if (Date_Cmp($fecha_vencimiento, $fecha_devolucion) == 0){#Se tiene que devolver hoy   
                
                my $begin = ParseDate(C4::AR::Preferencias::getValorPreferencia("open"));
                my $end =  C4::Date::calc_endES();
                my $actual=ParseDate("now");
                if (Date_Cmp($actual, $end) <= 0){#No hay sancion se devuelve entre la apertura de la biblioteca y el limite
                    return(0);
                }
            }
            else {#Se devuelve antes de la fecha de devolucion
                return(0);
            }
        }#else ES
    }#if Date_Cmp

#Corresponde una sancion vamos a calcular de cuantos dias!
C4::AR::Debug::debug("Corresponde una sancion vamos a calcular de cuantos dias!");
  use C4::Modelo::CircTipoSancion::Manager;
  my $tipo_sancion_array_ref = C4::Modelo::CircTipoSancion::Manager->get_circ_tipo_sancion ( 
                                                                    query => [ 
                                                                            tipo_prestamo       => { eq => $tipo_prestamo },
                                                                            categoria_socio     => { eq => $categoria },
                                                                        ],
                                    );

 C4::AR::Debug::debug("HAY REGLAS? ");

 if (!$tipo_sancion_array_ref->[0]){
    C4::AR::Debug::debug("NO HAY REGLAS!!!! DIAS DE SANCION 0!!! ");  
    return 0;
 }

  my $reglas_tipo_array_ref=$tipo_sancion_array_ref->[0]->ref_regla_tipo_sancion;

=item
Date-Date calculations
$delta  = $date->calc($date2 [,$subtract] [,$mode]);
Two dates can be worked with and a delta will be produced which is the amount of time between the two dates.
$date1 and $date2 are Date::Manip::Date objects with valid dates. The Date::Manip::Delta object returned is the amount of time between them. If $subtract is not passed in
 (or is 0), the delta produced is:
  DELTA = DATE2 - DATE1
If $subtract is non-zero, the delta produced is:
  DELTA = DATE1 - DATE2
=cut
  my $err;
  my $delta= Date::Manip::DateCalc(ParseDate($fecha_vencimiento),ParseDate($fecha_devolucion),\$err,0);
  

  #FIXME esta horrible, agarro las horas y las divido por 24!!!
  my $dias;

  $dias = Date::Manip::Delta_Format($delta,2,"%.2hhs") / 24;

  if ( (!$dias)||($dias<=0)){
    $dias = Date::Manip::Delta_Format($delta,2,"%dh");
  }

  C4::AR::Debug::error("HAY ERROR?????    ".$err);

  C4::AR::Debug::error("CUANTOS DIAS??? FECHA: ".$fecha_vencimiento." DEVOLUCION: ".$fecha_devolucion." DELTA: ".$delta." DIAS: ".$dias);

  #Si es un prestamo especial, si se pasa de la hora se toma como si se pasara un dia
  if ($tipo_prestamo eq 'ES'){$dias++;}
C4::AR::Debug::debug("DIAS Excedido -->>> ".$dias);
  my $diasExcedido= $dias;
  my $cantidadDeDias= 0;
    
  foreach  my $regla_tipo (@$reglas_tipo_array_ref) {
     C4::AR::Debug::error("REGLAS DE SANCION -->>> Orden ".$regla_tipo->getOrden);

        if($diasExcedido > 0){
            #($regla_tipo->getCantidad == 0) ===> INFINITO
            for (my $i=0; (($i < $regla_tipo->getCantidad) || ($regla_tipo->getCantidad == 0)) && ($diasExcedido > 0); $i++) {
                $diasExcedido-= $regla_tipo->ref_regla->getDias_demora;
               C4::AR::Debug::debug("DIAS Excedido -->>> ".$diasExcedido);
                $cantidadDeDias+= $regla_tipo->ref_regla->getDias_sancion;
               C4::AR::Debug::debug("CANTIDAD DE DIAS -->>> ".$cantidadDeDias);
                }
            }
        else {
            return($cantidadDeDias);
        }
    }

return($cantidadDeDias);

}


sub getTipoSancion{
  #Esta funcion recupera el tipo de sancion a partir del tipo de prestamo y la categoria del usuario
    my ($tipo_prestamo, $categoria_socio,$db)=@_;
    my @filtros;
    my $tipo_sanciones_array_ref;


    if ( ($tipo_prestamo) && (($tipo_prestamo ne C4::AR::Filtros::i18n("SIN SELECCIONAR"))) ){
      push (@filtros, (tipo_prestamo => {eq =>$tipo_prestamo}) );

    }

    if ( ($categoria_socio) && (($categoria_socio ne C4::AR::Filtros::i18n("SIN SELECCIONAR"))) ){
      push (@filtros, (categoria_socio => {eq =>$categoria_socio}) );

    }

    if($db){ #Si viene $db es porque forma parte de una transaccion
        $tipo_sanciones_array_ref = C4::Modelo::CircTipoSancion::Manager->get_circ_tipo_sancion (
                                                                    db => $db,
                                                                    query => \@filtros,
                                    );
    }else{
        $tipo_sanciones_array_ref = C4::Modelo::CircTipoSancion::Manager->get_circ_tipo_sancion (   
                                                                    query => \@filtros,
                                    );
    }

    my $tipo_sancion=undef;


    if ($tipo_sanciones_array_ref->[0]){
        $tipo_sancion = $tipo_sanciones_array_ref->[0];
    }else{
      $tipo_sancion = C4::Modelo::CircTipoSancion->new();
      $tipo_sancion->setCategoria_socio($categoria_socio);
      $tipo_sancion->setTipo_prestamo($tipo_prestamo);
      $tipo_sancion->save();

    }

    return($tipo_sancion);
}


sub sanciones {
 #Esta funcion muestra toda las sanciones que hay
  my ($orden,$ini,$cantR) = @_;

  my $dateformat = C4::Date::get_date_format();
  my $hoy        = C4::Date::format_date_in_iso(ParseDate("today"), $dateformat);

  my $sanciones_array_ref = C4::Modelo::CircSancion::Manager->get_circ_sancion (   
                                                                    query => [ 
                                                                            fecha_comienzo  => { le => $hoy },
                                                                            fecha_final     => { ge => $hoy},
                                                                              ],
                                                                    select  => ['*'],
                                                                    with_objects => ['socio','socio.persona','ref_tipo_sancion','nivel3', 'reserva'],
                                                                    sort_by => $orden,
                                                                    limit   => $cantR,
                                                                    offset  => $ini,
                              );
                              
  my $sanciones_array_ref_count = C4::Modelo::CircSancion::Manager->get_circ_sancion_count( query => [  
                                                                                                    fecha_comienzo  => { le => $hoy },
                                                                                                    fecha_final     => { ge => $hoy}, 
                                                                                            ]); 
  return ($sanciones_array_ref_count,$sanciones_array_ref);

}


=item
Elimina las sanciones 
=cut

sub eliminarSanciones{
  my ($userid,$sanciones_ids) = @_;

    my @infoMessages;
    my %messageObj;
  my ($msg_object) = C4::AR::Mensajes::create();
  my $sancionTEMP  = C4::Modelo::CircSancion->new();
  my $db           = $sancionTEMP->db;
  $db->{connect_options}->{AutoCommit} = 0;
  $db->begin_work;

  foreach my $id_sancion (@$sanciones_ids) {
    my $sancion = C4::Modelo::CircSancion->new(id_sancion => $id_sancion, db => $db);
  
    $sancion->load();
    my $socio_sancionado = $sancion->getNro_socio;
    my $socio_temp       = C4::AR::Usuarios::getSocioInfoPorNroSocio($socio_sancionado);
    my $nombre_persona   = $socio_temp->persona->getNombre();
    my $apellido_persona = $socio_temp->persona->getApellido();

    if(!$msg_object->{'error'}){
        eval{ 
            $sancion->eliminar_sancion($userid);
            $db->commit;
        };
        if ($@){
            $db->rollback;
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'S203', 'params' => [$apellido_persona, $nombre_persona, $socio_sancionado]} ) ;
        }
        $msg_object->{'error'}= 0;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'S202', 'params' => [$apellido_persona, $nombre_persona, $socio_sancionado]} ) ;
    }else{
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'S203', 'params' => [$apellido_persona, $nombre_persona, $socio_sancionado]} ) ;
    }

  }

  $db->{connect_options}->{AutoCommit} = 1;

  return ($msg_object);
 }


=item
  sub actualizarTiposPrestamoQueAplica
  
  Esta funcion actualiza los tipos de prestamo sobre los cuales se aplica la sancion de un determinado tipo de prestamo y categoria de usuario
=cut

sub actualizarTiposPrestamoQueAplica {
    my ($tipo_prestamo,$categoria_socio,$tiposQueAplica) = @_;

    my @infoMessages;
    my %messageObj;
    my ($msg_object)    = C4::AR::Mensajes::create();
    my $sancionTEMP     = C4::Modelo::CircSancion->new();
    my $db = $sancionTEMP->db;
    $db->{connect_options}->{AutoCommit} = 0;
    $db->begin_work;
    #Busco el tipo de sanción
    my $tipo_sancion    = C4::AR::Sanciones::getTipoSancion($tipo_prestamo, $categoria_socio,$db);

  eval {  
        $tipo_sancion->actualizarTiposPrestamoQueAplica($tiposQueAplica,$db);
        $db->commit;
        $msg_object->{'error'}= 0;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP013', 'params' => []} ) ;
    };
   
    if ($@){
    C4::AR::Mensajes::printErrorDB($@, '',"INTRA");
    $db->rollback;
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP014', 'params' => []} ) ;

    }
   
    $db->{connect_options}->{AutoCommit} = 1;

    return ($msg_object);
}

sub getReglaSancion{
  #Esta funcion recupera una regla si existe    
    my ($dias_sancion,$dias_demora)=@_;

   use C4::Modelo::CircReglaSancion::Manager;
   my $regla_sancion_array_ref = C4::Modelo::CircReglaSancion::Manager->get_circ_regla_sancion(
                                                              query => [ 
                                                                      dias_sancion  => { eq => $dias_sancion },
                                                                      dias_demora     => { eq => $dias_demora},
                                                                        ],
                                                                        );

    if ($regla_sancion_array_ref->[0]) {return $regla_sancion_array_ref->[0];}

  return 0;

}


sub getReglasSancion{
  #Esta funcion recupera todas las reglas 

   use C4::Modelo::CircReglaSancion::Manager;
   my $reglas_sancion_array_ref = C4::Modelo::CircReglaSancion::Manager->get_circ_regla_sancion(
                                                              sort_by => 'dias_demora , dias_sancion'
                                                                        );

    if ($reglas_sancion_array_ref->[0]) {return $reglas_sancion_array_ref;}

  return 0;

}


sub getReglasSancionNoAplicadas{
  #Esta funcion recupera todas las reglas que no son aplicadas al tipo de sancion actual
   my ($tipo_sancion)=@_;
   use C4::Modelo::CircReglaSancion::Manager;
   my $reglas_sancion_array_ref = C4::Modelo::CircReglaSancion::Manager->get_circ_regla_sancion(
                                                              sort_by => 'dias_demora , dias_sancion'
                                                                        );
   my $reglas_tipo_sancion= C4::AR::Sanciones::getReglasTipoSancion($tipo_sancion);
  
  if ($reglas_sancion_array_ref) {

   my @reglas_resultado;

   foreach  my $regla1 (@$reglas_sancion_array_ref) {
            my $existe=0;
           if($reglas_tipo_sancion){
           foreach  my $regla2 (@$reglas_tipo_sancion) {
                if($regla1->getRegla_sancion eq $regla2->getRegla_sancion){$existe=1;}
           }
           }
            if(!$existe){push (@reglas_resultado,$regla1);}
   }

   if ($reglas_resultado[0]) {return \@reglas_resultado;}
  }

  return 0;

}

sub getReglasTipoSancion{
  #Esta funcion recupera las reglas de un tipo de sancion
   my ($tipo_sancion)=@_;

  if($tipo_sancion){
   use C4::Modelo::CircReglaTipoSancion::Manager;
   my $reglas_sanciones_array_ref = C4::Modelo::CircReglaTipoSancion::Manager->get_circ_regla_tipo_sancion(
                                                                    query => [ 
                                                                            tipo_sancion => { eq => $tipo_sancion->getTipo_sancion},
                                                                        ],
                                                                    sort_by      => 'orden ASC',
                                                                    require_objetcs => ['ref_regla','sancion'],
                                    );

    if ($reglas_sanciones_array_ref->[0]) {
        return ($reglas_sanciones_array_ref);
      }
  }
  return (0,0);

}

sub agregarReglaTipoSancion {
#Esta funcion agrega una regla a un tipo de sancion 
 my ($regla_sancion,$orden,$cantidad,$tipo_prestamo, $categoria_socio)=@_;

    my @infoMessages;
    my %messageObj;
    my ($msg_object)= C4::AR::Mensajes::create();
    my $regla_tipo_sancion = C4::Modelo::CircReglaTipoSancion->new();
    my $db = $regla_tipo_sancion->db;
    $db->{connect_options}->{AutoCommit} = 0;
    $db->begin_work;
    my $tipo_sancion=&C4::AR::Sanciones::getTipoSancion($tipo_prestamo, $categoria_socio);

    eval{
         $regla_tipo_sancion->setTipo_sancion($tipo_sancion->getTipo_sancion);
         $regla_tipo_sancion->setRegla_sancion($regla_sancion);
         $regla_tipo_sancion->setOrden($orden);
         $regla_tipo_sancion->setCantidad($cantidad);
         $regla_tipo_sancion->save;
         $db->commit;
         $msg_object->{'error'}= 0;
         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP015', 'params' => []} ) ;
         };
         if ($@){
                C4::AR::Mensajes::printErrorDB($@, '',"INTRA");
                $db->rollback;
                $msg_object->{'error'}= 1;
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP016', 'params' => []} ) ;
                }

    $db->{connect_options}->{AutoCommit} = 1;

    return ($msg_object);
}


sub eliminarReglaTipoSancion {
#Esta funcion elimina una regla a un tipo de sancion 
 my ($tipo_sancion,$regla_sancion)=@_;

    my @infoMessages;
    my %messageObj;
    my ($msg_object)= C4::AR::Mensajes::create();
    my $regla_tipo_sancion = C4::Modelo::CircReglaTipoSancion->new(tipo_sancion => $tipo_sancion, regla_sancion=>$regla_sancion);
    $regla_tipo_sancion->load();
    my $db = $regla_tipo_sancion->db;
    $db->{connect_options}->{AutoCommit} = 0;
    $db->begin_work;
    eval{
         $regla_tipo_sancion->delete;
         $db->commit;
         $msg_object->{'error'}= 0;
         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP017', 'params' => []} ) ;
         };
         if ($@){
                C4::AR::Mensajes::printErrorDB($@, '',"INTRA");
                $db->rollback;
                $msg_object->{'error'}= 1;
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP018', 'params' => []} ) ;
                }

    $db->{connect_options}->{AutoCommit} = 1;

    return ($msg_object);
}



sub agregarReglaSancion {
#Esta funcion agrega una regla 
 my ($dias_sancion,$dias_demora)=@_;

    my @infoMessages;
    my %messageObj;
    my ($msg_object)= C4::AR::Mensajes::create();
    my $regla=&C4::AR::Sanciones::getReglaSancion($dias_sancion, $dias_demora);
    if ($regla){
    #Ya existe la regla
         $msg_object->{'error'}= 1;
         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP019', 'params' => []} ) ;
    }
    else{
        my $regla_sancion = C4::Modelo::CircReglaSancion->new();
        my $db = $regla_sancion->db;
        $db->{connect_options}->{AutoCommit} = 0;
        $db->begin_work;
        eval{
         $regla_sancion->setDias_sancion($dias_sancion);
         $regla_sancion->setDias_demora($dias_demora);
         $regla_sancion->save;
         $db->commit;
         $msg_object->{'error'}= 0;
         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP020', 'params' => []} ) ;
         };
         if ($@){
                C4::AR::Mensajes::printErrorDB($@, '',"INTRA");
                $db->rollback;
                $msg_object->{'error'}= 1;
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP021', 'params' => []} ) ;
                }
        $db->{connect_options}->{AutoCommit} = 1;
        }

    return ($msg_object);
}
sub cantUtilizacionReglaSancion {
#Esta funcion retorna si se esta utilizando o no una regla en particular
 my ($regla_sancion)=@_;

  use C4::Modelo::CircReglaTipoSancion::Manager;
  my $reglas = C4::Modelo::CircReglaTipoSancion::Manager->get_circ_regla_tipo_sancion_count (
                                                                    query => [ 
                                                                         regla_sancion => { eq => $regla_sancion},
                                                                        ],
                                    );

  return $reglas;
}

sub eliminarReglaSancion {
#Esta funcion elimina una regla
 my ($regla_sancion)=@_;

    my @infoMessages;
    my %messageObj;
    my ($msg_object)= C4::AR::Mensajes::create();
    my $cant_regla=C4::AR::Sanciones::cantUtilizacionReglaSancion($regla_sancion);

    if ($cant_regla > 0 ) {
    #Esta siendo utilizada!!
         $msg_object->{'error'}= 1;
         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP022', 'params' => [$cant_regla]} ) ;
    }
    else {
        my $regla = C4::Modelo::CircReglaSancion->new(regla_sancion=>$regla_sancion);
        $regla->load();
        my $db = $regla->db;
        $db->{connect_options}->{AutoCommit} = 0;
        $db->begin_work;
        eval{
            $regla->delete;
            $db->commit;
            $msg_object->{'error'}= 0;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP023', 'params' => []} ) ;
            };
            if ($@){
                    C4::AR::Mensajes::printErrorDB($@, '',"INTRA");
                    $db->rollback;
                    $msg_object->{'error'}= 1;
                    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP024', 'params' => []} ) ;
                    }
        $db->{connect_options}->{AutoCommit} = 1;
    }

    return ($msg_object);
}

sub getHistorialSanciones{
  #Esta funcion recupera las sanciones históricas de un socio
   my ($nro_socio,$ini,$cantR,$orden)=@_;

    $cantR  = $cantR || 10;
    $ini    = $ini || 0;

  if($nro_socio){

    my $err         = "Error con la fecha";
    my $dateformat  = C4::Date::get_date_format();
    my $hoy         = C4::Date::format_date_in_iso(ParseDate("today"), $dateformat);
    
    my @filtros;
    push(@filtros, and  => [ nro_socio      => { eq => $nro_socio }, 
                             fecha_comienzo    => { lt => $hoy }]);

    use C4::Modelo::RepHistorialSancion::Manager;
    my $historial_sanciones_array_ref = C4::Modelo::RepHistorialSancion::Manager->get_rep_historial_sancion (   
                                                                        query => \@filtros,
                                                                        with_objects => ['usr_responsable','usr_nro_socio','ref_tipo_sancion', 'nivel3', 'nivel3.nivel1'],
                                                                        sort_by => $orden,
                                                                        limit   => $cantR,
                                                                        offset  => $ini,
                                );
    my $historial_sanciones_array_ref_count = C4::Modelo::RepHistorialSancion::Manager->get_rep_historial_sancion_count(query => \@filtros,);
    return ($historial_sanciones_array_ref_count, $historial_sanciones_array_ref);

  }
  return 0;

}


=item
    Aplicar Sancion Manual a Socio
=cut
sub aplicarSancionManualSocio {

    my ($params)    = @_;
    my $msg_object  = C4::AR::Mensajes::create();
    my ($socio)     = C4::AR::Usuarios::getSocioInfoPorNroSocio($params->{'nro_socio'});

    if ($socio){
        my $db = $socio->db;
        $db->{connect_options}->{AutoCommit} = 0;
        $db->begin_work;

        eval {
            #$socio->setCredentialType($params->{'credenciales'});
              C4::AR::Debug::debug("***__________________________CALCULO COMIENZO SANCION MANUAL__________________***");   
              my $dateformat = C4::Date::get_date_format();
              my $comienzo_sancion =  C4::Date::format_date_in_iso( Date::Manip::ParseDate("today"), $dateformat );   
              my $diasDeSancionManual =  $params->{'dias'};
              C4::AR::Debug::debug("***___________________________________DIAS SANCION MANUAL___________________________".$diasDeSancionManual);  
              if ($diasDeSancionManual > 0) {
                C4::AR::Debug::debug("***_____________________________CALCULO FIN SANCION MANUAL____________________***");
                my ($fecha_comienzo_sancion,$fecha_fin_sancion,$apertura,$cierre) = C4::Date::proximosHabiles($diasDeSancionManual,0,$comienzo_sancion);
                
                $fecha_comienzo_sancion   = C4::Date::format_date_in_iso($fecha_comienzo_sancion,$dateformat);
                $fecha_fin_sancion        = C4::Date::format_date_in_iso($fecha_fin_sancion,$dateformat);
                my  $sancion              = C4::Modelo::CircSancion->new(db => $db);
                my %paramsSancion;
                $paramsSancion{'responsable'}       = $params->{'responsable'};
                $paramsSancion{'tipo_sancion'}      = -1;
                $paramsSancion{'nro_socio'}         = $params->{'nro_socio'};
                $paramsSancion{'fecha_comienzo'}    = $fecha_comienzo_sancion;
                $paramsSancion{'fecha_final'}       = $fecha_fin_sancion;
                $paramsSancion{'dias_sancion'}      = $diasDeSancionManual;
                $paramsSancion{'motivo_sancion'}    = $params->{'motivo'};
                $sancion->insertar_sancion(\%paramsSancion);
              }

            $db->commit;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'S207', 'params' => []} ) ;
            
        };

        if ($@){
            C4::AR::Mensajes::printErrorDB($@, 'B423',"INTRA");
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'S208', 'params' => []} ) ;
            $db->rollback;
        }
        $db->{connect_options}->{AutoCommit} = 1;
    }
    return ($msg_object);
}


END { }       # module clean-up code here (global destructor)

1;
__END__