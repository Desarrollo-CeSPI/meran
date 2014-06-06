package C4::Modelo::RepHistorialSancion;

use strict;
use Date::Manip;
use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'rep_historial_sancion',

    columns => [
        id                    => { type => 'serial', overflow => 'truncate', not_null => 1 },
        tipo_operacion        => { type => 'varchar', overflow => 'truncate', default => '', length => 50, not_null => 1 },
        nro_socio		      => { type => 'varchar', overflow => 'truncate', length => 16, not_null => 1 },
        responsable           => { type => 'varchar', overflow => 'truncate', length => 16, not_null => 1 },
        timestamp             => { type => 'timestamp', not_null => 1 },
        fecha                 => { type => 'varchar', overflow => 'truncate', default => '0000-00-00', not_null => 1 },
        fecha_comienzo        => { type => 'varchar', overflow => 'truncate' },
        fecha_final           => { type => 'varchar', overflow => 'truncate' },
        tipo_sancion          => { type => 'integer', overflow => 'truncate', default => '0' },
        dias_sancion          => { type => 'integer', overflow => 'truncate', default => '0' },
        id3                   => { type => 'integer', overflow => 'truncate' },
        motivo_sancion        => { type => 'text', overflow => 'truncate', length => 65535 },
    ],

    primary_key_columns => [ 'id' ],
    
   relationships => [
         usr_responsable => {
               class      => 'C4::Modelo::UsrSocio',
               column_map => { responsable => 'nro_socio' },
               type       => 'one to one',
         },
          usr_nro_socio => {
            class      => 'C4::Modelo::UsrSocio',
            column_map => { nro_socio => 'nro_socio' },
            type       => 'one to one',
        },
          ref_tipo_sancion  => {
             class      => 'C4::Modelo::CircTipoSancion',
             column_map => { tipo_sancion => 'tipo_sancion' },
             type       => 'one to one',
         },
        nivel3 => {
            class       => 'C4::Modelo::CatRegistroMarcN3',
            key_columns => { id3 => 'id' },
            type        => 'one to one',
        },
   ],
);


sub getId{
    my ($self) = shift;
    return ($self->id);
}

sub setId{
    my ($self) = shift;
    my ($id) = @_;
    $self->id($id);
}

sub getTipo_operacion{
    my ($self) = shift;
    return ($self->tipo_operacion);
}

sub setTipo_operacion{
    my ($self) = shift;
    my ($tipo_operacion) = @_;
    $self->tipo_operacion($tipo_operacion);
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

sub getFecha_formateada{
    my ($self) = shift;
    my $dateformat = C4::Date::get_date_format();
    return ( C4::Date::format_date($self->fecha, $dateformat) );
}

sub getTimestamp{
    #devuelve la fecha formateada del timestamp
    my ($self)      = shift;
    my $timestamp   = $self->timestamp;
    my @array_temp  = split(/T/, $timestamp);
    my $dateformat = C4::Date::get_date_format();
    return (C4::Date::format_date(@array_temp[0], $dateformat));
}

sub getFecha{
    my ($self) = shift;
    return ($self->fecha);
}


sub setFecha{
    my ($self) = shift;
    my ($fecha) = @_;
    $self->fecha($fecha);
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


sub getTipo_sancion{
    my ($self) = shift;
    return ($self->tipo_sancion);
}

sub setTipo_sancion{
    my ($self) = shift;
    my ($tipo_sancion) = @_;
    $self->tipo_sancion($tipo_sancion);
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

sub agregar {
    my ($self)=shift;
    my ($data_hash)=@_;

    my $dateformat = C4::Date::get_date_format();
    my $hoy = ParseDate("today");

	$self->setTipo_operacion($data_hash->{'tipo_operacion'});
    $self->setNro_socio($data_hash->{'nro_socio'});
    $self->setResponsable($data_hash->{'responsable'});
    $self->setFecha(C4::Date::format_date_in_iso($hoy, $dateformat));
    $self->setFecha_comienzo($data_hash->{'fecha_comienzo'});
    $self->setFecha_final($data_hash->{'fecha_final'});
    $self->setTipo_sancion($data_hash->{'tipo_sancion'});
    $self->setId3($data_hash->{'id3'} || undef);
    $self->setDias_sancion($data_hash->{'dias_sancion'}||undef);
    $self->setMotivo_sancion($data_hash->{'motivo_sancion'}||undef);

    $self->save();
}

1;
