package C4::Modelo::UsrSocio;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'usr_socio',

    columns => [
        id_persona                       => { type => 'integer', overflow => 'truncate', not_null => 1 , length => 11},
        id_socio                         => { type => 'serial', overflow => 'truncate', not_null => 1 , length => 11},
        nro_socio                        => { type => 'varchar', overflow => 'truncate', length => 16, not_null => 1 },
        id_ui                            => { type => 'varchar', overflow => 'truncate', length => 4, not_null => 1 },
        fecha_alta                       => { type => 'varchar' },
        expira                           => { type => 'date' },
        flags                            => { type => 'integer', overflow => 'truncate' },
        password                         => { type => 'varchar', overflow => 'truncate', length => 255 },
        last_login                       => { type => 'timestamp' },
        last_login_all                   => { type => 'timestamp' },
        last_change_password             => { type => 'date' },
        change_password                  => { type => 'integer', overflow => 'truncate', default => '0', not_null => 1 },
        cumple_requisito                 => { type => 'varchar', overflow => 'truncate', length=>32, not_null => 1, default => '0'},
        id_estado                        => { type => 'integer', overflow => 'truncate', not_null => 1,  default => 20 },
        activo                           => { type => 'integer', overflow => 'truncate', default => 0, not_null => 1 },
        agregacion_temp                  => { type => 'varchar', overflow => 'truncate', length => 255 },
        note                             => { type => 'text', not_null => 1 },
        nombre_apellido_autorizado       => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 0 },
        dni_autorizado                   => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 0 },
        telefono_autorizado              => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 0 },
        is_super_user                    => { type => 'integer', overflow => 'truncate', default => 0, not_null => 1 },
        credential_type                  => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1, default => 'estudiante' },
        theme                            => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 0 },
        theme_intra                      => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 0 },
        locale                           => { type => 'varchar', overflow => 'truncate', length => 32 },
        lastValidation                   => { type => 'timestamp'  },
        recover_password_hash            => { type => 'varchar', overflow => 'truncate', length => 255 },
        remindFlag                       => { type => 'integer', overflow => 'truncate', default => '1', length => 1 },
        #PARA ESTOS CAMPOS, NO HAY GETTER/SETTER
        client_ip_recover_pwd            => { type => 'varchar', overflow => 'truncate', length => 255 },
        recover_date_of                  => { type => 'timestamp'  },
        last_auth_method                 => { type => 'varchar', overflow => 'truncate', default => 'mysql', length => 255 },
        id_categoria                     => { type => 'integer', overflow => 'truncate', length =>2, not_null => 1, default => 8 },       
        foto                             => { type => 'varchar', overflow => 'truncate', length => 255 },
        es_admin                         => { type => 'integer', overflow => 'truncate', length =>1, not_null => 0, default => 0 },       
        
    ],

     relationships =>
    [
      persona => 
      {
        class       => 'C4::Modelo::UsrPersona',
        key_columns => { id_persona => 'id_persona' },
        type        => 'one to one',
      },

      ui => 
      {
        class       => 'C4::Modelo::PrefUnidadInformacion',
        key_columns => { id_ui => 'id_ui' },
        type        => 'one to one',
      },

     categoria => 
      {
        class       => 'C4::Modelo::UsrRefCategoriaSocio',
        key_columns => { id_categoria => 'id' },
        type        => 'one to one',
      },

     estado => 
      {
        class       => 'C4::Modelo::UsrEstado',
        key_columns => { id_estado => 'id_estado' },
        type        => 'one to one',
      },

    ],

    primary_key_columns => [ 'id_socio' ],

    unique_key => [ 'nro_socio' ],
);

use utf8;
use C4::AR::Permisos;
use C4::AR::Utilidades;
use C4::Modelo::UsrPersona;
use C4::Modelo::UsrPersona::Manager;
use Switch;
use C4::Date;


sub buildFotoNameHash{
    my ($self) = shift;
    use Digest::SHA;
    my $hash;
    
    $hash = Digest::SHA::sha1_hex($self->getId_persona.$self->getNro_socio.$self->getId_ui.$self->getId_socio);
    
    return $hash;
}

sub setFoto{
    my ($self) = shift;
    my ($foto) = @_;
    $self->foto($foto);
}

sub getFoto{
    my ($self) = shift;
    return($self->foto);
}


sub setCredentialType{
    my ($self)=shift;
    my ($credential_type)=@_;
    $credential_type = $credential_type || 'estudiante';
    $self->credential_type($credential_type);
    $self->activar();
    $self->save();
}

sub getCredentialType{
    my ($self)=shift;

    return($self->credential_type || C4::AR::Filtros::i18n("Indefinido"));
}

sub getLastAuthMethod{
	my ($self) = shift;
	
	return ($self->last_auth_method);
}

sub setLastAuthMethod{
	my ($self) = shift;
	my ($method) = shift;
	
	$self->last_auth_method($method);
	
	$self->save();
}

sub getRemindFlag{
	my ($self) = shift;
	
	return ($self->remindFlag);
}

sub setRemindFlag{
	my ($self) = shift;
	my ($remindFlag) = shift;
	
	$self->remindFlag($remindFlag);
}

sub agregar{

    my ($self)=shift;
    my ($data_hash)=@_;

    $self->setId_persona($data_hash->{'id_persona'});
    if ($data_hash->{'auto_nro_socio'}){
        if (C4::AR::Preferencias::getValorPreferencia("auto-nro_socio_from_dni")){
            $self->setNro_socio( $self->setNro_socio($self->persona->getNro_documento) );
        }else{
             $self->setNro_socio( $self->nextNro_socio )
        }
    }else{
        $self->setNro_socio($data_hash->{'nro_socio'});
    }

    $self->setId_ui($data_hash->{'id_ui'});

    my $dateformat = C4::Date::get_date_format();
    my $fecha_alta = $data_hash->{'fecha_alta'} || C4::Date::format_date_in_iso(C4::AR::Utilidades::getToday(),$dateformat);
    $self->setFecha_alta($fecha_alta);

    $self->setExpira($data_hash->{'expira'});
    $self->setFlags($data_hash->{'flags'});
    
    $self->setPassword(C4::AR::Auth::hashear_password(C4::AR::Auth::hashear_password($self->persona->getNro_documento, 'MD5_B64'), 'SHA_256_B64'));

    if ($data_hash->{'changepassword'} eq '1'){
        $self->forzarCambioDePassword(1);
    }
    
    my $today = Date::Manip::ParseDate("today");
    my $cumple_requisito = $data_hash->{'cumple_requisito'};

    if ($cumple_requisito){
        $self->setCumple_requisito($today);
    }else{
    	$self->setCumple_requisito("0000000000:00:00");
    }

    if (C4::AR::Preferencias::getValorPreferencia("autoActivarPersona")){
        C4::AR::Debug::debug("Desde UsrSocio->agregar(), se tiene autoActivarPersona en 1, ojimetro");
        $self->activar();
    }

    $self->save();
    $self->setId_categoria(($data_hash->{'cod_categoria'}));
    $self->setFoto($self->buildFotoNameHash());
    $self->save();
    $self->setCredentials($data_hash->{'credential_type'});

}

sub agregarAutorizado{

    my ($self)=shift;
    my ($params) = @_;

    $self->setNombre_apellido_autorizado($params->{'auth_nombre'});
    $self->setDni_autorizado($params->{'auth_dni'});
    $self->setTelefono_autorizado($params->{'auth_telefono'});

    $self->save();
}

sub desautorizarTercero{
    my ($self) = shift;

    my ($params) = @_;

    $self->nombre_apellido_autorizado('');
    $self->dni_autorizado('');
    $self->telefono_autorizado('');

    $self->save();
}


sub getId_estado{
    my ($self) = shift;
    return ($self->id_estado);
}

sub setId_estado{
    my ($self) = shift;
    my ($id_estado) = @_;
    $self->id_estado($id_estado);
}


sub tieneAutorizado{

    my ($self)=shift;

    return (
            C4::AR::Utilidades::validateString($self->getNombre_apellido_autorizado)
                            &&
            C4::AR::Utilidades::validateString($self->getDni_autorizado)
                            && 
            C4::AR::Utilidades::validateString($self->getTelefono_autorizado)
            );
}

sub nextNro_socio{

     my ($self)=shift;

     my $nro_socio = C4::Modelo::UsrSocio::Manager->get_usr_socio(
                                query => [ nro_socio => { regexp => '^(-|\\+){0,1}([0-9]+\\.[0-9]*|[0-9]*\\.[0-9]+|[0-9]+)$' },
                                ],
                                select => ['nro_socio'],
                                sort_by => ['nro_socio DESC'],
                                );
    if ($nro_socio->[0]){
        return ($nro_socio->[0]->nro_socio + 1);
    }else{
        return '1';            
    }
}

sub modificar{

    my ($self)=shift;
    my ($data_hash)=@_;

    $self->setId_ui($data_hash->{'id_ui'});
    $self->setId_categoria(($data_hash->{'cod_categoria'}));
    $self->setId_estado(($data_hash->{'id_estado'}));

    my $today = Date::Manip::ParseDate("today");
    C4::AR::Debug::debug("TODAY ==================================== >".$today);
    my $cumple_requisito = $data_hash->{'cumple_requisito'};
    
    if ($cumple_requisito){
    	if (!$self->cumpleRequisito){
            $self->setCumple_requisito($today);
    	}
    }else{
        $self->setCumple_requisito("0000000000:00:00");
    }
    
    my $change_password = $data_hash->{'changepassword'};
    
    if ($change_password eq '1'){
        $self->forzarCambioDePassword();
    }else{
        $self->setChange_password(0);
    }

    $self->persona->modificar($data_hash);
    $self->agregarAutorizado($data_hash);

    $self->save();
}

sub sortByString{
    my ($self)      = shift;
    my ($campo)     = @_;

    my $fieldsString = &C4::AR::Utilidades::joinArrayOfString($self->meta->columns);
#   C4::AR::Debug::debug("UsrPersona=> sortByString => fieldsString: ".$fieldsString);
#     C4::AR::Debug::debug("UsrSocio => campo: ".$campo);

    my $index;  
    my $campos_salida;
    my @fields_out;
    my @fields = split /,/, $campo;

    foreach my $f (@fields){
        $index = rindex $fieldsString,$f;

        if ($index != -1){
        #agrego un campo valido
#             C4::AR::Debug::debug("UsrSocio => sortByString => f ".$f);
            push (@fields_out, $f)
        }
    }

    if(scalar(@fields_out) > 0){
        foreach my $fo (@fields_out){
            $campos_salida = $campos_salida.'persona.'.C4::AR::Utilidades::trim($fo).",";
        }

        $campos_salida  = substr $campos_salida, 0, length($campos_salida) - 1;
    
#         C4::AR::Debug::debug("UsrSocio => sortByString => campos_salida ".$campos_salida);
        return $campos_salida;
  
    } else {
        return ("persona.apellido");
    }
}

sub defaultSort{
    my ($campo)     = @_;

    my $personaTemp = C4::Modelo::UsrPersona->new();

    C4::AR::Debug::debug("UsrSocio => defaultSort => return: ".$personaTemp->sortByString($campo));
    C4::AR::Debug::debug("UsrSocio => defaultSort => campo ".$campo);
    return ($personaTemp->sortByString($campo));
}


sub cambiarPassword{
    my ($self)=shift;
    my ($password)=@_;
    
    $self->setPassword($password);
    my $today = Date::Manip::ParseDate("today");
    $self->setLast_change_password($today);
    $self->setChange_password(0);
    
    $self->save();
}

sub resetPassword{
    my ($self)=shift;

	$self->setPassword(C4::AR::Auth::hashear_password(C4::AR::Auth::hashear_password($self->persona->getNro_documento, 'MD5_B64'), 'SHA_256_B64'));
	$self->forzarCambioDePassword();

	$self->save();
}

sub forzarCambioDePassword{
    my ($self)=shift;
    my ($es_alta) = @_;
    
    $es_alta = $es_alta || 0;
    
    $self->setChange_password(1);
    $self->last_change_password('0000-00-00');
    
    if (!$es_alta){
        $self->save();
    }
}


sub activar{
    my ($self) = shift;

#    $self->forget();
    my $today       = Date::Manip::ParseDate("today");
    my $dateformat  = C4::Date::get_date_format();

    $self->setActivo(1);
    $self->persona->activar();
    # $self->setCumple_requisito("0000000000:00:00");
    $today = C4::Date::format_date_in_iso($today,$dateformat);
    #se setea nuevamente la fecha del dia al momento de activar al 
    C4::AR::Debug::debug("UsrSocio => activar => setFecha_alta => " . $today);
    $self->setFecha_alta($today);

    my ($credential_type) = $self->getCredentialType;

    switch ($credential_type){

      case 'estudiante'      {$self->convertirEnEstudiante}
      case 'librarian'       {$self->convertirEnLibrarian}
      case 'superLibrarian'  {$self->convertirEnSuperLibrarian; $self->setIs_super_user(1);}
      else                   {$self->convertirEnEstudiante}
    }

    $self->save();
}

sub desactivar{
    my ($self) = shift;
    use C4::AR::Prestamos;
    
    my ($vencidos,$prestamos) = C4::AR::Prestamos::cantidadDePrestamosPorUsuario($self->getNro_socio);
    
    if ($vencidos || $prestamos){
    	return (1,'U424');
    }
    $self->persona->desactivar;
    $self->setActivo(0);
    $self->save();
    
    return (0,'U363')
}

sub eliminar{
    my ($self) = shift;
    use C4::AR::Prestamos;
    
    my ($vencidos,$prestamos) = C4::AR::Prestamos::cantidadDePrestamosPorUsuario($self->getNro_socio);
    
    if ($vencidos || $prestamos){
        return (1,'U421');
    }
    $self->persona->delete;
    $self->delete;
    
    return (0,'U900')
}

sub getActivo{
    my ($self) = shift;
    return ($self->activo);
}

sub setActivo{
    my ($self) = shift;
    my ($activo) = @_;
    $self->activo($activo);
}


sub setNote{
    my ($self) = shift;
    my ($note) = @_;
    $self->note($note);
}


sub getNote{
    my ($self) = shift;
    return ($self->note);
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

sub getId_socio{
    my ($self) = shift;
    return ($self->id_socio);
}

sub setId_socio{
    my ($self) = shift;
    my ($id_socio) = @_;
    $self->id_socio($id_socio);
}

sub getNro_socio{
    my ($self) = shift;
    return ($self->nro_socio);
}

sub setNro_socio{
    my ($self) = shift;
    my ($nro_socio) = @_;
    $self->nro_socio(C4::AR::Utilidades::trim($nro_socio));
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

sub getCategoria{
    my ($self) = shift;
    return ($self->categoria);
}


sub getCod_categoria{
    my ($self) = shift;
    return ($self->categoria->getCategory_code);
}

sub getId_categoria{
    my ($self) = shift;
    return ($self->id_categoria);
}

sub getFecha_alta{
    my ($self) = shift;
    my $dateformat = C4::Date::get_date_format();

    return ( C4::Date::format_date($self->fecha_alta,$dateformat) );
}

sub setFecha_alta{
    my ($self) = shift;
    my ($fecha_alta) = @_;
    $self->fecha_alta($fecha_alta);
}

sub getExpira{
    my ($self) = shift;
    my $dateformat = C4::Date::get_date_format();

    return ( C4::Date::format_date($self->expira,$dateformat) );
}

sub setExpira{
    my ($self) = shift;
    my ($expira) = @_;
    $self->expira($expira);
}

sub getFlags{
    my ($self) = shift;
    return ($self->flags);
}

sub setFlags{
    my ($self) = shift;
    my ($flags) = @_;
    $self->flags($flags);
}

sub getPassword{
    my ($self) = shift;
    if($self->getLastAuthMethod ne 'mysql'){
        return C4::AR::Auth::getPassword($self);
        }
    elsif (C4::AR::Utilidades::validateString($self->password)){
      return ($self->password);
    }else{
      return (C4::AR::Auth::prepare_password($self->persona->getNro_documento));
    }
}

sub setPassword{
    my ($self) = shift;
    my ($password) = @_;

    $self->password($password);
}

sub getLast_login{
    my ($self) = shift;
    return ($self->last_login);
}

sub setLast_login{
    my ($self) = shift;
    my ($last_login) = @_;

    $self->last_login($last_login);

}

sub getLastLoginAll{
    my ($self) = shift;

    return $self->last_login_all;
}

sub getLastLoginAllFormatted{
    my ($self)      = shift;
    my $dateformat  = C4::Date::get_date_format();

    return C4::Date::format_date(substr($self->getLastLoginAll(),0,10),$dateformat);
}

sub setLastLoginAll{
    my ($self) = shift;
    my ($last_login_all) = @_;

    $self->last_login_all($last_login_all);

}

sub getLogin_attempts{
    my ($self) = shift;
    
    return (C4::AR::Auth::getSocioAttempts($self->nro_socio));
}


sub getLast_change_password{
    my ($self) = shift;
    return ($self->last_change_password);
}

sub setLast_change_password{
    my ($self) = shift;
    my $dateformat = C4::Date::get_date_format();
    my ($last_change_password) = @_;
    $last_change_password = C4::Date::format_date_in_iso($last_change_password,$dateformat);
    $self->last_change_password($last_change_password);
    
}

sub getLastValidation{
    my ($self) = shift;
    return $self->lastValidation;
}

sub getLastValidation_formateada{
    my ($self) = shift; 
    my $dateformat = C4::Date::get_date_format();
    return  C4::Date::format_date(substr($self->getLastValidation,0,10),$dateformat);

}


sub updateValidation{
    my ($self) = shift;
    
    my $now = C4::Date::getCurrentTimestamp();
    
    $self->setLastValidation($now);
    $self->save();
}

sub setLastValidation{
    my ($self) = shift;
    my ($lastValidation) = @_;

   # my $dateformat = C4::Date::get_date_format();
    #$lastValidation = C4::Date::format_date_complete($lastValidation,);

    C4::AR::Debug::debug("lastValidation: ".$lastValidation);
    $self->lastValidation($lastValidation);
}


sub getChange_password{
    my ($self) = shift;
    return ($self->change_password);
}

sub setChange_password{
    my ($self) = shift;
    my ($change_password) = @_;
    $self->change_password($change_password);
}

sub cumpleRequisito{
  my ($self) = shift;

  my $requisito_necesario = C4::AR::Preferencias::getValorPreferencia("requisito_necesario")||0;
  my $cumple = 1;

  # (C4::AR::Preferencias::getValorPreferencia("requisito_necesario"))? $cumple : $cumple = 1;	

  if ($requisito_necesario){
      my $cumple_condicion  = $self->getCumple_requisito||"0000000000:00:00";
      $cumple               = ($cumple_condicion ne "0000000000:00:00");
  }
  $cumple = $cumple && ($self->getActivo);

  return $cumple;
}

sub getCumple_requisito{
    my ($self) = shift;
    return ($self->cumple_requisito);
}

sub setCumple_requisito{
    my ($self) = shift;
    my ($cumple_requisito) = @_;
    $self->cumple_requisito($cumple_requisito);
}

sub getTheme{
    my ($self) = shift;
    return ($self->theme);
}

sub setTheme{
    my ($self) = shift;
    my ($theme) = @_;
    $self->theme($theme);
}

sub getThemeINTRA{
    my ($self) = shift;
    return ($self->theme_intra);
}

sub setThemeINTRA{
    my ($self) = shift;
    my ($theme) = @_;
    $self->theme_intra($theme);
    $self->save();
}


sub setThemeSave{
    my ($self) = shift;
    my ($theme) = @_;
    $self->theme($theme);
}

sub esRegularToString{
    my ($self) = shift;

    my $object = $self->getCondicion_object;
    my $result;
    
    eval{
        $result =  $object?$object->estado->getNombre:C4::AR::Filtros::i18n("INDEFINIDO");
    };
    
    if ($@){
        return C4::AR::Filtros::i18n("INDEFINIDO");
    }else{
    	return $result;
    }
}

sub esRegular{
    my ($self) = shift;
    
    my $object = $self->getCondicion_object();
    
    if ($object){
        return $object->getCondicion;
    }else{
        return 0;
    }
}


sub getCondicion_object{
    my ($self) = shift;

    use C4::Modelo::UsrRegularidad::Manager;

    my @filtros;
    
    push (@filtros, (usr_estado_id => {eq => $self->getId_estado }) );
    push (@filtros, (usr_ref_categoria_id => {eq => $self->getId_categoria }) );
    
    my ($estados) = C4::Modelo::UsrRegularidad::Manager->get_usr_regularidad(query => \@filtros, require_objects => ['categoria','estado']);
    
    return $estados->[0];
}
sub getIs_super_user{
    my ($self) = shift;

    return ($self->is_super_user);
}

sub setIs_super_user{
    my ($self) = shift;
    my ($is_super_user) = @_;

    $self->is_super_user($is_super_user);
}

sub isSuperUser{
    my ($self) = shift;
    
    return ($self->getIs_super_user);
}
=item
Esta funcion se encarga de verificar los permisos para un entorno dado
Entorno de datos de nivel, para ABM de datos de nivel 1, 2 y 3
@entornos_datos_nivel = ('datos_nivel1','datos_nivel2','datos_nivel3'); 
Entorno de estructura de catalogacion, para ABM de estructura de catalogacion
@entornos_estructura_catalogacion= ('estructura_catalogacion_n1','estructura_catalogacion_n2','estructura_catalogacion_n3');
Entorno de usuarios, para ABM de usuarios
@entornos_manejo_usuario = ('usuarios');

La funcion recibe entre otros parametros el entorno donde se van a verificar los permisos, los arreglos sirven como indices, para saber
si el entorno existe y ademas para buscar el permiso en el entorno (TABLA) correspondiente, ya que catalogo, usuarios, circulacion, datos de nivel, etc cada uno tendra su tabla de permisos.
cualquier entorno ingresado a la funcion que no exista en alguno de los arreglos de entornos será descartado e inmediatamente se
retornará SIN PERMISOS.
=cut

sub checkEntorno{

    my ($flagsrequired,$entornos_perm_catalogo,$entornos_perm_general,$entornos_perm_circulacion) = @_; 
    
    my $entornos_chosen;
    
    my $permisos_array_hash_ref;

    if ($flagsrequired->{'tipo_permiso'} eq "catalogo"){
      $entornos_chosen = $entornos_perm_catalogo;
    }
    elsif ($flagsrequired->{'tipo_permiso'} eq "general"){
      $entornos_chosen = $entornos_perm_general;
    }
    elsif ($flagsrequired->{'tipo_permiso'} eq "circulacion"){
      $entornos_chosen = $entornos_perm_circulacion;
    }
    if( (C4::AR::Utilidades::existeInArray($flagsrequired->{'entorno'}, @$entornos_chosen)) ){
        if ($flagsrequired->{'tipo_permiso'} eq "catalogo"){
            $permisos_array_hash_ref= C4::AR::Permisos::get_permisos_catalogo({
                                                                ui => $flagsrequired->{'ui'}, 
                                                                tipo_documento => $flagsrequired->{'tipo_documento'}, 
                                                                nro_socio => $flagsrequired->{'nro_socio'},
                                                                tipo_documento => 'ALL',
                                                    });
        }
        elsif($flagsrequired->{'tipo_permiso'} eq "general"){
        C4::AR::Debug::debug("ENTORNOS CHOSEN: ".$entornos_chosen->[2]);
            $permisos_array_hash_ref= C4::AR::Permisos::get_permisos_general({
                                                                ui => $flagsrequired->{'ui'}, 
                                                                tipo_documento => $flagsrequired->{'tipo_documento'}, 
                                                                nro_socio => $flagsrequired->{'nro_socio'},
                                                                tipo_documento => 'ALL',
                                                    });
        }
        elsif($flagsrequired->{'tipo_permiso'} eq "circulacion"){
            $permisos_array_hash_ref= C4::AR::Permisos::get_permisos_circulacion({
                                                                ui => $flagsrequired->{'ui'}, 
                                                                tipo_documento => $flagsrequired->{'tipo_documento'}, 
                                                                nro_socio => $flagsrequired->{'nro_socio'},
                                                                tipo_documento => 'ALL',
                                                    });
        }
        return ($permisos_array_hash_ref);
    }else{
        return 0;
    }
}

sub setCredentials{

    my ($self) = shift;
    my ($credential_type) = @_;

    switch ($credential_type){

      case 'estudiante'      {$self->convertirEnEstudiante}
      case 'librarian'       {$self->convertirEnLibrarian}
      case 'superLibrarian'  {$self->convertirEnSuperLibrarian; $self->setIs_super_user(1);}
      else                   {$self->convertirEnEstudiante} # estudiante deberia ser default?
    }

    $self->setCredentialType($credential_type);
    $self->save();
}

sub convertirEnEstudiante{

    my ($self) = shift;
    my ($perm_catalogo, $perm_general, $perm_circulacion);
    my $msg_object= C4::AR::Mensajes::create();

    my @filtros;

    push (@filtros, (nro_socio => {eq => $self->getNro_socio}));
    push (@filtros, (ui => {eq => $self->getId_ui}));
    push (@filtros, (tipo_documento => {eq => 'ALL'}));

    my $db = $self->db;
    
    $perm_catalogo = C4::AR::Permisos::getPermCatalogoOne(\@filtros,$db);
    unless($perm_catalogo)
    {
      $perm_catalogo = C4::Modelo::PermCatalogo->new(db => $self->db);
    }

    $perm_general = C4::AR::Permisos::getPermGeneralOne(\@filtros,$db);
    unless($perm_general)
    {
      $perm_general = C4::Modelo::PermGeneral->new(db => $self->db);
    }

    $perm_circulacion = C4::AR::Permisos::getPermCirculacionOne(\@filtros,$db);
    unless($perm_circulacion)
    {
      $perm_circulacion = C4::Modelo::PermCirculacion->new(db => $self->db);
    }

    $db->{connect_options}->{AutoCommit} = 0;
    $db->begin_work;
        $perm_general->convertirEnEstudiante($self);
        $perm_circulacion->convertirEnEstudiante($self);
        $perm_catalogo->convertirEnEstudiante($self);
        eval{
            $db->commit;
        };
        if ($@){
            C4::AR::Debug::debug("ERROR EN CONVERTIR PERMISOS");
            #Se loguea error de Base de Datos
            $db->rollback;
            #Se setea error para el usuario
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P106', 'params' => []} ) ;
        }
    $db->{connect_options}->{AutoCommit} = 1;
}

sub convertirEnLibrarian{

    my ($self) = shift;
    my ($perm_catalogo, $perm_general, $perm_circulacion);
    my $msg_object= C4::AR::Mensajes::create();

    my @filtros;

    push (@filtros, (nro_socio => {eq => $self->getNro_socio}));
    push (@filtros, (ui => {eq => $self->getId_ui}));
    push (@filtros, (tipo_documento => {eq => 'ALL'}));

    my $db = $self->db;
    
    $perm_catalogo = C4::AR::Permisos::getPermCatalogoOne(\@filtros,$db);

    unless($perm_catalogo)
    {
      $perm_catalogo = C4::Modelo::PermCatalogo->new(db => $self->db);
    }

    $perm_general = C4::AR::Permisos::getPermGeneralOne(\@filtros,$db);
    unless($perm_general)
    {
      $perm_general = C4::Modelo::PermGeneral->new(db => $self->db);
    }

    $perm_circulacion = C4::AR::Permisos::getPermCirculacionOne(\@filtros,$db);
    unless($perm_circulacion)
    {
      $perm_circulacion = C4::Modelo::PermCirculacion->new(db => $self->db);
    }

    $db->{connect_options}->{AutoCommit} = 0;
    $db->begin_work;
        $perm_general->convertirEnLibrarian($self);
        $perm_circulacion->convertirEnLibrarian($self);
        $perm_catalogo->convertirEnLibrarian($self);
        eval{
            $db->commit;
        };
        if ($@){
            C4::AR::Debug::debug("ERROR EN CONVERTIR PERMISOS");
            #Se loguea error de Base de Datos
            $db->rollback;
            #Se setea error para el usuario
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P106', 'params' => []} ) ;
        }
    $db->{connect_options}->{AutoCommit} = 1;
}

sub convertirEnSuperLibrarian{

    my ($self) = shift;
    my ($perm_catalogo, $perm_general, $perm_circulacion);
    my $msg_object= C4::AR::Mensajes::create();

    my @filtros;

    push (@filtros, (nro_socio => {eq => $self->getNro_socio}));
    push (@filtros, (ui => {eq => $self->getId_ui}));
    push (@filtros, (tipo_documento => {eq => 'ALL'}));

    my $db = $self->db;
    
    $perm_catalogo = C4::AR::Permisos::getPermCatalogoOne(\@filtros,$db);

    unless($perm_catalogo)
    {
      $perm_catalogo = C4::Modelo::PermCatalogo->new(db => $self->db);
    }

    $perm_general = C4::AR::Permisos::getPermGeneralOne(\@filtros,$db);
    unless($perm_general)
    {
      $perm_general = C4::Modelo::PermGeneral->new(db => $self->db);
    }

    $perm_circulacion = C4::AR::Permisos::getPermCirculacionOne(\@filtros,$db);
    unless($perm_circulacion)
    {
      $perm_circulacion = C4::Modelo::PermCirculacion->new(db => $self->db);
    }

    $db->{connect_options}->{AutoCommit} = 0;
    $db->begin_work;
        $perm_general->convertirEnSuperLibrarian($self);
        $perm_circulacion->convertirEnSuperLibrarian($self);
        $perm_catalogo->convertirEnSuperLibrarian($self);
        eval{
            $db->commit;
        };
        if ($@){
            C4::AR::Debug::debug("ERROR EN CONVERTIR PERMISOS");
            #Se loguea error de Base de Datos
            $db->rollback;
            #Se setea error para el usuario
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P106', 'params' => []} ) ;
        }
    $db->{connect_options}->{AutoCommit} = 1;
    
}


sub verificar_permisos_por_nivel{

    my ($flagsrequired) = @_;
    my @filtros;
    my $permisos_array_hash_ref;

    my @entornos_perm_catalogo      = ( 'datos_nivel1','datos_nivel2','datos_nivel3', 'estructura_catalogacion_n1',
                                        'estructura_catalogacion_n2','estructura_catalogacion_n3', 'sistema', 'undefined', 'usuarios');
    
    my @entornos_perm_general       = ( 'reportes','preferencias','permisos','adq_opac','adq_intra' );
    
    my @entornos_perm_circulacion   = ( 'prestamos', 'circ_opac', 'circ_prestar','circ_renovar', 'circ_devolver', 'circ_sanciones' );

    my @entornos_manejo_usuario     = ( 'usuarios' );


    $permisos_array_hash_ref = C4::Modelo::UsrSocio::checkEntorno($flagsrequired,\@entornos_perm_catalogo,\@entornos_perm_general,\@entornos_perm_circulacion);
    
    if (!$permisos_array_hash_ref){
        #el entorno pasado por parametro no existe, NO TIENE PERMISOS
#         C4::AR::Debug::debug("UsrSocio => verificar_permisos_por_nivel => NO EXISTE EL ENTORNO: ".$flagsrequired->{'entorno'});
        return (0);
    }

    foreach my $permisos_hash_ref (@$permisos_array_hash_ref){
#         if($permisos_hash_ref ne 0){
#             C4::AR::Debug::debug("UsrSocio => verificar_permisos_por_nivel");
            #se encontraron permisos level1
        
            my $permiso_bin_del_usuario= $permisos_hash_ref->{$flagsrequired->{'entorno'}};
            my $permiso_bin_requerido= C4::AR::Permisos::permisos_str_to_bin($flagsrequired->{'accion'});
            my $permiso_dec_del_usuario= C4::AR::Utilidades::bin2dec($permiso_bin_del_usuario);
            my $permiso_dec_requerido = C4::AR::Utilidades::bin2dec($permiso_bin_requerido);
    
            if( ($permiso_bin_del_usuario & '00010000') > 0){
                #tiene TODOS los permisos
#                 C4::AR::Debug::debug("UsrSocio => verificar_permisos_por_nivel => PERMISOS DEL USUARIO=================bin: ".$permiso_bin_del_usuario);
#                 C4::AR::Debug::debug("UsrSocio => verificar_permisos_por_nivel => PERMISOS DEL USUARIO=================TODOS");
                return 1;
            }
            
#             C4::AR::Debug::debug("UsrSocio => verificar_permisos_por_nivel => PERMISOS DEL USUARIO=================bin: ".$permiso_bin_del_usuario);
#             C4::AR::Debug::debug("UsrSocio => verificar_permisos_por_nivel => PERMISOS REQUERIDOS=================bin: ".$permiso_bin_requerido);
#             C4::AR::Debug::debug("UsrSocio => verificar_permisos_por_nivel => ENTORNO=================: ".$flagsrequired->{'entorno'});
            my $resultado= $permiso_bin_del_usuario & $permiso_bin_requerido;
            if( C4::AR::Utilidades::bin2dec($resultado) > 0 ){
                return 1;
            }
#         }
    }

    return 0;
}

sub tienePermisos {
    #     00000000 8bits los 3 más significativos esta para uso futuro
    #     000TABMC TODOS, ALTA, BAJA, MODIFICACION, CONSULTA 

    #     $flagsrequired->{'tipo_documento'}
    #     $flagsrequired->{'accion'}
    #     $flagsrequired->{'ui'}
    #     $flagsrequired->{'nivel'} #datos_nivel3 | datos_nivel2 | datos_nivel1

    my ($self) = shift;
    my ($flagsrequired) = @_;
    
    if (!($self->getActivo)){ 
        C4::AR::Debug::debug("UsrSocio => TIPO_PERMISO => el socio no es activo");
        return 0;
    }
    # Se setean los flags requeridos
    $flagsrequired->{'nro_socio'}       = $self->getNro_socio;
    $flagsrequired->{'tipo_permiso'}    = $flagsrequired->{'tipo_permiso'} || "catalogo";
    C4::AR::Debug::debug("UsrSocio => TIPO_PERMISO => ".$flagsrequired->{'tipo_permiso'});
    #se verifican permisos level1
    C4::AR::Debug::debug("UsrSocio => tienePermisos??? => intento level1");
    if(verificar_permisos_por_nivel($flagsrequired)){return 1}

    $flagsrequired->{'tipo_documento'}  = 'ALL';
    #se verifican permisos level2
    C4::AR::Debug::debug("UsrSocio => tienePermisos??? => intento level2");
    if(verificar_permisos_por_nivel($flagsrequired)){return 1}

    $flagsrequired->{'ui'}              = 'ALL';
    #se verifican permisos level3
    C4::AR::Debug::debug("UsrSocio => tienePermisos??? => intento level3");
    if(verificar_permisos_por_nivel($flagsrequired)){return 1}

    $flagsrequired->{'tipo_documento'}  = 'ALL';
    $flagsrequired->{'ui'}              = 'ALL';
    #se verifican permisos level4
    C4::AR::Debug::debug("UsrSocio => tienePermisos??? => intento level4");
    if(verificar_permisos_por_nivel($flagsrequired)){
        return 1;
    }else{
        #el usuario no tiene permisos
        C4::AR::Debug::debug("UsrSocio => NO TIENE EL PERMISO");
        return 0;
    }
}


sub tieneSeteadosPermisos{
    my ($self) = shift;

    my @filtros;
    
    push (@filtros, ( nro_socio => { eq =>$self->getNro_socio}) );
    push (@filtros, ( ui => { eq =>$self->getId_ui} ) );
    push (@filtros, ( tipo_documento => { eq =>"ALL"}) );
     
    my $permisos = C4::Modelo::PermCatalogo::Manager::get_perm_catalogo(query => \@filtros,);
    
    my $result = $permisos->[0] || undef;
    
    return $result;
	
}

sub tienePermisosOPAC{
	my ($self) = shift;
	
	return (C4::AR::Utilidades::validateString($self->credential_type));
	
}
=item
Retorna la persona que corresponde al socio
=cut
sub getPersona{
    my ($self) = shift;

    my $persona = C4::Modelo::UsrPersona::Manager->get_usr_persona( query => [ id_persona => { eq => $self->getId_persona } ]);

    return ($persona);
}

sub estaSancionado {
  #Esta funcion determina si un usuario ($nro_socio) tiene alguna sancion
  my ($nro_socio)=@_;

  my $dateformat = C4::Date::get_date_format();
  my $hoy=C4::Date::format_date_in_iso(ParseDate("today"), $dateformat);
  
  my $sanciones_array_ref = C4::Modelo::CircSancion::Manager->get_circ_sancion (   
                                                                    query => [ 
                                                                            nro_socio       => { eq => $nro_socio },
                                                                            fecha_comienzo  => { le => $hoy },
                                                                            fecha_final     => { ge => $hoy},
                                                                        ],
                                    );
  return($sanciones_array_ref->[0] || undef);

}


sub getNombre_apellido_autorizado{
    my ($self) = shift;
    return ($self->nombre_apellido_autorizado);
}

sub setNombre_apellido_autorizado{
    my ($self) = shift;
    my ($nombre_apellido_autorizado) = @_;
    utf8::encode($nombre_apellido_autorizado);
    if (C4::AR::Utilidades::validateString($nombre_apellido_autorizado)){
      $self->nombre_apellido_autorizado($nombre_apellido_autorizado);
    }
}

sub getTelefono_autorizado{
    my ($self) = shift;
    return ($self->telefono_autorizado);
}

sub setTelefono_autorizado{
    my ($self) = shift;
    my ($telefono_autorizado) = @_;
    utf8::encode($telefono_autorizado);
    if (C4::AR::Utilidades::validateString($telefono_autorizado)){
      $self->telefono_autorizado($telefono_autorizado);
    }
}


sub getRecoverPasswordHash{
    my ($self) = shift;
    return ($self->recover_password_hash);
}

sub setRecoverPasswordHash{
    my ($self) = shift;
    my ($recover_password_hash) = @_;

    if (C4::AR::Utilidades::validateString($recover_password_hash)){
      $self->recover_password_hash($recover_password_hash);
    }
    
    $self->save();
}

sub unsetRecoverPasswordHash{
	
    my ($self) = shift;
    $self->recover_password_hash(undef);
    
    $self->save();
}

sub getDni_autorizado{
    my ($self) = shift;
    return ($self->dni_autorizado);
}

sub setDni_autorizado{
    my ($self) = shift;
    my ($dni_autorizado) = @_;
    utf8::encode($dni_autorizado);
    if (C4::AR::Utilidades::validateString($dni_autorizado)){
      $self->dni_autorizado($dni_autorizado);
    }
}

sub getLocale{
    my ($self) = shift;
    return ($self->locale);
}

sub setLocale{
    my ($self) = shift;
    my ($string) = @_;
    $string = Encode::encode_utf8($string);
    $self->locale($string);
    $self->save();
}


sub fotoName{
    my ($self)          = shift;
    my ($session_type)  = shift;
    
    my $picturesDir = C4::Context->config("picturesdir");
    my $path;

    my $foto_name   =   $self->persona->getFoto;
    
    if (!C4::AR::Utilidades::validateString($foto_name)){
        $foto_name = $self->buildFotoNameHash();
        $self->setFoto($foto_name);
    }
    
    
    if (lc($session_type) eq "opac"){
        $picturesDir = C4::Context->config("picturesdir_opac");
        $foto_name =   $self->getFoto;

	    if (!C4::AR::Utilidades::validateString($foto_name)){
	        $foto_name = $self->persona->buildFotoNameHash();
            $self->persona->setFoto($foto_name);
	    }
    }

    $path           = $picturesDir."/".$foto_name;

     return $foto_name;
}


sub tieneFoto{
    my ($self)          = shift;
    my ($session_type)  = shift;
    
    my $picturesDir = C4::Context->config("picturesdir");
    my $path;

    my $foto_name   =   $self->persona->getFoto;

    if (lc($session_type) eq "opac"){
    	$picturesDir = C4::Context->config("picturesdir_opac");
    	$foto_name =   $self->getFoto;
    }

    $path           = $picturesDir."/".$foto_name;

    if ( -e $path ){
    	return $foto_name;
    }else{
    	return undef;
    }
}

sub needsValidation{
	my ($self)      = shift;
	
	my $lastValidation = $self->getLastValidation();
	
	my $days = $self->daysFromLastValidation();
	            
	my $validation_required_or_days = C4::AR::Preferencias::getValorPreferencia("user_data_validation_required_or_days") || 0;
	            
	            
	my $needsDataValidation = ($validation_required_or_days) 
	                                   &&  
	                          (($days > $validation_required_or_days) || ($lastValidation eq '0000-00-00 00:00:00'));
	                          
	return ($needsDataValidation);
	
}

sub daysFromLastValidation{
    my ($self)      = shift;

    my $lastValidation = $self->getLastValidation();
    my $days = C4::AR::Utilidades::daysToNow($lastValidation);
    return $days;
}

sub getInvolvedCount{
 
    my ($self) = shift;

    my ($campo, $value)= @_;
    my @filtros;

    C4::AR::Utilidades::printHASH($campo);

    push (@filtros, ( $campo->getCampo_referente => $value ) );

    my $count = C4::Modelo::UsrSocio::Manager->get_usr_socio_count( query => \@filtros );

    return ($count);
}

sub replaceBy{
 
    my ($self) = shift;

    my ($campo,$value,$new_value)= @_;
    
    my @filtros;

    push (  @filtros, ( $campo => { eq => $value},) );


    my $replaced = C4::Modelo::UsrSocio::Manager->update_usr_socio(     where => \@filtros,
                                                                        set   => { $campo => $new_value });
}


sub getId_categoria{
    my ($self) = shift;
    
    return ($self->id_categoria);
}

sub setId_categoria{
    my ($self) = shift;
    my ($id) = shift;
    
    $self->id_categoria($id);
    $self->save();
}

sub puedeReservar{
    
    my ($self) = shift;
    my ($id2)= @_;

    my ($reservas,$cant_reservas) = C4::AR::Reservas::getReservasDeSocio($self->getNro_socio, $id2);

    return ( ($cant_reservas == 0) && (!$self->loTienePrestado($id2)) );    
}

sub loTienePrestado{
    
    my ($self) = shift;
    my ($id2)= @_;

    my ($status) = C4::AR::Prestamos::tienePrestamosDeId2($self->getNro_socio, $id2);

    return ( $status );    
}

sub getIdReserva{
    
    my ($self) = shift;
    my ($id2)= @_;
    
    my ($reservas,$cant_reservas) = C4::AR::Reservas::getReservasDeSocio($self->getNro_socio, $id2);

    if ($cant_reservas){
    	return $reservas->[0]->id_reserva;
    }
}


sub esAdmin{
	my ($self) = shift;
	
	return ($self->es_admin);
}

sub updateNroSocio{

    my ($self)          = shift;
    my ($params) = @_;

    use C4::Modelo::RepBusqueda::Manager;
    use C4::Modelo::SysNovedad::Manager;
    use C4::Modelo::SysNovedadIntraNoMostrar::Manager;
    use C4::Modelo::SysNovedadIntra::Manager;

    my $db = $self->db;
    my $old_nro_socio = $self->getNro_socio;
    my $nuevo_nro_socio = $params->{'nuevo_nro_socio'};
    my @where;
    my @set;

    $self->setNro_socio($nuevo_nro_socio);

    push (  @where, ( nro_socio => { eq => $old_nro_socio},) );
    push (  @set, ( nro_socio => $self->getNro_socio,) );


    C4::Modelo::CircPrestamo::Manager->update_circ_prestamo(     
                                                            where => \@where,
                                                            set   => \@set,
                                                            db    => $db,
                                                    );

    C4::Modelo::CircReserva::Manager->update_circ_reserva(     
                                                            where => \@where,
                                                            set   => \@set,
                                                            db    => $db,
                                                    );

    C4::Modelo::CircSancion::Manager->update_circ_sancion(     
                                                            where => \@where,
                                                            set   => \@set,
                                                            db    => $db,
                                                    );

    C4::Modelo::PermCatalogo::Manager->update_perm_catalogo(     
                                                            where => \@where,
                                                            set   => \@set,
                                                            db    => $db,
                                                    );

    C4::Modelo::PermCirculacion::Manager->update_perm_circulacion(     
                                                            where => \@where,
                                                            set   => \@set,
                                                            db    => $db,
                                                    );

    C4::Modelo::PermGeneral::Manager->update_perm_general(     
                                                            where => \@where,
                                                            set   => \@set,
                                                            db    => $db,
                                                    );

    C4::Modelo::RepBusqueda::Manager->update_rep_busqueda(     
                                                            where => \@where,
                                                            set   => \@set,
                                                            db    => $db,
                                                    );

    C4::Modelo::RepHistorialCirculacion::Manager->update_rep_historial_circulacion(     
                                                            where => \@where,
                                                            set   => {nro_socio => $self->getNro_socio, responsable => $self->getNro_socio,},
                                                            db    => $db,
                                                    );

    C4::Modelo::RepHistorialPrestamo::Manager->update_rep_historial_prestamo(     
                                                            where => \@where,
                                                            set   => \@set,
                                                            db    => $db,
                                                    );

    C4::Modelo::RepHistorialSancion::Manager->update_rep_historial_sancion(     
                                                            where => \@where,
                                                            set   => {nro_socio => $self->getNro_socio, responsable => $self->getNro_socio,},
                                                            db    => $db,
                                                    );

    C4::Modelo::SistSesion::Manager->update_sist_sesion(     
                                                            where => [userid => {eq =>$old_nro_socio}],
                                                            set   => {userid => $self->getNro_socio,},
                                                            db    => $db,
                                                    );

    C4::Modelo::SysNovedad::Manager->update_sys_novedad(     
                                                            where => [usuario => {eq =>$old_nro_socio}],
                                                            set   => {usuario => $self->getNro_socio,},
                                                            db    => $db,
                                                    );

    C4::Modelo::SysNovedadIntra::Manager->update_sys_novedad_intra(     
                                                            where => [usuario => {eq =>$old_nro_socio}],
                                                            set   => {usuario => $self->getNro_socio,},
                                                            db    => $db,
                                                    );

    C4::Modelo::SysNovedadIntraNoMostrar::Manager->update_sys_novedad_intra_no_mostrar(     
                                                            where => [usuario_novedad => {eq =>$old_nro_socio}],
                                                            set   => {usuario_novedad => $self->getNro_socio,},
                                                            db    => $db,
                                                    );


    return ($self->save());
}

1;
