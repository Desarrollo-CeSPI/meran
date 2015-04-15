
package C4::AR::Usuarios;

=head1 NAME

C4::AR::Usuarios 

=head1 SYNOPSIS

  use C4::AR::Usuarios;

=head1 DESCRIPTION

  Descripción del modulo COMPLETAR

=head1 FUNCTIONS

=over 2

=cut



=item
####################################### About PM ########################################################
    Author: Heredado de KOHA V2
    Updates: Carbone Miguel, Pagano Matias, Rajoy Gaspar
    Version: 3.0 (Meran)
    Language: Perl
    Description: Este Modulo contiene todas las funciones necesarias para manipular usuarios.
                 Todas las funciones que recolentan datos de un socio en particular, retornan 0 (cero)
                 en caso de que la consulta fue fallida.
####################################### End About PM #####################################################
=cut

use strict;
require Exporter;


use C4::AR::Validator;
use C4::AR::Prestamos qw(cantidadDePrestamosPorUsuario);
use C4::Modelo::UsrPersona;
use C4::Modelo::UsrPersona::Manager;
use C4::Modelo::UsrEstado;
use C4::Modelo::UsrSocio;
use C4::Modelo::UsrSocio::Manager;
use C4::AR::Preferencias;
use C4::AR::Utilidades;
use Digest::SHA qw(sha256_base64);
use Switch;

use vars qw(@EXPORT_OK @ISA);
@ISA=qw(Exporter);

@EXPORT_OK=qw(
    agregarAutorizado
    agregarPersona
    habilitarPersona
    deshabilitarPersona
    resetPassword
    eliminarUsuario
    editarNote
    _verficarEliminarUsuario
    t_cambiarPermisos
    cambiarPassword
    _verificarDatosBorrower
    actualizarSocio
    getSocioInfo
    getSocioInfoPorNroSocio
    getSocioInfoPorMixed
    existeSocio
    getSocioLike
    llegoMaxReservas
    estaSancionado
    BornameSearchForCard
    isUniqueDocument
    esRegular
    updateUserDataValidation
    needsDataValidation
    crearPersonaLDAP
    _verificarLibreDeuda
    updateUserProfile
    modificarCredencialesSocio
    getEsquemaRegularidades
    editarRegularidadEsquema
    eliminarPotencial
    cambiarNroSocio
);

=item
    Cambia las credenciales del socio
=cut
sub modificarCredencialesSocio {

    my ($params)    = @_;
    my $msg_object  = C4::AR::Mensajes::create();
    my ($socio)     = C4::AR::Usuarios::getSocioInfoPorNroSocio($params->{'nro_socio'});

    if ($socio){
        my $db = $socio->db;
        $db->{connect_options}->{AutoCommit} = 0;
        $db->begin_work;

        eval {
            $socio->setCredentialType($params->{'credenciales'});
            $db->commit;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U338', 'params' => []} ) ;
            
        };

        if ($@){
            C4::AR::Mensajes::printErrorDB($@, 'B423',"INTRA");
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U339', 'params' => []} ) ;
            $db->rollback;
        }
        $db->{connect_options}->{AutoCommit} = 1;
    }
    return ($msg_object);
}

=item
    Este modulo agrega un autorizado (persona apta para retirar ejemplares a su nombre)
    a un socio (UsrSocio).
    Parametros: 
                HASH: {nro_socio},{nombre_apellido_autorizado},{telefono_autorizado},{dni_autorizado}
=cut
sub agregarAutorizado {

    my ($params)=@_;
    my $msg_object= C4::AR::Mensajes::create();
    my ($socio) = C4::AR::Usuarios::getSocioInfoPorNroSocio($params->{'nro_socio'});

    if ($socio){
        my $db = $socio->db;
            $db->{connect_options}->{AutoCommit} = 0;
            $db->begin_work;

            eval{
                $socio->agregarAutorizado($params);
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U397', 'params' => []});
                $db->commit;
            };

            if ($@){
                C4::AR::Mensajes::printErrorDB($@, 'B423',"INTRA");
                $msg_object->{'error'}= 1;
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U398', 'params' => []} ) ;
                $db->rollback;
            }

            $db->{connect_options}->{AutoCommit} = 1;
    }
    else{
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U353', 'params' => []} ) ;
    }
    return ($msg_object);
}

=item
    Este modulo agrega una persona al sistema, que dependiendo de las preferencias de MERAN se auto-activara (conviertiendose en Real) o no.
    Parametros: 
                HASH: con toda la info de una persona (ver UsrPersona->agregar() )
=cut
sub agregarPersona {

    my ($params)=@_;
    my $msg_object= C4::AR::Mensajes::create();
    my ($person) = C4::Modelo::UsrPersona->new();
    my $db = $person->db;

    _verificarDatosBorrower($params,$msg_object);
    if (!($msg_object->{'error'})){

        $params->{'iniciales'} = C4::AR::Utilidades::armarIniciales($params);
        #genero un estado de ALTA para la persona para una fuente de informacion
        $db->{connect_options}->{AutoCommit} = 0;
        $db->begin_work;
        eval{
            my $socio = $person->agregar($params);
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U329', 'params' => [$socio->getNro_socio]});
            $db->commit;
            
        };

        if ($@){
            C4::AR::Mensajes::printErrorDB($@, 'B423',"INTRA");
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U330', 'params' => []} ) ;
            $db->rollback;
        }
        $db->{connect_options}->{AutoCommit} = 1;
    }
    return ($msg_object);
}

=item sub habilitarPersona

    Este modulo habilita un socio, para que pueda operar en la biblioteca.
    Parametros: 
    ARRAY: con los id de los socios a habilitar

=cut
sub habilitarPersona {

    my ($id_socios_array_ref)=@_;
    my $dbh = C4::Context->dbh;
    my $msg_object= C4::AR::Mensajes::create();

     eval {
        foreach my $socio (@$id_socios_array_ref){
            my ($partner) = C4::AR::Usuarios::getSocioInfoPorNroSocio($socio);
            if ($partner){
                $partner->activar;
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U347', 'params' => [$partner->getNro_socio]});
            }
        }
     };

     if ($@){
         #Se loguea error de Base de Datos
         &C4::AR::Mensajes::printErrorDB($@, 'B423',"INTRA");
         #Se setea error para el usuario
         $msg_object->{'error'}= 1;
         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U330', 'params' => []} ) ;
     }

    return ($msg_object);
}

=item
    Este modulo deshabilita un socio, para que no pueda operar en la biblioteca.
    Parametros:
                ARRAY: con los id de los socios a deshabilitar
=cut
sub deshabilitarPersona {

    my ($id_socios_array_ref)=@_;
    my $dbh = C4::Context->dbh;
    my $msg_object= C4::AR::Mensajes::create();
    C4::AR::Debug::debug("Usuarios => deshabilitar!!!");

    eval {
        foreach my $socio (@$id_socios_array_ref){
            C4::AR::Debug::debug("Usuarios => deshabilitar => socio => " . $socio);

            # my ($partner) = getSocioInfo($socio);
            my ($partner) = getSocioInfoPorNroSocio($socio);
            
            C4::AR::Debug::debug("Usuarios => deshabilitar => partner => " . $partner);

            if ($partner){
                my ($o, $cod_msg) = $partner->desactivar;
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> $cod_msg, 'params' => [$partner->getNro_socio]});
            }
        }
     };

     if ($@){
         #Se loguea error de Base de Datos
         &C4::AR::Mensajes::printErrorDB($@, 'B423',"INTRA");
         #Se setea error para el usuario
         $msg_object->{'error'}= 1;
         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U330', 'params' => []} ) ;
     }

    return ($msg_object);

}

=item
    Este modulo resetea (deja en blanco) el password de acceso de un usuario, que sera su nro_documento.
    Parametros: 
                HASH: {nro_socio}
=cut
sub desautorizarTercero {

    my ($params)=@_;
    my $nro_socio = $params->{'nro_socio'};
    my $msg_object= C4::AR::Mensajes::create();
    my $socio = C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);

        eval {
            $socio->desautorizarTercero;
            $msg_object->{'error'}= 0;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U396', 'params' => [$socio->getNro_socio]} ) ;
        } or do{
            #Se loguea error de Base de Datos
            &C4::AR::Mensajes::printErrorDB($@, 'B422','INTRA');
            #Se setea error para el usuario
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U398', 'params' => [$socio->getNro_socio]} ) ;
        };

    return ($msg_object);
}

=item
    Este modulo resetea (deja en blanco) el password de acceso de un usuario, que será su nro_documento.
    Parametros: 
                HASH: {nro_socio}
=cut
sub resetPassword {

    my ($params)=@_;
    my $nro_socio = $params->{'nro_socio'};
    my $msg_object;
    
    eval {
            $msg_object = C4::AR::Auth::resetUserPassword($nro_socio);
    };

    if ($@) {
      $msg_object =
      $msg_object->{'error'}= 1;
      C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U360', 'params' => [$nro_socio]} ) ;

    }
    
    return ($msg_object);
}

=item
    Este módulo es IDENTICO a deshabilitarPersona, pero por razones de posibles cambios en los requerimientos, de deja para que el sistema
    tenga suficiente escalabilidad.
=cut
# FIXME NO SE ESTA USANDO
sub eliminarUsuario {

    my ($nro_socio)=@_;
    my $msg_object= C4::AR::Mensajes::create();
    my $socio = C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);
# FIXME esa funcion debe cambiar, porque cambiaron los parametros
#     $msg_object = _verficarEliminarUsuario($params,$msg_object);

    if(!$msg_object->{'error'}){
    #No hay error

        eval {
            my ($error,$cod_msg) = $socio->desactivar;
            
            $error = $error || 0;
            $cod_msg = $cod_msg || 'U320'; 
            $msg_object->{'error'}= $error;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> $cod_msg, 'params' => [($socio->getNro_socio)]} ) ;
        };

        if ($@){
            #Se loguea error de Base de Datos
            &C4::AR::Mensajes::printErrorDB($@, 'B422','INTRA');
            #Se setea error para el usuario
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U319', 'params' => [($socio->getNro_socio)]} ) ;
        }
    }

    return ($msg_object);
}

=item
    Este modulo verifica que un usuario se pueda eliminar.
=cut
# FIXME fijarse que aca no se checkea nada, por ejemplo si tiene reservas, libros en su poder, etc...
# FIXME ADEMAS NO ES ESTA USANDO, HAY QUE ARREGLARLA Y USARLA (MONO?)
# FIXME deberia usarse en deshabilitarPersona y checkear que no tenga prestamos, de lo contrario retorna FALSE

sub _verficarEliminarUsuario {

    my ($params,$msg_object)=@_;
    my ($cantVencidos,$cantIssues) = C4::AR::Prestamos::cantidadDePrestamosPorUsuario($params->{'borrowernumber'});
    my ($cantidadTotalDePrestamos) = $cantVencidos + $cantIssues;

    if( !($msg_object->{'error'}) && !( _existeUsuario($params->{'borrowernumber'})) ){
    #se verifica la existencia del usuario, que ahora no existe
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U321', 'params' => [$params->{'cardnumber'}]} ) ;
    } 
    elsif ($cantidadTotalDePrestamos > 0){
        #se verifica que no tenga prestamos activos
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U351', 'params' => [$params->{'cardnumber'}]} ) ;
    }
    elsif ($params->{'loggedInUser'} eq $params->{'borrowernumber'}){
    #   Se verifica que el usuario loggeado no sea el mismo que se va a eliminar
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U352', 'params' => [$params->{'cardnumber'}]} ) ;
    }
    return ($msg_object);
}

=item
    Este modulo es la transaccion para cambiar los permisos de acceso de un socio.
    Parametros:
                HASH: {nro_socio}, y nuevos permisos
=cut
sub t_cambiarPermisos {

    my ($params)=@_;
## FIXME ver si falta verificar algo!!!!!!!!!!
    my $msg_object= C4::AR::Mensajes::create();

    if(!$msg_object->{'error'}){
    #No hay error
        my $socio= C4::AR::Usuarios::getSocioInfoPorNroSocio($params->{'nro_socio'});

        my $db= $socio->db;
        # enable transactions, if possible
        $db->{connect_options}->{AutoCommit} = 0;

        eval {
            $socio->cambiarPermisos($params);
            $db->commit;
            #se cambio el permiso con exito
            $msg_object->{'error'}= 0;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U317', 'params' => []} ) ;
        };

        if ($@){
            #Se loguea error de Base de Datos
            &C4::AR::Mensajes::printErrorDB($@, 'B421',"INTRA");
            $db->rollback;
            #Se setea error para el usuario
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U331', 'params' => []} ) ;
        }

        $db->{connect_options}->{AutoCommit} = 1;

    }

    return ($msg_object);
}

=item
    Modulo que chekea que todos los datos necesarios sean validos. Queda todo en $msg_object, ademas lo retorna;
=cut
sub _verificarDatosBorrower {

    my ($data, $msg_object)=@_;
    my $actionType = $data->{'actionType'};
    my $checkStatus;
    my $emailAddress = $data->{'email'};
    my $credential_type = lc $data->{'credential_type'};
    my $nro_socio = $data->{'nro_socio'};

    if ( (!($msg_object->{'error'})) && ($data->{'auto_nro_socio'} != 1) && (!$data->{'modifica'})){
          $msg_object->{'error'} = (existeSocio($nro_socio) > 0);
          if ($msg_object->{'error'}){
              C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U500', 'params' => []} );
          }
    }

    if (!($msg_object->{'error'}) && ($credential_type eq "superlibrarian") ){
        my $socio = getSocioInfoPorNroSocio(C4::AR::Auth::getSessionNroSocio());
        if ( (!$socio) || (!($socio->isSuperUser())) ){
          $msg_object->{'error'}= 1;
          C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U399', 'params' => []} ) ;
        }
    }

    if (!($msg_object->{'error'}) && (!(&C4::AR::Validator::isValidMail($emailAddress)))){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U332', 'params' => []} ) ;
    }

    #### EN ESTE IF VAN TODOS LOS CHECKS PARA UN NUEVO BORROWER, NO PARA UN UPDATE
    if ($actionType eq "new"){

        my $cardNumber = $data->{'nro_socio'};
        if (!($msg_object->{'error'}) && (!(&C4::AR::Utilidades::validateString($cardNumber)))){
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U333', 'params' => []} ) ;
        }
    }
    #### FIN NUEVO BORROWER's CHECKS

    my $surname = $data->{'apellido'};
    if (!($msg_object->{'error'}) && (!(&C4::AR::Utilidades::validateString($surname)))){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U334', 'params' => []} ) ;
    }

    my $firstname = $data->{'nombre'};
    if (!($msg_object->{'error'}) && (!(&C4::AR::Utilidades::validateString($firstname)))){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U335', 'params' => []} ) ;
    }

    my $tipo_doc = $data->{'tipo_documento'};
    if (!($msg_object->{'error'}) && (!(&C4::AR::Utilidades::validateString($tipo_doc)))){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U800', 'params' => []} ) ;
    }

    my $documentnumber = $data->{'nro_documento'};
    $checkStatus = C4::AR::Validator::isValidDocument($data->{'tipo_documento'},$documentnumber);
    if (!($msg_object->{'error'}) && ( $checkStatus == 0)){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U336', 'params' => []} ) ;
    } 

    if (!C4::AR::Usuarios::isUniqueDocument($documentnumber,$data)) {
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U388', 'params' => []} ) ;
    } 

    return ($msg_object);
}

=item
    Este modulo recibe los mismos datos que agregarPersona, pero sirven como modificacion de los actuales.
    Parametros:
                HASH: con todos los datos de UsrPersona y UsrSocio
=cut
sub actualizarSocio {
    my ($params)    = @_;
    my $dbh         = C4::Context->dbh;
    my $msg_object  = C4::AR::Mensajes::create();

    $params->{'actionType'} = "update";
    $params->{'modifica'} = 1;

    _verificarDatosBorrower($params, $msg_object);

    if(!$msg_object->{'error'}){
    #No hay error

        $dbh->{AutoCommit} = 0;  # enable transactions, if possible
        $dbh->{RaiseError} = 1;

        #eval {
            my $socio = getSocioInfoPorNroSocio($params->{'nro_socio'});
            $socio->modificar($params);
#            $socio->setThemeINTRA($params->{'tema'} || 'default');
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U338', 'params' => []} ) ;
        #};

        if ($@){
            #Se loguea error de Base de Datos
            &C4::AR::Mensajes::printErrorDB($@, 'B424',"INTRA");
            $dbh->rollback;
            #Se setea error para el usuario
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U339', 'params' => []} ) ;
        }
        $dbh->{AutoCommit} = 1;
    }
    return ($msg_object);
}

=item
    Esta funcion devuelve la informacion del socio, segun el id_socio que recibe por parametro
=cut
sub getSocioInfo {
    my ($id_socio) = @_;
    my @filtros;

    push (@filtros, (id_socio => {eq =>$id_socio}) );

    my  $socio = C4::Modelo::UsrSocio::Manager->get_usr_socio(query => \@filtros,
                                                              require_objects => ['persona','ui','categoria','persona.ciudad_ref',
                                                                                  'persona.documento'],
                                                              with_objects => ['persona.alt_ciudad_ref'],
                                                             );

    if (scalar(@$socio)){
        return ($socio->[0]);
    }else{
        return (0);
    }
}

=item
    Este funcion devuelve la informacion del usuario segun un nro_socio
=cut
sub getSocioInfoPorNroSocio {
    my ($nro_socio) = @_;
    if ($nro_socio){
        my $socio_array_ref = C4::Modelo::UsrSocio::Manager->get_usr_socio( 
                                                    query => [ nro_socio => { eq => $nro_socio } ],
                                                    require_objects => ['persona','persona.documento','categoria'],
                                                    with_objects => ['ui', 'persona.alt_ciudad_ref','persona.ciudad_ref'],
                                                    select       => ['persona.*','usr_socio.*','usr_ref_categoria_socio.*','ui.*'],
                                        );

        if($socio_array_ref){
            return ($socio_array_ref->[0]);
        }else{
            return 0;
        }
    }

    return 0;
}

=item
    Este funcion devuelve la informacion del usuario segun un nro_socio, su e-mail o su DNI
=cut
sub getSocioInfoPorMixed{
        my ($user_id) = @_;
        my @filtros;
        
        my $socio = undef;
        
        push (@filtros, (or   => [
                                   'usr_persona.email' => { eq => $user_id }, 
                                   'usr_persona.nro_documento' => { eq => $user_id },
                                   'nro_socio' => { eq => $user_id },
                                   ])
        );
        
        
        my $socio_array_ref = C4::Modelo::UsrSocio::Manager->get_usr_socio( 
                                                     query              => \@filtros,
                                                     require_objects    => ['persona'],
                                                     select             => ['persona.*','usr_socio.*'],
                                         );
    
        if(scalar(@$socio_array_ref)){
             $socio =  $socio_array_ref->[0];
        }else{
             $socio =  C4::AR::Usuarios::getSocioInfoPorNroSocio($user_id);
        }
        
        return ($socio);
        
	
}

=item
    Este funcion devuelve 1 si existe el socio y 0 si no existe
=cut
sub existeSocio {
    my ($nro_socio)= @_;
    my $socio_array_ref = C4::Modelo::UsrSocio::Manager->get_usr_socio_count( query => [ nro_socio => { eq => $nro_socio } ]);
    return $socio_array_ref;
}

=item
    Esta funcion busca por nro_documento, nro_socio, apellido y combinados por ej: "27 Car", donde 27 puede ser parte del DNI o legajo o ambos
=cut
sub getSocioLike {
    my ($socio, $orden, $ini, $cantR, $habilitados, $inicial, $categoria) = @_;


# C4::AR::Debug::debug("Usuarios => getSocioLike => orden => ".$orden);

    my @filtros;
    my $socioTemp           = C4::Modelo::UsrSocio->new();
    my @searchstring_array  = C4::AR::Utilidades::obtenerBusquedas($socio);
    my $limit_pref          = C4::AR::Preferencias::getValorPreferencia('limite_resultados_autocompletables') || 20;
    $cantR                  = $cantR || $limit_pref;


    if($socio ne 'TODOS'){
        #SI VIENE INICIAL, SE BUSCA SOLAMENTE POR APELLIDOS QUE COMIENCEN CON ESA LETRA, SINO EN TODOS LADOS CON LIKE EN AMBOS LADOS
        if (!($inicial)){
            foreach my $s (@searchstring_array){ 
                push (  @filtros, ( or   => [   
                                                'persona.nombre'    => { like => $s.'%'},   
                                                'persona.nombre'    => { like => '% '.$s.'%'},
                                                apellido            => { like => $s.'%'},
                                                apellido            => { like => '% '.$s.'%'},
                                                nro_documento       => { like => '%'.$s.'%' }, 
                                                legajo              => { like => '%'.$s.'%' },
                                                nro_socio           => { like => '%'.$s.'%' }         
                                            ])
                     );
            }

# TODO preferencia para ECONO
        } else {
            foreach my $s (@searchstring_array){ 
                push (  @filtros, ( or   => [   apellido => { like => $s.'%'}, ]) );
            }
        }
    }

    #filtro por categoria del socio
    if ($categoria ne ""){
        push(@filtros, ( id_categoria => { eq => $categoria}));
    }

    if (!defined $habilitados){
        $habilitados = 1;
    }

    push(@filtros, ( activo => { eq => $habilitados}));
    push(@filtros, ( es_socio => { eq => $habilitados}));
    $orden = "apellido,nombre";
    my $ordenAux= $socioTemp->sortByString($orden);
    
   # $ordenAux = 'agregacion_temp,'.$ordenAux;
    
    my $socios_array_ref = C4::Modelo::UsrSocio::Manager->get_usr_socio(   query => \@filtros,
                                                                            sort_by => $ordenAux,
                                                                            limit   => $cantR,
                                                                            offset  => $ini,
                                                                            select => ['*','persona.*','length(apellido) AS agregacion_temp'],
                                                                            with_objects => ['persona','ui','categoria','persona.ciudad_ref',
                                                                                  'persona.documento'],
     ); 

    #Obtengo la cant total de socios para el paginador
    my $socios_array_ref_count = C4::Modelo::UsrSocio::Manager->get_usr_socio_count( query => \@filtros,
                                                              with_objects => ['persona','ui','categoria','persona.ciudad_ref',
                                                                                  'persona.documento'],
                                                                     );

    if(scalar(@$socios_array_ref) > 0){
        return ($socios_array_ref_count, $socios_array_ref);
    }else{
        return (0,());
    }
}

=item
    Esta funcion busca por nro_documento, nro_socio, apellido y combinados por ej: "27 Car", donde 27 puede ser parte del DNI o legajo o ambos
    Tambien recibe una credencial, para filtrar solo a los socios con dicha credencial
=cut
sub getSocioLikeByCredentialType {

    my ($socio, $credential) = @_;

    my @filtros;
    my $socioTemp           = C4::Modelo::UsrSocio->new();
    my @searchstring_array  = C4::AR::Utilidades::obtenerBusquedas($socio);
    my $limit_pref          = C4::AR::Preferencias::getValorPreferencia('limite_resultados_autocompletables') || 20;
    my $cantR               = $limit_pref;
    my $ini                 = 0;
    my $inicial             = undef;


    if($socio ne 'TODOS'){
        #SI VIENE INICIAL, SE BUSCA SOLAMENTE POR APELLIDOS QUE COMIENCEN CON ESA LETRA, SINO EN TODOS LADOS CON LIKE EN AMBOS LADOS
        if (!($inicial)){
            foreach my $s (@searchstring_array){ 
                push (  @filtros, ( or   => [   
                                                'persona.nombre'    => { like => $s.'%'},   
                                                'persona.nombre'    => { like => '% '.$s.'%'},
                                                apellido            => { like => $s.'%'},
                                                apellido            => { like => '% '.$s.'%'},
                                                nro_documento       => { like => '%'.$s.'%' }, 
                                                legajo              => { like => '%'.$s.'%' },
                                                nro_socio           => { like => '%'.$s.'%' }          
                                            ])
                     );
            }

# TODO preferencia para ECONO
        } else {
            foreach my $s (@searchstring_array){ 
                push (  @filtros, ( or   => [   apellido => { like => $s.'%'}, ]) );
            }
        }
    }

    # push(@filtros, ( credential_type => { eq => $credential}));


    push(@filtros,or => [   credential_type => { eq => "librarian" },
                            credential_type => { eq => "superlibrarian" } 
                        ]
         ); 

    my $orden       = "apellido, nombre";
    my $ordenAux    = $socioTemp->sortByString($orden);
    
   # $ordenAux = 'agregacion_temp,'.$ordenAux;
    
    my $socios_array_ref = C4::Modelo::UsrSocio::Manager->get_usr_socio(   query => \@filtros,
                                                                            sort_by => $ordenAux,
                                                                            limit   => $cantR,
                                                                            offset  => $ini,
                                                                            select => ['*','length(apellido) AS agregacion_temp'],
                                                              with_objects => ['persona','ui','categoria','persona.ciudad_ref',
                                                                                  'persona.documento'],
     ); 

    #Obtengo la cant total de socios para el paginador
    my $socios_array_ref_count = C4::Modelo::UsrSocio::Manager->get_usr_socio_count( query => \@filtros,
                                                              with_objects => ['persona','ui','categoria','persona.ciudad_ref',
                                                                                  'persona.documento'],
                                                                     );

    if(scalar(@$socios_array_ref) > 0){
        return ($socios_array_ref_count, $socios_array_ref);
    }else{
        return (0,());
    }
}

=item
    Verifica si el usuario llego al maximo de las resevas que puede relizar sengun la preferencia del sistema, recibe el numero de socio
=cut
sub llegoMaxReservas {

    my ($nro_socio)=@_;
    my $cant= &C4::AR::Reservas::cant_reservas($nro_socio);

C4::AR::Debug::debug("cant: ".$cant);
C4::AR::Debug::debug("maxreserves: ".C4::AR::Preferencias::getValorPreferencia("maxreserves"));

    return ( $cant >= C4::AR::Preferencias::getValorPreferencia("maxreserves") );
}

=item
    Verifica si un usuario esta sancionado segun un tipo de prestamo
=cut
sub estaSancionado {

    my ($nro_socio,$tipo_prestamo)=@_;
    my $sancionado= 0;
    my @sancion= C4::AR::Sanciones::permitionToLoan($nro_socio, $tipo_prestamo);

    if (($sancion[0]||$sancion[1])) { 
        $sancionado= 1;
    }

    return $sancionado;
}

sub editarAutorizado{
    my ($params)    = @_;

    my $nro_socio   = $params->{'nro_socio'};
    my $campo       = $params->{'id'};
    my $value       = $params->{'value'};
    my $socio       = C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);

    if ($socio){
        switch ($campo) {
            case "nombre_autorizado" { $socio->setNombre_apellido_autorizado($value); $socio->save();  }
            case "dni_autorizado" { $socio->setDni_autorizado($value); $socio->save();  }
            case "telefono_autorizado" { $socio->setTelefono_autorizado($value); $socio->save();  }
            else { }
        }
    }
    return ($value);
}


sub editarNote{
    my ($params)    = @_;

    my $nro_socio   = $params->{'nro_socio'};
    my $value       = $params->{'value'};

    my $socio       = C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);
 
    if ($socio){       
           $socio->setNote($value); 
           $socio->save();
    }
    return ($value);
}



=item
    Busca todos los usuarios, con sus datos, entre un par de nombres o legajo para poder crear los carnet.
=cut
sub BornameSearchForCard {

#     my ($apellido1,$apellido2,$category,$branch,$orden,$regular,$legajo1,$legajo2) = @_;
    my ($params) = @_;
    my @filtros;
    my $socioTemp = C4::Modelo::UsrSocio->new();

    my $fecha_inicio    = $params->{'from_last_login'} || 0;
    my $fecha_fin       = $params->{'to_last_login'} || 0;

    my $desde = C4::AR::Filtros::i18n('Desde');
    my $hasta = C4::AR::Filtros::i18n('Hasta');

    if (($fecha_inicio) && ($fecha_inicio ne $desde) && ($fecha_fin) && ($fecha_fin ne $hasta) ) {

        $fecha_inicio   = C4::Date::format_date($fecha_inicio, 'iso')."00:00:00";
        $fecha_fin      = C4::Date::format_date($fecha_fin, 'iso')." 23:59:59";  

        push( @filtros, and => ['last_login_all' => { ge => $fecha_inicio },
                                'last_login_all' => { le => $fecha_fin } ] ); 

    }

    my $fecha_inicio_alta    = $params->{'from_alta'} || 0;
    my $fecha_fin_alta       = $params->{'to_alta'} || 0;

    if (($fecha_inicio_alta) && ($fecha_inicio_alta ne $desde) && ($fecha_fin_alta) && ($fecha_fin_alta ne $hasta) ) {

        $fecha_inicio_alta   = C4::Date::format_date($fecha_inicio_alta, "iso");
        $fecha_fin_alta      = C4::Date::format_date($fecha_fin_alta, "iso");

        push( @filtros, and => ['fecha_alta' => { ge => $fecha_inicio_alta },
                                'fecha_alta' => { le => $fecha_fin_alta } ] ); 

    }

    my $fecha_inicio_alta_p    = $params->{'from_alta_persona'} || 0;
    my $fecha_fin_alta_p       = $params->{'to_alta_persona'} || 0;

    if (($fecha_inicio_alta_p) && ($fecha_inicio_alta_p ne "") && ($fecha_fin_alta_p) && ($fecha_fin_alta_p ne "") ) {

        $fecha_inicio_alta_p   = C4::Date::format_date($fecha_inicio_alta_p, "iso");
        $fecha_fin_alta_p      = C4::Date::format_date($fecha_fin_alta_p, "iso");

        push( @filtros, and => ['persona.'.fecha_alta => { ge => $fecha_inicio_alta_p },
                                'persona.'.fecha_alta => { le => $fecha_fin_alta_p } ] ); 

    }

    if ((C4::AR::Utilidades::validateString($params->{'apellido1'})) || (C4::AR::Utilidades::validateString($params->{'apellido2'}))){
        if ((C4::AR::Utilidades::validateString($params->{'apellido1'})) && (C4::AR::Utilidades::validateString($params->{'apellido2'}))){
                push (@filtros, ('persona.'.apellido => { ge => $params->{'apellido1'}})); # >=
                push (@filtros, ('persona.'.apellido => { le => $params->{'apellido2'}, like => $params->{'apellido2'}.'%'})); # <=
        }
        elsif (C4::AR::Utilidades::validateString($params->{'apellido1'})) {
                push (@filtros, ('persona.'.apellido => {ge => $params->{'apellido1'}}) );
        }
        else {
               push (@filtros, ('persona.'.apellido => { le => $params->{'apellido2'}}) );
        }
    }

    if ((C4::AR::Utilidades::validateString($params->{'legajo1'})) || (C4::AR::Utilidades::validateString($params->{'legajo2'}))){
        if ((C4::AR::Utilidades::validateString($params->{'legajo1'})) && (C4::AR::Utilidades::validateString($params->{'legajo2'}))){
                push (@filtros, ('persona.'.legajo => { ge => $params->{'legajo1'}})); # >=
                push (@filtros, ('persona.'.legajo => { le => $params->{'legajo2'}})); # <=
        }
        elsif (C4::AR::Utilidades::validateString($params->{'legajo1'})) {
                push (@filtros, ('persona.'.legajo => { eq => $params->{'legajo1'}}) );
        }
        else {
               push (@filtros, ('persona.'.legajo => { eq => $params->{'legajo2'}}) );
        }
    }

    if ($params->{'categoria_socio'} ne '') {
            push (@filtros, (id_categoria => { eq => $params->{'categoria_socio'} }) );
    }

    if (C4::AR::Utilidades::validateString($params->{'dni'})) {
            push (@filtros, ('persona.'.nro_documento => { eq => $params->{'dni'} }) );
    }

    if ( (!C4::AR::Utilidades::isnan($params->{'regularidad'})) && ($params->{'regularidad'})) {
            push (@filtros, (id_estado => { eq => $params->{'regularidad'} }) );
    }
   


     push (@filtros, ('persona.'.es_socio => { eq => 1}) );
     push (@filtros, (activo => { eq => 1}) );
     $params->{'cantR'} = $params->{'cantR'} || 0;
     $params->{'ini'} = $params->{'ini'} || 0;
     my $socios_array_ref=0;
     my $socios_array_ref_count=0;
     eval{
        $socios_array_ref_count = C4::Modelo::UsrSocio::Manager->get_usr_socio_count(   query => \@filtros,
                                                                                sort_by => ( $socioTemp->sortByString($params->{'orden'}) ),
                                                                                require_objects => ['persona'],
        );
        if ($params->{'export'}){
	        $socios_array_ref = C4::Modelo::UsrSocio::Manager->get_usr_socio(   query => \@filtros,
	                                                                            sort_by => ( $socioTemp->sortByString($params->{'orden'}) ),
                                                                                require_objects => ['persona'],
	        );

        }else{
            $socios_array_ref = C4::Modelo::UsrSocio::Manager->get_usr_socio(   query => \@filtros,
                                                                                sort_by => ( $socioTemp->sortByString($params->{'orden'}) ),
                                                                                limit => $params->{'cantR'},
                                                                                offset => $params->{'ini'},
                                                                                require_objects => ['persona'],
            );
        }
    };


    return ($socios_array_ref_count, $socios_array_ref);
}

=item
    Checkea que un nro_documento junto con su tipo, no existan en la base, porque por motivos de diseño, no se puede poner restriccion en la DB.
=cut
sub isUniqueDocument {
    my ($nro_documento,$params) = @_;
    my @filtros;

    push (@filtros, ( 'persona.nro_documento' => { eq => $nro_documento }, ) );
    push (@filtros, ( 'persona.tipo_documento' => { eq => $params->{'tipo_documento'} }, ) );
    push (@filtros, ( nro_socio => { ne => $params->{'nro_socio'} }) );

    my $cant = C4::Modelo::UsrSocio::Manager::get_usr_socio_count( query => \@filtros,
                                                                   require_objects => ['persona']
                                                                );


    return ($cant == 0); # SE USA 0 PARA SABER QUE NADIE TIENE ESE DOCUMENTO, Y 1 PARA SABER QUE LO TIENE UNO SOLO, SIRVE PARA MODIFICAR
}

=item
    Modulo que dado un nro_socio, le dice al mismo esRegular.
=cut
sub esRegular {

    my ($nro_socio) = @_;
    my $socio = C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);

    if ($socio){
        return ($socio->esRegular);
    }else{
        return(0);
    }
}



=item
    Este funcion devuelve si el socio tiene que pasar por ventanilla a validar sus datos censales
=cut
sub needsDataValidation {
    my ($nro_socio) = @_;
    if ($nro_socio){
        my $socio_array_ref = C4::Modelo::UsrSocio::Manager->get_usr_socio( 
                                                   query => [ nro_socio => { eq => $nro_socio } ],
                                                    select       => ['*'],
                                       );
        if($socio_array_ref){
            my $socio = $socio_array_ref->[0];
            # Si es admin no le exijo validación
            return ($socio->needsValidation() && !$socio->esAdmin());
        }else{
            return 0;
        }
   }
}

=item
    Este funcion devuelve si el socio tiene que pasar por ventanilla a validar sus datos censales
=cut
sub updateUserDataValidation {
    my ($nro_socio, $tipo) = @_;

    my $msg_object= C4::AR::Mensajes::create();
    use Date::Manip;
        C4::AR::Debug::debug("Usuarios => updateUserDataValidation!!!");

    #Verificamos si se permite actualizar datos censales desde donde se hace el requerimiento
    if(
        ($tipo eq "opac")&&(!C4::AR::Preferencias::getValorPreferencia("user_data_validation_required_opac")) 
     || ($tipo eq "intranet")&&(!C4::AR::Preferencias::getValorPreferencia("user_data_validation_required_intra")) 
        )
    {
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg' => 'U507', 'tipo' => $tipo, 'params' => []} ) ;
    }

    if (($nro_socio) && (!$msg_object->{'error'})) {
        my $socio_array_ref = C4::Modelo::UsrSocio::Manager->get_usr_socio( 
                                                    query => [ nro_socio => { eq => $nro_socio } ],
                                                    select       => ['*'],
                                        );
        if($socio_array_ref){
            my $socio = $socio_array_ref->[0];
            
            eval{
                $socio->updateValidation();

                C4::AR::Debug::debug("Usuarios => updateUserDataValidation UPDATED!!!");
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U415', 'params' => []});
            };
            if ($@){
                C4::AR::Debug::debug("Usuarios => ERROR updateUserDataValidation: ".$@);
                $msg_object->{'error'}= 1;
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U416', 'params' => []} ) ;
            }
        }
    }
    
    return ($msg_object);
}


=item
=item sub getLastLoginTime

Esta funcion devuelve el momento en q se logeo el ultimo socio ed la biblioteca

=cut
sub getLastLoginTime{
    my $dbh = C4::Context->dbh;
    #WARNING: Cuando pasan dias habiles sin actividad se consideran automaticamente feriados
    my $sth=$dbh->prepare("SELECT MAX(last_login) AS lastlogin FROM usr_socio");
    $sth->execute();
    my $lastlogin= $sth->fetchrow;
    return $lastlogin;
}


sub crearPersonaLDAP{

# campos que vienen desde LDAP

#    unidad_academica,              *
#    identificacion,
#    clave,                         no se guarda en MERAN
#    apellido,                      *
#    nombres,                       *
#    fecha_nacimiento,              *
#    sexo,                          *
#    calle_per_lect,                *
#    numero_per_lect,
#    piso_per_lect,
#    dpto_per_lect,
#    unidad_per_lect,
#    loc_per_lect,                  FIXME: viene el id de la ciudad o el nombre en un string ??
#    cp_per_lect,
#    te_per_lect,                   *
#    e_mail,                        *
#    carrera,                       *
#    legajo,                        *
#    calidad, A= Activo - E= Egresado, N = No activo
#    regular,                       * FIXME: como viene ?1 o 0 , S o N ?
#    tipo_documento,                *
#    nro_documento                  *

                                    
    my ($nro_socio,$entry)          = @_;

#   TODO: en ldapConfig.tmpl mostrar un combo con los posibles campos, que no se puedan editar
    
    # mapeo en estas variables los nombres de los campos de MERAN
    # pueden no tener valor, porque son opcionales en la conf de LDAP
    my $ldap_field_name             = C4::AR::Authldap::_getValorPreferenciaLdap('ldap_lockconfig_field_map_firstnames') || "nombre";
    my $ldap_field_lastname         = C4::AR::Authldap::_getValorPreferenciaLdap('ldap_lockconfig_field_map_lastname') || "apellido";
    my $ldap_field_city             = C4::AR::Authldap::_getValorPreferenciaLdap('ldap_lockconfig_field_map_city') || "ciudad";
    my $ldap_field_mail             = C4::AR::Authldap::_getValorPreferenciaLdap('ldap_lockconfig_field_map_email') || "email";
    
    my %params                      = {};
    
    if (C4::AR::Authldap::_getValorPreferenciaLdap('ldap_objectclass') eq 'inetOrgPerson') {

        $params{$ldap_field_lastname}   = $entry->get_value("sn") || "";
        $params{$ldap_field_mail}       = $entry->get_value("mail") || "";
        $params{$ldap_field_name}       = $entry->get_value("cn") || ""; 
        $params{'tipo_documento'}       = $entry->get_value("tipo_documento") || "1"; # 1 es DNI
        $params{'nro_documento'}        = $entry->get_value("nro_documento") || "99999999"; 
        $params{'legajo'}               = $entry->get_value("emplayeeNumber") || "99999";
        $params{'calle'}                = $entry->get_value("street") || "";
        $params{'telefono'}             = $entry->get_value("telephoneNumber") || "";
        $params{'carrera'}              = $entry->get_value("title") || "";
        $params{'sexo'}                 = $entry->get_value("sex") || "m";
        $params{'nacimiento'}           = $entry->get_value("fecha_nacimiento") || "";
        $params{'cumple_condicion'}     = 1;
    }
    else {
        $params{$ldap_field_lastname}   = $entry->get_value("apellido") || "";
        $params{$ldap_field_mail}       = $entry->get_value("e_mail") || "";
        $params{$ldap_field_name}       = $entry->get_value("nombres") || ""; 
        $params{'tipo_documento'}       = $entry->get_value("tipo_documento") || "1"; # 1 es DNI
        $params{'nro_documento'}        = $entry->get_value("nro_documento") || "99999999"; 
        $params{'legajo'}               = $entry->get_value("legajo") || "99999";
        $params{'cumple_condicion'}     = $entry->get_value("regular") || 0;
        $params{'calle'}                = $entry->get_value("calle_per_lect") || "";
        $params{'telefono'}             = $entry->get_value("te_per_lect") || "";
        $params{'carrera'}              = $entry->get_value("carrera") || "";
        $params{'sexo'}                 = $entry->get_value("sexo") || "";
        $params{'nacimiento'}           = $entry->get_value("fecha_nacimiento") || "";
    }    
        $params{'id_ui'}                = $entry->get_value("unidad_academica") || C4::AR::Preferencias::getValorPreferencia("defaultUI");
        $params{'changepassword'}       = 0;
        $params{'password'}             = "";   # la password no se guarda en la base 
        $params{$ldap_field_city}       = "1";  # id de ciudad 1 o $entry->get_value("loc_per_lect");
        $params{'credential_type'}      = "estudiante";
        $params{'nro_socio'}            = $nro_socio;
        $params{'id_categoria'}         = "1";

    my $person                      = C4::Modelo::UsrPersona->new();
    
    $person->agregar(\%params);
}

=item
    Modulo que chekea que el al usuario se le pueda emitir un libre deuda. Queda todo en $msg_object, ademas lo retorna;
=cut
sub _verificarLibreDeuda {

    my ($nro_socio)=@_;


    my $msg_object= C4::AR::Mensajes::create();

    my $libreD=C4::AR::Preferencias::getValorPreferencia("libreDeuda");
    my @array=split(//, $libreD);
    my $ok=1;
    my $msj="";
    # RESERVAS ADJUDICADAS 0--------> flag 1; function C4::AR::Reservas::cant_reservas($borum);
    # RESERVAS EN ESPERA   1--------> flag 2; function C4::AR::Reserves::cant_waiting($borum);
    # PRESTAMOS VENCIDOS   2--------> flag 3; fucntion C4::AR::Sanciones::hasDebts("",$borum); 1 tiene vencidos. 0 no.
    # PRESTAMOS EN CURSO   3--------> flag 4; fucntion C4::AR::Prestamos::DatosPrestamos($borum);
    # SANSIONADO           4--------> flag 5; function C4::AR::Sanciones::hasSanctions($borum);

    if($array[0] eq "1"){
        if(C4::AR::Reservas::_getReservasAsignadas($nro_socio)){
          $msg_object->{'error'}= 1;
          C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U418', 'params' => []} ) ;
        }
    }
    if($array[1] eq "1" &&  (!($msg_object->{'error'}))){
        if(C4::AR::Reservas::getReservasDeSocioEnEspera($nro_socio)){
          $msg_object->{'error'}= 1;
          C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U419', 'params' => []} ) ;
        }
    }
    if($array[2] eq "1" && (!($msg_object->{'error'}))){
        if(&C4::AR::Sanciones::tieneLibroVencido($nro_socio)){
          $msg_object->{'error'}= 1;
          C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U420', 'params' => []} ) ;
        }
    }

     if($array[3] eq "1" && (!($msg_object->{'error'}))){
        if(&C4::AR::Prestamos::tienePrestamos($nro_socio)){
          $msg_object->{'error'}= 1;
          C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U421', 'params' => []} ) ;
        }
    }

     if($array[4] eq "1" && (!($msg_object->{'error'}))){
        if(&C4::AR::Sanciones::tieneSanciones($nro_socio)){
          $msg_object->{'error'}= 1;
          C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U422', 'params' => []} ) ;
        }
    }

    return ($msg_object);
}



sub updateUserProfile{
	my ($params) = @_;
	
	my $socio  =   C4::AR::Auth::getSessionNroSocio();
	
	$socio     = getSocioInfoPorNroSocio($socio);
	
	eval{
		$socio->persona->setEmail($params->{'email'});
        $socio->setLocale($params->{'language'});
        #$socio->setThemeINTRA($params->{'temas_intra'});
        #SAVE DATA
		$socio->persona->save();
		$socio->save();
	};
	
	return ($socio);
}

sub getEsquemaRegularidades{
	
	my $regularidades = C4::Modelo::UsrRegularidad::Manager->get_usr_regularidad(require_objects => ['estado','categoria'], sort_by => ['categoria.description, estado.nombre, estado.fuente ASC'],);
	
	return $regularidades;
	
}


sub editarRegularidadEsquema{
	
	my ($ref,$value) = @_;

    my @filtros;

    my @id_array = split('_',$ref);
    
    $ref = @id_array[1];
    push (@filtros, (id => {eq =>$ref}) );
	
	my $regularidades = C4::Modelo::UsrRegularidad::Manager->update_usr_regularidad(   where => \@filtros, 
	                                                                                   set => {condicion => C4::AR::Utilidades::translateYesNo_toNumber($value)} );
	
	
	return ($value);
	
}


sub eliminarPotencial{
	my ($nro_socio) = shift;

    my $msg_object= C4::AR::Mensajes::create();
    my $socio = C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);


    if(!$msg_object->{'error'}){

        eval {
            my ($error,$cod_msg) = $socio->eliminar;
            
            $error = $error || 0;
            $cod_msg = $cod_msg || 'U900'; 
            $msg_object->{'error'}= $error;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> $cod_msg, 'params' => [($socio->getNro_socio)]} ) ;
        };

        if ($@){
            #Se loguea error de Base de Datos
            &C4::AR::Mensajes::printErrorDB($@, 'B422','INTRA');
            #Se setea error para el usuario
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U319', 'params' => [($socio->getNro_socio)]} ) ;
        }
    }

    return ($msg_object);
}	

sub cambiarNroSocio{
    my ($params) = shift;

    my $msg_object= C4::AR::Mensajes::create();
    my ($socio)     = C4::AR::Usuarios::getSocioInfoPorNroSocio($params->{'nro_socio'});

    if ($socio){
        my $db = $socio->db;
        $db->begin_work;

        eval {
            if ($socio->updateNroSocio($params)){
                $db->commit;
            }
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U338', 'params' => []} ) ;
        };

        if ($@){
            C4::AR::Mensajes::printErrorDB($@, 'B423',"INTRA");
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U500', 'params' => []} ) ;
            $db->rollback;
        }else{
            my $loggedInUser = C4::AR::Auth::getSessionNroSocio();

            if ($loggedInUser eq $params->{'nro_socio'}){
                my $session = CGI::Session->load();

                $session->param('userid',$socio->getNro_socio);
            }
        }
    }

    return $msg_object;

}

END { }       # module clean-up code here (global destructor)

1;
__END__



