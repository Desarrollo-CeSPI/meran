package C4::Modelo::CircSancion;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'circ_sancion',

    columns => [
        id_sancion        => { type => 'serial', overflow => 'truncate', not_null => 1 },
        tipo_sancion      => { type => 'integer', overflow => 'truncate', default => '0' },
        id_reserva        => { type => 'integer', overflow => 'truncate' },
        nro_socio         => { type => 'varchar', overflow => 'truncate', length => 16, not_null => 1 },
        fecha_comienzo    => { type => 'varchar', overflow => 'truncate', default => '0000-00-00', not_null => 1 },
        fecha_final       => { type => 'varchar', overflow => 'truncate', default => '0000-00-00', not_null => 1 },
        dias_sancion      => { type => 'integer', overflow => 'truncate', default => '0' },
        id3               => { type => 'integer', overflow => 'truncate' },
        motivo_sancion    => { type => 'text', overflow => 'truncate', length => 65535 },
    ],

    primary_key_columns => [ 'id_sancion' ],

	relationships => [
	    reserva => {
            class      => 'C4::Modelo::CircReserva',
            column_map => { id_reserva => 'id_reserva' },
            type       => 'one to one',
        },
        socio => {
            class       => 'C4::Modelo::UsrSocio',
            key_columns => { nro_socio => 'nro_socio' },
            type        => 'one to one',
        },

	    ref_tipo_sancion => {
            class      => 'C4::Modelo::CircTipoSancion',
            column_map => { tipo_sancion => 'tipo_sancion' },
            type       => 'one to one',
        },
		ref_tipo_prestamo_sancion => {
            class      => 'C4::Modelo::CircTipoPrestamoSancion',
            column_map => { tipo_sancion => 'tipo_sancion' },
            type       => 'one to many',
        },
        nivel3 => {
            class       => 'C4::Modelo::CatRegistroMarcN3',
            key_columns => { id3 => 'id' },
            type        => 'one to one',
        },
    ],
);

#Einar use Date::Manip;
use C4::Date;#formatdate
use C4::AR::Utilidades;#trim
use C4::Modelo::RepHistorialSancion;
sub getId_sancion{
    my ($self) = shift;
    return ($self->id_sancion);
}

sub setId_sancion{
    my ($self) = shift;
    my ($id_sancion) = @_;
    $self->id_sancion($id_sancion);
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

sub getTipo_sancion{
    my ($self) = shift;
    return ($self->tipo_sancion);
}

sub setTipo_sancion{
    my ($self) = shift;
    my ($tipo_sancion) = @_;
    $self->tipo_sancion($tipo_sancion);
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

sub getId_reserva{
    my ($self) = shift;
    return ($self->id_reserva);
}

sub setId_reserva{
    my ($self) = shift;
    my ($id_reserva) = @_;
    $self->id_reserva($id_reserva);
}

sub getFecha_comienzo{
    my ($self) = shift;
    return ($self->fecha_comienzo);
}

sub getFecha_comienzo_formateada {
    my ($self) = shift;
	my $dateformat = C4::Date::get_date_format();
    return C4::Date::format_date(C4::AR::Utilidades::trim($self->getFecha_comienzo),$dateformat);
}

sub setFecha_comienzo{
    my ($self) = shift;
    my ($fecha_comienzo) = @_;
    $self->fecha_comienzo($fecha_comienzo);
}

sub getFecha_final{
    my ($self) = shift;
    return ($self->fecha_final);
}

sub getFecha_final_formateada {
    my ($self) = shift;
	my $dateformat = C4::Date::get_date_format();
    return C4::Date::format_date(C4::AR::Utilidades::trim($self->getFecha_final),$dateformat);
}

sub setFecha_final{
    my ($self) = shift;
    my ($fecha_final) = @_;
    $self->fecha_final($fecha_final);
}


sub getDias_sancion{
    my ($self) = shift;
    return ($self->dias_sancion);
}

sub setDias_sancion{
    my ($self) = shift;
    my ($dias_sancion) = @_;
    $self->dias_sancion($dias_sancion);
}


sub getMotivo_sancion{
    my ($self) = shift;
    return ($self->motivo_sancion);
}

sub setMotivo_sancion{
    my ($self) = shift;
    my ($motivo_sancion) = @_;
    $self->motivo_sancion($motivo_sancion);
}


=item
agregar
Funcion que agrega una sancion
=cut

sub agregar {
    my ($self)=shift;
    my ($data_hash)=@_;
    #Asignando data...
    $self->setId3($data_hash->{'id3'}||undef);
    $self->setId_reserva($data_hash->{'id_reserva'}||undef);
    $self->setNro_socio($data_hash->{'nro_socio'});
    $self->setTipo_sancion($data_hash->{'tipo_sancion'}||undef);
    $self->setFecha_comienzo($data_hash->{'fecha_comienzo'});
    $self->setFecha_final($data_hash->{'fecha_final'});
    $self->setDias_sancion($data_hash->{'dias_sancion'}||undef);
    $self->setMotivo_sancion($data_hash->{'motivo_sancion'}||undef);
    $self->save();

}


sub insertar_sancion {
    my ($self)=shift;
	my ($data_hash)=@_;
 #Esta funcion da de alta una sancion
  	my $dateformat = C4::Date::get_date_format();
 #Hay varios casos:
 #Si no existe una tupla con una posible sancion y debe ser sancionado por $delaydays
 #Si existe se sanciona con la mayor cantidad de dias
    $self->debug("CircSancion::insertar_sancion ==> SE VA A AGREGAR UNA SANCION");
 #Busco si tiene una sancion pendiente
    my $sancion_existente=C4::AR::Sanciones::tieneSancionPendiente($data_hash->{'nro_socio'},$self->db);

	if ($sancion_existente){
	#Hay sancion pendiente
        $self->debug("CircSancion::insertar_sancion ==> YA EXISTIA UNA PENDIENTE");

		if ( $sancion_existente->getDias_sancion < $data_hash->{'dias_sancion'}) {
		#La Sancion pendiente es menor a la actual, recalculo la fecha de fin
        $self->debug("CircSancion::insertar_sancion ==> LA SANCION PENDIENTE ES MENOR A LA ACTUAL, SE REEMPLAZA");
		my $err;
		my $fecha_final_nueva= C4::Date::format_date_in_iso(C4::Date::DateCalc($data_hash->{'fecha_comienzo'},"+ ".$data_hash->{'dias_sancion'}." days",\$err),$dateformat);

		$sancion_existente->setTipo_sancion($data_hash->{'tipo_sancion'});
		$sancion_existente->setDias_sancion($data_hash->{'dias_sancion'});
		$sancion_existente->setId3($data_hash->{'id3'});
		$sancion_existente->setFecha_final($fecha_final_nueva);
		$sancion_existente->setFecha_comienzo($data_hash->{'fecha_comienzo'});
		$sancion_existente->save();
        
        #**********************************Se registra el movimiento en historicSanction***************************
        my ($historial_sancion) = C4::Modelo::RepHistorialSancion->new(db=>$self->db);
        $data_hash->{'tipo_operacion'}= 'Actualizacion y Efectivizacion Pendiente';
        $data_hash->{'fecha_final'}    = $fecha_final_nueva;
        $historial_sancion->agregar($data_hash);
        #*******************************Fin***Se registra el movimiento en historicSanction*************************
		}
        else{
        #La sancion pendiente es mayor a la actual, nos quedamos con esa, pero hay que aplicar la sancion calculando la fecha de comienzo y fin
            $self->debug("CircSancion::insertar_sancion ==> LA SANCION PENDIENTE ES MAYOR A LA ACTUAL, SE EFECTIVIZA LA QUE ESTABA");
            my $err;
            my $fecha_final_nueva= C4::Date::format_date_in_iso(C4::Date::DateCalc($data_hash->{'fecha_comienzo'},"+ ".$sancion_existente->getDias_sancion." days",\$err),$dateformat);
            $sancion_existente->setFecha_final($fecha_final_nueva);
            $sancion_existente->setFecha_comienzo($data_hash->{'fecha_comienzo'});
            $sancion_existente->save();

            #**********************************Se registra el movimiento en historicSanction***************************
            my ($historial_sancion) = C4::Modelo::RepHistorialSancion->new(db=>$self->db);
            #Se pasan los datos de la existente al historial
            $data_hash->{'tipo_sancion'}   = $sancion_existente->getTipo_sancion;
            $data_hash->{'id3'}            = $sancion_existente->getId3;
            $data_hash->{'fecha_final'}    = $fecha_final_nueva;
            $data_hash->{'dias_sancion'}   = $sancion_existente->getDias_sancion;
            $data_hash->{'tipo_operacion'}= 'Efectivizacion Pendiente';
            $historial_sancion->agregar($data_hash);
            #*******************************Fin***Se registra el movimiento en historicSanction*************************
        }
	}
	else {
	#No tiene sanciones pendientes
	$self->agregar($data_hash);

     #**********************************Se registra el movimiento en historicSanction***************************
     
     my ($historial_sancion) = C4::Modelo::RepHistorialSancion->new(db=>$self->db);
     $data_hash->{'tipo_operacion'}= 'Insercion';
     $historial_sancion->agregar($data_hash);
     #*******************************Fin***Se registra el movimiento en historicSanction*************************
	}


}


#Esta funcion da de alta una sancion pendiente 
sub insertar_sancion_pendiente {
    my ($self)=shift;
    my ($data_hash)=@_;
 #Hay varios casos:
 #Si no existe una tupla con una posible sancion se crea una
 #Si ya existe una posible sancion se deja la mayor

 #Busco si tiene una sancion pendiente
my $sancion_existente=C4::AR::Sanciones::tieneSancionPendiente($data_hash->{'nro_socio'},$self->db);

    if ($sancion_existente){
    #Hay sancion pendiente

        if ( $sancion_existente->getDias_sancion < $data_hash->{'dias_sancion'}) {
        #La Sancion pendiente es menor a la actual, hay que actualizar la cantidad de dias de sancion, sino se descarta
            $sancion_existente->setTipo_sancion($data_hash->{'tipo_sancion'});
            $sancion_existente->setDias_sancion($data_hash->{'dias_sancion'});
            $sancion_existente->setId3($data_hash->{'id3'});
            $sancion_existente->save();
            #**********************************Se registra el movimiento en historicSanction***************************
            my ($historial_sancion) = C4::Modelo::RepHistorialSancion->new(db=>$self->db);
            $data_hash->{'tipo_operacion'}= 'Actualizacion Pendiente';
            $historial_sancion->agregar($data_hash);
            #*******************************Fin***Se registra el movimiento en historicSanction*************************
            }
    }else { #No tiene sanciones pendientes
            $self->agregar($data_hash);
            #**********************************Se registra el movimiento en historicSanction***************************
            my ($historial_sancion) = C4::Modelo::RepHistorialSancion->new(db=>$self->db);
            $data_hash->{'tipo_operacion'}= 'Insercion Pendiente';
            $historial_sancion->agregar($data_hash);
            #*******************************Fin***Se registra el movimiento en historicSanction*************************
        }
}


sub actualizar_sancion {
    my ($self)=shift;
	my ($params)=@_;
	
	$self->setId3($params->{'id3'});
	$self->save();

#**********************************Se registra el movimiento en historicSanction***************************
   my ($historial_sancion) = C4::Modelo::RepHistorialSancion->new(db=>$self->db);
   $params->{'tipo_operacion'}= 'Actualizacion';
   $historial_sancion->agregar($params);
#*******************************Fin***Se registra el movimiento en historicSanction*************************
}

sub eliminar_sancion {
    my ($self)=shift;
    my ($responsable)=@_;


#**********************************Se registra el movimiento en historicSanction***************************
    my $data_hash;
    $data_hash->{'nro_socio'}       = $self->getNro_socio;
    $data_hash->{'responsable'}     = $responsable;
    $data_hash->{'fecha_final'}     = $self->getFecha_final;
    $data_hash->{'fecha_comienzo'}  = $self->getFecha_comienzo;
    $data_hash->{'tipo_sancion'}    = $self->getTipo_sancion;
    $data_hash->{'dias_sancion'}    = $self->getDias_sancion;
    $data_hash->{'id3'}             = $self->getId3;

    my ($historial_sancion)         = C4::Modelo::RepHistorialSancion->new(db=>$self->db);

    $data_hash->{'tipo_operacion'}  = 'Borrado';
    $historial_sancion->agregar($data_hash);
#*******************************Fin***Se registra el movimiento en historicSanction*************************


    $self->delete();
}

1;

