package C4::Modelo::RepHistorialCirculacion;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'rep_historial_circulacion',

    columns => [
        id              => { type => 'serial', overflow => 'truncate', not_null => 1 },
        id1             => { type => 'integer', overflow => 'truncate', not_null => 1 },
        id2             => { type => 'integer', overflow => 'truncate', not_null => 1 },
        id3             => { type => 'integer', overflow => 'truncate', not_null => 1 },
        tipo_operacion  => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1 },
        nro_socio       => { type => 'varchar', overflow => 'truncate', length => 16, default => '0', not_null => 1 },
        responsable     => { type => 'varchar', overflow => 'truncate', length => 16, not_null => 1 },
        id_ui	        => { type => 'varchar', overflow => 'truncate', length => 4 },
        timestamp       => { type => 'timestamp', not_null => 1 },
        fecha           => { type => 'varchar', overflow => 'truncate', not_null => 1 },
        nota            => { type => 'varchar', overflow => 'truncate', length => 255 },
        fecha_fin       => { type => 'varchar', overflow => 'truncate' },
        tipo_prestamo   => { type => 'character', overflow => 'truncate', length => 2 },
        #para campos COUNT y SUM
        agregacion_temp => { type => 'varchar', overflow => 'truncate', length => 255 },
    ],

    relationships =>
    [
      nivel1 =>
      {
#         class       => 'C4::Modelo::CatNivel1',
        class       => 'C4::Modelo::CatRegistroMarcN1',
        key_columns => { id1 => 'id' },
        type        => 'one to one',
      },

      nivel2 =>
      {
#         class       => 'C4::Modelo::CatNivel2',
        class       => 'C4::Modelo::CatRegistroMarcN2',
        key_columns => { id2 => 'id' },
        type        => 'one to one',
      },

      nivel3 =>
      {
#         class       => 'C4::Modelo::CatNivel3',
        class       => 'C4::Modelo::CatRegistroMarcN3',
        key_columns => { id3 => 'id' },
        type        => 'one to one',
      },

     socio =>
      {
        class       => 'C4::Modelo::UsrSocio',
        key_columns => { nro_socio => 'nro_socio' },
        type        => 'one to one',
      },

     responsable_ref =>
      {
        class       => 'C4::Modelo::UsrSocio',
        key_columns => { responsable => 'nro_socio' },
        type        => 'one to one',
      },

     tipo_prestamo_ref =>
      {
        class       => 'C4::Modelo::CircRefTipoPrestamo',
        key_columns => { tipo_prestamo => 'id_tipo_prestamo' },
        type        => 'one to one',
      },

    ],

    primary_key_columns => [ 'id' ],
);

use Date::Manip;

sub getId{
    my ($self) = shift;
    return ($self->id);
}

sub setId{
    my ($self) = shift;
    my ($id) = @_;
    $self->id($id);
}

sub getId1{
    my ($self) = shift;
    return ($self->id1);
}

sub setId1{
    my ($self) = shift;
    my ($id1) = @_;
    $self->id1($id1);
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

sub getId3{
    my ($self) = shift;
    return ($self->id3);
}

sub setId3{
    my ($self) = shift;
    my ($id3) = @_;
    $self->id3($id3);
}

sub getTipo_operacion{
    my ($self) = shift;
    return ($self->tipo_operacion);
}

sub setTipo_operacion{
    my ($self) = shift;
    my ($tipo) = @_;
    $self->tipo_operacion($tipo);
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

sub getResponsable{
    my ($self) = shift;
    return ($self->responsable);
}

sub setResponsable{
    my ($self) = shift;
    my ($responsable) = @_;
    $self->responsable($responsable);
}

sub getFecha{
    my ($self) = shift;
    return ($self->fecha);
}

sub getFecha_formateada{
    my ($self) = shift;
    my $dateformat = C4::Date::get_date_format();
    return C4::Date::format_date(C4::AR::Utilidades::trim($self->getFecha),$dateformat);
}


sub setFecha{
    my ($self) = shift;
    my ($fecha) = @_;
    $self->fecha($fecha);
}

sub getFecha_fin{
    my ($self) = shift;
    return ($self->fecha_fin);
}

sub getFecha_fin_formateada{
    my ($self) = shift;
    my $dateformat = C4::Date::get_date_format();
    return C4::Date::format_date(C4::AR::Utilidades::trim($self->getFecha_fin),$dateformat);
}

sub setFecha_fin{
    my ($self) = shift;
    my ($fecha_fin) = @_;
    $self->fecha_fin($fecha_fin);
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

sub getNota{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->nota));
}

sub setNota{
    my ($self) = shift;
    my ($nota) = @_;
    $self->nota(C4::AR::Utilidades::trim($nota));
}

sub getTipo_prestamo{
    my ($self) = shift;
    return ($self->tipo_prestamo);
}

sub setTipo_prestamo{
    my ($self) = shift;
    my ($tipo_prestamo) = @_;
    $self->tipo_prestamo($tipo_prestamo);
}


sub getTimestamp{
    my ($self) = shift;
    return ($self->timestamp);
}


sub agregar {
    my ($self)=shift;
    my ($data_hash)=@_;

    #Si viene el tipo se usa, sino depende del tipo de reserva
    if ($data_hash->{'tipo'}){
	   $self->setTipo_operacion($data_hash->{'tipo'});
  	}
	else{
    	if($data_hash->{'estado'} eq 'E'){
		#es una reserva sobre el ITEM
            $self->setTipo_operacion('RESERVA');
		}else{
		#es una reserva sobre el GRUPO
		  $self->setTipo_operacion('ESPERA');
		  $data_hash->{'id3'}= 0;
		}
   	}

    $self->setId1($data_hash->{'id1'});
    $self->setId2($data_hash->{'id2'});
    $self->setId3($data_hash->{'id3'});
    $self->setNro_socio($data_hash->{'nro_socio'});

    C4::AR::Debug::debug("responsable desde rep_historial_circulacion***************************: ".$data_hash->{'responsable'});
    $self->setResponsable($data_hash->{'responsable'});

    my $hoy = ParseDate("today");
    my $dateformat = C4::Date::get_date_format();
    my $fecha = $data_hash->{'fecha_devolucion'} || C4::Date::format_date_in_iso($hoy, $dateformat);
    $self->setFecha($fecha);

    $self->setFecha_fin($data_hash->{'hasta'});
    $self->setTipo_prestamo($data_hash->{'tipo_prestamo'});
    $self->setId_ui($data_hash->{'id_ui'});
    $self->setNota($data_hash->{'nota'});

    $self->save();
}
1;
