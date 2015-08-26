package C4::AR::Auth;


=head1 NAME

  C4::AR::Auth 

=head1 SYNOPSIS

  use C4::AR::Auth;

=head1 DESCRIPTION

 En este modulo se centraliza todo lo relacionado a la authenticacion del usuario

=head1 VARIABLES DEL meran.conf necesarias

 Hay algunas variables que se deben configurar para controlar el funcionamiento de este modulo:

	charset: controla el charset, en caso de no estar definida utiliza utf8
	plainPassword: controla si se usa la authenticacion de MERAN utilizando el sistema definido internamente con el nroRandom o si utiliza un sistema tradicional simplemente utilizando la password y chequeandola contra un repositorio normal. Por defecto es 0.
	ldapenabled: Define si se utiliza un ldap para la authenticacion, en combinacion con la variables plainPassword se define si es un ldap especialmente formado para soportar el manejo del nroRandom o si es un ldap comun como ser un dominio
	defaultLang: el idioma del sistema, por defecto si no esta definido es es_ES
	expire: controla si las sesiones expiran o no.
	timeout: define el tiempo que demora una sesion en dar timeout. Se usa en conjunto con expire. Si no esta definida, la busca en las preferencias del sistema, y si no esta alli la setea en 600 segundos.


=head1 PREFERENCIAS del sistema necesarias

 Hay algunas variables que se deben configurar para controlar el funcionamiento de este modulo:

	limite_resultados_autocompletables: HELP FIXME
	insecure: HELP FIXME
	habilitar_https: HELP FIXME
	puerto_para_https: HELP FIXME
	defaultissuetype:HELP FIXME
	keeppasswordalive: Define cuantos dias dura una contraseña antes de vencer y ser necesario cambiarla.
	timeout: define el tiempo que demora una sesion en dar timeout. Se usa en conjunto con expire. Si no esta definida en meran.conf la busca en las preferencias del sistema, y si no esta alli la setea en 600 segundos.



=head1 FUNCTIONS

=over 2

=cut

use strict;
use warnings;

require Exporter;
use Digest::MD5 qw(md5_base64);
use Digest::SHA  qw(sha1 sha1_hex sha1_base64 sha256_base64 );
use C4::AR::Usuarios qw(getSocioInfoPorNroSocio);
use Locale::Maketext::Gettext::Functions qw(bindtextdomain textdomain get_handle);
use C4::Context;
use C4::Modelo::SistSesion;
use C4::Modelo::SistSesion::Manager;
use C4::Modelo::CircReserva;
use C4::Modelo::UsrSocio;
use C4::Modelo::PrefFeriado;
use C4::Modelo::UsrLoginAttempts;
use C4::AR::Authldap;
use C4::AR::AuthMysql;
use HTTP::BrowserDetect;

use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS);
my $defaultCodMSG = 'U000';
# set the version for version checking

$VERSION = 1.0;
@ISA = qw(Exporter);
@EXPORT = qw(
		checkauth       
		get_template_and_user
		output_html_with_http_headers
		getSessionUserID
		getSessionNroSocio
		redirectAndAdvice
		hashear_password
		get_html_content
		getMetodoEncriptacion
		buildSocioDataHashFromSession
		buildSocioData
		updateLoggedUserTemplateParams
		updateAuthOrder
		changeEnable
		addMethod
		updateNameMetodo
		resetUserPassword
		changePasswordFromRecover
		checkRecoverLink
		_init_i18n
		getSessionSocioObject
		getSessionType
		printValue
		
);

=item
	Agrega un metodo
=cut
sub addMethod{
	my ($nameMetodo)    = @_;
	my $metodo          = C4::Modelo::SysMetodoAuth->new();
	my $msg_object      = C4::AR::Mensajes::create();
	my $db              = $metodo->db;
	$db->begin_work;
	
	eval{
		$metodo->agregarMetodo($nameMetodo);
		$msg_object->{'error'} = 0;
		C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'MA000', 'params' => []});
		$db->commit;
	};
	if ($@){
		# TODO falta definir el mensaje "amigable" para el usuario informando que no se pudo agregar el proveedor
		&C4::AR::Mensajes::printErrorDB($@, 'B449',"INTRA");
		$msg_object->{'error'}= 1;
		C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'MA001', 'params' => []} ) ;
		$db->rollback;
	}
	return ($msg_object);
}

=item
	Actualiza el nombre del metodo
=cut
sub updateNameMetodo{
	my ($idMetodo,$value)    = @_;
	
	my $metodo = C4::Modelo::SysMetodoAuth::Manager::get_sys_metodo_auth( 
									 query   => [ id => { eq => $idMetodo}], 
							   );
							   
	$metodo->[0]->setMetodo($value);
}


=item
	Actualiza si el metodo esta habilitado o no
=cut
sub changeEnable{
	my ($newValue,$idMetodo)    = @_;
	my $msg_object      = C4::AR::Mensajes::create();
	
	C4::AR::Debug::debug("entro : id : ".$idMetodo. "  : newValue : ".$newValue);
	
	my $metodo = C4::Modelo::SysMetodoAuth::Manager::get_sys_metodo_auth( 
									 query   => [ id => { eq => $idMetodo}], 
							   );
							   
	C4::AR::Debug::debug("metodo : ".$metodo->[0]);
	my $objMetodo;
	$objMetodo = $metodo->[0];
	if($newValue eq "1"){
		$objMetodo->enable();
	}else{
		$objMetodo->disable();
	}    
	
	
	C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'M000', 'params' => []} ) ;
	return ($msg_object);              
}

=item
	Actualiza el orden de los metodos de autenticacion, la tabla sys_metodo_auth
=cut
sub updateAuthOrder{
	my ($newOrderArray) = @_;
	my $msg_object      = C4::AR::Mensajes::create();
	
	# ordeno los ids que llegan desordenados primero, para obtener un clon de los ids, y ahora usarlo de indice para el orden
	# esto es porque no todos los campos de cat_visualizacion_intra se muestran en el template a ordenar ( ej 8 y 9 )
	# entonces no puedo usar un simple indice como id.
	my @array = sort { $a <=> $b } @$newOrderArray;
	
	my $i = 0;
	my @filtros;
	
	# hay que hacer update de todos los campos porque si viene un nuevo orden y es justo ordenado (igual que @array : 1,2,3...)
	# tambien hay que actualizarlo
	foreach my $campo (@$newOrderArray){
	
		my $config_temp   = C4::Modelo::SysMetodoAuth::Manager::get_sys_metodo_auth( 
																	query   => [ id => { eq => $campo}], 
							   );
		my $configuracion = $config_temp->[0];
		
#        C4::AR::Debug::debug("nuevo orden de id : ".$campo." es :  ".@array[$i]);
		
		$configuracion->setOrden($array[$i]);
	
		$i++;
	}
	
	C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'M000', 'params' => []} ) ;

	return ($msg_object);


}


=item 
	DEPRECATED
	Checkea si el browser es uno ideal
	Chromium Browser y Google Chrome lo detecta con el mismo user agent
=cut
sub checkBrowser{

#    my @blacklist = qw(
#        Firefox_4
#        Firefox_3
#        Chrome_10
#        Chrome_9
#        Chrome_8
#        Chrome_7
#        Chrome_6
#        MSIE_8
#        MSIE_7
#        MSIE_6
#        MSIE_5
#        IceWeasel_4
#        IceWeasel_3
#    );
#    my $session         = CGI::Session->load();
#   my $browser         = HTTP::BrowserDetect->new($ENV{'HTTP_USER_AGENT'});
#   my $browser_string  = $browser->browser_string();
#   my $browser_major   = $browser->major();
#   my $search          = $browser_string."_".$browser_major;

#   
#   if ($search ~~ @blacklist){
#       if (!$session->param('check_browser_allowed')){
#            if($session->param('type') eq "opac"){
#                redirectTo(C4::AR::Utilidades::getUrlPrefix().'/checkBrowser.pl?token='.$session->param('token'));
#            }else{
#                redirectTo(C4::AR::Utilidades::getUrlPrefix().'/checkBrowser.pl?token='.$session->param('token'));
#            }    
#       }
#       
#   }
}

=item sub _generarNroRandom

	Función que devuelve un nro random entre 0 100000
	

=cut

sub _generarNroRandom {
	my $nroRandom = (int(rand()*100000));
	C4::AR::Debug::debug("generarNroRandom -> nro generado : " . $nroRandom);
	return $nroRandom;  
}
=item sub 
	Función que devuelve el codigo de mensaje 
=cut

sub getMsgCode{
	my ($session) = CGI::Session->load();
	return ($session->param('codMsg') or $defaultCodMSG);
 
}

=item sub _getExpireStatus
	Devuelve el valor de la variable de contexto que indica si expiran las sesiones o devuelve true si no esta definido este valor
=cut
sub _getExpireStatus{
  my $expire = C4::Context->config("expire");
#         C4::AR::Debug::debug("EXPIRA => ".$expire);
  if (defined($expire)){
	  return ( $expire );
  }else{
	  return (1);
  }
}

=item sub _generarSession

	genera una sesion nueva y carga los parametros a la misma y la devuelve
	Parametros:
	$params: (HASH) con los parametros 

=cut
sub _generarSession {
	my ($params) = @_;

	my $session = new CGI::Session(undef, undef, undef);
	#se setea toda la info necesaria en la sesion
	_actualizarSession($session->id(), ($params->{'userid'} || undef), $params->{'userid'}, $params->{'lasttime'}, $params->{'nroRandom'}, $params->{'type'},$params->{'flagsrequired'}, $params->{'token'}, $session);
	my $expire = _getExpireStatus();
	if ($expire){
	  $session->expire(_getTimeOut().'s');
	}else{
	  $session->expire(0);
	}
	return $session;
}


=item sub _actualizarSession

	Toma una sesion, algunos parametros y actualiza la sesion
	Uso INTERNO
	Parametros:
	$params: $sessionID, $userid, $socioNro, $time, $nroRandom, $type, $flagsrequired, $token, $session

=cut
sub _actualizarSession {
  
  
	my ($sessionID, $userid, $socioNro, $time, $nroRandom, $type, $flagsrequired, $token, $session)= @_;
#     C4::AR::Debug::debug("userid en actualizarSession".$sessionID);
	$type   =   $type || 'opac';
	
	$session->param('sessionID', $sessionID);
	$session->param('userid', $userid);
   #C4::AR::Debug::debug("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! userid en actualizarSession actualizado".$session->param('userid'));
	$session->param('nro_socio', $socioNro);
	$session->param('loggedinusername', $userid);
	$session->param('ip', $ENV{'REMOTE_ADDR'});
	$session->param('lasttime', $time);
	$session->param('nroRandom', $nroRandom);
	$session->param('type', $type); 
	$session->param('secure', ($type eq 'intranet')?1:0); #OPAC o INTRA
	$session->param('flagsrequired', $flagsrequired);
	$session->param('browser', $ENV{'HTTP_USER_AGENT'});
	$session->param('charset', C4::Context->config("charset")||'utf-8'); #se guarda el juego de caracteres
	$session->param('token', $token); #se guarda el token
	#$session->param('SERVER_GENERATED_SID', $sid);


}

=item sub _setLoguinDuplicado

	Esta funcion modifica el flag de todos las sessiones con usuarios duplicados, seteando el mismo a LOGUIN_DUPLICADO
	cuando el usuario remoto con session duplicada intente navegar, sera redireccionado al loguin
	Parametros: 
	$userid, $ip

=cut
sub _setLoguinDuplicado {
	my ($userid, $ip) = @_;
	#Verifica si existe sesiones abiertas con el mismo userid, pero con <> ip, si es asi se les setea un flag de LOGUIN_DIPLICADO
	#y ni bien intente navegar el usuario será redireccionado al loguin.
	my ($sist_sesion_array_ref) = C4::Modelo::SistSesion::Manager->get_sist_sesion( query => [ 
																								ip => { ne => $ip },
																								userid => { eq => $userid }
																					 ]);

	if( scalar($sist_sesion_array_ref->[0]) > 0){
	#si retorna un objeto
		$sist_sesion_array_ref->[0]->setFlag('LOGUIN_DUPLICADO');
		$sist_sesion_array_ref->[0]->save();
	}
}

=item _session_log
	
	Hace log de la sesion

=cut

sub _session_log {
	(@_) or return 0;
#     C4::AR::Debug::debug(join("\n",@_));
}


=item sub _save_session_db

	Esta funcion guarda una session en la base
	Parametros: 
	$sessionID, $userid, $remote_addr, $nroRandom, $token

=cut
sub _save_session_db{
	my ($sessionID, $userid, $remote_addr, $nroRandom, $token) = @_;
	my ($sist_sesion)= C4::Modelo::SistSesion->new();
	$sist_sesion->setSessionId($sessionID);
	$sist_sesion->setUserid($userid);
	$sist_sesion->setIp($remote_addr);
	$sist_sesion->setLasttime(time());
	$sist_sesion->setNroRandom($nroRandom);
	$sist_sesion->setToken($token);
	$sist_sesion->save();

}

=item sub _eliminarSession

Funcion que realmente borra la sesion

=cut

sub _eliminarSession{
	my $session=shift;
	$session->expire('-1');
	$session->delete();
	$session->flush();
}


=item sub _destruirSession

Funcion que destruye la sesion actual, genera una nueva vacia y despues redirige al auth

=cut


sub _destruirSession{
	
	my ($cod_Msg,$template_params) = @_;

	$cod_Msg = $cod_Msg || 'U406';

	my ($session) = CGI::Session->load();
#     
#    C4::AR::Debug::debug("Template params". $template_params);   
 
	_eliminarSession($session);
	
	$session = C4::AR::Auth::_generarSession();
	$session->param('sessionID', undef);

	#redirecciono a loguin y genero una nueva session y nroRandom para que se loguee el usuario
	$session->param('codMsg', $cod_Msg);

#     C4::AR::Debug::debug("WARNING: ¡¡¡¡Se destruye la session y la cookie!!!!!");
	redirectToAuth($template_params)

}

=item sub inicializarAuth

	Esta funcion inicializa la session para autenticar un usuario, se usa en OPAC e INTRA siempre q se quiere autenticar
	Parametros: 
	$query: CGI
	$t_params: parametros para el template

=cut
sub inicializarAuth{
	my ($t_params) = @_;
	#recupero los datos de la sesion anterior que voy a necesitar y luego la destruyo
	my ($session) = CGI::Session->load();
	my $msjCode = getMsgCode();
	 
#     $t_params->{'mensaje'}= C4::AR::Mensajes::getMensaje($msjCode,'INTRA',[]);

	$t_params->{'mensaje'}= C4::AR::Mensajes::getMensaje($msjCode,$t_params->{'type'},[]);

	C4::AR::Debug::debug($t_params->{'mensaje'});
	#se destruye la session anterior
	
	my $locale                      =  $session->param('usr_locale');

	$locale                         = $locale || C4::Context->config('defaultLang');
	
	
	
	
	C4::AR::Debug::debug("LOCALE ANTES DE ELIMIAR LA SESSION: ".$locale);
	_eliminarSession($session);
	#Genero una nueva sesion.
	my %params;
	$params{'userid'}               = undef;
	$params{'loggedinusername'}     = undef;
	$params{'token'}                = '';
	$params{'nroRandom'}            = C4::AR::Auth::_generarNroRandom();
	$params{'borrowernumber'}       = undef;
	$params{'type'}                 = $t_params->{'type'}; #OPAC o INTRA
	$params{'flagsrequired'}        = '';
	$params{'socio_data'}           = undef;
	$session                        = C4::AR::Auth::_generarSession(\%params);

	#Guardo la sesion en la base
	#FIXME C4::AR::Auth::_save_session_db($session->param('sessionID'), undef, $params{'ip'} , $params{'nroRandom'}, $params{'token'});
	C4::AR::Debug::debug("inicializarAuth - > " . $session->param('sessionID') . " nroRandom : " . $session->param('nroRandom'));
	$t_params->{"nroRandom"}        = $params{'nroRandom'};
	$t_params->{"plainPassword"}    = C4::Context->config('plainPassword');
	$t_params->{'socio_data'}       = undef;
	
	$session->param('usr_locale',$locale);

	return ($session);
}

=item get_template_and_user

  my ($template, $borrowernumber, $cookie)
	= get_template_and_user({template_name   => "opac-main.tmpl",
							 query           => $query,
				 type            => "opac",
				 authnotrequired => 1,
				 flagsrequired   => {borrow => 1},
			  });

	This call passes the C<query>, C<flagsrequired> and C<authnotrequired>
	to C<&checkauth> (in this module) to perform authentification.
	See C<&checkauth> for an explanation of these parameters.

	The C<template_name> is then used to find the correct template for
	the page. The authenticated users details are loaded onto the
	template in the HTML::Template LOOP variable C<USER_INFO>. Also the
	C<sessionID> is passed to the template. This can be used in templates
	if cookies are disabled. It needs to be put as and input to every
	authenticated page.

	More information on the C<gettemplate> sub can be found in the
	Output.pm module.


 get_template_and_user({
									template_name => "main.tmpl",
									query => $query,
									type => "intranet",
									authnotrequired => 0,
									flagsrequired => { ui => 'ANY', tipo_documento => 'ANY', accion => 'CONSULTA', entorno => 'undefined'},

=cut
sub get_template_and_user {
	my $in = shift;
	
	my ($user, $session, $flags, $usuario_logueado) = checkauth(         $in->{'query'}, 
																		 $in->{'authnotrequired'}, 
																		 $in->{'flagsrequired'}, 
																		 $in->{'type'}, 
																		 $in->{'change_password'},
																		 $in->{'template_params'}
															 );
	#C4::AR::Debug::debug("la SESSION en el get template and user ".$session);    
	my ($template, $params)     = C4::Output::gettemplate($in->{'template_name'}, $in->{'type'}, $in->{'loging_out'}, $usuario_logueado);
  
	$in->{'template_params'}    = $params;

	if ( $session->param('userid') ) {
		$params->{'nro_socio'}          = $session->param('userid');
		$params->{'socio'}              = C4::AR::Usuarios::getSocioInfoPorNroSocio($params->{'nro_socio'});
		if (!$usuario_logueado) {
			$usuario_logueado = C4::Modelo::UsrSocio->new();
		}
	
		C4::AR::Auth::updateLoggedUserTemplateParams($session,$params, $usuario_logueado);
	
		$params->{'socio_data'}                 = buildSocioDataHashFromSession();
		$params->{'token'}                      = $session->param('token');
		#para mostrar o no algun submenu del menu principal
		$params->{'menu_preferences'}           = C4::AR::Preferencias::getMenuPreferences();
	}

	#Logueo de estadísticas piwik desde el opac 
	if ($in->{'type'} eq 'opac'){
		$params->{'piwik_code'} = C4::AR::Preferencias::getValorPreferencia("piwik_code");
	}

	#se cargan todas las variables de entorno de las preferencias del sistema
	$params->{'limite_resultados_autocompletables'} = C4::AR::Preferencias::getValorPreferencia("limite_resultados_autocompletables");


	return ($template, $session, $params, $usuario_logueado);
}
=item sub _obtenerToken

Funcion que devuelve el token, hay diferencias enter las llamadas tradicionales, tanto sea por AJAX o tradicional y para las llamadas transaccionales comunes

=cut
sub _obtenerToken{
	my $query=shift;
	#Pregunto si es AJAX
	if(defined($ENV{'HTTP_X_REQUESTED_WITH'}) && ($ENV{'HTTP_X_REQUESTED_WITH'} eq 'XMLHttpRequest')){ 
		my $obj = $query->param('obj');
		#PREGUNTO Si ES PARA LAS LLAMADAS AJAX QUE PASSAN UN OBJETO JSON (HELPER DE AJAX)
		if ( defined($obj) ){
			$obj = C4::AR::Utilidades::from_json_ISO($obj);
			C4::AR::Debug::debug("C4::AR::Auth::OBJ".$obj);
			
			#cuando se compre C4::AR::Utilidades::from_json_ISO devuelve un 0
			eval{
				return $obj->{'token'};
			};

			if($@){
				redirectAndAdvice('B460');
			}
	  
		}
	}
	#ESTO ES PARA LAS LLAMADAS AJAX TRADICIONALES (PARAMETROS POR URL) o llamados transaccionales habituales
	return $query->param('token');
}

=item sub getUserLocale
  Devuelve el idioma por defecto del Usuario, lo busca en la sesion, sino en el defaultLanguage o devuelve el esES por defecto
=cut

sub getUserLocale{
	my $session = CGI::Session->load();

	my $locale = $session->param('usr_locale') || C4::Context->config("defaultLang") || 'es_ES';

	return C4::AR::Utilidades::trim($locale);
	
}

=item
  sub i18n
  setea lo necesario para que el filtro C4::AR::Filtros::i18n pueada realizar la internacionalizacion dinámicamente
=cut
sub _init_i18n {
	my($params) = @_;
	my $locale = C4::AR::Auth::getUserLocale();

	Locale::Maketext::Gettext::Functions::bindtextdomain($params->{'type'}, C4::Context->config("locale"));
	Locale::Maketext::Gettext::Functions::textdomain($params->{'type'});
	Locale::Maketext::Gettext::Functions::get_handle($locale);

}

=item sub _cambioIp
Funcion que devuelve si se cambio la ip o no para la misma session
=cut

sub _cambioIp{ 
	my $session=shift;
	if ($session->param('ip') ne $ENV{'REMOTE_ADDR'}) {
				my $time=localtime(time());
				_session_log(sprintf "%20s from logged out at %30s (ip changed from %16s to %16s).\n", 
															$session->param('userid'), 
															$time, 
															$session->param('ip'), 
															$ENV{'REMOTE_ADDR'}
				 );
			return 1;}
	else{
			return 0;
	}
}
=item sub _verificarSession
Devuelve  sesion_valida sin_sesion o sesion_invalida de acuerdo a lo q corresponda
=cut

sub _verificarSession {

	my ($session,$type,$token)=@_;
	my $valido_token=C4::Context->config("token") || 0;
	my $code_MSG;

	C4::AR::Debug::debug("C4::AR::Auth::_verificarSession => type ($type) != type_session (".$session->param('type').")");
	  
	if(defined $session and $session->is_expired()){
		#EXPIRO LA SESION
		$code_MSG='U355';     
		C4::AR::Debug::debug("C4::AR::Auth::_verificarSession => expiro");    
	} else {
		#NO EXPIRO LA SESION
		   
		my $type_session    = C4::AR::Utilidades::capitalizarString($session->param('type'));
		$type               = C4::AR::Utilidades::capitalizarString($type);
		
		if ($type ne $type_session){
			#Esta pasando de la intra al opac o al revés
			C4::AR::Debug::debug("C4::AR::Auth::_verificarSession => SESSION INVALIDA, VENIA DESDE OPAC/INTRA HACIA INTRA/OPAC -- type ($type) != type_session ($type_session)");
		
			if ($type eq "Opac"){
				$code_MSG = "U607";
			}else{
				$code_MSG = "U601";
			}
			
			return ($code_MSG,"sesion_invalida");
		}
		
		_init_i18n({ type => $type });
		if ($session->param('userid')) {

#             C4::AR::Debug::debug("no hay userid");    
			#Quiere decir que la sesion existe ahora hay q Verificar condiciones
			if (_cambioIp($session)){
				$code_MSG='U356';             
				C4::AR::Debug::debug("C4::AR::Auth::_verificarSession => sesion invalido => cambio la ip");  
			} elsif (defined($session->param('flag')) && ($session->param('flag') eq 'LOGUIN_DUPLICADO')){
					$code_MSG='U359';            
					C4::AR::Debug::debug("C4::AR::Auth::_verificarSession => sesion invalido => loguin duplicado");  
			} elsif ((C4::AR::Utilidades::validateString($token)) && (($session->param('token') ne $token) and ($valido_token))){
					$code_MSG='U354';            
					C4::AR::Debug::debug("C4::AR::Auth::_verificarSession => sesion invalido => token invalido");    
				  } else {
						 #ESTA TODO OK
#                        C4::AR::Debug::debug("valida");    
						 return ($code_MSG,"sesion_valida"); 
				  }

		} else {
			#Esto quiere decir que la sesion esta bien pero que no hay nadie logueado
	
			  $code_MSG='000';
			  return ($code_MSG,"sin_sesion");
		}
	}
		 C4::AR::Debug::debug("entra por aca?");
#     C4::AR::Debug::debug("sesion invalida");
	C4::AR::Debug::debug("ENTRA EN _verificarSession");

	$code_MSG='U357';
	return ($code_MSG,"sesion_invalida");
}

sub checkauth {
	C4::AR::Debug::debug("desde checkauth==================================================================================================");
	
	my $socio;
	$_[3]           = 'opac' unless $_[3];
	my $demo        = C4::Context->config("demo") || 0;
	my $token       = _obtenerToken($_[0]);
	my $loggedin    = 0;
	my ($session)   = CGI::Session->load();
  # C4::AR::Debug::debug("antes del if existe sesion en checkauth, nroRandom - > " . $session->param('nroRandom') . " sessionid : " . $session->param('sessionID'));
	my $userid      = undef;
   
	if ($session){
		# C4::AR::Debug::debug("existe sesion en checkauth");
		# C4::AR::Debug::debug("existe sesion en checkauth, nroRandom - > " . $session->param('nroRandom') . " sessionid : " . $session->param('sessionID'));
		$userid     = $session->param('userid') || 0;
	}else{
		# C4::AR::Debug::debug("NO existe sesion en checkauth, se generara");
		$session    = _generarSession();
	}
	my $flags       = 0;
	my $sin_captcha = 0;
	my $time        = localtime(time());
	
	if ($_[1]) {

		C4::AR::Debug::debug("C4::AR::Auth::checkauth => Autorización Requerida");    
		C4::AR::Debug::debug("C4::AR::Auth::checkauth => userid  $userid"); 
		my $socio_object = getSessionSocioObject();
		if ($userid){


					  $socio = C4::AR::Usuarios::getSocioInfoPorNroSocio($session->param('userid'));
					  #Se verifica si el usuario tiene que cambiar la password
					  if ( ($userid) && ( new_password_is_needed($userid, $socio) ) && !$_[4] ) {
						  _change_Password_Controller($_[0], $userid, $_[3], $token);
					  }
			
					  #Se deben actualizar los datos censales? se redirige a editar el perfil
					  if ( (!$session->param('modificar_datos_censales')) &&  (C4::AR::Usuarios::needsDataValidation($session->param('userid')) != 0)) {
										
						 C4::AR::Debug::debug("C4::AR::Auth::_verificarSession => datos censales invalidos");    
						 $session->param('codMsg', 'U505');
						 #Marcamos para evitar loop de redirecciones 
						 $session->param('modificar_datos_censales', 1);
						 _update_Data_Controller($_[0], $userid, $_[3], $token,$session);
					  } 

			buildSocioData($session,$socio_object);
		}
		return ($userid, $session, $flags, $socio_object);
	}

	if ($demo) {
		#Quiere decir que no es necesario una autenticacion
		$userid ="demo";
		$flags  = 1;
		_actualizarSession($userid, $userid,$userid, $time, getSessionNroRandom(), $_[3], $_[2], _generarToken(), $session);

		$socio=C4::Modelo::UsrSocio->new();
		return ($userid, $session, $flags, $socio);
	} else {
		#No es DEMO hay q hacer todas las comprobaciones de la sesion
 
				  my ($code_MSG,$estado) = _verificarSession($session, $_[3], $token);
					C4::AR::Debug::debug("C4::AR::Auth::checkauth => estado?? $estado");
				  if ($estado eq "sesion_valida"){ 
				
					  C4::AR::Debug::debug("C4::AR::Auth::checkauth => session_valida");
					  $socio = C4::AR::Usuarios::getSocioInfoPorNroSocio($session->param('userid'));
					  $flags = $socio->tienePermisos($_[2]);
					  loginSuccess($socio->getNro_socio);
					  _init_i18n({ type => $_[3] });
					  
					  #Se verifica si el usuario tiene que cambiar la password
					  if ( ($userid) && ( new_password_is_needed($userid, $socio) ) && !$_[4] ) {
						  _change_Password_Controller($_[0], $userid, $_[3], $token);
					  }

					  #Se deben actualizar los datos censales? se redirige a editar el perfil
					  if ( (!$session->param('modificar_datos_censales')) &&  (C4::AR::Usuarios::needsDataValidation($session->param('userid')) != 0)) {
										
						 C4::AR::Debug::debug("C4::AR::Auth::_verificarSession => datos censales invalidos");    
						 $session->param('codMsg', 'U505');
						 #Marcamos para evitar loop de redirecciones 
						 $session->param('modificar_datos_censales', 1);
						 _update_Data_Controller($_[0], $userid, $_[3], $token,$session);
					  } 

					  if ($flags) {
						  $loggedin = 1;
					  } else {
						  #redirecciono a una pagina informando q no tiene  permisos
						  $session->param('codMsg', 'U354');
						  $session->param('redirectTo', C4::AR::Utilidades::getUrlPrefix().'/informacion.pl');
						  redirectTo(C4::AR::Utilidades::getUrlPrefix().'/informacion.pl');
					} 
				  }
				  elsif ($estado eq "sesion_invalida") { 
					  # C4::AR::Debug::debug("C4::AR::Auth::checkauth => session_invalida");
					  $_[6] = C4::AR::Utilidades::getUrlPrefix().'/auth.pl';
					  $session->param('codMsg', $code_MSG);
					  $session->param('redirectTo', $_[6]);
					  redirectTo($_[6]); 
				  } 
				  elsif ($estado eq "sin_sesion") { 
					  # C4::AR::Debug::debug("C4::AR::Auth::checkauth => sin_sesion");
					  #ESTO DEBERIA PASAR solo cuando la sesion esta sin iniciar
					  #_destruirSession('U406', $_[5]);
					  inicializarAuth($_[5]);
					  $session->param('codMsg', $code_MSG);
					  }
				  else { 
					  #ESTO MENOS
					  # C4::AR::Debug::debug("C4::AR::Auth::checkauth => ESTO MENOS ???");
					  _destruirSession(($code_MSG || 'U406'), $_[5]);
					  $session->param('codMsg', $code_MSG);
					  $session->param('redirectTo', C4::AR::Utilidades::getUrlPrefix().'/error.pl');
					  redirectTo(C4::AR::Utilidades::getUrlPrefix().'/error.pl'); 
				  }
				  
				  #por aca se permite llegar a paginas que no necesitan autenticarse
				  my $insecure = C4::AR::Preferencias::getValorPreferencia('insecure');
				  if ($loggedin || $_[1] || (defined($insecure) && $insecure)) {
					  
					  # que se hace aca ?
					C4::AR::Debug::debug("C4::AR::Auth::checkauth => por aca se permite llegar a paginas que no necesitan autenticarse");    

				  return ($userid, $session, $flags, $socio);
				  }
				unless ($userid) { 
					#si no hay userid, hay que autentificarlo y no existe sesion
					#No genero un nuevo sessionID
					#con este sessionID puedo recuperar el nroRandom (si existe) guardado en la base, para verificar la password
					my $sessionID      = $session->param('sessionID');
					#recupero el userid y la password desde el cliente
					$userid            = $_[0]->param('userid');
					my $password       = $_[0]->param('password');
					my $nroRandom      = $session->param('nroRandom');
					# C4::AR::Debug::debug("checkauth -> nroRandom en sesion Auth.pm -> " . $nroRandom . " sessionId : " . $sessionID);
					$session->param('username_input',$userid);
					my $error_login    = 0;
					my $mensaje;
					my $cant_fallidos;
					#se verifica la password ingresada
					my ($socio)        = _verificarPassword($userid,$password,$nroRandom);
					my $login_attempts = getSocioAttempts($userid); 
					my $captchaResult;
					if (($login_attempts > 2) && (!$_[0]->url_param('welcome')) && 
						( C4::AR::Utilidades::trim(C4::AR::Preferencias::getValorPreferencia('re_captcha_private_key')) && C4::AR::Utilidades::trim(C4::AR::Preferencias::getValorPreferencia('re_captcha_public_key')))) {
						# se logueo mal mas de 3 veces y se tiene configuración de recaptcha, debo verificar captcha
						
						my $reCaptchaPrivateKey =  C4::AR::Preferencias::getValorPreferencia('re_captcha_private_key');
						my $reCaptchaChallenge  = $_[0]->param('recaptcha_challenge_field');
						my $reCaptchaResponse   = $_[0]->param('recaptcha_response_field');
						use Captcha::reCAPTCHA;
						
						my $c = Captcha::reCAPTCHA->new;
						
						eval{
						   $captchaResult = $c->check_answer($reCaptchaPrivateKey, $ENV{'REMOTE_ADDR'},$reCaptchaChallenge, $reCaptchaResponse);
						};

						C4::AR::Debug::debug("ERROR DE CAPTCHA: ".$captchaResult->{error});
						
						
					} else {  
						#else del  if ($login_attempts > 2 ) que revisa si hay captcha configurado
						$sin_captcha = 1; 
					}  
					if (($sin_captcha || $captchaResult->{is_valid}) && $socio){
						#se valido el captcha, la pass y el user y son validos
						#setea loguins duplicados si existe, dejando logueado a un solo usuario a la vez
						_setLoguinDuplicado($userid,  $ENV{'REMOTE_ADDR'});
						#$socio = C4::AR::Usuarios::getSocioInfoPorNroSocio($userid);
						# TODO todo esto va en una funcion
						$sessionID  = $session->param('sessionID');
						$sessionID .= "_" . $socio->ui->getNombre;
						_actualizarSession($sessionID, $userid, $socio->getNro_socio(), $time, getSessionNroRandom(), $_[3], $_[2], _generarToken(), $session);
						buildSocioData($session,$socio);
						#Logueo una nueva sesion
						_session_log(sprintf "%20s from %16s logged out at %30s.\n", $userid,$ENV{'REMOTE_ADDR'},$time);
						#por defecto no tiene permisos
						if( $flags = $socio->tienePermisos($_[2]) ){
							_realizarOperacionesLogin($_[3],$socio);
						}
						
						# C4::AR::Debug::debug("C4::AR::Auth::checkauth => fin operaciones login");
						
						#Si se logueo correctamente en intranet entonces guardo la fecha
						my $now = Date::Manip::ParseDate("now");
						if ($session->param('type') eq "intranet"){
							$socio->setLast_login($now);
							$socio->setLastLoginAll($now);
							$socio->save();
						}
						C4::AR::Debug::debug("C4::AR::Auth::checkauth => fecha ".$now);
						
						my $referer  = $ENV{'HTTP_REFERER'};
						my $fromAuth = index($referer,'auth.pl');
						$referer     = C4::AR::Utilidades::addParamToUrl($referer,"token",$session->param('token'));
						  
						if ($_[3] eq 'opac') {
							$session->param('redirectTo', C4::AR::Utilidades::getUrlPrefix().'/opac-main.pl?token='.$session->param('token'));
							if ($fromAuth eq "-1"){
								redirectTo($referer);
							}else{                                                              
								redirectToNoHTTPS(C4::AR::Utilidades::getUrlPrefix().'/opac-main.pl?token='.$session->param('token'));
							}
							# #                               $session->secure(0);
						}else{
							# si es estudiante no puede loguearse en la INTRA
							if($socio->getCredentialType() eq "estudiante"){
								$session->param('redirectTo', C4::AR::Utilidades::getUrlPrefix().'/auth.pl?token='.$session->param('token'));
								redirectTo(C4::AR::Utilidades::getUrlPrefix().'/auth.pl?token='.$session->param('token'));
							}else{
								$session->param('redirectTo', C4::AR::Utilidades::getUrlPrefix().'/mainpage.pl?token='.$session->param('token'));
								redirectTo(C4::AR::Utilidades::getUrlPrefix().'/mainpage.pl?token='.$session->param('token'));
							}
							
						}
					} else {  # if ($sin_captcha || $captchaResult->{is_valid} ) - INGRESA CAPTCHA INVALIDO
						if ($socio) {$code_MSG='U425';}
						elsif ($userid) {     
							   
							   $code_MSG='U357';
						}
						$session->param('codMsg', $code_MSG);
						loginFailed($userid);
						$cant_fallidos = getSocioAttempts($userid);
						if ($cant_fallidos > 0){
								$_[5]->{'loginFailed'} = 1;
						}
						if (!$sin_captcha && $cant_fallidos >= 3){
								$_[5]->{'mostrar_captcha'} = 1;
						}  
					}
			if ($_[0]->url_param('welcome')){
				$_[5]->{'loginAttempt'} = 0;
				$mensaje = 'U000';
			}
			_destruirSession($mensaje, $_[5]);
	  }# end unless ($userid)
				  
	}# el else de DEMO
}# end checkauth

=item sub _realizarOperacionesLogin

Funcion que realiza todas las operaciones asociadas a un inicio de sesion como ser:
- revisar si los dias anteriores huubo actividad en la biblioteca, en aso de no haberla se marcan en la base como días feriados 
- Dar de baja reservas de acuerdo a las sanciones

=cut

sub _realizarOperacionesLogin{
	my ($type,$socio)=@_;
	 C4::AR::Debug::debug("_realizarOperacionesLOGIN=> LOGIN\n");
	my $dateformat = C4::Date::get_date_format();
	my $lastlogin= C4::AR::Usuarios::getLastLoginTime();
	if ($type eq 'intranet') {
		#Se entran a realizar las rutinas solo cuando es intranet
		my $auxlastlogin= C4::Date::format_date($lastlogin,$dateformat);
		my $prevWorkDate = C4::Date::format_date(Date::Manip::Date_PrevWorkDay("today",1),$dateformat);
		my $enter=0;
		if ($lastlogin){
			while (Date::Manip::Date_Cmp($auxlastlogin,$prevWorkDate)<0) {
				
				C4::AR::Debug::debug("_realizarOperacionesLOGIN=> COMPARACION ll=".$auxlastlogin." prev=".$prevWorkDate);
				#Se recorren todos los dias entre el lastlogin y el dia previo laboral a hoy, si en esos dias no hubo actividad se marca como no activo al dia en la bdd
				my $dias=Date::Manip::Date_IsWorkDay($auxlastlogin);
				C4::AR::Debug::debug("_realizarOperacionesLOGIN=> dias ".$dias);
				my $nextWorkingDay=C4::Date::format_date(Date::Manip::Date_NextWorkDay($auxlastlogin,$dias),$dateformat);
				C4::AR::Debug::debug("_realizarOperacionesLOGIN=> nextWorkingDay ".$nextWorkingDay);

				if(Date::Manip::Date_Cmp($nextWorkingDay,$prevWorkDate)<=0) {
					   if (C4::AR::Utilidades::setFeriado(C4::Date::format_date_in_iso($nextWorkingDay,$dateformat),"true","Biblioteca sin actividad")){
							C4::AR::Debug::debug("_realizarOperacionesLOGIN=> agregando dia sin actividad ".$nextWorkingDay);
						}
					}
				$auxlastlogin=$nextWorkingDay;
				$enter=1;
			}
			if ($enter) {
				#Se actuliza el archivo con los feriados (.DateManip.cfg) solo si se dieron de alta nuevos feriados en 
				#el while anterior
				my ($count,@holidays)= C4::AR::Utilidades::getholidays();
				C4::AR::Utilidades::savedatemanip(@holidays);
			}
			#Genera una comprobacion una vez al dia, cuando se loguea el primer usuario
			my $today = C4::Date::format_date_in_iso(Date::Manip::ParseDate("today"),$dateformat);

		C4::AR::Debug::debug("_realizarOperaciones=> TODAY = ".$today);
		C4::AR::Debug::debug("_realizarOperaciones=> LASTLOGIN = ".$auxlastlogin);
		C4::AR::Debug::debug("_realizarOperaciones=> Date_Cmp = ".Date::Manip::Date_Cmp($auxlastlogin,$today));
			if (Date::Manip::Date_Cmp($auxlastlogin,$today)<0) {
				# lastlogin es anterior a hoy
				##Si es un usuario de intranet entonces se borran las reservas de todos los usuarios sancionados
					 C4::AR::Debug::debug("_realizarOperaciones=> t_operacionesDeINTRA\n");
					_operacionesDeINTRA($socio);     
			}
		}#end if ($lastlogin)
	}# end if ($type eq 'intra')
	elsif ($type eq 'opac') {
		#Si es un usuario de opac que esta sancionado entonces se borran sus reservas
		_operacionesDeOPAC($socio);
	} 
}


sub getSessionSocioObject {
	my ($session) = @_;
	unless($session){
		$session = CGI::Session->load();
	}
	
	
	if ($session->param('nro_socio')){
		return C4::AR::Usuarios::getSocioInfoPorNroSocio(getSessionNroSocio());
	}else{
		return C4::Modelo::UsrSocio->new();
	}
}

sub getSessionType{
	my ($session) = @_;

	unless($session){
		$session = CGI::Session->load() || CGI::Session->new();
	}

	if ($session->param('type')){
		return ($session->param('type'));
	}
	
	return ('opac');
}

sub getSessionNroRandom {
	my ($session) = @_;
	unless($session){
		$session = CGI::Session->load() || CGI::Session->new();
	}
	
	if ($session->param('nroRandom')){
		return $session->param('nroRandom');
	} else {
		my $nroRandom = _generarNroRandom();        
		$session->param('nroRandom',$nroRandom);

		return $nroRandom;
	}
}


=item sub getSessionUserID

	obtiene el userid de la session
	Parametros: 
	$session

=cut
sub getSessionUserID {
	my ($session) = @_;
	unless($session){
		$session = CGI::Session->load();
	}
	return $session->param('userid');
}

#Este método retorna el método utilizado por el socio para iniciar sesión (el efectivo)
sub getSessionAuthMethod{
	my ($session) = @_;
	unless($session){
		$session = CGI::Session->load();
	}
	return $session->param('last_auth_method');
}

=item sub getSessionNroSocio

	obtiene el nroSocio de la session
	Parametros: 
	$session

=cut
sub getSessionNroSocio {
	my $session= CGI::Session->load();
	return $session->param('nro_socio') || undef;
}


=item sub output_html_with_http_headers

	imprime el header y procesa el template
	Parametros: 
	$template: template que se creo anteriomente
	$params: parametros para el template
	$session: sesion acutal

=cut
sub output_html_with_http_headers {
	my($template, $params, $session) = @_;
	print_header($session, $params);
	$template->process($params->{'template_name'},$params) || die "Template process failed: ", $template->error(), "\n";
	exit;
}

=item sub print_header
Funcion que genera y decide si se envia o no la cookie

=cut

sub print_header {
	my($session, $template_params) = @_;
	my $query = new CGI;
	my $cookie = undef;
	my $secure;
	if(_isOPAC($template_params)){
		#si la conexion no es segura no se envía la cookie, en el OPAC la conexion no es segura
		$secure = 0;
	}else{
		$secure = 1;
	}
	$cookie = new CGI::Cookie(  
								-secure     => $secure, 
								-httponly   => 1, 
								-name       => $session->name, 
								-value      => $session->id, 
								-expires    => $session->expire ? '+' .$session->expire. 's' : 0, 
							);
							
#En el header podría ir esto para la parte de las user pictures, 
# pero no vale la pena no cachear me parece por algo que se hace una vez cada tanto
#                         -Cache_Control => join(', ', qw(
#                                                            private
#                                                            no-cache
#                                                            no-store
#                                                            must-revalidate
#                                                            max-age=0
#                                                            pre-check=0
#                                                            post-check=0
#                                                        )),
							
	print $query->header(   -cookie=>$cookie, 
							-type=>'text/html', 
							 charset => C4::Context->config("charset")||'UTF-8', 
							 "Cache-control: public",
						 );
}


=item sub _isOPAC

	Indica si es un requerimiento desde el OPAC o desde la INTRA
	Parametros: 
	$template: template que se creo anteriomente

=cut
sub _isOPAC {
	my($template_params) = @_;
	$template_params->{'type'} = $template_params->{'type'} || 'opac';
	return (($template_params->{'type'} eq 'opac')?1:0);
}


=item sub buildSocioData

	Funcion que a partir del socio fija los parametros para la sesion
	Parametros: la sesion y el socio
=cut

sub buildSocioData{

	my ($session,$socio) = @_;
	use C4::Modelo::UsrSocio;
	
	$session->flush();
	$session->param('urs_theme', $socio->getTheme());
	$session->param('usr_theme_intra', $socio->getThemeINTRA());
	$session->param('last_auth_method', $socio->getLastAuthMethod());
	$session->param('usr_locale', $socio->getLocale());
	$session->param('usr_apellido', $socio->persona->getApellido());
	$session->param('usr_nombre', $socio->persona->getNombre());
	$session->param('usr_tiene_foto', $socio->tieneFoto(getSessionType()));
	$session->param('usr_documento_nombre', $socio->persona->documento->nombre());
	$session->param('usr_documento_version', $socio->persona->getVersion_documento());
	$session->param('usr_nro_documento', $socio->persona->getNro_documento());
	$session->param('usr_calle', $socio->persona->getCalle());

	if($socio->persona->getCiudad){
		$session->param('usr_ciudad_nombre', $socio->persona->ciudad_ref->getNombre());
		$session->param('usr_ciudad_id',$socio->persona->ciudad_ref->id);
	} 

	
	$session->param('usr_categoria_desc', $socio->categoria->getDescription());
	$session->param('usr_fecha_nac', $socio->persona->getNacimiento());
	$session->param('usr_sexo', $socio->persona->getSexo());
	$session->param('usr_telefono', $socio->persona->getTelefono());
	$session->param('usr_alt_telefono', $socio->persona->getAlt_telefono());
	$session->param('usr_email', $socio->persona->getEmail());
	$session->param('usr_legajo', $socio->persona->getLegajo());
	$session->param('usr_credential_type', $socio->getCredentialType());
	$session->param('usr_permisos_opac', $socio->tienePermisosOPAC);
	$session->param('remindFlag', $socio->getRemindFlag());
	
	$session->flush();
}

sub buildSocioDataHashFromSession{

	my ($session) = CGI::Session->load();    
	
	my %socio_data;
	$socio_data{'usr_apellido'}             = $session->param('usr_apellido');
	$socio_data{'usr_nombre'}               = $session->param('usr_nombre');
	$socio_data{'usr_tiene_foto'}           = $session->param('usr_tiene_foto');
	$socio_data{'usr_nro_socio'}            = $session->param('nro_socio');
	$socio_data{'usr_permisos_opac'}        = $session->param('usr_permisos_opac');
	$socio_data{'usr_documento_nombre'}     = $session->param('usr_documento_nombre');
	$socio_data{'usr_documento_version'}    = $session->param('usr_documento_version');
	$socio_data{'usr_nro_documento'}        = $session->param('usr_nro_documento');
	$socio_data{'usr_calle'}                = $session->param('usr_calle');
	$socio_data{'usr_ciudad_nombre'}        = $session->param('usr_ciudad_nombre');
	$socio_data{'usr_categoria_desc'}       = $session->param('usr_categoria_desc');
	$socio_data{'usr_fecha_nac'}            = $session->param('usr_fecha_nac');
	$socio_data{'usr_sexo'}                 = $session->param('usr_sexo');
	$socio_data{'usr_telefono'}             = $session->param('usr_telefono');
	$socio_data{'usr_alt_telefono'}         = $session->param('usr_alt_telefono');
	$socio_data{'usr_email'}                = $session->param('usr_email');
	$socio_data{'usr_legajo'}               = $session->param('usr_legajo');
	$socio_data{'ciudad_ref'}{'id'}         = $session->param('usr_ciudad_id'); 
	$socio_data{'remindFlag'}               = $session->param('remindFlag'); 
	$socio_data{'usr_credential_type'}      = $session->param('usr_credential_type'); 
	$socio_data{'object'}                   = C4::AR::Usuarios::getSocioInfoPorNroSocio($socio_data{'usr_nro_socio'});
	
	return (\%socio_data);
}

sub updateLoggedUserTemplateParams{
	my ($session,$t_params,$socio) = @_;
	
	buildSocioData($session,$socio);
	$t_params->{'socio_data'} = buildSocioDataHashFromSession();
}

=item sub _getTimeOut

	TimeOut para la sesion

	Parametros: 

=cut
sub _getTimeOut {
	my $timeout = C4::Context->config('timeout')|| C4::AR::Preferencias::getValorPreferencia('timeout') ||600;
	return $timeout;
}


=item sub prepare_password

	Esta funcion "prepara" la password para ser guardada en la base de datos
	este es el tratamiento actual que se le esta dando a la password antes de guardar en la base de datos,
	si cambia, solo deberia cambiarse este metodo

	Parametros: 
	$password

=cut

sub prepare_password{
	my ($password) = @_;
	#primero se hashea la pass con MD5 (esto se mantiene por compatibilidad hacia atras KOHA V2), luego con SHA_256_B64
	$password = C4::AR::Utilidades::trim($password);
#     C4::AR::Debug::debug("hashear_password=> "._hashear_password(_hashear_password($password, 'MD5_B64'), 'SHA_256_B64'));
	return hashear_password(hashear_password($password, 'MD5_B64'), 'SHA_256_B64');
}


=item sub desencriptar

	Esta funcion desencripta el texto_a_desencriptar con la clave $key usando AES
	Parametros: 
	$texto_a_desencriptar
	$key= clave para desencriptar

=cut
sub desencriptar{
	my ($texto_a_desencriptar, $key) = @_;
	use Crypt::CBC;
	use MIME::Base64;
	my  $cipher = Crypt::CBC->new( 
									-key    => $key,
									-cipher => 'Rijndael',
									-salt   => 1,
							);


	my $plaintext = $cipher->decrypt(decode_base64($texto_a_desencriptar));    

	return C4::AR::Utilidades::trim($plaintext);
}

=item sub _change_Password_Controller

	Esta funcion se encarga de manejar el cambio de la password
	Parametros: 
	$dbh, $query, $userid, $type

=cut
sub _change_Password_Controller {
	my ($query, $userid, $type, $token) = @_;
	if ($type eq 'opac') {
		C4::AR::Debug::debug("redirigiendo al OPAC ------------------------ ");
			redirectTo(C4::AR::Utilidades::getUrlPrefix().'/change_password.pl?token='.$token);
	} else {
			redirectTo(C4::AR::Utilidades::getUrlPrefix().'/usuarios/change_password.pl?token='.$token);
	}
}

=item sub _update_Data_Controller

	Esta funcion se encarga de manejar la actualización de datos censales
	Parametros: 
	$dbh, $query, $userid, $type

=cut
sub _update_Data_Controller {
	my ($query, $userid, $type, $token, $session) = @_;
	if ($type eq 'opac') {
		if(C4::AR::Preferencias::getValorPreferencia("user_data_validation_required_opac")){
			#Se permiten actualizar los datos desde el opac?
			C4::AR::Debug::debug("redirigiendo en OPAC datos censales ------------------------ ");
			redirectTo(C4::AR::Utilidades::getUrlPrefix().'/opac-actualizar_datos_censales.pl?token='.$token);
		}else{
			#redirecciono a una pagina informando que no se permite actualizar
			redirectAndAdvice('U507');
		}
	} else {
		if(C4::AR::Preferencias::getValorPreferencia("user_data_validation_required_intra")){
			#Se permiten actualizar los datos desde el opac?
			C4::AR::Debug::debug("redirigiendo en INTRA datos censales ------------------------ ");
			redirectTo(C4::AR::Utilidades::getUrlPrefix().'/usuarios/reales/datosUsuario.pl?nro_socio='.$userid.'&token='.$token);
		}else{
			#redirecciono a una pagina informando que no se permite actualizar
			redirectAndAdvice('U507');
		}

	}
}
=item sub cerrarSesion

Funcion que cierra la sesion generando una nueva

=cut

sub cerrarSesion{
	my ($t_params) = @_;

 
	#se genera un nuevo nroRandom para que se autentique el usuario
	my $nroRandom       = C4::AR::Auth::_generarNroRandom();
	#genero una nueva session
	my ($session)           = CGI::Session->load();
	my $msjCode             = 'U358';
	my $type                = $t_params->{'type'} || 'OPAC';
	
	$t_params->{'mensaje'}  = C4::AR::Mensajes::getMensaje($msjCode,$type,[]);
	#se destruye la session anterior
	_eliminarSession($session);
	#se genera una nueva session
	my %params;
	$params{'userid'}               = '';
	$params{'loggedinusername'}     = '';
	$params{'token'}                = '';
	$params{'nroRandom'}            = '';
	$params{'borrowernumber'}       = '';
	$params{'type'}                 = $type;
	$params{'flagsrequired'}        = '';
	$t_params->{'sessionClose'}     = 1;
	$session = C4::AR::Auth::_generarSession(\%params);
	$session->param('codMsg', 'U358');
   
	redirectToAuth($t_params);
}

=item sub _generarToken

	genera el token para evitar CSRF a partir del sessionID, le hace un SHA(sessionID)
	Parametros: 

=cut
sub _generarToken {
	my $session = CGI::Session->load();
	my $digest;
	#se le hace SHA al sessionID para generar el TOKEN 
	$digest = sha1_hex($session->id);
	my $token= $digest;
	return $token;
}

sub session_destroy {
	my $session = new CGI::Session(undef, undef, undef);
	return $session;
}


# DEPRECATED
sub _checkRequisito{
	my ($socio) = @_;

	my $status = 1;
	
	if (C4::AR::Preferencias::getValorPreferencia("requisito_necesario") ){
		my $cumple_condicion = $socio->getCumple_requisito;
		$status = $status && ($cumple_condicion && ($cumple_condicion ne "0000000000:00:00"));
	}
	
	$status = $status && ($socio->getActivo);

	return($status);
	
}

=item sub _verificarPassword

	Esta funcion verifica si el usuario y la password ingresada son valida, ya se en LDAP o en la base, segun configuracion de preferencia
	Parametros:
	$userid, $password, $nroRandom

=cut
sub _verificarPassword {
	my ($userid, $password, $nroRandom) = @_;
	my ($socio) = undef;
	my $metodosDeAutenticacion= C4::AR::Preferencias::getMetodosAuth();
	my $metodo;

	while (scalar(@$metodosDeAutenticacion) && (!(defined $socio)) ) {
			$metodo = shift(@$metodosDeAutenticacion);
			C4::AR::Debug::debug("Socio ".$userid." METODO ".$metodo . " nroRandom " . $nroRandom);
			$socio  = _autenticar($userid, $password, $nroRandom, $metodo);
	}

	return $socio;
}
=item sub _autenticar
	Esta funcion es la que hay que modificar si se cambia el conjunto de metodos de autenticacion, por ejemplo agregando otra cosa como podria ser openid

=cut

sub _autenticar{
  use Switch;
  my ($userid, $password, $nroRandom,$metodo) = @_;
  my $socio = undef;
  eval{
    C4::AR::Debug::debug("metodo ".$metodo." userid ".$userid . " nroRandom : " . $nroRandom);
    switch ($metodo){
			case "ldap" {
				($socio) = C4::AR::Authldap::checkPassword($userid,$password,$nroRandom); 
				C4::AR::Debug::debug("Devolviendo casi al final el socio".$socio);      
			}
			case "mysql"{
				($socio) = C4::AR::AuthMysql::checkPassword($userid,$password,$nroRandom);       
				C4::AR::Debug::debug("Vamos bien???".$socio);      
			}
			else{
			}
    } #end switch
		# if ( (defined $socio) && (! _checkRequisito($socio))  ){
		C4::AR::Debug::debug("Auth => socio->cumpleRequisito() " . $socio->cumpleRequisito());	
		if ( (defined $socio) && ( !$socio->cumpleRequisito() ) ) {
			C4::AR::Debug::debug("Auth.pm => NO CUMPLE REQUISITO ".$socio);      
			$socio = undef ;
	
		}elsif (defined $socio){
			$socio->setLastAuthMethod($metodo);
		}
	};
		
	return ($socio);
}

sub redirectTo {
	my ($url) = @_;
#     C4::AR::Debug::debug("redirectTo=>");  
	#para saber si fue un llamado con AJAX
	if(C4::AR::Utilidades::isAjaxRequest()){
	#redirijo en el cliente
#      C4::AR::Debug::debug("redirectTo=> CLIENT_REDIRECT");        
		my $session = CGI::Session->load();
		# send proper HTTP header with cookies:
		$session->param('redirectTo', $url);
#         C4::AR::Debug::debug("redirectTo=> url: ".$url);
		print_header($session);
		print 'CLIENT_REDIRECT';
		exit;
	}else{
		my $session = CGI::Session->load();  
		C4::AR::Debug::debug($url);   
#        C4::AR::Debug::debug("redirectTo=> SERVER_REDIRECT");       
		my $input = CGI->new(); 
		print $input->redirect( 
			-location => $url, 
			-status => 301,
		); 
#       C4::AR::Debug::debug("redirectTo=> url: ".$url);
		exit;
	}
}

sub redirectToAuth {
	my ($template_params) = @_;
		
	my $url;
	$url = C4::AR::Utilidades::getUrlPrefix().'/auth.pl';
	if($template_params->{'loginAttempt'}){
		$url = C4::AR::Utilidades::addParamToUrl($url,'loginAttempt',1);
	}elsif($template_params->{'sessionClose'}){
		$url = C4::AR::Utilidades::addParamToUrl($url,'sessionClose',1);
	} 
	if($template_params->{'mostrar_captcha'}){
		$url = C4::AR::Utilidades::addParamToUrl($url,'mostrarCaptcha',1);
	} 
	if($template_params->{'loginFailed'}){
		$url = C4::AR::Utilidades::addParamToUrl($url,'loginFailed',1);
	}

	redirectTo($url);    
}

sub redirectToNoHTTPS {
	my ($url) = @_;
#   C4::AR::Debug::debug("\n");
#   C4::AR::Debug::debug("redirectToNoHTTPS=>");
	#PARA SACAR EL LOCALE ELEGIDO POR EL SOCIO
	my $socio = C4::AR::Auth::getSessionNroSocio();
	$socio = C4::AR::Usuarios::getSocioInfoPorNroSocio($socio) || C4::Modelo::UsrSocio->new();
	#para saber si fue un llamado con AJAX
	my $url_server      = C4::AR::Preferencias::getValorPreferencia('serverName');
	my $opac_port       = ":".(C4::Context->config('opac_port')||'80');
	my $server_port     = ":".$ENV{'SERVER_PORT'};
	my $SERVER_URL       =(C4::AR::Utilidades::trim($url_server)||($ENV{'SERVER_NAME'})).$server_port;
	my $SERVER_URL_OPAC  =(C4::AR::Utilidades::trim($url_server)||($ENV{'SERVER_NAME'})).$opac_port;

	if(C4::AR::Utilidades::isAjaxRequest()){
	#redirijo en el cliente
#      C4::AR::Debug::debug("redirectToNoHTTPS=> CLIENT_REDIRECT");         
		my $session = CGI::Session->load();
		# send proper HTTP header with cookies:
		$session->param('redirectTo', $url);
#       C4::AR::Debug::debug("SESSION url: ".$session->param('redirectTo'));
#       C4::AR::Debug::debug("redirectToNoHTTPS=> url: ".$url);
		print_header($session);
		print 'CLIENT_REDIRECT';
		exit;
	}else{
		#redirijo en el servidor
		 C4::AR::Debug::debug("redirectToNoHTTPS=> SERVER_REDIRECT \n\n\n");    
		my $input = CGI->new(); 
		print $input->redirect( 
			-location => "http://".$SERVER_URL_OPAC.$url, 
			-status => 301,
		); 
#         C4::AR::Debug::debug("redirectTo=> url: ".$url);
		exit;
	}
}

=item sub _opac_logout

	redirecciona a al login correspondiente

=cut
sub _opac_logout{

	if ( C4::AR::Preferencias::getValorPreferencia("habilitar_https") ){
	#se encuentra habilitado https
		redirectToHTTPS(C4::AR::Utilidades::getUrlPrefix().'/login/auth.pl');
	}else{
		redirectTo(C4::AR::Utilidades::getUrlPrefix().'/auth.pl');
	}
}

sub redirectToHTTPS {
	my ($url) = @_;
#     C4::AR::Debug::debug("\n");
#     C4::AR::Debug::debug("redirectToHTTPS=> \n");
	my $puerto = C4::AR::Preferencias::getValorPreferencia("puerto_para_https")||'80';
	my $protocolo = "https";
	#para saber si fue un llamado con AJAX
	if(C4::AR::Utilidades::isAjaxRequest()){
	#redirijo en el cliente
#         C4::AR::Debug::debug("redirectToHTTPS=> CLIENT_REDIRECT\n");         
		my $session = CGI::Session->load();
		# send proper HTTP header with cookies:
		$session->param('redirectTo', $url);
#         C4::AR::Debug::debug("redirectToHTTPS=> url: ".$url."\n");
		print_header($session);
		print 'CLIENT_REDIRECT';
	}else{
	#redirijo en el servidor
#         C4::AR::Debug::debug("redirectToHTTPS=> SERVER_REDIRECT\n");    
		my $input = CGI->new(); 
		print $input->redirect( 
			-location => $protocolo."://".$ENV{'SERVER_NAME'}.":".$puerto.$url,  
			-status => 301,
		); 
#         C4::AR::Debug::debug("redirectTo=> url: ".$url."\n");
	}
}
=item sub _operacionesDeOPAC

Funcion que realiza las operaciones para un socio cuando se esta logueando en el opac de ser necesario.
Por ejemplo borrar las reservas que tiene si esta sancionado

=cut

sub _operacionesDeOPAC{
	my ($socio) = @_;
#     C4::AR::Debug::debug("_operacionesDeOPAC !!!!!!!!!!!!!!!!!");
	my $msg_object                          = C4::AR::Mensajes::create();
	my $db                                  = $socio->db;
	$db->{connect_options}->{AutoCommit}    = 0;
	$db->begin_work;
	eval{
		#Si es un usuario de opac que esta sancionado entonces se borran sus reservas
		my ($status_hash)= C4::AR::Sanciones::permisoParaPrestamo($socio, C4::AR::Preferencias::getValorPreferencia("defaultissuetype"));
		
		my $isSanction           =$status_hash->{'deudaSancion'};
		
		my $regular = $socio->esRegular;
		my $userid = $socio->getNro_socio();
		if ($isSanction || !$regular ){
			&C4::AR::Reservas::cancelar_reserva_socio($userid, $socio);
		}

		$db->commit;
	};
	if ($@){
	  #Se loguea error de Base de Datos
	  &C4::AR::Mensajes::printErrorDB($@, 'B411',"OPAC");
	  #Se setea error para el usuario
	  $msg_object->{'error'}= 1;
	  C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'R010', 'params' => []} ) ;
	  $db->rollback;
	}
	$db->{connect_options}->{AutoCommit} = 1;
}
=item _operacionesDeOPAC

	Funcion que se invoca cuando ingresa el primer usuario del día en intranet y realiza todas las operaciones necesarias como
	- borrar las reservas de los usuarios sancionados
	- se borran las reservas de los usuarios que no son alumnos regulares
	- se borran las reservas vencidas
	
=cut

sub _operacionesDeINTRA{
	my ($socio) = @_;
	 C4::AR::Debug::debug("t_operacionesDeINTRA !!!!!!!!!!!!!!!!!");
	my $msg_object= C4::AR::Mensajes::create();
	my $db= $socio->db;
	$db->{connect_options}->{AutoCommit} = 0;
	$db->begin_work;
	my $userid = $socio->getNro_socio();
	my $responsable = 'Sistema';
	eval{
		my $reserva=C4::Modelo::CircReserva->new(db=> $db);

		#Se borran las reservas vencidas
		C4::AR::Debug::debug("_operacionesDeINTRA=> Se cancelan las reservas vencidas ");
		$reserva->cancelar_reservas_vencidas($responsable);

		#Ademas, se borran las reservas vencidas de usuarios con prestamos vencidos
		C4::AR::Debug::debug("_operacionesDeINTRA=> Se cancelan las reservas de usuarios con prestamos vencidos ");
		$reserva->cancelar_reservas_usuarios_morosos($responsable);

		#Ademas, se borran las reservas de todos los usuarios sancionados
				C4::AR::Debug::debug("_operacionesDeINTRA=> Se cancelan las reservas de todos los usuarios sancionados ");
		$reserva->cancelar_reservas_sancionados($responsable);

		#Ademas, se borran las reservas de los usuarios que no son alumnos regulares
		C4::AR::Debug::debug("_operacionesDeINTRA=> Se cancelan las reservas de los usuarios que no son alumnos regulares ");
		$reserva->cancelar_reservas_no_regulares($responsable);
	
		$db->commit;
	};
	if ($@){
		#Se loguea error de Base de Datos
		&C4::AR::Mensajes::printErrorDB($@, 'B409',"INTRA");
		#Se setea error para el usuario
		$msg_object->{'error'}= 1;
		C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'R010', 'params' => []} ) ;
		$db->rollback;
	}

	$db->{connect_options}->{AutoCommit} = 1;
}


=item sub _checkpw

	verifica la password
	Parametros:
	$userid, $password, $nroRandom

=cut
sub _checkpw {
	my ($userid, $password, $nroRandom) = @_;
	my ($socio)= C4::AR::Usuarios::getSocioInfoPorNroSocio($userid);
	if ($socio){
		 C4::AR::Debug::debug("_checkpw=> busco el socio ".$userid."\n");
		 return _verificar_password_con_metodo($password, $socio, $nroRandom, getMetodoEncriptacion());
	}
	return undef;
}

sub getMetodoEncriptacion {
	return 'SHA_256_B64';
}



=item sub hashear_password

	Hashea una password segun el metodo pasado por parametro
	si se agrega otro metodo de encriptacion se debe agregar aca
	
	Parametros:
	$password: password del usuario a hashear
	$metodo: MD5, SHA

=cut
sub hashear_password {
	my ($password, $metodo) = @_;
	if($metodo eq 'SHA'){
		return sha1_hex($password);
	}elsif($metodo eq 'SHA_256_B64'){
		return sha256_base64($password);
	}elsif($metodo eq 'MD5_B64'){
		return md5_base64($password);
	}
}


=item sub new_password_is_needed

	Verifica si el usuario tiene que cambiar o no la password
	
	Hay dos campos (lastchangepassword, changepassword) en urs_socio 
	lastchangepassword: fecha en la que el socio cambio la password por ultima vez
	changepassword: booleano, indica si la password debe ser cambiada o no
	Parametros:
	$nro_socio

=cut
sub new_password_is_needed {
	my ($nro_socio, $socio) = @_;
	if (!$socio) {
		$socio = C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);
	}
	my $days = C4::AR::Preferencias::getValorPreferencia("keeppasswordalive");
	if ($days ne '0') {
		my $err;
		my $today = Date::Manip::DateCalc("today","- ".$days." days",\$err);
		my $lastChangePasswordDate = Date::Manip::ParseDate($socio->getLast_change_password);
		return ( $socio->getChange_password && ((Date::Manip::Date_Cmp($today,$lastChangePasswordDate)) > 0) );
	} else {
		return ( $socio->getChange_password && $socio->getLast_change_password eq '0000-00-00');
	}

}

sub redirectAndAdvice{
	my ($cod_msg,$destination)= @_;
	my ($session) = CGI::Session->load();
	$defaultCodMSG = $cod_msg;

	$session->param('codMsg',$cod_msg);
	if(!$destination){
		$destination=C4::AR::Utilidades::getUrlPrefix().'/informacion.pl';
	}
	C4::AR::Auth::redirectTo($destination);
}

sub get_html_content {
	my($template, $params) = @_;
	my $out = '';
	$template->process($params->{'template_name'},$params,\$out) || die "Template process failed: ", $template->error(), "\n";
	return($out);
}

#LOGIN ATTEMPTS DE USUARIOS


#METODO STATIC
sub loginFailed{
	my ($nro_socio) = shift;
	
	eval{    
		my $attempts_object = _getAttemptsObject($nro_socio);
	
		$attempts_object->increase;
	};
	
}

#METODO STATIC
sub _getAttemptsObject{
	
	my ($nro_socio) = shift;

	use C4::Modelo::UsrLoginAttempts::Manager;
	
	my @filtros;
	
	push (@filtros, (nro_socio => {eq => $nro_socio}));
	
	my ($socio_array) = C4::Modelo::UsrLoginAttempts::Manager->get_usr_login_attempts(query => \@filtros,);
	
	
	if (scalar(@$socio_array)){
		return ($socio_array->[0]);
	}else{
		my $object = C4::Modelo::UsrLoginAttempts->new(nro_socio => $nro_socio);
		
		return ($object);
	}
}

#METODO STATIC
sub loginSuccess{
	my ($nro_socio) = shift;
	
	my $attempts_object = _getAttemptsObject($nro_socio);
	
	$attempts_object->reset;
	
}

#METODO STATIC
sub getSocioAttempts{
	
	my ($nro_socio) = shift;
	
	my $object = _getAttemptsObject($nro_socio);
	
	return ($object->attempts);
}

=item
	Modulo que persiste el cambio de password de un usuario por el nuevo.
	Parametros:
				HASH: con los datos de un socio.
=cut
sub cambiarPassword {
	my ($params)=@_;
	
	my $session = CGI::Session->load();

	my  ($msg_object,$socio) = _validarCambioPassword($params);
	if(!$msg_object->{'error'}){
		#No hay error la validacion del password esta ok!
		if( ($params->{'changePassword'} eq 1) && ($socio->getChange_password) ){
			my $cambioDePasswordForzado= 1;
		}
	}
	return ($msg_object);
}

=item
	Modulo que recibe una hash con passwordActual, newpassword1 y newpassword2, y hace las validaciones necesarias
	Las nuevas passwords vienen encriptadas en AES, usando como key la passwordActual
	Retortan un objeto Mensaje
=cut
sub _validarCambioPassword {
	my ($params)    = @_;
	my $socio       = undef;
	my $msg_object  = C4::AR::Mensajes::create();
	my $new_password_1;
	my $new_password_2; 
	my $passPlana; 
	my $key;  
	
   ($socio,$msg_object)=_validarPasswordActual($params->{'actual_password'},C4::AR::Auth::getSessionNroSocio(),$params->{'new_password1'},C4::AR::Auth::getSessionNroRandom());

	if ($socio && !$msg_object->{'error'}) {

		$new_password_1 = $params->{'new_password1'};
		$new_password_2 = $params->{'new_password2'};
		
		if (_passwordsIguales($new_password_1, $new_password_2, $socio)) {
			
			#comun a todos los metodos
			$key            = $params->{'key'};
			$passPlana      = C4::AR::Auth::desencriptar($new_password_1, $key);
			($msg_object)   = C4::AR::Validator::checkPassword($passPlana); 
 
		}else{
		
			#las nuevas password son distintas
			$msg_object->{'error'} = 1;
			C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U315', 'params' => []} ) ;  
				
		}          
		
	}else{
	
		#no es valida la pass actual
		$msg_object->{'error'} = 1;
		C4::AR::Debug::debug("ENTRA EN #no es valida la pass actual");
		C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U357', 'params' => []} ) ;    
				 
	}

	if ( !($msg_object->{'error'}) && ( C4::AR::Auth::getSessionNroSocio() != $params->{'nro_socio'} ) ){
	
		#no coincide el usuario logueado con el usuario al que se le va a cambiar la password
		$msg_object->{'error'}= 1;
		C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U362', 'params' => [$params->{'nro_socio'}]} ) ;
		
	}
	
	if (!($msg_object->{'error'})) {
	C4::AR::Debug::debug("PASSpLANA : $passPlana");
		_setearPassword($socio,$new_password_1,C4::AR::Auth::getSessionNroRandom(),$passPlana);
		my $today = Date::Manip::ParseDate("today");
		$socio->setLast_change_password($today);
		$socio->setChange_password(0);
		
		$socio->save();
		
	}
	   
	return ($msg_object);
}


=item
sub _validarPasswordActual

Funcion que recibe $password,$nroRandom,$socio y verifica si el password es el que corresponde con el actual del usuario

=cut
sub _validarPasswordActual{
	my ($password,$userid,$nuevaPassword,$nroRandom) = @_;
	my $auth_method = getSessionAuthMethod();
	my $msg_object;
	my $socio       = undef;
	
	use Switch;
	switch ($auth_method){
		case "ldap" {
				($socio,$msg_object) = C4::AR::Authldap::validarPassword($userid,$password,$nuevaPassword,$nroRandom);       
		}
		case "mysql"{
				($socio,$msg_object) = C4::AR::AuthMysql::validarPassword($userid,$password,$nuevaPassword,$nroRandom);       
			
		}
		else{}
	}
	return ($socio,$msg_object);
}

=item
sub _cambiarPassword

Funcion que recibe $password,$nroRandom,$socio y verifica si el password es el que corresponde con el actual del usuario
$passPlana es usada para LDAP

=cut
sub _setearPassword{
	my ($socio,$nuevaPassword,$nroRandom,$passPlana)   = @_;
	my $auth_method                         = $socio->getLastAuthMethod();
	
	use Switch;
	switch ($auth_method){
		case "ldap" {
				($socio) = C4::AR::Authldap::setearPassword($socio,$passPlana);       
		}
		case "mysql"{
				($socio) = C4::AR::AuthMysql::setearPassword($socio,$nuevaPassword);       
			
		}
		else{}
	}
	
	return $socio;
}


sub _passwordsIguales{

	my ($nuevaPassword1,$nuevaPassword2,$socio) = @_;
	my $auth_method                             = $socio->getLastAuthMethod();
	my $result                                  = 0;
	
	use Switch;
	switch ($auth_method){
		case "ldap" {
				($result) = C4::AR::Authldap::passwordsIguales($nuevaPassword1,$nuevaPassword2,$socio);       
		}
		case "mysql"{
				($result) = C4::AR::AuthMysql::passwordsIguales($nuevaPassword1,$nuevaPassword2,$socio);       
			
		}
		else{}
	}
	
	return $result;
}

=item sub getPassword

Esta funcion devuelve el password del socio desde el ultimo mecanismo utilizado para recuperar la password

=cut

 sub getPassword{
	my ($socio)=@_;
	my $auth_method = $socio->getLastAuthMethod;
	my $msg_object= C4::AR::Mensajes::create();
	my $password;
	my $metodosDeAutenticacion= C4::AR::Preferencias::getMetodosAuth();
	use Switch;
	switch ($auth_method){
		case {"ldap" && C4::AR::Utilidades::existeInArray("ldap",@$metodosDeAutenticacion)} {
			   ($password) = C4::AR::Authldap::obtenerPassword($socio);  
		}
		else{
			#en este caso devuelve lo que tiene el obejto en la base de datos.
			($password) = $socio->password;   
			}
	}
	
	return $password;
}   



############################### PASSWORD RECOVERY SUBs #######################################

sub _sendRecoveryPasswordMail{

	my ($socio,$link) = @_;

	use C4::AR::Mail;
	use C4::Modelo::PrefUnidadInformacion;

	my %mail;

	$mail{'mail_from'}              = Encode::decode_utf8(C4::AR::Preferencias::getValorPreferencia("reserveFrom"));
	$mail{'mail_to'}                = $socio->persona->getEmail;
	$mail{'mail_subject'}           = C4::AR::Filtros::i18n("Instrucciones para reestablecer su clave");

	# Datos para el mail
	
	my $completo                    = Encode::decode_utf8($socio->persona->getApeYNom );
	my $nro_socio                   = $socio->getNro_socio;
	my $ui                          = C4::AR::Referencias::obtenerDefaultUI() || C4::AR::Referencias::getFirstDefaultUI();
	my $nombre_ui                   = Encode::decode_utf8($ui->getNombre());
	my $mailMessage                 = C4::AR::Preferencias::getValorPreferencia('mailMessageForgotPass');
						
	$mailMessage                    =~ s/SOCIO/$completo/;
	#hay 2 NOMBRE_UI por eso repetido
	$mailMessage                    =~ s/NOMBRE_UI/$nombre_ui/;
	$mailMessage                    =~ s/NOMBRE_UI/$nombre_ui/;
	#hay 3 LINK
	$mailMessage                    =~ s/LINK/$link/;
	$mailMessage                    =~ s/LINK/$link/;
	$mailMessage                    =~ s/LINK/$link/;
	
	$mail{'mail_message'}           = $mailMessage;
	$mail{'page_title'}             = C4::AR::Filtros::i18n("Olvido de su contrase&ntilde;a");
	$mail{'link'}                   = $link;
	
	my ($ok, $msg_error)            = C4::AR::Mail::send_mail(\%mail);
	
	return (!$ok,$msg_error);

}

sub _sendRecoveryPasswordMail_Unactive{

	my ($socio) = @_;

	use C4::AR::Mail;

	my %mail;

	$mail{'mail_from'}              = Encode::decode_utf8(C4::AR::Preferencias::getValorPreferencia("reserveFrom"));
	$mail{'mail_to'}                = $socio->persona->getEmail;
	$mail{'mail_subject'}           = C4::AR::Filtros::i18n("Instrucciones para reestablecer su clave");
	  
	# Datos para el mail
	use C4::Modelo::PrefUnidadInformacion;
						
	my $completo                    = Encode::decode_utf8($socio->persona->getNombre . " " . $socio->persona->getApellido);
	my $nro_socio                   = $socio->getNro_socio;

	my $ui                          = C4::AR::Referencias::obtenerDefaultUI();
	my $nombre_ui                   = Encode::decode_utf8($ui->getNombre());

	my $mailMessage                 = C4::AR::Preferencias::getValorPreferencia('mailMessageForgotPassUnactive');
	
	$mailMessage                    =~ s/SOCIO/$completo/;

	#hay 2 NOMBRE_UI por eso repetido
	$mailMessage                    =~ s/NOMBRE_UI/$nombre_ui/;
	$mailMessage                    =~ s/NOMBRE_UI/$nombre_ui/;

	$mail{'mail_message'}           = $mailMessage;
	$mail{'page_title'}             = C4::AR::Filtros::i18n("Olvido de su clave de ingreso");
	
	my ($ok, $msg_error)            = C4::AR::Mail::send_mail(\%mail);
	
	return (!$ok,$msg_error);

}

sub _buildPasswordRecoverLink{
	my ($socio) = @_;
	my $hash = sha256_base64(localtime().$socio->getPassword().$socio->getLastValidation());
	my $encoded_hash    = C4::AR::Utilidades::escapeURL($hash);
	my $link = "http://".$ENV{'SERVER_NAME'}.C4::AR::Utilidades::getUrlPrefix()."/opac-recover-password.pl?key=".$encoded_hash;
	return ($link,$hash,$encoded_hash); 
	
	
}

sub _logClientIpAddress{
	my ($operation_type, $socio) = @_;
	use Date::Manip;
	my $client_id =  $ENV{'REMOTE_ADDR'}." <".$ENV{'REMOTE_NAME'}.">";
	my $today = Date::Manip::ParseDate("now");

	$socio->client_ip_recover_pwd($client_id);
	$socio->recover_date_of($today);
	
	$socio->save();

	
	
}

sub recoverPassword{
	my ($params) = @_;

	my $message             = undef;
	my $socio               = undef;
	my $reCaptchaPrivateKey =  C4::AR::Preferencias::getValorPreferencia('re_captcha_private_key');
	my $reCaptchaChallenge  = $params->{'recaptcha_challenge_field'};
	my $reCaptchaResponse   = $params->{'recaptcha_response_field'};
	my $isError             = 0;
	use HTML::Entities;
	
	use Captcha::reCAPTCHA;
	my $c = Captcha::reCAPTCHA->new;

	my $captchaResult = $c->check_answer(
		$reCaptchaPrivateKey, $ENV{'REMOTE_ADDR'},
		$reCaptchaChallenge, $reCaptchaResponse
	);

	if ( $captchaResult->{is_valid} ){
		my $user_id = C4::AR::Utilidades::trim($params->{'user-id'});
		my $socio   = C4::AR::Usuarios::getSocioInfoPorMixed($user_id);       
		if ($socio){
			my $db = $socio->db;

			if ($socio->cumpleRequisito()) {	
			# if ( _checkRequisito($socio) ){
				
				$db->{connect_options}->{AutoCommit} = 0;
				$db->begin_work;
				
				C4::AR::Debug::debug("Auth => recoverPassword => usuario activo ");   

				eval{
					_logClientIpAddress('recover_password',$socio);
					my ($link,$hash) = _buildPasswordRecoverLink($socio);

					($isError)                      = _sendRecoveryPasswordMail($socio,$link);

					if($isError){
						C4::AR::Debug::debug("Auth => recoverPassword => usuario activo ERROR al enviar el correo " . $isError);   
						$message = C4::AR::Mensajes::getMensaje('U606','opac');
						$db->rollback;                        
					} else {
						$socio->setRecoverPasswordHash($hash);
						$db->commit;
						$message                        = C4::AR::Mensajes::getMensaje('U600','opac');
					}
				};
				if ($@){
					C4::AR::Debug::debug("Auth => " . $@);
					$message = C4::AR::Mensajes::getMensaje('U606','opac');
					C4::AR::Mensajes::printErrorDB($@, 'U606',"opac");
					$db->rollback;
				}

				$db->{connect_options}->{AutoCommit} = 1;
			}else{
				#NO ES ACTIVO, LE MANDO UN MAIL DICIENDOLE QUE VAYA A LA BIBLIOTECA
					
				C4::AR::Debug::debug("Auth => recoverPassword => usuario inactivo ");    
				eval{
					_logClientIpAddress('recover_password',$socio);
					$message                    = C4::AR::Mensajes::getMensaje('U600','opac');
					($isError)                  = _sendRecoveryPasswordMail_Unactive($socio);

					if($isError){
						$message = C4::AR::Mensajes::getMensaje('U606','opac');
						$db->rollback;                        
					} 
				};    
				if ($@){
					$message = C4::AR::Mensajes::getMensaje('U606','opac');
					C4::AR::Mensajes::printErrorDB($@, 'U606',"opac");
				}
				
			}
		}else{
			$message = C4::AR::Mensajes::getMensaje('U601','opac');
			$isError = 1;
		}
	}else{
		$message = C4::AR::Mensajes::getMensaje('U605','opac');
		$isError = 1;
	}

	return ($isError,$message);
}


sub checkRecoverLink{
	my ($key) = @_;

	my $status = 0;
	
	if (C4::AR::Utilidades::validateString($key)){
		my $socio_array_ref = C4::Modelo::UsrSocio::Manager->get_usr_socio( 
													 query              => [ 'recover_password_hash' => { eq => $key } ],
										 );
	
		if(scalar(@$socio_array_ref)){
			$status = 1;
			my $socio          = $socio_array_ref->[0];
			my $dateformat     = C4::Date::get_date_format();
			my $hoy            = Date::Manip::ParseDate("now");
			my $fecha_link     = $socio->recover_date_of;        
			my $err;
	
			$fecha_link        = Date::Manip::DateCalc( $fecha_link, "+ 1 day", \$err );
	
			my $cmp_result = Date::Manip::Date_Cmp($fecha_link,$hoy);
			
			$status = $cmp_result >= 0; 
			
			if (!$status){
				$socio->unsetRecoverPasswordHash();
				$status = 0;
			}
					
			 
		}
	}    
	return ($status)
}


sub changePasswordFromRecover{
	my ($params) = @_;
	my $socio_array_ref = C4::Modelo::UsrSocio::Manager->get_usr_socio( 
												 query              => [ 'recover_password_hash' => { eq => $params->{'key'} } ],
									 );

	my $message;
	
	if(scalar(@$socio_array_ref)){
		my $socio = $socio_array_ref->[0];
		
		if ($params->{'new_password1'} eq $params->{'new_password2'}){
		   cambiarPasswordPropagado($socio,$params->{'new_password1'},1);
		   $socio->unsetRecoverPasswordHash();
		   $message = C4::AR::Mensajes::getMensaje('U603','opac');
		   
		}else{
			$message = C4::AR::Mensajes::getMensaje('U604','opac');
		}
	}else{
		$message = C4::AR::Mensajes::getMensaje('U602','opac');
	}

	return ($message);
}   


sub resetUserPassword{
	my ($nro_socio) = @_;
	my $msg_object= C4::AR::Mensajes::create();
	
	my $socio = C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);
	if($socio){
		   my $password_dni = C4::AR::Auth::hashear_password($socio->persona->getNro_documento, 'MD5_B64');;

		   cambiarPasswordPropagado($socio,$password_dni,1);
		   $socio->forzarCambioDePassword();
		   C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U359', 'params' => [($socio->getNro_socio)]} ) ;
	}else{
		$msg_object->{'error'}= 1;
		C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U360', 'params' => [($socio->getNro_socio)]} ) ;
	}

	return ($msg_object);
}   

sub cambiarPasswordPropagado{
	my ($socio,$password_md5_b64,$isReset)=@_;
	my $msg_object= C4::AR::Mensajes::create();
	my $password = $password_md5_b64;
	my $metodosDeAutenticacion= C4::AR::Preferencias::getMetodosAuth();
	my $metodo;

	$isReset = $isReset || 0;

	while (scalar(@$metodosDeAutenticacion) ) {
		$metodo=shift(@$metodosDeAutenticacion);
		cambiarPasswordForzadoEnMetodo($socio,$password_md5_b64,$metodo,$isReset);
		C4::AR::Debug::debug("Socio ".$socio." PASSWORD ".$password_md5_b64." METODO ".$metodo);
	}
 
}  
	
	#DEBERIA SER SOLO EN EL ULTIMO AUTH_METHOD O EN TODOS LOS HABILITADOS??????
=item

#CODIGO PARA CAMBIAR EL PASS SOLAMENTE DEL ULTIMO AUTH METHOD
   
	switch ($auth_method){
		case "ldap" {
				#C4::AR::Authldap::obetenerPassword($socio);   
		}
		case "mysql" {
				$socio->cambiarPassword($password);   
		}

		else{}
	}
=cut


 

sub cambiarPasswordForzadoEnMetodo{
	my ($socio,$password_md5_b64,$auth_method,$isReset) = @_;

	$isReset = $isReset || 0;
	
	switch ($auth_method){
		case "ldap" {
				C4::AR::Authldap::setearPassword($socio,$password_md5_b64,$isReset);   
		}
		case "mysql" {
				$password_md5_b64 =  C4::AR::Auth::hashear_password($password_md5_b64,'SHA_256_B64');
				$socio->cambiarPassword($password_md5_b64);   
		}

		else{}
	}
	
		#Se limpian los login_attempts
		eval{
			
			C4::AR::Debug::debug("\n\n\n\n AHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH ".$socio->getNro_socio."\n\n\n\n");
			my $attempts_object = _getAttemptsObject($socio->getNro_socio);    
			
			$attempts_object->reset();
		}
		
}

sub printValue{
	my ($value) = @_;
	
	my $session = CGI::Session->load();
	C4::AR::Auth::print_header($session);
	print $value;
		
}


END { }       # module clean-up code here (global destructor)
1;
__END__
