package C4::AR::Reservas;

use strict;
require Exporter;

use C4::AR::Mail;
use C4::AR::Mensajes;
use C4::AR::Prestamos;
use Date::Manip;
use C4::Date;#formatdate
use C4::Modelo::CircReserva;
use C4::Modelo::CircReserva::Manager;
use C4::Modelo::CatRegistroMarcN3::Manager;


use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS);

$VERSION = 3.0;

@ISA = qw(Exporter);

@EXPORT = qw(
    getReservaActiva
    t_reservarOPAC
    t_cancelar_reserva
    t_cancelar_y_reservar
    cancelar_reservas
    cant_reservas
    getReservasDeGrupo
    cantReservasPorGrupo
    DatosReservas
    getDatosReservaDeId3
    CheckWaiting
    Enviar_Email_Asignacion_Reserva
    Enviar_Email_Cancelacion_Reserva
    Enviar_Email_Reserva_A_Espera
    FindNotRegularUsersWithReserves
    eliminarReservasVencidas
    reasignarTodasLasReservasEnEspera
    getReserva
    eliminarReservas
    getReservasDeSocioEnEspera
    getHistorialReservasParaTemplate
    cancelarReservaDesdeGrupoYSocio
    cantReservasPorGrupoAsignadas
    getReservasDeSocioAsignadas
    getReservasDeSocioEnEspera
);


=item
Esta funcion obtiene el socio del ejemplar prestado
=cut
sub getSocioFromReserva {
    my ($id3)= @_;

    my @filtros;
    push(@filtros, ( id3 => { eq => $id3 } ));
    push(@filtros, ( estado => { eq => 'E' } ));    

    my $reservas_array_ref = C4::Modelo::CircReserva::Manager->get_circ_reserva(
                                                                                    query => \@filtros,
                                                                                    require_objects => ['socio', 'socio.persona'],
                                                                                    select          => ['socio.*','usr_persona.*']
                                                                                );
    if(scalar(@$reservas_array_ref) > 0){
        return ($reservas_array_ref->[0]->socio);
    }else{
        return 0;
    }
}



=item
Esta funcion obtiene la reserva del ejemplar
Parametros:
    { id3 }
Devuele el objeto o 0 si no lo encuentra
=cut
sub getReservaActiva{

    my ($id3)= @_;

    my @filtros;
    push(@filtros, ( id3 => { eq => $id3 } ));
#    push(@filtros, ( fecha_devolucion => { eq => undef } ) );

    my $reservas_array_ref = C4::Modelo::CircReserva::Manager->get_circ_reserva(
                                                    query => \@filtros,
                                                    require_objects => ['nivel3','socio','ui'],
                                           );
                                           
    if(scalar(@$reservas_array_ref) > 0){
        return ($reservas_array_ref->[0]);
    }else{
        return 0;
    }
}


=head2  sub getNivel3ParaReserva
    Busca un nivel3 sin reservas para los prestamos y nuevas reservas.
=cut
sub getNivel3ParaReserva{
    my ($id2, $db) = @_;


    $db = $db || C4::Modelo::CatRegistroMarcN3->new()->db;

    my $disponibilidad_filtro      = C4::Modelo::RefDisponibilidad::paraPrestamoReferencia(); #  Domiciliario 
    my $estado_disponible_filtro  = C4::Modelo::RefEstado::estadoDisponibleReferencia(); #Disponible

    my @filtros;

    push (  @filtros, ( id2         => { eq => $id2} ) );                                   #ejemplares del grupo
    push (  @filtros, ( marc_record => { like => '%'.$disponibilidad_filtro.'%' } ) );       #con esta disponibilidad
    push (  @filtros, ( marc_record => { like => '%'.$estado_disponible_filtro.'%' } ) );   #con estado disponible

    my $nivel3_array_ref = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(  db => $db ,query => [ @filtros ] );

    foreach my $nivel3 (@$nivel3_array_ref){
	C4::AR::Debug::debug("getNivel3ParaReserva=> id3: ".$nivel3->getId3);
        if(estaLibre($nivel3->getId3)){
            return($nivel3);
        }
    }

    return 0;
}

=head2  sub estaLibre 
    Devuelve si esta libre: sin prestamos ni reservas
=cut
sub estaLibre{

    my ($id3)=@_;   

    my @filtros;
    push(@filtros, ( id3    => { eq => $id3}));
    push(@filtros, ( estado => { ne => undef}));
    my $reservas_count = C4::Modelo::CircReserva::Manager->get_circ_reserva_count( query => \@filtros);

    if ($reservas_count > 0){
	C4::AR::Debug::debug("estaLibre $id3 ? => 0 ");
        return 0;
    }else{
	C4::AR::Debug::debug("estaLibre $id3 ? => 1 ");
	return 1;
    }
}


=head2 sub getDisponibilidadDeGrupoParaPrestamoDomiciliario
    Indica si tiene o no (el grupo) disponibilidad para prestamo DOMICILIARIO
=cut
sub getDisponibilidadDeGrupoParaPrestamoDomiciliario{
    my ($db, $id2) = @_;

    my @filtros;
    my $disponibilidad_filtro      = C4::Modelo::RefDisponibilidad::paraPrestamoReferencia(); #  Domiciliario
    my $estado_disponible_filtro   = C4::Modelo::RefEstado::estadoDisponibleReferencia(); #Disponible

    push(@filtros, ( id2                => { eq => $id2 }) );
    push(@filtros, ( marc_record        => { like => '%'.$disponibilidad_filtro.'%' } ) );       
    push(@filtros, ( marc_record        => { like => '%'.$estado_disponible_filtro.'%' } ) );   

    my $cant = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3_count( db => $db, query => \@filtros);

    C4::AR::Debug::debug("getDisponibilidadDeGrupoParaPrestamoDomiciliario $id2 => $cant ");

    return $cant;
}

=head2
    sub getDisponibilidadDeGrupoParaPrestamoSala
    Indica si tiene o no (el grupo) disponibilidad para prestamo PARA SALA
=cut
sub getDisponibilidadDeGrupoParaPrestamoSala{
    my ($id2) = @_;

    my @filtros;
  
    my $disponibilidad_filtro      = C4::Modelo::RefDisponibilidad::paraPrestamoReferencia(); #  Domiciliario
    my $estado_disponible_filtro   = C4::Modelo::RefEstado::estadoDisponibleReferencia(); #Disponible

    push(@filtros, ( id2                => { eq => $id2}) );
    push(@filtros, ( marc_record        => { like => '%'.$disponibilidad_filtro.'%' } ) );       
    push(@filtros, ( marc_record        => { like => '%'.$estado_disponible_filtro.'%' } ) );   

    my $cant = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3_count( query => \@filtros);

    if($cant > 0){
        return $cant;
    }else{
        return 0;
    }
}
#===================================================hasta aca revisado=======================================================================


sub t_cancelar_y_reservar {
    
    my($params)=@_;

    my $paramsReserva;
    my ($msg_object);   

    my $db = undef;
    my ($reserva) = C4::AR::Reservas::getReserva($params->{'id_reserva'});
    if ($reserva){
        $db = $reserva->db;
        $db->{connect_options}->{AutoCommit} = 0;
        $db->begin_work;
    
        eval {
            $reserva->cancelar_reserva($params);
    
            my ($msg_object)= C4::AR::Reservas::_verificaciones($params);
            
            if(!$msg_object->{'error'}){
    
                ($paramsReserva)= $reserva->reservar($params);
    
                #Se setean los parametros para el mensaje de la reserva SIN ERRORES
                if($paramsReserva->{'estado'} eq 'E'){
                #SE RESERVO CON EXITO UN EJEMPLAR
                    $msg_object->{'error'}= 0;
                    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U302', 'params' => [    $paramsReserva->{'desde'}, 
                                                        $paramsReserva->{'desdeh'},
                                                        $paramsReserva->{'hasta'},
                                                        $paramsReserva->{'hastah'}
                            ]} ) ;
    
                }else{
                #SE REALIZO UN RESERVA DE GRUPO
                    my $borrowerInfo= C4::AR::Usuarios::getBorrowerInfo($params->{'borrowernumber'});
                    $msg_object->{'error'}= 0;
                    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U303', 'params' => [$borrowerInfo->{'emailaddress'}]} ) ;
                }
            }
    
            $db->commit;    
        };
    }
    if ($@){
        #Se loguea error de Base de Datos
        &C4::AR::Mensajes::printErrorDB($@, 'B407',"OPAC");
        eval {$db->rollback};
        #Se setea error para el usuario
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'R011', 'params' => []} ) ;
    }
    $db->{connect_options}->{AutoCommit} = 1;
    
    return ($msg_object);
}

=item
Esta funcion elimina todas las del borrower pasado por parametro
=cut
sub eliminarReservas{
    my ($socio)=@_;

    my $reservas_array_ref = C4::Modelo::CircReserva::Manager->get_circ_reserva(query => [ nro_socio => { eq => $socio } ]); 

    foreach my $reserva (@$reservas_array_ref){
       $reserva->delete();
    }
}


=item
Esta funcion reasigna todas las reservas de un borrower
recibe como parametro un borrowernumber y el responsable
Esta funcion se utiliza por ej. cuando se elimina un usuario
=cut
sub reasignarTodasLasReservasEnEspera{
    my ($params) = @_;

    my $reservas = C4::AR::Reservas::_getReservasAsignadas($params->{'nro_socio'});

    foreach my $reserva (@$reservas){

        $reserva->reasignarEjemplarASiguienteReservaEnEspera($reserva->{'responsable'});
    }
}

sub cant_reservas{
#Cantidad de reservas totales de GRUPO y EJEMPLARES
        my ($nro_socio)=@_;

        my @filtros;
        push(@filtros, ( nro_socio  => { eq => $nro_socio}));
        push(@filtros, ( estado     => { ne => 'P'} ));

        my $reservas_count = C4::Modelo::CircReserva::Manager->get_circ_reserva_count( query => \@filtros); 
        return ($reservas_count);
}

sub cantReservasPorGrupo{
#Devuelve la cantidad de reservas realizadas (SIN PRESTAR) sobre un GRUPO
    my ($id2,$db)=@_;

        $db = $db || C4::Modelo::CircPrestamo->new()->db;
        
        my @filtros;
        push(@filtros, ( id2    => { eq => $id2}));
        push(@filtros, ( estado => { ne => 'P'} ));

        my $reservas_count = C4::Modelo::CircReserva::Manager->get_circ_reserva_count( query => \@filtros, db   => $db,); 

        return ($reservas_count);
}

#cuenta las reservas pendientes del grupo
sub cantReservasPorGrupoEnEspera{
    my ($id2)=@_;

    my @filtros;
    push(@filtros, ( id2    => { eq => $id2}));
    push(@filtros, ( id3    => { eq => undef}));
    push(@filtros, ( estado => { eq => 'G'} ));

    my $reservas_count = C4::Modelo::CircReserva::Manager->get_circ_reserva_count( query => \@filtros); 

    return ($reservas_count);
}

sub cantReservasPorGrupoAsignadas{
    my ($id2)=@_;

    my @filtros;
    push(@filtros, ( id2    => { eq => $id2}));
    push(@filtros, ( id3    => { ne => undef}));
    push(@filtros, ( estado => { eq => 'E'} ));

    my $reservas_count = C4::Modelo::CircReserva::Manager->get_circ_reserva_count( query => \@filtros); 

    return ($reservas_count);
}
#para enviar un mail cuando al usuario se le asigna una reserva
sub Enviar_Email_Asignacion_Reserva{
    my ($reserva,$params)=@_;

    my $desde= $params->{'desde'};
    my $fecha= $params->{'fecha'};
    my $apertura= $params->{'apertura'};
    my $cierre= $params->{'cierre'};
    my $responsable= $params->{'responsable'};

    if (C4::AR::Preferencias::getValorPreferencia("EnabledMailSystem")){

        my $dateformat = C4::Date::get_date_format();
        my $socio= C4::AR::Usuarios::getSocioInfoPorNroSocio($reserva->getNro_socio);

        my $mailFrom        = Encode::decode_utf8(C4::AR::Preferencias::getValorPreferencia("reserveFrom"));
        my $mailSubject     = Encode::decode_utf8(C4::AR::Preferencias::getValorPreferencia("reserveSubject"));
        my $mailMessage     = Encode::decode_utf8(C4::AR::Preferencias::getValorPreferencia("reserveMessage"));
        
        my $nombreUI = Encode::decode_utf8($reserva->ui->getNombre);
        $mailSubject =~ s/BRANCH/$nombreUI/;
        $mailMessage =~ s/BRANCH/$nombreUI/;
        
        my $nombrePersona = Encode::decode_utf8($socio->persona->getNombre);
        $mailMessage =~ s/FIRSTNAME/$nombrePersona/;
        
        my $apellidoPersona = Encode::decode_utf8($socio->persona->getApellido);
        $mailMessage =~ s/SURNAME/$apellidoPersona/;
        
        my $unititle = Encode::decode_utf8(C4::AR::Nivel1::getUnititle($reserva->nivel2->nivel1->getId1));
        $mailMessage =~ s/UNITITLE/$unititle/;
        
        my $tituloReserva = Encode::decode_utf8($reserva->nivel2->nivel1->getTitulo);
        $mailMessage =~ s/TITLE/$tituloReserva/;
        
        my $autorCompleto = Encode::decode_utf8($reserva->nivel2->nivel1->getAutor);
        $mailMessage =~ s/AUTHOR/$autorCompleto/;
        
        my $edicion  =  Encode::decode_utf8($reserva->nivel2->getEdicion);
        $mailMessage =~ s/EDICION/$edicion/;

        $mailMessage =~ s/a2/$apertura/;
        $desde=C4::Date::format_date($desde,$dateformat);
        $mailMessage =~ s/a1/$desde/;
        $mailMessage =~ s/a3/$cierre/;
        $fecha=C4::Date::format_date($fecha,$dateformat);
        $mailMessage =~ s/a4/$fecha/;

        my %mail;
        $mail{'mail_from'}             = $mailFrom;
        $mail{'page_title'}            = Encode::decode_utf8("Asignación de Reserva");
        $mail{'mail_to'}               = $socio->persona->getEmail;
        $mail{'mail_subject'}          = $mailSubject;
        $mail{'mail_message'}          = $mailMessage;

        my ($ok, $msg_error)           = C4::AR::Mail::send_mail(\%mail);

    }#end if (C4::Context->preference("EnabledMailSystem"))
}


#para enviar un mail cuando al usuario se le cancela una reserva
sub Enviar_Email_Cancelacion_Reserva{
    my ($reserva,$responsable)=@_;

   C4::AR::Debug::debug("Reservas => Enviar_Email_Cancelacion_Reserva => EnabledMailSystem => ".C4::AR::Preferencias::getValorPreferencia("EnabledMailSystem"));
   C4::AR::Debug::debug("Reservas => Enviar_Email_Cancelacion_Reserva => enviar_mail_cambio_disponibilidad_cancelacion => ".C4::AR::Preferencias::getValorPreferencia("enviar_mail_cambio_disponibilidad_cancelacion"));

    if (C4::AR::Preferencias::getValorPreferencia("EnabledMailSystem") && C4::AR::Preferencias::getValorPreferencia("enviar_mail_cambio_disponibilidad_cancelacion")){

        my $dateformat = C4::Date::get_date_format();
        my $socio= C4::AR::Usuarios::getSocioInfoPorNroSocio($reserva->getNro_socio);
        
        my $mailFrom        = Encode::decode_utf8(C4::AR::Preferencias::getValorPreferencia("reserveFrom"));
        my $mailSubject     = Encode::decode_utf8(C4::AR::Preferencias::getValorPreferencia("subject_mail_cambio_disponibilidad_cancelacion"));
        my $mailMessage     = Encode::decode_utf8(C4::AR::Preferencias::getValorPreferencia("mensaje_mail_cambio_disponibilidad_cancelacion"));
        
        my $nombreUI = Encode::decode_utf8($reserva->ui->getNombre);
        $mailSubject =~ s/BRANCH/$nombreUI/;
        $mailMessage =~ s/BRANCH/$nombreUI/;
        
        my $nombrePersona = Encode::decode_utf8($socio->persona->getNombre);
        $mailMessage =~ s/FIRSTNAME/$nombrePersona/;
        
        my $apellidoPersona = Encode::decode_utf8($socio->persona->getApellido);
        $mailMessage =~ s/SURNAME/$apellidoPersona/;
        
        my $unititle = Encode::decode_utf8(C4::AR::Nivel1::getUnititle($reserva->nivel2->nivel1->getId1));
        $mailMessage =~ s/UNITITLE/$unititle/;
        
        my $tituloReserva = Encode::decode_utf8($reserva->nivel2->nivel1->getTitulo);
        $mailMessage =~ s/TITLE/$tituloReserva/;
        
        my $autorCompleto = Encode::decode_utf8($reserva->nivel2->nivel1->getAutor);
        $mailMessage =~ s/AUTHOR/$autorCompleto/;
        
        my $edicion  =  Encode::decode_utf8($reserva->nivel2->getEdicion);
        $mailMessage =~ s/EDICION/$edicion/;

        $mailMessage     = Encode::decode_utf8($mailMessage);

        my %mail;
        $mail{'mail_from'}             = $mailFrom;
        $mail{'mail_to'}               = $socio->persona->getEmail;
        $mail{'mail_subject'}          = $mailSubject;
        $mail{'mail_message'}          = $mailMessage;

       C4::AR::Debug::debug("Reservas => Enviar_Email_Cancelacion_Reserva => Se envia el mail ".$mail{'mail_message'});

        my ($ok, $msg_error)           = C4::AR::Mail::send_mail(\%mail);

    }#end if (C4::Context->preference("EnabledMailSystem"))
}




#para enviar un mail cuando al usuario se le pasa una reserva a espera
sub Enviar_Email_Reserva_A_Espera{
    my ($reserva,$responsable)=@_;

    if (C4::AR::Preferencias::getValorPreferencia("EnabledMailSystem") && C4::AR::Preferencias::getValorPreferencia("enviar_mail_cambio_disponibilidad_espera")){

        my $dateformat = C4::Date::get_date_format();
        my $socio= C4::AR::Usuarios::getSocioInfoPorNroSocio($reserva->getNro_socio);
        
        my $mailFrom        = Encode::decode_utf8(C4::AR::Preferencias::getValorPreferencia("reserveFrom"));
        my $mailSubject     = Encode::decode_utf8(C4::AR::Preferencias::getValorPreferencia("subject_mail_cambio_disponibilidad_espera"));
        my $mailMessage     = Encode::decode_utf8(C4::AR::Preferencias::getValorPreferencia("mensaje_mail_cambio_disponibilidad_espera"));
        
        my $nombreUI = Encode::decode_utf8($reserva->ui->getNombre);
        $mailSubject =~ s/BRANCH/$nombreUI/;
        $mailMessage =~ s/BRANCH/$nombreUI/;
        
        my $nombrePersona = Encode::decode_utf8($socio->persona->getNombre);
        $mailMessage =~ s/FIRSTNAME/$nombrePersona/;
        
        my $apellidoPersona = Encode::decode_utf8($socio->persona->getApellido);
        $mailMessage =~ s/SURNAME/$apellidoPersona/;
        
        my $unititle= Encode::decode_utf8(C4::AR::Nivel1::getUnititle($reserva->nivel2->nivel1->getId1));
        $mailMessage =~ s/UNITITLE/$unititle/;
        
        my $tituloReserva = Encode::decode_utf8($reserva->nivel2->nivel1->getTitulo);
        $mailMessage =~ s/TITLE/$tituloReserva/;
        
        my $autorCompleto = Encode::decode_utf8($reserva->nivel2->nivel1->getAutor);
        $mailMessage =~ s/AUTHOR/$autorCompleto/;
        
        my $edicion  =  Encode::decode_utf8($reserva->nivel2->getEdicion);
        $mailMessage =~ s/EDICION/$edicion/;

        $mailMessage     = Encode::decode_utf8($mailMessage);

        my %mail;
        $mail{'mail_from'}             = $mailFrom;
        $mail{'mail_to'}               = $socio->persona->getEmail;
        $mail{'mail_subject'}          = $mailSubject;
        $mail{'mail_message'}          = $mailMessage;

        my ($ok, $msg_error)           = C4::AR::Mail::send_mail(\%mail);

    }#end if (C4::Context->preference("EnabledMailSystem"))
}



=item sub estaReservado
    Devuelve 1 si esta reservado el ejemplar pasado por parametro, 0 caso contrario
=cut
sub estaReservado{
    my ($id3)=@_;   

    my @filtros;
    push(@filtros, ( id3    => { eq => $id3}));
#     push(@filtros, ( estado => { ne => undef}));
    my ($reservas_array_ref) = C4::Modelo::CircReserva::Manager->get_circ_reserva( query => \@filtros);

    if (scalar(@$reservas_array_ref) > 0){
        return 1;
    }else{
        return 0;
    }
}

# =item sub tieneReservas
#     Devuelve 1 si tiene ejemplares reservados en el grupo, 0 caso contrario
# =cut
# sub tieneReservas{
#     my ($id2) = @_;   
# 
#     use C4::Modelo::CircReserva;
#     use C4::Modelo::CircReserva::Manager;
#     my @filtros;
#     push(@filtros, ( id2    => { eq => $id2}));
# 
#     my ($reservas_array_ref) = C4::Modelo::CircReserva::Manager->get_circ_reserva( query => \@filtros);
# 
#     if (scalar(@$reservas_array_ref) > 0){
#         return 1;
#     }else{
#         return 0;
#     }
# }

sub _verificarHorario{
    my $end     = ParseDate(C4::AR::Preferencias::getValorPreferencia("close"));
    my $offset  = C4::AR::Preferencias::getValorPreferencia("offset_operacion_fuera_horario") || 0;
    
    $end        =  DateCalc($end, "+ $offset minutes");
    
    my $begin   = ParseDate(C4::AR::Preferencias::getValorPreferencia("open"));
    my $actual  = ParseDate("now");
    my $error   = 0;

    C4::AR::Debug::debug("_verificarHorario ->>  apertura = $begin , cierre = $end , actual = $actual");

    if ((Date_Cmp($actual, $begin) < 0) || (Date_Cmp($actual, $end) > 0)){
        $error = 1;
    }

    C4::AR::Debug::debug("_verificarHorario ->> error : $error");

    return $error;
}

sub _verificarHorarioES{
    my $end     = ParseDate(C4::AR::Preferencias::getValorPreferencia("close"));
    my $begin   = C4::Date::calc_beginES();
    my $actual  = ParseDate("now");
    my $error   = 0;

    if ((Date_Cmp($actual, $begin) < 0) || (Date_Cmp($actual, $end) > 0)){
        $error = 1;
    }

    return $error;
}

sub getDisponibilidad{
#Devuelve la disponibilidad del item ('Para Sala', 'Domiciliario')
    my ($id3) = @_;   
    my  $cat_registro_marc_n3 = C4::AR::Nivel3::getNivel3FromId3($id3);

    if ($cat_registro_marc_n3){
        return C4::Modelo::RefDisponibilidad->getByPk($cat_registro_marc_n3->getIdDisponibilidad)->getNombre();
#         return C4::AR::Referencias::getNombreDisponibilidad($cat_registro_marc_n3->getIdDisponibilidad);
    }else{
        return (0);
    }
}

=item
_verificarTipoReserva
Verifica que el usuario no reserve un item y que ya tenga una reserva para el mismo grupo
=cut
sub _verificarTipoReserva {
    my ($nro_socio, $id2)=@_;

    my ($reservas, $cant)= C4::AR::Reservas::getReservasDeSocio($nro_socio, $id2);
    #Se intento reservar desde el OPAC sobre el mismo GRUPO
    return ($cant ne 0);
}

=head2
    sub getReservasDeSocio
    devuelve las reservas de grupo del usuario
=cut
sub getReservasDeSocio {
    my ($nro_socio,$id2, $db)=@_;

    $db = $db || C4::Modelo::CircReserva->new()->db;

    my @filtros;
    push(@filtros, ( id2        => { eq => $id2}));
    push(@filtros, ( nro_socio  => { eq => $nro_socio} ));
    push(@filtros, ( estado     => { ne => 'P'} ));

    my $reservas_array_ref = C4::Modelo::CircReserva::Manager->get_circ_reserva(  db => $db, query => \@filtros);

   C4::AR::Debug::debug("getReservasDeSocio -->>  reservas de $id2 de grupo de $nro_socio = ".scalar(@$reservas_array_ref) );

    return ($reservas_array_ref,scalar(@$reservas_array_ref));
}

=head2
    sub getReservasDeSocio
    devuelve las reservas EN ESPERA de grupo del usuario
=cut
sub getReservasDeSocioEnEspera {
    my ($nro_socio,$id2, $db)=@_;

    $db = $db || C4::Modelo::CircReserva->new()->db;

    my @filtros;
    push(@filtros, ( id2        => { eq => $id2}));
    push(@filtros, ( id3        => { eq => undef}));
    push(@filtros, ( nro_socio  => { eq => $nro_socio} ));
    push(@filtros, ( estado     => { eq => 'G'} ));

    my $reservas_array_ref = C4::Modelo::CircReserva::Manager->get_circ_reserva(  db => $db, query => \@filtros);

    return ($reservas_array_ref,scalar(@$reservas_array_ref));
}

=head2
    sub getReservasDeSocio
    devuelve las reservas EN ESPERA de grupo del usuario
=cut
sub getReservasDeSocioAsignadas {
    my ($nro_socio,$id2, $db)=@_;

    $db = $db || C4::Modelo::CircReserva->new()->db;

    my @filtros;
    push(@filtros, ( id2        => { eq => $id2}));
    push(@filtros, ( nro_socio  => { eq => $nro_socio} ));
    push(@filtros, ( estado     => { eq => 'E'} ));

    my $reservas_array_ref = C4::Modelo::CircReserva::Manager->get_circ_reserva(  db => $db, query => \@filtros);

    return ($reservas_array_ref,scalar(@$reservas_array_ref));
}
=head2
    sub getReservasDeId2
    devuelve las reservas de grupo
=cut
sub getReservasDeId2 {
    my ($id2) = @_;

    my @filtros;
    push(@filtros, ( id2        => { eq => $id2}));
    push(@filtros, ( estado     => { ne => 'P'} ));

    my $reservas_array_ref = C4::Modelo::CircReserva::Manager->get_circ_reserva( query => \@filtros, require_objects => ['nivel2']); 

    return ($reservas_array_ref,scalar(@$reservas_array_ref));
}

=head2
    sub getDisponibilidadGrupo
    devuelve si el grupo tiene ejemplares disponibles para reservar
=cut
sub disponibilidadGrupoParaReserva {
    my ($id2) = @_;

    my $nivel3_array_ref  = C4::AR::Nivel3::getNivel3FromId2($id2);

    for(my $i=0;$i<scalar(@$nivel3_array_ref);$i++){
            C4::AR::Debug::debug("disponibilidadGrupoParaReserva>> estadoDisponible: ".$nivel3_array_ref->[$i]->estadoDisponible);
            C4::AR::Debug::debug("disponibilidadGrupoParaReserva>> esParaSala: ".$nivel3_array_ref->[$i]->esParaSala);
              
             if (($nivel3_array_ref->[$i]->estadoDisponible) && (!$nivel3_array_ref->[$i]->esParaSala)) {return 1;}
    }
    return 0;
}


=head2
    sub obtenerReservasDeSocio
=cut
sub obtenerReservasDeSocio {
    

    my ($socio,$db) = @_;
    $db = $db || C4::Modelo::CircReserva->new()->db;

    my $reservas_array_ref = C4::Modelo::CircReserva::Manager->get_circ_reserva( 
                                                    db => $db,
                                                    query => [ nro_socio => { eq => $socio }, estado => {ne => 'P'}],
                                                    require_objects     => [ 'nivel3.nivel2' ], # INNER JOIN
                                                    with_objects        => [ 'nivel3' ], #LEFT JOIN
                                                    sorty_by            => ['circ_reserva.id_reserva DESC'],
                                ); 

    if(scalar(@$reservas_array_ref) > 0){
        return ($reservas_array_ref);
    }else{
        return 0;
    }
}

=head2  
    sub _getReservasAsignadas
    Dado un socio, devuelve las reservas asignadas a el
=cut
sub _getReservasAsignadas {

    my ($socio,$db)=@_;
    $db = $db || C4::Modelo::CircReserva->new()->db;

    my $reservas_array_ref = C4::Modelo::CircReserva::Manager->get_circ_reserva(
                                                                    db => $db,
                                                                    query => [ nro_socio => { eq => $socio }, id3 => {ne => undef}, estado => {ne => 'P'} ],
                                                                    require_objects => ['nivel3','nivel2'] 
                                                    );


    if (scalar(@$reservas_array_ref) > 0){
        return($reservas_array_ref);
    }else{
      return (0);
    }
}


=head2  
    sub _getId3AsignadosyPrestadosById2
    Dado un id2, devuelve los ejemplares o asignados o prestados
=cut
sub _getId3AsignadosyPrestadosById2 {

    my ($id2,$db)=@_;
    $db = $db || C4::Modelo::CircReserva->new()->db;

    my $reservas_array_ref = C4::Modelo::CircReserva::Manager->get_circ_reserva(
                                                                    db => $db,
                                                                    query => [ id2 => { eq => $id2 }, id3 => {ne => undef} ],
                                                                    select => ['id3']
                                                    );


    if (scalar(@$reservas_array_ref) > 0){
        return($reservas_array_ref);
    }else{
      return (0);
    }
}

=head2
    sub getReserva
    Funcion que retorna la informacion de la reserva con el numero que se le pasa por parametro.
=cut
sub getReserva{
    my ($id, $db) = @_;
    my @filtros;

    $db = $db || C4::Modelo::CircReserva->new()->db;

    push (@filtros, (id_reserva => $id) );

    my ($reserva) = C4::Modelo::CircReserva::Manager->get_circ_reserva( 
                                                                        db              => $db,
                                                                        query           => \@filtros, 
                                                                        with_objects    => ['nivel3','nivel2']);



    if (scalar(@$reserva) > 0){
        return ($reserva->[0]);
    }else{
        return(0);
    }
}

=head2
    sub reservasVencidas
    Devuele una referencia a un arreglo con todas las reservas que esta vencidas al dia de la fecha.
=cut
sub reservasVencidas{

    my $dateformat = C4::Date::get_date_format();
    my $hoy=C4::Date::format_date_in_iso(ParseDate("today"), $dateformat);

    my $reservas_array_ref = C4::Modelo::CircReserva::Manager->get_circ_reserva(
                            query => [ fecha_recordatorio => { lt => $hoy }, 
                                   estado => {ne => 'P'}, 
                                   id3 => {ne => undef}],
                            require_objects => ['nivel3','nivel2']
                                ); 
    return ($reservas_array_ref);

}


=head2
    sub getReservasDeSocioEnEspera
    Funcion que trae las reservas en espera de un grupo
=cut
sub getReservasDeSocioEnEspera {
    my($nro_socio)=@_;


    my ($reservas,$cant_reservas) = C4::AR::Reservas::getReservasDeSocio($nro_socio);

    my @reservas_espera;
    if ($cant_reservas){
      foreach my $reserva (@$reservas) {
          if (!$reserva->getId3) {
              #Reservas en espera
              push @reservas_espera, $reserva;
          }
      }    
    }

    if (scalar(@reservas_espera)){
        return(\@reservas_espera);
    }else{
      return(0);
    }
}


=head2
    sub reservasEnEspera
    Funcion que trae las reservas en espera de un grupo
=cut
sub reservasEnEspera {
    my($id2)=@_;

    my @filtros;
    push(@filtros, ( id2 => { eq => $id2}));
    push(@filtros, ( id3 => undef ));

    my $reservas_array_ref = C4::Modelo::CircReserva::Manager->get_circ_reserva( query => \@filtros, sort_by => 'timestamp',
                                                                                   with_objects => ['nivel3','nivel2']
  );

      C4::AR::Debug::debug("Reservas.pm => reservasEnEspera => id2: $id2 ".scalar(@$reservas_array_ref));

  if (scalar(@$reservas_array_ref) == 0){
        return 0;
  }else{
    return(\@$reservas_array_ref);
  }
}


#VERIFICACIONES PREVIAS tanto para reservas desde el OPAC como para PRESTAMO de la INTRANET
sub _verificaciones {
    my($params) = @_;

    my $tipo                = $params->{'tipo'}; #INTRA u OPAC
    my $id2                 = $params->{'id2'};
    my $id3                 = $params->{'id3'};
    my $barcode             = $params->{'barcode'};
    my $nro_socio           = $params->{'nro_socio'};
    my $tipo_prestamo       = $params->{'tipo_prestamo'};
    my $es_reserva;
    if ($params->{'es_reserva'}){
        $es_reserva     = $params->{'es_reserva'};
    } else {
        $es_reserva = undef;
    }

    my $msg_object          = C4::AR::Mensajes::create();
    $msg_object->{'tipo'}   = $tipo;

    my $dateformat          = C4::Date::get_date_format();
    my $socio               = C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);


    if ( ($tipo_prestamo eq "-1") || (!C4::AR::Utilidades::validateString($tipo_prestamo)) ){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'S206', 'params' => []} ) ;
    }

    if ( (!($msg_object->{'error'})) && ($socio) ){
    
      C4::AR::Debug::debug("Reservas.pm => _verificaciones => tipo: $tipo\n");
      C4::AR::Debug::debug("Reservas.pm => _verificaciones => id2: $id2\n");
      C4::AR::Debug::debug("Reservas.pm => _verificaciones => id3: $id3\n");
      C4::AR::Debug::debug("Reservas.pm => _verificaciones => socio: $nro_socio\n");
      C4::AR::Debug::debug("Reservas.pm => _verificaciones => tipo_prestamo: $tipo_prestamo\n");
        
    #Se verifica que el usuario sea Regular
        if ( (!($msg_object->{'error'})) && (!$socio->esRegular) ){
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U300', 'params' => []} ) ;
            C4::AR::Debug::debug("Reservas.pm => _verificaciones => Entro al if de regularidad\n");
        }
    }elsif (!($msg_object->{'error'})){
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U321', 'params' => [$nro_socio]} ) ;
    }

#Se verifica que el usuario halla realizado el curso, segun preferencia del sistema.
    if( !($msg_object->{'error'}) && ($tipo eq "OPAC") && (C4::AR::Preferencias::getValorPreferencia("requisito_necesario")) && 
        (!$socio->getCumple_requisito) ){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U304', 'params' => []} ) ;
        C4::AR::Debug::debug("Reservas.pm => _verificaciones => Entro al if de si cumple o no requisito\n");
    }

#Se verifica que el EJEMPLAR no se encuentre prestado.
#SOLO PARA INTRA, ES UN PRESTAMO INMEDIATO.
    if( !($msg_object->{'error'}) && ($tipo eq "INTRA") &&  C4::AR::Prestamos::estaPrestado($id3) ){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P126', 'params' => [$barcode]} ) ;
        C4::AR::Debug::debug("Reservas.pm => _verificaciones => Entro al if que verifica si el ejemplar se encuentra prestado");
    }

#Se verifica que el EJEMPLAR no se encuentre asignado a otro usuario y no hay más ejemplares libres!!.
#SOLO PARA INTRA, ES UN PRESTAMO INMEDIATO.
    if( !($msg_object->{'error'}) && $tipo eq "INTRA" &&  
      ( C4::AR::Reservas::estaAsignadoAOtroUsuario($id3,$nro_socio) && 
       !C4::AR::Reservas::tieneReservaAsignadaDeGrupo($id2,$nro_socio) && 
       !C4::AR::Reservas::getNivel3ParaReserva($id2))){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P130', 'params' => []} ) ;
        C4::AR::Debug::debug("Reservas.pm => _verificaciones => Entro al if que verifica si el ejemplar se encuentra asignado a otro usuario");
    }

#Si se encuentra configurado, se verifica que el usuario tenga sus datos censales actualizados.
#SOLO PARA INTRA, ES UN PRESTAMO INMEDIATO.
    if( !($msg_object->{'error'}) && $tipo eq "INTRA" && $socio->needsValidation() ){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U506', 'params' => [$nro_socio]} ) ;
        C4::AR::Debug::debug("Reservas.pm => _verificaciones => Entro al if que verifica datos censales");
    }

#Se verifica que el usuario no tenga el maximo de prestamos permitidos para el tipo de prestamo.
#SOLO PARA INTRA, ES UN PRESTAMO INMEDIATO.
    if( !($msg_object->{'error'}) && $tipo eq "INTRA" &&  C4::AR::Prestamos::_verificarMaxTipoPrestamo($nro_socio, $tipo_prestamo) ){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P101', 'params' => [$params->{'descripcionTipoPrestamo'}, $barcode]} ) ;
        C4::AR::Debug::debug("Reservas.pm => _verificaciones => Entro al if que verifica la cantidad de prestamos");
    }

#Se verifica si es un prestamo especial este dentro de los horarios que corresponde.
#SOLO PARA INTRA, ES UN PRESTAMO ESPECIAL.
    if(!$msg_object->{'error'} && $tipo eq "INTRA" && $tipo_prestamo eq 'ES' &&  C4::AR::Reservas::_verificarHorarioES()){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P102', 'params' => []} ) ;
        C4::AR::Debug::debug("Reservas.pm => _verificaciones => Entro al if de prestamos especiales");
    }

#Se verifica que la operación este dentro del horario de funcionamiento de la biblioteca.
#SOLO PARA INTRA, ES UN PRESTAMO.
    if(!$msg_object->{'error'} && $tipo eq "INTRA" && $tipo_prestamo ne 'ES' && !C4::AR::Preferencias::getValorPreferencia("operacion_fuera_horario") && C4::AR::Reservas::_verificarHorario()){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P127', 'params' => []} ) ;
        C4::AR::Debug::debug("Reservas.pm => _verificaciones => Entro al if de operacion fuera de horario");
    }

#Se verfica si el usuario esta sancionado o tiene libros vencidos 
    my ($status_hash) = C4::AR::Sanciones::permisoParaPrestamo($nro_socio, $tipo_prestamo, $es_reserva);
    
    my $sancionado = $status_hash->{'deudaSancion'};
    my $cod_error  = $status_hash->{'cod_error'};
    my $fechaFin   = $status_hash->{'hasta'};
    
    C4::AR::Debug::debug("Reservas.pm => _verificaciones => sancionado: $sancionado ------ fechaFin: $fechaFin\n");
    if( !($msg_object->{'error'}) && ($sancionado || $fechaFin) ){

        $msg_object->{'error'}  = 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=>  $cod_error, 'params' => [C4::Date::format_date($fechaFin, $dateformat)]} ) ;
        C4::AR::Debug::debug("Reservas.pm => _verificaciones => Entro al if de sanciones");
    }

#Se verifica que el usuario no intente reservar desde el OPAC un registro que no tiene items para prestamo domiciliario

    C4::AR::Debug::debug("Reservas.pm => _verificaciones => Disponibilidad???? ".C4::AR::Reservas::disponibilidadGrupoParaReserva($id2));
     if(!$msg_object->{'error'} && $tipo eq "OPAC" && !C4::AR::Reservas::disponibilidadGrupoParaReserva($id2)){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=>  'R007', 'params' => []} ) ;
        C4::AR::Debug::debug("Reservas.pm => _verificaciones => Entro al if de prestamos de sala");
     }

#Se verifica que el usuario no tenga dos reservas sobre el mismo grupo
    if( !($msg_object->{'error'}) && ($tipo eq "OPAC") && (C4::AR::Reservas::_verificarTipoReserva($nro_socio, $id2)) ){
        $msg_object->{'error'}= 1;

        C4::AR::Mensajes::add($msg_object, {'codMsg'=>  'R002', 'params' => []} ) ;
        C4::AR::Debug::debug("Reservas.pm => _verificaciones => Entro al if de reservas iguales, sobre el mismo grupo y tipo de prestamo");
    }
#Verifico la disponibilidad antes de realizar el prestamo
    my $nivel3      = C4::AR::Nivel3::getNivel3FromId3($id3);
    my $disponible  = 0;

    if($nivel3){    
        $disponible  = $nivel3->estadoDisponible();
    }

    if( !($msg_object->{'error'}) && ($tipo eq "INTRA") && !($disponible) ){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=>  'P128', 'params' => []} ) ;
        C4::AR::Debug::debug("Reservas.pm => _verificaciones => Entro al if donde se verifica la disponibilidad");
    }

#Se verifica que el usuario no supere el numero maximo de reservas posibles seteadas en el sistema desde OPAC
    if( !($msg_object->{'error'}) && ($tipo eq "OPAC") && (C4::AR::Usuarios::llegoMaxReservas($nro_socio))){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=>  'R001', 'params' => [C4::AR::Preferencias::getValorPreferencia("maxreserves")]} ) ;
        C4::AR::Debug::debug("Reservas.pm => _verificaciones => Entro al if de maximo de reservas desde OPAC");
    }

    if( !($msg_object->{'error'}) && ($tipo eq "OPAC") && (!C4::AR::Preferencias::getValorPreferencia('CirculationEnabled'))){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=>  'R900', 'params' => []} ) ;
        C4::AR::Debug::debug("Reservas.pm => _verificaciones => Entro al if de maximo de reservas desde OPAC");
    }

#Se verifica que el usuario no tenga un prestamo sobre el mismo grupo para el mismo tipo prestamo (o no, depende de la preferencia "prestar_mismo_grupo_distintos_tipos_prestamo")
    if( !($msg_object->{'error'}) && (C4::AR::Prestamos::getCountPrestamosDeGrupoPorUsuario($nro_socio, $id2, $tipo_prestamo)) ){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=>  'P100', 'params' => []} ) ;
    }

    C4::AR::Debug::debug("Reservas.pm => _verificaciones => FIN ".$msg_object->{'error'}." !!!\n\n");
    C4::AR::Debug::debug("Reservas.pm => _verificaciones => FIN VERIFICACION !!!\n\n");

    C4::AR::Debug::debug($msg_object->{'codMsg'});

    return ($msg_object);
}

#funcion que realiza la transaccion de la RESERVA
sub t_reservarOPAC {
    
    my($params)=@_;
    my $reservaGrupo= 0;
    C4::AR::Debug::debug("Antes de verificar");
    my ($msg_object)= C4::AR::Reservas::_verificaciones($params);
    
    if(!$msg_object->{'error'}){
    #No hay error
        C4::AR::Debug::debug("No hay error");
        my ($paramsReserva);
        my  $reserva = C4::Modelo::CircReserva->new();
        my $db = $reserva->db;
           $db->{connect_options}->{AutoCommit} = 0;
           $db->begin_work;

        eval {

            ($paramsReserva)= $reserva->reservar($params);
            $db->commit;

            #Se setean los parametros para el mensaje de la reserva SIN ERRORES
            if($paramsReserva->{'estado'} eq 'E'){
	            C4::AR::Debug::debug("SE RESERVO CON EXITO UN EJEMPLAR!!! codMsg: U305");
	            #SE RESERVO CON EXITO UN EJEMPLAR
                $msg_object->{'error'} = 0;
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U305', 'tipo'=> 'opac', 'params' => [    
                                                                                        $paramsReserva->{'hasta'}
                                ]} ) ;

            }else{
            #SE REALIZO UN RESERVA DE GRUPO
                C4::AR::Debug::debug("SE REALIZO UN RESERVA DE GRUPO codMsg: U303");
                my $socio= C4::AR::Usuarios::getSocioInfoPorNroSocio($params->{'nro_socio'});
                $msg_object->{'error'}= 0;
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U303', 'tipo'=> 'opac', 'params' => [$socio->persona->getEmail]} ) ;
            }
        };

        if ($@){
            #Se loguea error de Base de Datos
            &C4::AR::Mensajes::printErrorDB($@, 'B400',"OPAC");
            eval {$db->rollback};
            #Se setea error para el usuario
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'R009', 'params' => []} ) ;
        }
        $db->{connect_options}->{AutoCommit} = 1;
        
    }

    return ($msg_object);
}

=item
agregarReservaAHistorial
Agrega una reserva/asignacion/cancelacion de reserva a la tabla de historial de circulacion.
@params: $reserva-->Object CircReserva de la reserva hecha.
=cut

sub agregarReservaAHistorial{
	my ($reserva,$tipo_operacion,$responsable,$hasta,$nota) = @_;

    use C4::Modelo::RepHistorialCirculacion;
    
    my %params = {};
    $params{'nro_socio'}    = $reserva->getNro_socio;
    $params{'id1'}          = $reserva->nivel2->getId1;
    $params{'id2'}          = $reserva->getId2;
    $params{'id3'}          = $reserva->getId3;
    $params{'nro_socio'}    = $reserva->getNro_socio;
    $params{'responsable'}  = $responsable || $reserva->getNro_socio;
    $params{'fecha'}        = $reserva->getFecha_reserva;
    $params{'id_ui'}        = $reserva->getId_ui;
    $params{'estado'}       = $reserva->getEstado;
    $params{'tipo'}         = $tipo_operacion;
    $params{'hasta'}        = $hasta;
    $params{'nota'}         = $nota;

    my $historial_circulacion = C4::Modelo::RepHistorialCirculacion->new(db => $reserva->db);    
    $historial_circulacion->agregar(\%params);
    
	return ($reserva);
}


sub cancelarReservaDesdeGrupoYSocio{
    my ($params)=@_;

    my $nro_socio               = $params->{'nro_socio'};
    my $id2                     = $params->{'id2'};
    $params->{'responsable'}   = $nro_socio;
    
    my $msg_object= C4::AR::Mensajes::create();
    my @filtros;

    push (@filtros, (nro_socio   => { eq => $nro_socio})    );
    push (@filtros, (id2         => { eq => $id2})  );

	    my ($reserva) = C4::Modelo::CircReserva::Manager->get_circ_reserva( 
	                                                                        query           => \@filtros, 
	                                                                        with_objects    => ['nivel3','nivel2']
	                                                                        );

    $reserva = $reserva->[0];

    eval{
	        my $db = $reserva->db;
	        $db->{connect_options}->{AutoCommit} = 0;
	        $db->begin_work;
	            C4::AR::Debug::debug("VAMOS A CANCELAR LA RESERVA");
	            $params->{'id_reserva'} = $reserva->getId_reserva;
	            $reserva->cancelar_reserva($params);
	            $db->commit;
	            $msg_object->{'error'}= 0;
	            C4::AR::Debug::debug("LA RESERVA DESDE KOHA SE CANCELO CON EXITO");
            $db->{connect_options}->{AutoCommit} = 1;
    };

    if ($@){
    	$msg_object->{'error'}= 1;
        C4::AR::Debug::debug("ERROR EN CANCELAR RESERVA DESDE KOHA PARA EL GRUPO $id2 Y EL SOCIO $nro_socio");
    }
    
    return($msg_object);
}


=item
t_cancelar_reserva
Transaccion que cancela una reserva.
@params: $params-->Hash con los datos necesarios para poder cancelar la reserva.
=cut
sub t_cancelar_reserva{
    my ($params)=@_;

    my $tipo = $params->{'tipo'} || 'OPAC';
    my $msg_object= C4::AR::Mensajes::create();
    $msg_object->{'tipo'}=$tipo;
    my $db = undef;
    
    if( (!$msg_object->{'error'}) && ($tipo eq 'OPAC') && (!C4::AR::Preferencias::getValorPreferencia('CirculationEnabled'))){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=>  'R900', 'params' => []} ) ;
    }else{
	    
	     my ($reserva) = C4::AR::Reservas::getReserva($params->{'id_reserva'});
	     if ($reserva){
	        $db = $reserva->db;
	        $db->{connect_options}->{AutoCommit} = 0;
	            $db->begin_work;
	         eval{
	            C4::AR::Debug::debug("VAMOS A CANCELAR LA RESERVA");
	            $reserva->cancelar_reserva($params);
	            $db->commit;
	            $msg_object->{'error'}= 0;
	            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U308', 'params' => []} ) ;
	            C4::AR::Debug::debug("LA RESERVA SE CANCELO CON EXITO");
	         };
	     }else{
	         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'R010', 'params' => []} ) ;
	     }
	 
	     if ($@){
	         C4::AR::Debug::debug("ERROR");
	         #Se loguea error de Base de Datos
	         C4::AR::Mensajes::printErrorDB($@, 'B404',$tipo);
	         eval {$db->rollback};
	         #Se setea error para el usuario
	         $msg_object->{'error'}= 1;
	         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'R010', 'params' => []} ) ;
	     }
	    $db->{connect_options}->{AutoCommit} = 1;
    }
    return ($msg_object);
}

# ## FIXME reservas por Nivel 1 ?????????????, SE ESTA USANDO ARREGLAR O PASAR
=head2
    sub cantReservasPorNivel1
    Devuelve la cantidad de reservas realizadas (SIN PRESTAR) sobre el nivel1
=cut
sub cantReservasPorNivel1{
    my ($id1) = @_;
    
    my @filtros;
    
    push (@filtros, ('nivel2.id1' => {eq => $id1}));
    push (@filtros, ('estado' => {ne => 'P'}));

    my ($count) = C4::Modelo::CircReserva::Manager->get_circ_reserva_count(
                                                                    query => \@filtros, 
                                                                    require_objects => ['nivel2']
                                                                );


    return $count;
}


#===================================================================================================================================

=item sub reasignarNuevoEjemplarAReserva
    Esta funcion intenta reasignar un ejemplar disponible del mismo grupo a la reserva, ya que el ejemplar que tenia asignado
    no se encuentra mas disponible   

    @Parametros

        $params->{'id3'}:
        $params->{'id2'}:
        $params->{'db'}:
=cut
sub reasignarNuevoEjemplarAReserva{
    my ($db, $params, $msg_object) = @_;

    C4::AR::Debug::debug("Reservas => reasignarNuevoEjemplarAReserva => id3: ".$params->{'id3'});
    #se verifca si el ejemplar que se esta modificado tiene o no un reserva asignada
    my ($reserva_asignada) = C4::AR::Reservas::getReservaDeId3($params->{'id3'}, $db);

    if($reserva_asignada){
        C4::AR::Debug::debug("Reservas => reasignarNuevoEjemplarAReserva => tiene reserva asignada ");
        #si TIENE RESERVA ASIGNADA hay q buscar un ejemplar disponible para asignarlo a la reserva
        my ($nuevoId3) = C4::AR::Reservas::getEjemplarDeGrupoParaReserva($params->{'id2'});
    
        if($nuevoId3){
            C4::AR::Debug::debug("Reservas => reasignarNuevoEjemplarAReserva => EXISTE ejemplar disponible");
            #EXISTE un ejemplar disponible
            $reserva_asignada->intercambiarId3 ($nuevoId3, $msg_object, $db);
        }else{
            C4::AR::Debug::debug("Reservas => reasignarNuevoEjemplarAReserva => NO EXISTE");
            #NO EXISTE un ejemplar disponible del grupo
	    #Verifico la disponibilidad para reservas del grupo
	    my ($cant) = C4::AR::Reservas::getDisponibilidadDeGrupoParaPrestamoDomiciliario($db, $params->{'id2'});
	    if($cant == 0){
		#No hay mas disponibilidad en el grupo, se cancela la reserva.
		C4::AR::Debug::debug("Reservas => reasignarNuevoEjemplarAReserva => NO hay disponibilidad para el grupo id2: ".$params->{'id2'}." se CANCELA la reserva asignada!!!");

		#Se envia una notificacion al usuario avisando que se le cancelo la reserva por cambio de disponibilidad
		C4::AR::Reservas::Enviar_Email_Cancelacion_Reserva($reserva_asignada,$params->{'responsable'});

		$reserva_asignada->cancelar_reserva($params);

	    } else {
		#a la reserva se la pasa a reserva en  espera (id3 = null). Además, se borra la sanción de esa reserva.
		C4::AR::Debug::debug("Reservas => reasignarNuevoEjemplarAReserva => paso la reserva a ESPERA (estado = G)");

		#Se envia una notificacion al usuario avisando que se le cancelo la reserva por cambio de disponibilidad
		C4::AR::Reservas::Enviar_Email_Reserva_A_Espera($reserva_asignada,$params->{'responsable'});

		$reserva_asignada->pasar_a_espera();

	    }
        }
    }else{
        #no tiene reserva asiganada, NO SE HACE NADA
    }

}


=item sub manejoDeDisponibilidadDomiciliaria
    Esta funcion se encarga de "manejar" la disponibilidad para reservas domiciliarias

    @Parametros

        $params->{'id2'}: grupo con el que se esta trabajando
=cut
sub manejoDeDisponibilidadDomiciliaria{
    my ($db, $params) = @_;

    #verifico la disponibilidad del grupo
    my ($cant) = C4::AR::Reservas::getDisponibilidadDeGrupoParaPrestamoDomiciliario($db, $params->{'id2'});
    if($cant == 0){
        C4::AR::Debug::debug("manejoDeDisponibilidadDomiciliaria => NO hay disponibilidad para el grupo id2: ".$params->{'id2'});
        #si no hay disponibilidad, (el grupo ahora NO TIENE mas ejemplares para prestamo), 
        #elimino TODAS las reservas en espera y la asignada del GRUPO, tambien elimino las sanciones y las reservas
        #retorna las reserva en espera (SI EXISTEN) del grupo
        my ($reservas_en_espera_array_ref) = C4::AR::Reservas::getReservasEnEsperaById2($db, $params->{'id2'}); 

        if($reservas_en_espera_array_ref){
          foreach my $r (@$reservas_en_espera_array_ref) {
              C4::AR::Debug::debug("manejoDeDisponibilidadDomiciliaria => elimino la reserva con id_reserva: ".$r->getId_reserva);
          #elimino todas las sanciones y las reservas
              $r->borrar_sancion_de_reserva($params->{'db'});
              $r->delete();
          }
        }
    }
  else{
        C4::AR::Debug::debug("manejoDeDisponibilidadDomiciliaria => aun hay ejemplares disponibles para reservar");
   }
}

=item sub asignarEjemplarASiguienteReservaEnEspera

    Esta funcion asgina el ejemplar a una reserva (SI EXISTE) que se encontraba en la cola de espera para un grupo determinado

    @Parametros:
        $params->{'id2'}: 
        $params->{'id3'}:
        $params->{'responsable'}: el usuario logueado
=cut
sub asignarEjemplarASiguienteReservaEnEspera{
    my ($params, $db) = @_;

    my ($reservaGrupo) = C4::AR::Reservas::getReservaEnEsperaById2($db, $params->{'id2'}); #retorna la primer reserva en espera (SI EXISTE) del grupo

    if($reservaGrupo){
        #Si hay al menos un ejemplar esperando se reasigna
        $reservaGrupo->setId3($params->{'id3'});
        $reservaGrupo->setId_ui($params->{'id_ui'});
        $reservaGrupo->actualizarDatosReservaEnEspera($params->{'responsable'});
    }
}




=item sub getEjemplarDeGrupoParaReserva
    Busca los ejemplares del grupo disponibles para reserva.
=cut

sub getEjemplaresDeGrupoParaReserva{
    my ($id2)   = @_;

    my @filtros;
    my $disponibilidad_filtro      = C4::Modelo::RefDisponibilidad::paraPrestamoReferencia(); #  Domiciliario
    my $estado_disponible_filtro   = C4::Modelo::RefEstado::estadoDisponibleReferencia(); #Disponible

    push(@filtros, ( id2                => { eq => $id2 }) );
    push(@filtros, ( marc_record        => { like => '%'.$disponibilidad_filtro.'%' } ) );       
    push(@filtros, ( marc_record        => { like => '%'.$estado_disponible_filtro.'%' } ) );

    #Hay que sacar los ejemplares reservados o prestados
    my $reservas =C4::AR::Reservas::_getId3AsignadosyPrestadosById2($id2);
    if($reservas) {
      foreach my $reserva (@$reservas){
	    push(@filtros, ( id  => { ne => $reserva->getId3 }) );
      }
    }

    my $ejemplares_array_ref = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3 ( query => \@filtros);

    if(scalar(@$ejemplares_array_ref) > 0){
        return ($ejemplares_array_ref);
    }else{
        return 0;
    }
}

=item sub getEjemplarDeGrupoParaReserva
    Devuelve el primer el ejemplar (si existe) del grupo disponible para reserva.
    Si no hay ejemplar retorna 0
=cut
sub getEjemplarDeGrupoParaReserva {
    my ($id2) = @_;
    my $ejemplares_array_ref = C4::AR::Reservas::getEjemplaresDeGrupoParaReserva($id2);

    if($ejemplares_array_ref){
        return $ejemplares_array_ref->[0]->getId3();
    }else{
        return 0;
    }
}

=item sub getReservaDeId3
    Devuelve la reserva del item

    @Parametros
    $id3 = id3 del ejemplar del cual se intenta recuperar la reserva
=cut
sub getReservaDeId3{
    my ($id3, $db) = @_;

    $db = $db || C4::Modelo::PermCatalogo->new()->db;  

C4::AR::Debug::debug("Reservas => getReservaDeId3 => id3 => ".$id3);

    my @filtros;
    push(@filtros, ( id3        => { eq => $id3}));
    push(@filtros, ( estado     => { ne => 'P'} ));

    my ($reservas_array_ref) = C4::Modelo::CircReserva::Manager->get_circ_reserva( 
                                                                                    db => $db, 
                                                                                    query => \@filtros, 
                                                                                    require_objects => ['nivel3','nivel2']
                                                                            ); 

    if(scalar(@$reservas_array_ref) > 0){
        return ($reservas_array_ref->[0]);
    }else{
        #el ejemplar NO TIENE reserva
        return 0;
    }
}


=item sub getReservaEnEspera
Funcion que trae los datos de la primer reserva de la cola que estaba esperando que se desocupe un ejemplar del grupo de esta misma reserva.
=cut
sub getReservaEnEsperaById2{
    my ($db, $id2) = @_;

    my $reservas_array_ref = C4::AR::Reservas::getReservasEnEsperaById2($db, $id2);

    if($reservas_array_ref eq 0){
        #NO hay reservas en espera para este grupo
        return 0;
    }else{
        return ($reservas_array_ref->[0]);
    }
}


=item sub getReservasEnEsperaById2
Funcion que trae las reservas en espera sobre un grupo.
=cut
sub getReservasEnEsperaById2{
    my ($db, $id2) = @_;

    my @filtros;
    push(@filtros, ( id2 => { eq => $id2 }));
    push(@filtros, ( estado => { eq => 'G' }));
    push(@filtros, ( id3 => undef ));

    my $reservas_array_ref = C4::Modelo::CircReserva::Manager->get_circ_reserva(    db      => $db,
                                                                                    query   => \@filtros,
                                                                                    with_objects => ['ui','socio'],
                                                                                    sort_by => 'timestamp',
                                                                ); 

    if(scalar(@$reservas_array_ref) > 0){
        return ($reservas_array_ref);
    }else{
        #NO hay reservas en espera para este grupo
        return 0;
    }
}

=item sub getReservaById
    Esta funcion recupera la reserva segun id_reserva pasado por parametros
    retorna la reserva o 0 si no existe
=cut
sub getReservaById{
    my ($id_reserva) = @_;

    my @filtros;
    push(@filtros, ( id_reserva => { eq => $id_reserva }));

    my ($reservas_array_ref) = C4::Modelo::CircReserva::Manager->get_circ_reserva(    
                                                                                    query   => \@filtros,
                                                                ); 

    if(scalar(@$reservas_array_ref) > 0){
        return ($reservas_array_ref->[0]);
    }else{
        #NO EXISTE la reserva con id_reserva pasado por parametro
        return 0;
    }
}

=item
    Funcion que trae el historial de reservas de un socio.
    La consulta se hace sobre rep_historial_circulacion porque en circ_reserva se borran las reservas pasadas
    Se filtra por las operaciones: cancelacion, devolucion y reserva
=cut
sub getHistorialReservasParaTemplate {

    my ($nro_socio,$ini,$cantR,$orden) = @_;
    
    $cantR  = $cantR || 10;
    $ini    = $ini || 0;
    
    use C4::Modelo::RepHistorialCirculacion;
    use C4::Modelo::RepHistorialCirculacion::Manager;
    
    my @filtros;
    push(@filtros, ( nro_socio => { eq => $nro_socio }));
    push(@filtros, ( tipo_operacion => { eq => ['cancelacion','reserva','espera','asignacion'] } ) );

    my $reservas_array_ref = C4::Modelo::RepHistorialCirculacion::Manager->get_rep_historial_circulacion( 
                                          query             => \@filtros,
                                          with_objects      => ['nivel2', 'nivel3','socio', 'nivel3.nivel2.nivel1'],
                                          sort_by           => $orden,
                                          limit             => $cantR,
                                          offset            => $ini,
                                ); 
    my $reservas_array_ref_count = C4::Modelo::RepHistorialCirculacion::Manager->get_rep_historial_circulacion_count(query => \@filtros,); 
    return ($reservas_array_ref_count, $reservas_array_ref);
}


=item
Esta funcion retorna si el ejemplar segun el id3 pasado por parametro esta asignado a otra persona
=cut
sub estaAsignadoAOtroUsuario {
    my ($id3,$nro_socio) = @_;
    
    use C4::Modelo::CircReserva;
    use C4::Modelo::CircReserva::Manager;

    my $reserva_array_ref= C4::Modelo::CircReserva::Manager->get_circ_reserva( 
                                                                query => [  estado  => { eq => 'E' }, 
									    nro_socio => { ne => $nro_socio }, 
                                                                            id3  => { eq => $id3 }
                                                                ]
                                ); 

    return (scalar(@$reserva_array_ref) > 0);
}

=item
Esta funcion retorna si el usuario tiene algun ejemplar asignado en el grupo
=cut
sub tieneReservaAsignadaDeGrupo {
    my ($id2,$nro_socio) = @_;
    
    use C4::Modelo::CircReserva;
    use C4::Modelo::CircReserva::Manager;

    my $reserva_array_ref= C4::Modelo::CircReserva::Manager->get_circ_reserva( 
                                                                query => [  estado  => { eq => 'E' }, 
									    nro_socio => { eq => $nro_socio }, 
                                                                            id2  => { eq => $id2 }
                                                                ]
                                ); 

    return (scalar(@$reserva_array_ref) > 0);
}


END { }       # module clean-up code here (global destructor)

1;
__END__
