#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;

use C4::AR::VisualizacionIntra;
use C4::AR::Utilidades;
use JSON;

my $input   = new CGI;

my $editing         = $input->param('id');
my $type            = $input->param('type');
my $nivel           = $input->param('nivel');
my $tipo_ejemplar   = $input->param('tipo_ejemplar');

if($editing){

    my ($template, $session, $t_params)  = get_template_and_user({  
                            template_name   => "includes/partials/modificar_value.tmpl",
                            query           => $input,
                            type            => "intranet",
                            authnotrequired => 0,
                            flagsrequired   => {  ui            => 'ANY', 
                                                tipo_documento  => 'ANY', 
                                                accion          => 'CONSULTA', 
                                                entorno         => 'permisos', 
                                                tipo_permiso    => 'general'},
                            debug => 1,
                        });
    my $configuracion; 
    my $value;   
    my $vista_id;                    


    if($type eq "pre"){
        $value          = $input->param('value');
        $vista_id       = $input->param('id');
        $configuracion  = C4::AR::VisualizacionIntra::editConfiguracion($vista_id,$value,'pre');
    }
    elsif($type eq "inter"){
        $value          = $input->param('value');
        $vista_id       = $input->param('id');
        $configuracion  = C4::AR::VisualizacionIntra::editConfiguracion($vista_id,$value,'inter');
    }
    elsif($type eq "post"){
        $value          = $input->param('value');
        $vista_id       = $input->param('id');
        $configuracion  = C4::AR::VisualizacionIntra::editConfiguracion($vista_id,$value,'post');
    }
    elsif($type eq "nombre"){
        $value          = $input->param('value');
        $vista_id       = $input->param('id');
        $configuracion  = C4::AR::VisualizacionIntra::editConfiguracion($vista_id,$value);
    }
    elsif($type eq "nivel"){
        $value          = $input->param('value');
        $vista_id       = $input->param('id');
        $configuracion  = C4::AR::VisualizacionIntra::editConfiguracion($vista_id,$value,'nivel');
    }
    elsif($type eq "vista_campo"){
        $value          = $input->param('value');
        $vista_id       = $input->param('id');

        $configuracion  = C4::AR::VisualizacionIntra::editVistaGrupo($vista_id, $value, $nivel, $tipo_ejemplar);
    }

    $t_params->{'value'} = $configuracion;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
else{

    my $obj = $input->param('obj');

    $obj    = C4::AR::Utilidades::from_json_ISO($obj);

    #tipoAccion = Insert, Update, Select
    my $tipoAccion      = $obj->{'tipoAccion'} || "";
    my $componente      = $obj->{'componente'} || "";
    my $ejemplar        = $obj->{'ejemplar'} || "";
    my $nivel           = $obj->{'nivel'} || "";
    my $result;
    my %infoRespuesta;
    my $authnotrequired = 0;

    #************************* para cargar la tabla de encabezados*************************************
    if($tipoAccion eq "MOSTRAR_VISUALIZACION"){

        my ($template, $session, $t_params) = get_template_and_user({
                            template_name   => "catalogacion/visualizacionINTRA/detalleVisualizacionIntra.tmpl",
                            query           => $input,
                            type            => "intranet",
                            authnotrequired => 0,
                            flagsrequired   => {  ui            => 'ANY', 
                                                tipo_documento  => 'ANY', 
                                                accion          => 'CONSULTA', 
                                                entorno         => 'undefined'},
                            debug => 1,
        });

        $t_params->{'selectCampoX'} = C4::AR::Utilidades::generarComboCampoX('eleccionCampoX()');

        C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
    }
    elsif($tipoAccion eq "AGREGAR_VISUALIZACION"){

        my ($user, $session, $flags)= checkauth(  $input, 
                                                  $authnotrequired, 
                                                  {   ui => 'ANY', 
                                                      tipo_documento => 'ANY', 
                                                      accion => 'CONSULTA', 
                                                      entorno => 'datos_nivel1'}, 
                                                  'intranet'
                                      );

        my ($Message_arrayref)  = C4::AR::VisualizacionIntra::t_agregar_configuracion($obj);
        my $infoOperacionJSON   = to_json $Message_arrayref;

        C4::AR::Auth::print_header($session);
        print $infoOperacionJSON;          
    }
    elsif($tipoAccion eq "ELIMINAR_VISUALIZACION"){

        my ($user, $session, $flags)= checkauth(  $input, 
                                                  $authnotrequired, 
                                                  {   ui => 'ANY', 
                                                      tipo_documento => 'ANY', 
                                                      accion => 'CONSULTA', 
                                                      entorno => 'datos_nivel1'}, 
                                                  'intranet'
                                      );

        my ($Message_arrayref)  = C4::AR::VisualizacionIntra::t_delete_configuracion($obj);
        my $infoOperacionJSON   = to_json $Message_arrayref;

        C4::AR::Auth::print_header($session);
        print $infoOperacionJSON;
    }
    elsif($tipoAccion eq "ELIMINAR_TODO_EL_CAMPO"){

        my ($user, $session, $flags)= checkauth(  $input, 
                                                  $authnotrequired, 
                                                  {   ui => 'ANY', 
                                                      tipo_documento => 'ANY', 
                                                      accion => 'CONSULTA', 
                                                      entorno => 'datos_nivel1'}, 
                                                  'intranet'
                                      );

        my ($Message_arrayref)  = C4::AR::VisualizacionIntra::eliminarTodoElCampo($obj);
        my $infoOperacionJSON   = to_json $Message_arrayref;

        C4::AR::Auth::print_header($session);
        print $infoOperacionJSON;
    }
    elsif($tipoAccion eq "GENERAR_ARREGLO_CAMPOS"){
        my ($user, $session, $flags)= checkauth(    $input, 
                                                  $authnotrequired, 
                                                  {   ui => 'ANY', 
                                                      tipo_documento => 'ANY', 
                                                      accion => 'CONSULTA', 
                                                      entorno => 'datos_nivel1'}, 
                                                  'intranet'
                                      );

      my $campoX            = $obj->{'campoX'};
      my ($campos_array)    = C4::AR::VisualizacionIntra::getCamposXLike($campoX);
      my $info              = C4::AR::Utilidades::arrayObjectsToJSONString($campos_array);
      my $infoOperacionJSON = $info;

      C4::AR::Auth::print_header($session);
      print $infoOperacionJSON;
    }

    elsif($tipoAccion eq "GENERAR_ARREGLO_SUBCAMPOS"){
        my ($user, $session, $flags)= checkauth(    $input, 
                                                  $authnotrequired, 
                                                  {   ui => 'ANY', 
                                                      tipo_documento => 'ANY', 
                                                      accion => 'CONSULTA', 
                                                      entorno => 'datos_nivel1'}, 
                                                  'intranet'
                                      );
      my $campo             = $obj->{'campo'};

      my ($campos_array)    = C4::AR::VisualizacionIntra::getSubCamposLike($campo);

      my $info              = C4::AR::Utilidades::arrayObjectsToJSONString($campos_array);

      my $infoOperacionJSON = $info;

      C4::AR::Auth::print_header($session);
      print $infoOperacionJSON;
    }
    
    elsif($tipoAccion eq "ACTUALIZAR_ORDEN"){
        my ($user, $session, $flags)= checkauth(  $input, 
                                                  $authnotrequired, 
                                                  {   ui                => 'ANY', 
                                                      tipo_documento    => 'ANY', 
                                                      accion            => 'CONSULTA', 
                                                      entorno           => 'datos_nivel1'}, 
                                                  'intranet'
                                      );
        my $newOrderArray       = $obj->{'newOrderArray'};
        my $info                = C4::AR::VisualizacionIntra::updateNewOrder($newOrderArray);
        my $infoOperacionJSON   = to_json $info;
        C4::AR::Auth::print_header($session);
        print $infoOperacionJSON;  
    }
    
     elsif($tipoAccion eq "ACTUALIZAR_ORDEN_AGRUPANDO"){
        my ($user, $session, $flags)= checkauth(  $input, 
                                                  $authnotrequired, 
                                                  {   ui                => 'ANY', 
                                                      tipo_documento    => 'ANY', 
                                                      accion            => 'CONSULTA', 
                                                      entorno           => 'datos_nivel1'}, 
                                                  'intranet'
                                      );
        my $newOrderArray       = $obj->{'newOrderArray'};
        my $info                = C4::AR::VisualizacionIntra::updateNewOrderGroup($newOrderArray);
        my $infoOperacionJSON   = to_json $info;
        C4::AR::Auth::print_header($session);
        print $infoOperacionJSON;  
    }
    elsif($tipoAccion eq "ACTUALIZAR_ORDEN_SUBCAMPOS"){
        my ($user, $session, $flags)= checkauth(  $input, 
                                                  $authnotrequired, 
                                                  {   ui                => 'ANY', 
                                                      tipo_documento    => 'ANY', 
                                                      accion            => 'CONSULTA', 
                                                      entorno           => 'datos_nivel1'}, 
                                                  'intranet'
                                      );
        my $newOrderArray       = $obj->{'newOrderArray'};
        my $info                = C4::AR::VisualizacionIntra::updateNewOrderSubCampos($newOrderArray);
        my $infoOperacionJSON   = to_json $info;
        C4::AR::Auth::print_header($session);
        print $infoOperacionJSON;  
    }
    elsif($tipoAccion eq "MOSTRAR_TABLA_VISUALIZACION"){

        my ($template, $session, $t_params) = get_template_and_user({
                            template_name   => "catalogacion/visualizacionINTRA/detalleTablaVisualizacionIntra.tmpl",
                            query           => $input,
                            type            => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui              => 'ANY', 
                                                tipo_documento  => 'ANY', 
                                                accion          => 'CONSULTA', 
                                                entorno         => 'undefined'},
                            debug => 1,
        });
        

        $t_params->{'visualizacion'}    = C4::AR::VisualizacionIntra::getSubCampos($obj->{'campo'}, $obj->{'nivel'}, $obj->{'template'});

        C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);     
    }
    elsif($tipoAccion eq "MOSTRAR_TABLA_CAMPO"){

        my ($template, $session, $t_params) = get_template_and_user({
                            template_name   => "catalogacion/visualizacionINTRA/detalleTablaCampoVisualizacionIntra.tmpl",
                            query           => $input,
                            type            => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui              => 'ANY', 
                                                tipo_documento  => 'ANY', 
                                                accion          => 'CONSULTA', 
                                                entorno         => 'undefined'},
                            debug => 1,
        });

        $t_params->{'visualizacion'}    = C4::AR::VisualizacionIntra::getConfiguracionByOrderGroupCampo($ejemplar,$nivel);

        C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);     
    }
    #**************************************************************************************************
}
