#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;
use C4::Output;
use JSON;
use C4::AR::Nivel2;
use C4::AR::Nivel3;
use C4::AR::Recomendaciones;
use C4::AR::RecomendacionDetalle;

my $input = new CGI;
my $obj=$input->param('obj');
my ($template, $session, $t_params);

if($obj){
    
    $obj= C4::AR::Utilidades::from_json_ISO($obj);

}

if ($obj->{'tipoAccion'} eq 'BUSQUEDA_EDICIONES') {
    
    my $idNivel1=  $obj->{'idCatalogoSearch'};

    my $combo_ediciones= C4::AR::Utilidades::generarComboNivel2($idNivel1);

    ($template, $session, $t_params)= get_template_and_user({
                        template_name => "/includes/opac-combo_ediciones.inc",
                        query => $input,
                        type => "opac",
                        authnotrequired => 1,
                        flagsrequired => {  ui => 'ANY', 
                                            tipo_documento => 'ANY', 
                                            accion => 'CONSULTA', 
                                            tipo_permiso => 'general',
                                            entorno => 'adq_opac'},
                    });
 
    $t_params->{'combo_ediciones'} = $combo_ediciones;
      
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

} elsif ($obj->{'tipoAccion'} eq 'AGREGAR_RECOMENDACION') {
     
    my $authnotrequired= 0;
    my ($userid, $session, $flags)= checkauth(  $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'ALTA', 
                                                    tipo_permiso => 'general',
                                                    entorno => 'adq_opac'}, 
                                                'opac'
                                );


    my $usr_socio= C4::AR::Auth::getSessionUserID($session);

    my $id_recomendacion= C4::AR::Recomendaciones::agregarRecomendacion($usr_socio);
    
    C4::AR::Auth::print_header($session);
    
    print $id_recomendacion;
 
} elsif ($obj->{'tipoAccion'} eq 'AGREGAR_RENGLON') {

  my $recom_id= $obj->{'id_recomendacion'}; 
  
  my $authnotrequired= 0;
  my ($userid, $session, $flags)= checkauth(  $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'MODIFICACION', 
                                                    tipo_permiso => 'general',
                                                    entorno => 'adq_opac'}, 
                                                'opac'
                                );

  my ($msg_object,$id_detalle_recomendacion) = C4::AR::RecomendacionDetalle::agregarDetalleARecomendacion($obj, $recom_id);
  C4::AR::Debug::debug("msg object : ".$msg_object->{'error'});
  
  # preguntamos si agrego sin errores
  if($msg_object->{'error'}){
      # si hay error mandamos un 1 como responseText
      C4::AR::Auth::print_header($session);
      print "1";
  }else{
      C4::AR::Auth::print_header($session);
      print $id_detalle_recomendacion;
  }

 } elsif ($obj->{'tipoAccion'} eq 'CARGAR_DATOS_EDICION')   {


    my $idNivel2 =  $obj->{'edicion_id'};
    my $edicion =  $obj->{'edicion'};

    my $idNivel1= $obj->{'idCatalogoSearch'};

    my $datos_edicion= C4::AR::Nivel2::getNivel2FromId2($idNivel2);

    my $detalle_nivel_3= C4::AR::Nivel3::detalleNivel3($idNivel2);

    my $datos_nivel1= C4::AR::Nivel1::getNivel1FromId1($idNivel1);

    ($template, $session, $t_params)= get_template_and_user({
                        template_name => "/includes/opac-datos_edicion.inc",
                        query => $input,
                        type => "opac",
                        authnotrequired => 1,
                        flagsrequired => {  ui => 'ANY', 
                                            tipo_documento => 'ANY', 
                                            accion => 'CONSULTA',   
                                            tipo_permiso => 'general',
                                            entorno => 'adq_opac'},
                    });

   $t_params->{'cant_ejemplares_disp'} = $detalle_nivel_3->{'disponibles'};

   $t_params->{'edicion'} = $edicion;
   $t_params->{'datos_edicion'} = $datos_edicion;
   $t_params->{'datos_nivel1'} = $datos_nivel1;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);


} elsif ($obj->{'tipoAccion'} eq 'BUSQUEDA_RECOMENDACION_SIN_RESULTADOS') {


    ($template, $session, $t_params)= get_template_and_user({
                        template_name => "/includes/opac-datos_edicion.inc",
                        query => $input,
                        type => "opac",
                        authnotrequired => 1,
                        flagsrequired => {  ui => 'ANY', 
                                            tipo_documento => 'ANY', 
                                            accion => 'CONSULTA', 
                                            tipo_permiso => 'general',
                                            entorno => 'adq_opac'},
                    });

    $t_params->{'datos_edicion'} = "";
  
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

} elsif ($obj->{'tipoAccion'} eq 'ELIMINAR_DETALLE') {

  my $detalle_recom_id= $obj->{'id_rec_det'}; 
  
  my $authnotrequired= 0;
  my ($userid, $session, $flags)= checkauth(  $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    tipo_permiso => 'general',
                                                    entorno => 'adq_opac'}, 
                                                'opac'
                                );

  my $message= C4::AR::RecomendacionDetalle::eliminarDetalleRecomendacion($detalle_recom_id);
  
  my $infoOperacionJSON = to_json $message;
    
  C4::AR::Auth::print_header($session);
  print $infoOperacionJSON;     

} elsif ($obj->{'tipoAccion'} eq 'CANCELAR_RECOMENDACION') {

  my $recom_id= $obj->{'id_rec'}; 
  
  my $authnotrequired= 0;
  my ($userid, $session, $flags)= checkauth(  $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    tipo_permiso => 'general',
                                                    entorno => 'adq_opac'}, 
                                                'opac'
                                );

  my $message= C4::AR::Recomendaciones::eliminarRecomendacion($recom_id);
    
  my $infoOperacionJSON = to_json $message;  
  C4::AR::Auth::print_header($session);
  print $infoOperacionJSON;     

} elsif  ($obj->{'tipoAccion'} eq 'ACTIVAR_RECOMENDACION') {
   
    my $authnotrequired= 0;
    my ($userid, $session, $flags)= checkauth(  $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    tipo_permiso => 'general',
                                                    entorno => 'adq_opac'}, 
                                                'opac'
                                );

    my $recom_id= $obj->{'id_rec'}; 
    my $user_id= $obj->{'user_id'}; 
    
    my $recom= C4::AR::Recomendaciones::getRecomendacionPorId($recom_id);

    $recom->activar();
  
    my $rec_de_usuario= C4::AR::Recomendaciones::getRecomendacionesDeUsuario($user_id);
   
    foreach my $rec (@$rec_de_usuario){

        if (!$rec->getActiva){
              my $message= C4::AR::Recomendaciones::eliminarRecomendacion($rec->getId);
        }
    } 

    my $msg_object= C4::AR::Mensajes::create();
    $msg_object->{'error'} = 0;
    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'RC04', 'params' => []});

    my $infoOperacionJSON = to_json $msg_object;  
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;     



}


