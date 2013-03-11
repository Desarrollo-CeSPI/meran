package C4::AR::Permisos;

use strict;
require Exporter;
use C4::Context;
# use CGI::Session;
use C4::Modelo::PermCatalogo;
use C4::Modelo::PermCatalogo::Manager;
use C4::Modelo::PermGeneral;
use C4::Modelo::PermGeneral::Manager;
use C4::Modelo::PermCirculacion;
use C4::Modelo::PermCirculacion::Manager;
# use CGI;
use Encode;
# use JSON;
use POSIX qw(ceil floor); #para redondear cuando divido un numero

use constant {
        AUX             => '00100000',
        TODOS           => '00010000',
        ALTA            => '00001000',
        BAJA            => '00000100',
        MODIFICACION    => '00000010',
        CONSULTA        => '00000001'
};

use vars qw(@ISA @EXPORT);
@ISA=qw(Exporter);
@EXPORT=qw(
    &obtenerPermisos
);

our @EXPORT= ('TODOS', 'ALTA', 'BAJA', 'MODIFICACION', 'CONSULTA');


sub getPermCatalogoOne{

    my ($filtros,$db)= @_;

    $db = $db || C4::Modelo::PermCatalogo->new()->db;

    my $permiso = getPermCatalogo($filtros,$db);

    if ($permiso){
        return($permiso->[0]);
    }else{
      return(0);
    }
}

sub getPermGeneralOne{

    my ($filtros,$db)= @_;

    $db = $db || C4::Modelo::PermGeneral->new()->db;

    my $permiso = getPermGeneral($filtros,$db);

    if ($permiso){
        return($permiso->[0]);
    }else{
      return(0);
    }
}

sub getPermCirculacionOne{

    my ($filtros,$db)= @_;


    my $permiso = getPermCirculacion($filtros,$db);

    if ($permiso){
        return($permiso->[0]);
    }else{
      return(0);
    }
}



sub getPermCatalogo{

    my ($filtros,$db)= @_;

    $db = $db || C4::Modelo::PermCatalogo->new()->db;
    my $permiso = C4::Modelo::PermCatalogo::Manager->get_perm_catalogo(db => $db, query => $filtros,);

    if (scalar(@$permiso)){
        return($permiso);
    }else{
      return(0);
    }
}

sub getPermGeneral{

    my ($filtros,$db)= @_;

    $db = $db || C4::Modelo::PermGeneral->new()->db;

    my $permiso = C4::Modelo::PermGeneral::Manager->get_perm_general(db => $db, query => $filtros,);

    if (scalar(@$permiso)){
        return($permiso);
    }else{
      return(0);
    }
}

sub getPermCirculacion{

    my ($filtros,$db)= @_;

    $db = $db || C4::Modelo::PermCirculacion->new()->db;

    my $permiso = C4::Modelo::PermCirculacion::Manager->get_perm_circulacion(db => $db, query => $filtros,);

    if (scalar(@$permiso)){
        return($permiso);
    }else{
      return(0);
    }
}

sub getAltaByte{
  return ALTA;
}

sub getBajaByte{
  return BAJA;
}

sub getModificacionByte{
  return MODIFICACION;
}

sub getConsultaByte{
  return CONSULTA;
}

sub getTodosByte{
  return TODOS;
}

sub getSelectorByte{
  return AUX;
}

sub getRegularByte{
  return AUX;
}



# FUNCIONES COMUNES A TODOS LOS PERMISOS

sub checkTipoPermiso{

    my ($entorno_byte,$tipo_permiso)= @_;
    my $flag;
    my $result;
    if($tipo_permiso eq 'TODOS'){
        $flag= getTodosByte();
        $result = substr($entorno_byte,3,1);
    }elsif($tipo_permiso eq 'ALTA'){
        $flag= getAltaByte();
        $result = substr($entorno_byte,4,1);
    }elsif($tipo_permiso eq 'BAJA'){
        $flag= getBajaByte();
        $result = substr($entorno_byte,5,1);
    }elsif($tipo_permiso eq 'MODIFICACION'){
        $flag= getModificacionByte();
        $result = substr($entorno_byte,6,1);
    }elsif($tipo_permiso eq 'CONSULTA'){
        $flag= getConsultaByte();
        $result = substr($entorno_byte,7,1);
    }
    return ($result);
}

sub parsearPermisos{

    my ($permiso)= @_;

    my @tipo_permiso = ('ALTA','CONSULTA','MODIFICACION','BAJA','TODOS'); 
    my $entornos = $permiso->meta->columns;
    my %hash_permisos = {};
    foreach my $entorno (@$entornos){
        foreach my $flag (@tipo_permiso){
            $hash_permisos{$entorno}{$flag} = C4::AR::Permisos::checkTipoPermiso($permiso->{$entorno},$flag);
        }
    }
    return (\%hash_permisos);
#    return ($permiso);

}

sub armarByte{

    my ($permiso)= @_;

    my $byte = '000';

    $byte.= $permiso->{'todos'}.$permiso->{'alta'}.$permiso->{'baja'}.$permiso->{'modif'}.$permiso->{'consulta'};

    return ($byte);
}


sub procesarPermisos{

    my ($permisos_array)= @_;

    my %hash_permisos;

    foreach my $permiso (@$permisos_array){

        $hash_permisos{$permiso->{'nombre'}} = C4::AR::Permisos::armarByte($permiso);
    }

    return (\%hash_permisos);
}

sub permisos_str_to_bin {

    my ($permisos) = @_;
    my $flag;

    $flag= '00000000';

    if($permisos eq 'TODOS'){
        $flag= getTodosByte();
    }elsif($permisos eq 'ALTA'){
        $flag= getAltaByte();
    }elsif($permisos eq 'BAJA'){
        $flag= getBajaByte();
    }elsif($permisos eq 'MODIFICACION'){
        $flag= getModificacionByte();
    }elsif($permisos eq 'CONSULTA'){
        $flag= getConsultaByte();
    }

    return $flag;
}


# FUNCIONES DE PERMISOS PARA CATALOGO

sub actualizarPermisosCatalogo{

    my ($nro_socio,$id_ui,$tipo_documento,$permisos_array)= @_;

    my @filtros;
    my $hash_permisos = C4::AR::Permisos::procesarPermisos($permisos_array); #DEBE HACER UNA HASH TENIENDO COMO CLAVE EL NOMBRE
    my @filtros;
    my $msg_object= C4::AR::Mensajes::create();
    
    push (@filtros, (nro_socio => {eq => $nro_socio}));
    push (@filtros, (ui => {eq => $id_ui}));
    push (@filtros, (tipo_documento => {eq => $tipo_documento}));
  
    my $permiso = getPermCatalogoOne(\@filtros);
    if ($permiso){
        eval{
            $hash_permisos->{'tipo_documento'} = $tipo_documento;
            $hash_permisos->{'nro_socio'} = $nro_socio;
            $id_ui = $id_ui || 'ALL';
            $hash_permisos->{'id_ui'} = $id_ui;
    
            $permiso->agregar($hash_permisos);
            $permiso = C4::AR::Permisos::parsearPermisos($permiso);
     
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U317', 'params' => []});
    
            return ($msg_object);
        };
        
        if ($@){
            &C4::AR::Mensajes::printErrorDB($@, 'B423',"INTRA");
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U502', 'params' => [$permiso->getNro_socio]} ) ;
        }
        
    }
    return ($msg_object);

}

sub obtenerPermisosCatalogo{

    my ($nro_socio,$id_ui,$tipo_documento,$perfil)= @_;
    my $permisos;
    my @filtros;
    my $newUpdate;

    push (@filtros, (nro_socio => {eq => $nro_socio}));
    $id_ui = $id_ui || 'ANY';
    push (@filtros, (ui => {eq => $id_ui}));
    push (@filtros, (tipo_documento => {eq => $tipo_documento}));

    $permisos = C4::AR::Permisos::getPermCatalogoOne(\@filtros);

    if ($permisos){
        $permisos = C4::AR::Permisos::armarPerfilCatalogo($perfil,$permisos);
        $permisos = C4::AR::Permisos::parsearPermisos($permisos);
        $newUpdate = 0;
    }else{
        if ($perfil){
            $permisos = C4::AR::Permisos::armarPerfilCatalogo($perfil,$permisos);
            $permisos = C4::AR::Permisos::parsearPermisos($permisos);
        }else{
            $permisos = 0;
        }
        $newUpdate = 1;
    }
    return ($permisos,$newUpdate);
}

sub nuevoPermisoCatalogo{

    my ($nro_socio,$id_ui,$tipo_documento,$permisos_array)= @_;

    my @filtros;
    my $msg_object= C4::AR::Mensajes::create();
    my $hash_permisos = C4::AR::Permisos::procesarPermisos($permisos_array); #DEBE HACER UNA HASH TENIENDO COMO CLAVE EL NOMBRE

    my $permisos = C4::Modelo::PermCatalogo->new();
    $hash_permisos->{'tipo_documento'} = $tipo_documento;
    $hash_permisos->{'nro_socio'} = $nro_socio;
    $hash_permisos->{'id_ui'} = $id_ui || 'ANY';
    eval{
        $permisos->agregar($hash_permisos);
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U503', 'params' => [$permisos->getNro_socio]});
        $permisos = C4::AR::Permisos::parsearPermisos($permisos);
    };

    if ($@){
        &C4::AR::Mensajes::printErrorDB($@, 'B423',"INTRA");
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U504', 'params' => [$permisos->getNro_socio]} ) ;
    }

    return ($msg_object);
}


sub get_permisos_catalogo {

    my ($params) = @_;
    my @filtros;

    if($params->{'ui'} ne 'ANY'){
        #interesa la UI
        push (@filtros, ( 'ui' => { eq => $params->{'ui'} }) );
    }

    if($params->{'tipo_documento'} ne 'ANY'){
        #interesa el tipo_documento
        push (@filtros, ( 'tipo_documento' => { eq => $params->{'tipo_documento'} }) );
    }

    push (@filtros, ( 'nro_socio' => { eq => $params->{'nro_socio'} }) );


    my $permisos_catalogo_array_ref = getPermCatalogo(\@filtros);

    return $permisos_catalogo_array_ref;
}

sub armarPerfilCatalogo{

    my ($perfil,$permisos) = @_;

#     use C4::Modelo::PermCatalogo;
    my $permisoTemp = $permisos || C4::Modelo::PermCatalogo->new();

    if ($perfil eq 'SL'){
        $permisoTemp->setAll(TODOS);
    }
    elsif ($perfil eq 'L'){
        $permisoTemp->setAll(ALTA | MODIFICACION | CONSULTA);
    }
    elsif ($perfil eq 'E'){
        $permisoTemp->setAll(CONSULTA);

    }
    return $permisoTemp;
}


# FUNCIONES DE PERMISOS GENERALES

sub actualizarPermisosGeneral{

    my ($nro_socio,$id_ui,$tipo_documento,$permisos_array)= @_;

    my @filtros;

    my $hash_permisos = C4::AR::Permisos::procesarPermisos($permisos_array); #DEBE HACER UNA HASH TENIENDO COMO CLAVE EL NOMBRE
    my $msg_object= C4::AR::Mensajes::create();
    push (@filtros, (nro_socio => {eq => $nro_socio}));
    push (@filtros, (ui => {eq => $id_ui}));
    push (@filtros, (tipo_documento => {eq => $tipo_documento}));
  

    my $permiso = getPermGeneralOne(\@filtros);
    if ($permiso){
        eval{
            $hash_permisos->{'tipo_documento'} = $tipo_documento;
            $hash_permisos->{'nro_socio'} = $nro_socio;
            $id_ui = $id_ui || 'ALL';
            $hash_permisos->{'id_ui'} = $id_ui;
    
            $permiso->agregar($hash_permisos);
    
            C4::AR::Permisos::parsearPermisos($permiso);
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U317', 'params' => [$permiso->getNro_socio]});
    
            return ($msg_object);
        };
        
        if ($@){
            &C4::AR::Mensajes::printErrorDB($@, 'B423',"INTRA");
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U502', 'params' => [$permiso->getNro_socio]} ) ;
        }
    }
    return ($msg_object);

}

sub obtenerPermisosGenerales{

    my ($nro_socio,$id_ui,$tipo_documento,$perfil)= @_;
    my $permisos;
    my @filtros;
    my $newUpdate;
    push (@filtros, (nro_socio => {eq => $nro_socio}));
    $id_ui = $id_ui || 'ANY';
    push (@filtros, (ui => {eq => $id_ui}));
    push (@filtros, (tipo_documento => {eq => $tipo_documento}));

    $permisos = C4::AR::Permisos::getPermGeneralOne(\@filtros);

    if ($permisos){
        $permisos = C4::AR::Permisos::armarPerfilGeneral($perfil,$permisos);
        $permisos = C4::AR::Permisos::parsearPermisos($permisos);
        $newUpdate = 0;
    }else{
        if ($perfil){
            $permisos = C4::AR::Permisos::armarPerfilGeneral($perfil,$permisos);
            $permisos = C4::AR::Permisos::parsearPermisos($permisos);
        }else{
            $permisos = 0;
        }
        $newUpdate = 1;
    }
    return ($permisos,$newUpdate);
}

sub nuevoPermisoGeneral{

    my ($nro_socio,$id_ui,$tipo_documento,$permisos_array)= @_;

    my @filtros;
    my $msg_object= C4::AR::Mensajes::create();
    my $hash_permisos = C4::AR::Permisos::procesarPermisos($permisos_array); #DEBE HACER UNA HASH TENIENDO COMO CLAVE EL NOMBRE

    my $permisos = C4::Modelo::PermGeneral->new();
    $hash_permisos->{'tipo_documento'} = $tipo_documento;
    $hash_permisos->{'nro_socio'} = $nro_socio;
    $hash_permisos->{'id_ui'} = $id_ui || 'ALL';

    eval{
        $permisos->agregar($hash_permisos);
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U503', 'params' => [$permisos->getNro_socio]});
        $permisos = C4::AR::Permisos::parsearPermisos($permisos);
    };

    if ($@){
        &C4::AR::Mensajes::printErrorDB($@, 'B423',"INTRA");
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U504', 'params' => [$permisos->getNro_socio]} ) ;
    }

    return ($msg_object);
}


sub get_permisos_general {
    my ($params) = @_;

    my @filtros;

    if($params->{'ui'} ne 'ANY'){
        #interesa la UI
        push (@filtros, ( 'ui' => { eq => $params->{'ui'} }) );
    }

    if($params->{'tipo_documento'} ne 'ANY'){
        #interesa el tipo_documento
        push (@filtros, ( 'tipo_documento' => { eq => $params->{'tipo_documento'} }) );
    }

    push (@filtros, ( 'nro_socio' => { eq => $params->{'nro_socio'} }) );


    my $permisos_general_array_ref = getPermGeneral(\@filtros);

    return $permisos_general_array_ref;
}

sub armarPerfilGeneral{

    my ($perfil,$permisos) = @_;

#     use C4::Modelo::PermGeneral;

    my $permisoTemp = $permisos || C4::Modelo::PermGeneral->new();

    if ($perfil eq 'SL'){
        $permisoTemp->setAll(TODOS);
    }
    elsif ($perfil eq 'L'){
        $permisoTemp->setAll(ALTA | MODIFICACION | CONSULTA);

    }
    elsif ($perfil eq 'E'){
        $permisoTemp->setAll(CONSULTA);
    }    
    return $permisoTemp;

}




# FUNCIONES DE PERMISOS PARA CIRCULACION

sub actualizarPermisosCirculacion{

    my ($nro_socio,$id_ui,$tipo_documento,$permisos_array)= @_;

    my @filtros;

    my $hash_permisos = C4::AR::Permisos::procesarPermisos($permisos_array); #DEBE HACER UNA HASH TENIENDO COMO CLAVE EL NOMBRE
    my $msg_object= C4::AR::Mensajes::create();
    push (@filtros, (nro_socio => {eq => $nro_socio}));
    push (@filtros, (ui => {eq => $id_ui}));
    push (@filtros, (tipo_documento => {eq => $tipo_documento}));
  

    my $permiso = getPermCirculacionOne(\@filtros);
    if ($permiso){
        eval{
            $hash_permisos->{'tipo_documento'} = $tipo_documento;
            $hash_permisos->{'nro_socio'} = $nro_socio;
            $id_ui = $id_ui || 'ALL';
            $hash_permisos->{'id_ui'} = $id_ui;
    
            $permiso->agregar($hash_permisos);
    
            $permiso = C4::AR::Permisos::parsearPermisos($permiso);
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U317', 'params' => []});
    
            return ($msg_object);
        };
        
        if ($@){
            &C4::AR::Mensajes::printErrorDB($@, 'B423',"INTRA");
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U502', 'params' => [$permiso->getNro_socio]} ) ;
        }
    }
    return ($msg_object);

}

sub obtenerPermisosCirculacion{

    my ($nro_socio,$id_ui,$tipo_documento,$perfil)= @_;
    my $permisos;
    my @filtros;
    my $newUpdate;
    push (@filtros, (nro_socio => {eq => $nro_socio}));
    $id_ui = $id_ui || 'ANY';
    push (@filtros, (ui => {eq => $id_ui}));
    push (@filtros, (tipo_documento => {eq => $tipo_documento}));

    $permisos = C4::AR::Permisos::getPermCirculacionOne(\@filtros);

    if ($permisos){
        $permisos = C4::AR::Permisos::armarPerfilCirculacion($perfil,$permisos);
        $permisos = C4::AR::Permisos::parsearPermisos($permisos);
        $newUpdate = 0;
    }else{
        if ($perfil){
            $permisos = C4::AR::Permisos::armarPerfilCirculacion($perfil,$permisos);
            $permisos = C4::AR::Permisos::parsearPermisos($permisos);
        }else{
            $permisos = 0;
        }
        $newUpdate = 1;
    }
    return ($permisos,$newUpdate);
}

sub nuevoPermisoCirculacion{

    my ($nro_socio,$id_ui,$tipo_documento,$permisos_array)= @_;

    my @filtros;
    my $msg_object= C4::AR::Mensajes::create();
    my $hash_permisos = C4::AR::Permisos::procesarPermisos($permisos_array); #DEBE HACER UNA HASH TENIENDO COMO CLAVE EL NOMBRE

    my $permisos = C4::Modelo::PermCirculacion->new();
    $hash_permisos->{'tipo_documento'} = $tipo_documento;
    $hash_permisos->{'nro_socio'} = $nro_socio;
    $hash_permisos->{'id_ui'} = $id_ui || 'ALL';

    eval{
        $permisos->agregar($hash_permisos);
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U503', 'params' => [$permisos->getNro_socio]});
        $permisos = C4::AR::Permisos::parsearPermisos($permisos);
    };

    if ($@){
        &C4::AR::Mensajes::printErrorDB($@, 'B423',"INTRA");
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U504', 'params' => [$permisos->getNro_socio]} ) ;
    }

    return ($msg_object);
}


sub get_permisos_circulacion {
    my ($params) = @_;

    my @filtros;

    if($params->{'ui'} ne 'ANY'){
        #interesa la UI
        push (@filtros, ( 'ui' => { eq => $params->{'ui'} }) );
    }

    if($params->{'tipo_documento'} ne 'ANY'){
        #interesa el tipo_documento
        push (@filtros, ( 'tipo_documento' => { eq => $params->{'tipo_documento'} }) );
    }

    push (@filtros, ( 'nro_socio' => { eq => $params->{'nro_socio'} }) );


    my $permisos_circulacion_array_ref = C4::AR::Permisos::getPermCirculacion(\@filtros);

    return $permisos_circulacion_array_ref;
}

sub armarPerfilCirculacion{

    my ($perfil,$permisos) = @_;

#     use C4::Modelo::PermCirculacion;

    my $permisoTemp = $permisos || C4::Modelo::PermCirculacion->new();

    if ($perfil eq 'SL'){
        $permisoTemp->setAll(TODOS);
    }
    elsif ($perfil eq 'L'){
        $permisoTemp->setAll(ALTA | MODIFICACION | CONSULTA);

    }
    elsif ($perfil eq 'E'){
        $permisoTemp->setAll(CONSULTA);
    }
        
    return $permisoTemp;

}

END { }       # module clean-up code here (global destructor)

1;
__END__
