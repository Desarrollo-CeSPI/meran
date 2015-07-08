package C4::Modelo::CircPrestamo;

use strict;
use Date::Manip;
use C4::Modelo::RepHistorialCirculacion;
use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table => 'circ_prestamo',

    columns => [
        id_prestamo                 => { type => 'serial', overflow => 'truncate', not_null => 1 },
        id3                         => { type => 'integer', overflow => 'truncate' },
        nro_socio                   => { type => 'varchar', overflow => 'truncate', length => 16, not_null => 1 },
        tipo_prestamo               => { type => 'character', overflow => 'truncate', length => 2, default => 'DO', not_null => 1 },
        fecha_prestamo              => { type => 'varchar', overflow => 'truncate', not_null => 1 },
        id_ui_origen                => { type => 'varchar', overflow => 'truncate', length   => 4 },
        id_ui_prestamo              => { type => 'varchar', overflow => 'truncate', length   => 4 },
        fecha_devolucion            => { type => 'varchar', overflow => 'truncate' },
        fecha_vencimiento_reporte   => { type => 'varchar', overflow => 'truncate' },
        renovaciones                => { type => 'integer', overflow => 'truncate', default => '0', not_null => 1 },
        fecha_ultima_renovacion     => { type => 'varchar', overflow => 'truncate' },
        timestamp                   => { type => 'timestamp', not_null => 1 },
        agregacion_temp             => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 0 },
    ],

    primary_key_columns => ['id_prestamo'],

    unique_key          => ['id3','nro_socio'],

    relationships => [

        nivel3 => {
            class       => 'C4::Modelo::CatRegistroMarcN3',
            key_columns => { id3 => 'id' },
            type        => 'one to one',
        },
        tipo => {
            class       => 'C4::Modelo::CircRefTipoPrestamo',
            key_columns => { tipo_prestamo => 'id_tipo_prestamo' },
            type        => 'one to one',
        },

        socio => {
            class       => 'C4::Modelo::UsrSocio',
            key_columns => { nro_socio => 'nro_socio' },
            type        => 'one to one',
        },
        ui => {
            class       => 'C4::Modelo::PrefUnidadInformacion',
            key_columns => { id_ui_origen => 'id_ui' },
            type        => 'one to one',
        },
        ui_prestamo => {
            class       => 'C4::Modelo::PrefUnidadInformacion',
            key_columns => { id_ui_prestamo => 'id_ui' },
            type        => 'one to one',
        },
    ],
);

sub getId_prestamo {
    my ($self) = shift;
    return ( $self->id_prestamo );
}

sub setId_prestamo {
    my ($self)        = shift;
    my ($id_prestamo) = @_;
    $self->id_prestamo($id_prestamo);
}

sub getId3 {
    my ($self) = shift;
    return ( $self->id3 );
}

sub setId3 {
    my ($self) = shift;
    my ($id3)  = @_;
    $self->id3($id3);
}

sub getNro_socio {
    my ($self) = shift;
    return ( $self->nro_socio );
}

sub setNro_socio {
    my ($self)      = shift;
    my ($nro_socio) = @_;
    $self->nro_socio($nro_socio);
}

sub getTipo_prestamo {
    my ($self) = shift;
    return ( $self->tipo_prestamo );
}

sub setTipo_prestamo {
    my ($self)          = shift;
    my ($tipo_prestamo) = @_;
    $self->tipo_prestamo($tipo_prestamo);
}

sub getFecha_prestamo {
    my ($self) = shift;
    return ( $self->fecha_prestamo );
}

sub getFecha_prestamo_formateada {
    my ($self) = shift;
    my $dateformat = C4::Date::get_date_format();
    return C4::Date::format_date( $self->getFecha_prestamo, $dateformat );
}

sub getFecha_vencimiento_reporte_formateada{
    my ($self) = shift;
    my $dateformat = C4::Date::get_date_format();
    return C4::Date::format_date( $self->fecha_vencimiento_reporte, $dateformat );
}

sub getFecha_vencimiento_reporte{
    my ($self) = shift;

    return $self->fecha_vencimiento_reporte;
}

sub getFecha_prestamo_formateada_ticket {
    my ($self) = shift;
    my $dateformat = C4::Date::get_date_format();
    return C4::Date::format_date( substr($self->getTimestamp,0,10), $dateformat)." ".substr($self->getTimestamp,11);
}

sub setFecha_prestamo {
    my ($self)           = shift;
    my ($fecha_prestamo) = @_;
    $self->fecha_prestamo($fecha_prestamo);
}

sub getId_ui_origen {
    my ($self) = shift;
    return ( $self->id_ui_origen );
}

sub setId_ui_origen {
    my ($self)  = shift;
    my ($id_ui) = @_;
    $self->id_ui_origen($id_ui);
}

sub getId_ui_prestamo {
    my ($self) = shift;
    return ( $self->id_ui_prestamo );
}

sub setId_ui_prestamo {
    my ($self)           = shift;
    my ($id_ui_prestamo) = @_;
    $self->id_ui_prestamo($id_ui_prestamo);
}

sub getFecha_devolucion {
    my ($self) = shift;
    return ( $self->fecha_devolucion );
}

sub getFecha_devolucion_formateada {
    my ($self) = shift;
    my $dateformat = C4::Date::get_date_format();
    return C4::Date::format_date( $self->getFecha_devolucion, $dateformat );
}

sub setFecha_devolucion {
    my ($self)             = shift;
    my ($fecha_devolucion) = @_;
    $self->fecha_devolucion($fecha_devolucion);
}

sub getRenovaciones {
    my ($self) = shift;
    return ( $self->renovaciones );
}

sub setRenovaciones {
    my ($self)         = shift;
    my ($renovaciones) = @_;
    $self->renovaciones($renovaciones);
}

sub getFecha_ultima_renovacion {
    my ($self) = shift;
    return ( $self->fecha_ultima_renovacion );
}

sub getFecha_ultima_renovacion_formateada {
    my ($self) = shift;
    my $dateformat = C4::Date::get_date_format();
    return C4::Date::format_date( $self->getFecha_ultima_renovacion,
        $dateformat );
}

sub setFecha_ultima_renovacion {
    my ($self)                    = shift;
    my ($fecha_ultima_renovacion) = @_;
    $self->fecha_ultima_renovacion($fecha_ultima_renovacion);
}

sub setFecha_vencimiento_reporte {
    my ($self)                      = shift;
    my ($fecha_vencimiento_reporte) = @_;
    $self->fecha_vencimiento_reporte($fecha_vencimiento_reporte);
}

sub getTimestamp {
    my ($self) = shift;
    return ( $self->timestamp );
}

=item
agregar
Funcion que agrega un prestamo
=cut

sub agregar {
    my ($self)      = shift;
    my ($data_hash) = @_;
    $self->debug("SE AGREGO EL PRESTAMO");

    my $dateformat = C4::Date::get_date_format();
    my $hoy = Date::Manip::ParseDate("today");

    #Asignando data...


    $self->setId3( $data_hash->{'id3'} );
    $self->setNro_socio( $data_hash->{'nro_socio'} );
    $self->setFecha_prestamo(C4::Date::format_date_in_iso($hoy, $dateformat));
    $self->setTipo_prestamo( $data_hash->{'tipo_prestamo'} );
    $self->setId_ui_origen( $data_hash->{'id_ui'} );
    $self->setId_ui_prestamo( $data_hash->{'id_ui_prestamo'} );
    $self->setRenovaciones(0);
    $self->fecha_vencimiento_reporte($self->getFecha_vencimiento());
    $self->save();

#**********************************Se registra el movimiento en rep_historial_circulacion***************************
    $self->debug("Se loguea en historico de circulacion el prestamo");
    my $responsable = $data_hash->{'responsable'};
    my $tipo_operacion = "PRESTAMO";
    C4::AR::Prestamos::agregarPrestamoAHistorialCirculacion($self,$tipo_operacion,$responsable);
#*******************************Fin***Se registra el movimiento en rep_historial_circulacion*************************
}

sub prestar {
    my ($self) = shift;
    my ( $params, $msg_object ) = @_;

    my $nro_socio = $params->{'nro_socio'};
    my $id2       = $params->{'id2'};
    my $id3       = $params->{'id3'};
    C4::AR::Debug::debug( "_chequeoParaPrestamo=> id2: " . $id2 );
    C4::AR::Debug::debug( "_chequeoParaPrestamo=> id3: " . $id3 );
    C4::AR::Debug::debug( "_chequeoParaPrestamo=> nro_socio: " . $nro_socio );
    C4::AR::Debug::debug( "_chequeoParaPrestamo=> tipo_prestamo: " . $params->{'tipo_prestamo'} );

    #Se verifica si ya se tiene la reserva sobre el grupo

    my ( $reservas, $cant_reservas_asignadas )  = C4::AR::Reservas::getReservasDeSocioAsignadas( $nro_socio, $id2 ,$self->db);

    my ( $reservas, $cant_reservas_espera )     = C4::AR::Reservas::getReservasDeSocioEnEspera( $nro_socio, $id2 ,$self->db);

    my ( $reservas )  = C4::AR::Reservas::getReservasDeSocio( $nro_socio, $id2 ,$self->db);

    my $cant_reservas_total                     = $cant_reservas_asignadas + $cant_reservas_espera;
#********************************        VER!!!!!!!!!!!!!! *************************************************
# Si tiene un ejemplar prestado de ese grupo no devuelve la reserva porque en el where estado <> P, Salta error cuando se quiere crear una nueva reserva por el else de abajo. El error es el correcto, pero se puede detectar antes.
# Tendria que devolver todas las reservas y despues verificar los tipos de prestamos de cada ejemplar (notforloan)
# Si esta prestado la clase de prestamo que se quiere hacer en este momento.
# Si no esta prestado se puede hacer lo de abajo, lo que sigue (estaba pensado para esa situacion).
# Tener en cuenta los prestamos especiales, $tipo_prestamo ==> ES ---> SA. **** VER!!!!!!
    my $disponibilidad = C4::AR::Reservas::getDisponibilidad($id3);

    my $ejemplar  = C4::AR::Nivel3::getNivel3FromId3($id3);
    if ( ($cant_reservas_total >= 1) && ($ejemplar->esParaPrestamo) ) {

        #El usuario ya tiene la reserva,
        $self->debug( "El usuario ya tiene una reserva ID::: " . $reservas->[0]->getId_reserva );
        $params->{'id_reserva'} = $reservas->[0]->getId_reserva;

        #Si tiene una reserva asignada a un ejemplar del mismo grupo se intercambian
        if (($reservas->[0]->getId3)&&( $id3 != $reservas->[0]->getId3 )) {
            $self->debug("Los ids son distintos, se intercambian");

#se le esta entregando un item que es <> al que se le asigno al relizar la reserva
#Se intercambiaron los id3 de las reservas, si el item que se quiere prestar esta prestado se devuelve el error.
#Los ids son distintos, se intercambian.
            $reservas->[0]->intercambiarId3( $id3, $msg_object , $self->db);
        }

    }

    else {
        if (($cant_reservas_asignadas >= 1) && ($ejemplar->esParaSala) && (!C4::AR::Preferencias::getValorPreferencia("prestar_mismo_grupo_distintos_tipos_prestamo"))){
            $msg_object->{'error'} = 1;
            C4::AR::Mensajes::add( $msg_object,{ 'codMsg' => 'R005', 'params' => [] } );
        }else{
            #NO EXITE LA RESERVA -> HAY QUE RESERVAR!!!
            $self->debug("NO EXITE LA RESERVA -> HAY QUE RESERVAR!!!");

            my $seReserva = 1;

            #Se verifica disponibilidad del item;
            my $reserva = C4::AR::Reservas::getReservaDeId3($id3,$self->db);

            if ($reserva) {
                $self->debug("El item se encuentra reservado, y hay que buscar otro item del mismo grupo para asignarlo a la reserva del otro usuario");

    #el item se encuentra reservado, y hay que buscar otro item del mismo grupo para asignarlo a la reserva del otro usuario
                my ($nivel3) = C4::AR::Reservas::getNivel3ParaReserva( $params->{'id2'},$self->db );
                if ($nivel3) {

             #CAMBIAMOS EL ID3 A OTRO LIBRE Y ASI LIBERAMOS EL QUE SE QUIERE PRESTAR
                    $self->debug("CAMBIAMOS EL ID3 A OTRO LIBRE Y ASI LIBERAMOS EL QUE SE QUIERE PRESTAR : Reserva: ".$reserva->getId_reserva." Nuevo id3: ".$nivel3->getId3);
                    $reserva->setId3( $nivel3->getId3 );
                    $reserva->save();

                    # el id3 de params quedo libre para ser reservado

                }
                else {
                    $self->debug("NO HAY EJEMPLARES LIBRES PARA EL PRESTAMO");

       # NO HAY EJEMPLARES LIBRES PARA EL PRESTAMO, SE PONE EL ID3 EN "" PARA QUE SE
       # REALIZE UNA RESERVA DE GRUPO, SI SE PERMITE.
                    $params->{'id3'} = "";
                    if (!C4::AR::Preferencias::getValorPreferencia('intranetGroupReserve')){

                        #NO SE PERMITE LA RESERVA DE GRUPO
                        $seReserva = 0;

                    #Hay error no se permite realizar una reserva de grupo en intra.
                        $self->debug("Hay error no se permite realizar una reserva de grupo en intra");
                        $msg_object->{'error'} = 1;
                        C4::AR::Mensajes::add( $msg_object,
                            { 'codMsg' => 'R004', 'params' => [] } );
                    }
                    else {

                        #SE PERMITE LA RESERVA DE GRUPO
                        $self->debug(
                            "No hay error, se realiza una reserva de grupo");

                        #No hay error, se realiza una reserva de grupo.
                        $msg_object->{'error'} = 1;
                        C4::AR::Mensajes::add( $msg_object,
                            { 'codMsg' => 'R005', 'params' => [] } );
                    }
                }
            }

            #Se realiza una reserva
            if ($seReserva) {
                $self->debug("Se realiza una reserva!! ");

                my ($reserva) = C4::Modelo::CircReserva->new( db => $self->db );
                my ($paramsReserva) = $reserva->reservar($params);
                $params->{'id_reserva'} = $reserva->getId_reserva;
                $self->debug(
                    "Se realizo la reserva ID: " . $params->{'id_reserva'} );
            }
        }
    }

    if ( !$msg_object->{'error'} ) {

        #No hay error, se realiza el pretamo
        $self->debug("Se va a insertar el prestamo");
        C4::AR::Debug::debug(
            "responsable desde CircPrestamo antes de insertarPrestamo: "
              . $params->{'responsable'} );
        $self->insertarPrestamo($params);
        $self->debug(
            "se realizan las verificacioines luego de realizar el prestamo");

#se realizan lgetFecha_vencimiento_formateadaas verificacioines luego de realizar el prestamo
        $self->_verificacionesPostPrestamo( $params, $msg_object );
    }

}

sub insertarPrestamo {
    my ($self)   = shift;
    my ($params) = @_;

    my ($reserva) =  C4::AR::Reservas::getReserva( $params->{'id_reserva'}, $self->db );
    $self->debug("Se actualiza el estado de la reserva a P = Prestado a la reserva " . $reserva->getId2 );

    #Se actualiza el estado de la reserva a P = Prestado
    $reserva->setEstado('P');
    $reserva->save();

    $self->debug("Se borra la sancion correspondiente a la reserva porque se esta prestando el biblo");

    # Se borra la sancion correspondiente a la reserva porque se esta prestando el biblo
    $reserva->borrar_sancion_de_reserva($self->db);

    $self->debug("Se realiza el prestamo del item");
    C4::AR::Debug::debug( "CircPrestamo => insertarPrestamo => responsable "  . $params->{'responsable'} );

    #Se realiza el prestamo del item
    $self->agregar($params);

}    #end insertarPrestamo

=item
Esta funcion se utiliza para verificar post condiciones luego de un prestamo, y realizar las operaciones que sean necesarias
=cut

sub _verificacionesPostPrestamo {
    my ($self) = shift;
    my ( $params, $msg_object ) = @_;

#Se verifica si el usuario llego al maximo de prestamos, se caen las demas reservas
    if (
        C4::AR::Prestamos::_verificarMaxTipoPrestamo(
            $params->{'nro_socio'},
            $params->{'tipo_prestamo'}
        )
      )
    {
        $self->debug( "Se verifica si el usuario llego al maximo de prestamos, se caen las demas reservas");
        $params->{'tipo'}      = "INTRA";
        $msg_object->{'error'} = 0;
        C4::AR::Mensajes::add( $msg_object, { 'codMsg' => 'P108', 'params' => [ $params->{'barcode'} ] } );
        my ($reserva) = C4::Modelo::CircReserva->new( db => $self->db );
        $reserva->cancelar_reservas_inmediatas($params);
    }
    else {

        # Se realizo el prestamo con exito
        $msg_object->{'error'} = 0;
        C4::AR::Mensajes::add( $msg_object,
            { 'codMsg' => 'P103', 'params' => [ $params->{'barcode'} ] } );
    }
}

sub estaVencido {
    my ($self) = shift;

    my $dateformat = C4::Date::get_date_format();
    my $hoy =  C4::Date::format_date_in_iso( Date::Manip::ParseDate("today"), $dateformat );
    my $cierre = C4::AR::Preferencias::getValorPreferencia("close");
    my $close  = Date::Manip::ParseDate($cierre);
    my $err;

    if ( Date::Manip::Date_Cmp( $close, Date::Manip::ParseDate("today") ) < 0 )
    {    #Se paso la hora de cierre
        $hoy = C4::Date::format_date_in_iso(Date::Manip::DateCalc( $hoy, "+ 1 day", \$err ), $dateformat);
    }

    my $df = C4::Date::format_date_in_iso( $self->getFecha_vencimiento, $dateformat );

    if ( Date::Manip::Date_Cmp( $df, $hoy ) < 0 ) { return 1; }
    else {

        if ( $self->getTipo_prestamo eq 'ES' ) {    #Prestamo especial
            $self->debug("Prestamo Especial !!");
            if ( Date::Manip::Date_Cmp( $df, $hoy ) == 0 )
            {                                       #Se tiene que devolver hoy

                $self->debug("Se tiene que devolver hoy!!!");

                my $end    = C4::Date::calc_endES();
                my $actual = Date::Manip::ParseDate("now");
                $self->debug("HORA PE VENCIMIENTO ".$end." ACTUAL ".$actual);

                if ( Date::Manip::Date_Cmp( $actual, $end ) > 0 )
                {    #Se devuelve despues del limite
                    $self->debug("PE VENCIDO");
                    return (1);
                }
            }
        }    #Fin ES
    }

    #No esta vencido
    return 0;
}

=item
la fecha en que vence el prestamo
=cut

sub getFecha_vencimiento {
    my ($self) = shift;


    #$self->debug( "getFecha_vencimiento!!!");
    my $plazo_actual;
    my $vencimiento;
    my $desde_proximos;
    my $apertura;
    my $cierre;

    eval {
        if ( $self->getRenovaciones > 0 )
        { #quiere decir que ya fue renovado entonces tengo que calcular sobre los dias de un prestamo renovado para saber si estoy en fecha


            # $self->debug( "getFecha_vencimiento => SE RENOVO ".$self->getRenovaciones." VECES, LA ULTIMA ".$self->getFecha_ultima_renovacion );
            $plazo_actual = $self->tipo->getDias_renovacion;
            ($desde_proximos,$vencimiento,$apertura,$cierre) = C4::Date::proximosHabiles($plazo_actual, 0, $self->getFecha_ultima_renovacion);

            # $self->debug( "getFecha_vencimiento => DIAS A AGREGAR ".$self->tipo->getDias_renovacion);
            # $self->debug( "getFecha_vencimiento => VENCE  ".$vencimiento);


        }
        else
        { #es la primer renovacion por lo tanto tengo que ver sobre los dias de un prestamo normal para saber si estoy en fecha de renovacion
            $plazo_actual = $self->tipo->getDias_prestamo;
            # $self->debug( "PLAZO ACTUAL => DIAS ".$plazo_actual);
            ($desde_proximos,$vencimiento,$apertura,$cierre) = C4::Date::proximosHabiles($plazo_actual, 0, $self->getFecha_prestamo);
        }
    };

    return ($vencimiento);
}

sub getFecha_vencimiento_formateada {
    my ($self) = shift;
    my $dateformat = C4::Date::get_date_format();
    return C4::Date::format_date( $self->getFecha_vencimiento, $dateformat );
}

=item
la funcion devolver recibe una hash y actualiza la tabla de CircPrestamo,la tabla de CircReserva , de RepHistorialCirculacion y
RepHistorialPrestamo. Realiza las comprobaciones para saber si hay reservas esperando en ese momento para ese item, si
las hay entonces realiza las actualizaciones y envia un mail al socio correspondiente.
=cut

sub devolver {
    my ($self)   = shift;
    my ($db) = shift;
    my ($params) = @_;

    my $id3          = $params->{'id3'};
    my $tipo         = $params->{'tipo'};
    my $responsable  = $params->{'responsable'};

    #     my $msg_object= C4::AR::Mensajes::create();
    #se setea el barcode para informar al usuario en la devolucion

    $self->debug("Actualizo la fecha de devolucion!!!!");

    my $fechaVencimiento = $self->getFecha_vencimiento;    # tiene que estar aca porque despues ya se marco como devuelto
    #Actualizo la fecha de devolucion!!!!
    my $dateformat = C4::Date::get_date_format();
    my $fechaHoy =  C4::Date::format_date_in_iso( Date::Manip::ParseDate("today"), $dateformat );
    $self->setFecha_devolucion($fechaHoy);
    $self->save();

    my $disponibilidad = C4::AR::Reservas::getDisponibilidad($id3);
    $self->debug("Busco la reserva del prestamo");

    #Busco la reserva del prestamo
    my $reservas_array_ref = C4::Modelo::CircReserva::Manager->get_circ_reserva(
                        db    => $db,
                        query => [ id3 => { eq => $id3 }, estado => { eq => 'P' } ]
    );
    my $reserva = $reservas_array_ref->[0];

    if ($reserva) {

        #Si la reserva que voy a borrar existia realmente sino hubo un error
        $self->debug("Si la reserva que voy a borrar existia realmente sino hubo un error");

        if ( $disponibilidad eq 'Domiciliario' ) {    #si no es para sala
            $self->debug("reasignar Reserva En Espera");
            $reserva->reasignarEjemplarASiguienteReservaEnEspera($responsable);
        }

        $self->debug("Se borra la reserva");

#Haya o no uno esperando elimino el que existia porque la reserva se esta cancelando
        $reserva->delete();

        $self->debug("Se loguea en historico de circulacion la devolucion");

#**********************************Se registra el movimiento en rep_historial_circulacion***************************
    $self->debug("Se loguea en historico de circulacion el prestamo");
    my $tipo_operacion = "DEVOLUCION";
    C4::AR::Prestamos::agregarPrestamoAHistorialCirculacion($self,$tipo_operacion,$responsable);
#*******************************Fin***Se registra el movimiento en rep_historial_circulacion*************************

### SANCIONES  Se sanciona al usuario si es necesario, solo si se devolvio el item correctamente
        my $hasdebts = 0;
        my $sanction = 0;
        my $fechaFinSancion;

# Hay que ver si devolvio el ejemplar a termino para, en caso contrario, aplicarle una sancion
        my $daysissue = $self->tipo->getDias_prestamo;

        use C4::AR::Sanciones;

        my $diasSancion =  C4::AR::Sanciones::diasDeSancion( $fechaHoy, $fechaVencimiento,$self->socio->getCod_categoria ,$self->getTipo_prestamo );


      C4::AR::Debug::error("DIAS DE SANCION: ".$diasSancion);


        if ( $diasSancion > 0 ) {


# Se calcula el tipo de sancion que le corresponde segun la categoria del prestamo devuelto tardiamente y la categoria de usuario que tenga

            $self->debug("SANCION!!  DIAS: $diasSancion");



            $self->debug("SANCION!!  TIPO PRESTAMO: ".$self->getTipo_prestamo." CATEGORIA SOCIO: ".$self->socio->getCod_categoria);

            my $tipo_sancion =  C4::AR::Sanciones::getTipoSancion( $self->getTipo_prestamo,$self->socio->getCod_categoria );

            $self->debug("SANCION!!  TIPO SANCION: ".$tipo_sancion->getTipo_sancion);

            if ( C4::AR::Sanciones::tieneLibroVencido( $self->getNro_socio , $self->db ) )
            {

# El usuario tiene libros vencidos en su poder (es moroso)
#SE INSERTA UNA SANCION PENDIENTE (se va a hacer efectiva al devolver el ultimo libro!!)
                $self->debug("SE INSERTA UNA SANCION PENDIENTE");
                use C4::Modelo::CircSancion;
                my $sancion = C4::Modelo::CircSancion->new( db => $self->db );
                my %paramsSancion;
                $paramsSancion{'responsable'} = $responsable;
                $paramsSancion{'tipo_sancion'} = $tipo_sancion->getTipo_sancion;
                $paramsSancion{'id_reserva'}   = undef;
                $paramsSancion{'fecha_comienzo'} = undef;
                $paramsSancion{'fecha_final'}    = undef;
                $paramsSancion{'id3'}         = $self->getId3;
                $paramsSancion{'nro_socio'}      = $self->getNro_socio;
                $paramsSancion{'dias_sancion'}   = $diasSancion;
                $sancion->insertar_sancion_pendiente( \%paramsSancion );
                $hasdebts = 1;
            }
            else {

                #SANCION EFECTIVA
                $self->debug("SANCION EFECTIVA a ".$self->getNro_socio);
                my $err;

# Se calcula la fecha de fin de la sancion en funcion de la fecha actual (hoy + cantidad de dias de sancion)
                $fechaFinSancion = C4::Date::format_date_in_iso(
                    Date::Manip::DateCalc(
                        Date::Manip::ParseDate("today"), "+ " . $diasSancion . " days",
                        \$err
                    ),
                    $dateformat
                );

                use C4::Modelo::CircSancion;
                my $sancion = C4::Modelo::CircSancion->new( db => $self->db );
                my %paramsSancion;
                $paramsSancion{'responsable'}   = $responsable;
                $paramsSancion{'tipo_sancion'}   = $tipo_sancion->getTipo_sancion;
                $paramsSancion{'id_reserva'}     = undef;
                $paramsSancion{'id3'}         = $self->getId3;
                $paramsSancion{'nro_socio'}      = $self->getNro_socio;
                $paramsSancion{'fecha_comienzo'} = $fechaHoy;
                $paramsSancion{'fecha_final'}    = $fechaFinSancion;
                $paramsSancion{'dias_sancion'}   = $diasSancion;
                $sancion->insertar_sancion( \%paramsSancion );
                $sanction = 1;

                #Se borran las reservas del usuario sancionado
                my $reserva = C4::Modelo::CircReserva->new( db => $self->db );

                $reserva->cancelar_reservas_socio( \%paramsSancion );
            }
        }
### FIN SANCIONES

#**********************************Se registra el movimiento en rep_historial_prestamo***************************
        use C4::Modelo::RepHistorialPrestamo;
        my $historial_prestamo =  C4::Modelo::RepHistorialPrestamo->new( db => $self->db );
        $historial_prestamo->agregarPrestamo($self,$fechaVencimiento);

        #AHORA SE BORRA EL PRESTAMO DEVUELTO PASADO AL HISTORICO DE PRESTAMOS
        $self->delete();

#**********************************Se registra el movimiento en rep_historial_prestamo***************************

    }

}

sub estaEnFechaDeRenovacion {
    my ($self) = shift;

    my $err;
    my $dateformat = C4::Date::get_date_format();
    my $hoy =  C4::Date::format_date_in_iso(Date::Manip::DateCalc( Date::Manip::ParseDate("today"), "+ 0 days", \$err ), $dateformat );

#Agregados para que renueve los sabados tambien
    my $apertura               =C4::AR::Preferencias::getValorPreferencia("open");
    my $cierre                 =C4::AR::Preferencias::getValorPreferencia("close");
    my $first_day_week         =C4::AR::Preferencias::getValorPreferencia("primer_dia_semana");
    my $last_day_week          =C4::AR::Preferencias::getValorPreferencia("ultimo_dia_semana");
    my ($actual,$min,$hora)    = localtime;

    $actual=($hora).':'.$min;
    Date_Init("WorkDayBeg=".$apertura,"WorkDayEnd=".$cierre);
    Date_Init("WorkWeekBeg=".$first_day_week,"WorkWeekEnd=".$last_day_week);
#fin agregados

    my $desde = C4::Date::format_date_in_iso(Date::Manip::DateCalc($self->getFecha_vencimiento,"- ".$self->tipo->getDias_antes_renovacion . " business days",\$err),$dateformat );
    my $flag = Date_Cmp( $desde, $hoy );


    #comparo la fecha de hoy con el inicio del plazo de renovacion
    if ( !( $flag gt 0 ) ) {

#quiere decir que la fecha de hoy es mayor o igual al inicio del plazo de renovacion
#ahora tengo que ver que la fecha de hoy sea anterior al vencimiento
        my $flag2 = Date_Cmp( $self->getFecha_vencimiento, $hoy );
        if ( !( $flag2 lt 0 ) ) {

            #la fecha esta ok, se puede renovar
            return 1;
        }
    }
    return 0;
}

=item
Se verifica que se cumplan las condiciones para poder renovar
=cut

sub _verificarParaRenovar {
    my ($self)       = shift;
    my ($msg_object, $type) = @_;

    C4::AR::Debug::debug($type);
    #Se que estemos dentro de la fecha en que se puede realizar la renovacion
    if ( !$self->estaEnFechaDeRenovacion ) {
        $self->debug(
            "_verificarParaRenovar - NO estamos en fecha de renovacion");
        $msg_object->{'error'} = 1;
        C4::AR::Mensajes::add( $msg_object,
            { 'codMsg' => 'P119', 'params' => [] } );
    }

    if ( !( $msg_object->{'error'} ) && ( !$self->socio->esRegular ) ) {

        # El usuario es regular?
        $self->debug("_verificarParaRenovar - socio no es regular");
        $msg_object->{'error'} = 1;
        C4::AR::Mensajes::add( $msg_object,
            { 'codMsg' => 'U300', 'params' => [] } );
    }

    if ($type eq "opac"){

        if ( !( $msg_object->{'error'} )  && !($self->socio->cumpleRequisito ))
        {
                # El usuario cumple condicion?
                $self->debug("_verificarParaRenovar - socio no cumple condicion");
                $msg_object->{'error'} = 1;
                C4::AR::Mensajes::add( $msg_object, { 'codMsg' => 'P114', 'params' => [] } );
            }

    }
    #Busco si tiene una sancion pendiente
    my $sancion_pendiente =
      C4::AR::Sanciones::tieneSancionPendiente( $self->getNro_socio,
        $self->db );

    if ( !( $msg_object->{'error'} ) && ($sancion_pendiente) ) {

        # El usuario tiene una sancion pendiente?
        $self->debug("_verificarParaRenovar - socio con sancion pendiente");
        $msg_object->{'error'} = 1;
        C4::AR::Mensajes::add( $msg_object, { 'codMsg' => 'S201', 'params' => [] } );
    }

    my $sancion = C4::AR::Sanciones::estaSancionado( $self->getNro_socio,
        $self->getTipo_prestamo );
    if ( !( $msg_object->{'error'} ) && ($sancion) ) {

        # El usuario tiene una sancion ?
        $self->debug("_verificarParaRenovar - socio sancionado");
        $msg_object->{'error'} = 1;
        C4::AR::Mensajes::add(
            $msg_object,
            {
                'codMsg' => 'S200',
                'params' => [ $sancion->getFecha_final_formateada ]
            }
        );
    }

    if (!( $msg_object->{'error'})&&( C4::AR::Reservas::reservasEnEspera( $self->nivel3->nivel2->getId2 )))
    {
        #Hay alguna reserva pendiente?
        $self->debug("_verificarParaRenovar - grupo con reserva pendiente");
        $msg_object->{'error'} = 1;
        C4::AR::Mensajes::add( $msg_object,{ 'codMsg' => 'P120', 'params' => [] } );
    }

    if (  !( $msg_object->{'error'} )
        && ( $self->getRenovaciones == $self->tipo->getRenovaciones ) )
    {

        # Se llego al maximo de renovaciones?
        $self->debug(
            "_verificarParaRenovar - Se llego al maximo de renovaciones");
        $msg_object->{'error'} = 1;
        C4::AR::Mensajes::add( $msg_object,
            { 'codMsg' => 'R012', 'params' => [] } );
    }

    if ( !( $msg_object->{'error'} ) && ( $self->estaVencido ) ) {

        # Esta vencido?
        $self->debug("_verificarParaRenovar - esta vencido");
        $msg_object->{'error'} = 1;
        C4::AR::Mensajes::add( $msg_object,
            { 'codMsg' => 'P118', 'params' => [] } );
    }

    #Tiene algún ejemplar prestado vencido??
    my ($vencidos,$prestados) = C4::AR::Prestamos::cantidadDePrestamosPorUsuario($self->getNro_socio);

    if ( !( $msg_object->{'error'} ) && ( $vencidos > 0 ) ) {

        # Tiene algún ejempĺar vencido
        $self->debug("_verificarParaRenovar - tiene prestamo vencido");
        $msg_object->{'error'} = 1;
        C4::AR::Mensajes::add( $msg_object,
            { 'codMsg' => 'P131', 'params' => [] } );
    }


    #Se verifica que la operación este dentro del horario de funcionamiento de la biblioteca.
    #SOLO PARA INTRA
    if(!$msg_object->{'error'} && $msg_object->{'tipo'} eq 'INTRA' && !C4::AR::Preferencias::getValorPreferencia("operacion_fuera_horario") && C4::AR::Reservas::_verificarHorario()){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P127', 'params' => []} ) ;
        C4::AR::Debug::debug("CircPrestamo.pm => _verificarParaRenovar => Entro al if de operacion fuera de horario");
    }

}

sub sePuedeRenovar {
    my ($self) = shift;

    #Si no dan errores las verificaciones, se puede renovar
    my ($msg_object) = C4::AR::Mensajes::create();
    $msg_object->{'error'} = 0;
    $self->_verificarParaRenovar($msg_object);
    return ( !$msg_object->{'error'} );
}


sub sePuedeRenovar_text{
    my ($self) = shift;

    #Si no dan errores las verificaciones, se puede renovar
    my ($msg_object) = C4::AR::Mensajes::create();
    $msg_object->{'error'} = 0;
    $self->_verificarParaRenovar($msg_object,);

    my $cod_msg = C4::AR::Mensajes::getFirstCodeError($msg_object);

    return ( C4::AR::Mensajes::getMensaje($cod_msg,$msg_object->{'tipo'}) );

}

=item
renovar
=cut

sub renovar {
    my ($self)         = shift;
    my ($responsable) = @_;

    $self->setRenovaciones( $self->getRenovaciones + 1 );
    my $dateformat = C4::Date::get_date_format();
    my $fechaHoy = C4::Date::format_date_in_iso(Date::Manip::ParseDate("today"),$dateformat);

    $self->setFecha_ultima_renovacion($fechaHoy);
    $self->save();

    if ($self->nivel3->esParaPrestamo){
        #**********************************Se registra el movimiento en rep_historial_circulacion***************************
        $self->debug("Se loguea en historico de circulacion el prestamo");

        my $tipo_operacion = "RENOVACION";
        my $hasta = $self->getFecha_vencimiento;
        C4::AR::Prestamos::agregarPrestamoAHistorialCirculacion($self,$tipo_operacion,$responsable,$hasta);
        #*******************************Fin***Se registra el movimiento en rep_historial_circulacion*************************
    }

    $self->setFecha_vencimiento_reporte($self->getFecha_vencimiento);
    $self->save();

}

sub getInvolvedCount {

    my ($self) = shift;
    my ( $campo, $value ) = @_;
    my @filtros;
    push (@filtros, ( $campo->getCampo_referente => $value ) );
    C4::AR::Debug::debug("CircPrestamo=> getInvolvedCount => $campo || $value" );

    my $circ_prestamo_count =  C4::Modelo::CircPrestamo::Manager->get_circ_prestamo_count(query => \@filtros );
    return ($circ_prestamo_count);
}

sub replaceBy {

    my ($self) = shift;
    my ( $campo, $value, $new_value ) = @_;
    my @filtros;
    push( @filtros, ( $campo => { eq => $value }, ) );
    my $replaced = C4::Modelo::CircPrestamo::Manager->update_circ_prestamo(
        where => \@filtros,
        set   => { $campo => $new_value }
    );
}

1;
