package C4::AR::Prestamos;

use strict;
require Exporter;
#use DBI;
use C4::Date qw(get_date_format format_date_in_iso);
#use C4::AR::Reservas;
use C4::Modelo::CircPrestamo;
use C4::Modelo::CircPrestamo::Manager;
use C4::Modelo::RepHistorialPrestamo;
use C4::Modelo::RepHistorialPrestamo::Manager;
# use C4::Modelo::CatRegistroMarcN3;
# use C4::Modelo::CatRegistroMarcN3::Manager;
# use C4::Modelo::CatRegistroMarcN2;
# use C4::Modelo::CatRegistroMarcN2::Manager;
use Date::Manip;
use C4::Modelo::RepHistorialPrestamo::Manager;
use C4::AR::Sanciones;
#use Date::Manip;
#use Thread;
#use Mail::Sendmail;

use vars qw($VERSION @ISA @EXPORT_OK %EXPORT_TAGS);

$VERSION = 3;

@ISA = qw(Exporter);

@EXPORT_OK = qw(

    t_devolver
    t_renovar
    t_renovarOPAC
    t_realizarPrestamo
    _verificarMaxTipoPrestamo
    chequeoDeFechas
    prestamosHabilitadosPorTipo
    getTipoPrestamo
    getPrestamoDeId3
    getPrestamosDeSocio
    getTipoPrestamo
    obtenerPrestamosDeSocio
    cantidadDePrestamosPorUsuario
    crearTicket
    t_eliminarTipoPrestamo
    t_agregarTipoPrestamo
    t_modificarTipoPrestamo
    cantidadDeUsoTipoPrestamo
    getInfoPrestamo
    getHistorialPrestamosVigentesParaTemplate
    tienePrestamos
    enviarRecordacionDePrestamo
    getAllPrestamosVencidos
    getAllPrestamosActivos
    setPrestamosVencidosTemp
    getAllPrestamosVencidosParaMail
    tienePrestamosDeId2
);


=head2
    sub getInfoPrestamo
=cut
sub getInfoPrestamo{

    my ($id_prestamo,$db) = @_;
    my @filtros;
    my $db_temp = C4::Modelo::CircPrestamo->new()->db;
    push (@filtros, (id_prestamo => {eq => $id_prestamo} ) );
    $db = $db || $db_temp;
    my $prestamos = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo( query => \@filtros,
                                                                          db => $db,
                                                                          require_objects => ['nivel3','socio','socio.categoria','ui','tipo'],
                                                                        );

    if (scalar(@$prestamos)){
        return ($prestamos->[0]);
    }
    return (0);
}


=head2
    sub _verificarMaxTipoPrestamo
=cut
sub _verificarMaxTipoPrestamo{
    my ($nro_socio, $tipo_prestamo) = @_;

    my $error = 0;

    #Obtengo la cant maxima de prestamos de ese tipo que se puede tener
    my $tipo = C4::AR::Prestamos::getTipoPrestamo($tipo_prestamo);
    if ($tipo){
        my $prestamos_maximos= $tipo->getPrestamos;
        #

        #Obtengo la cant total de prestamos actuales de ese tipo que tiene el usuario
        my @filtros;
        push(@filtros, ( fecha_devolucion   => { eq => undef } ));
        push(@filtros, ( nro_socio          => { eq => $nro_socio}) );
        push(@filtros, ( tipo_prestamo      => { eq => $tipo_prestamo}) );

        my $cantidad_prestamos= C4::Modelo::CircPrestamo::Manager->get_circ_prestamo_count( query => \@filtros, require_objects => ['tipo']);


        if ($cantidad_prestamos >= $prestamos_maximos) {$error=1}
    }

    return $error;
}

=head2
    sub prestamosHabilitadosPorTipo
    Esta funcion devuelve los tipos de prestamos permitidos para un usuario, en un arreglo de hash.
=cut
sub prestamosHabilitadosPorTipo {
    my ($codigo_disponibilidad, $nro_socio) = @_;

    #Se buscan todas las sanciones de un usuario
    my $sanciones= C4::AR::Sanciones::tieneSanciones($nro_socio);

    #Trae todos los tipos de prestamos que estan habilitados
    my $tipos_habilitados_array_ref = C4::Modelo::CircRefTipoPrestamo::Manager->get_circ_ref_tipo_prestamo(
                                                                        query => [
                                                                                codigo_disponibilidad   => { eq => $codigo_disponibilidad },
                                                                                habilitado          => { eq => 1},
                                                                                id 					=> { ne => 0 } # No debe mostrar NUNCA el tipo RESERVA
                                                                            ],
                                        );



    my @tipos;
    foreach my $tipo_prestamo (@$tipos_habilitados_array_ref){
        my $estaSancionado= 0;


        if($sanciones){
        #tiene sanciones
            foreach my $sancion (@$sanciones){
                if(($sancion->getTipo_sancion ne 0)&&($sancion->getTipo_sancion ne -1)){#Si no es una sancion por una Reserva (0) o Manual (-1)
                    #tipos de prestamo que afecta
                    my @tipos_prestamo_sancion=$sancion->ref_tipo_sancion->ref_tipo_prestamo_sancion;
                    foreach my $tipo_prestamo_sancion (@tipos_prestamo_sancion){
                        if ($tipo_prestamo_sancion->getTipo_prestamo eq $tipo_prestamo->getId_tipo_prestamo){
                            $estaSancionado= 1;
                        }
                    }
                }
            }# END foreach my $sancion (@$sanciones)
        }

        my $tipo;

        if(!$estaSancionado){
            #solo se agrega si no esta sancionado para ese tipo de prestamo
            $tipo->{'value'}= $tipo_prestamo->getId_tipo_prestamo;
            $tipo->{'label'}= $tipo_prestamo->getDescripcion;
            push(@tipos,$tipo)
        }
    }

    return(\@tipos);
}

=head2
    sub getCountPrestamosDeGrupoPorUsuario
=cut
sub getCountPrestamosDeGrupoPorUsuario {
#devuelve la cantidad de prestamos de grupo del usuario
    my ($nro_socio, $id2, $tipo_prestamo)=@_;

        use C4::Modelo::CircPrestamo;
        use C4::Modelo::CircPrestamo::Manager;

        my @filtros;
        push(@filtros, ( id2                => { eq => $id2 } ));
        push(@filtros, ( nro_socio          => { eq => $nro_socio } ));

    	#Se tiene en cuenta el tipo de préstamo al contar los prestamos del grupo?? Esto permitiría prestar varios ejemplares del mismo grupo con distintos tipos de prestamo.
    	if(C4::AR::Preferencias::getValorPreferencia('prestar_mismo_grupo_distintos_tipos_prestamo')){
    	  push(@filtros, ( tipo_prestamo      => { eq => $tipo_prestamo } ));
    	}

        push(@filtros, ( fecha_devolucion   => { eq => undef } ));

        my $prestamos_grupo_count = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo_count(
                                                                                        query => \@filtros,
                                                                                        with_objects => [ 'nivel3' ]
                                                            );

        C4::AR::Debug::debug("\n\n\n\n\n\n\n"."CANTIDA DE PRESTAMOS DE ".$nro_socio. " PARA ".$tipo_prestamo." --------------------------- > ".$prestamos_grupo_count."\n\n\n\n\n\n\n");
        return ($prestamos_grupo_count);
}

=head2
    sub getCountPrestamosDelRegistro
    Esta funcion devuelve la cantidad de prestamos por grupo
=cut
sub getCountPrestamosDelRegistro{
    my ($id1) = @_;

    use C4::Modelo::CircPrestamo;
    use C4::Modelo::CircPrestamo::Manager;

    my @filtros;
    push(@filtros, ( id1                => { eq => $id1 } ));
    push(@filtros, ( fecha_devolucion   => { eq => undef } ));

    my $prestamos_grupo_count = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo_count(
                                                                                query => \@filtros,
                                                                                with_objects => [ 'nivel3' ]
                                                            );

    return ($prestamos_grupo_count);
}


=head2
    sub getTipoPrestamo
    retorna los datos del tipo de prestamo
=cut
sub getTipoPrestamo {

    use C4::Modelo::CircRefTipoPrestamo;
    my ($tipo_prestamo)=@_;
    my @filtros;

    push (@filtros,(id_tipo_prestamo => {eq => $tipo_prestamo}) );
    my  $circ_ref_tipo_prestamo = C4::Modelo::CircRefTipoPrestamo::Manager->get_circ_ref_tipo_prestamo( query => \@filtros,);
    if (scalar(@$circ_ref_tipo_prestamo)){
        return($circ_ref_tipo_prestamo->[0]);
    }else{
        return(0);
    }
}
#==========================================================hasta aca revisado========================================================

sub chequeoDeFechas{
    my ($cantDiasRenovacion,$fechaRenovacion,$intervalo_vale_renovacion)=@_;
    # La $fechaRenovacion es la ultima fecha de renovacion o la fecha del prestamo si nunca se renovo
    my $plazo_actual=$cantDiasRenovacion; # Cuantos dias más se puede renovar el prestamo

    my ($desde_proximos,$vencimiento,$apertura,$cierre) = C4::Date::proximosHabiles($plazo_actual, 0, $fechaRenovacion);

    my $err= "Error con la fecha";
    my $dateformat = C4::Date::get_date_format();
    my $hoy=C4::Date::format_date_in_iso(DateCalc(ParseDate("today"),"+ 0 days",\$err),$dateformat);#se saco el 2 para que ande bien.
    my $desde=C4::Date::format_date_in_iso(DateCalc($vencimiento,"- ".$intervalo_vale_renovacion." business days",\$err),$dateformat);#Se cambio el 2 por business days
    my $flag = Date_Cmp($desde,$hoy);
    #comparo la fecha de hoy con el inicio del plazo de renovacion
    if (!($flag gt 0)){
        #quiere decir que la fecha de hoy es mayor o igual al inicio del plazo de renovacion
        #ahora tengo que ver que la fecha de hoy sea anterior al vencimiento
        my $flag2=Date_Cmp($vencimiento,$hoy);
        if (!($flag2 lt 0)){
            #la fecha esta ok
            return 1;

        }

    }
    return 0;
}


#
# NUEVAS FUNCIONES
#



=item
getPrestamoDeId3
Esta funcion retorna el prestamo a partir de un id3
=cut
sub getPrestamoDeId3 {
    my ($id3)=@_;

        use C4::Modelo::CircPrestamo;
        use C4::Modelo::CircPrestamo::Manager;

        my @filtros;
        push(@filtros, ( fecha_devolucion => { eq => undef } ));
        push(@filtros, ( id3 => { eq => $id3 } ));

        my $prestamos__array_ref = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo(
                                                                        query => \@filtros,
                                                                        require_objects => ['nivel3','socio','ui','tipo'],
                                                                                        );


        return ($prestamos__array_ref->[0] || 0);
}

=item
getPrestamosDeSocio
Esta funcion retorna los prestamos actuales de un socio
=cut
sub getPrestamosDeSocio {
    my ($nro_socio,$db)=@_;

        use C4::Modelo::CircPrestamo;
        use C4::Modelo::CircPrestamo::Manager;

        my @filtros;
        push(@filtros, ( fecha_devolucion => { eq => undef } ));
        push(@filtros, ( nro_socio => { eq => $nro_socio } ));

        my $prestamos__array_ref;
        if($db){ #Si viene $db es porque forma parte de una transaccion
            $prestamos__array_ref = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo(db => $db,query => \@filtros,
                                                                        require_objects => ['nivel3','socio','ui','tipo'],
                                                                        );
        }else{
            $prestamos__array_ref = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo(query => \@filtros,
                                                                        require_objects => ['nivel3','socio','ui','tipo'],
                                                                      );
        }

        return ($prestamos__array_ref);
}

=item
getPrestamosDeSocio
Esta funcion retorna los prestamos actuales de un socio
=cut
sub tienePrestamosDeId2 {
    my ($nro_socio,$id2)=@_;

        use C4::Modelo::CircPrestamo;
        use C4::Modelo::CircPrestamo::Manager;

        my @filtros;

        push(@filtros, ( nro_socio      => { eq => $nro_socio } ));
        push(@filtros, ( 'nivel3.id2'   => { eq => $id2} ));
        push(@filtros, ( fecha_devolucion => { eq => "NULL"} ));


        my $prestamos_count = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo_count(query => \@filtros,
                                                                        require_objects => ['nivel3.nivel2','socio','ui'],
                                                                      );

        return ($prestamos_count);
}



sub getTiposDePrestamos {
#retorna los datos de TODOS los tipos de prestamos
use C4::Modelo::CircRefTipoPrestamo::Manager;
   my @filtros;
   push(@filtros, ( id => { ne => 0 } )); # No debe mostrar NUNCA el tipo RESERVA
   my  $circ_ref_tipo_prestamo = C4::Modelo::CircRefTipoPrestamo::Manager->get_circ_ref_tipo_prestamo( query => \@filtros);
   return($circ_ref_tipo_prestamo);
}

sub prestarYGenerarTicket{
    my ($params)=@_;

# FIXME falta verificar

    my ($nivel3aPrestar)= C4::AR::Nivel3::getNivel3FromBarcode($params->{'barcode'});
    C4::AR::Debug::debug("Prestamos => prestarYGenerarTicket => barcode a prestar: ".$params->{'barcode'});

    my @infoTickets;
    my @infoMessages;
    my $id3                         = $nivel3aPrestar->getId3;
    my $nivel3aPrestar              = C4::AR::Nivel3::getNivel3FromId3($id3);
    $params->{'id1'}                = $nivel3aPrestar->getId1;
    $params->{'id2'}                = $nivel3aPrestar->getId2;
    C4::AR::Debug::debug("Prestamos => prestarYGenerarTicket => id1: ".$nivel3aPrestar->getId1);
    C4::AR::Debug::debug("Prestamos => prestarYGenerarTicket => id2: ".$nivel3aPrestar->getId2);
    C4::AR::Debug::debug("Prestamos => prestarYGenerarTicket => id3: ".$id3);
    $params->{'id3'}                = $id3;
    $params->{'id_ui'}              = C4::AR::Preferencias::getValorPreferencia('defaultUI');
    $params->{'id_ui_prestamo'}     = C4::AR::Preferencias::getValorPreferencia('defaultUI');
    $params->{'tipo'}               = "INTRA";

    my ($msg_object)    = C4::AR::Prestamos::t_realizarPrestamo($params);
    my $ticketObj       = 0;

    C4::AR::Debug::debug("Prestamos => prestarYGenerarTicket => adicional_selected=> ".$params->{'adicional_selected'});

    if(!$msg_object->{'error'}){
    #Se crean los ticket para imprimir.
        C4::AR::Debug::debug("Prestamos => prestarYGenerarTicket => SE PRESTO SIN ERROR --> SE CREA EL TICKET");
        $ticketObj      = C4::AR::Prestamos::crearTicket($id3,$params->{'nro_socio'},$params->{'responsable'},$params->{'adicional_selected'});
    }

    push (@infoMessages, $msg_object);

    my %infoOperacion = (
                ticket  => $ticketObj,
    );

    push (@infoTickets, \%infoOperacion);

    my %infoOperaciones;
    $infoOperaciones{'tickets'}     = \@infoTickets;
    $infoOperaciones{'messages'}    = \@infoMessages;


    return (\%infoOperaciones);
}

#funcion que realiza la transaccion del Prestamo
sub t_realizarPrestamo{
    my ($params) = @_;
    C4::AR::Debug::debug("Antes de verificar");

    my ($msg_object)= C4::AR::Reservas::_verificaciones($params);

    if(!$msg_object->{'error'}){
        C4::AR::Debug::debug("No hay error en las verificaciones");
        my  $prestamo = C4::Modelo::CircPrestamo->new();
        my $db = $prestamo->db;
           $db->{connect_options}->{AutoCommit} = 0;
           $db->begin_work;
        eval{
            $prestamo->prestar($params,$msg_object);
            $db->commit;
        };
        if ($@){
            C4::AR::Debug::debug("ERROR");
            #Se loguea error de Base de Datos
            C4::AR::Mensajes::printErrorDB($@, 'B401',"INTRA");
            $db->rollback;
            #Se setea error para el usuario
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P106', 'params' => []} ) ;
        }
        $db->{connect_options}->{AutoCommit} = 1;
    }

    return ($msg_object);
}

sub obtenerPrestamosDeSocio {

    use C4::Modelo::CircPrestamo;
    use C4::Modelo::CircPrestamo::Manager;

    my ($nro_socio)=@_;

    my $prestamos_array_ref = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo(
                                          query => [ fecha_devolucion  => { eq => undef }, nro_socio  => { eq => $nro_socio }],
                                          require_objects => ['nivel3','socio','ui', 'nivel3.nivel2.nivel1','tipo'],
                                );

    # my $prestamos_array_ref_count = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo_count(
    #                                       query => [ fecha_devolucion  => { eq => undef }, nro_socio  => { eq => $nro_socio }],
    #                                       require_objects => ['nivel3','socio','ui'],

    #                             );

    my $prestamos_array_ref_count = scalar(@$prestamos_array_ref);

    return ($prestamos_array_ref_count, $prestamos_array_ref);
}

=head2
    sub tienePrestamos
    Dado un socio, devuelve si tiene ejemplares prestados
=cut
sub tienePrestamos {

    use C4::Modelo::CircPrestamo;
    use C4::Modelo::CircPrestamo::Manager;

    my ($nro_socio)=@_;

    my $prestamos_array_ref_count = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo_count(
                                          query => [ fecha_devolucion  => { eq => undef }, nro_socio  => { eq => $nro_socio }],
                                          require_objects => ['nivel3','socio','ui'],

                                );

    return ($prestamos_array_ref_count);
}

=item
Esta funcion retorna si el ejemplar segun el id3 pasado por parametro esta prestado o no
=cut
sub estaPrestado {
    my ($id3) = @_;

    use C4::Modelo::CircPrestamo;
    use C4::Modelo::CircPrestamo::Manager;

    my $nivel3_array_ref= C4::Modelo::CircPrestamo::Manager->get_circ_prestamo(
                                                                query => [  fecha_devolucion  => { eq => undef },
                                                                            id3  => { eq => $id3 },
                                                                ],
                                                                require_objects => ['tipo'],
                                );

    return (scalar(@$nivel3_array_ref) > 0);
}


=item
cantidadDePrestamosPorUsuario
Devuelve la cantidad de prestamos que tiene el usuario que se pasa por parametro y la cantidad de vencidos.
=cut
sub cantidadDePrestamosPorUsuario {
    my ($nro_socio)=@_;

    my $prestamos= obtenerPrestamosDeSocio($nro_socio);

    my $prestados=0;
    my $vencidos=0;
    foreach my $prestamo (@$prestamos){
        $prestados++;
        if($prestamo->estaVencido){$vencidos++;}
    }

    return($vencidos,$prestados);
}

sub existePrestamo{

    my ($prestamo_id) = @_;

    my @filtros;
    push (@filtros,( id_prestamo => {eq => $prestamo_id}) );

    my $prestamo = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo(query => \@filtros,
                                                                        require_objects => ['nivel3','socio','ui'],
                                                                        );

    return (scalar(@$prestamo));
}

sub validarExistenciaPrestamos{

    my ($msg_object,$array_id_prestamos) = @_;

    my @prestamos_array_validos;
    foreach my $prestamo_id (@$array_id_prestamos){
        if (C4::AR::Prestamos::existePrestamo($prestamo_id)){
          push(@prestamos_array_validos,$prestamo_id);
        }else{
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P110', 'params' => [$prestamo_id]} ) ;
        }
    }
    return(\@prestamos_array_validos);
}


=item
Transaccion que maneja los erroes de base de datos y llama a la funcion devolver
=cut
sub t_devolver {
    my($params)=@_;

    my $msg_object= C4::AR::Mensajes::create();
    my $array_id_prestamos= $params->{'datosArray'};
    my $prestamos_array_validos = C4::AR::Prestamos::validarExistenciaPrestamos($msg_object,$array_id_prestamos);
    my $loop=scalar(@$prestamos_array_validos);
    my $id_prestamo;
    my $prestamo = C4::Modelo::CircPrestamo->new();
    my $db = $prestamo->db;
    $db->{connect_options}->{AutoCommit} = 0;
    $db->begin_work;

    for(my $i=0;$i<$loop;$i++){
        $id_prestamo= $prestamos_array_validos->[$i];
        $prestamo = C4::AR::Prestamos::getInfoPrestamo($id_prestamo, $db);
        $params->{'id_prestamo'}= $id_prestamo;
        C4::AR::Debug::debug("PRESTAMOS => t_devolver => id_prestamo: ".$id_prestamo);
        if ($prestamo){
            $params->{'id3'}= $prestamo->getId3;
            $params->{'barcode'}= $prestamo->nivel3->getBarcode;

            #se realizan las verificaciones necesarias para el prestamo que se intenta devolver
            verificarCirculacionRapida($params, $msg_object);

            if(!$msg_object->{'error'}){

                eval {
                    $prestamo->devolver($db,$params);
                    $db->commit;
                    # Si la devolucion se pudo realizar
                    $msg_object->{'error'}= 0;
                    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P109', 'params' => [$params->{'barcode'}]} ) ;
                };
                if ($@){
                    #Se loguea error de Base de Datos
                    &C4::AR::Mensajes::printErrorDB($@, 'B406',"INTRA");
                    $db->rollback;
                    #Se setea error para el usuario
                    $msg_object->{'error'}= 1;
                    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P110', 'params' => [$params->{'barcode'}]} ) ;
                }
            }# END if(!$msg_object->{'error'})
        }

    }# END for(my $i=0;$i<$loop;$i++)

    $db->{connect_options}->{AutoCommit} = 1;

    return ($msg_object);
}

sub renovarYGenerarTicket{
    my ($params)=@_;

    my ($infoTickets,$msg_object);

    #Acomodo la entrada y llamo al renovar
    my $array_id_prestamos= $params->{'datosArray'};
    my $prestamos_array_validos = C4::AR::Prestamos::validarExistenciaPrestamos($msg_object,$array_id_prestamos);


    my @arrayPrestamos=();

    foreach my $id_prestamo (@$prestamos_array_validos){
        my %datosPrestamos;
        my $prestamo            = C4::AR::Prestamos::getInfoPrestamo($id_prestamo);
        $datosPrestamos{'id3'}        = $prestamo->nivel3->getId3;
        $datosPrestamos{'barcode'}        = $prestamo->nivel3->getBarcode;
        $datosPrestamos{'id_prestamo'}    = $prestamo->getId_prestamo;
        push (@arrayPrestamos, \%datosPrestamos)
        }

    $params->{'datosArray'}=\@arrayPrestamos;
    ($infoTickets,$msg_object)   = C4::AR::Prestamos::t_renovar($params);

    my @infoMessages;
    push (@infoMessages, $msg_object);

    my %info;
    $info{'tickets'}                = $infoTickets;
    $info{'messages'}               = \@infoMessages;
    return (\%info);
}


sub t_renovar {
    my ($params)              = @_;
    my $msg_object            = C4::AR::Mensajes::create();

    my $type= "intranet";

    my $ticketObj;
    my @infoTickets;
    my $print_renew           = C4::AR::Preferencias::getValorPreferencia("print_renew");
    my $array_id_prestamos    = $params->{'datosArray'};
    my $prestamoTEMP          = C4::Modelo::CircPrestamo->new();
    my $db                    = $prestamoTEMP->db;
    $db->{connect_options}->{AutoCommit} = 0;
    $db->begin_work;

    foreach my $data (@$array_id_prestamos){

        $msg_object->{'tipo'}   = "INTRA";
        $msg_object->{'error'}  = 0;
        C4::AR::Debug::debug("T_Renovar ".$data->{'barcode'});
        my $prestamo            = C4::AR::Prestamos::getInfoPrestamo($data->{'id_prestamo'},$db);
        if ($prestamo){
            $prestamo->_verificarParaRenovar($msg_object, $params->{'type'});

            if(!$msg_object->{'error'}){
                    eval{
                        $prestamo->renovar($params->{'responsable'});
                        $db->commit;

                        # Si la renovacion se pudo realizar
                        C4::AR::Debug::debug("SE RENOVO SIN ERROR --> SE CREA EL TICKET");
                        my $ticketObj = C4::AR::Prestamos::crearTicket($data->{'id3'},$prestamo->getNro_socio,$params->{'responsable'});
                        if(!$ticketObj){
                            $ticketObj = 0;
                        }
                        my %infoOperacion = (
                                    ticket  => $ticketObj,
                        );
                        push (@infoTickets,  \%infoOperacion);

                        $msg_object->{'error'}= 0;
                        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P111', 'params' => [$data->{'barcode'}]} ) ;

                    };
                    if ($@){
                    #Se loguea error de Base de Datos
                        C4::AR::Mensajes::printErrorDB($@, 'B405',"INTRA");
                        $db->rollback;
                    #Se setea error para el usuario
                        $msg_object->{'error'}= 1;
                        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P112', 'params' => [$data->{'barcode'}]} ) ;
                    }
            }
        }else{
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P112', 'params' => [$data->{'barcode'}]} ) ;
        }
    }
    $db->{connect_options}->{AutoCommit} = 1;

    return (\@infoTickets, $msg_object);
}

sub t_renovarOPAC {
  my ($params)=@_;

  my $type= "opac";


  my $prestamoTEMP = C4::Modelo::CircPrestamo->new();
  my $db = $prestamoTEMP->db;
     $db->{connect_options}->{AutoCommit} = 0;
     $db->begin_work;

        my ($msg_object)= C4::AR::Mensajes::create();
        $msg_object->{'error'}= 0;
        $msg_object->{'tipo'}= "OPAC";

        C4::AR::Debug::debug("T_Renovar OPAC ".$params->{'id_prestamo'});
        my $prestamo = C4::AR::Prestamos::getInfoPrestamo($params->{'id_prestamo'},$db);
        if ($prestamo){
            $prestamo->_verificarParaRenovar($msg_object, $type);

            if(!$msg_object->{'error'}){
                    eval{
                        $prestamo->renovar($params->{'nro_socio'});
                        $db->commit;
                    # Si la renovacion se pudo realizar
                        $msg_object->{'error'}= 0;
                        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P111', 'params' => [$prestamo->nivel3->getBarcode]} ) ;
                    };
                    if ($@){
                    #Se loguea error de Base de Datos
                        &C4::AR::Mensajes::printErrorDB($@, 'B405',"OPAC");
                        $db->rollback;
                    #Se setea error para el usuario
                        $msg_object->{'error'}= 1;
                        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P112', 'params' => [$prestamo->nivel3->getBarcode]} ) ;
                    }
              }
        }else{
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P112', 'params' => [$prestamo->nivel3->getBarcode]} ) ;
        }

  $db->{connect_options}->{AutoCommit} = 1;

    return ($msg_object);
}

sub getPrestamoPorBarcode {
    my ($barcode) = @_;

    use C4::Modelo::CircPrestamo;
    use C4::Modelo::CircPrestamo::Manager;

    my @filtros;
    push(@filtros, ( barcode            => { eq => $barcode } ));
    push(@filtros, ( fecha_devolucion   => { eq => undef } ) );

    my $prestamo_array_ref= C4::Modelo::CircPrestamo::Manager->get_circ_prestamo(
                                                                query => \@filtros,
                                                                require_objects => [ 'nivel3','tipo' ] #INNER JOIN
                                );

    if(scalar(@$prestamo_array_ref) > 0){
        return $prestamo_array_ref->[0]->getId_prestamo;
    }else {
        return 0;
    }
}


=item
Esta funcion verifica que el id_prestamo que se pasa por parametro exista y que ademas sea un prestamo, o sea q no se haya devuelto aún
=cut
sub esUnPrestamo {

    my ($id_prestamo)=@_;

    use C4::Modelo::CircPrestamo;
    use C4::Modelo::CircPrestamo::Manager;

    my @filtros;
    push(@filtros, ( id_prestamo => { eq => $id_prestamo } ));
    push(@filtros, ( fecha_devolucion => { eq => undef } ) );

    my $prestamo_array_ref= C4::Modelo::CircPrestamo::Manager->get_circ_prestamo(
                                                                query => \@filtros,
#                                                               require_objects => [ 'nivel3' ] #INNER JOIN
                                );

    if(scalar(@$prestamo_array_ref) > 0){
#       return $prestamo_array_ref->[0]->getId_prestamo;
        return 1;
    }else {
        return 0;
    }
}

sub getSocioFromID_Prestamo {
    my ($prestamo)=@_;

    use C4::Modelo::CircPrestamo;
    use C4::Modelo::CircPrestamo::Manager;

    my @filtros;
    push(@filtros, ( id_prestamo => { eq => $prestamo } ));
    push(@filtros, ( fecha_devolucion => { eq => undef } ) );

    my $prestamo_array_ref= C4::Modelo::CircPrestamo::Manager->get_circ_prestamo(
                                                                query => \@filtros,
                                                                require_objects => [ 'socio','tipo' ] #INNER JOIN
                                );

    if(scalar(@$prestamo_array_ref) > 0){
        return $prestamo_array_ref->[0]->socio;
    }else {
        return 0;
    }
}

sub verificarCirculacionRapida {
    my ($params, $msg_object)=@_;


# FIXME ahora no se mandan los barcodes, se mandan los id_prestamo, faltaria verificar esto!!!!!!!!!!
# verificar q el id_prestmo exista y que no se haya devuelto

=item
    if( !($msg_object->{'error'}) &&  $params->{'operacion'} eq 'devolver'){
    #se verifica si la operacion es una devolucion, que EXISTA el BARCODE
        $params->{'id_prestamo'}= getPrestamoPorBarcode($params->{'barcode'});
        if($params->{'id_prestamo'} == 0){
        #no existe el barcode
            $msg_object->{'error'}= 1;
            C4::AR::Debug::debug("verificarCirculacionRapida => no existe el barcode");
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P115', 'params' => [$params->{'barcode'}]} ) ;
        }
    }
=cut
    if( !($msg_object->{'error'}) && $params->{'operacion'} ne 'devolver' && !esUnPrestamo($params->{'id_prestamo'})){
    #si la operacion es una devolucion, se verifica que exista el id_prestamo y que ademas ya no se haya devuelto
        $msg_object->{'error'}= 1;
        C4::AR::Debug::debug("verificarCirculacionRapida => no existe el prestamo o ya se devolvió anteriormente");
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P117', 'params' => []} ) ;
    }

    if( !($msg_object->{'error'}) && $params->{'operacion'} ne 'devolver' && !C4::AR::Usuarios::existeSocio($params->{'nro_socio'})){
    #se verifica si la operacion es un prestamo, que EXISTA el USUARIO
    #si es una devolucion  no importa el usuario ya que lo tengo en el prestamo
        $msg_object->{'error'}= 1;
        C4::AR::Debug::debug("verificarCirculacionRapida => no existe el usuario");
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P116', 'params' => []} ) ;
    }

    #Se verifica que la operación este dentro del horario de funcionamiento de la biblioteca.
    #SOLO PARA INTRA
    if(!$msg_object->{'error'} && !C4::AR::Preferencias::getValorPreferencia("operacion_fuera_horario") && C4::AR::Reservas::_verificarHorario()){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P127', 'params' => []} ) ;
        C4::AR::Debug::debug("Prestamos.pm => verificarCirculacionRapida => Entro al if de operacion fuera de horario ");
    }
}


sub crearTicket {
    my ($id3,$nro_socio,$responsable,$adicional_selected)=@_;

    my %ticket;

    $ticket{'adicional_selected'}       = $adicional_selected;
    $ticket{'socio'}                    = $nro_socio;
    $ticket{'responsable'}              = $responsable;
    $ticket{'id3'}                      = $id3;

    return(\%ticket);
}

=item
Esta funcion obtiene el socio del ejemplar prestado
=cut
# FIXME ver si la condicion de filtro es valida (id3, nro_socio, fecha_prestamo)
sub getSocioFromPrestamo {
    my ($id3)= @_;

    my @filtros;
    push(@filtros, ( id3 => { eq => $id3 } ));
    push(@filtros, ( fecha_devolucion => { eq => undef } ) );

    my $prestamos_array_ref = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo(
                                                                                    query => \@filtros,
                                                                                    require_objects => ['socio', 'socio.persona','tipo'],
                                                                                    select          => ['socio.*','usr_persona.*']
                                                                                );

    if(scalar(@$prestamos_array_ref) > 0){
        return ($prestamos_array_ref->[0]->socio);
    }else{
        return 0;
    }
}

=item
Esta funcion obtiene el prestamo del ejemplar prestado
=cut
sub getPrestamoActivo {
    my ($id3)= @_;

    my @filtros;
    push(@filtros, ( id3 => { eq => $id3 } ));
    push(@filtros, ( fecha_devolucion => { eq => undef } ) );

    my $prestamos_array_ref = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo(
                                                                                    query => \@filtros,
                                                                                    require_objects => ['nivel3','socio','ui'],
                                                                                );

    if(scalar(@$prestamos_array_ref) > 0){
        return ($prestamos_array_ref->[0]);
    }else{
        return 0;
    }
}


sub getHistorialPrestamos {
    my ($nro_socio,$ini,$cantR,$orden)=@_;

    my @filtros;

    my $historialPrestamos = C4::Modelo::RepHistorialPrestamo::Manager->get_rep_historial_prestamo(
                                                    query => [ nro_socio => { eq => $nro_socio } ],
                                                    limit   => $cantR,
                                                    offset  => $ini,
                                                    require_objects => ['nivel3','nivel3.nivel1'],
                                                    sort_by => ['id_historial_prestamo DESC']

);

    my $cantidad = C4::Modelo::RepHistorialPrestamo::Manager->get_rep_historial_prestamo_count(
                                                    query => [ nro_socio => { eq => $nro_socio } ],
                                                    require_objects => ['nivel3','nivel3.nivel1'],

);


    return($cantidad,$historialPrestamos);

}


sub getHistorialPrestamosParaTemplate {

     my ($nro_socio,$ini,$cantR,$orden)=@_;


     my ($cant,$prestamos_array_ref) = getHistorialPrestamos($nro_socio,$ini,$cantR,$orden);


    return ($cant,$prestamos_array_ref);
}


sub getHistorialPrestamosVigentesParaTemplate {

    my ($nro_socio,$ini,$cantR,$orden)=@_;

    my ($cant,$prestamos_array_ref) = obtenerPrestamosDeSocio($nro_socio,$ini,$cantR,$orden);

    return ($cant,$prestamos_array_ref);
}

sub t_agregarTipoPrestamo {
    my ($params)=@_;

    my $msg_object = C4::AR::Mensajes::create();
    my $tipo_prestamo = C4::Modelo::CircRefTipoPrestamo->new();
    my $db = $tipo_prestamo->db;

C4::AR::Debug::debug("AGREGAR TIPO DE PRESTAMO ".$params->{'id_tipo_prestamo'});

    $db->{connect_options}->{AutoCommit} = 0;
    $db->begin_work;
    eval {
        $tipo_prestamo->modificar($params);
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP011', 'params' => []} ) ;
        $db->commit;
    };

    if ($@){
        #Se loguea error de Base de Datos
        &C4::AR::Mensajes::printErrorDB($@, 'SP009','INTRA');
        eval{$db->rollback};
        #Se setea error para el usuario
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP009', 'params' => []} ) ;
    }

    $db->{connect_options}->{AutoCommit} = 1;
    return ($msg_object);
}

sub t_modificarTipoPrestamo {
    my ($params)=@_;

    my $msg_object = C4::AR::Mensajes::create();
C4::AR::Debug::debug("MODIFICAR TIPO DE PRESTAMO ".$params->{'id_tipo_prestamo'});
    my $db = undef;
    my $tipo_prestamo=C4::AR::Prestamos::getTipoPrestamo($params->{'id_tipo_prestamo'});
    if ($tipo_prestamo){
        $db = $tipo_prestamo->db;

        $db->{connect_options}->{AutoCommit} = 0;
        $db->begin_work;
        eval {
            $tipo_prestamo->modificar($params);
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP010', 'params' => []} ) ;
            $db->commit;
        };
    }

    if ($@){
        #Se loguea error de Base de Datos
        &C4::AR::Mensajes::printErrorDB($@, 'SP008','INTRA');
        $db->rollback;
        #Se setea error para el usuario
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP008', 'params' => []} ) ;
    }

    $db->{connect_options}->{AutoCommit} = 1;
    return ($msg_object);
}

sub t_eliminarTipoPrestamo {
    my ($id_tipo_prestamo)=@_;

    my $msg_object = C4::AR::Mensajes::create();
    my $cantidad_prestamos=C4::AR::Prestamos::cantidadDeUsoTipoPrestamo($id_tipo_prestamo);
    my $db = undef;

    if($cantidad_prestamos == 0) {
        C4::AR::Debug::debug("ELIMINAR TIPO DE PRESTAMO ".$id_tipo_prestamo);
        my $tipo_prestamo=C4::AR::Prestamos::getTipoPrestamo($id_tipo_prestamo);
        if ($tipo_prestamo){
            $db = $tipo_prestamo->db;

            $db->{connect_options}->{AutoCommit} = 0;
            $db->begin_work;
            eval {
                $tipo_prestamo->delete();
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP006', 'params' => []} ) ;
                $db->commit;
            };
        }

        if ($@){
            #Se loguea error de Base de Datos
            &C4::AR::Mensajes::printErrorDB($@, 'SP007','INTRA');
            $db->rollback;
            #Se setea error para el usuario
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP007', 'params' => []} ) ;
        }

        $db->{connect_options}->{AutoCommit} = 1;

    }else{
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP012', 'params' => [$cantidad_prestamos]} ) ;
    }

    return ($msg_object);
}



sub cantidadDeUsoTipoPrestamo {
    my ($id_tipo_prestamo) = @_;

    my @filtros;
    push(@filtros, (tipo_prestamo => { eq => $id_tipo_prestamo}));
    my $cantidad_prestamos= C4::Modelo::CircPrestamo::Manager->get_circ_prestamo_count( query => \@filtros);

    return $cantidad_prestamos;
}

=item sub getCountPrestamosDeGrupo
    Devuelve la cantidad de prestamos de grupo
=cut
sub getCountPrestamosDeGrupo {
    my ($id2) = @_;

    use C4::Modelo::CircPrestamo;
    use C4::Modelo::CircPrestamo::Manager;

    my @filtros;
    push(@filtros, ( id2    => { eq => $id2 } ));
    push(@filtros, ( fecha_devolucion => { eq => undef } ));

    my $prestamos_grupo_count = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo_count(
                                                                                    query => \@filtros,
                                                                                    require_objects => [ 'nivel3' ]
                                                        );

    return ($prestamos_grupo_count);
}


=item
    Se envian los mails con los recordatorios de vencimiento
=cut
sub enviarRecordacionDePrestamo {

     my ($today) = @_;

    # remindUser es la preferencia global que habilita el recordatorio al socio
    if (C4::AR::Preferencias::getValorPreferencia('remindUser')){

        my @array_prestamos     = getAllPrestamosActivos($today);

        _enviarRecordatorio(@array_prestamos);
    }
}

=item
    Funcion que limpia la data de la tabla circ_prestamo_vencido_temp
=cut
sub _limpiarTablaCircPrestamoVencidoTemp {

    use C4::Modelo::CircPrestamoVencidoTemp::Manager;
    use C4::Modelo::CircPrestamoVencidoTemp;

    my $prestamos_vencidos_temp_array_ref = C4::Modelo::CircPrestamoVencidoTemp::Manager->get_circ_prestamo_vencido_temp();

    if(scalar(@$prestamos_vencidos_temp_array_ref) > 0){

        eval{

            foreach my $id_prestamo (@$prestamos_vencidos_temp_array_ref){

                my $prestamo_vencido_temp = C4::Modelo::CircPrestamoVencidoTemp->new(id => $id_prestamo->{'id'});

                $prestamo_vencido_temp->load();

                $prestamo_vencido_temp->delete();

            }
        };
    }
}

=item
    Se envian los mails a los socios con prestamos vencidos
    Se ejecuta esta funcion solo si el flag enableMailPrestVencidos esta activo.
    El mismo se activa desde otra interfaz y el CRON lo checkea antes de llamar aca.
=cut
sub enviarRecordacionDePrestamoVencidos {

    # remindUser es la preferencia global que habilita el recordatorio al socio
    if (C4::AR::Preferencias::getValorPreferencia('remindUser')){

        my @array_prestamos = getAllPrestamosVencidosParaMail();

        _enviarRecordatorioVencidos(@array_prestamos);

        # unseteamos el flag para el CRON
        C4::AR::Preferencias::setVariable('enableMailPrestVencidos', 0);

        # limpiamos la tabla prestamo_vencido_temp si es que tiene algo
        _limpiarTablaCircPrestamoVencidoTemp();
    }

}

=item
    Funcion interna que envia los recordatorios
    El array_prestamos viene ordenado pro usuario. Por lo que si hay mas de un prestamos por usuario,
    manda solo un mail.
=cut
sub _enviarRecordatorioVencidos{

    my (@array_prestamos) = @_;

    use C4::AR::Usuarios;

    my $fin;
    my $pres;

    if (scalar(@array_prestamos) == 0) {
        $fin    = 1;
    } else {
        $fin    = 0;
        $pres   = shift @array_prestamos;
    }

    while (!$fin) {

        my $nroSocio            = $pres->getNro_socio();
        my $socio               = C4::AR::Usuarios::getSocioInfoPorNroSocio($nroSocio);

        my %mail;
        my $nivel3              = C4::AR::Nivel3::getNivel3FromId3($pres->{'id3'});
        my $nivel1              = C4::AR::Nivel3::getNivel1FromId1($nivel3->{'id1'});
        my $autor               = Encode::decode_utf8($nivel1->getAutor());
        my $titulo              = Encode::decode_utf8($nivel1->getTitulo());
        my $nombre              = Encode::decode_utf8($socio->{'persona'}->{'nombre'});
        my $apellido            = Encode::decode_utf8($socio->{'persona'}->{'apellido'});
        my $fecha_prestamo      = $pres->getFecha_vencimiento_formateada();
        my $cuerpo_mensaje      = Encode::decode_utf8(C4::AR::Preferencias::getValorPreferencia('vencidoMessage'));

        $cuerpo_mensaje         =~ s/FIRSTNAME\ SURNAME/$nombre\ $apellido/;
        $cuerpo_mensaje         =~ s/VENCIMIENTO/$fecha_prestamo/;
        $cuerpo_mensaje         =~ s/AUTHOR/$autor/;
        $cuerpo_mensaje         =~ s/TITLE\:UNITITLE/$titulo/;
        $cuerpo_mensaje         =~ s/\(EDICION\)//;

        $mail{'mail_from'}      = Encode::decode_utf8(C4::AR::Preferencias::getValorPreferencia('mailFrom'));
        $mail{'mail_to'}        = $socio->{'persona'}->email;
        $mail{'mail_subject'}   = C4::AR::Preferencias::getValorPreferencia('vencidoSubject');
        $mail{'mail_message'}   = $cuerpo_mensaje;

        if (scalar(@array_prestamos) == 0) {
            $fin    = 1;
        } else {
            $pres   = shift @array_prestamos;
        }

        while ( ($nroSocio eq $pres->getNro_socio()) && (!$fin) ) {

                my $nivel3              = C4::AR::Nivel3::getNivel3FromId3($pres->{'id3'});
                my $nivel1              = C4::AR::Nivel3::getNivel1FromId1($nivel3->{'id1'});
                my $autor               = Encode::decode_utf8($nivel1->getAutor());
                my $titulo              = Encode::decode_utf8($nivel1->getTitulo());
                my $nombre              = Encode::decode_utf8($socio->{'persona'}->{'nombre'});
                my $apellido            = Encode::decode_utf8($socio->{'persona'}->{'apellido'});
                my $fecha_prestamo      = $pres->getFecha_vencimiento_formateada();
                my $cuerpo_mensaje      = Encode::decode_utf8(C4::AR::Preferencias::getValorPreferencia('vencidoMessage'));

                $cuerpo_mensaje         =~ s/Sr\.\/Sra\.\ FIRSTNAME\ SURNAME\ :\ //;

                $cuerpo_mensaje         =~ s/FIRSTNAME\ SURNAME/$nombre\ $apellido/;
                $cuerpo_mensaje         =~ s/VENCIMIENTO/$fecha_prestamo/;
                $cuerpo_mensaje         =~ s/AUTHOR/$autor/;
                $cuerpo_mensaje         =~ s/TITLE\:UNITITLE/$titulo/;
                $cuerpo_mensaje         =~ s/\(EDICION\)//;

                $mail{'mail_message'}   .= "<br /><br />" . $cuerpo_mensaje;

                if (scalar(@array_prestamos) == 0) {
                    $fin    = 1;
                } else {
                    $pres   = shift @array_prestamos;
                }
        }

        # FIXME: feo, hacer una funcion que arme el mail y aca solo mandarlo. Inmanejable cuando haya mas medios
        if (C4::AR::Preferencias::getValorPreferencia('EnabledMailSystem')){
            C4::AR::Debug::debug("antessssssssssssssssssss -----------------------------");
            C4::AR::Mail::send_mail(\%mail);
        }

    }

}

=item
    Funcion interna que envia los recordatorios
=cut
sub _enviarRecordatorio{

    my (@array_prestamos) = @_;

    use C4::AR::Usuarios;

    my $fin;
    my $pres;

    if (scalar(@array_prestamos) == 0) {
        $fin    = 1;
    } else {
        $fin    = 0;
        $pres   = shift @array_prestamos;
    }

    while (!$fin) {

        my $nroSocio            = $pres->getNro_socio();
        my $socio               = C4::AR::Usuarios::getSocioInfoPorNroSocio($nroSocio);

        if($socio->getRemindFlag()){

            my %mail;
            my $nivel3              = C4::AR::Nivel3::getNivel3FromId3($pres->{'id3'});
            my $nivel1              = C4::AR::Nivel3::getNivel1FromId1($nivel3->{'id1'});
            my $autor               = Encode::decode_utf8($nivel1->getAutor());
            my $titulo              = Encode::decode_utf8($nivel1->getTitulo());
            my $nombre              = Encode::decode_utf8($socio->{'persona'}->{'nombre'});
            my $apellido            = Encode::decode_utf8($socio->{'persona'}->{'apellido'});
            my $fecha_prestamo      = $pres->getFecha_vencimiento_formateada();
            my $cuerpo_mensaje      = Encode::decode_utf8(C4::AR::Preferencias::getValorPreferencia('reminderMessage'));
            my $opac_port           = ":".(C4::Context->config('opac_port')||'80');
            my $link                = "http://" . C4::AR::Utilidades::serverName() . $opac_port
                                      . C4::AR::Utilidades::getUrlPrefix() . "/modificarDatos.pl";

            $cuerpo_mensaje         =~ s/FIRSTNAME\ SURNAME/$nombre\ $apellido/;
            $cuerpo_mensaje         =~ s/VENCIMIENTO/$fecha_prestamo/;
            $cuerpo_mensaje         =~ s/AUTHOR/$autor/;
            $cuerpo_mensaje         =~ s/TITLE\:UNITITLE/$titulo/;
            $cuerpo_mensaje         =~ s/\(EDICION\)//;
            $cuerpo_mensaje         =~ s/BRANCH/Biblioteca/;
            $cuerpo_mensaje         =~ s/LINK/$link/;

            $mail{'mail_from'}      = Encode::decode_utf8(C4::AR::Preferencias::getValorPreferencia('mailFrom'));
            $mail{'mail_to'}        = $socio->{'persona'}->email;
            $mail{'mail_subject'}   = C4::AR::Preferencias::getValorPreferencia('reminderSubject');
            $mail{'mail_message'}   = $cuerpo_mensaje;


            if (scalar(@array_prestamos) == 0) {
                $fin    = 1;
            } else {
                $pres   = shift @array_prestamos;
            }

            while ( ($nroSocio eq $pres->getNro_socio()) && (!$fin) ) {

                my $nivel3              = C4::AR::Nivel3::getNivel3FromId3($pres->{'id3'});
                my $nivel1              = C4::AR::Nivel3::getNivel1FromId1($nivel3->{'id1'});
                my $autor               = Encode::decode_utf8($nivel1->getAutor());
                my $titulo              = Encode::decode_utf8($nivel1->getTitulo());
                my $nombre              = Encode::decode_utf8($socio->{'persona'}->{'nombre'});
                my $apellido            = Encode::decode_utf8($socio->{'persona'}->{'apellido'});
                my $fecha_prestamo      = $pres->getFecha_vencimiento_formateada();
                my $cuerpo_mensaje      = Encode::decode_utf8(C4::AR::Preferencias::getValorPreferencia('reminderMessage'));
                my $opac_port           = ":".(C4::Context->config('opac_port')||'80');
                my $link                = "http://" . C4::AR::Utilidades::serverName() . $opac_port
                                           . C4::AR::Utilidades::getUrlPrefix() . "/modificarDatos.pl";

                $cuerpo_mensaje         =~ s/Sr\.\/Sra\.\ FIRSTNAME\ SURNAME\ :\ //;

                $cuerpo_mensaje         =~ s/FIRSTNAME\ SURNAME/$nombre\ $apellido/;
                $cuerpo_mensaje         =~ s/VENCIMIENTO/$fecha_prestamo/;
                $cuerpo_mensaje         =~ s/AUTHOR/$autor/;
                $cuerpo_mensaje         =~ s/TITLE\:UNITITLE/$titulo/;
                $cuerpo_mensaje         =~ s/\(EDICION\)//;
                $cuerpo_mensaje         =~ s/BRANCH/Biblioteca/;
                $cuerpo_mensaje         =~ s/LINK/$link/;

                $mail{'mail_message'}   .= "<br /><br />" . $cuerpo_mensaje;

                if (scalar(@array_prestamos) == 0) {
                    $fin    = 1;
                } else {
                    $pres   = shift @array_prestamos;
                }

            }

            if (C4::AR::Preferencias::getValorPreferencia('EnabledMailSystem')){
                C4::AR::Mail::send_mail(\%mail);
            }

        } else {

            if (scalar(@array_prestamos) == 0) {
                $fin    = 1;
            } else {
                $pres   = shift @array_prestamos;
            }

        }
    }
}

=item
    Funcion que devuelve todos los prestamos vencidos para mandar los mails
    Hace un checkeo para ver que prestamos traer
=cut
sub getAllPrestamosVencidosParaMail{

    my $prestamos_array_ref               = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo(
                                                                                                    query => [fecha_devolucion => { eq => undef}],
                                                                                                    sort_by => ['nro_socio DESC'],
                                                                                                    require_objects => ['socio','socio.persona','tipo']
                                                                                                 );
    use C4::Modelo::CircPrestamoVencidoTemp::Manager;
    my $prestamos_vencidos_temp_array_ref = C4::Modelo::CircPrestamoVencidoTemp::Manager->get_circ_prestamo_vencido_temp();

    my @arrayPrestamos;

    # seleccionaron solo algunos prestamos
    # vamos a enviar solo estos
    if(scalar(@$prestamos_vencidos_temp_array_ref) > 0){

        use  C4::Modelo::CircPrestamoVencidoTemp;

        eval{

            foreach my $id_prestamo (@$prestamos_vencidos_temp_array_ref){

                # hace el new del objeto prestamo con el id del for
                my $prestamo_vencido_temp = C4::Modelo::CircPrestamo->new(id_prestamo => $id_prestamo->{'id_prestamo'});

                $prestamo_vencido_temp->load();
                push(@arrayPrestamos,($prestamo_vencido_temp));

            }
        };
        return (@arrayPrestamos);

    }
    elsif(scalar(@$prestamos_array_ref) > 0){
    # recorremos todos los prestamos, y guardamos los vencidos
        foreach my $prestamo (@$prestamos_array_ref){

            if ($prestamo->estaVencido()){
                push(@arrayPrestamos,($prestamo));
            }
        }

        return (@arrayPrestamos);
    }else{
        return 0;
    }
}

=item
    Funcion que devuelve todos los prestamos vencidos.
=cut
sub getAllPrestamosVencidos{
    my ($params) = @_;

    my @filtros;
    my $fecha_inicio            = $params->{'fecha_vto_from'};
    my $fecha_fin               = $params->{'fecha_vto_to'};
    my $dateformat              = C4::Date::get_date_format();
    $fecha_inicio               = C4::Date::format_date_in_iso($fecha_inicio, $dateformat);
    $fecha_fin                  = C4::Date::format_date_in_iso($fecha_fin, $dateformat);

    $params->{'orden'}          = ($params->{'orden'} eq "")?'fecha_prestamo':$params->{'orden'};
    $params->{'sentido_orden'}  = ($params->{'sentido_orden'})?'DESC':'ASC';

    if($params->{'orden'} eq "apellido"){
        $params->{'orden'} = "persona.apellido";
    }

    if($params->{'orden'} eq "fecha_prestamo"){
        $params->{'orden'} = "circ_prestamo.fecha_prestamo";
    }

    if($params->{'orden'} eq "fecha_vto"){
        $params->{'orden'} = "circ_prestamo.fecha_prestamo";
    }

    if(($fecha_inicio ne "") && ($fecha_fin ne "")){
        $fecha_inicio   = C4::Date::format_date_hour($fecha_inicio,"iso");
        $fecha_fin      = C4::Date::format_date_hour($fecha_fin,"iso");
    } else {
        $fecha_inicio   = C4::Date::format_date_hour("1900-01-01","iso");
        $fecha_fin      = C4::Date::format_date_hour(Date::Manip::ParseDate("now"),"iso");
    }

    push( @filtros, and => [    'fecha_prestamo' => { gt => $fecha_inicio, eq => $fecha_inicio },
                                'fecha_prestamo' => { lt => $fecha_fin, eq => $fecha_fin} ] );
    push(@filtros, ( fecha_devolucion   => { eq => undef } ));

    my $prestamos_array_ref = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo(
                                                                query   => \@filtros,
                                                                require_objects => ['socio','nivel3','socio.persona','tipo'],
                                                                # sort_by => 'fecha_prestamo DESC',
                                                                sort_by => $params->{'orden'} . ' ' . $params->{'sentido_orden'},

                                                        );

    my @arrayPrestamos;
    my $fecha_vencimiento;

C4::AR::Debug::debug("Prestamos => getAllPrestamosVencidos => PRESTAMOS:::::".scalar(@$prestamos_array_ref));

    if(scalar(@$prestamos_array_ref) > 0){
        foreach my $prestamo (@$prestamos_array_ref){
            # $prestamo->fecha_vencimiento_reporte($prestamo->getFecha_vencimiento);
            # $prestamo->save();
           # if ($prestamo->estaVencido()){
                # $fecha_vencimiento = $prestamo->getFecha_vencimiento();
                $fecha_vencimiento = $prestamo->getFecha_vencimiento_reporte();
                C4::AR::Debug::debug("Prestamos => getAllPrestamosVencidos => fecha_inicio " . $fecha_inicio . " fecha vto " . $fecha_vencimiento);

                if ( ( Date::Manip::Date_Cmp( $fecha_inicio, $fecha_vencimiento ) < 0 ) && ( Date::Manip::Date_Cmp( $fecha_vencimiento, $fecha_fin ) < 0 ) ) {
                    # C4::AR::Debug::debug("Prestamos => getAllPrestamosVencidos => fecha de vencimiento => " . $prestamo->getFecha_vencimiento());
                    push(@arrayPrestamos,($prestamo));
                }
           # }
        }
        return (\@arrayPrestamos);
    }else{
        return 0;
    }
}


=item
    Funcion que devuelve todos los prestamos que esten activos.
    Hace una consulta vacia sobre la tabla porque ahi estan solo los prestamos activos
=cut
sub getAllPrestamosActivos{

    my ($today) = @_;

    my $prestamos_array_ref = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo(
                                                                                    query => [fecha_devolucion => { eq => undef}],
                                                                                    sort_by => ['nro_socio DESC']
                                                                                   );
    use Date::Calc qw(Delta_Days);

    my @first;
    my @second;
    my $days;
    my @arrayPrestamos;

    if(scalar(@$prestamos_array_ref) > 0){
    # recorremos todos los prestamos, le pedimos la fecha de vencimiento y la checkeamos con la actual
        foreach my $prestamo (@$prestamos_array_ref){

            my $fecha_prestamo = $prestamo->getFecha_vencimiento();

            #obtenemos la diferencia de dias entre las dos fechas
            @first  = split(/-/, $today);
            @second = split(/-/, $fecha_prestamo);
            $days   = Delta_Days(@first, @second);

            # si esta dentro de los dias de reminderDays y NO esta vencido el prestamo
            if ($days <= C4::AR::Preferencias::getValorPreferencia('reminderDays') && !($prestamo->estaVencido())){
                push(@arrayPrestamos,($prestamo));
            }
        }
        return (@arrayPrestamos);
    }else{
        return 0;
    }
}

=item
    Funcion que setea los prestamos vencidos a enviar mail
    Lo hace sobre la tabla 'circ_prestamo_vencido_temp'
=cut
sub setPrestamosVencidosTemp{

    my ($ids_prestamos) = @_;

    my $msg_object      = C4::AR::Mensajes::create();

    use C4::Modelo::CircPrestamoVencidoTemp;

    if(!$msg_object->{'error'}){

        eval {

            foreach my $id_prestamo (@$ids_prestamos){

                my $prestamo_vencido_temp = C4::Modelo::CircPrestamoVencidoTemp->new();
                $prestamo_vencido_temp->agregarPrestamo($id_prestamo);

            }
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'PV00'});

        };

        if ($@){

            #Se setea error para el usuario
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'PV01'} ) ;

        }
    }

    return ($msg_object);

}


=item
agregarReservaAHistorial
Agrega una reserva/asignacion/cancelacion de reserva a la tabla de historial de circulacion.
@params: $reserva-->Object CircReserva de la reserva hecha.
=cut

sub agregarPrestamoAHistorialCirculacion{
    my ($prestamo,$tipo_operacion,$responsable,$hasta,$nota) = @_;

    use C4::Modelo::RepHistorialCirculacion;

    my %params = {};
    $params{'nro_socio'}    = $prestamo->getNro_socio;
    $params{'id1'}          = $prestamo->nivel3->nivel2->nivel1->getId1;
    $params{'id2'}          = $prestamo->nivel3->nivel2->getId2;
    $params{'id3'}          = $prestamo->getId3;
    $params{'nro_socio'}    = $prestamo->getNro_socio;
    $params{'responsable'}  = $responsable || $prestamo->getNro_socio;
    $params{'fecha'}        = $prestamo->getFecha_prestamo;
    $params{'fecha_devolucion'}= $prestamo->getFecha_devolucion;
    $params{'id_ui'}        = $prestamo->getId_ui_prestamo;
    $params{'tipo'}         = $tipo_operacion;
    $params{'tipo_prestamo'}= $prestamo->getTipo_prestamo;
    $params{'hasta'}        = $hasta;
    $params{'nota'}         = $nota;

    my $historial_circulacion = C4::Modelo::RepHistorialCirculacion->new(db => $prestamo->db);
    $historial_circulacion->agregar(\%params);
}

END { }       # module clean-up code here (global destructor)

1;
__END__
