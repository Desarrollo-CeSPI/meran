package C4::Modelo::UsrPersona;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'usr_persona',

    columns => [
        id_persona       => { type => 'serial', overflow => 'truncate', not_null => 1 },
        legajo           => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1 },
        version_documento=> { type => 'character', overflow => 'truncate', default => 'P', length => 1, not_null => 1 },
        nro_documento    => { type => 'varchar', overflow => 'truncate', length => 16, not_null => 1 },
        tipo_documento   => { type => 'integer', overflow => 'truncate', length => 11, not_null => 1 },
        apellido         => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1 },
        nombre           => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1 },
        titulo           => { type => 'varchar', overflow => 'truncate', length => 255 },
        otros_nombres    => { type => 'varchar', overflow => 'truncate', length => 255 },
        iniciales        => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1 },
        calle            => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1 },
        barrio           => { type => 'varchar', overflow => 'truncate', length => 255 },
        ciudad           => { type => 'integer', overflow => 'truncate', length => 11, not_null => 1, default => 1 },
        telefono         => { type => 'varchar', overflow => 'truncate', length => 255 },
        email            => { type => 'varchar', overflow => 'truncate', length => 255 },
        fax              => { type => 'varchar', overflow => 'truncate', length => 255 },
        msg_texto        => { type => 'varchar', overflow => 'truncate', length => 255 },
        alt_calle        => { type => 'varchar', overflow => 'truncate', length => 255 },
        alt_barrio       => { type => 'varchar', overflow => 'truncate', length => 255 },
        alt_ciudad       => { type => 'integer', overflow => 'truncate', length => 11, not_null => 0 },
        alt_telefono     => { type => 'varchar', overflow => 'truncate', length => 255 },
        nacimiento       => { type => 'varchar', overflow => 'truncate', length => 255},
        codigo_postal    => { type => 'varchar', overflow => 'truncate', length => 32},
        fecha_alta       => { type => 'varchar', overflow => 'truncate', length => 255},
        sexo             => { type => 'character', overflow => 'truncate', length => 1 },
        telefono_laboral => { type => 'varchar', overflow => 'truncate', length => 50 },
        es_socio         => { type => 'integer', overflow => 'truncate', length => 1, default => 0 },
        institucion      => { type => 'varchar', overflow => 'truncate', length => 255 },
        carrera          => { type => 'varchar', overflow => 'truncate', length => 255 },
        anio             => { type => 'varchar', overflow => 'truncate', length => 255 },
        division         => { type => 'varchar', overflow => 'truncate', length => 255 },
        foto             => { type => 'varchar', overflow => 'truncate', length => 255 },
    ],

     relationships =>
    [
      ciudad_ref => 
      {
        class       => 'C4::Modelo::RefLocalidad',
        key_columns => { ciudad => 'id' },
        type        => 'one to one',
      },
      alt_ciudad_ref => 
      {
        class       => 'C4::Modelo::RefLocalidad',
        key_columns => { alt_ciudad => 'id' },
        type        => 'one to one',
      },
     documento => 
      {
        class       => 'C4::Modelo::UsrRefTipoDocumento',
        key_columns => { tipo_documento => 'id' },
        type        => 'one to one',
      },
      
    ],
    
    primary_key_columns => [ 'id_persona' ],
    unique_key => ['tipo_documento','nro_documento'],
);

use utf8;
use C4::Modelo::UsrPersona;
use C4::Modelo::UsrEstado;
use C4::Modelo::UsrRegularidad::Manager;


=item
    Returns true (1) if the row was loaded successfully
    undef if the row could not be loaded due to an error, 
    zero (0) if the row does not exist.
=cut
sub load{
    my $self = $_[0]; # Copy, not shift
    

    my $error = 1;

    eval {
    
         unless( $self->SUPER::load(speculative => 1) ){
                 C4::AR::Debug::debug("UsrPersona=>  dentro del unless, no existe el objeto SUPER load");
                $error = 0;
         }

        C4::AR::Debug::debug("UsrPersona=>  SUPER load");
        return $self->SUPER::load(@_);
    };

    if($@){
        C4::AR::Debug::debug("UsrPersona=>  no existe el objeto");
        $error = undef;
    }

    return $error;
}

sub agregar{
    my ($self)=shift;
    my ($data_hash)=@_;
    #Asignando data...
    $self->setLegajo($data_hash->{'legajo'});
    $self->setNombre(C4::AR::Utilidades::capitalizarString($data_hash->{'nombre'}));
    $self->setApellido(C4::AR::Utilidades::capitalizarString($data_hash->{'apellido'}));
    $self->setVersion_documento($data_hash->{'version_documento'});
    $self->setNro_documento($data_hash->{'nro_documento'});
    $self->setTipo_documento($data_hash->{'tipo_documento'});
    $self->setTitulo($data_hash->{'titulo'});
    $self->setOtros_nombres($data_hash->{'otros_nombres'});
    $self->setIniciales($data_hash->{'iniciales'});
    $self->setCalle($data_hash->{'calle'});
    $self->setBarrio($data_hash->{'barrio'});
    $self->setCiudad($data_hash->{'ciudad'});
    $self->setTelefono($data_hash->{'telefono'});
    $self->setEmail($data_hash->{'email'});
    $self->setFax($data_hash->{'fax'});
    $self->setMsg_texto($data_hash->{'msg_texto'});
    $self->setAlt_calle($data_hash->{'alt_calle'});
    $self->setAlt_barrio($data_hash->{'alt_barrio'});
    $self->setAlt_ciudad($data_hash->{'alt_ciudad'});
    $self->setCodigoPostal($data_hash->{'codigo_postal'});
    $self->setAlt_telefono($data_hash->{'alt_telefono'});
    $self->setNacimiento($data_hash->{'nacimiento'});
    $self->setFecha_alta($data_hash->{'fecha_alta'});
    $self->setSexo($data_hash->{'sexo'});
    $self->setTelefono_laboral($data_hash->{'telefono_laboral'});
    $self->setEs_socio(0);
    $data_hash->{'id_persona'}=$self->getId_persona;
    $data_hash->{'categoria_socio_id'}=$data_hash->{'categoria_socio_id'};
    $self->setInstitucion($data_hash->{'institucion'});
    $self->setCarrera($data_hash->{'carrera'});
    $self->setAnio($data_hash->{'anio'});
    $self->setDivision($data_hash->{'division'});
    $self->setFoto($self->buildFotoNameHash());
    $self->save();
    return $self->convertirEnSocio($data_hash);

}

sub convertirEnSocio{
    my ($self)=shift;
    my ($data_hash,$vienePassword)=@_;

    $self->log($data_hash,'convertirEnSocio');

#    $self->forget();

    my $db = $self->db;
    my $socio = C4::Modelo::UsrSocio->new(db => $db);
        $data_hash->{'id_persona'} = $self->getId_persona;

        $socio->agregar($data_hash);
        $socio->setId_estado(($data_hash->{'id_estado'}));
        $socio->setThemeINTRA($data_hash->{'tema'} || 'default');
    return $socio;
}

sub modificar{
    my ($self)=shift;
    my ($data_hash)=@_;
    #Asignando data...
    $self->setNombre($data_hash->{'nombre'});
    $self->setApellido($data_hash->{'apellido'});
    $self->setLegajo($data_hash->{'legajo'});
    $self->setVersion_documento($data_hash->{'version_documento'});
    $self->setNro_documento($data_hash->{'nro_documento'});
    $self->setTipo_documento($data_hash->{'tipo_documento'});
    $self->setTitulo($data_hash->{'titulo'});
    $self->setOtros_nombres($data_hash->{'otros_nombres'});
    $self->setIniciales($data_hash->{'iniciales'});
    $self->setCalle($data_hash->{'calle'});
    $self->setBarrio($data_hash->{'barrio'});
    $self->setCiudad($data_hash->{'ciudad'});
    $self->setTelefono($data_hash->{'telefono'});
    $self->setEmail($data_hash->{'email'});
    $self->setFax($data_hash->{'fax'});
    $self->setMsg_texto($data_hash->{'msg_texto'});
    $self->setAlt_calle($data_hash->{'alt_calle'});
    $self->setAlt_barrio($data_hash->{'alt_barrio'});
    $self->setAlt_ciudad($data_hash->{'alt_ciudad'});
    $self->setAlt_telefono($data_hash->{'alt_telefono'});
    $self->setNacimiento($data_hash->{'nacimiento'});
    $self->setCodigoPostal($data_hash->{'codigo_postal'});
    $self->setFecha_alta($data_hash->{'fecha_alta'});
    $self->setSexo($data_hash->{'sexo'});
    $self->setTelefono_laboral($data_hash->{'telefono_laboral'});
    $self->setInstitucion($data_hash->{'institucion'});
    $self->setCarrera($data_hash->{'carrera'});
    $self->setAnio($data_hash->{'anio'});
    $self->setDivision($data_hash->{'division'});

    $self->save();
}

sub modificarDatosDeOPAC{
    my ($self)=shift;
    my ($data_hash)=@_;

    #Asignando data...
    $data_hash = C4::AR::Utilidades::escapeHashData($data_hash);
    
    $self->setNombre($data_hash->{'nombre'});
    $self->setApellido($data_hash->{'apellido'});
    $self->setCalle($data_hash->{'direccion'});
    $self->setCiudad($data_hash->{'id_ciudad'});
    $self->setTelefono($data_hash->{'numero_telefono'});
    $self->setEmail($data_hash->{'email'});
    
    $self->save();
}

sub modificarVisibilidadOPAC{
    my ($self)=shift;
    my ($data_hash)=@_;

    #Asignando data...
    $data_hash = C4::AR::Utilidades::escapeHashData($data_hash);

    $self->setNombre($data_hash->{'nombre'});
    $self->setApellido($data_hash->{'apellido'});
    $self->setCalle($data_hash->{'direccion'});
    $self->setCiudad($data_hash->{'id_ciudad'});
    $self->setTelefono($data_hash->{'numero_telefono'});
    $self->setEmail($data_hash->{'email'});

    $self->save();
}

sub sortByString{
    my ($self) = shift;
    my ($campo) = @_;

    my $fieldsString = &C4::AR::Utilidades::joinArrayOfString($self->meta->columns);
    my $index = rindex $fieldsString,$campo;

    if ($index != -1){
        return ("persona.".$campo);
    } else {
        return ("persona.apellido");
    }
}

sub activar{
    my ($self) = shift;

    $self->setEs_socio(1);
    $self->save();
}

sub desactivar{
    my ($self) = shift;
    $self->setEs_socio(0);
    $self->save();
}

sub getLegajo{
    my ($self) = shift;
    return ($self->legajo);
}

sub setLegajo{
    my ($self) = shift;
    my ($legajo) = @_;
    $self->legajo($legajo);
}

sub getInstitucion{
    my ($self) = shift;
    return ($self->institucion);
}

sub setInstitucion{
    my ($self) = shift;
    my ($institucion) = @_;
    $self->institucion($institucion);
}

sub getCarrera{
    my ($self) = shift;
    return ($self->carrera);
}

sub setCarrera{
    my ($self) = shift;
    my ($carrera) = @_;
    $self->carrera($carrera);
}

sub getAnio{
    my ($self) = shift;
    return ($self->anio);
}

sub setAnio{
    my ($self) = shift;
    my ($anio) = @_;
    $self->anio($anio);
}

sub getDivision{
    my ($self) = shift;
    return ($self->division);
}

sub setDivision{
    my ($self) = shift;
    my ($division) = @_;
    $self->division($division);
}

sub getId_persona{
    my ($self) = shift;
    return ($self->id_persona);
}

sub setId_persona{
    my ($self) = shift;
    my ($id_persona) = @_;
    $self->id_persona($id_persona);
}

sub buildFotoNameHash{
    my ($self) = shift;
    use Digest::SHA;
    my $hash;
    
    $hash = Digest::SHA::sha1_hex($self->getId_persona.$self->getNro_documento.$self->getApellido.$self->getNombre);
    
    return $hash;
}

sub setFoto{
    my ($self) = shift;
    my ($foto) = @_;
    $self->foto($foto);
    $self->save();
}

sub getFoto{
    my ($self) = shift;
    return($self->foto);
}

sub setEs_socio{
    my ($self) = shift;
    my ($status) = @_;
    $self->es_socio($status);
}

sub getEs_socio{
    my ($self) = shift;
    return($self->es_socio);
}

sub getVersion_documento{
    my ($self) = shift;
    return ($self->version_documento);
}

sub setVersion_documento{
    my ($self) = shift;
    my ($version_documento) = @_;
    $self->version_documento($version_documento);
}


sub getNro_documento{
    my ($self) = shift;
    return ($self->nro_documento);
}

sub setNro_documento{
    my ($self) = shift;
    my ($nro_documento) = @_;
    $self->nro_documento($nro_documento);
}

sub getTipo_documento{
    my ($self) = shift;
    return ($self->tipo_documento);
}

sub setTipo_documento{
    my ($self) = shift;
    my ($tipo_documento) = @_;
    $self->tipo_documento($tipo_documento);
}

sub getApellido{
    my ($self) = shift;
    return ($self->apellido);
}

sub setApellido{
    my ($self) = shift;
    my ($apellido) = @_;
    Encode::encode_utf8($apellido);
    $self->apellido(C4::AR::Utilidades::capitalizarString($apellido));
}

sub getNombre{
    my ($self) = shift;
    return ($self->nombre);
}

sub setNombre{
    my ($self) = shift;
    my ($nombre) = @_;
    Encode::encode_utf8($nombre);
    $self->nombre(C4::AR::Utilidades::capitalizarString($nombre));
}

sub getApeYNom{
    my ($self) = shift;

    return ($self->getApellido.", ".$self->getNombre);
}

sub getTitulo{
    my ($self) = shift;
    return ($self->titulo);
}

sub setTitulo{
    my ($self) = shift;
    my ($titulo) = @_;
    Encode::encode_utf8($titulo);
    $self->titulo($titulo);
}


sub getOtros_nombres{
    my ($self) = shift;
    return ($self->otros_nombres);
}

sub setOtros_nombres{
    my ($self) = shift;
    my ($otros_nombres) = @_;
    Encode::encode_utf8($otros_nombres);
    $self->otros_nombres($otros_nombres);
}

sub getIniciales{
    my ($self) = shift;
    return ($self->iniciales);
}

sub setIniciales{
    my ($self) = shift;
    my ($iniciales) = @_;
    $self->iniciales($iniciales);
}

sub getCodigoPostal{
    my ($self) = shift;
    return ($self->codigo_postal);
}

sub setCodigoPostal{
    my ($self) = shift;
    my ($cp) = @_;
    $self->codigo_postal($cp);
}

sub getCalle{
    my ($self) = shift;
    return ($self->calle);
}

sub setCalle{
    my ($self) = shift;
    my ($calle) = @_;
    Encode::encode_utf8($calle);
    $self->calle($calle);
}

sub getBarrio{
    my ($self) = shift;
    return ($self->barrio);
}

sub setBarrio{
    my ($self) = shift;
    my ($barrio) = @_;
    $self->barrio($barrio);
}

sub getCiudad{
    my ($self) = shift;
    
    eval {
		$self->ciudad_ref;
        };
        
    if($@){
        C4::AR::Debug::debug("UsrPersona => getCiudad => no existe la ciudad, se setea la ciudad por defecto, gracias Guarani");
         $self->setCiudad( C4::AR::Preferencias::getValorPreferencia("defaultCiudad"));
		$self->save();
    }
   
    return ($self->ciudad);
}

sub setCiudad{
    my ($self) = shift;
    my ($ciudad) = @_;
    $self->ciudad($ciudad);
}

sub getTelefono{
    my ($self) = shift;
    return ($self->telefono);
}

sub setTelefono{
    my ($self) = shift;
    my ($telefono) = @_;
    $self->telefono($telefono);
}

sub getEmail{
    my ($self) = shift;
    return ($self->email);
}

sub setEmail{
    my ($self) = shift;
    my ($email) = @_;
    $self->email($email);
}

sub getFax{
    my ($self) = shift;
    return ($self->fax);
}

sub setFax{
    my ($self) = shift;
    my ($fax) = @_;
    $self->fax($fax);
}

sub getMsg_texto{
    my ($self) = shift;
    return ($self->msg_texto);
}

sub setMsg_texto{
    my ($self) = shift;
    my ($msg_texto) = @_;
    Encode::encode_utf8($msg_texto);
    $self->msg_texto($msg_texto);
}

sub getAlt_calle{
    my ($self) = shift;
    return ($self->alt_calle);
}

sub setAlt_calle{
    my ($self) = shift;
    my ($alt_calle) = @_;
    $self->alt_calle($alt_calle);
}

sub getAlt_barrio{
    my ($self) = shift;
    return ($self->alt_barrio);
}

sub setAlt_barrio{
    my ($self) = shift;
    my ($alt_barrio) = @_;
    $self->alt_barrio($alt_barrio);
}

sub getAlt_ciudad{
    my ($self) = shift;   
    return ($self->alt_ciudad);
}

sub setAlt_ciudad{
    my ($self) = shift;
    my ($alt_ciudad) = @_;
    $self->alt_ciudad($alt_ciudad);
}

sub getAlt_telefono{
    my ($self) = shift;
    return ($self->alt_telefono);
}

sub setAlt_telefono{
    my ($self) = shift;
    my ($alt_telefono) = @_;
    $self->alt_telefono($alt_telefono);
}

sub getNacimiento{
    my ($self) = shift;
    my $dateformat = C4::Date::get_date_format();

    return ( C4::Date::format_date($self->nacimiento, $dateformat) );
}

sub setNacimiento{
    my ($self) = shift;
    my ($nacimiento)    = @_;

    $nacimiento         = C4::AR::Validator::toValidDate($nacimiento);
    my $dateformat      = C4::Date::get_date_format();
    $nacimiento         = C4::Date::format_date_in_iso($nacimiento, $dateformat);

    $self->nacimiento($nacimiento);
}

sub getFecha_alta{
    my ($self) = shift;
    my $dateformat = C4::Date::get_date_format();

    return ( C4::Date::format_date($self->fecha_alta, $dateformat) );
}

sub setFecha_alta{
    my ($self) = shift;
    my ($fecha_alta) = @_;
    $self->fecha_alta($fecha_alta);
}

sub getSexo{
    my ($self) = shift;
    return ($self->sexo);
}

sub getSexoPrint{
    my ($self) = shift;
    my %hash_sexo;
    $hash_sexo{'M'} = "Masculino";
    $hash_sexo{'F'} = "Femenino";
    return ($hash_sexo{uc($self->sexo)});
}


sub setSexo{
    my ($self) = shift;
    my ($sexo) = @_;
    $self->sexo($sexo);
}

sub getTelefono_laboral{
    my ($self) = shift;
    return ($self->telefono_laboral);
}

sub setTelefono_laboral{
    my ($self) = shift;
    my ($telefono_laboral) = @_;
    $self->telefono_laboral($telefono_laboral);
}


sub getInvolvedCount{
 
    my ($self) = shift;
    my ($campo, $value)= @_;
    my @filtros;

    push (@filtros, ( $campo->getCampo_referente => $value ) );

    my $count = C4::Modelo::UsrPersona::Manager->get_usr_persona_count( query => \@filtros );

    return ($count);
}

sub replaceBy{
 
    my ($self) = shift;

    my ($campo,$value,$new_value)= @_;
    
    my @filtros;

    push (  @filtros, ( $campo => { eq => $value},) );


    my $replaced = C4::Modelo::UsrPersona::Manager->update_usr_persona(     where => \@filtros,
                                                                        set   => { $campo => $new_value });
}

1;

