package C4::AR::Proveedores;

use strict;
require Exporter;
use DBI;
use C4::Modelo::AdqProveedor;
use C4::Modelo::AdqProveedor::Manager;
use C4::Modelo::AdqProveedorMoneda;
use C4::Modelo::AdqProveedorMoneda::Manager;
use C4::Modelo::AdqProveedorFormaEnvio::Manager;
use C4::Modelo::AdqProveedorTipoMaterial;
use C4::Modelo::AdqProveedorTipoMaterial::Manager;
use C4::Modelo::AdqProveedorFormaEnvio;
use C4::Modelo::AdqProveedorFormaEnvio::Manager;


use vars qw(@EXPORT @ISA);
@ISA=qw(Exporter);
@EXPORT=qw(  
    &isPersonaFisica;
    &eliminarMoneda;
    &getAdqProveedorMoneda;
    &agregarMoneda;
    &agregarProveedor;
    &eliminarProveedor;
    &editarProveedor;
    &getProveedorLike;
    &getMonedasProveedor;
    &getFormasEnvioProveedor;
    &getProveedorInfoPorId;
    &getMonedas;
    &getMaterialesProveedor;
    &getAdqProveedorFormaEnvio;
);



=item
    Esta funcion devuelve true si el proveedor es persona fisica, false si es juridica
    Parametros: 
                {id_proveedor}
=cut
sub isPersonaFisica{

     my ($id_prov) = @_;
     my $prov = C4::AR::Proveedores::getProveedorInfoPorId($id_prov);

     if(($prov->getNombre() eq "") && ($prov->getApellido() eq "")){
        return 0;
     }else{
        return 1;
     }
}



=item
    Esta funcion elimina una modena al proveedor  
    Parametros: 
                HASH: {id_proveedor},{id_moneda}
=cut
sub eliminarMoneda{

    my ($params) = @_;

    my $proveedor_moneda = C4::Modelo::AdqProveedorMoneda->new();
    my $msg_object= C4::AR::Mensajes::create();
    my $db = $proveedor_moneda->db;

 
     if (!($msg_object->{'error'})){
           $db->{connect_options}->{AutoCommit} = 0;
           $db->begin_work;
          my $id_proveedor;
          my $id_moneda;
          my $adq_proveedor_moneda; 
            eval{
              for(my $i=0;$i<scalar(@{$params->{'monedas_array'}});$i++){
                $id_proveedor                   = $params->{'id_proveedor'};
                $id_moneda                      = $params->{'monedas_array'}->[$i];
                $adq_proveedor_moneda        = getAdqProveedorMoneda($id_moneda, $id_proveedor, $db);
                $adq_proveedor_moneda->eliminar();
                $msg_object->{'error'}= 0;
             }
             $db->commit;
            };
 
            if ($@){
               &C4::AR::Mensajes::printErrorDB($@, 'B449',"INTRA");
               $msg_object->{'error'}= 1;
               C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'B449', 'params' => []} ) ;
               $db->rollback;
            }
 
           $db->{connect_options}->{AutoCommit} = 1;
     }
     return ($msg_object);
}

=item 
Recupero un registro de adqproveedormoneda
retorna un objeto o 0 si no existe
=cut
sub getAdqProveedorMoneda{
    my ($id_moneda, $id_proveedor, $db) = @_;

    $db = $db || C4::Modelo::AdqProveedorMoneda->new()->db;
    my $adq_proveedor_moneda = C4::Modelo::AdqProveedorMoneda::Manager->get_adq_ref_proveedor_moneda(   
                                                                    db => $db,
                                                                    query   => [ proveedor_id => { eq => $id_proveedor} , moneda_id => { eq => $id_moneda }], 
                                                                );

    if( scalar($adq_proveedor_moneda) > 0){
        return ($adq_proveedor_moneda->[0]);
    }else{
        return 0;
    }
}


=item
    Esta funcion agrega una modena al proveedor  
    Parametros: 
                HASH: {id_proveedor},{id_moneda}
=cut
sub agregarMoneda{

    my ($params) = @_;

    my $proveedor_moneda = C4::Modelo::AdqProveedorMoneda->new();
    my $msg_object= C4::AR::Mensajes::create();
    my $db = $proveedor_moneda->db;

 
     if (!($msg_object->{'error'})){
           $db->{connect_options}->{AutoCommit} = 0;
           $db->begin_work;
 
           eval{
               $proveedor_moneda->agregarMonedaProveedor($params);
               $msg_object->{'error'}= 0;
               $db->commit;
           };
 
           if ($@){
               &C4::AR::Mensajes::printErrorDB($@, 'B449',"INTRA");
               $msg_object->{'error'}= 1;
               C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'B449', 'params' => []} ) ;
               $db->rollback;
           }
 
           $db->{connect_options}->{AutoCommit} = 1;
     }
     
     return ($msg_object);
}


=item
    Esta funcion agrega un proveedor
    Parametros: 
                HASH: {nombre},{direccion},{proveedor_activo},{telefono},{mail},{tipoAccion}
=cut
sub agregarProveedor{

    my ($param) = @_;
    my $proveedor = C4::Modelo::AdqProveedor->new();
    my $msg_object= C4::AR::Mensajes::create();
    my $db = $proveedor->db;

     _verificarDatosProveedor($param,$msg_object);

    if (!($msg_object->{'error'})){
          # entro si no hay algun error, todos los campos ingresados son validos
          $db->{connect_options}->{AutoCommit} = 0;
          $db->begin_work;
          my $id_moneda;
          # FIXME ver el tipo de documento, poner 1 para DNI
           eval{
              $proveedor->agregarProveedor($param);
              my $id_proveedor = $proveedor->getId();

#             monedas
              for(my $i=0;$i<scalar(@{$param->{'monedas_array'}});$i++){
                my %parametros;
                $parametros{'id_proveedor'}     = $id_proveedor;
                $parametros{'id_moneda'}        = $param->{'monedas_array'}->[$i];          
                my $proveedor_moneda            = C4::Modelo::AdqProveedorMoneda->new(db => $db);    
                $proveedor_moneda->agregarMonedaProveedor(\%parametros);
              }
              
#             materiales
              for(my $i=0;$i<scalar(@{$param->{'materiales_array'}});$i++){             
                my %parametros2;
                $parametros2{'id_proveedor'}    = $id_proveedor;
                $parametros2{'id_material'}     = $param->{'materiales_array'}->[$i];          
                my $proveedor_material          = C4::Modelo::AdqProveedorTipoMaterial->new(db => $db);    
                $proveedor_material->agregarMaterialProveedor(\%parametros2);
              }
              
#             envios
              for(my $i=0;$i<scalar(@{$param->{'formas_envios_array'}});$i++){             
                my %parametros2;
                $parametros2{'id_proveedor'}    = $id_proveedor;
                $parametros2{'id_forma_envio'}  = $param->{'formas_envios_array'}->[$i];          
                my $proveedor_forma_envio = C4::Modelo::AdqProveedorFormaEnvio->new(db => $db);    
                $proveedor_forma_envio->agregarFormaDeEnvioProveedor(\%parametros2);
              }
              
              $msg_object->{'error'} = 0;
              C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A001', 'params' => []});
              $db->commit;
           };
           if ($@){
           # TODO falta definir el mensaje "amigable" para el usuario informando que no se pudo agregar el proveedor
               &C4::AR::Mensajes::printErrorDB($@, 'B449',"INTRA");
               $msg_object->{'error'}= 1;
               C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'B449', 'params' => []} ) ;
               $db->rollback;
           }

          $db->{connect_options}->{AutoCommit} = 1;
    }
    return ($msg_object);
}

=item 
Recupero un registro de AdqProveedorTipoMaterial
retorna un objeto o 0 si no existe
=cut
sub getAdqProveedorTipoMaterial{
    my ($id_material, $id_proveedor, $db) = @_;

    $db = $db || C4::Modelo::AdqProveedorTipoMaterial->new()->db;
    my $adq_proveedor_tipo_material = C4::Modelo::AdqProveedorTipoMaterial::Manager->get_adq_proveedor_tipo_material(   
                                                                    db => $db,
                                                                    query   => [ proveedor_id => { eq => $id_proveedor} , tipo_material_id => { eq => $id_material }], 
                                                                );

    if( scalar($adq_proveedor_tipo_material) > 0){
        return ($adq_proveedor_tipo_material->[0]);
    }else{
        return 0;
    }
}

=item 
Recupero un registro de AdqProveedorFormaEnvio
retorna un objeto o 0 si no existe
=cut
sub getAdqProveedorFormaEnvio{
    my ($id_forma_envio, $id_proveedor, $db) = @_;

    $db = $db || C4::Modelo::AdqProveedorTipoMaterial->new()->db;
    my $adq_proveedor_forma_envio = C4::Modelo::AdqProveedorFormaEnvio::Manager->get_adq_proveedor_forma_envio(   
                                                                    db => $db,
                                                                    query   => [ adq_proveedor_id => { eq => $id_proveedor} , adq_forma_envio_id => { eq => $id_forma_envio }], 
                                                                );

    if( scalar($adq_proveedor_forma_envio) > 0){
        return ($adq_proveedor_forma_envio->[0]);
    }else{
        return 0;
    }
}


=item
    Esta funcion elimina un proveedor (pone el flag activo en 0)
    Parametros: 
                {id_proveedor}
=cut
sub eliminarProveedor {

     my ($id_prov) = @_;
     my $msg_object= C4::AR::Mensajes::create();
     my $prov = C4::AR::Proveedores::getProveedorInfoPorId($id_prov);
 
     eval {
         $prov->desactivar;
         $msg_object->{'error'}= 0;
         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A024', 'params' => []} ) ;
     };
 
     if ($@){
         #Se loguea error de Base de Datos
         &C4::AR::Mensajes::printErrorDB($@, 'B422','INTRA');
         #Se setea error para el usuario
         $msg_object->{'error'}= 1;
         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A025', 'params' => []} ) ;
     }
 
     return ($msg_object);
}


=item
    Esta funcion edita un proveedor
    Parametros: 
                 HASH: {nombre},{direccion},{proveedor_activo},{telefono},{mail}
=cut
sub editarProveedor{
#   Recibe la informacion del proveedos, el objeto JSON.

    my ($params)=@_;
    my $msg_object= C4::AR::Mensajes::create();

    my $proveedor = getProveedorInfoPorId($params->{'id_proveedor'});

    my $db = $proveedor->db;

    _verificarDatosProveedor($params,$msg_object);

    if (!($msg_object->{'error'})){

#         entro si no hay algun error, todos los campos ingresados son validos
          $db->{connect_options}->{AutoCommit} = 0;
          $db->begin_work;
          eval{
              $proveedor->editarProveedor($params);
              
#             materiales:
#             antes de agregar borrar todo de la tabla proveedor_tipo_material:
              my $arreglo_materiales            = getMaterialesProveedor($params->{'id_proveedor'});
              for(my $i=0;$i<scalar(@{$arreglo_materiales});$i++){
                my $proveedor_material = getAdqProveedorTipoMaterial($arreglo_materiales->[$i]->getMaterialId, $params->{'id_proveedor'}, $db);
                $proveedor_material->eliminar();             
              }
              
#             se agregan los materiales              
              for(my $i=0;$i<scalar(@{$params->{'materiales_array'}});$i++){
                my %parametros;
                $parametros{'id_proveedor'}     = $params->{'id_proveedor'};
                $parametros{'id_material'}      = $params->{'materiales_array'}->[$i];          
                my $proveedor_material          = C4::Modelo::AdqProveedorTipoMaterial->new(db => $db);   

                $proveedor_material->agregarMaterialProveedor(\%parametros);
              }
              
#             formas de envio:
#             antes de agregar borrar todo de la tabla adq_proveedor_forma_envio:
              my $arreglo_formas_envio            = getFormasEnvioProveedor($params->{'id_proveedor'});
              for(my $i=0;$i<scalar(@{$arreglo_formas_envio});$i++){
                my $proveedor_forma_envio = getAdqProveedorFormaEnvio($arreglo_formas_envio->[$i]->getFormaEnvioId, $params->{'id_proveedor'}, $db);
                $proveedor_forma_envio->eliminar();             
              }
              
#             se agregan las formas de envio              
              for(my $i=0;$i<scalar(@{$params->{'formas_envios_array'}});$i++){
                my %parametros;
                $parametros{'id_proveedor'}         = $params->{'id_proveedor'};
                $parametros{'id_forma_envio'}       = $params->{'formas_envios_array'}->[$i];          
                my $proveedor_forma_envio           = C4::Modelo::AdqProveedorFormaEnvio->new(db => $db);   

                $proveedor_forma_envio->agregarFormaDeEnvioProveedor(\%parametros);
              }
              
              $msg_object->{'error'}= 0;
              C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A006', 'params' => []});
              $db->commit;
          };

          if ($@){
          # TODO falta definir el mensaje "amigable" para el usuario informando que no se pudo editar el proveedor
              &C4::AR::Mensajes::printErrorDB($@, 'B449',"INTRA");
              $msg_object->{'error'}= 1;
              C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'B449', 'params' => []} ) ;
              $db->rollback;
          }

    }

     return ($msg_object);
}

# =item
#     Esta funcion devuelve la informacion del proveedor segun su id
# =cut
sub getProveedorInfoPorId {
    my ($params) = @_;

    my $proveedorTemp;
    my @filtros;

    if ($params){
        push (@filtros, ( id => { eq => $params}));
        $proveedorTemp = C4::Modelo::AdqProveedor::Manager->get_adq_proveedor(   query => \@filtros );

        return $proveedorTemp->[0]
    }

    return 0;
}

# =item
#     Esta funcion devuelve el proveedor con nro_doc recibido como parametro
# =cut
sub getProveedorPorDni{
    my ($params) = @_;

    my $proveedorTemp;
    my @filtros;

    if ($params){
        push (@filtros, ( nro_doc => { eq => $params}));
        $proveedorTemp = C4::Modelo::AdqProveedor::Manager->get_adq_proveedor( query => \@filtros );

        return $proveedorTemp->[0]
    }

    return 0;
}

# =item
#     Este funcion devuelve la informacion de proveedores segun su nombre o razon social
# =cut
sub getProveedorLike {

    my ($proveedor,$orden,$ini,$cantR,$habilitados,$inicial) = @_;
    my @filtros;
    my $proveedorTemp = C4::Modelo::AdqProveedor->new();

    if($proveedor ne 'TODOS'){
        if (!($inicial)){
                push (  @filtros, ( or   => [   nombre => { like => '%'.$proveedor.'%'}, razon_social => { like => '%'.$proveedor.'%'}, ]));
        }else{
                push (  @filtros, ( or   => [   nombre => { like => $proveedor.'%'}, razon_social => { like => $proveedor.'%'}, ]) );
        }
    }

    if (!defined $habilitados){
        $habilitados = 1;
    }

    push(@filtros, ( activo => { eq => $habilitados}));
    my $ordenAux= $proveedorTemp->sortByString($orden);
    my $proveedores_array_ref = C4::Modelo::AdqProveedor::Manager->get_adq_proveedor(   query => \@filtros,
                                                                                        sort_by => $ordenAux,
                                                                                        limit   => $cantR,
                                                                                        offset  => $ini,
     ); 

    #Obtengo la cantidad total de proveedores para el paginador
    my $proveedores_array_ref_count = C4::Modelo::AdqProveedor::Manager->get_adq_proveedor_count( query => \@filtros, );

    if(scalar(@$proveedores_array_ref) > 0){
        return ($proveedores_array_ref_count, $proveedores_array_ref);
    }else{
        return (0,0);
    }
}



=item
   Modulo que devuelve todos las formas de envio que tenga el proveedor
=cut
sub getFormasEnvioProveedor{
 
    my ($params) = @_;
    my $id_proveedor = $params;

    my $formas_envio_array_ref = C4::Modelo::AdqProveedorFormaEnvio::Manager->get_adq_proveedor_forma_envio(   
                                                                                        query =>  [ 
                                                                                        adq_proveedor_id  => { eq => $id_proveedor  },
                                                                                        ],
                                                                                        require_objects => ['forma_envio_ref'],
                                                                                        );
 
    return($formas_envio_array_ref);
}


=item
   Modulo que devuelve todos los tipos de materiales que tenga el proveedor
=cut
sub getMaterialesProveedor{
 
    my ($params) = @_;
    my $id_proveedor = $params;

    my $materiales_array_ref = C4::Modelo::AdqProveedorTipoMaterial::Manager->get_adq_proveedor_tipo_material(   
                                                                                        query =>  [ 
                                                                                        proveedor_id  => { eq => $id_proveedor  },
                                                                                        ],
                                                                                        require_objects => ['material_ref'],
                                                                                        );
 
    return($materiales_array_ref);
}


=item
   Modulo que devuelve todas las monedas que tenga el proveedor
=cut
sub getMonedasProveedor{
 
   my ($params) = @_;
   my $id_proveedor = $params;

   my $monedas_array_ref = C4::Modelo::AdqProveedorMoneda::Manager->get_adq_ref_proveedor_moneda(   query =>  [ 
                                                                                                adq_proveedor_id  => { eq => $id_proveedor  },
                                                                                   ],
                                                                                    require_objects => ['moneda_ref'],
   
                                                    );

    
   return($monedas_array_ref);
}


=item
   Modulo que devuelve todas las monedas para mostrarlas en Editar Proveedor
=cut

sub getMonedas{
 
   my $todasMonedas = C4::Modelo::RefAdqMoneda::Manager->get_ref_adq_moneda();
   my @nombres_monedas;
   foreach my $moneda (@$todasMonedas){
      push (@nombres_monedas,$moneda);
   }
    
   return($todasMonedas);
}


sub _verificarDatosProveedor {

     my ($data, $msg_object)    = @_;
     my $actionType             = $data->{'tipoAccion'};
     my $checkStatus;

     my $tipo_proveedor         = $data->{'tipo_proveedor'};
   
     my $apellido               = $data->{'apellido'};
     my $nombre                 = $data->{'nombre'};
    
     my $nro_doc                = $data->{'nro_doc'};
     my $tipo_doc               = $data->{'tipo_doc'};
     my $razon_social           = $data->{'razon_social'};
     my $cuit_cuil              = $data->{'cuit_cuil'};

     my $pais                   = $data->{'pais'};
     my $provincia              = $data->{'provincia'};
     my $ciudad                 = $data->{'ciudad'};
     my $domicilio              = $data->{'domicilio'};
     my $telefono               = $data->{'telefono'};
     my $fax                    = $data->{'fax'};     

     my $emailAddress           = $data->{'email'};
     
     my $plazo_reclamo          = $data->{'plazo_reclamo'};
    
     my $proveedorActivo        = $data->{'proveedor_activo'};
     
     my $monedas_array          = $data->{'monedas_array'};
     my $formas_envio_array     = $data->{'formas_envios_array'};
     my $materiales_array       = $data->{'materiales_array'};

     if (($actionType eq "AGREGAR_PROVEEDOR") || ($actionType eq "GUARDAR_MODIFICACION_PROVEEDOR")){

        if($tipo_proveedor eq "persona_fisica"){
    
            # es una persona fisica, se validan estos datos
            # valida que el nombre sea valido - no puede estar en blanco ni tener caracteres invalidos - 
            if($nombre ne ""){
                if (!($msg_object->{'error'}) && (!(&C4::AR::Utilidades::validateString($nombre)))){
                    $msg_object->{'error'}= 1;
                    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A007', 'params' => []} ) ;
                }
            } else {
                  $msg_object->{'error'}= 1;
                  C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A002', 'params' => []} ) ;
            }

            #   valida apellido
            if($apellido ne ""){
                if (!($msg_object->{'error'}) && (!(&C4::AR::Utilidades::validateString($apellido)))){
                      $msg_object->{'error'}= 1;
                      C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A009', 'params' => []} ) ;
                      }
            } else {
                    $msg_object->{'error'}= 1;
                    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A010', 'params' => []} ) ;   
            }

            #   valida nro documento, tambien que no exista ya en la base cuando estamos agregando un proveedor
            if($nro_doc ne "") {
                if (!($msg_object->{'error'}) && ( ((&C4::AR::Validator::countAlphaChars($nro_doc) != 0)) || (&C4::AR::Validator::countSymbolChars($nro_doc) != 0) || (&C4::AR::Validator::countNumericChars($nro_doc) == 0))){
                      $msg_object->{'error'}= 1;
                      C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A015', 'params' => []} ) ;
                      }else{
                        # el dni es valido, validamos que sea unico si estamos agregando
                        if($actionType eq "AGREGAR_PROVEEDOR"){
                            my $proveedor_dni = getProveedorPorDni($nro_doc);
                            if($proveedor_dni != 0){
                                $msg_object->{'error'}= 1;
                                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A026', 'params' => []} ) ;
                            }
                        }else{
                            # si estamos editando tiene que tener el mismo dni el proveedor con mismo id
                            my $proveedor_dni = getProveedorPorDni($nro_doc);
                            if($proveedor_dni != 0){
                                if($proveedor_dni->getId != $data->{'id_proveedor'}){
                                    $msg_object->{'error'}= 1;
                                    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A026', 'params' => []} ) ;
                                }
                            }
                        }
                      }
            } else {
            C4::AR::Debug::debug("nro_doc: ".$nro_doc);
                    $msg_object->{'error'}= 1;
                    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A016', 'params' => []} ) ;
                  
            }

        }else{
            # es una persona juridica
            # valida razon social
            if($razon_social ne "") {
                if (!($msg_object->{'error'}) && (!(&C4::AR::Utilidades::validateString($razon_social)))){
                      $msg_object->{'error'}= 1;
                      C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A011', 'params' => []} ) ;
                      }
            } else {
                    $msg_object->{'error'}= 1;
                    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A012', 'params' => []} ) ;     
            }

        } 
        
        #   validaciones aparte del tipo de persona que sea:  
        
        #   valida las monedas:
        my $cant_monedas = scalar(@{$monedas_array});
        if($cant_monedas != 0 ){
            if (!($msg_object->{'error'})){ 
              
            for(my $i=0;$i<$cant_monedas;$i++){
                if(((&C4::AR::Validator::countAlphaChars($monedas_array->[$i]) != 0)) || (&C4::AR::Validator::countSymbolChars($monedas_array->[$i]) != 0)){
                     $msg_object->{'error'}= 1;
                    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A038', 'params' => []} ) ;
                }
            }
            }
        }   
                
        #   valida las formas de envio:
        my $cant_formas_envio = scalar(@{$formas_envio_array});
        if($cant_formas_envio != 0){
             if (!($msg_object->{'error'})){
                for(my $i=0;$i<$cant_formas_envio;$i++){
                   if(((&C4::AR::Validator::countAlphaChars($formas_envio_array->[$i]) != 0)) || (&C4::AR::Validator::countSymbolChars($formas_envio_array->[$i]) != 0)){
                     $msg_object->{'error'}= 1;
                    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A039', 'params' => []} ) ;
                  }
                }
            }
        }
        
        
        #   valida los materiales:
        my $cant_materiales = scalar(@{$materiales_array});
        if($cant_materiales != 0){
             if (!($msg_object->{'error'})){
                for(my $i=0;$i<$cant_materiales;$i++){
                   if(((&C4::AR::Validator::countAlphaChars($materiales_array->[$i]) != 0)) || (&C4::AR::Validator::countSymbolChars($materiales_array->[$i]) != 0)){
                     $msg_object->{'error'}= 1;
                    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A040', 'params' => []} ) ;
                  }
                }
                
                } 
        }    
        
        #   valida cuit_cuil
        if($cuit_cuil ne "") {
            if (!($msg_object->{'error'}) && ( ((&C4::AR::Validator::countAlphaChars($cuit_cuil) != 0)) || (&C4::AR::Validator::countSymbolChars($cuit_cuil) != 0) || (&C4::AR::Validator::countNumericChars($cuit_cuil) == 0))){
                  $msg_object->{'error'}= 1;
                  C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A013', 'params' => []} ) ;
                  }
        } else {
                 $msg_object->{'error'}= 1;
                 C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A014', 'params' => []} ) ;       
        }
          
        if($ciudad ne ""){
            if (!($msg_object->{'error'}) && (!(&C4::AR::Utilidades::validateString($ciudad)))){
                $msg_object->{'error'}= 1;
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A021', 'params' => []} ) ;
            }
        } else {
                $msg_object->{'error'}= 1;
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A022', 'params' => []} ) ;        
        }


        #   valida si el email contiene algo
        if($emailAddress ne ""){
            if (!($msg_object->{'error'}) && (!(&C4::AR::Validator::isValidMail($emailAddress)))){
                $msg_object->{'error'}= 1;
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A003', 'params' => []} ) ;
            }
        }

        #   valida el domicilio
        if($domicilio ne ""){
            if (!($msg_object->{'error'}) && (!(&C4::AR::Utilidades::validateString($domicilio)))){
                  $msg_object->{'error'}= 1;
                  C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A008', 'params' => []} ) ;
            } 
        }else {
                  $msg_object->{'error'}= 1;
                  C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A004', 'params' => []} ) ;      
            }
        
      
          #   valida que el telefono no tenga caractes ni simbolos
          if (!($msg_object->{'error'}) && ( ((&C4::AR::Validator::countAlphaChars($telefono) != 0)) || (&C4::AR::Validator::countSymbolChars($telefono) != 0) || (&C4::AR::Validator::countNumericChars($telefono) == 0))){
                 $msg_object->{'error'}= 1;
                 C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A005', 'params' => []} ) ;     
           }

       }

       return ($msg_object);

  
}

END { }       # module clean-up code here (global destructor)

1;
__END__
