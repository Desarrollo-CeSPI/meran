package C4::AR::Preferencias;

#
#Este modulo sera el encargado del manejo de las preferencias del sistema.
#

use strict;
require Exporter;
#use C4::Context;
use C4::Date;
use C4::Modelo::PrefPreferenciaSistema;
use C4::Modelo::PrefPreferenciaSistema::Manager;
use C4::Modelo::PrefAbout;
use C4::Modelo::PrefAbout::Manager;

use vars qw(@EXPORT_OK @ISA),qw($PREFERENCES);

@ISA=qw(Exporter);

@EXPORT_OK=qw(
    updateInfoAbout
    getInfoAbout
    getPreferencia
    setVariable
    getValorPreferencia
    getPreferenciaLike
    t_guardarVariable
    t_modificarVariable
    getMenuPreferences
    getPreferenciasByArray
    verificar_preferencias
    getPreferenciasLikeCategoria
    getMetodosAuth
    getPreferenciasBooleanas
);


=item
    Esta funcion actualiza pref_about.
=cut
sub updateInfoAbout{
    my ($param)     = @_;
    my $pref_about  = getInfoAbout();
    my $msg_object  = C4::AR::Mensajes::create();
    my $db          = $pref_about->db;
    
    #_verificarDatosTexto($param,$msg_object);
        
    if (!($msg_object->{'error'})){
        # entro si no hay algun error, el texto ingresado es valido
        $db->{connect_options}->{AutoCommit} = 0;
        $db->begin_work;
          
        eval{
            $pref_about->updateInfoAbout($param);   
            $msg_object->{'error'} = 0;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A001', 'params' => []});
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
    Esta funcion retorna 0 si alguna preferencia de las requeridas en el arreglo no existe, 
    y devuelve en $variable el nombre de la primer preferencia no encontrada
    Devuelve un objeto o 0.
=cut
sub verificar_preferencias{

    my ($variables_array)= @_;

    my @filtros;
    my %preferencias_hash;

    foreach my $variable (@$variables_array){

        push (@filtros, (  variable => {eq => $variable} ) );

    }

    my $preferencias_array_ref = 
        C4::Modelo::PrefPreferenciaSistema::Manager->get_pref_preferencia_sistema( 
                                                                        query => [ or  => \@filtros ]
                                                                                 );
    my $existe = 1;
    my $variable = "";
    
    foreach my $preferencia (@$preferencias_array_ref){
        $variable = $preferencia->getVariable;
        $existe = C4::AR::Utilidades::existeInArray($variable,@$variables_array);
        if (!$existe){
            return($existe,$variable);
        }
    }
    
    return($existe,$variable);
    
}

=item
    Esta funcion trae la informacion de pref_about.
    Devuelve un objeto o 0.
=cut
sub getInfoAbout{
    my @filtros;
    
    my $info_about_ref = C4::Modelo::PrefAbout::Manager->get_pref_about( query => \@filtros );
    
    if ($info_about_ref->[0]){
        return ($info_about_ref->[0]);
    } else{
        return C4::Modelo::PrefAbout->new();
    }
}


sub reloadAllPreferences {
       $PREFERENCES = undef;
       $PREFERENCES = C4::AR::Preferencias::getAllPreferencias();
}

sub getPreferenciasByArray {
    my ($variables_array)= @_;
    
    # C4::AR::Debug::debug("ENTRO A getPreferenciasByArray() ===> FIXEAR PARA QUE USE LA CACHE!!!");

    my @filtros;
    my %preferencias_hash;

    foreach my $variable (@$variables_array){

        push (@filtros, (  variable => {eq => $variable} ) );

    }

    my $preferencias_array_ref = C4::Modelo::PrefPreferenciaSistema::Manager->get_pref_preferencia_sistema( query => [ or  => \@filtros ]);

   if ($preferencias_array_ref){

        foreach my $p (@$preferencias_array_ref){
            $preferencias_hash{$p->getVariable} = $p->getValue;
        }

        return \%preferencias_hash;
    } else{
        return undef;
    }
}


sub getAllPreferencias {
    
    my %preferencias_hash;

    require C4::Modelo::PrefPreferenciaSistema;
    require C4::Modelo::PrefPreferenciaSistema::Manager;

    my $preferencias_array_ref = C4::Modelo::PrefPreferenciaSistema::Manager->get_pref_preferencia_sistema();

    if ($preferencias_array_ref){

        foreach my $p (@$preferencias_array_ref){
            $preferencias_hash{$p->getVariable} = $p->getValue;
        }

        return \%preferencias_hash;
        
    } else{
        return undef;
    }
}


sub getMenuPreferences{

    my %hash;
    
    $hash{'showMenuItem_circ_devolucion_renovacion'} = C4::AR::Preferencias::getValorPreferencia('showMenuItem_circ_devolucion_renovacion');
    $hash{'showMenuItem_circ_prestamos'}             = C4::AR::Preferencias::getValorPreferencia('showMenuItem_circ_prestamos');

      

    return (\%hash);
}

=item
    Devuelve las preferencias booleanas de la categoria recibida como parametro
=cut
sub getPreferenciasBooleanas{

    my ($categoria) = @_;
  
    my $preferencias_array_ref = C4::Modelo::PrefPreferenciaSistema::Manager->get_pref_preferencia_sistema( 
                                        #select  => ['variable'],
                                        query   => [    categoria   => { eq => $categoria },
                                                        type        => { eq => 'bool' },
                                        ],
                                        sort_by => ['categoria','label'],

                                ); 

    return $preferencias_array_ref;
}

=item
    Devuelve una referencia con todas las preferencias filtradas por categoria
=cut
sub getPreferenciasByCategoria{
    my ($str)=@_;
        
    my $preferencias_array_ref;
    my $prefTemp = C4::Modelo::PrefPreferenciaSistema->new();
  
    $preferencias_array_ref = C4::Modelo::PrefPreferenciaSistema::Manager->get_pref_preferencia_sistema( 
                                        query => [ categoria => { eq => $str }],
                                        sort_by => ['categoria','label'],
                                ); 

    my $preferencias_array_ref_count = C4::Modelo::PrefPreferenciaSistema::Manager->get_pref_preferencia_sistema_count( 
                                        query => [ categoria => { eq => $str }],
                                );

    return ($preferencias_array_ref_count, $preferencias_array_ref);
}

=item
    Devuelve una referencia con todas las preferencias filtradas por categoria, con like categoria
=cut
sub getPreferenciasLikeCategoria{
    my ($str)=@_;
    
    my $preferencias_array_ref;
    my $prefTemp = C4::Modelo::PrefPreferenciaSistema->new();
  
    $preferencias_array_ref = C4::Modelo::PrefPreferenciaSistema::Manager->get_pref_preferencia_sistema( 
                                        query => [ categoria=> { like => '%'.$str.'%' }],
                                        sort_by => ['categoria','label'],
                                ); 

    return (scalar($preferencias_array_ref), $preferencias_array_ref);
}

=item
    Misma funcion que arriba, pero devuelve una hash armada
=cut
sub getPreferenciasByCategoriaHash{
    my ($str)=@_;
        
    my $preferencias_array_ref;
    my $prefTemp = C4::Modelo::PrefPreferenciaSistema->new();
  
    $preferencias_array_ref = C4::Modelo::PrefPreferenciaSistema::Manager->get_pref_preferencia_sistema( 
                                        query => [ categoria => { eq => $str }],
                                );
    my %hash;
    foreach my $pref (@$preferencias_array_ref){
        $hash{$pref->getVariable} = $pref->getValue();
    }

    return (\%hash); 
} 

sub getPreferenciaLike {
    my ($str,$orden)=@_;

    # C4::AR::Debug::debug("getValorPreferencia => getPreferenciaLike == $str");

    my $preferencias_array_ref;
    my @filtros;
    my $prefTemp = C4::Modelo::PrefPreferenciaSistema->new();
  
    $preferencias_array_ref = C4::Modelo::PrefPreferenciaSistema::Manager->get_pref_preferencia_sistema( 
                                        query => [ variable=> { like => '%'.$str.'%' }],
                                        sort_by => ['categoria','label'],
                                ); 

    return (scalar($preferencias_array_ref), $preferencias_array_ref);
}

# busca el nombre de una preferencia dentro de la categoria recibida como parametro
sub getPreferenciaLikeConCategoria {
    my ($str,$orden,$categoria)=@_;

    my $preferencias_array_ref;
    my @filtros;
    my $prefTemp = C4::Modelo::PrefPreferenciaSistema->new();
  
    $preferencias_array_ref = C4::Modelo::PrefPreferenciaSistema::Manager->get_pref_preferencia_sistema( 
                                        query => [  variable  => { like => '%'.$str.'%' },
                                                    categoria => { like => $categoria.'%' } ],
                                        sort_by => ['categoria','label'],
                                ); 

    return (scalar($preferencias_array_ref), $preferencias_array_ref);
}


sub getPreferencia{
    my ($variable)  = @_;
    
#     C4::AR::Debug::debug("ENTRO A getPreferencia() ===> FIXEAR PARA QUE USE LA CACHE!!!");

    my $preferencia_array_ref = C4::Modelo::PrefPreferenciaSistema::Manager->get_pref_preferencia_sistema( query => [ variable => { eq => "".$variable} ]);

    if ($preferencia_array_ref->[0]){
        return ($preferencia_array_ref->[0]);
    } else{
        return undef;
    }
}


sub getValorPreferencia {
    my ($variable)  = @_;

#    verifico si se encuentra en la cache, sino se busca de la base
    if (defined $PREFERENCES->{$variable}){
          # C4::AR::Debug::debug("Preferencias => getValorPreferencia => VARIABLE ==".$variable."== valor => ".$PREFERENCES->{$variable}." CACHED!!!!!!!");
        return $PREFERENCES->{$variable};
    }

      # C4::AR::Debug::debug("Preferencias => getValorPreferencia => VARIABLE ==".$variable."== NO CACHED!!!!!!!");
    my $preferencia_array_ref = C4::Modelo::PrefPreferenciaSistema::Manager->get_pref_preferencia_sistema( query => [ variable => { eq => $variable} ]);

    if ($preferencia_array_ref->[0]){
        return ($preferencia_array_ref->[0]->getValue);
    } else{
        return 0;
    }
}


=item
guardarVariable
guarda la variable del sistema ingresada.
=cut
sub t_guardarVariable {
    my ($var,$val,$exp,$tipo,$op)=@_;
    
    my %params;
    $params{'variable'}       = $var;
    $params{'value'}          = $val;
    $params{'explanation'}    = $exp;
    $params{'options'}        = $op;
    $params{'type'}           = $tipo;


    my $msg_object= C4::AR::Mensajes::create();
    _verificarDatosVariable(\%params,$msg_object);

    if(!$msg_object->{'error'}){
        my ($preferencia) = C4::Modelo::PrefPreferenciaSistema->new();
        my $db = $preferencia->db;

        $db->{connect_options}->{AutoCommit} = 0;
        $db->begin_work;
    eval {
        $preferencia->agregar(\%params);
        $db->commit;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP004', 'params' => []} ) ;
    };
    if ($@){
        #Se loguea error de Base de Datos
        &C4::AR::Mensajes::printErrorDB($@, 'SP001','INTRA');
        eval{$db->rollback};
        #Se setea error para el usuario
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP001', 'params' => []} ) ;
    }
        $db->{connect_options}->{AutoCommit} = 1;
    }
    return ($msg_object);
}

sub setVariable {
    my ($variable, $valor, $db) = @_;
    
    my  $preferencia;

    if($db){
        $preferencia = C4::Modelo::PrefPreferenciaSistema::Manager->get_pref_preferencia_sistema( db => $db,query => [variable => {eq => $variable}] );
    } else {
        $preferencia = C4::Modelo::PrefPreferenciaSistema::Manager->get_pref_preferencia_sistema( query => [variable => {eq => $variable}] );
    } 

    if(scalar(@$preferencia) > 0){
        C4::AR::Debug::debug("Preferencias => setVariable => ".$variable." valor => ".$valor);
       C4::AR::Debug::debug("Preferencias => setVariable => ".$variable." valor CACHE antes => ".$PREFERENCES->{$variable});
        $preferencia->[0]->setValue($valor);
        $preferencia->[0]->save();
        reloadAllPreferences();
        C4::AR::Debug::debug("Preferencias => getVariable => ".$variable." valor desde la base => ".C4::AR::Preferencias::getValorPreferencia($variable));
    }
}


sub _verificarDatosVariable {
    my($params,$msg_object)=@_;

    my $var= $params->{'variable'};
    my $val= $params->{'value'};
    my $type= $params->{'type'};
    my $exp= $params->{'explanation'};
    my $op= $params->{'options'};

#Se verifica que el no exista ya la variable que se quiere agregar
    if( getPreferencia($var) ){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP005', 'params' => []} ) ;
    }

}

sub t_modificarVariable {
    my ($var, $valor, $expl, $categoria) = @_;
    
    my $params;
    $params->{'value'}          = $valor;
    $params->{'explanation'}    = $expl;
    $params->{'categoria'}      = $categoria;
    $params->{'variable'}       = $var;
    my $msg_object              = C4::AR::Mensajes::create();
    my ($preferencia)           = C4::Modelo::PrefPreferenciaSistema->new( variable => $var );
    $preferencia->load();
    my $db                      = $preferencia->db; 

    $db->{connect_options}->{AutoCommit} = 0;
    $db->begin_work;
    eval {
        $preferencia->modificar($params);
        $PREFERENCES->{$params->{'variable'}} = $params->{'value'};
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP003', 'params' => []} ) ;
        $db->commit;
    };

    if ($@){
        #Se loguea error de Base de Datos
        &C4::AR::Mensajes::printErrorDB($@, 'SP001','INTRA');
        eval{$db->rollback};
        #Se setea error para el usuario
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP001', 'params' => []} ) ;
    }

    $db->{connect_options}->{AutoCommit} = 1;

    return ($msg_object);
}


sub getConfigVisualizacionOPAC{
    my $self = shift;

    my %hash_config = {};
    $hash_config{'resumido'}            = C4::AR::Preferencias::getValorPreferencia("detalle_resumido") || 0;

    return (\%hash_config);
}

sub getMetodosAuth{
    my @filtros;
    my @arreglo_temp;
        
    use C4::Modelo::SysMetodoAuth::Manager;
    
    push (@filtros, ('enabled' => {eq => 1}) );
    
    my $metodos_auth = C4::Modelo::SysMetodoAuth::Manager::get_sys_metodo_auth( query => \@filtros, 
                                                                                sort_by => 'orden ASC',
                                                                              );
    
    foreach my $metodo (@$metodos_auth){
        push (@arreglo_temp, $metodo->getMetodo);
    }

    return (\@arreglo_temp);
}

sub getMetodosAuthAll{
    
    use C4::Modelo::SysMetodoAuth::Manager;
    my $metodos_auth = C4::Modelo::SysMetodoAuth::Manager::get_sys_metodo_auth( query => [], 
                                                                                sort_by => 'orden ASC',
                                                                              );

    return ($metodos_auth);
}

# get all servers
sub getSysExternosMeran {

    use C4::Modelo::SysExternosMeran::Manager;
    my $sys_externos_meran = C4::Modelo::SysExternosMeran::Manager::get_sys_externos_meran();

    return ($sys_externos_meran);
}

# get only one server
sub getSysExternoMeran {
    my ($id_server) = @_;
    my @filtros;
        
    use C4::Modelo::SysExternosMeran::Manager; 
    push (@filtros, ('id' => {eq => $id_server}) );

    my $sys_externo_meran = C4::Modelo::SysExternosMeran::Manager::get_sys_externos_meran(query => \@filtros);

    return ($sys_externo_meran->[0]);
}

# get only one server
sub editSysExternoMeran {
    my ($id, $url, $id_ui) = @_;
    my @filtros;
    my $msg_object = C4::AR::Mensajes::create();

    use C4::Modelo::SysExternosMeran::Manager; 
    push (@filtros, ('id' => {eq => $id}) );

    my $sys_externo_meran = C4::Modelo::SysExternosMeran::Manager::get_sys_externos_meran(query => \@filtros);

    $sys_externo_meran = $sys_externo_meran->[0];
    
    if ($sys_externo_meran) {
        
        my $db = $sys_externo_meran->db;
        $db->begin_work;
        
        eval{
            $sys_externo_meran->edit($url, $id_ui);
            $sys_externo_meran->save();
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SEM03', 'params' => []});
            $db->commit;
        };
        if ($@){
            # TODO falta definir el mensaje "amigable" para el usuario informando que no se pudo agregar el proveedor
            &C4::AR::Mensajes::printErrorDB($@, 'B460',"INTRA");
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SEM02', 'params' => []} ) ;
            $db->rollback;
        }
    }
    return ($msg_object);
}

sub deleteSysExternoMeran {
    my ($id, $url, $id_ui) = @_;
    my @filtros;

    use C4::Modelo::SysExternosMeran::Manager; 
    push (@filtros, ('id' => {eq => $id}) );

    my $sys_externo_meran = C4::Modelo::SysExternosMeran::Manager::get_sys_externos_meran(query => \@filtros);

    $sys_externo_meran = $sys_externo_meran->[0];

    my $db = $sys_externo_meran->db;
    $db->begin_work;
    my $msg_object = C4::AR::Mensajes::create();
    eval{
        $sys_externo_meran->delete();
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SEM04', 'params' => []});
        $db->commit;
    };
    if ($@){
        # TODO falta definir el mensaje "amigable" para el usuario informando que no se pudo agregar el proveedor
        &C4::AR::Mensajes::printErrorDB($@, 'B460',"INTRA");
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SEM05', 'params' => []} ) ;
        $db->rollback;
    }
    return ($msg_object);
}

sub addSysExternoMeran {
    use C4::Modelo::SysExternosMeran;
    my ($url, $id_ui)       = @_;
    my $sys_externo_meran   = C4::Modelo::SysExternosMeran->new();
    my $msg_object          = C4::AR::Mensajes::create();
    my $db                  = $sys_externo_meran->db;
    $db->begin_work;
    
    eval{
        $sys_externo_meran->add($url, $id_ui);
        $sys_externo_meran->save();
        $msg_object->{'error'} = 0;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SEM01', 'params' => []});
        $db->commit;
    };
    if ($@){
        # TODO falta definir el mensaje "amigable" para el usuario informando que no se pudo agregar el proveedor
        &C4::AR::Mensajes::printErrorDB($@, 'B460',"INTRA");
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SEM02', 'params' => []} ) ;
        $db->rollback;
    }
    return ($msg_object);
}

sub unsetCacheMeran{
    C4::AR::CacheMeran::borrar();
}

BEGIN{
      C4::AR::Preferencias::reloadAllPreferences();
      #TESTING CACHE_MERAN
      #$JUAN = "pruebw";#C4::AR::CacheMeran->new();
};



END { }       # module clean-up code here (global destructor)

1;
__END__
