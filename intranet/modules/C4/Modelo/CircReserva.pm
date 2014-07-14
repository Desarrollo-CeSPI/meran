package C4::Modelo::CircReserva;

use strict;
use Date::Manip;
use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'circ_reserva',

    columns => [
        id2              => { type => 'integer', overflow => 'truncate', not_null => 1 },
        id3              => { type => 'integer', overflow => 'truncate' },
        id_reserva       => { type => 'serial', overflow => 'truncate', not_null => 1 },
        nro_socio    	 => { type => 'varchar', overflow => 'truncate', length => 16, not_null => 1 },
        fecha_reserva    => { type => 'varchar', overflow => 'truncate', default => '0000-00-00', not_null => 1 },
        estado           => { type => 'character', overflow => 'truncate', length => 1 },
        id_ui	      	 => { type => 'varchar', overflow => 'truncate', length => 4 },
        fecha_notificacion => { type => 'varchar', overflow => 'truncate' },
        fecha_recordatorio  => { type => 'varchar', overflow => 'truncate' },
        timestamp        => { type => 'timestamp', not_null => 1 },
    ],

    primary_key_columns => [ 'id_reserva' ],

    unique_key => [ 'nro_socio', 'id3' ],

    relationships => [
        nivel3 => {
            class       => 'C4::Modelo::CatRegistroMarcN3',
            key_columns => { id3 => 'id' },
	        type        => 'one to one',
        },
        nivel2 => {
            class       => 'C4::Modelo::CatRegistroMarcN2',
            key_columns => { id2 => 'id' },
	        type        => 'one to one',
        },
        socio => {
            class       => 'C4::Modelo::UsrSocio',
            key_columns => { nro_socio => 'nro_socio' },
	        type        => 'one to one',
            },
        ui =>  {
            class       => 'C4::Modelo::PrefUnidadInformacion',
            key_columns => { id_ui => 'id_ui' },
            type        => 'one to one',
        },
    ],
);

use C4::Modelo::CircSancion::Manager;
use C4::Modelo::RepHistorialCirculacion;
use C4::Modelo::CircSancion;
use C4::Modelo::CircReserva::Manager;
use C4::Modelo::CircReserva;

sub getId_reserva{
    my ($self) = shift;
    return ($self->id_reserva);
}

sub setId_reserva{
    my ($self) = shift;
    my ($id_reserva) = @_;
    $self->id_reserva($id_reserva);
}

sub getId3{
    my ($self) = shift;
    return ($self->id3);
}

sub setId3{
    my ($self) = shift;
    my ($id3) = @_;
    $self->id3($id3);
}

sub getId2{
    my ($self) = shift;
    return ($self->id2);
}

sub setId2{
    my ($self) = shift;
    my ($id2) = @_;
    $self->id2($id2);
}

sub getNro_socio{
    my ($self) = shift;
    return ($self->nro_socio);
}

sub setNro_socio{
    my ($self) = shift;
    my ($nro_socio) = @_;
    $self->nro_socio($nro_socio);
}

sub getFecha_reserva{
    my ($self) = shift;
    return ($self->fecha_reserva);
}

sub estaVencida{
    my ($self) = shift; 

    my $dateformat = C4::Date::get_date_format();
    my $hoy = C4::Date::format_date_in_iso(Date::Manip::ParseDate("today"), $dateformat);
    my $fecha_vencimiento = $self->getFecha_notificacion_formateada();
    $fecha_vencimiento = C4::Date::format_date_in_iso(Date::Manip::ParseDate($fecha_vencimiento), $dateformat);
    if ( Date::Manip::Date_Cmp( $fecha_vencimiento, $hoy ) < 0 ){
    	return (1);
    }
    
    return (0);
	
}

sub getFecha_reserva_formateada{
    my ($self) = shift; 
	my $dateformat = C4::Date::get_date_format();
    return C4::Date::format_date(C4::AR::Utilidades::trim($self->getFecha_reserva),$dateformat);
}

sub setFecha_reserva{
    my ($self) = shift;
    my ($fecha_reserva) = @_;
    $self->fecha_reserva($fecha_reserva);
}

sub getFecha_notificacion{
    my ($self) = shift;
    return ($self->fecha_notificacion);
}

sub getFecha_notificacion_formateada{
    my ($self) = shift; 
	my $dateformat = C4::Date::get_date_format();
		$self->debug("Fecha de notificacion: ".$self->getFecha_notificacion);
    return C4::Date::format_date(C4::AR::Utilidades::trim($self->getFecha_notificacion),$dateformat);
}

sub setFecha_notificacion{
    my ($self) = shift;
    my ($fecha_notificacion) = @_;
    $self->fecha_notificacion($fecha_notificacion);
}

sub getFecha_recordatorio{
    my ($self) = shift;
    return ($self->fecha_recordatorio);
}

sub getFecha_recordatorio_formateada{
    my ($self) = shift; 
	my $dateformat = C4::Date::get_date_format();
	$self->debug("Fecha de recordatorio: ".$self->getFecha_recordatorio);
    return C4::Date::format_date(C4::AR::Utilidades::trim($self->getFecha_recordatorio),$dateformat);
}

sub setFecha_recordatorio{
    my ($self) = shift;
    my ($fecha_recordatorio) = @_;
    $self->fecha_recordatorio($fecha_recordatorio);
}

sub getId_ui{
    my ($self) = shift;
    return ($self->id_ui);
}

sub setId_ui{
    my ($self) = shift;
    my ($id_ui) = @_;
    $self->id_ui($id_ui);
}

sub getEstado{
    my ($self) = shift;
    return ($self->estado);
}

sub setEstado{
    my ($self) = shift;
    my ($estado) = @_;
    $self->estado($estado);
}

sub getTimestamp{
    my ($self) = shift;
    return ($self->timestamp);
}


sub esEspera{
    my ($self)      = shift;

    return (!C4::AR::Utilidades::validateString($self->getId3()));	
}
=item
agregar
Funcion que agrega una reserva
=cut

sub agregar {
    my ($self)      = shift;
    my ($data_hash) = @_;
    #Asignando data...
    
    my $session_type = lc C4::AR::Auth::getSessionType();
    
    $self->setId3($data_hash->{'id3'}||undef);
    $self->setId2($data_hash->{'id2'});
    $self->setNro_socio($data_hash->{'nro_socio'});
    $self->setFecha_reserva($data_hash->{'fecha_reserva'});
    $self->setFecha_recordatorio($data_hash->{'fecha_recordatorio'});
    $self->setId_ui($data_hash->{'id_ui'});
    $self->setEstado($data_hash->{'estado'});
    $self->save();


    eval{
        $self->nivel2->nivel1->hit();
    };

#**********************************Se registra el movimiento en rep_historial_circulacion***************************

    #Este IF se agrega para que no se registre en historico de circulacion la reserva automatica
    if (rindex($session_type,'intra') == -1 ){
        my $tipo="";
        if ($self->getId3) {
            #Reserva con ejemplar
            $tipo            = 'RESERVA';
        }else{
            #Reserva de grupo, en espera
            $tipo            = 'ESPERA';
        }
        my $hasta              = C4::Date::format_date($data_hash->{'fecha_recordatorio'}, C4::Date::get_date_format());
        my $responsable     = $data_hash->{'nro_socio'};

        $self->debug("Se loguea en historico de circulacion la reserva que viene del opac");
        C4::AR::Reservas::agregarReservaAHistorial($self,$tipo,$responsable,$hasta);

#*******************************Fin***Se registra el movimiento en rep_historial_circulacion*************************
    }
}

=item
agregar
Funcion para reservar
=cut

sub reservar {
	my ($self)=shift;
	my($params)=@_;


	$self->debug("RESERVA: tipo: ".$params->{'tipo'}." id2: ".$params->{'id2'}." id3: ".$params->{'id3'}." tipo_p:".$params->{'tipo_prestamo'});
	$self->debug("RESERVA: socio: ".$params->{'nro_socio'}." resp: ".$params->{'responsable'});

	my $dateformat = C4::Date::get_date_format();
	my $id3= $params->{'id3'}||'';
	if($params->{'tipo'} eq 'OPAC'){
		my $nivel3= C4::AR::Reservas::getNivel3ParaReserva($params->{'id2'},$self->db);
		if($nivel3){ $id3=$nivel3->getId3;}
		$self->debug("RESERVA: es para OPAC se buscan algún nivel 3 para reservar");
	}


    C4::AR::Debug::debug("***_______________________________CALCULO DÍAS DE RESERVA_______________________***");	
	#Numero de dias que tiene el usuario para retirar el libro si la reserva se efectua sobre un item
	my $numeroDias                          = C4::AR::Preferencias::getValorPreferencia("reserveItem");
	my ($desde,$hasta,$apertura,$cierre)    = C4::Date::proximosHabiles($numeroDias,1);
	
    C4::AR::Debug::debug("C4::AR::CircReserva => reservar => desde => ".$desde);
    C4::AR::Debug::debug("C4::AR::CircReserva => reservar => hasta => ".$hasta);

	my %paramsReserva;
	$paramsReserva{'id1'}                   = $params->{'id1'};
	$paramsReserva{'id2'}                   = $params->{'id2'};
	$paramsReserva{'id3'}                   = $id3;
	$paramsReserva{'nro_socio'}             = $params->{'nro_socio'};
	$paramsReserva{'responsable'}           = $params->{'responsable'};
	$paramsReserva{'fecha_reserva'}         = $desde;
	$paramsReserva{'fecha_recordatorio'}    = $hasta;
	$paramsReserva{'id_ui'}                 = C4::AR::Preferencias::getValorPreferencia("defaultUI");
	$paramsReserva{'estado'}                = ($id3 ne '')?'E':'G';
	$paramsReserva{'hasta'}                 = C4::Date::format_date($hasta,$dateformat);
	C4::AR::Debug::debug("C4::AR::CircReserva => reservar => hasta hash => ".$paramsReserva{'hasta'});
	$paramsReserva{'desde'}                 = C4::Date::format_date($desde,$dateformat);
	C4::AR::Debug::debug("C4::AR::CircReserva => reservar => desde hash => ".$paramsReserva{'desde'});
	$paramsReserva{'desdeh'}                = $apertura;
	$paramsReserva{'hastah'}                = $cierre;
	$paramsReserva{'tipo_prestamo'}         = $params->{'tipo_prestamo'};


    $self->debug("RESERVA: estado: ".$paramsReserva{'estado'}." id_ui: ".	$paramsReserva{'id_ui'});


	$self->agregar(\%paramsReserva);


	C4::AR::Debug::debug("C4::AR::CircReserva => reservar => desde hash2 => ".$paramsReserva{'desde'});
	C4::AR::Debug::debug("C4::AR::CircReserva => reservar => hasta hash2 => ".$paramsReserva{'hasta'});
		
	$paramsReserva{'id_reserva'}= $self->getId_reserva;

	if( ($id3 ne '')&&($params->{'tipo'} eq 'OPAC') ){
		#es una reserva de ITEM, se le agrega una SANCION al usuario al comienzo del dia siguiente
		#al ultimo dia que tiene el usuario para ir a retirar el libro
		
		C4::AR::Debug::debug("***__________________________CALCULO COMIENZO SANCION RESERVA__________________***");		
    my ($fin_reserva,$comienzo_sancion,$apertura,$cierre)    = C4::Date::proximosHabiles(1,1,$hasta);

		my $fechaHoy =  C4::Date::format_date_in_iso( Date::Manip::ParseDate("today"), $dateformat );		
		my $diasDeSancionReserva =  C4::AR::Sanciones::diasDeSancion( $comienzo_sancion,$fin_reserva,$self->socio->getCod_categoria ,'RE' );
		C4::AR::Debug::debug("***___________________________________DIAS SANCION RESERVA___________________________".$diasDeSancionReserva);	
		
		my $tipo_sancion = C4::AR::Sanciones::getTipoSancion('RE', $self->socio->getCod_categoria ,$self->db);
		
		if (($diasDeSancionReserva > 0)&&($tipo_sancion)) {
			C4::AR::Debug::debug("***_____________________________CALCULO FIN SANCION RESERVA____________________***");
			my ($fecha_comienzo_sancion,$fecha_fin_sancion,$apertura,$cierre) = C4::Date::proximosHabiles($diasDeSancionReserva,0,$comienzo_sancion);
			
			$fecha_comienzo_sancion              = C4::Date::format_date_in_iso($fecha_comienzo_sancion,$dateformat);
			$fecha_fin_sancion                = C4::Date::format_date_in_iso($fecha_fin_sancion,$dateformat);
			my  $sancion            = C4::Modelo::CircSancion->new(db => $self->db);
			my %paramsSancion;
			#Responsable ahora es: 'Sistema', ticket #2645. Por reserva no retirada en el rep_historial_sancion
			#$paramsSancion{'responsable'} = $params->{'responsable'};
			$paramsSancion{'responsable'}       = "Sistema";
			$paramsSancion{'tipo_sancion'}      = $tipo_sancion->getTipo_sancion;
			$paramsSancion{'id_reserva'}        = $self->getId_reserva;
			$paramsSancion{'nro_socio'}         = $params->{'nro_socio'};
			$paramsSancion{'fecha_comienzo'}    = $fecha_comienzo_sancion;
			$paramsSancion{'fecha_final'}       = $fecha_fin_sancion;
			$paramsSancion{'dias_sancion'}      = $diasDeSancionReserva;
			$paramsSancion{'id3'}		        = $self->getId3;

			$sancion->insertar_sancion(\%paramsSancion);
		}
	}

	return (\%paramsReserva);
}


 
=item
 cancelar_reserva
 Funcion que cancela una reserva
=cut
sub cancelar_reserva{
	my ($self)      = shift;
	my ($params)    = @_;
	my $nro_socio   = $params->{'nro_socio'};
	my $responsable = $params->{'responsable'};
    my $nota        = $params->{'nota'};

	if($self->getId3){
		$self->debug("Es una reserva asignada se trata de reasignar");
        # Si la reserva que voy a cancelar estaba asociada a un item tengo que reasignar ese item a otra reserva para el mismo grupo
		$self->reasignarEjemplarASiguienteReservaEnEspera($responsable);
        # Se borra la sancion correspondiente a la reserva si es que la sancion todavia no entro en vigencia
		$self->debug("Se borra la sancion de la reserva");
		$self->borrar_sancion_de_reserva();
	}

	$self->debug("Se loguea en historico de circulacion la cancelacion");
    C4::AR::Reservas::agregarReservaAHistorial($self,'CANCELACION',$responsable,"",$nota);
	$self->debug("Se cancela efectivamente");
    #Haya o no uno esperando elimino el que existia porque la reserva se esta cancelando
	$self->delete();
}



=item sub actualizarDatosReservaEnEspera
Funcion que actualiza la reserva que estaba esperando por un ejemplar.
=cut
sub actualizarDatosReservaEnEspera{
	my ($self) = shift;

	my ($responsable) = @_;

	my $dateformat = C4::Date::get_date_format();
	my $hoy = C4::Date::format_date_in_iso(Date::Manip::ParseDate("today"), $dateformat);

    #Se actualiza la reserva
	my ($desde,$hasta,$apertura,$cierre) = C4::Date::proximosHabiles(C4::AR::Preferencias::getValorPreferencia("reserveGroup"),1);
	$self->setEstado('E');
	$self->setFecha_reserva($desde);
	$self->setFecha_notificacion($hoy);
	$self->setFecha_recordatorio($hasta);
	$self->save();


		C4::AR::Debug::debug("***___actualizarDatosReservaEnEspera___CALCULO COMIENZO SANCION RESERVA__________________***");		
    my ($fin_reserva,$comienzo_sancion,$apertura,$cierre)    = C4::Date::proximosHabiles(1,1,$hasta);
	
		my $diasDeSancionReserva =  C4::AR::Sanciones::diasDeSancion( $comienzo_sancion,$fin_reserva,$self->socio->getCod_categoria ,'RE' );
		C4::AR::Debug::debug("***___actualizarDatosReservaEnEspera___DIAS SANCION RESERVA___________________________".$diasDeSancionReserva);	
		
		my $tipo_sancion = C4::AR::Sanciones::getTipoSancion('RE', $self->socio->getCod_categoria ,$self->db);
		
		if (($diasDeSancionReserva > 0)&&($tipo_sancion)) {
			C4::AR::Debug::debug("***___actualizarDatosReservaEnEspera___CALCULO FIN SANCION RESERVA____________________***");
			my ($fecha_comienzo_sancion,$fecha_fin_sancion,$apertura,$cierre) = C4::Date::proximosHabiles($diasDeSancionReserva,0,$comienzo_sancion);
			
			$fecha_comienzo_sancion             = C4::Date::format_date_in_iso($fecha_comienzo_sancion,$dateformat);
			$fecha_fin_sancion                  = C4::Date::format_date_in_iso($fecha_fin_sancion,$dateformat);
			my  $sancion                        = C4::Modelo::CircSancion->new(db => $self->db);
			my %paramsSancion;
			$paramsSancion{'responsable'}       = "Sistema";
			$paramsSancion{'tipo_sancion'}      = $tipo_sancion->getTipo_sancion;
			$paramsSancion{'id_reserva'}        = $self->getId_reserva;
			$paramsSancion{'nro_socio'}         = $self->getNro_socio;
			$paramsSancion{'fecha_comienzo'}    = $fecha_comienzo_sancion;
			$paramsSancion{'fecha_final'}       = $fecha_fin_sancion;
			$paramsSancion{'dias_sancion'}      = $diasDeSancionReserva;
			$paramsSancion{'id3'}		        = $self->getId3;

			$sancion->insertar_sancion(\%paramsSancion);
		}

	my $params;
	$params->{'cierre'}= $cierre;
	$params->{'fecha'}= $hasta;
	$params->{'desde'}= $desde;
	$params->{'apertura'}= $apertura;
	$params->{'responsable'}= $responsable;
	#Se envia una notificacion al usuario avisando que se le asigno una reserva

	   C4::AR::Reservas::Enviar_Email_Asignacion_Reserva($self,$params);
}

=item sub getReservaEnEspera
Funcion que trae los datos de la primer reserva de la cola que estaba esperando que se desocupe un ejemplar del grupo de esta misma reserva.
=cut
sub getReservaEnEspera{
	my ($self) = shift;
    my @filtros;
    push(@filtros, ( id2 => { eq => $self->getId2 }));
    push(@filtros, ( id3 => undef ));

    my $reservas_array_ref = C4::Modelo::CircReserva::Manager->get_circ_reserva(    db      => $self->db,
										    query   => \@filtros,
                                                                                    sort_by => 'timestamp',
                                                                                    limit   => 1
                                                                ); 

    if(scalar(@$reservas_array_ref) > 0){
        return ($reservas_array_ref->[0]);
    }else{
        #NO hay reservas en espera para este grupo
        return 0;
    }
}


=item
cancelar_reservas_inmediatas
Se cancelan todas las reservas del usuario que viene por parametro cuando este llega al maximo de prestamos de un tipo determinado.
=cut
sub cancelar_reservas_inmediatas{
	my ($self)=shift;
	my ($params)=@_;
	my $socio=$params->{'nro_socio'};

    $params->{'nota'} = "PRESTAMOS MÁXIMOS";

   	my $reservas_array_ref = C4::Modelo::CircReserva::Manager->get_circ_reserva(
					db=>$self->db,
					query => [ nro_socio => { eq => $socio }, estado => {ne => 'P'}, id3 => undef ]
     				);
    	
	foreach my $reserva (@$reservas_array_ref){
		$reserva->cancelar_reserva($params);
	}

}


sub cancelar_reservas{
# Este procedimiento cancela todas las reservas de los usuarios recibidos como parametro
	my ($self)=shift;
	my ($responsable,$nro_socios,$nota)= @_;
	my $params;
	
	$params->{'responsable'}= $responsable;
	$params->{'tipo'}= 'INTRA';
    $params->{'nota'} = $nota;

	foreach (@$nro_socios) {
		my $reservas_array_ref = C4::Modelo::CircReserva::Manager->get_circ_reserva( db => $self->db,
									query => [ nro_socio => { eq => $_ }, estado => {ne => 'P'}]); 

		foreach my $reserva (@$reservas_array_ref){
			$reserva->cancelar_reserva($params);
		}
	}
}


=item
cancelar_reservas_sancionados
Se cancelan todas las reservas de usuarios sancionados.
=cut
sub cancelar_reservas_sancionados {
	my ($self)=shift;
	my ($responsable)= @_;

	#Se buscan los socios sancionados
	my $dateformat = C4::Date::get_date_format();
	my $hoy=C4::Date::format_date_in_iso(Date::Manip::ParseDate("today"), $dateformat);

        $self->debug("cancelar_reservas_sancionados => HOY = ".$hoy);

	my $sanciones_array_ref = C4::Modelo::CircSancion::Manager->get_circ_sancion ( db=>$self->db, 
									query => [ 
											fecha_comienzo 	=> { le => $hoy },
											fecha_final    	=> { ge => $hoy},
										],
									select => ['nro_socio'],
									);

	my @socios_sancionados;
	foreach my $sancion (@$sanciones_array_ref){
	      $self->debug("cancelar_reservas_sancionados => Usuario Sancionado = ".$sancion->getNro_socio);
	      push (@socios_sancionados,$sancion->getNro_socio);
	}

	$self->cancelar_reservas($responsable,\@socios_sancionados,"SANCION");
}


=item
cancelar_reservas_no_regulares
Se cancelan todas las reservas de usuarios que perdieron la regularidad.
=cut
sub cancelar_reservas_no_regulares {
  my ($self)=shift;
  my ($responsable)= @_;

    my $params;
    $params->{'responsable'}= $responsable;
    $params->{'tipo'}= 'INTRA';
    $params->{'nota'} = "NO REGULAR";

    my $reservas_array_ref = C4::Modelo::CircReserva::Manager->get_circ_reserva( db => $self->db,
										    query => [ estado => {ne => 'P'}]);

    foreach my $reserva (@$reservas_array_ref){
	if(! $reserva->socio->esRegular){
	    $self->debug("cancelar_reservas_no_regulares => Usuario Irregular = ".$reserva->socio->getNro_socio." se cancela la reserva ".$reserva->getId_reserva );
	    $reserva->cancelar_reserva($params);
	  }
    }
}


#========================================================================================================================================


=item sub reasignarEjemplarASiguienteReservaEnEspera

    Esta funcion asgina el ejemplar a una reserva (SI EXISTE) que se encontraba en la cola de espera para un grupo determinado
    Esta reserva ya tenia el ejemplar asignado

    @Parametros:
        $responsable: el usuario logueado
=cut
sub reasignarEjemplarASiguienteReservaEnEspera{
    my ($self) = shift;

    my ($responsable) = @_;

    my ($reservaGrupo) = $self->getReservaEnEspera(); #retorna la primer reserva en espera SI EXISTE

    if($reservaGrupo){
        #Si hay al menos un ejemplar esperando se reasigna
        $reservaGrupo->setId3($self->getId3);
        $reservaGrupo->setId_ui($self->getId_ui);
        $reservaGrupo->actualizarDatosReservaEnEspera($responsable);
        
        $self->debug("Se loguea en historico de circulacion la asignacion");
        C4::AR::Reservas::agregarReservaAHistorial($reservaGrupo,'ASIGNACION',$responsable);
    }
}


=item sub cancelar_reservas_socio
    Este procedimiento cancela todas las reservas del usuario recibido como parametro

    @Parametros
        responsable = usuario logueado en el sistema
        nro_socio    = socio al que se le cancelan las reservas
=cut
sub cancelar_reservas_socio{
    my ($self) = shift;

    my ($params) = @_;
    $params->{'tipo'}= 'INTRA';

    my ($reservas_array_ref) = C4::Modelo::CircReserva::Manager->get_circ_reserva( 
                                                                db      => $self->db,
                                                                query   => [    nro_socio   => { eq => $params->{'nro_socio'} }, 
                                                                                estado      => { ne => 'P'} 
                                                                            ]
                                                        );

    foreach my $reserva (@$reservas_array_ref){
        $reserva->cancelar_reserva($params);
    }
}


=item
eliminarReservasVencidas
Elimina las reservas vencidas al dia de la fecha y actualiza la reservas de grupo, si es que exiten, para los item liberados.
=cut
sub cancelar_reservas_vencidas {
    my ($self) = shift;

    my ($responsable) = @_;

    #Se buscan las reservas vencidas!!!!
    my ($reservas_vencidas_array_ref) = $self->getReservasVencidas();

   $self->debug("cancelar_reservas_vencidas => cant_reservas => ".scalar(@$reservas_vencidas_array_ref));

    #Se buscan si hay reservas esperando sobre el grupo que se va a elimninar la reservas vencidas
    foreach my $reserva (@$reservas_vencidas_array_ref){
       $reserva->reasignarEjemplarASiguienteReservaEnEspera($responsable);
        #Haya o no uno esperando elimino el que existia porque la reserva se esta cancelando

        $self->debug("Se loguea en historico de circulacion la cancelacion");
        my $nota="RESERVA VENCIDA";
        C4::AR::Reservas::agregarReservaAHistorial($reserva,'CANCELACION',$responsable,"",$nota);

        $self->debug("cancelar_reservas_vencidas => SE CANCELA LA RESERVA : ". $reserva->getId_reserva);
       $reserva->delete();
    }# END foreach my $reserva (@$reservasVencidas)
}

=item
cancelar_reservas_usuarios_morosos
Se cancelan las reservas de usuarios con prestamos vencidos
=cut
sub cancelar_reservas_usuarios_morosos {
  my ($self)=shift;
  my ($responsable)= @_;

    my $params;
    $params->{'responsable'}= $responsable;
    $params->{'tipo'}= 'INTRA';

    my $socios_reservas_array_ref = C4::Modelo::CircReserva::Manager->get_circ_reserva( db => $self->db,
										 distinct => 1,
										 select   => [ 'nro_socio' ],
										 query => [ estado => {ne => 'P'}]);

    foreach my $reserva (@$socios_reservas_array_ref){
        my ($vencidos,$prestados) = C4::AR::Prestamos::cantidadDePrestamosPorUsuario($reserva->nro_socio);
		if( $vencidos ){
		    $self->debug("cancelar_reservas_usuarios_morosos => Usuario Moroso = ".$reserva->nro_socio." se cancelan sus reservas ");
		    $params->{'nro_socio'}= $reserva->nro_socio;
		    $params->{'nota'} = "MOROSO";
            $self->cancelar_reservas_socio($params);
		  }

    }
}



=item sub getReservasVencidas
    Retorna un arreglo de objetos reserva que se encuentran VENCIDAS
=cut
sub getReservasVencidas {
    my ($self) = shift;

    my $dateformat  = C4::Date::get_date_format();
    my $hoy         = C4::Date::format_date_in_iso(Date::Manip::ParseDate("today"), $dateformat);

    #Se buscan las reservas vencidas!!!!
    my ($reservas_vencidas_array_ref) = C4::Modelo::CircReserva::Manager->get_circ_reserva(
                                                                        db => $self->db,
                                                                        query => [ 
                                                                                fecha_recordatorio  => { lt => $hoy }, 
                                                                                estado              => { ne => 'P'},
                                                                                id3                 => { ne => undef}
                                                                            ]
                                                        );
    return ($reservas_vencidas_array_ref);
}

=item sub borrar_sancion_de_reserva
Borra la sancion que corresponde a esta reserva
FIXME Se borra del historial si no se llegó a efectivizar la sancion!!
=cut
sub borrar_sancion_de_reserva{
    my ($self) = shift;
    my ($db) = @_;


    $db = $db || $self->db; 

    my $dateformat  = C4::Date::get_date_format();
    my $hoy         = C4::Date::format_date_in_iso(Date::Manip::ParseDate("today"), $dateformat);
    my @filtros;
    push(@filtros, ( id_reserva     => { eq => $self->getId_reserva}));
    push(@filtros, ( fecha_comienzo => { gt => $hoy} ));

    my ($sancion_reserva_array_ref) = C4::Modelo::CircSancion::Manager->get_circ_sancion( db => $db, query => \@filtros);

    if(scalar(@$sancion_reserva_array_ref) > 0){
        #Primero eliminamos la sancion del historial
        my $sancion = $sancion_reserva_array_ref->[0];
        my @filtrosHistorial;
        push(@filtrosHistorial, ( nro_socio       => { eq => $sancion->getNro_socio()}));
        push(@filtrosHistorial, ( fecha_comienzo  => { eq => $sancion->getFecha_comienzo()}));
        push(@filtrosHistorial, ( fecha_final     => { eq => $sancion->getFecha_final()}));
        push(@filtrosHistorial, ( tipo_sancion    => { eq => $sancion->getTipo_sancion()}));
        my ($historial_sancion_array_ref) = C4::Modelo::RepHistorialSancion::Manager->get_rep_historial_sancion( db => $db, query => \@filtrosHistorial);

        if(scalar(@$historial_sancion_array_ref) > 0){
            #Se elimina del historial la sancion de la reserva
            $historial_sancion_array_ref->[0]->delete();
        }
        
        #Se elimina la sanción
        $sancion->delete();
    }
}

sub pasar_a_espera{
    my ($self) = shift;

    # Se borra la sancion correspondiente a la reserva si es que la sancion todavia no entro en vigencia
    $self->debug("Se borra la sancion de la reserva");
    $self->borrar_sancion_de_reserva();

    $self->debug("Se pasa la reserva a GRUPAL");
    $self->setEstado('G');
    $self->setId3(undef);
    $self->save();
}

=item sub intercambiarId3

    Este metodo intercambia el id3 de la reserva, por el id3 pasado por parametro
=cut
sub intercambiarId3{
    my ($self) = shift;

    my ($nuevo_Id3, $msg_object, $db) = @_;
    
    C4::AR::Debug::debug("intercambiarId3 => se va a intercambiar el id3: ".$self->getId3." por nuevo_Id3: ".$nuevo_Id3);
    my @filtros;
    push(@filtros, ( id3 => { eq => $nuevo_Id3 } ));
    my ($reserva_array_ref) = C4::Modelo::CircReserva::Manager->get_circ_reserva( db => $db, query => \@filtros);

    if (scalar(@$reserva_array_ref) > 0){ 
        #Ya existe una reserva sobre ese Id3
        if($reserva_array_ref->[0]->getEstado eq "E"){ 
        C4::AR::Debug::debug("intercambiarId3 => EXISTE reserva asginada a id3: ".$nuevo_Id3);
            #quiere decir que hay una reserva sobre el $nuevo_Id3 y NO esta prestado el item -> SE HACE EL INTERCAMBIO
            #actualizo la reserva con el viejo id3 para la reserva del otro usuario.
            $reserva_array_ref->[0]->setId3($self->getId3);
            $reserva_array_ref->[0]->save();
            #luego actualizo la actual
            $self->setId3($nuevo_Id3);
            $self->save();
            
        }elsif($reserva_array_ref->[0]->getEstado eq "P"){
            $msg_object->{'error'} = 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P107', 'params' => []} ) ;
        }
    }else{
        #el item con id3 esta libre se actualiza la reserva del usuario al que se va a prestar el item.
        $self->setId3($nuevo_Id3);
        $self->save();
    }

}

sub defaultSort{

    return ("fecha_recordatorio DESC");
}


1;

