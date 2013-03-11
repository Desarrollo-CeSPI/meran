package C4::AR::VisualizacionOpac;

#
#Este modulo sera el encargado del manejo de la carga de datos en las tablas MARC
#Tambien en la carga de los items en los distintos niveles.
#

use strict;
require Exporter;
use C4::Context;
use C4::Modelo::CatVisualizacionOpac;
use C4::Modelo::CatVisualizacionOpac::Manager;
use C4::Modelo::CatEstructuraCatalogacion;
use C4::Modelo::CatEstructuraCatalogacion::Manager;
use vars qw($VERSION @EXPORT_OK @ISA);

#~ use C4::AR::CacheMeran;
# set the version for version checking
$VERSION = 0.01;

@ISA=qw(Exporter);

@EXPORT_OK=qw(
    addConfiguracion
    updateNewOrder
    getConfiguracionByOrder
	getConfiguracion
    deleteConfiguracion
    editConfiguracion
    getSubCamposLike
    getCamposXLike
    getVisualizacionFromCampoSubCampo
    updateNewOrder
    getItemsByCampo
    updateNewOrderGroup
    getConfiguracionByOrderGroupCampo
    editVistaGrupo
    getSubCamposByCampo
    updateNewOrderSubCampos
    eliminarTodoElCampo
    updateCacheOPAC
    __updateCacheOPAC
);

=item
   Esta funcion elimina todo un campo con sus respectivos subcampos de un nivel recibido por parametro
=cut
sub eliminarTodoElCampo{
    my ($params) = @_;

    my $visualizacion_opac  = C4::Modelo::CatVisualizacionOpac->new();  
    my $db                  = $visualizacion_opac->db;
    my $msg_object          = C4::AR::Mensajes::create();
    my $campo               = $params->{'campo'};
    my $nivel               = $params->{'nivel'};
    my $ejemplar            = $params->{'ejemplar'};

    $db->{connect_options}->{AutoCommit} = 0;

    eval {
        C4::AR::VisualizacionOpac::_eliminarTodoElCampo($params, $db);
        $msg_object->{'error'} = 0;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'M001', 'params' => [$campo, $nivel, $ejemplar]} ) ;

        $db->commit;
    };

    if ($@){
        #Se loguea error de Base de Datos
        C4::AR::Mensajes::printErrorDB($@, 'M003',"INTRA");
        $db->rollback;
        #Se setea error para el usuario
        $msg_object->{'error'} = 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'M002', 'params' => [$campo, $nivel, $ejemplar]} ) ;
    }

    $db->{connect_options}->{AutoCommit} = 1;

    return ($msg_object);
}

=item
    Funcion interna que elimina todos los campos-subcampos de un nivel
=cut
sub _eliminarTodoElCampo{
    my ($params, $db) = @_;
    my @filtros;
    my $campo       = $params->{'campo'};
    my $nivel       = $params->{'nivel'};
    my $ejemplar    = $params->{'ejemplar'};

    push (@filtros, (campo      => { eq => $campo }) );
    push (@filtros, (nivel      => { eq => $nivel }) );
    
    #FIXME: esta con un 'OR' porque cuando se muestran los campos se hace lo mismo: sub getConfiguracionByOrderGroupCampo
    push ( @filtros, ( or   => [    tipo_ejemplar   => { eq => $ejemplar }, 
                                    tipo_ejemplar   => { eq => 'ALL'     } ]),
                                
    );
#    push (@filtros, (ejemplar   => { eq => $ejemplar }) );

    my $configuracion = C4::Modelo::CatVisualizacionOpac::Manager->get_cat_visualizacion_opac(db => $db, query => \@filtros,);

    foreach my $conf (@$configuracion){
        $conf->delete();    
    }
}

=item
    Funcion que actializa el orden de los subcampos. 
    Parametros: array con los ids en el orden nuevo
=cut
sub updateNewOrderSubCampos{
    my ($newOrderArray) = @_;
    my $msg_object      = C4::AR::Mensajes::create();
    
    my $i = 1;
    
    foreach my $campo (@$newOrderArray){
        my $config_temp = C4::Modelo::CatVisualizacionOpac::Manager->get_cat_visualizacion_opac(
                                                                    query   => [ id => { eq => $campo}], 
                               );
        my $configuracion = $config_temp->[0];
        
        $configuracion->setOrdenSubCampo($i);
    
        $i++;
    }
    
    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'M000', 'params' => []} ) ;

    return ($msg_object);

}

=item
    Funcion que devuelve TODOS los subcampos de un campo y ordenados por orden 
=cut
sub getSubCamposByCampo{
    my ($campo) = @_;

    my @filtros;
    
    push ( @filtros, ( or   => [    campo   => { eq => $campo },]),
                                
    );

    my $configuracion = C4::Modelo::CatVisualizacionOpac::Manager->get_cat_visualizacion_opac(query => \@filtros, sort_by => ('orden_subcampo'),);

    return ($configuracion);
}

=item
    
=cut
sub getSubCampos{
    my ($campo, $nivel, $template) = @_;

    my @filtros;
    
    push ( @filtros, ( nivel            => { eq => $nivel } ));
    push ( @filtros, ( campo            => { eq => $campo } ));
    push ( @filtros, ( or   => [    tipo_ejemplar   => { eq => 'ALL' }, tipo_ejemplar    => { eq => $template }]  ));

    my $configuracion = C4::Modelo::CatVisualizacionOpac::Manager->get_cat_visualizacion_opac(query => \@filtros, sort_by => ('orden_subcampo'),);

    return ($configuracion);
}

=item
    Esta funcion edita la vista_campo de un grupo recibido como parametro
=cut
sub editVistaGrupo{
    my ($campo, $value, $nivel, $tipo_ejemplar)  = @_;

    my @filtros;
    push (@filtros, (campo => { eq => $campo }) );
    push (@filtros, (nivel => { eq => $nivel }) );
    push ( @filtros, ( or   => [    tipo_ejemplar   => { eq => 'ALL' }, tipo_ejemplar    => { eq => $tipo_ejemplar }]  ));
    
    my $configuracion   = C4::Modelo::CatVisualizacionOpac::Manager->get_cat_visualizacion_opac(query => \@filtros,);
    
    foreach my $conf (@$configuracion){
        $conf->setVistaCampo($value);    
    }
    return ($configuracion->[0]->getVistaCampo());
    
}

=item
    Funcion que actializa el orden de los campos. 
    Parametros: array con los ids en el orden nuevo
=cut
sub updateNewOrder{
    my ($newOrderArray) = @_;
    my $msg_object      = C4::AR::Mensajes::create();
    
    # ordeno los ids que llegan desordenados primero, para obtener un clon de los ids, y ahora usarlo de indice para el orden
    # esto es porque no todos los campos de cat_visualizacion_opac se muestran en el template a ordenar 
    # entonces no puedo usar un simple indice como id.
    my @array = sort { $a <=> $b } @$newOrderArray;
    
    my $i = 0;
    my @filtros;
    
    # hay que hacer update de todos los campos porque si viene un nuevo orden y es justo ordenado (igual que @array : 1,2,3...)
    # tambien hay que actualizarlo
    foreach my $campo (@$newOrderArray){
    
        my $config_temp = C4::Modelo::CatVisualizacionOpac::Manager->get_cat_visualizacion_opac(
                                                                    query   => [ id => { eq => $campo}], 
                               );
        my $configuracion = $config_temp->[0];
          
        $configuracion->setOrden(@array[$i]);
    
        $i++;
    }
    
    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'M000', 'params' => []} ) ;

    return ($msg_object);
}

=item
    Esta funcion devuelve los items que tengan el campo recibido como parametro
=cut
sub getItemsByCampo{
    my ($campo) = @_;
    
    my @filtros;
    push (@filtros, (campo => { eq => $campo }));

    my $items = C4::Modelo::CatVisualizacionOpac::Manager->get_cat_visualizacion_opac(query => \@filtros);

    return ($items);
}


=item
    Funcion que actializa el orden de los campos. 
    Parametros: array con los ids en el orden nuevo
=cut
sub updateNewOrderGroup{
    my ($newOrderArray) = @_;
    my $msg_object      = C4::AR::Mensajes::create();
    
    my @worked; # array con los ids de los items que ya trabaje 
    
    # ordeno los ids que llegan desordenados primero, para obtener un clon de los ids, y ahora usarlo de indice para el orden
    # esto es porque no todos los campos de cat_visualizacion_opac se muestran en el template a ordenar 
    # entonces no puedo usar un simple indice como id.
    my @array = sort { $a <=> $b } @$newOrderArray;
    
    my $i = 0;
    
    # hay que hacer update de todos los campos porque si viene un nuevo orden y es justo ordenado (igual que @array : 1,2,3...)
    # tambien hay que actualizarlo
    foreach my $campo (@$newOrderArray){
    
        my $config_temp = C4::Modelo::CatVisualizacionOpac::Manager->get_cat_visualizacion_opac(
                                                                    query   => [ id => { eq => $campo}], 
                               );
        my $configuracion = $config_temp->[0];
        
        # si ya lo trabaje o no
        if (!($configuracion->getId() ~~ @worked)){
            my $items = getItemsByCampo($configuracion->getCampo());
            
            foreach my $item (@$items){
                $item->setOrden(@array[$i]);
                push (@worked, $item->getId());
                C4::AR::Debug::debug("nuevo orden a item : ".$item->getId()." es : ".@array[$i]);
            }    
            $i++;   
        }
    }
    
    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'M000', 'params' => []} ) ;

    return ($msg_object);
}


=item
    Funcion que devuelve TODOS los campos ordenados por orden
=cut
sub getConfiguracionByOrder{
    my ($ejemplar) = @_;

    my @filtros;
    
    push ( @filtros, ( or   => [    tipo_ejemplar   => { eq => $ejemplar }, 
                                tipo_ejemplar   => { eq => 'ALL'     } ]) #TODOS
    );                

    my $configuracion = C4::Modelo::CatVisualizacionOpac::Manager->get_cat_visualizacion_opac(query => \@filtros, sort_by => ('orden'),);

    return ($configuracion);
}


sub getConfiguracion{
    my ($nivel, $ejemplar, $db) = @_;

    my @filtros;
    $db = $db || C4::Modelo::CatVisualizacionOpac->new()->db;
    
    push ( @filtros, ( or   => [    tipo_ejemplar   => { eq => $ejemplar }, 
                                    tipo_ejemplar   => { eq => 'ALL'     } ]) #TODOS
                );

    push ( @filtros, ( nivel   => { eq => $nivel } ));

    my $configuracion = C4::Modelo::CatVisualizacionOpac::Manager->get_cat_visualizacion_opac(query => \@filtros, sort_by => ('campo, subcampo'), db => $db,);

    return ($configuracion);
}

sub getConfiguracionOAI{
    my ($db) = @_;
    
    $db = $db || C4::Modelo::CatVisualizacionOpac->new()->db;
    
    my $arreglo_marc = getCamposParaOAI();    

    my @configuracion = ();
    
    foreach my $marc (@$arreglo_marc){
    	
        my  $conf_object = C4::Modelo::CatVisualizacionOpac->new();
            $conf_object->campo($marc->getCampo);
            $conf_object->subcampo($marc->getSubcampo);

            push (@configuracion,$conf_object);
    }

    return (\@configuracion);
}

sub getVistaCampo{
    my ($campo, $template, $nivel, $db) = @_;

    $db = $db || C4::Modelo::CatVisualizacionOpac->new()->db;

    my @filtros;

    push ( @filtros, ( nivel   => { eq => $nivel } ));
    push ( @filtros, ( campo   => { eq => $campo } ));
    push ( @filtros, ( or   => [    tipo_ejemplar   => { eq => $template }, 
                                    tipo_ejemplar   => { eq => 'ALL'     } ]) #TODOS
                );

    #TESTING CACHE MERAN
    # my $key = C4::AR::Utilidades::joinArrayOfString(@filtros);
    my $key = $nivel.$campo.$template;
    # C4::AR::Debug::error("CACHED3!!!!!!!");

    if (defined C4::AR::CacheMeran::obtener($key)){
        # C4::AR::Debug::error("CACHED!!!!!!!");
        return C4::AR::CacheMeran::obtener($key);
    } else {

        my $configuracion = C4::Modelo::CatVisualizacionOpac::Manager->get_cat_visualizacion_opac(query => \@filtros, db => $db,);

        if(scalar(@$configuracion) > 0){
            # return $configuracion->[0]->getVistaCampo;
            C4::AR::CacheMeran::setear($key,$configuracion->[0]->getVistaCampo);
            return C4::AR::CacheMeran::obtener($key);
        } else {
            C4::AR::CacheMeran::setear($key,0);
            return 0;
        }
    }
}

sub getVistaOpac{
    my ($campo, $template, $nivel, $db) = @_;

    $db = $db || C4::Modelo::CatVisualizacionOpac->new()->db;

    my @filtros;

    push ( @filtros, ( nivel   => { eq => $nivel } ));
    push ( @filtros, ( campo   => { eq => $campo } ));
    push ( @filtros, ( or   => [    tipo_ejemplar   => { eq => $template }, 
                                    tipo_ejemplar   => { eq => 'ALL'     } ]) #TODOS
                );

    #TESTING CACHE MERAN
    # my $key = C4::AR::Utilidades::joinArrayOfString(@filtros);
    my $key = $nivel.$campo.$template;
# C4::AR::Debug::error("CACHED4!!!!!!!");

    if (defined C4::AR::CacheMeran::obtener($key)){
        # C4::AR::Debug::error(" CACHED!!!!!!!");
        return C4::AR::CacheMeran::obtener($key);
    } else {

        my $configuracion = C4::Modelo::CatVisualizacionOpac::Manager->get_cat_visualizacion_opac(query => \@filtros, db => $db,);

        if(scalar(@$configuracion) > 0){
            C4::AR::CacheMeran::setear($key, $configuracion->[0]->getVistaOpac);
            # return $configuracion->[0]->getVistaOpac;
            return C4::AR::CacheMeran::obtener($key);
        } else {
            C4::AR::CacheMeran::setear($key, 0);
            return 0;
        }

    }
}

sub addConfiguracion {
    my ($params, $db) = @_;

    my @filtros;

    my $configuracion = C4::Modelo::CatVisualizacionOpac->new( db => $db );

    $configuracion->agregar($params);
    C4::AR::Preferencias::unsetCacheMeran();

    return ($configuracion);
}

sub deleteConfiguracion{
    my ($params) = @_;
    my @filtros;
    my $vista_id = $params->{'vista_id'};
    my $msg_object;

    C4::AR::Utilidades::printHASH($params);

    push (@filtros, (id => { eq => $vista_id }) );
    my $configuracion = C4::Modelo::CatVisualizacionOpac::Manager->get_cat_visualizacion_opac(query => \@filtros,);

    if ($configuracion->[0]){
        $configuracion->[0]->delete();
        $msg_object->{'error'} = 0;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U608'} ) ;
        C4::AR::Preferencias::unsetCacheMeran();
    }else{
        $msg_object->{'error'} = 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U609'} ) ;

    }
    return($msg_object);
}
 
sub editConfiguracion{
    my ($vista_id,$value,$type) = @_;
    my @filtros;

    push (@filtros, (id => { eq => $vista_id }) );
    my $configuracion = C4::Modelo::CatVisualizacionOpac::Manager->get_cat_visualizacion_opac(query => \@filtros,);

    if ($configuracion->[0]){
        if($type eq "pre"){
            $configuracion->[0]->modificarPre($value);
            return ($configuracion->[0]->getPreLimpio());
        }
        elsif($type eq "inter"){
            $configuracion->[0]->modificarInter($value);
            return ($configuracion->[0]->getInterLimpio());
        }
        elsif($type eq "post"){
            $configuracion->[0]->modificarPost($value);
            return ($configuracion->[0]->getPostLimpio());
        }
        elsif($type eq "nivel"){
            $configuracion->[0]->modificarNivel($value);
            return ($configuracion->[0]->getNivel());
        }
        else{
            $configuracion->[0]->modificar($value);
            return ($configuracion->[0]->getVistaOpac());
        }
        C4::AR::Preferencias::unsetCacheMeran();
    }else{
        return(0);
    }
}

=head2 sub getSubCamposLike
    Obtiene los subcampos haciendo busqueda like, para el nivel indicado
=cut
sub getSubCamposLike{
    my ($campo) = @_;

    my @filtros;

    push(@filtros, ( campo => { eq => $campo} ) );

    my $db_campos_MARC = C4::Modelo::CatEstructuraCatalogacion::Manager->get_cat_estructura_catalogacion(
                                                                query => \@filtros,
                                                                sort_by => ('subcampo'),
                                                                select   => [ 'subcampo', 'liblibrarian', 'obligatorio' ],
                                                                group_by => [ 'subcampo'],
                                                            );
    return($db_campos_MARC);
}

=head2 sub getCamposXLike
    Busca un campo like..., segun nivel indicado
=cut
sub getCamposXLike{
    my ($campoX) = @_;

    my @filtros;

    push(@filtros, ( campo => { like => $campoX.'%'} ) );

    my $db_campos_MARC = C4::Modelo::CatEstructuraCatalogacion::Manager->get_cat_estructura_catalogacion(
                                                                                        query => \@filtros,
                                                                                        sort_by => ('campo'),
                                                                                        select   => [ 'campo', 'liblibrarian'],
                                                                                        group_by => [ 'campo'],
                                                                       );
    return($db_campos_MARC);
}

=head2 sub getVisualizacionFromCampoSubCampo
    Este funcion devuelve la configuracion de la estructura de catalogacion de un campo, subcampo, realizada por el usuario
=cut
sub getVisualizacionFromCampoSubCampo{
    my ($campo, $subcampo, $tipo_ejemplar, $nivel, $db) = @_;

    $db = $db || C4::Modelo::CatVisualizacionOpac->new()->db;
    my @filtros;
    
    push(@filtros, ( campo          => { eq => $campo } ) );
    push(@filtros, ( subcampo       => { eq => $subcampo } ) );
    push(@filtros, ( nivel          => { eq => $nivel } ) );
    push (  @filtros, ( or   => [   tipo_ejemplar   => { eq => $tipo_ejemplar }, 
                                    tipo_ejemplar   => { eq => 'ALL'     } ])
                     );

    my $key = $campo.$subcampo.$nivel.$tipo_ejemplar;
    my $cat_estruct_info_array;

# C4::AR::Debug::error("CACHED2!!!!!!!".C4::AR::CacheMeran::obtener($key)." es ".$key);

    if (defined C4::AR::CacheMeran::obtener($key)){
        $cat_estruct_info_array = C4::AR::CacheMeran::obtener($key);

    } else { 

        my $cat_estruct_info_array = C4::Modelo::CatVisualizacionOpac::Manager->get_cat_visualizacion_opac(  
                                                                                    query           =>  \@filtros,
                                                                                    db              => $db, 

                                            );  

        if(scalar(@$cat_estruct_info_array) > 0){
            C4::AR::CacheMeran::setear($key, $cat_estruct_info_array->[0]);
            # C4::AR::Debug::error("CACHED2.1!!!!!!!".C4::AR::CacheMeran::obtener($key)." es ".$key);
            return C4::AR::CacheMeran::obtener($key);
          # return $cat_estruct_info_array->[0];
        }else{
            # C4::AR::Debug::error("CACHED2.2!!!!!!!".C4::AR::CacheMeran::obtener($key)." es ".$key);
            C4::AR::CacheMeran::setear($key,0);
            return 0;
        }
    }
}

=item sub getVisualizacionFromCampoAndNivel

  el campo puede estar repedido ya q se agrupa campo y subcampo, pero todo los campos iguales y del mismo nivel deben tener el mismo orden
=cut
sub getVisualizacionFromCampoAndNivel{
    my ($campo, $nivel, $itemtype, $db) = @_;
    $db = $db || C4::Modelo::CatVisualizacionOpac->new()->db;
    my @filtros;

    push( @filtros, ( campo 	=> { eq => $campo } ) );
    push( @filtros, ( nivel 	=> { eq => $nivel } ) );
    push ( @filtros, ( or   => [   tipo_ejemplar   => { eq => $itemtype }, 
                                    tipo_ejemplar   => { eq => 'ALL'     } ])
                     );


#TESTING CACHE MERAN
    # my $key = C4::AR::Utilidades::joinArrayOfString(@filtros);
    # FIXME esta clave no esta bien armada, faltan los operadores logicos
    my $key = $campo.$nivel.$itemtype;
    my $cat_estruct_info_array;

    if (defined C4::AR::CacheMeran::obtener($key)){
        # C4::AR::Debug::error("CACHED!!!!");
        $cat_estruct_info_array = C4::AR::CacheMeran::obtener($key);

    } else {

        my $cat_estruct_info_array = C4::Modelo::CatVisualizacionOpac::Manager->get_cat_visualizacion_opac(  
                                                                                    query           =>  \@filtros,
                                                                                    db              => $db, 

                                            );  

        if(scalar(@$cat_estruct_info_array) > 0){
          # C4::AR::Debug::debug("VisualizacionOpac => getVisualizacionFromCampoAndNivel => lo encontre!!!");
          C4::AR::CacheMeran::setear($key, $cat_estruct_info_array->[0]);
          return C4::AR::CacheMeran::obtener($key);
          # return $cat_estruct_info_array->[0];
        }else{
            C4::AR::CacheMeran::setear($key, 0);
            return 0;
        }
    }
}


sub existeConfiguracion{
    my ($params) = @_;

    my @filtros;

    push(@filtros, ( campo          => { eq => $params->{'campo'} } ));
    push(@filtros, ( subcampo       => { eq => $params->{'subcampo'} } ));
    push(@filtros, ( nivel          => { eq => $params->{'nivel'} } ));
    push(@filtros, ( tipo_ejemplar  => { eq => $params->{'ejemplar'} } ));
#    push ( @filtros, ( or   => [    tipo_ejemplar   => { eq => $params->{'ejemplar'} }, 
#                                    tipo_ejemplar   => { eq => 'ALL'     } ]) #TODOS
#    );


    my $cat_estruct_info_array = C4::Modelo::CatVisualizacionOpac::Manager->get_cat_visualizacion_opac(  
                                                                                query           =>  \@filtros, 

                                        );  

    if(scalar(@$cat_estruct_info_array) > 0){
      return 1;
    }else{
      return 0;
    }
}

=head2 sub t_agregar_configuracion
   
=cut
sub t_agregar_configuracion {
    my ($params) = @_;

    my $visualizacion_opac  = C4::Modelo::CatVisualizacionOpac->new();  
    my $db                  = $visualizacion_opac->db;
    my $msg_object          = C4::AR::Mensajes::create();

    if(existeConfiguracion($params)){

        $msg_object->{'error'} = 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U605', 'params' => [$params->{'campo'}, $params->{'subcampo'}, $params->{'ejemplar'}, $params->{'nivel'}]} ) ;

    } else {
        # enable transactions, if possible
        $db->{connect_options}->{AutoCommit} = 0;
    
        eval {

            C4::AR::VisualizacionOpac::addConfiguracion($params, $db);
            $msg_object->{'error'} = 0;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U607', 'params' => [$params->{'campo'}, $params->{'subcampo'}, $params->{'ejemplar'}]} ) ;

            $db->commit;
        };

        if ($@){
            my $errorDB = $@;

            #Se loguea error de Base de Datos
            &C4::AR::Mensajes::printErrorDB($@, 'B432',"INTRA");
            $db->rollback;
            
            #Se setea error para el usuario
            $msg_object->{'error'} = 1;

            if($errorDB =~ 'Duplicate entry'){
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U613', 'params' => [$params->{'campo'}, $params->{'subcampo'}, $params->{'ejemplar'}]} ) ;
            }else{
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U606', 'params' => [$params->{'campo'}, $params->{'subcampo'}, $params->{'ejemplar'}]} ) ;
            } 
        }

        $db->{connect_options}->{AutoCommit} = 1;

    }

    return ($msg_object);
}

=item
    Funcion que devuelve TODOS los campos ordenados por orden y por nivel si recibe el parametro nivel y agrupados por campo.
    Si no tiene seteado el campo vista_campo lo saca desde la base
=cut
sub getConfiguracionByOrderGroupCampo{
    my ($ejemplar,$nivel) = @_;

    my @filtros;
    
    push ( @filtros, ( or   => [    tipo_ejemplar   => { eq => $ejemplar }, 
                                    tipo_ejemplar   => { eq => 'ALL'     } ]),
                                
    );
    
    if($nivel){
        push (@filtros, (nivel => { eq => $nivel }) );
    }

    my $configuracion = C4::Modelo::CatVisualizacionOpac::Manager->get_cat_visualizacion_opac(query => \@filtros, sort_by => ('orden'), group_by => ('campo'));
    
    foreach my $conf (@$configuracion){
        if($conf->getVistaCampo() eq ""){
            $conf->{'vista_campo'} = C4::AR::EstructuraCatalogacionBase::getLabelByCampo($conf->getCampo());
        }
    }

    return ($configuracion);
}


sub getCamposParaOAI{

    my @filtros;
    my %hash_fields = {};

    use C4::Modelo::MapeoOai;
    use C4::Modelo::MapeoOai::Manager;

    my $mapeoOai = C4::Modelo::MapeoOai::Manager->get_mapeo_oai();



    foreach my $obj (@$mapeoOai) {

        push ( @filtros, ( or   => [ subcampo   => { eq => $obj->getSubCampo() }, 
                                     campo      => { eq => $obj->getCampo() } ]),

        );

    }
    
    my $result = C4::Modelo::PrefEstructuraSubcampoMarc::Manager->get_pref_estructura_subcampo_marc( );



    return ($result);
    
}

sub __updateCacheOPAC{

    use HTTP::Request;
    use LWP::UserAgent;

    my $ua = LWP::UserAgent->new;

    my $req = HTTP::Request->new(GET => "http://".C4::AR::Utilidades::getUrlOpac()."/clean_opac_cache.pl");

    $ua->request($req);    

}

sub updateCacheOPAC{

    use C4::AR::BackgroundJob;
    use Proc::Simple;

    my $job = "ACTUALIZAR_CACHE_OPAC";
    my $proc = Proc::Simple->new();

    $proc->start(\&C4::AR::VisualizacionOpac::__updateCacheOPAC,1,$job);    

}

END { }       # module clean-up code here (global destructor)

1;
__END__
