package C4::AR::Authldap;

=head1 NAME
  C4::AR::Authldap 
=head1 SYNOPSIS
  use C4::AR::Authldap;
=head1 DESCRIPTION
    En este modulo se centraliza todo lo relacionado a la authenticacion del usuario contra un ldap.
    Sirve tanto para utilizar el esquema propio de Meran como para autenticarse contra un dominio.
=cut

require Exporter;
use strict;
use Net::LDAP;
use Net::LDAP::Extension::SetPassword;
use Net::LDAPS;
use Net::LDAP::LDIF;
use Net::LDAP::Util qw(ldap_error_text);
use Net::LDAP::Constant qw(LDAP_EXTENSION_START_TLS);
use C4::AR::Preferencias;
use vars qw(@ISA @EXPORT_OK );
@ISA = qw(Exporter);
@EXPORT_OK = qw(
    getLdapPreferences
    setVariableLdap
    checkPwEncriptada
    checkPwPlana
    _getValorPreferenciaLdap
    datosUsuario
    _conectarLDAP
    checkPassword
    obtenerPassword
);

=item
    setVariableLdap, esta funcion setea una variable en pref_ldap
=cut
sub setVariableLdap {
    my ($variable, $valor, $db) = @_;
    my  $preferencia;
    
    $preferencia = C4::Modelo::PrefPreferenciaSistema::Manager->get_pref_preferencia_sistema( query => [variable => {eq => $variable}] );
    
    if(scalar(@$preferencia) > 0){
        $preferencia->[0]->setValue($valor);
        $preferencia->[0]->save();
    }
}

=item
    Esta funcion devuelve en una HASH todas las variables de pref_ldap, se filtra por categoria='auth'
=cut
sub getLdapPreferences{

    my $preferencias_array_ref;
    my @filtros;
    my $prefTemp = C4::Modelo::PrefPreferenciaSistema->new();
  
    $preferencias_array_ref = C4::Modelo::PrefPreferenciaSistema::Manager->get_pref_preferencia_sistema( 
                                        query => [ categoria => { eq => 'auth' } ],
                                ); 
                                
    my %hash;
    foreach my $pref (@$preferencias_array_ref){
        $hash{$pref->getVariable} = $pref->getValue();
    }

    return (\%hash);                    
}

=item
    Esta funcion devuelve el valor de la preferencia 'variable' recibida como parametro
=cut
sub _getValorPreferenciaLdap{

    my ($variable)              = @_;
    my $preferencia_ldap_array_ref   = C4::Modelo::PrefPreferenciaSistema::Manager->get_pref_preferencia_sistema( 
                                                            query => [  variable => { eq => $variable} ,
                                                                        categoria => { eq => 'auth'}
                                                                     ]
                                                            );

    if ($preferencia_ldap_array_ref->[0]){
        return ($preferencia_ldap_array_ref->[0]->getValue);
    } else{
        return 0;
    }
}

=item 
    Esa funcion devuelve un objeto socio a partir de los datos que estan en la base de Meran una vez que fue autenticado por el ldap,
    en caso de no existir en la base de MERAN lo agrega a la misma siempre y cuando la variable agregarDesdeLDAP este habilitada.
    Si no existe en la base y la variable esta en 0 devuelve 0. 
    
    Recibe el userid y un ldap con el bind ya realizado.
=cut
sub datosUsuario{
    my ($userid,$ldap)  = @_;
    my $socio           = C4::AR::Usuarios::getSocioInfoPorNroSocio($userid);

    if ($socio) { 
        return $socio;
    }
    else {
        # DATOS OBLIGATORIOS PARA CREAR UN NUEVO SOCIO
        # nro_socio , id_ui, cod_categoria, change_password (dejala en 0), id_estado (uno de UsrEstado), is_super_user 

        my $preferencias_ldap   = getLdapPreferences();
        my $agregar_ldap        = $preferencias_ldap->{'ldap_agregar_user'} || 0; 
        
        if ($agregar_ldap){
                
                my $LDAP_DB_PREF    = $preferencias_ldap->{'ldap_prefijo_base'};
                my $LDAP_U_PREF     = $preferencias_ldap->{'ldap_user_prefijo'};
                my $LDAP_FILTER     = $LDAP_U_PREF.'='.$userid;
                
                my $entries         = $ldap->search(
                        base   => $LDAP_DB_PREF,
                        filter => "($LDAP_FILTER)"
                );  
                my $entry           = $entries->entry(0);

                if ($entry){
                    $socio = C4::AR::Usuarios::crearPersonaLDAP($userid,$entry);
                    C4::AR::Debug::debug("Authldap =>datosUsuario".$LDAP_FILTER . ' entry '.$entry->ldif); 
                }                
        }  
    }
        ######FIXME agregarSocio como inactivo o no???? preferencia???
        return $socio;
}

=item 
    Funcion interna al modulo q se conecta al sevidor LDAP y devuelve un objeto Net::LDAP o NET::LDAPS de acuerdo a la configuracion.
=cut
sub _conectarLDAP{

    my $preferencias_ldap   = getLdapPreferences();
    
    my $LDAP_SERVER = $preferencias_ldap->{'ldap_server'};
    my $LDAP_PORT   = $preferencias_ldap->{'ldap_port'};
    my $LDAP_TYPE   = $preferencias_ldap->{'ldap_type'};

    my $ldap;
    if ($LDAP_TYPE ne 'SSL'){
        $ldap = Net::LDAP->new($LDAP_SERVER, port => $LDAP_PORT) or die "Coult not create LDAP object because:\n$!";
        if ($LDAP_TYPE eq 'TLS') {
            my $dse             = $ldap->root_dse();
            my $doesSupportTLS  = $dse->supported_extension(LDAP_EXTENSION_START_TLS);
            C4::AR::Debug::debug("Authldap =>Server does not support TLS\n") unless($doesSupportTLS);
            my $startTLSMsg     = $ldap->start_tls();
            C4::AR::Debug::debug("Authldap =>".$startTLSMsg->error) if $startTLSMsg->is_error;
        } 
    }
    else{
        $ldap = Net::LDAPS->new($LDAP_SERVER, port => $LDAP_PORT) or die "Coult not create LDAP object because:\n$!";
    }
    return $ldap;
}

=item 
    Funcion que recibe un userid y un password e intenta autenticarse ante un ldap, si lo logra devuelve un objeto Socio.
=cut
sub checkPwPlana{
    my ($userid, $password) = @_;
    my $preferencias_ldap   = getLdapPreferences();
    my $LDAP_DB_PREF        = $preferencias_ldap->{'ldap_prefijo_base'};
    my $LDAP_U_PREF         = $preferencias_ldap->{'ldap_user_prefijo'};
    my $userDN              = $LDAP_U_PREF.'='.$userid.','.$LDAP_DB_PREF;
    my $ldap                =_conectarLDAP();
    C4::AR::Debug::debug("userid : " . $userid . " pass: " . $password . " userDN : " . $userDN);
    my $ldapMsg             = $ldap->bind($userDN, password => $password);
    C4::AR::Debug::debug("Authldap => smsj ". $ldapMsg->error. " codigo ". $ldapMsg->code() );
    my $socio               = undef;
    if (!$ldapMsg->code()) {
        $socio = datosUsuario($userid,$ldap);
    }
    $ldap->unbind;
    return $socio;
}

=item
    Funcion que recibe un userid, un nroRandom y un password e intenta validarlo ante un ldap utilizando el mecanismo interno de Meran, si      lo logra devuelve un objeto Socio.
=cut
sub checkPwEncriptada{
    my ($userid, $password, $nroRandom) = @_;
    C4::AR::Debug::debug("EN CHECKAUT LDAP userid: ".$userid." pass: ".$password." nroRandom : ".$nroRandom);
    my $preferencias_ldap   = getLdapPreferences();
    my $LDAP_DB_PREF        = $preferencias_ldap->{'ldap_prefijo_base'};
    my $LDAP_U_PREF         = $preferencias_ldap->{'ldap_user_prefijo'};
    my $LDAP_ROOT           = $preferencias_ldap->{'ldap_bind_dn'};
    my $LDAP_PASS           = $preferencias_ldap->{'ldap_bind_pw'};
    my $LDAP_OU             = $preferencias_ldap->{'ldap_grupo'};
    my $LDAP_FILTER         = $LDAP_U_PREF.'='.$userid;

    if ($preferencias_ldap->{'ldap_memberattribute'}){
        $LDAP_FILTER = "&(".$LDAP_FILTER.")(".$preferencias_ldap->{'ldap_memberattribute'}."=".$preferencias_ldap->{'ldap_memberattribute_isdn'}.")";
    }

  C4::AR::Debug::debug("checkPwEncriptada >> LDAP filter ".$LDAP_FILTER );

    my $passwordLDAP;
    my $ldapMsg             = undef;
    my $ldap                = _conectarLDAP();
#    my $userDN              = $LDAP_ROOT.','.$LDAP_DB_PREF;
    my $userDN              = $LDAP_U_PREF.'='.$userid.','.$LDAP_DB_PREF;
 
    if ($LDAP_ROOT ne ''){    
        $ldapMsg = $ldap->bind( $LDAP_ROOT , password => $LDAP_PASS) or die "$@";
        C4::AR::Debug::debug("checkPwEncriptada >> ERROR DEL LDAP con ".$LDAP_ROOT ." y ".$LDAP_PASS. " dio ".$ldapMsg->error);        
    }else{    
        $ldapMsg = $ldap->bind() or die "$@";        
    }
    
    my $socio           = undef;

    if ((defined $ldapMsg )&& (!$ldapMsg->code()) ) {   
        my $entries = $ldap->search(
            base   => $LDAP_DB_PREF,
            filter => "($LDAP_FILTER)"
        );
        
    C4::AR::Debug::debug("checkPwEncriptada >> search LDAP user  ".$LDAP_FILTER );
        
        my $entry = $entries->entry(0);
     C4::AR::Debug::debug("checkPwEncriptada >> search LDAP user  ".$entry );  
        if (defined $entry){        
            $passwordLDAP = $entry->get_value("userPassword");

            C4::AR::Debug::debug("checkPwEncriptada >> passLDAP  ".$passwordLDAP );
            if ($preferencias_ldap->{'ldap_passtype'} eq "sha1"){
                #Las passwords encriptadas se limpian
                $passwordLDAP =~ s/^\{SHA\}+|=+$//g;
            }elsif($preferencias_ldap->{'ldap_passtype'} eq "md5"){
               #Las passwords encriptadas se limpian
                $passwordLDAP =~ s/^\{MD5\}+|=+$//g;
            }

           $socio        =_verificar_password_con_metodo($userid,$password, $passwordLDAP, $nroRandom, $ldap);           
        }
        
        $ldap->unbind;
    }
    
    return $socio;
}

=item sub _verificar_password_con_metodo

    Verifica la password ingresada por el usuario con la password de LDAP
    Parametros:
    $passwordLDAP: el pass obtenido del LDAP, PLANA
    $ldap: la conexion al ldap
    $nroRandom: el nroRandom previamente generado
    $password: ingresada por el usuario
    $userid: usuario

=cut
sub _verificar_password_con_metodo {
    my ($userid, $password, $passwordLDAP, $nroRandom, $ldap) = @_;
 C4::AR::Debug::debug("checkPwEncriptada >> passwordLDAP  ".$passwordLDAP);
#    my $passwordParaComparar    = C4::AR::Auth::hashear_password($passwordLDAP, 'MD5_B64');
    my $passwordParaComparar       = C4::AR::Auth::hashear_password($passwordLDAP, C4::AR::Auth::getMetodoEncriptacion());
    $passwordParaComparar       = C4::AR::Auth::hashear_password($passwordParaComparar.$nroRandom, C4::AR::Auth::getMetodoEncriptacion());
 

   C4::AR::Debug::debug("checkPwEncriptada >> passwordParaComparar  ".$passwordParaComparar ."   ==  ".$password);

 
    if ($password eq $passwordParaComparar) {
        #PASSWORD VALIDA
        return datosUsuario($userid,$ldap);
    }else {
        #PASSWORD INVALIDA
        return undef;
    }
}

sub checkPassword{
    my ($userid,$password,$nroRandom) = @_;
    my $socio = undef;
    if (!C4::Context->config('plainPassword')){
	    ($socio) = C4::AR::Authldap::checkPwEncriptada($userid,$password,$nroRandom);
        C4::AR::Debug::debug("Devolviendo el socio".$socio);
	}else{
	    ($socio) = C4::AR::Authldap::checkPwPlana($userid,$password);       
	}
    return $socio;
	
}

=item
    Verifica que la password nueva no sea igual a la que ya tiene el socio.
    Es independiente del flag de plainPassword en meran.conf
    Porque viene del cliente la pass nueva encriptada con AES
    usando como kay la password vieja del socio ( $socio->getPassword )
=cut
sub validarPassword{
    my ($userid,$password,$nuevaPassword,$nroRandom) = @_;
	my $socio       = undef;
    my $ldap        =_conectarLDAP();
    
    #aca dentro ya se comparan que las dos passwords sean iguales
    ($socio) = checkPwEncriptada($userid,$password,$nroRandom);
    
    if (!$socio){
        return undef;
    }

   return ($socio);
}

=item
    FIXME
    FIXME
    FIXME
    FIXME
    FIXME
    FIXME
    FIXME
    FIXME
    FIXME
    FIXME
    FIXME
    
    QUEDA QUE VALIDE LAS CREDENCIALES --- OK
    BUSCAR LOGINS DE LDAP QUE PODAMOS USAR
    RESET PASSWORD EN AMBOS (MYSQL/LDAP) --- OK EN MYSQL
    SET PASSWORD EN LDAP (ESTE DE ACA ABAJO)
    CAPTCHA --- OK
    
    
=cut
sub setearPassword{
    
    my ($socio,$nuevaPassword,$isReset) = @_;
    my $preferencias_ldap               = getLdapPreferences();


 C4::AR::Debug::debug("setearPassword>>> $nuevaPassword");

    my $LDAP_DB_PREF                    = $preferencias_ldap->{'ldap_prefijo_base'};
    my $LDAP_U_PREF                     = $preferencias_ldap->{'ldap_user_prefijo'};
    my $LDAP_USER                       = $LDAP_U_PREF.'='.$socio->getNro_socio().','.$LDAP_DB_PREF;
    my $LDAP_ROOT                       = $preferencias_ldap->{'ldap_bind_dn'};
    my $LDAP_PASS                       = $preferencias_ldap->{'ldap_bind_pw'};
    my $LDAP_OU                         = $preferencias_ldap->{'ldap_grupo'};
    my $LDAP_FILTER                     = $LDAP_U_PREF.'='.$socio->getNro_socio();
    my $ldapMsg                         = undef;
    my $ldap                            =_conectarLDAP();

    $isReset = $isReset || 0;
    
    if ($LDAP_ROOT ne ''){
        $ldapMsg = $ldap->bind( $LDAP_ROOT , password => $LDAP_PASS) or die "$@";
        C4::AR::Debug::debug("bind es $LDAP_ROOT y pass $LDAP_PASS");
        C4::AR::Debug::debug("Authldap => smsj ". $ldapMsg->error. " codigo ". $ldapMsg->code() );
    }else{
        $ldapMsg = $ldap->bind() or die "$@";
        }


    #si esto da error, es porque la codificacion falla, lo cual, seguramente no esté encriptada por ser un reseteo de password
    #si $isReset = 1, la $nuevaPassword ya viene en b64_md5, es el dni del socio hasheado
    
    if (!$isReset){
   	#encriptar con md5_b64
	$nuevaPassword    = C4::AR::Auth::hashear_password($nuevaPassword, 'MD5_B64');
 

    }

#    $ldapMsg = my $result = $ldap->modify(dn=>$LDAP_USER, replace=>{'userPassword'=>$nuevaPassword}); 
    $ldapMsg = $ldap->modify(dn=>$LDAP_USER, replace=>{'userPassword'=>$nuevaPassword}); 
    #LEER http://comments.gmane.org/gmane.comp.lang.perl.modules.ldap/2028
#    $ldap->set_password( user =>$LDAP_U_PREF.'='.$socio->getNro_socio(), newpassword => $nuevaPassword );

}


sub _obtenerPassword{
    
    my ($ldap,$LDAP_DB_PREF,$LDAP_FILTER) = @_;
    my $entries = $ldap->search(
            base   => $LDAP_DB_PREF,
            filter => "($LDAP_FILTER)"
    );
    my $passwordLDAP;
    my $entry       = $entries->entry(0);

    if (defined $entry){
            $passwordLDAP   = $entry->get_value("userPassword");
    }
    
    return $passwordLDAP;

}

sub obtenerPassword{
    
    my ($socio)             = @_;
    my $preferencias_ldap   = getLdapPreferences();

    my $LDAP_DB_PREF        = $preferencias_ldap->{'ldap_prefijo_base'};
    my $LDAP_U_PREF         = $preferencias_ldap->{'ldap_user_prefijo'};
    my $LDAP_USER           = $LDAP_U_PREF.'='.$socio->getNro_socio().','.$LDAP_DB_PREF;
    my $LDAP_ROOT           = $preferencias_ldap->{'ldap_bind_dn'}.','.$LDAP_DB_PREF;
    my $LDAP_PASS           = $preferencias_ldap->{'ldap_bind_pw'};
    my $LDAP_OU             = $preferencias_ldap->{'ldap_grupo'};
    my $LDAP_FILTER         = $LDAP_U_PREF.'='.$socio->getNro_socio();
    my $ldapMsg             = undef;
    my $ldap                =_conectarLDAP();

    if ($LDAP_ROOT ne ''){
        $ldapMsg= $ldap->bind( $preferencias_ldap->{'ldap_bind_dn'} , password => $LDAP_PASS) or die "$@";
        C4::AR::Debug::debug("obtenerPassword : MENSAJE LDAP con ".$preferencias_ldap->{'ldap_bind_dn'} ." y ".$LDAP_PASS. " dio ".$ldapMsg->error);
    }else{
        $ldapMsg= $ldap->bind() or die "$@";
        }
    
    #FIXME ESTO ES UNA PORQUERIA SE REHACE TODA LA CONEXION
    return _obtenerPassword($ldap,$LDAP_DB_PREF,$LDAP_FILTER);
}

=item
    Las passwords vienen siempre encriptadas con AES, usando como key la pass vieja del socio
=cut
sub passwordsIguales{
	my ($nuevaPassword1,$nuevaPassword2,$socio) = @_;

#    OLD
#    my $user_ldap_password = obtenerPassword($socio);
#    $user_ldap_password = C4::AR::Auth::hashear_password($user_ldap_password, 'SHA_256_B64');
#    $nuevaPassword1 = C4::AR::Auth::desencriptar($nuevaPassword1,$user_ldap_password);
#    $nuevaPassword2 = C4::AR::Auth::desencriptar($nuevaPassword2,$user_ldap_password);



    $nuevaPassword1 = C4::AR::Auth::hashear_password($nuevaPassword1, 'MD5_B64');
    $nuevaPassword1 = C4::AR::Auth::hashear_password($nuevaPassword1, C4::AR::Auth::getMetodoEncriptacion());
    $nuevaPassword1 = C4::AR::Auth::hashear_password($nuevaPassword1.C4::AR::Auth::getSessionNroRandom(), C4::AR::Auth::getMetodoEncriptacion());
    
    $nuevaPassword2 = C4::AR::Auth::hashear_password($nuevaPassword2, 'MD5_B64');
    $nuevaPassword2 = C4::AR::Auth::hashear_password($nuevaPassword2, C4::AR::Auth::getMetodoEncriptacion());
    $nuevaPassword2 = C4::AR::Auth::hashear_password($nuevaPassword2.C4::AR::Auth::getSessionNroRandom(), C4::AR::Auth::getMetodoEncriptacion());
    

    return ($nuevaPassword1 eq $nuevaPassword2);	
}
END { }       # module clean-up code here (global destructor)
1;
__END__
