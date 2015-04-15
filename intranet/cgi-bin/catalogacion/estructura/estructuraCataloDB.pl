#!/usr/bin/perl
#
# Meran - MERAN UNLP is a ILS (Integrated Library System) wich provides Catalog,
# Circulation and User's Management. It's written in Perl, and uses Apache2
# Web-Server, MySQL database and Sphinx 2 indexing.
# Copyright (C) 2009-2013 Grupo de desarrollo de Meran CeSPI-UNLP
#
# This file is part of Meran.
#
# Meran is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Meran is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Meran.  If not, see <http://www.gnu.org/licenses/>.
#


use strict;
use CGI;
use C4::AR::Nivel1;
use C4::AR::Nivel2;
use C4::AR::Auth;
use C4::AR::Utilidades;
use C4::AR::Catalogacion;
use JSON;

my $input           = new CGI;
my $authnotrequired = 0;
my $obj             = $input->param('obj');
$obj                = C4::AR::Utilidades::from_json_ISO($obj);
my $tipoAccion      = $obj->{'tipoAccion'}||"";
my $nivel           = $obj->{'nivel'};
my $orden           = $obj->{'orden'}||"intranet_habilitado";
my $itemType        = $obj->{'itemtype'}||'ALL';

if($nivel > 1){
    $itemType=$obj->{'itemtype'};
}

if($tipoAccion eq "MOSTRAR_CAMPOS"){
#Se muestran las catalogaciones

    my ($template, $session, $t_params) = get_template_and_user({
                            template_name => "catalogacion/estructura/mostrarCatalogacion.tmpl",
			                query => $input,
			                type => "intranet",
			                authnotrequired => 0,
			                flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'CONSULTA', 
                                                entorno => 'datos_nivel1' },
			                debug => 1,
			        });


# C4::AR::Debug::debug("getEstructuraCatalogacionFromDBCompleta => itemType FROM PL => ".$itemType);
# TODO en el template esta haciendo una consulta por cada fila
    my ($cant, $catalogaciones_array_ref) = C4::AR::Catalogacion::getEstructuraCatalogacionFromDBCompleta($nivel, $itemType, $orden);
    
    #Se pasa al cliente el arreglo de objetos estructura_catalogacion   
    $t_params->{'catalogaciones'}   = $catalogaciones_array_ref;
    $t_params->{'nivel'}            = $nivel;
    $t_params->{'itemType'}         = $itemType;
    
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}

elsif($tipoAccion eq "GENERAR_ARREGLO_CAMPOS_REFERENCIA"){
     my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'datos_nivel1'}, 
                                                'intranet'
                                    );
    my $tableAlias= $obj->{'tableAlias'};
    
    my ($campos_array) = C4::AR::Referencias::getCamposDeTablaRef($tableAlias);

    my $info = to_json($campos_array);
    my $infoOperacionJSON = $info;

    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;

} elsif ($obj->{'tipoAccion'} eq 'BUSQUEDA_EDICIONES') {
    
    my $combo_ediciones = C4::AR::Utilidades::generarComboNivel2Detalle( $obj->{'id1'});

    my ($template, $session, $t_params)= get_template_and_user({
                                                                    template_name => "/includes/partials/catalogo/combo_ediciones.inc",
                                                                    query => $input,
                                                                    type => "intranet",
                                                                    flagsrequired => {  ui => 'ANY', 
                                                                                        tipo_documento => 'ANY', 
                                                                                        accion => 'CONSULTA', 
                                                                                        entorno => 'undefined'},
                                                            });
 
    $t_params->{'combo_ediciones'} = $combo_ediciones;
      
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
} elsif($tipoAccion eq "GENERAR_ARREGLO_CAMPOS"){
     my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'datos_nivel1'}, 
                                                'intranet'
                                    );
# SE AGREGA '|| 0' porque se usa en VISUALIZACION DEL OPAC, NO SACAR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    my $nivel = $obj->{'nivel'} || 0;
    my $campoX = $obj->{'campoX'};

    my ($campos_array) = C4::AR::EstructuraCatalogacionBase::getCamposXLike($nivel,$campoX);

    my $info = C4::AR::Utilidades::arrayObjectsToJSONString($campos_array);

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
# SE AGREGA '|| 0' porque se usa en VISUALIZACION DEL OPAC, NO SACAR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    my $nivel = $obj->{'nivel'} || 0;;
    my $campo = $obj->{'campo'};

    my ($campos_array)      = C4::AR::EstructuraCatalogacionBase::getSubCamposLike($nivel,$campo);
    my $info                = C4::AR::Utilidades::arrayObjectsToJSONString($campos_array);
    my $infoOperacionJSON   = $info;

    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}

elsif($tipoAccion eq "GENERAR_ARREGLO_TABLA_REF"){
     my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'datos_nivel1',
                                                    tipo_permiso => 'catalogo'
                                                    
                                                }, 
                                                'intranet'
                                    );

    my ($tablaRef_array) = C4::AR::Referencias::obtenerTablasDeReferenciaAsString();
    
    my ($infoOperacionJSON) = to_json($tablaRef_array);

    
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;

}

elsif($tipoAccion eq "MOSTRAR_FORM_AGREGAR_CAMPOS"){
#Se muestran las catalogaciones

    my ($template, $session, $t_params) = get_template_and_user({
                        template_name => "catalogacion/estructura/agregarCampoMARC.tmpl",
                        query => $input,
                        type => "intranet",
                        authnotrequired => 0,
                        flagsrequired => {      ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'CONSULTA', 
                                                entorno => 'datos_nivel1' },
                        debug => 1,
                    });


    my %params_combo;
    $params_combo{'onChange'}           = 'eleccionTablaRef()';
    $t_params->{'tabla_referencias'}    = C4::AR::Utilidades::generarComboTablasDeReferencia(\%params_combo);

    $t_params->{'selectCampoX'}         = C4::AR::Utilidades::generarComboCampoX('eleccionCampoX()');

    my %params_combo;
    $params_combo{'default'}            = 'SIN SELECCIONAR';
    $params_combo{'id'}                 = 'tipoInput';
    $t_params->{'comboComponentes'}     = C4::AR::Utilidades::generarComboComponentes(\%params_combo);

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}

elsif($tipoAccion eq "MOSTRAR_FORM_MODIFICAR_CAMPOS"){
#Se muestran las catalogaciones

    my ($template, $session, $t_params) = get_template_and_user({
                        template_name => "catalogacion/estructura/modificarCampoMARC.tmpl",
                        query => $input,
                        type => "intranet",
                        authnotrequired => 0,
                        flagsrequired => {  ui => 'ANY', 
                                            tipo_documento => 'ANY', 
                                            accion => 'CONSULTA', 
                                            entorno => 'datos_nivel1' },
                        debug => 1,
                    });

    my $id                              = $obj->{'id'};
    my $catalogacion                    = C4::AR::Catalogacion::getEstructuraCatalogacionById($id);

    my %params_combo;
    $params_combo{'class'}              = 'horizontal';
    $params_combo{'id'}                 = 'tipo_nivel3_id_nuevo';
    $params_combo{'default'}            = $catalogacion->getItemType();
    my $comboTiposNivel3                = C4::AR::Utilidades::generarComboTipoNivel3(\%params_combo);
    $t_params->{'selectItemType'}       = $comboTiposNivel3;

    my %params_combo;
    $params_combo{'default'}            = $catalogacion->getTablaFromReferencia()||'-1';
    $params_combo{'onChange'}           = 'eleccionTablaRef()';
    $params_combo{'ALL'}                = 1; #retorno TODAS las tablas de referencia
    $t_params->{'tabla_referencias'}    = C4::AR::Utilidades::generarComboTablasDeReferencia(\%params_combo);
    $t_params->{'catalogacion'}         = $catalogacion;
    $t_params->{'OK'}                   = ($catalogacion?1:0); 
    
    my %params_combo;
    $params_combo{'id'}                 = 'tipoInput';
    $params_combo{'default'}            = $catalogacion->getTipo();
    $t_params->{'comboComponentes'}     = C4::AR::Utilidades::generarComboComponentes(\%params_combo);

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
elsif($tipoAccion eq "GUARDAR_ESTRUCTURA_CATALOGACION"){
     my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'datos_nivel1'}, 
                                                'intranet'
                                    );
    # Se guardan los datos en estructura de catalogacion    
    #estan todos habilidatos
    $obj->{'intranet_habilitado'} = 1;
    my ($Message_arrayref) = C4::AR::Catalogacion::t_guardarEnEstructuraCatalogacion($obj);
    
    my $infoOperacionJSON = to_json $Message_arrayref;
    
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}

elsif($tipoAccion eq "ASOCIAR_REGISTRO_FUENTE"){
     my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'datos_nivel1'}, 
                                                'intranet'
                                    );

    my ($Message_arrayref) = C4::AR::Catalogacion::t_guardarAsociarRegistroFuente($obj);
    
    my $infoOperacionJSON = to_json $Message_arrayref;
    
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}
elsif($tipoAccion eq "DESASOCIAR_REGISTRO_FUENTE"){
     my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'datos_nivel1'}, 
                                                'intranet'
                                    );

    my ($Message_arrayref) = C4::AR::Catalogacion::t_guardarDesAsociarRegistroFuente($obj);
    
    my $infoOperacionJSON = to_json $Message_arrayref;
    
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}
elsif($tipoAccion eq "MODIFICAR_ESTRUCTURA_CATALOGACION"){
     my ($user, $session, $flags) = checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'datos_nivel1'}, 
                                                'intranet'
                                    );
    # Se guardan los datos en estructura de catalogacion    
    #estan todos habilidatos
    $obj->{'intranet_habilitado'} = 1;

    my ($Message_arrayref) = C4::AR::Catalogacion::t_modificarEnEstructuraCatalogacion($obj);
    
    my $infoOperacionJSON = to_json $Message_arrayref;
    
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}
# elsif($tipoAccion eq "BUSCAR_EDICIONES_BY_ID1"){
#     my ($template, $session, $t_params) = get_template_and_user({
#                             template_name => "catalogacion/estructura/eidcionesDeRegistro.tmpl",
#                             query => $input,
#                             type => "intranet",
#                             authnotrequired => 0,
#                             flagsrequired => {      ui => 'ANY', 
#                                                     tipo_documento => 'ANY', 
#                                                     accion => 'CONSULTA', 
#                                                     entorno => 'datos_nivel1' },
#                             debug => 1,
#                     });
    
#     $t_params->{'ediciones_array'} = C4::AR::Catalogacion::getNivel2FromId1($obj->{'id1'});  
    
#     C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
# }

elsif($tipoAccion eq "CAMBIAR_VISIBILIDAD"){
#Se cambia la visibilidad del campo.
     my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'datos_nivel1'}, 
                                                'intranet'
                                    );

    C4::AR::Validator::validateParams('U389', $obj,['id']);
    C4::AR::Catalogacion::cambiarVisibilidad($obj->{'id'});

    C4::AR::Auth::print_header($session);
}

elsif($tipoAccion eq "CAMBIAR_EDICION_GRUPAL"){
     my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'datos_nivel1'}, 
                                                'intranet'
                                    );

    C4::AR::Validator::validateParams('U389', $obj,['id']);
    C4::AR::Catalogacion::cambiarEdicionGrupal($obj->{'id'});

    C4::AR::Auth::print_header($session);
}

elsif($tipoAccion eq "CAMBIAR_HABILITADO"){
     my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'datos_nivel1'}, 
                                                'intranet'
                                    );

    C4::AR::Validator::validateParams('U389', $obj,['id']);
    C4::AR::Catalogacion::cambiarHabilitado($obj->{'id'});

    C4::AR::Auth::print_header($session);
}
#Se deshabilita el campo seleccionado para la vista en intranet
elsif($tipoAccion eq "ELIMINAR_CAMPO"){
     my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'datos_nivel1'}, 
                                                'intranet'
                                    );

#     C4::AR::Validator::validateParams('U389', $obj,['id']);
    C4::AR::Catalogacion::eliminarCampo($obj);

    C4::AR::Auth::print_header($session);
}

elsif($tipoAccion eq "AGREGAR_CAMPO"){
     my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'datos_nivel1'}, 
                                                'intranet'
                                    );

    
    my ($Message_arrayref)= C4::AR::Catalogacion::t_guardarEnEstructuraCatalogacion($obj);
    
    my $infoOperacionJSON=to_json $Message_arrayref;
    
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}
# ***********************************************ABM CATALOGACION*****************************************************************

elsif($tipoAccion eq "MOSTRAR_ESTRUCTURA_DEL_NIVEL"){
    my $entorno= 'estructura_catalogacion_n1';
    if($obj->{'nivel'} eq '2'){$entorno= 'estructura_catalogacion_n2'};
    if($obj->{'nivel'} eq '3'){$entorno= 'estructura_catalogacion_n3'};

    my ($user, $session, $flags)    = checkauth(    $input, 
                                                    $authnotrequired, 
                                                    {   ui => 'ANY', 
                                                        tipo_documento => 'ANY', 
                                                        accion => 'CONSULTA', 
                                                        entorno => $entorno}, 
                                                        'intranet'
                                    );
    
    #Se muestran la estructura de catalogacion segun el nivel pasado por parametro
    my ($cant, $catalogaciones_array_ref)   = C4::AR::Catalogacion::getEstructuraSinDatos($obj);


    if($cant > 0){
        my $infoOperacionJSON                   = to_json($catalogaciones_array_ref);

        C4::AR::Auth::print_header($session);
        print $infoOperacionJSON;    
    } else {

        my %info;
        my $msg_object          = C4::AR::Mensajes::create();
        $msg_object->{'error'}  = 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U615', 'params' => [$obj->{'nivel'}, $obj->{'id_tipo_doc'}]} ) ;

        $info{'Message_arrayref'}   = $msg_object;

        C4::AR::Auth::print_header($session);
        print to_json \%info;
    }
    
}

elsif($tipoAccion eq "MOSTRAR_ESTRUCTURA_DEL_NIVEL_CON_DATOS"){
     my ($user, $session, $flags)= checkauth(   $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'datos_nivel1'}, 
                                                    'intranet'
                                    );

    my $infoOperacionJSON;

# TODO esta feo, ver si se puede meter mas adentro en un modulo
    if($obj->{'nivel'} eq '1'){
        my $nivel1 = C4::AR::Nivel1::getNivel1FromId1($obj->{'id'});
        $obj->{'id_tipo_doc'} = $nivel1->getTemplate()||'ALL';
    }elsif($obj->{'nivel'} eq '2'){
        my $nivel2 = C4::AR::Nivel2::getNivel2FromId2($obj->{'id'});
        if($nivel2){
          $obj->{'id_tipo_doc'} = $nivel2->getTemplate();
        }
    }elsif($obj->{'nivel'} eq '3'){
      my $nivel3 = C4::AR::Nivel3::getNivel3FromId3($obj->{'id3'});
  
      if($nivel3){
          my $nivel2 = C4::AR::Nivel2::getNivel2FromId2($nivel3->getId2);
          if($nivel2){
              $obj->{'id_tipo_doc'} = $nivel2->getTemplate();
          }
      }
    }

    my ($cant, $catalogaciones_array_ref)   = C4::AR::Catalogacion::getDatosFromNivel($obj);
	$infoOperacionJSON                      = to_json($catalogaciones_array_ref);
    
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}
elsif($tipoAccion eq "GUARDAR_ESQUEMA"){
     my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'datos_nivel1'}, 
                                                'intranet'
                                    );


    my ($Message_arrayref)      = C4::AR::Catalogacion::guardarEsquema($obj);
    
    my %info;
    $info{'Message_arrayref'}   = $Message_arrayref;

    C4::AR::Auth::print_header($session);
    print to_json \%info;
}

elsif($tipoAccion eq "MOSTRAR_SUBCAMPOS_DE_CAMPO"){
     my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'datos_nivel1'}, 
                                                'intranet'
                                    );
    

    my ($sub_campos_string) = C4::AR::Utilidades::obtenerDescripcionDeSubCampos($obj->{'campo'});
    
	C4::AR::Auth::print_header($session);
	print $sub_campos_string;
}

elsif($tipoAccion eq "MOSTRAR_INFO_NIVEL1_LATERAL"){
#Se muestran las catalogaciones

    my ($template, $session, $t_params) = get_template_and_user({
                            template_name => "catalogacion/estructura/ADInfoNivel1.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'CONSULTA', 
                                                entorno => 'datos_nivel1' },
                            debug => 1,
                    });

    C4::AR::Validator::validateParams('U389', $obj,['id1']);

    my ($nivel1)            = C4::AR::Nivel1::getNivel1FromId1($obj->{'id1'});
    $t_params->{'nivel1'}   = $nivel1;
    $t_params->{'OK'}       = ($nivel1?1:0);

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}

elsif($tipoAccion eq "MOSTRAR_INFO_NIVEL2_LATERAL"){
#Se muestran las catalogaciones

    my ($template, $session, $t_params) = get_template_and_user({
                            template_name => "catalogacion/estructura/ADInfoNivel2.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {      ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'datos_nivel1' },
                            debug => 1,
                    });

    C4::AR::Validator::validateParams('U389', $obj,['id1']);
    
    my $nivel2_array_ref = C4::AR::Nivel2::getNivel2FromId1($obj->{'id1'});

    #se envia al cliente todos los objetos nivel2 segun id1
    $t_params->{'nivel2_array'} = $nivel2_array_ref;
    $t_params->{'OK'} = 1;

    $t_params->{'indice_edit'} = 0;
    
	if($obj->{'id2'}){
    # obtenemos el indice, si es que tiene
    
        my $nivel2 = C4::AR::Nivel2::getNivel2FromId2($obj->{'id2'});
        my $indice = $nivel2->getIndice();   
        
		if($indice ne ""){
			$t_params->{'indice_edit'} = 1;
		}

        $t_params->{'nivel1'} = $nivel2->nivel1;
	}
	
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
elsif($tipoAccion eq "MOSTRAR_INFO_NIVEL2"){
#Se muestran las catalogaciones

    my ($template, $session, $t_params) = get_template_and_user({
                            template_name => "catalogacion/estructura/ADInfoNivel2.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {      ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'datos_nivel1' },
                            debug => 1,
                    });

    my $nivel2_array_ref;

    C4::AR::Validator::validateParams('U389', $obj,['id2']);
# FIXME no hay garantias que este getNivel2FromId2 devuelva un objeto nivel2 siempre
    my $nivel2              = C4::AR::Nivel2::getNivel2FromId2($obj->{'id2'});
    
    push  (@$nivel2_array_ref, $nivel2);

    #se envia al cliente todos los objetos nivel2 segun id1
    $t_params->{'nivel2_array'} = $nivel2_array_ref;
    $t_params->{'OK'}           = 1;
    $t_params->{'indice_edit'}  = 0;
    
    if($obj->{'id2'}){
    # obtenemos el indice, si es que tiene
    
        my $indice              = $nivel2_array_ref->[0]->getIndice(); 
        $t_params->{'nivel1'}   = $nivel2_array_ref->[0]->nivel1;  
        
        if($indice ne ""){
            $t_params->{'indice_edit'} = 1;
        }
    }
    
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
elsif($tipoAccion eq "MOSTRAR_INFO_NIVEL3_TABLA"){
#Se muestran las catalogaciones

    my ($template, $session, $t_params) = get_template_and_user({
                            template_name => "catalogacion/estructura/ADInfoNivel3.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {      ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'datos_nivel1' },
                            debug => 1,
                    });

    my($nivel2_hashref)		= C4::AR::Nivel3::detalleNivel3($obj->{'id2'});
    $t_params->{'nivel3_array'} = $nivel2_hashref->{'nivel3'};
  
    
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
# **********************************************FIN ABM CATALOGACION****************************************************************

#============================================================= ABM Catalogo==============================================================
elsif($tipoAccion eq "GUARDAR_NIVEL_1"){
     my ($user, $session, $flags)= checkauth(   $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'ALTA', 
                                                    entorno => 'datos_nivel1'}, 
                                                'intranet'
                                    );


    $obj->{'responsable'}           = $user;
	#Se guarda informacion del NIVEL 1
    my ($Message_arrayref, $id1)    = C4::AR::Nivel1::t_guardarNivel1($obj);
    
    my %info;
    $info{'Message_arrayref'}       = $Message_arrayref;
    $info{'id1'}                    = $id1;

    C4::AR::Auth::print_header($session);
    print to_json \%info;
}

elsif($tipoAccion eq "GUARDAR_NIVEL_2"){
     my ($user, $session, $flags)= checkauth(   $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'ALTA', 
                                                    entorno => 'datos_nivel2'}, 
                                                'intranet'
                                    );
    $obj->{'responsable'}=$user;
    #Se guarda informacion del NIVEL 2 relacionada con un ID de NIVEL 1
    my ($Message_arrayref, $id1, $id2)  = C4::AR::Nivel2::t_guardarNivel2($obj);
    
    my %info;
    $info{'Message_arrayref'}           = $Message_arrayref;
    $info{'id1'}                        = $id1;
    $info{'id2'}                        = $id2;
    $info{'enable_nivel3'}              = C4::AR::Referencias::getTipoNivel3ByCodigo($obj->{'id_tipo_doc'})->enableNivel3();

    C4::AR::Auth::print_header($session);
    print to_json \%info;
}

elsif($tipoAccion eq "GUARDAR_NIVEL_3"){

	my ($user, $session, $flags)= checkauth(
												$input, 	
												$authnotrequired,	
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'ALTA', 
                                                    entorno => 'datos_nivel3'}, 
												'intranet'
											);
    $obj->{'responsable'}=$user;
    #Se muestran la estructura de catalogacion para que el usuario agregue un documento
    my ($Message_arrayref, $nivel3) = C4::AR::Nivel3::t_guardarNivel3($obj);
    
    my %info;
    $info{'Message_arrayref'}= $Message_arrayref;

    C4::AR::Auth::print_header($session);
    print to_json \%info;
}

elsif($tipoAccion eq "MODIFICAR_NIVEL_1"){
     my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'MODIFICACION', 
                                                    entorno => 'datos_nivel1'}, 
                                                'intranet'
                                    );

    $obj->{'responsable'}=$user;
    my ($Message_arrayref, $id1) = C4::AR::Nivel1::t_modificarNivel1($obj);
    
    if($id1){    
        my %info;
        $info{'Message_arrayref'}= $Message_arrayref;
        $info{'id1'} = $id1;

        C4::AR::Auth::print_header($session);
        print to_json \%info;

    }else{
        #no existe el objeto de nivel1
        C4::AR::Auth::print_header($session);
        print 0;
    }
}

elsif($tipoAccion eq "MODIFICAR_NIVEL_2"){
     my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'MODIFICACION', 
                                                    entorno => 'datos_nivel2'}, 
                                                'intranet'
                                    );

    $obj->{'responsable'}=$user;
    my ($Message_arrayref, $nivel2) = C4::AR::Nivel2::t_modificarNivel2($obj);
    
    if($nivel2){        
        my %info;
        $info{'Message_arrayref'}   = $Message_arrayref;
        $info{'id1'}                = $nivel2->getId1;
        $info{'id2'}                = $nivel2->getId2;
    
        C4::AR::Auth::print_header($session);
        print to_json \%info;
    }else{
        #no existe el objeto de nivel2
        C4::AR::Auth::print_header($session);
        print 0;
    }
}

elsif($tipoAccion eq "MODIFICAR_NIVEL_3"){
     my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'MODIFICACION', 
                                                    entorno => 'datos_nivel3'}, 
                                                'intranet'
                                    );

    $obj->{'responsable'}=$user;
    my ($Message_arrayref, $nivel3) = C4::AR::Nivel3::t_modificarNivel3($obj);
    
    my %info;
    $info{'Message_arrayref'}       = $Message_arrayref;

    C4::AR::Auth::print_header($session);
    print to_json \%info;
}

elsif($tipoAccion eq "GUARDAR_INDICE"){
     my ($user, $session, $flags)= checkauth(   $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'ALTA', 
                                                    entorno => 'datos_nivel1'}, 
                                                'intranet'
                                    );
    my ($Message_arrayref) = C4::AR::Nivel2::t_guardarIndice($obj);
    
    my %info;
    $info{'Message_arrayref'} = $Message_arrayref;

    C4::AR::Auth::print_header($session);
    print to_json \%info;
}
elsif($tipoAccion eq "MOSTRAR_INDICE"){

    my ($template, $session, $t_params) = get_template_and_user({
                            template_name => "/includes/partials/catalogo/contenido_indice.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {      ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'datos_nivel1' },
                            debug => 1,
                    });

    $t_params->{'indice'}       = "";
    my ($catRegistroMarcN2)     = C4::AR::Nivel2::getNivel2FromId2($obj->{'id2'});

    if($catRegistroMarcN2){
        $t_params->{'indice'}   = $catRegistroMarcN2->getIndice();
    }
 
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
elsif($tipoAccion eq "IMPORTAR_DESDE_KOHA"){
     my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'IMPORTAR_DESDE_KOHA', 
                                                    entorno => 'datos_nivel3'}, 
                                                'intranet'
                                    );

    my ($Message_arrayref) = C4::AR::Catalogacion::koha2_to_meran($obj);
    
    my %info;
    $info{'Message_arrayref'} = $Message_arrayref;

    C4::AR::Auth::print_header($session);
    print to_json \%info;
}
elsif($tipoAccion eq "ELIMINAR_NIVEL"){
    my $entorno= 'datos_nivel1';
    if($obj->{'nivel'} eq '2'){$entorno= 'datos_nivel2'};
    if($obj->{'nivel'} eq '3'){$entorno= 'datos_nivel3'};
    
     my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'BAJA', 
                                                    entorno => $entorno}, 
                                                'intranet'
                                    );
    $obj->{'responsable'}=$user;
    my $nivel= $obj->{'nivel'};
	my $id= $obj->{'id1'} || $obj->{'id2'};
    my ($Message_arrayref);
   
    if ($nivel == 1){
      ($Message_arrayref)= C4::AR::Nivel1::t_eliminarNivel1($id);
    }
    elsif($nivel == 2){
      ($Message_arrayref)= C4::AR::Nivel2::t_eliminarNivel2($id);
    }
    elsif($nivel == 3){
		($Message_arrayref)= C4::AR::Nivel3::t_eliminarNivel3($obj);
    }

	my %info;
    $info{'Message_arrayref'}= $Message_arrayref;
    
    C4::AR::Auth::print_header($session);
	print to_json \%info;
}
#=============================================================FIN ABM Catalogo===============================================================
elsif($tipoAccion eq "MOSTRAR_DETALLE_NIVEL3"){
	 my ($template, $session, $t_params)  = get_template_and_user({
							template_name   => ('catalogacion/estructura/ejemplaresDelGrupo.tmpl'),
							query           => $input,
							type            => "intranet",
							authnotrequired => 0,
							flagsrequired   => {    ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'datos_nivel1' },
});


	#Cuando viene desde otra pagina que llama al detalle.
	my $id2= $obj->{'id2'};
	my($nivel2_hashref)				        = C4::AR::Nivel3::detalleNivel3($id2);
	$t_params->{'disponibles'}			    = $nivel2_hashref->{'disponibles'};
	$t_params->{'cantReservas'}			    = $nivel2_hashref->{'cantReservas'};
	$t_params->{'cantReservasEnEspera'}		= $nivel2_hashref->{'cantReservasEnEspera'};
	$t_params->{'cantPrestados'}			= $nivel2_hashref->{'cantPrestados'};
	$t_params->{'nivel3'}				    = $nivel2_hashref->{'nivel3'};
	$t_params->{'id2'}				        = $id2;
	$t_params->{'cant_nivel3'}              = $nivel2_hashref->{'cant_nivel3'};
	$t_params->{'cantReservasAsignadas'}    = $nivel2_hashref->{'cantReservasAsignadas'};
	#se ferifica si la preferencia "circularDesdeDetalleDelRegistro" esta seteada

	$t_params->{'circularDesdeDetalleDelRegistro'}	= C4::AR::Preferencias::getValorPreferencia('circularDesdeDetalleDelRegistro');
    
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
#============================================================= Ayudas MARC ===============================================================
elsif($tipoAccion eq "SHOW_AYUDA_MARC"){

    my ($template, $session, $t_params)  = get_template_and_user({
                            template_name   => ('catalogacion/estructura/showAyudaMarc.tmpl'),
                            query           => $input,
                            type            => "intranet",
                            authnotrequired => 0,
                            flagsrequired   => {    ui              => 'ANY', 
                                                    tipo_documento  => 'ANY', 
                                                    accion          => 'CONSULTA', 
                                                    entorno         => 'datos_nivel1' },
    });

    use C4::AR::AyudaMarc;
    use C4::AR::EstructuraCatalogacionBase;

    my $ayudasMarc      = C4::AR::AyudaMarc::getAyudaMarcCampo($obj->{'campo'});

    my $ayudaMarcWeb    = C4::AR::EstructuraCatalogacionBase::getCampoByCampo($obj->{'campo'});

    if($ayudasMarc){
        $t_params->{'ayudasMarc'}   = $ayudasMarc;
    }else{
        $t_params->{'ayudasMarc'}    = 0;
    }

    $t_params->{'ayudaMarcWeb'}     = $ayudaMarcWeb->getDescripcion;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
#============================================================= Portadas Edicion ===============================================================
elsif($tipoAccion eq "SHOW_ADD_PORTADA_EDICION"){

    my ($template, $session, $t_params)  = get_template_and_user({
                            template_name   => ('catalogacion/estructura/agregarPortadaEdicionModal.tmpl'),
                            query           => $input,
                            type            => "intranet",
                            authnotrequired => 0,
                            flagsrequired   => {    ui              => 'ANY', 
                                                    tipo_documento  => 'ANY', 
                                                    accion          => 'CONSULTA', 
                                                    entorno         => 'datos_nivel1' },
    });

    use C4::AR::PortadaNivel2;

    my $portadasEdicion             = C4::AR::PortadaNivel2::getPortadasEdicion($obj->{'id2'});

    if($portadasEdicion) {
        $t_params->{'portadasEdicion'}  = $portadasEdicion;
        $t_params->{'editing'}          = 1;
    }else{
        $t_params->{'portadasEdicion'}  = 0;
        $t_params->{'editing'}          = 0;
    }

    my $isbn                        = C4::AR::Nivel2::getISBNById2($obj->{'id2'});

    if ($isbn) {
        my $portada                         = C4::AR::PortadasRegistros::getPortadaByIsbn($isbn);

        if($portada){
            $t_params->{'editing'}              = 1;
            $t_params->{'portadasRegistro'}     = $portada;
            $t_params->{'S'}                    = $portada->getSmall();
            $t_params->{'M'}                    = $portada->getMedium();
            $t_params->{'L'}                    = $portada->getLarge();
        }
    }

    $t_params->{'id1'}      = $obj->{'id1'};
    $t_params->{'id2'}      = $obj->{'id2'};
    $t_params->{'token'}    = $obj->{'token'};

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
elsif($tipoAccion eq "CHECK_PROMOTION"){

    my ($template, $session, $t_params)  = get_template_and_user({
                            template_name   => ('catalogacion/estructura/agregarPortadaEdicionModal.tmpl'),
                            query           => $input,
                            type            => "intranet",
                            authnotrequired => 0,
                            flagsrequired   => {    ui              => 'ANY', 
                                                    tipo_documento  => 'ANY', 
                                                    accion          => 'CONSULTA', 
                                                    entorno         => 'datos_nivel1' },
    });

   my $html      = C4::AR::Nivel2::checkPromotion($obj->{'id2'});

   C4::AR::Auth::print_header($session);
   print $obj->{'id2'}."/////////////////////ID2////////////////////".$html;

}
elsif($tipoAccion eq "PROMOTE_GRUPO"){

    my ($template, $session, $t_params)  = get_template_and_user({
                            template_name   => ('catalogacion/estructura/agregarPortadaEdicionModal.tmpl'),
                            query           => $input,
                            type            => "intranet",
                            authnotrequired => 0,
                            flagsrequired   => {    ui              => 'ANY', 
                                                    tipo_documento  => 'ANY', 
                                                    accion          => 'CONSULTA', 
                                                    entorno         => 'datos_nivel1' },
    });

   my $html      = C4::AR::Nivel2::promoteGrupo($obj->{'id2'});

   C4::AR::Auth::print_header($session);
   print $obj->{'id2'}."/////////////////////ID2////////////////////".$html;
}
elsif($tipoAccion eq "UNPROMOTE_GRUPO"){

    my ($template, $session, $t_params)  = get_template_and_user({
                            template_name   => ('catalogacion/estructura/agregarPortadaEdicionModal.tmpl'),
                            query           => $input,
                            type            => "intranet",
                            authnotrequired => 0,
                            flagsrequired   => {    ui              => 'ANY', 
                                                    tipo_documento  => 'ANY', 
                                                    accion          => 'CONSULTA', 
                                                    entorno         => 'datos_nivel1' },
    });

   my $html      = C4::AR::Nivel2::unPromoteGrupo($obj->{'id2'});

   C4::AR::Auth::print_header($session);
   print $obj->{'id2'}."/////////////////////ID2////////////////////".$html;
}
elsif($tipoAccion eq "ELIMINAR_RELACION_ANALITICA"){

    my ($template, $session, $t_params)  = get_template_and_user({
                            template_name   => ('catalogacion/estructura/agregarPortadaEdicionModal.tmpl'),
                            query           => $input,
                            type            => "intranet",
                            authnotrequired => 0,
                            flagsrequired   => {    ui              => 'ANY', 
                                                    tipo_documento  => 'ANY', 
                                                    accion          => 'CONSULTA', 
                                                    entorno         => 'datos_nivel1' },
    });

    # my $id1 = $obj->{'id1'};
    # my $id2 = $obj->{'id2'};
    my ($Message_arrayref);
   
# FIXME esto es correcto????
    ($Message_arrayref)= C4::AR::Catalogacion::t_eliminarRelacion($obj);

    my $infoOperacionJSON = to_json $Message_arrayref;
    
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}