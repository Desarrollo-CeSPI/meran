/*
 * Meran - MERAN UNLP is a ILS (Integrated Library System) wich provides Catalog,
 * Circulation and User's Management. It's written in Perl, and uses Apache2
 * Web-Server, MySQL database and Sphinx 2 indexing.
 * Copyright (C) 2009-2013 Grupo de desarrollo de Meran CeSPI-UNLP
 *
 * This file is part of Meran.
 *
 * Meran is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Meran is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Meran.  If not, see <http://www.gnu.org/licenses/>.
 */

/*
 * LIBRERIA catalogacion v 1.0.1
 * Esta es una libreria creada para el sistema KOHA
 * Contendran las funciones para permitir la circulacion en el sistema
 * Las siguientes librerias son necesarias:
 *  <script src="/includes/jquery/jquery.js"></script>
 *  <script src="/includes/json/jsonStringify.js"></script>
 *  <script src="/includes/AjaxHelper.js"></script>
 *  <script src="/intranet-tmpl/includes/util.js"></script>
 *
 */

//************************************************REVISADO******************************************************************

var ID_N1                   = 0; //para saber el id del nivel 1
var ID_N1_PADRE             = 0; //para el id1 del padre en una analitica
var ID_N2                   = 0; //para saber el id del nivel 2
var ID_N2_PADRE             = 0; //para el id2 del padre en una analitica
var ID_N3                   = 0; //para saber el id del nivel 3
var ID_TIPO_EJEMPLAR        = 0; //para saber con tipo de ejemplar se esta trabajando
var TAB_INDEX               = 0;//tabindex para las componentes
//arreglo de objetos componentes, estos objetos son actualizados por el usuario y luego son enviados al servidor
var MARC_OBJECT_ARRAY       = new Array();
//arreglo con datos del servidor para modificar las componentes
var MODIFICAR               = 0;
var ACTION                  = "UNDEFINED";
var TEMPLATE_ACTUAL         = 0;
var EDICION_N3_GRUPAL       = 0; //=1 indica si se estan editando datos del Nivel 3 de forma grupal
var FROM_DETALLE_REGISTRO   = 0;
var ID3_ARRAY               = new Array(); //para enviar 1 o mas ID_N3 para agregar/modificar/eliminar
var BARCODES_ARRAY          = new Array(); //para enviar 1 o mas barcodes
var _NIVEL_ACTUAL           = 1; //para mantener el nivel que se esta procesando
var _message                = CAMPO_NO_PUEDE_ESTAR_EN_BLANCO;
var HASH_RULES              = new Array(); //para manejar las reglas de validacion del FORM dinamicamente
var HASH_MESSAGES           = new Array();
var AGREGAR_COMPLETO        = 1; //flag para verificar si se esta por agregar un documento desde el nivel 1 o no
var ID_COMPONENTE           = 1;
var scroll                  = 'N1';
var FATAL_ERROR             = 0;

function clear_fatal_error(){
    $('#nivel1Tabla').html("");
    $('#nivel2Tabla').html("");
    $('#nivel3Tabla').html("");
    $('#nivel1').html("");
}

function agregarAHash (HASH, name, value){
    HASH[name] = value;
}

//objeto generico para enviar parametros a cualquier funcion, se le van creando dinamicamente los mismos
function objeto_params(){
    
}

function inicializarSideLayers(){
    arreglo = $('#nivel2>fieldset legend');
    for (x = 0; x<arreglo.length; x++){
        $(arreglo[x]).removeClass('activeLayer');
        $(arreglo[x]).addClass('nivel2Selected');
    }
}

function toggleClass(layer){
    inicializarSideLayers();
    $(layer).addClass('activeLayer');
}

function inicializar(){

    _freeMemory(MARC_OBJECT_ARRAY);
    MARC_OBJECT_ARRAY   = [];
    _freeMemory(BARCODES_ARRAY);
    BARCODES_ARRAY      = [];
    TAB_INDEX           = 0;
    EDICION_N3_GRUPAL   = 0;
    
    $('#datos_del_leader').hide();  
}

//libera espacio de memoria utilizada por los arreglos
function _freeMemory(array){
    for(var i=0;i<array.length;i++){
        delete array[i];
    }
}

//busca en array el string pasado por parametro
function _existeEnArray(array, elemento){
    var cant = 0;

    for(var i=0;i<array.length;i++){
        if( jQuery.trim(array[i]) == jQuery.trim(elemento) ){
            cant++;
            if(cant > 1){
            //el elemento existe mas de 1 vez, esta repetido
                return 1;   
            }           
        }
    }

    return 0;
}

function verificarAgregarDocumentoN3(){
    var repetidos_array = new Array();
    var existe          = 0;

    if(_getBarcodes()){
        //verifico que los barcodes no esten repetidos
        for(var i=0;i<BARCODES_ARRAY.length;i++){
            if( _existeEnArray(BARCODES_ARRAY, BARCODES_ARRAY[i]) ){
                existe = 1;
                repetidos_array.push(BARCODES_ARRAY[i]);
            }
        }
    
        if(existe){
            jAlert(HAY_BARCODES_REPETIDOS,CATALOGO_ALERT_TITLE);
            return 0;
        }
    }

    return 1;
}

function _setFoco(){
    //obtengo cualquer componente que tenga tabindex = 1
    if($("[tabindex='1']")[0]){
        $("[tabindex='1']")[0].focus();
    }
}

function seleccionoAlgo(chckbox){
    var chck = $("input[name="+chckbox+"]:checked");
    var array = new Array;
    var long = chck.length;
    if ( long == 0){
        jAlert(ELIJA_AL_MENOS_UN_EJEMPLAR,CATALOGO_ALERT_TITLE);
        return 0;
    }

    return 1;
}

/*
Esta funcion retorna el ID de la componente en COMPONENTE_ARRAY segun campo, subcampo
*/
function _getIdComponente(campo, subcampo){
    for(var i=0;i<MARC_OBJECT_ARRAY.length;i++){
        var marc_object = MARC_OBJECT_ARRAY[i];

        if (marc_object.getCampo() == campo) {

            var subcampos_array = marc_object.getSubCamposArray();
            for(var j=0;j< subcampos_array.length;j++){
                if (subcampos_array[j].getSubCampo() == subcampo) {
                    return subcampos_array[j].getIdCompCliente();
                }
            }
        }
    }

    return 0;
}

/*
    Esta funcion busca la posicion dentro del arreglo de subcampos del subcampo marc segun el idCompCliente
*/
function _getPosBySubCampoMARC_conf_ById(id){
    for(var i=0;i<MARC_OBJECT_ARRAY.length;i++){
        var subcampos_array = MARC_OBJECT_ARRAY[i].getSubCamposArray();
        for(var s=0;s<subcampos_array.length;s++){
            if(subcampos_array[s].getIdCompCliente() == id){

                return s;
            }
        }
    }

    return 0;
}

/*
    Esta funcion busca un objeto subcampo marc en el arreglo de objetos de configuracion MARC, sgeun el idCompCliente
*/
function _getSubCampoMARC_conf_ById(id){
    for(var i=0;i<MARC_OBJECT_ARRAY.length;i++){
        var subcampos_array = MARC_OBJECT_ARRAY[i].getSubCamposArray();
        for(var s=0;s<subcampos_array.length;s++){
            if(subcampos_array[s].getIdCompCliente() == id){

                return subcampos_array[s];
            }
        }
    }

    return 0;
}

function _getCampoMARC_conf_ById(id){
    for(var i=0;i<MARC_OBJECT_ARRAY.length;i++){
        if(MARC_OBJECT_ARRAY[i].getIdCompCliente() == id){

            return MARC_OBJECT_ARRAY[i];
        }
    }

    return 0;
}

function _getIndexCampoMARC_conf_ById(id){
    for(var i=0;i<MARC_OBJECT_ARRAY.length;i++){
        if(MARC_OBJECT_ARRAY[i].getIdCompCliente() == id){

            return i;
        }
    }

    return -1;
}

// Array Remove - By John Resig (MIT Licensed)
function removeFromArray (array, from, to) {
  var rest = array.slice((to || from) + 1 || array.length);
  array.length = from < 0 ? array.length + from : from;
  return array.push.apply(array, rest);
};

function _getBarcodes(){
    var barcodes_string = $('#'+_getIdComponente('995','f')).val();

    //inicializo el arreglo
    _freeMemory(BARCODES_ARRAY);
    BARCODES_ARRAY= [];

    if((typeof(barcodes_string) !== 'undefined')&&(barcodes_string != '')){
        BARCODES_ARRAY = barcodes_string.split(",");
        return 1;
    }
    
    return 0;
}

//esta funcion elimina el arreglo de opciones, para enviar menos info al servidor
function _sacarOpciones(){
    for(var i=0;i<MARC_OBJECT_ARRAY.length;i++){
        var subcampos_array = MARC_OBJECT_ARRAY[i].getSubCamposArray();
        for(var s=0;s<subcampos_array.length;s++){
            if(subcampos_array[s].opciones){//si esta definido...
                if(subcampos_array[s].opciones.length > 0){
                    //elimino la propiedad opciones, para enviar menos info al servidor
                    subcampos_array[s].opciones= [];
                }
            }
        }
    }
}

function _clearDataFromComponentesArray(){
    for(var i=0;i< MARC_OBJECT_ARRAY.length;i++){
        MARC_OBJECT_ARRAY[i].dato= '';
        $('#'+MARC_OBJECT_ARRAY[i].idCompCliente).val('');
    }
}

function _clearContentsEstructuraDelNivel(){
    $("#estructuraDelNivel1").html("");
    $("#estructuraDelNivel2").html("");
    $("#estructuraDelNivel3").html("");
}

// muestra/oculta los divs de la estructura segun el nivel que se este procesando
function _showAndHiddeEstructuraDelNivel(nivel){
     if(nivel == 0){
        $('#nivel1Tabla').hide();
        $('#nivel2Tabla').hide();
        $('#nivel3Tabla').hide();   
    }else if(nivel == 1){
        $('#nivel1Tabla').show();
        $('#nivel2Tabla').hide();
        $('#nivel3Tabla').hide();
    }else if(nivel == 2){
        $('#nivel2Tabla').show();
        $('#nivel1Tabla').hide();
        $('#nivel3Tabla').hide();
    }else if(nivel == 3){
        $('#nivel3Tabla').show();
        $('#nivel1Tabla').hide();
        $('#nivel2Tabla').hide();
    }
}


//esta funcion sincroniza la informacion del cliente con el arreglo de componentes para enviarlos al servidor
function syncComponentesArray(){
    for(var i=0; i < MARC_OBJECT_ARRAY.length; i++){
//         log("syncComponentesArray => proceso " + MARC_OBJECT_ARRAY.length + " campos ");

        var subcampos_array                 = MARC_OBJECT_ARRAY[i].getSubCamposArray();
        var subcampos_hash                  = MARC_OBJECT_ARRAY[i].subcampos_hash;
        var subcampo_valor                  = '';
        MARC_OBJECT_ARRAY[i].cant_subcampos = 0; //para llevar la cantidad de subcampos del campo q se esta procesando


// TODO falta setear el indicador primero y segundo
        MARC_OBJECT_ARRAY[i].indicador_primario     = $("#select_indicador_primario" + i).val();
        MARC_OBJECT_ARRAY[i].indicador_secundario   = $("#select_indicador_secundario" + i).val();
    
        for(var s=0; s < subcampos_array.length; s++){
            subcampo_valor = new Object();

                if(subcampos_array[s].getReferencia() == '1'){
                    //log("TIENE REFERENCIA");
                    if($('#'+subcampos_array[s].getIdCompCliente()).val() != '' && subcampos_array[s].getTipo() == 'combo'){
//                         subcampo_valor[subcampos_array[s].getSubCampo()] = $('#'+subcampos_array[s].getIdCompCliente()).val();
                        subcampos_array[s].setDato($('#'+subcampos_array[s].getIdCompCliente()).val());
                        subcampo_valor[subcampos_array[s].getSubCampo()] = $('#'+subcampos_array[s].getIdCompCliente()).val();
//                         log("syncComponentesArray => COMBO => subcampo => " + subcampos_array[s].getSubCampo() + " dato " + subcampos_array[s].getDato());
                    }else if($('#'+subcampos_array[s].getIdCompCliente()).val() != '' && subcampos_array[s].getTipo() == 'auto'){
//                         subcampos_array[s].setDatoReferencia($('#'+subcampos_array[s].getIdCompCliente() + '_hidden').val());
                        subcampos_array[s].setDato($('#'+subcampos_array[s].getIdCompCliente() + '_hidden').val());
                        subcampos_array[s].setDatoReferencia($('#'+subcampos_array[s].getIdCompCliente()).val());
//                         alert( ('#'+subcampos_array[s].getIdCompCliente() ));
                        subcampo_valor[subcampos_array[s].getSubCampo()] = $('#'+subcampos_array[s].getIdCompCliente() + '_hidden').val();
//                         log("syncComponentesArray => AUTO => subcampo => " + subcampos_array[s].getSubCampo() + " dato " + subcampos_array[s].getDato());
                    }else{
//                         subcampos_array[s].datoReferencia = 0;
                        subcampos_array[s].datoReferencia = 'NULL';
//                         subcampos_array[s].setDato('');
                        subcampos_array[s].setDato($('#'+subcampos_array[s].getIdCompCliente()).val());
//                         subcampo_valor[subcampos_array[s].getSubCampo()] = 0;
                        subcampo_valor[subcampos_array[s].getSubCampo()] = 'NULL';  
//                         log("syncComponentesArray => OTRO => subcampo => " + subcampos_array[s].getSubCampo() + " dato " + subcampos_array[s].getDato());
                    }
                }else{  
                    //log("NO TIENE REFERENCIA");
                    //log("DATO: "+$('#'+subcampos_array[s].getIdCompCliente()).val());
//                     log("syncComponentesArray => NO TIENE REFERENCIA => subcampo => " + subcampos_array[s].getSubCampo() + " dato " + subcampos_array[s].getDato());
                    subcampos_array[s].setDato($('#'+subcampos_array[s].getIdCompCliente()).val());
//                        subcampo_valor = new Object();
                    subcampo_valor[subcampos_array[s].getSubCampo()] = $('#'+subcampos_array[s].getIdCompCliente()).val();
                }

//                 log("syncComponentesArray => NO TIENE REFERENCIA => subcampo => " + subcampo_valor);
                subcampos_hash[s] = subcampo_valor;
//             }
             
        }//END for(var s=0; s < subcampos_array.length; s++)
            MARC_OBJECT_ARRAY[i].cant_subcampos = subcampos_array.length;
            
    }//END for(var i=0; i < MARC_OBJECT_ARRAY.length; i++)
}

//dado el nivel pasado por parametro devuelve el nombre del div contenedor
function getDivDelNivel(){
    
    switch(_NIVEL_ACTUAL){
        case 1:
            return 'estructuraDelNivel1';   
        break;
        case 2:
            return 'estructuraDelNivel2';
        break;
        case 3:
            return 'estructuraDelNivel3';
        break;
    }
}


// FIXME esto podria ser generico para los 3 niveles
function mostrarEstructuraDelNivel1(){
    _NIVEL_ACTUAL       = 1;
   
    if((MODIFICAR == 0)&&(ACTION != "AGREGAR_ANALITICA")){
        _mostrarAccion("<h4>Agregando registro con el esquema: " + $('#tipo_nivel3_id option:selected').html() + " (" + TEMPLATE_ACTUAL + ")</h4>" + crearBotonEsquema());
    } 

    objAH               = new AjaxHelper(updateMostrarEstructuraDelNivel1);
    objAH.debug         = true;
    objAH.showOverlay   = true;
    objAH.showState     = true;  
    objAH.url           = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
    objAH.tipoAccion    = "MOSTRAR_ESTRUCTURA_DEL_NIVEL";
    objAH.nivel         = _NIVEL_ACTUAL;
    objAH.id_tipo_doc   = TEMPLATE_ACTUAL;//$('#tipo_nivel3_id').val();
    objAH.sendToServer();
}


function updateMostrarEstructuraDelNivel1(responseText){
    //se verifica que exista la configuaracion del catalogo
    var info        = JSONstring.toObject(responseText);
    var Messages    = info.Message_arrayref;
    if(setMessages(Messages) == 1){
        clear_fatal_error();
    } else {

        _clearContentsEstructuraDelNivel();
        _showAndHiddeEstructuraDelNivel(1);
        //proceso la info del servidor y se crean las componentes en el cliente
        //ademas se carga el arreglo MARC_OBJECT_ARRAY donde se hace el mapeo de componente del cliente y dato
        var objetos_array = JSONstring.toObject(responseText);
        procesarInfoJson(objetos_array, null); 
        //asigno el handler para el validador
        validateForm('formNivel1',guardarModificarDocumentoN1);
        scrollTo('nivel1Tabla');  
            $('.hasDatepicker').datepicker();

    }
}

function mostrarEstructuraDelNivel2(){
    _NIVEL_ACTUAL       = 2;
    
    if((MODIFICAR == 0)&&(ACTION != "AGREGAR_ANALITICA")){
        _mostrarAccion("<h4>Agregando Nivel 2 con el esquema: " + $('#tipo_nivel3_id option:selected').html() + " (" + TEMPLATE_ACTUAL + ")</h4>" + crearBotonEsquema());
    }
    
    objAH               = new AjaxHelper(updateMostrarEstructuraDelNivel2);
    objAH.debug         = true;
    objAH.showOverlay   = true;  
    objAH.showOverlay   = true;
    objAH.url           = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
    objAH.tipoAccion    = "MOSTRAR_ESTRUCTURA_DEL_NIVEL";
    objAH.nivel         = 2;
    objAH.id_tipo_doc   = TEMPLATE_ACTUAL;
    objAH.sendToServer();

}

function updateMostrarEstructuraDelNivel2(responseText){
    //se verifica que exista la configuaracion del catalogo
    var info        = JSONstring.toObject(responseText);
    var Messages    = info.Message_arrayref;
    if(setMessages(Messages) == 1){
        clear_fatal_error();
    } else {

        _clearContentsEstructuraDelNivel();
        _showAndHiddeEstructuraDelNivel(2);
        
        //proceso la info del servidor y se crean las componentes en el cliente
        var objetos_array = JSONstring.toObject(responseText);
        procesarInfoJson(objetos_array, null); 
        //asigno el handler para el validador
        validateForm('formNivel2',guardarModificarDocumentoN2);
        
        if(!MODIFICAR){
            if(ID_TIPO_EJEMPLAR == 0){
                $('#'+_getIdComponente('910','a')).val($('#tipo_nivel3_id').val());
            } else {
                //dejo seleccionado el tipo de documento segun el esquema  
                $('#'+_getIdComponente('910','a')).val(ID_TIPO_EJEMPLAR);
            } 
        }      
        
        scrollTo('nivel2Tabla');   
        $('.hasDatepicker').datepicker();
    }
}


/*
    Esta funcion selecciona en el combo de tipo de documento q se crea dinamicamente, el tipo de documento seleccionado en el combo
    esquema de ingreso de datos.
*/
function _seleccionarTipoDocumentoYDeshabilitarCombo(){
    if(MODIFICAR == 1){
        //obtengo el ID de la componente del combo de tipo de nivel3
        id = _getIdComponente('910','a');
        $('#'+ id).val($('#tipo_nivel3_id').val());    
        $('#'+ id).attr('disabled', 'true');
    }
}

function mostrarEstructuraDelNivel3(tipo_documento){
    _NIVEL_ACTUAL       = 3;
    
//     if(MODIFICAR == 0){
//         _mostrarAccion(crearBotonEsquema() + "Agregando ejemplares => Template: " + $('#tipo_nivel3_id').val() + crearBotonEsquema());
//     }

    objAH               = new AjaxHelper(updateMostrarEstructuraDelNivel3);
    objAH.debug         = true;
    objAH.showOverlay   = true;
    objAH.url           = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
    objAH.tipoAccion    = "MOSTRAR_ESTRUCTURA_DEL_NIVEL";
    objAH.nivel         = _NIVEL_ACTUAL;
    objAH.id_tipo_doc   = (tipo_documento)?tipo_documento:$("#tipo_nivel3_id").val();
    objAH.sendToServer();
}

function updateMostrarEstructuraDelNivel3(responseText){
    //se verifica que exista la configuaracion del catalogo
    var info        = JSONstring.toObject(responseText);
    var Messages    = info.Message_arrayref;
    if(setMessages(Messages) == 1){
        clear_fatal_error();
    } else {

        _clearContentsEstructuraDelNivel();
        _showAndHiddeEstructuraDelNivel(3);
          TAB_INDEX= 0;
        //proceso la info del servidor y se crean las componentes en el cliente
        var objetos_array = JSONstring.toObject(responseText);

        procesarInfoJson(objetos_array, null); 
        scrollTo('nivel3Tabla');
        
        if($('#cantEjemplares').val() > 0) {
            $('#'+_getIdComponente('995','f')).removeClass('required');
        } 
        //asigno el handler para el validador
        validateForm('formNivel3',guardarModificarDocumentoN3);
        if(MODIFICAR == 0){
            //si se esta agregando se muestra el input para la cantidad    
            var id = _getIdComponente('995','f');
            $('#'+id).click(function(){
                registrarToggleOnChangeForBarcode(id);
            });
        }

    // TODO fatlta ver esto!!!!!!!
        if(EDICION_N3_GRUPAL == 0){
        //no se trata de una edicion grupal se agregan las reglas para validar los campos, sino se permiten campos nulos
    //         addRules();
        } else {
            $("#nivel3Tabla").before("<div class='alert alert-heading'>Registro: <a href='detalle.pl?id1=" + REGISTRO_ID + "&amp;token='" + TOKEN + "' title='Ver Detalle del Registro'>" + REGISTRO_ID + "</a> <br> Complete sólo los campos que desee modificar</div>");  
            
            
        }
    }
    $('.hasDatepicker').datepicker();

}

function switchTipoBarcode(chosen, readOnly){
  
    readOnly.val('');
    readOnly.attr("readonly",true);
    readOnly.removeClass("required");  
    chosen.val('');
    chosen.removeAttr("readonly");
    chosen.focus();
}

function registrarToggleOnChangeForBarcode(callFromBarcode){
    var cantidad_comp   = $('#cantEjemplares');
    var cantidad_val    = $.trim(cantidad_comp.val());
    var id              = _getIdComponente('995','f');
    var barcode_comp    = $('#'+id);
    var barcode_val     = $.trim(barcode_comp.val());

    if (callFromBarcode){       
        if ((cantidad_val.length)>0) {

            bootbox.confirm(BORRAR_CANTIDAD_DE_EJEMPLARES, function (confirmStatus){ 
                if (confirmStatus){
                    switchTipoBarcode(barcode_comp,cantidad_comp);
                    $('#cantEjemplares').removeClass('required');
                    $('#'+_getIdComponente('995','f')).addClass('required'); 
                    $('#'+_getIdComponente('995','f')).attr("readonly",false);  
                }
            })  
        } else switchTipoBarcode(barcode_comp,cantidad_comp);
    } else {
        if ((barcode_val.length)>0){
            
            bootbox.confirm(BORRAR_LISTA_DE_CODIGOS, function (confirmStatus){   
                if (confirmStatus){
                    switchTipoBarcode(cantidad_comp,barcode_comp);
                    $('#cantEjemplares').addClass('required');    
                    $('#'+_getIdComponente('995','f')).attr("readonly",true);  
                }
            })  
        } else
            switchTipoBarcode(cantidad_comp,barcode_comp);        
    }
}

function seleccionar_esquema(){
    inicializar(); 
    ID_TIPO_EJEMPLAR    = $('#tipo_nivel3_id').val();
    TEMPLATE_ACTUAL     = $('#tipo_nivel3_id').val();
    
    if(MODIFICAR == 0){
        _mostrarAccion("<h4>Agregando ejemplares con el esquema: " + $('#tipo_nivel3_id option:selected').html() + " (" + $('#tipo_nivel3_id').val() + ")</h4>" + crearBotonEsquema());
    }
    
    
    if( (TIENE_NIVEL_2 == 0)&&($('#tipo_nivel3_id').val() == 'SIN SELECCIONAR') ){
        jAlert(SELECCIONE_EL_ESQUEMA,CATALOGO_ALERT_TITLE);
        $('#tipo_nivel3_id').focus();
    }
    
    if( $('#tipo_nivel3_id').val() == 'SIN SELECCIONAR') {
        jAlert(SELECCIONE_EL_ESQUEMA,CATALOGO_ALERT_TITLE);
        $('#tipo_nivel3_id').focus();
    } 
    
    if (MODIFICAR == 1) {
        //estoy modificando
//         alert("estoy modificando => " + MODIFICAR); 
    } else {
        close_esquema();
        //estoy agregando
        MODIFICAR           = 0;
        AGREGAR_COMPLETO    = 0;
          
        
        if(_NIVEL_ACTUAL == 1){  
            mostrarEstructuraDelNivel1();
//             $('#datos_del_leader').hide();    
        } else if(_NIVEL_ACTUAL == 2){
            mostrarEstructuraDelNivel2();
        } else {
            mostrarEstructuraDelNivel3();
        }

        inicializarSideLayers();
    }
   
}

function guardarEsquema(){
    TEMPLATE_ACTUAL     = $('#tipo_nivel3_id').val();
    objAH               = new AjaxHelper(updateGuardarEsquema);
    objAH.showOverlay   = true;
    objAH.debug         = true;
    objAH.url           = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
    objAH.tipoAccion    = "GUARDAR_ESQUEMA";
    objAH.id1           = ID_N1;
    objAH.id2           = ID_N2;
    objAH.id3           = ID_N3;  
    objAH.nivel         = _NIVEL_ACTUAL;
    objAH.template      = $("#tipo_nivel3_id").val();
    objAH.sendToServer();
}

function updateGuardarEsquema(responseText){
    var info        = JSONstring.toObject(responseText);
    var Messages    = info.Message_arrayref;

    setMessages(Messages);
    
    $('#datos_esquema').modal('hide');
    if(_NIVEL_ACTUAL == 1){  
        modificarN1(ID_N1, TEMPLATE_ACTUAL);
        mostrarInfoAltaNivel1(ID_N1);   
    } else if(_NIVEL_ACTUAL == 2){
        modificarN2(ID_N2, TEMPLATE_ACTUAL);
        mostrarInfoAltaNivel2(ID_N2);  
    } else {
        modificarN3(ID_N3, TEMPLATE_ACTUAL);
//         $("#template"+ID_N2).html(TEMPLATE_ACTUAL);      
    }
    
}

function editarIndice(id2){
    
ID_N2 = id2;
   
    $('#datos_indice').modal({   containerCss:{
                backgroundColor:"#fff",
                height:343,
                padding:0,
                width:900
            },
        });
}



function agregarIndice(id2){
    ID_N2 = id2;
   
    $('#datos_indice').modal({   containerCss:{
                backgroundColor:"#fff",
                height:343,
                padding:0,
                width:900
            },
        });

}

function mostrarIndice(id2){
    $("#indice_data" + id2).modal();
}

function guardarIndice(){

    objAH               = new AjaxHelper(updateGuadarIndice);
    objAH.showOverlay   = true;
    objAH.debug         = true;
    objAH.url           = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
    objAH.tipoAccion    = "GUARDAR_INDICE";
    objAH.id2           = ID_N2;
    objAH.indice        = $("#indice_id").val();
    objAH.sendToServer();
    close_window_indice();    
}

function updateGuadarIndice(responseText){    
    var info        = JSONstring.toObject(responseText);
    var Messages    = info.Message_arrayref;
    
    setMessages(Messages);  
}

function close_window_indice(){
    $('#datos_indice').modal('hide');
}  

function agregarN2(){
    _NIVEL_ACTUAL       = 2;
    ID_TIPO_EJEMPLAR    = $("#tipo_nivel3_id").val();
    MODIFICAR           = 0;
    inicializar();  
    open_esquema();
}

function completarArgregarN3(){
    _mostrarAccion("Agregando ejemplares" + crearBotonEsquema());
    $('#divCantEjemplares').show();

}

function agregarN3(id2, tipo_documento){
    _NIVEL_ACTUAL       = 3;
    ID_N2               = id2; 
    ID_TIPO_EJEMPLAR    = tipo_documento;
    MODIFICAR           = 0;
    inicializar();  
    open_esquema();
}

//esta funcion muestra la info en la barra laterarl del NIVEL 1 luego de ser guardado
function mostrarInfoAltaNivel1(id1){

    ID_N1                   = id1;
    objAH                   = new AjaxHelper(updateMostrarInfoAltaNivel1);
    objAH.showOverlay       = true;
    objAH.debug             = true;
    objAH.showStatusIn      = 'nivel1';
    objAH.url               = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
    objAH.tipoAccion        = "MOSTRAR_INFO_NIVEL1_LATERAL";
    objAH.id1               = ID_N1;
    objAH.sendToServer();
}

function updateMostrarInfoAltaNivel1(responseText){
    if((MODIFICAR == 0)&&(_NIVEL_ACTUAL == 1)){
    //si no se esta modificando y es el NIVEL 1
        $('#nivel1Tabla').slideUp('slow');
        $('#estructuraDelNivel1').html('');
    }

    $('#nivel1').html(responseText);
    if (scroll == 'N1')
        scrollTo('nivel1tabla');
}


function getNivel2(id2){
    objAH               = new AjaxHelper(updateMostrarInfoAltaNivel2);
    objAH.showOverlay   = true;
    objAH.debug         = true;
    objAH.url           = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
    objAH.tipoAccion    = "MOSTRAR_INFO_NIVEL2";
    objAH.id2           = id2; //mostrar todos los nivel 2 del nivel1 con el q se esta trabajando, asi este vuela
    objAH.id1           = ID_N1;
    objAH.sendToServer();
}

//esta funcion muestra la info en la barra laterarl del NIVEL 2 luego de ser guardado
function mostrarInfoAltaNivel2(id2){
    objAH               = new AjaxHelper(updateMostrarInfoAltaNivel2);
    objAH.showOverlay   = true;
    objAH.debug         = true;
    objAH.url           = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
    objAH.tipoAccion    = "MOSTRAR_INFO_NIVEL2_LATERAL";
    objAH.id2           = id2; //mostrar todos los nivel 2 del nivel1 con el q se esta trabajando, asi este vuela
    objAH.id1           = ID_N1;
    objAH.sendToServer();
}

function updateMostrarInfoAltaNivel2(responseText){
    if((MODIFICAR == 0)&&(_NIVEL_ACTUAL == 2)){
    //si no se esta modificando y es el NIVEL 1
        $('#nivel2Tabla').slideUp('slow');
        $('#estructuraDelNivel2').html('');
    }

    $('#nivel2').html(responseText);
    if (scroll == 'N2')
        scrollTo('nivel2tabla');
}

/*
Esta funcion es la asignada al handler del validate, ejecuta guardarModificacionDocumentoN1 o guardarDocumentoN1
dependiendo de si se esta modificando o agregando
*/
function guardarModificarDocumentoN1(){

    if(MODIFICAR == 1){
        guardarModificacionDocumentoN1();
    }else{
        guardarDocumentoN1();
    }
}

/*
Esta funcion es la asignada al handler del validate, ejecuta guardarModificacionDocumentoN2 o guardarDocumentoN2
dependiendo de si se esta modificando o agregando
*/
function guardarModificarDocumentoN2(){

    if(MODIFICAR == 1){
        guardarModificacionDocumentoN2();
    }else{
        guardarDocumentoN2();
    }
}

/*
Esta funcion es la asignada al handler del validate, ejecuta guardarModificacionDocumentoN3 o guardarDocumentoN3
dependiendo de si se esta modificando o agregando
*/
function guardarModificarDocumentoN3(){

    if(MODIFICAR == 1){
        guardarModificacionDocumentoN3();
    }else{
        guardarDocumentoN3();
    }
}

function guardarDocumentoN1(){

    syncComponentesArray();
    objAH                           = new AjaxHelper(updateGuardarDocumentoN1);
    objAH.debug                     = true;
    objAH.showOverlay               = true;
    objAH.url                       = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
    objAH.tipoAccion                = "GUARDAR_NIVEL_1";
    objAH.id_tipo_doc               = TEMPLATE_ACTUAL;
    objAH.id_nivel_bibliografico    = $("#id_nivel_bibliografico").val();
    _sacarOpciones();
    objAH.infoArrayNivel1           = MARC_OBJECT_ARRAY;
    objAH.id1                       = ID_N1;
    objAH.id2_padre                 = ID_N2_PADRE;

    objAH.sendToServer();
}

function updateGuardarDocumentoN1(responseText){

    var info        = JSONstring.toObject(responseText);
    var Messages    = info.Message_arrayref;
    ID_N1           = info.id1; //recupero el id desde el servidor

    if (! (hayError(Messages) ) ){
        inicializar();
        $('#datos_del_leader').hide();  
        //carga la barra lateral con info de nivel 1
        mostrarInfoAltaNivel1(ID_N1);
        mostrarEstructuraDelNivel2();
    } else {
        setMessages(Messages);
    }
}

function verificar_guardar_nivel2(){
    var ok = true;
    if( (MODIFICAR == 0)&&($('#tipo_nivel3_id').val() == 'SIN SELECCIONAR') ){
        jAlert(SELECCIONE_EL_ESQUEMA,CATALOGO_ALERT_TITLE);
        $('#tipo_nivel3_id').focus();
        ok = false;
    }

    return ok;
}

function guardarDocumentoN2(){

    if(verificar_guardar_nivel2()){
        syncComponentesArray();
        objAH                   = new AjaxHelper(updateGuardarDocumentoN2);
        objAH.debug             = true;
        objAH.showOverlay       = true;
        objAH.url               = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
        objAH.tipoAccion        = "GUARDAR_NIVEL_2";
        objAH.id_tipo_doc       = TEMPLATE_ACTUAL;
        objAH.tipo_ejemplar     = $('#' + _getIdComponente('910','a')).val();  
        _sacarOpciones();
        objAH.infoArrayNivel2   = MARC_OBJECT_ARRAY;
        objAH.estantes_array    = ESTANTES_SELECCIONADOS_ARRAY; 
        objAH.id1               = ID_N1;
        objAH.id2               = ID_N2; //por si se modificó
        objAH.id2_padre         = ID_N2_PADRE;
        objAH.sendToServer();
    }
}

function updateGuardarDocumentoN2(responseText){
    var info        = JSONstring.toObject(responseText);
    var Messages    = info.Message_arrayref;//obtengo los mensajes para el usuario
// FIXME para ????
    ID_N2           = info.id2; //recupero el id desde el servidor
    setMessages(Messages);

    if (! (hayError(Messages) ) ){
        inicializar();
        //carga la barra lateral con info de nivel 2
        mostrarInfoAltaNivel2(ID_N2);
        if(ACTION != "AGREGAR_ANALITICA"){  
            mostrarEstructuraDelNivel3(TEMPLATE_ACTUAL);    
        } else {
            disableAlert();
            // FIXME no se si esta funcionand
            $('#ajax-indicator').modal({show:true, keyboard: false, backdrop: false,});
            window.location = "detalle.pl?id1=" + ID_N1_PADRE;
        }


        if (FROM_DETALLE_REGISTRO == 1) {
            disableAlert();
            // FIXME no se si esta funcionand
            $('#ajax-indicator').modal({show:true, keyboard: false, backdrop: false,});
            window.location = "detalle.pl?id1=" + ID_N1;
        }
    }
}


function guardarDocumentoN3(){
    if( verificarAgregarDocumentoN3() ){
        syncComponentesArray();
        var porBarcode          = $("#cantEjemplares").attr("readonly")?true:false;
        objAH                   = new AjaxHelper(updateGuardarDocumentoN3);
        objAH.debug             = true;
        objAH.showOverlay       = true;
        objAH.modificado        = 0;
        objAH.url               = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
        objAH.tipoAccion        = "GUARDAR_NIVEL_3";
        objAH.id_tipo_doc       = TEMPLATE_ACTUAL;
        objAH.esPorBarcode      = porBarcode;  
        objAH.ui_origen         = $('#' + _getIdComponente('995','d')).val();
        objAH.ui_duenio         = $('#' + _getIdComponente('995','c')).val();

        if (porBarcode){
            objAH.BARCODES_ARRAY    = BARCODES_ARRAY;
        } else {
            objAH.cantEjemplares    = $("#cantEjemplares").val();
        }
    
        _sacarOpciones();
        objAH.infoArrayNivel3   = MARC_OBJECT_ARRAY;
        objAH.id1 = ID_N1;
        objAH.id2 = ID_N2;
        objAH.sendToServer();
    }
}

function updateGuardarDocumentoN3(responseText){

    var info        = JSONstring.toObject(responseText);
    var Messages    = info.Message_arrayref; //obtengo los mensajes para el usuario
    setMessages(Messages);

    if (! (hayError(Messages) ) ){

        // if (FROM_DETALLE_REGISTRO == 1) {
            disableAlert();
            // FIXME no se si esta funcionand
            $('#ajax-indicator').modal({show:true, keyboard: false, backdrop: false,});
            window.location = "detalle.pl?id1=" + ID_N1;
        // } else {

            //inicializo el arreglo
            _freeMemory(ID3_ARRAY);
            ID3_ARRAY= [];
            _freeMemory(BARCODES_ARRAY);
            BARCODES_ARRAY= [];
            //deja la misma estructura, solo borra el campo dato
            _clearDataFromComponentesArray();
            //acutalizo los datos de nivel 2
            mostrarInfoAltaNivel2(ID_N2);
            //muestra la tabla con los ejemplares agregados
            mostrarInfoAltaNivel3(ID_N2);
        // }
    }

}

function guardarModificacionDocumentoN1(){
    syncComponentesArray();
    objAH                           = new AjaxHelper(updateGuardarModificacionDocumentoN1);
    objAH.debug                     = true;
    objAH.showOverlay               = true;    
    objAH.url                       = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
    objAH.tipoAccion                = "MODIFICAR_NIVEL_1";
    objAH.id_tipo_doc               = TEMPLATE_ACTUAL;
    objAH.id_nivel_bibliografico    = $("#id_nivel_bibliografico").val();
    _sacarOpciones();
    objAH.infoArrayNivel1           = MARC_OBJECT_ARRAY;
    objAH.id1                       = ID_N1;
    objAH.sendToServer();
}

function updateGuardarModificacionDocumentoN1(responseText){

//  MODIFICAR       = 0;
    var info        = JSONstring.toObject(responseText);
    var Messages    = info.Message_arrayref;
// FIXME para que???
//     ID_N1 = info.id1; //recupero el id desde el servidor
    setMessages(Messages);

    if (! (hayError(Messages) ) ){
        inicializar();
        $('#datos_del_leader').hide();    
        //carga la barra lateral con info de nivel 1
        mostrarInfoAltaNivel1(ID_N1);
        mostrarEstructuraDelNivel2();
        //se esta modificando desde el detalle del registro
        if (FROM_DETALLE_REGISTRO == 1) {
            disableAlert();
            // FIXME no se si esta funcionand
            $('#ajax-indicator').modal({show:true, keyboard: false, backdrop: false,});
            window.location = "detalle.pl?id1=" + ID_N1;
        }
        
        MODIFICAR = 0;
    }
}

function guardarModificacionDocumentoN2(){
    syncComponentesArray();
    objAH                   = new AjaxHelper(updateGuardarModificacionDocumentoN2);
    objAH.debug             = true;
    objAH.showOverlay       = true;
    objAH.url               = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
    objAH.tipoAccion        = "MODIFICAR_NIVEL_2";
    objAH.estantes_array    = ESTANTES_SELECCIONADOS_ARRAY; 
    _sacarOpciones();
    objAH.infoArrayNivel2   = MARC_OBJECT_ARRAY;   
    objAH.tipo_ejemplar     = ID_TIPO_EJEMPLAR;
    objAH.id1               = ID_N1;
    objAH.id2               = ID_N2; //por si se modificó
    objAH.sendToServer();
}

function updateGuardarModificacionDocumentoN2(responseText){
    
    if (!verificarRespuesta(responseText)) return(0);

//  MODIFICAR       = 0;
    var info        = JSONstring.toObject(responseText);
    var Messages    = info.Message_arrayref;//obtengo los mensajes para el usuario
// FIXME para que ???
    ID_N2= info.id2; //recupero el id desde el servidor
    setMessages(Messages);

    if (! (hayError(Messages) ) ){
        inicializar();
        //carga la barra lateral con info de nivel 2
        mostrarInfoAltaNivel2(ID_N2);
        mostrarEstructuraDelNivel3(TEMPLATE_ACTUAL);
        //se esta modificando desde el detalle del registro
        if (FROM_DETALLE_REGISTRO == 1){
            disableAlert();
            // FIXME no se si esta funcionand
            $('#ajax-indicator').modal({show:true, keyboard: false, backdrop: false,});
            window.location = "detalle.pl?id1=" + ID_N1;
        }

        MODIFICAR = 0;
    }
}

function guardarModificacionDocumentoN3(){
    syncComponentesArray();
    objAH                   = new AjaxHelper(updateGuardarModificacionDocumentoN3);
    objAH.debug             = true;
    objAH.showOverlay       = true;
    objAH.url               = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
    objAH.tipoAccion        = "MODIFICAR_NIVEL_3";
    objAH.cantEjemplares    = $("#cantEjemplares").val();
    _sacarOpciones();
    objAH.infoArrayNivel3   = MARC_OBJECT_ARRAY; 
    objAH.tipo_ejemplar     = ID_TIPO_EJEMPLAR;
    objAH.id1               = ID_N1;
    objAH.id2               = ID_N2;
    objAH.EDICION_N3_GRUPAL = EDICION_N3_GRUPAL;
    objAH.ID3_ARRAY         = ID3_ARRAY;
    objAH.sendToServer();
}

function updateGuardarModificacionDocumentoN3(responseText){

    var info        = JSONstring.toObject(responseText);
    var Messages    = info.Message_arrayref; //obtengo los mensajes para el usuario
    setMessages(Messages);
    scroll          = 'N3';
    //PARA LIMPIAR EL VALUE DE TODOS (ASI INGRESA UNO NUEVO)
    var allInputs   = $('#estructuraDelNivel3 :input');
    for (x=0; x< allInputs.length; x++){
        allInputs[x].value="";
    }

    if (! (hayError(Messages) ) ){
        //inicializo el arreglo
        _freeMemory(ID3_ARRAY);
        ID3_ARRAY= [];
        //deja la misma estructura, solo borra el campo dato
        _clearDataFromComponentesArray();
        //muestra la tabla con los ejemplares agregados
        mostrarInfoAltaNivel3(ID_N2);
        //se esta modificando desde el detalle del registro
        if (FROM_DETALLE_REGISTRO == 1){
            disableAlert();
            // FIXME no se si esta funcionand
            $('#ajax-indicator').modal({show:true, keyboard: false, backdrop: false,});
            window.location = "detalle.pl?id1=" + ID_N1;
        }

        MODIFICAR = 0;
    }
}


function guardar(nivel){
    if(nivel == 1){
        $('#formNivel1').submit();
//         guardarModificarDocumentoN1();
    } 
    if(nivel == 2){
        $('#formNivel2').submit();
    }
    if(nivel == 3){
        $('#formNivel3').submit(); //hace el submit
    }
}

//esta funcion muestra la info en la barra laterarl del NIVEL 2 luego de ser guardado
/*
    Muestra el Nivel 3 Nivel 2 (idNivel2)
*/
function mostrarInfoAltaNivel3(idNivel2){
    startOverlay();
    if(idNivel2 != 0){
        objAH               = new AjaxHelper(updateMostrarInfoAltaNivel3);
        objAH.debug         = true;
        objAH.showOverlay   = true;
        objAH.url           = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
        objAH.tipoAccion    = "MOSTRAR_INFO_NIVEL3_TABLA";
        objAH.id2           = idNivel2;
        ID_N2               = idNivel2;
        objAH.sendToServer();
    }
}

function updateMostrarInfoAltaNivel3(responseText){
    $('#divCantEjemplares').show(); 
    $('#detalleDelNivel3').html(responseText);
    $('#ejemplares_nive2_id_'+ID_N2).html(responseText);  
    zebra('tablaResult');
    checkedAll('select_all', 'checkEjemplares');
    
    if (scroll == 'N3')
        scrollTo('detalleDelNivel3');
    closeModal();
}

function mostrarInfoAltaNivel3ParaEdicionGrupalFromRegistro(idNivel2){
    if(idNivel2 != 0){
        objAH               = new AjaxHelper(updateMostrarInfoAltaNivel3ParaEdicionGrupalFromRegistro);
        objAH.debug         = true;
        objAH.showOverlay   = true;
        objAH.url           = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
        objAH.tipoAccion    = "MOSTRAR_INFO_NIVEL3_TABLA";
        objAH.id2           = idNivel2;
        ID_N2               = idNivel2;
        objAH.sendToServer();
    }
}

function updateMostrarInfoAltaNivel3ParaEdicionGrupalFromRegistro(responseText){    
    modificarEjemplaresN3();
}

function open_alta_indicador(id_div_alta_indicador){
    $('#'+id_div_alta_indicador).modal();
}

function close_alta_indicador(id){
    closeModal(id); //cirro la ventana
}

function open_esquema(){
    $("#datos_esquema").modal();
    
    if(MODIFICAR == 1){
        $("#boton_guardar_esquema").show();
        $("#boton_seleccionar_esquema").hide();  
    } else {
        $("#boton_guardar_esquema").hide();
        $("#boton_seleccionar_esquema").show();    
    } 
}

function close_esquema(){
    closeModal('datos_esquema'); //cirro la ventana 
}

function guardar_indicadores(id_div_indicadores, i){
// function guardar_indicadores(i){
    var key_indicador_primario      = $("#select_indicador_primario" + i).val();
    var key_indicador_secundario    = $("#select_indicador_secundario" + i).val();

//     var str                         = "<span>" + key_indicador_primario + "</span>";
//         str                         = str + "<span class='indSeparator'>|</span><span>" + key_indicador_secundario + "</span>";

        
    $("#indicador_primario_" + i).html(key_indicador_primario);
    $("#indicador_secundario_" + i).html(key_indicador_secundario);
        
//     $('#'+id_div_indicadores).html(str);
    close_alta_indicador(id_div_indicadores);

    //seteo los valores en los combos ocultos para luego guardarlos en la base
    $("#select_indicador_primario" + i).val(key_indicador_primario); 
    $("#select_indicador_secundario" + i).val(key_indicador_secundario);
}

/*
 * procesarInfoJson
 * procesa la informacion que esta en notacion json, que viene del llamado ajax.
 * @params
 * json, string con formato json.
 */
function procesarInfoJson(marc_object_array, id_padre){

    var objetos     = marc_object_array;
    var campo_ant   = '';
    var campo;
    var strComp;
    var strIndicadores;
    var marc_group;
    var campo_marc_conf_obj;
    var subcampos_array;
    var id_temp;
    var id_div_alta_indicador;
    var id_div_indicadores;
    var id_aux;

    for(var i=0; i < objetos.length; i++){
        //recorro los campos
        strComp = "";
        strIndicadores = "";
    
    //FIXME Miguel: estoy probando, no se pq estas variables se declaran en cada iteracion for
        //guardo el objeto para luego enviarlo al servidor una vez que este actualizado
        /*
        var campo_marc_conf_obj     = new campo_marc_conf(objetos[i]);
        var subcampos_array         = campo_marc_conf_obj.getSubCamposArray(); 
        var id_temp                 = generarIdComponente(); 
        var id_div_alta_indicador   = generarIdComponente();
        var id_div_indicadores      = + id_div_alta_indicador + campo_marc_conf_obj.getCampo();
        var id_aux                  = MARC_OBJECT_ARRAY.length;
        */
        campo_marc_conf_obj     = new campo_marc_conf(objetos[i]);
        subcampos_array         = campo_marc_conf_obj.getSubCamposArray(); 
        id_temp                 = generarIdComponente(); 
        id_div_alta_indicador   = generarIdComponente();
        id_div_indicadores      = + id_div_alta_indicador + campo_marc_conf_obj.getCampo();
        id_aux                  = MARC_OBJECT_ARRAY.length;

        //los indicadores quedan ocultos y se muestran en una ventana
        strComp                 = strComp + "<form id='" + id_div_alta_indicador + "' class= 'modal fade hide form-horizontal well' onsubmit='return false;'>";
    
        strComp                += '<div class="modal-header"><h3>Indicadores</h3></div>';
        
        //genero el indicador primario
        if(campo_marc_conf_obj.getIndicadorPrimario() != ''){
            strIndicadores = "<div class='modal-body'><div class='control-group'>" + "<label for='"+id_div_alta_indicador+"'>Indicador Primero: " + campo_marc_conf_obj.getIndicadorPrimario() + "</label>"+"<div class='controls'>";
            strIndicadores = strIndicadores + crearSelectIndicadoresPrimarios(campo_marc_conf_obj, id_aux);
            strIndicadores = strIndicadores + "<p class='help-inline'>Seleccione un indicador primario para el campo</p>";
            strIndicadores = strIndicadores + "</div></div>";
        }


        //genero el indicador secundario
        if(campo_marc_conf_obj.getIndicadorSecundario() != ''){
            strIndicadores += "<div class='control-group'>" + "<label for='"+id_div_alta_indicador+"'>Indicador Segundo: " + campo_marc_conf_obj.getIndicadorSecundario() + "</label>"+"<div class='controls'>";
            strIndicadores = strIndicadores + crearSelectIndicadoresSecundarios(campo_marc_conf_obj, id_aux);
            strIndicadores = strIndicadores + "<p class='help-block'>Seleccione un indicador secundario para el campo</p>";
            strIndicadores = strIndicadores + "</div></div></div>";
        }
        
        strIndicadores = strIndicadores + "<div class='modal-footer'><p style='text-align: center; margin: 0;'>";
        
        strIndicadores = strIndicadores + "<button class='btn horizontal' onclick=close_alta_indicador('"+id_div_alta_indicador+"');>Cancelar</button>";
        strIndicadores = strIndicadores + "<button class='btn btn-primary horizontal' onclick='guardar_indicadores(" + id_div_alta_indicador + ", " + i +");'>Aceptar</button></p>";
        strIndicadores = strIndicadores + "</div>";
        //cierro UL de indicadores
        strComp = strComp + "</div>"; //end div buttonContainerHorizontal
        strComp = strComp + strIndicadores + "</form>";

        //genero el header para el campo q contiene todos los subcampos
        strComp = strComp + "<div id='marc_group" + id_temp + "' class='row underline' style='width: 80%; margin-left: 0;'><li class='MARCHeader'>";
        strComp = strComp + "<div class='MARCHeader_info'>";

        //header LEFT
        strComp = strComp + "<div style='width:120px;float:left'><div class='btn-group inline'>";
            strComp = strComp + crearBotonAyudaCampo(campo_marc_conf_obj.getCampo());
            if(campo_marc_conf_obj.getIndicadoresPrimarios() != 0){
                strComp = strComp + "<a id='indicador_primario_" + i + "' class='btn click' onclick=open_alta_indicador('" + id_div_alta_indicador + "') title='Indicadores'>" + campo_marc_conf_obj.getIndicadorPrimarioDato() + "</a>" + "|";
            }    
            
            if(campo_marc_conf_obj.getIndicadoresSecundarios() != 0){
                strComp = strComp + "<a id='indicador_secundario_" + i + "' class='btn click' onclick=open_alta_indicador('" + id_div_alta_indicador + "') title='Indicadores'>" + campo_marc_conf_obj.getIndicadorSecundarioDato(); 
            }
        
        strComp = strComp + "</div></div>";

        //header CENTER
        strComp = strComp + "<div id='trigger_" + id_temp + "' class='MARCHeader click trigger trigger_" + id_temp + "' style='width:80%;float:left; margin-left: 10px;'>";
        strComp = strComp + "<a class='fancy_extern_link' href='http://www.loc.gov/marc/bibliographic/bd" + campo_marc_conf_obj.getCampo() + ".html' TARGET='_blank'>" + campo_marc_conf_obj.getCampo() + "</a> - " +  "<h5 class='inline'>" + campo_marc_conf_obj.getNombre() + "</h5>";

        if(campo_marc_conf_obj.getRepetible() == "1"){  
            //cierro div CENTER
            strComp = strComp + "</div>";
            //header RIGHT
            strComp = strComp + "<div style='float:right'>";
            campo_marc_conf_obj.setIdCompCliente("marc_group" + id_temp);
           
            var id = "marc_group" + id_temp + "_buttons";
            strComp = strComp + openDivButtonContainer(id,'campo');
            
            strComp = strComp + "</div>";
            
        } else {
            //cierro div CENTER si no es repetible
            strComp = strComp + "</div>";
        }

        //cierro MARCHeader_info
        strComp = strComp + "</div>";
// TODO creo q el div MARCHeader_content esta deprecated
        strComp = strComp + "</li><div id='MARC_content_" + id_temp + "' class='MARC_content_" + id_temp + " left'>";

        //cierro DIV marc_group
//         strComp = strComp + "</div>";
       

        if(id_padre == null) {
            $("#" + getDivDelNivel()).append(strComp);
        } else {
            //estoy clonando un campo
            $(strComp).insertAfter($("#" + id_padre));
        }

        $("#marc_group" + id_temp + "_buttons_lista").append(crearBotonAgregarCampoRepetible(campo_marc_conf_obj,"marc_group" + id_temp));
        
//         $("#marc_group" + id_temp + "_buttons_lista").append(crearBotonEliminarCampoRepetible(campo_marc_conf_obj,"marc_group" + id_temp, campo_marc_conf_obj.getFirst()));
        $("#marc_group" + id_temp + "_buttons_lista").append(crearBotonEliminarCampoRepetible(campo_marc_conf_obj, campo_marc_conf_obj.getFirst()));  
        
       // alert("first => "+campo_marc_conf_obj.getFirst());
       // alert("getIdCompCliente => "+campo_marc_conf_obj.getIdCompCliente());
        
        //if(!campo_marc_conf_obj.getFirst()){
            $("#boton_eliminar_marc_group" + id_temp).show(); 
        //}
        
        //seteo los datos de los indicadores
        $("#select_indicador_primario" + MARC_OBJECT_ARRAY.length).val(campo_marc_conf_obj.getIndicadorPrimarioDato());
        $("#select_indicador_secundario" + MARC_OBJECT_ARRAY.length).val(campo_marc_conf_obj.getIndicadorSecundarioDato());

        //proceso los subcampos
        var subcampo_marc_conf_obj  = new subcampo_marc_conf(objetos[i]);
        var subcampos_array         = campo_marc_conf_obj.getSubCamposArray();
//         marc_group                  = "marc_group" + id_temp;
        marc_group                  = "MARC_content_" + id_temp;  
        
        for(var j=0; j < subcampos_array.length; j++){
        //recorro los subcampos
            subcampos_array[j].idCompCliente    = "id_componente_" + generarIdComponente();
            subcampos_array[j].marc_group       = marc_group;
            subcampos_array[j].posCampo         = MARC_OBJECT_ARRAY.length;//i; //posicion del campo contenedor en MARC_OBJECT_ARRAY
            subcampos_array[j].posSubCampo      = j; //posicion del subcampo en el arreglo de subcampos
            procesarSubCampo(subcampos_array[j], marc_group);
        }

        MARC_OBJECT_ARRAY.push(campo_marc_conf_obj);
        //cierrdo DIV MARCHeader_content
        strComp = strComp + "</div>";
        //cierro DIV marc_group
        strComp = strComp + "</div>"
        
        strComp = "<script type='text/javascript'>toggle_component('trigger_"+ id_temp +"','MARC_content_"+ id_temp +"');</script>";
        $("#marc_group" + id_temp).append(strComp);

    }

    if(objetos.length != 1) {
        //hago foco en la primer componente
        _setFoco();
    }

    if( MODIFICAR == 0 && _NIVEL_ACTUAL == 2 ){  
    //si se esta agregando un NIVEL 2  
        _seleccionarTipoDocumentoYDeshabilitarCombo();
        $('#'+_getIdComponente('910','a')).val($('#tipo_nivel3_id').val());
    } 

    if(MODIFICAR == 1){
        $('#tipo_nivel3_id').change( function() {
            $('#'+_getIdComponente('910','a')).val($('#tipo_nivel3_id').val());
        });
    }
      
}

function crearBotonAyudaCampo(campo, funcion){
// function crearBotonAyudaCampo(campo,id_div_alta_indicador,indicadores){
    var funcion = "ayudaParaCampo('" + campo + "')";
    
    
    var html = "<div class='btn-group inline'>"+"<a class='btn click' onclick=" + funcion + " title='Info'><i class='icon-info-sign'></i></a>";
    
    html += "</div>";
    
    return html;
}

function crearBotonEsquema(){
    
    var html = "<a class='btn btn-primary click' title='Cambiar el esquema' onclick='open_esquema();' > Esquema</a>";
    
    
    return html;
}

function crearBotonAgregarEjemplares(ID2,TIPO_DOC){

	var html = "<a class='btn btn-success click' title='"+ADD_EJEMPLARES+"' onclick=agregarN3("+ID2+",'"+TIPO_DOC+"'); completarArgregarN3(); ><i class='icon-white icon-plus-sign'></i> "+ADD_EJEMPLARES+"</a>";
    
    
    return html;
	
}

function crearBotonAgregarEdicion(ID2,TIPO_DOC){

    var html = "<a class='btn btn-success click' title='"+ADD_EDICION+"' onclick=agregarN3("+ID2+",'"+TIPO_DOC+"'); completarArgregarN3(); ><i class='icon-white icon-plus-sign'></i> "+ADD_EDICION+"</a>";
    
    
    return html;
    
}

function ayudaParaCampo(campo){
    objAH                   = new AjaxHelper(updateAyudaParaCampo);
    objAH.debug             = true;
    objAH.showOverlay       = true;
    objAH.url               = URL_PREFIX+'/catalogacion/estructura/estructuraCataloDB.pl';
    objAH.tipoAccion        = 'SHOW_AYUDA_MARC';
    objAH.campo             = campo;

    objAH.sendToServer();
}

function updateAyudaParaCampo(responseText){
    $('#ayudaMARC').html(responseText);
    $('#ayudaMARC').modal('show');
}

function generarOpcionesParaSelect(array_options){
    var op;

    for(var i=0; i< array_options.length; i++){
        op = op + "<option value='" + array_options[i].clave + "'>" + array_options[i].valor + "</option>\n";
    }

    return op;
}

function crearSelectIndicadoresPrimarios(campo_marc_conf_obj, campo){
    var opciones_array  = campo_marc_conf_obj.getIndicadoresPrimarios();
    var indicadores     = "";

    if(opciones_array.length > 0){
        indicadores = "<select id='select_indicador_primario" + campo + "'>" + generarOpcionesParaSelect(opciones_array) + "</select>";
    }

    return indicadores;
}

function crearSelectIndicadoresSecundarios(campo_marc_conf_obj, campo){
    var opciones_array  = campo_marc_conf_obj.getIndicadoresSecundarios();
    var indicadores     = "";

    if(opciones_array.length > 0){
        indicadores = "<select id='select_indicador_secundario" + campo + "'>" + generarOpcionesParaSelect(opciones_array) + "</select>";
    }

    return indicadores;
}

/*
 * procesarSubCampo
 * procesa el objeto json, para poder crear el componente adecuado al tipo de datos que vienen en el objeto.
 * @params
 * objeto, elemento que contiene toda la info necesaria.
 * marc_group, id del marc_group, div que contiene el campo con sus subcampos
 */
function procesarSubCampo(objeto, marc_group){

    TAB_INDEX++;

    var marc_conf_obj       = new subcampo_marc_conf(objeto);
    var vista_intra         = marc_conf_obj.getVistaIntra();
    var tipo                = marc_conf_obj.getTipo();
    var comp;
    var divLabel;
    var strComp;
    var divComp             = crearDivComponente("div"+marc_conf_obj.getIdCompCliente());
    var tiene_estructura    = marc_conf_obj.getTieneEstructura(); //falta q los niveles 1, 2, 3 mantengan esta estructura
      
    var id_temp_content_div = "div_control"+marc_conf_obj.getIdCompCliente()
    var content_div_open    = "<div id='"+id_temp_content_div+"' class=control-group>";
    var content_div_close   = "</div>";
    var controls_div        = "<div class=controls>";
    

    if(marc_conf_obj.getObligatorio() == "1"){  
        vista_intra = vista_intra + "<b> * </b>";
    }

    if(marc_conf_obj.getTieneEstructura() == '0'){ 
        //no existe estructura de catalogacion configurada para este campo, subcampo
// TODO armar una funcion q genere esto
        vista_intra         = "<div class='divComponente' style='float:left'><input type='text' id='" + marc_conf_obj.getIdCompCliente() + "' value='" + marc_conf_obj.getDato() + "' size='55' disabled></div>";
//         vista_intra         = "<span class='label label-important' style='float:left; width:273px; height:15px;'>" + marc_conf_obj.getDato() + "</span>";
        vista_intra         = vista_intra + crearIconWarning(marc_conf_obj);
        vista_intra         = vista_intra + crearBotonEliminarSubcampo(marc_conf_obj);
        tiene_estructura    = 0;
        divLabel            = crearDivLabel(marc_conf_obj.getCampo() + '^' + marc_conf_obj.getSubCampo() + " - " + marc_conf_obj.getVistaIntra(), marc_conf_obj.getIdCompCliente());  
        strComp             = "<span id='LI" + marc_conf_obj.getIdCompCliente() + "'> " + content_div_open + divLabel + controls_div +  vista_intra + content_div_close  + content_div_close + "</span>";  
    } else {
        vista_intra         =  marc_conf_obj.getCampo() + '^' + marc_conf_obj.getSubCampo() + " - " + vista_intra
        divLabel            = crearDivLabel(vista_intra, marc_conf_obj.getIdCompCliente());
        strComp             = "<span id='LI" + marc_conf_obj.getIdCompCliente() + "'> " + content_div_open + divLabel + controls_div + divComp + content_div_close + content_div_close + "</span>";    
    }
    
    $("#" + marc_group).append(strComp);

    if(tiene_estructura == 1){

        switch(tipo){
            case "text":
                crearText(marc_conf_obj);
            break;
            case "combo":
                crearCombo(marc_conf_obj);
            break;
            case "texta":
                crearTextArea(marc_conf_obj);
            break;
            case "auto": 
                crearAuto(marc_conf_obj);
            break;
/*            case "auto_nivel2": 
                crearAutoNivel2(marc_conf_obj);
            break;*/
            case "calendar":
                crearCalendar(marc_conf_obj);
            break;
            case "anio":
                crearTextAnio(marc_conf_obj);
            break;
            case "rango_anio":
                crearTextRangoAnio(marc_conf_obj);
            break;
        }
    
        //Se agregan clases para cuando tenga que recuperar los datos.
        if(objeto.obligatorio == "1"){
            hacerComponenteObligatoria(marc_conf_obj.getIdCompCliente());
            $("#"+id_temp_content_div).addClass('error');
        }

    }
}

var RULES_OPTIONS = [];
var alert_showed = false;


// TODO por ahora no lo uso, pero hay q ver si sirve para personalizar el texto a informar al usuario
function addRules(){
//     log("add rules ????????????????: ");
     for(var i=0; i< MARC_OBJECT_ARRAY.length; i++){
    //recorro los campos
        var subcampos_array = MARC_OBJECT_ARRAY[i].getSubCamposArray();
        for(var s=0; s< subcampos_array.length; s++){
        //recorro los subcampos
            if(subcampos_array[s].rules != ""){
                create_rules_object(subcampos_array[s].rules);
//                 log("remove rules val??: " + $('#'+subcampos_array[s].getIdCompCliente()).val() + " para el id " + subcampos_array[s].getIdCompCliente());
                try{
                    $('#'+subcampos_array[s].getIdCompCliente()).rules("remove");
    //                 log("rules: " + subcampos_array[s].rules + " para el id " + subcampos_array[s].getIdCompCliente());
                    $('#'+subcampos_array[s].getIdCompCliente()).rules("add", RULES_OPTIONS);
                }
                catch(e){
                    if (!alert_showed){
                        closeModal();
                        bootbox.dialog("Hubo un problema en la estructura del catalogo", {
                            "label" : "Aceptar",
                            "class" : "btn-warning",   // or primary, or danger, or nothing at all
                            "callback": function() {
                                alert_showed = true;
                            }
                        });
                        alert_showed = true;
                    }
                }
            }
        }
    }
}


function create_rules_object(rule){

    var rules_array = rule.split("|");    
    var rule_array;
    var clave;
    var valor;
    RULES_OPTIONS = [];

    for(i=0;i<rules_array.length;i++){
        rule_array = rules_array[i].split(":");

        clave = $.trim(rule_array[0]);
        valor = $.trim(rule_array[1]);

        switch (clave) { 
            case 'minlength': 
                RULES_OPTIONS.minlength             = valor;
                break;
            case 'maxlength': 
                RULES_OPTIONS.maxlength             = valor;
                break;
            case 'digits': 
                RULES_OPTIONS.digits                = valor;
                break;
            case 'lettersonly': 
                RULES_OPTIONS.lettersonly           = valor;
                break;
            case 'alphanumeric': 
                RULES_OPTIONS.alphanumeric          = valor;
                break;
            case 'alphanumeric_total': 
                RULES_OPTIONS.alphanumeric_total    = valor;
                break;
            case 'date': 
                RULES_OPTIONS.date                  = valor;
                break;
            case 'dateITA': 
                RULES_OPTIONS.dateITA               = valor;
                break;
            case 'solo_texto': 
                RULES_OPTIONS.solo_texto            = valor;
                break;
            case 'rango_anio': 
              
                RULES_OPTIONS.rango_anio            = valor;

                //se agrega un nuevo metodo para validar un rango de anios
                jQuery.validator.addMethod("rango_anio", function(value, element) { 
                    return this.optional(element) || /^([0-9]{4}-([0-9]{4})?)/.test(value); 
                }, "Ingrese un rango de años válido (1979-2000)");

                break;
        }
    }
}

// FIXME parece q no se usa mas!!!!!!!!!!!!!!!
function _cambiarIdDeAutocomplete(){
     for(var i=0; i< MARC_OBJECT_ARRAY.length; i++){
        //si es un autocomplete, guardo el ID del input hidden
        if(MARC_OBJECT_ARRAY[i].tipo == 'auto'){    
            //si es un autocomplete, el dato es un ID y se encuentra en el hidden
            MARC_OBJECT_ARRAY[i].idCompCliente= MARC_OBJECT_ARRAY[i].idCompCliente + '_hidden';
    // FIXME esto no esta funcionando, se pierde el id de la referencia
            $('#'+MARC_OBJECT_ARRAY[i].idCompCliente).val(MARC_OBJECT_ARRAY[i].datoReferencia);
        }
    }
}

//crea el Autocomplete segun lo indicado en el parametro "referenciaTabla"
function _cearAutocompleteParaCamponente(o){

    switch(o.getReferenciaTabla()){
        case "autor": CrearAutocompleteAutores(     {IdInput: o.getIdCompCliente(), 
                                                    IdInputHidden: o.getIdCompCliente() + '_hidden'}
                                    );
        break;
        case "pais": CrearAutocompletePaises(   {IdInput: o.getIdCompCliente(), 
                                                IdInputHidden: o.getIdCompCliente() + '_hidden' }
                                    );
        break;
        case "lenguaje": CrearAutocompleteLenguajes(    {IdInput: o.getIdCompCliente(), 
                                                        IdInputHidden: o.getIdCompCliente() + '_hidden' }
                                    );
        break;
        case "ciudad": CrearAutocompleteCiudades(   {IdInput: o.getIdCompCliente(), 
                                                    IdInputHidden: o.getIdCompCliente() + '_hidden' }
                                    );
        break;
        case "ui": CrearAutocompleteUI(             {IdInput: o.getIdCompCliente(), 
                                                    IdInputHidden: o.getIdCompCliente() + '_hidden' }
                                    );
        break;
        case "tema": CrearAutocompleteTemas(       {IdInput: o.getIdCompCliente(), 
                                                    IdInputHidden: o.getIdCompCliente() + '_hidden' }
                                    );
        break;
        case "editorial": CrearAutocompleteEditoriales(  {IdInput: o.getIdCompCliente(),   
                                                    IdInputHidden: o.getIdCompCliente() + '_hidden' }
                                    );
        break;        
        
// TODO estoy probando el link de las analiticas
        case "nivel2": CrearAutocompleteNivel2(       { IdInput: o.getIdCompCliente(), 
                                                        IdInputHidden: o.getIdCompCliente() + '_hidden',
                                                        callBackFunction: buscarDatosNivel2                      
                                                      }
                                    );
        break;
    }
}


function buscarDatosNivel2(){
        objAH                   = new AjaxHelper(updateBuscarDatosNivel2);
        objAH.debug             = true;
        objAH.showOverlay       = true;
        objAH.url               = URL_PREFIX+'/catalogacion/estructura/estructuraCataloDB.pl';
        objAH.tipoAccion        = 'BUSQUEDA_EDICIONES';
        objAH.id1               = $('#'+_getIdComponente('773', 'a')+'_hidden').val();
        objAH.sendToServer();
}

function updateBuscarDatosNivel2(responseText){
    var idComponenteCliente = _getIdComponente('773', 'a');
     
    $('#ediciones').html(responseText);
   
    $("#" + idComponenteCliente + "_hidden").val($('#edicion_id').val());
    
    //cambio el ID  
    $('#edicion_id').change(function() {
        $("#" + idComponenteCliente + "_hidden").val($('#edicion_id').val());
    });
}

function generarIdComponente(){
    return ID_COMPONENTE++;
}

function cloneSubCampo(id){
    var id_componente   = generarIdComponente();
    var subcampo_temp   = _getSubCampoMARC_conf_ById(id);
    var obj             = copy(subcampo_temp);        //se genera una copia del subcampo
    obj.setIdCompCliente( id_componente );            //seteo el nuevo id de la componente
    procesarSubCampo(obj, subcampo_temp.marc_group);  //se genera la componente en el cliente
    
    //agrego el subcampo en la poscion "posCampo" del arreglo MARC_OBJECT_ARRAY, donde se encuentra el campo contenedor
    MARC_OBJECT_ARRAY[subcampo_temp.posCampo].getSubCamposArray().push(obj);
}

//clona un campo 
//@params: marc_group_id es el marc_group del padre
function cloneCampo(marc_group_id){
    var id_componente   = generarIdComponente();
    var campo_temp      = _getCampoMARC_conf_ById(marc_group_id);
    var campo_obj       = copy(campo_temp);      //se genera una copia del campo

    //ahora cambio el id del campo
    campo_obj.setIdCompCliente(id_componente);  
    campo_obj.setFirst(false);
    //ahora cambio los id's de los subcampos
    var subcampos_array         = campo_temp.getSubCamposArray();
    var subcampos_array_destino = new Array();
    for(var i=0;i<subcampos_array.length;i++){
// TODO falta acomodar el posCampo que indica a los subcampos en q posicion esta el campo padre, esta FEOOOOO!!
        var subcampo_obj;
        subcampo_obj = copy(subcampos_array[i]);                //se genera una copia del subcampo
        subcampo_obj.setIdCompCliente(generarIdComponente());   //ahora cambio los id's de los subcampos
        subcampo_obj.posCampo = campo_temp.posCampo;
        subcampo_obj.setFirst(false);
        subcampos_array_destino.push(subcampo_obj);
    }

// FIXME no funciona!!!!!!
    
    campo_obj.subcampos_hash = copy(campo_obj.getSubCamposHash());
    campo_obj.setSubCamposArray(subcampos_array_destino);
    //alert("cloneCampo => getFirst => "+campo_obj.getFirst());
    //alert("getIdCompCliente => "+campo_obj.getIdCompCliente());
    
    var temp = new Array();
    temp.push(campo_obj);
    procesarInfoJson(temp, marc_group_id);   
 
}

function removeCampo(id){
    var campo_temp      = _getIndexCampoMARC_conf_ById(id);       //recupero el campo segun el id pasado por parametro
    var _from           = campo_temp;            //posicion del campo en el arreglo de subcampos
    var _to             = campo_temp;

    $('#'+id).remove();                                       //elimino la componete del cliente

    removeFromArray(MARC_OBJECT_ARRAY, _from, _to); //elimino la informacion del campo
}

function removeSubcampo(id){
    var subcampo_temp   = _getSubCampoMARC_conf_ById(id);       //recupero el subcampo segun el id pasado por parametro
    var _from           = _getPosBySubCampoMARC_conf_ById(id);  //posicion del subcampo en el arreglo de subcampos
    var _to             = _from;
    
    $('#LI'+id).remove();                                       //elimino la componete del cliente

    removeFromArray(MARC_OBJECT_ARRAY[subcampo_temp.posCampo].getSubCamposArray(), _from, _to); //elimino la informacion del subcampo
}


function openDivButtonContainer(id,tipo){
    
    var clase           = "btn btn-info ";
    var clase_dropdown  = "btn btn-info dropdown-toggle ";
    var title           = "Campo"
    if (tipo != 'campo'){
        clase = "btn ";
        clase_dropdown = "btn dropdown-toggle ";
        title           = "Subcampo";
    }
    
    var elem =  '<div class="btn-group" style="float: right; margin-left: 5px;" id="'+id+'">'+
                '<a class="'+clase+'"><i class="icon white user"></i> '+title+'</a>'+
                '<a class="'+clase_dropdown+'" data-toggle="dropdown" ><span class="caret"></span></a>'+
                '<ul class="dropdown-menu" id="'+id+"_lista"+'">'+'</ul></div>';
    
    return elem;
}

function closeDivButtonContainer(id){
    var elem =  '</ul></div>';
    
    return elem;
}

function crearBotonAgregarSubcampoRepetible(obj){

    if(obj.getRepetible() == '1'){
        return '<li><a class="click" onclick=cloneSubCampo("'+ obj.getIdCompCliente() +'")><i class="icon-plus"></i> Agregar</a></li>';
    }else{  
        return "";
    }
}

function crearBotonEliminarSubcampoRepetible(obj){

    if(obj.getRepetible() == '1'){
        return '<li><a class="click" onclick=removeSubcampo("'+ obj.getIdCompCliente() +'")><i class="icon-trash"></i> Eliminar</a></li>';
    }else{  
        return "";
    }
}

function crearBotonEliminarSubcampo(obj){
    return '<a class="click btn btn-danger" onclick=removeSubcampo("'+ obj.getIdCompCliente() +'")><i class="icon-trash"></i> Eliminar</a></li>';
}


function crearIconWarning(obj){

    return "<div style='float:left; margin-left:5px'><span class='label label-info'>Sin estructura</span></div>";
}

function crearBotonAgregarCampoRepetible(obj, id_padre){

    if(obj.getRepetible() == '1'){
        return "<li><a class='click' onclick=cloneCampo('"+ id_padre +"')><i class='icon-plus'></i> Agregar</a></li>";
    }else{  
        return "";
    }
}

function crearBotonEliminarCampoRepetible(obj, show){
    display = "none";
  
    if(!show){
        display = "block";
    }

// FIXME no esta funcionando bien, luego de clonar debería mostrarse igual

// display = "block";

    if(obj.getRepetible() == '1'){
        return '<li id="boton_eliminar_'+ obj.getIdCompCliente() +'" style= "display:' + display + '"><a class="click" onclick=removeCampo("'+ obj.getIdCompCliente() +'")><i class="icon-trash"></i> Eliminar</a></li>';
    }else{  
        return "";
    }
}

function campo_marc_conf(obj){

    this.nombre                     = obj.nombre;
    this.campo                      = obj.campo;
    this.idCompCliente              = obj.idCompCliente;
    this.ayuda_campo                = obj.ayuda_campo;
    this.descripcion_campo          = obj.descripcion_campo;
    this.subcampos_array            = obj.subcampos_array;
    this.repetible                  = obj.repetible;
    this.indicador_primario         = obj.indicador_primario;
    this.indicador_secundario       = obj.indicador_secundario;
    this.subcampos_array            = new Array();
    this.subcampos_hash             = new Object();
    this.indicadores_primarios      = obj.indicadores_primarios;
    this.indicadores_secundarios    = obj.indicadores_secundarios;
    this.indicador_primario_dato    = obj.indicador_primario_dato;
    this.indicador_secundario_dato  = obj.indicador_secundario_dato;
    this.first                      = true;


    for(var i = 0; i < obj.subcampos_array.length; i++){
        var subcampo_marc_conf_obj = new subcampo_marc_conf(obj.subcampos_array[i]);
        this.subcampos_array[i] = subcampo_marc_conf_obj;
    }

    function fGetIdCompCliente(){ return this.idCompCliente };
    function fSetIdCompCliente( id ){ this.idCompCliente = id };
    function fGetCampo(){                   return this.campo };
    function fGetNombre(){                  return this.nombre };
    function fGetAyudaCampo(){              return this.ayuda_campo };
    function fGetDescripcionCampo(){        return $.trim(this.descripcion_campo) };
    function fGetSubCamposArray(){          return this.subcampos_array };
    function fGetSubCamposHash(){           return this.subcampos_hash };
    function fSetSubCamposArray(array){ this.subcampos_array = array };
    function fGetRepetible(){               return (this.repetible) };
    function fGetIndicadorPrimario(){       return (this.indicador_primario) };
    function fGetIndicadorSecundario(){     return (this.indicador_secundario) };
    function fGetSubCamposArray(){          return (this.subcampos_array) };
    function fGetIndicadoresPrimarios(){    return (this.indicadores_primarios)};
    function fGetIndicadoresSecundarios(){  return (this.indicadores_secundarios)};
    function fGetIndicadorPrimarioDato(){   return ((this.indicador_primario_dato == undefined)?'#':this.indicador_primario_dato)};
    function fGetIndicadorSecundarioDato(){ return ((this.indicador_secundario_dato == undefined)?'#':this.indicador_secundario_dato)};
    function fGetFirst(){ return this.first}; 
    function fSetFirst(bool){ this.first = bool}; 
    

    //metodos
    this.getCampo                   = fGetCampo;
    this.getIdCompCliente           = fGetIdCompCliente;
    this.setIdCompCliente           = fSetIdCompCliente;
    this.getNombre                  = fGetNombre;
    this.getAyudaCampo              = fGetAyudaCampo;
    this.getDescripcionCampo        = fGetDescripcionCampo;
    this.getSubCamposArray          = fGetSubCamposArray;
    this.getRepetible               = fGetRepetible;
    this.getIndicadorPrimario       = fGetIndicadorPrimario;
    this.getIndicadorSecundario     = fGetIndicadorSecundario;
    this.getSubCamposArray          = fGetSubCamposArray;
    this.getSubCamposHash           = fGetSubCamposHash;
    this.setSubCamposArray          = fSetSubCamposArray;
    this.getIndicadoresPrimarios    = fGetIndicadoresPrimarios;
    this.getIndicadoresSecundarios  = fGetIndicadoresSecundarios;    
    this.getIndicadorPrimarioDato   = fGetIndicadorPrimarioDato;
    this.getIndicadorSecundarioDato = fGetIndicadorSecundarioDato;
    this.getFirst                   = fGetFirst;  
    this.setFirst                   = fSetFirst;

}

function subcampo_marc_conf(obj){
    this.liblibrarian           = obj.liblibrarian;
    this.itemtype               = obj.itemtype;
    this.campo                  = obj.campo;
    this.subcampo               = obj.subcampo;
    this.dato                   = obj.dato;
    this.nivel                  = obj.nivel;
    this.rules                  = obj.rules;
    this.tipo                   = obj.tipo;
    this.intranet_habilitado    = obj.intranet_habilitado;
    this.tiene_estructura       = obj.tiene_estructura;
    this.visible                = obj.visible;
    this.edicion_grupal         = obj.edicion_grupal;    
    this.repetible              = obj.repetible;
    this.referencia             = obj.referencia;
    this.obligatorio            = obj.obligatorio;
    this.datoReferencia         = obj.datoReferencia;
    this.idCompCliente          = obj.idCompCliente;
    this.referenciaTabla        = obj.referenciaTabla;
    this.opciones               = obj.opciones;
    this.defaultValue           = obj.defaultValue;
    this.default_value          = obj.default_value;  
    this.tiene_estructura       = obj.tiene_estructura;
    this.ayuda_campo            = obj.ayuda_campo;
    this.descripcion_subcampo   = obj.descripcion_subcampo;
    this.first                  = true; 

    function fGetIdCompCliente(){ return this.idCompCliente };
    function fSetIdCompCliente( id ){ this.idCompCliente = id };
    function fGetCampo(){ return this.campo };
    function fGetSubCampo(){ return this.subcampo };
    function fGetDato(){ return this.dato };
    function fSetDato(dato){ this.dato = dato };
    function fGetDatoReferencia(){ return $.trim(this.datoReferencia) };
    function fSetDatoReferencia(datoReferencia){ this.datoReferencia = datoReferencia };    
    function fGetTipo(){ return $.trim(this.tipo) };
    function fGetEdicionGrupal(){ return $.trim(this.edicion_grupal) };
    function fGetReferencia(){ return $.trim(this.referencia) };
    function fGetRepetible(){ return this.repetible };
    function fGetReferenciaTabla(){ return this.referenciaTabla };    
    function fGetOpciones(){ return this.opciones };
    function fGetDefaultValue(){ return this.default_value };
    function fGetTieneEstructura(){ return this.tiene_estructura };
    function fGetObligatorio(){ return this.obligatorio };
    function fGetVistaIntra(){ return $.trim(this.liblibrarian) };
    function fGetAyudaCampo(){ return $.trim(this.ayuda_campo) };
    function fGetDescripcionSubCampo(){ return $.trim(this.descripcion_subcampo) };
    function fGetFirst(){return this.first};
    function fSetFirst(bool){ this.first = bool };

    //metodos
    this.getIdCompCliente           = fGetIdCompCliente;
    this.setIdCompCliente           = fSetIdCompCliente;
    this.getCampo                   = fGetCampo;
    this.getSubCampo                = fGetSubCampo;
    this.getDato                    = fGetDato;
    this.setDato                    = fSetDato;
    this.getDatoReferencia          = fGetDatoReferencia;
    this.setDatoReferencia          = fSetDatoReferencia;            
    this.getTipo                    = fGetTipo;
    this.getRepetible               = fGetRepetible;
    this.getReferenciaTabla         = fGetReferenciaTabla;
    this.getReferencia              = fGetReferencia;
    this.getOpciones                = fGetOpciones;
    this.getDefaultValue            = fGetDefaultValue;
    this.getTieneEstructura         = fGetTieneEstructura;
    this.getObligatorio             = fGetObligatorio;
    this.getVistaIntra              = fGetVistaIntra;
    this.getEdicionGrupal           = fGetEdicionGrupal;  
    this.getAyudaCampo              = fGetAyudaCampo;
    this.getDescripcionSubCampo     = fGetDescripcionSubCampo;
    this.getFirst                   = fGetFirst;  
    this.setFirst                   = fSetFirst;
}


function crearText(obj){
    //     var comp = "<input class='input-xlarge' type='text' id='" + obj.getIdCompCliente() + "' value='" + obj.getDato() + "' size='55' tabindex="+TAB_INDEX+" name='" + obj.getIdCompCliente() + "' class='horizontal' >";
//    var dato = "";    
    if(obj.getDato() != null){
        dato = obj.getDato();    
    }
      
    //ticket #3984, se rompian los input con la comilla simple ('). por las dudas se agregó
    //las comillas dobles (") tambien
    dato = dato.replace(/'/g,"&#039");  
    dato = dato.replace(/\"/g,"&#034");  

    var comp = "<input class='input-xlarge' type='text' id='" + obj.getIdCompCliente() + "' value='" + dato + "' size='55' tabindex="+TAB_INDEX+" name='" + obj.getIdCompCliente() + "' class='horizontal' >";     
    $("#div" + obj.getIdCompCliente()).append(comp);
    
    crearBotones(obj);
}

function crearBotones(obj){
    if((obj.getRepetible() == '1')||(obj.getReferenciaTabla())){
        $(openDivButtonContainer("div_botones" + obj.getIdCompCliente())).insertAfter("#div" + obj.getIdCompCliente());
    }

    if((obj.getEdicionGrupal() == "0")&&(MODIFICAR == 1)&&(EDICION_N3_GRUPAL == 1)){  
        disableComponent(obj.getIdCompCliente());  
        $('#'+ obj.getIdCompCliente()).after("<p class='help-block'>No se permite edicion grupal</p>");
    } else {
        $("#div_botones" + obj.getIdCompCliente() + "_lista").append(crearBotonAgregarSubcampoRepetible(obj));
        $("#div_botones" + obj.getIdCompCliente() + "_lista").append(crearBotonEliminarSubcampoRepetible(obj));
        $("#div_botones" + obj.getIdCompCliente() + "_lista").append(crearBotonAgregarReferenciaSubcampo(obj));  
    }
}

function crearAyudaComponete(obj, ayuda_string){
    var html = "<p htmlfor='" + obj.getIdCompCliente() + "' class='help-block'>" + ayuda_string + "</p>";

    $(html).insertAfter("#"+obj.getIdCompCliente());
}

function newCombo(obj){
    var comp            = "<select id='" + obj.getIdCompCliente() + "' name='" + obj.getIdCompCliente() + "' tabindex="+TAB_INDEX+" class='horizontal'>";
    comp                = comp + "<option value=''>Elegir opci&oacute;n</option>\n";

    var op              = "";
    var defaultValue    = "";
    var opciones        = obj.getOpciones();
    var default_value   = obj.getDefaultValue();  

    for(var i=0; i< opciones.length; i++){
        if((obj.getDatoReferencia() == opciones[i].clave)||((default_value == opciones[i].clave)&&(MODIFICAR == 0))){
//         if((obj.getDatoReferencia() == opciones[i].clave)||((ID_TIPO_EJEMPLAR == opciones[i].clave)&&(MODIFICAR == 0))){
            op = op + "<option value='" + opciones[i].clave + "' selected=selected>" + opciones[i].valor + "</option>\n";
        } else {
            op = op + "<option value='" + opciones[i].clave + "' >" + opciones[i].valor + "</option>\n";  
        }
    }

    comp = comp + op + "</select>";
    
    return comp;
}


function crearCombo(obj){
    var comp = newCombo(obj);
    $("#div" + obj.getIdCompCliente()).append(comp);
    crearBotones(obj);
}

function crearTextArea(obj){
    var comp = "<textarea class='input-xlarge' id='" + obj.getIdCompCliente() + "' name='" + obj.getIdCompCliente() + "' rows='4' tabindex=" + TAB_INDEX + ">" + obj.getDato() + "</textarea>";

    //comp = comp + crearBotonAgregarSubcampoRepetible(obj);

    $("#div" + obj.getIdCompCliente()).append(comp);
// FIXME     y esto???
    $("#texta" + obj.getIdCompCliente()).val(obj.getDatoReferencia());
    crearBotones(obj);
}

function crearHidden(obj){
    return "<input type='hidden' id='" + obj.getIdCompCliente() + "_hidden' name='" + obj.getIdCompCliente() + "' value='" + obj.getDatoReferencia() + "'>";
}


function agregarTablaReferencias(tabla){
    objAH               = new AjaxHelper(updateAgregarTablaReferencias);
    objAH.showOverlay   = true;
    objAH.url           = URL_PREFIX+'/admin/referencias/referenciasDB.pl';
    objAH.accion        = "AGREGAR_REGISTRO";
    objAH.alias_tabla   = tabla;
    objAH.sendToServer();
}

function updateAgregarTablaReferencias(responseText){
	$('#basic-modal-content').addClass('bigModal');
    $('#basic-modal-content').html(responseText);
    $('#basic-modal-content').modal();

    crearEditor();
}

function crearEditor(){
    var loaderPath= "";
    loaderPath = '<img src="'+imagesForJS+'/loaders/loader_facebook.gif"'+'>'
    makeToggle('datos_tabla_div','trigger',null,false);
    onEnter('search_tabla',obtenerTablaFiltrada);
    $('.editable').editable(URL_PREFIX+'/admin/referencias/referenciasDB.pl', { 
            type      : 'text',
            cancel    : CANCELAR,
            submit    : OK,
            tooltip   : EDITABLE_MSG,
            placeholder: EDITABLE_MSG,
            style   : 'display: inline',
            submitdata : {token: "[% token %]", edit: '1'},
            indicator : loaderPath,

    });

// FIXXXXX arregla el tamaño de la tabla, FEOOOOOOOOOOOOO
    $('#tablaResult').attr('style', 'width: 100%');
}


function cambiarValorEnHidden(id){
  
    var valor = $('#edicion_id').val();
  
    $(id + "_hidden").val(valor);
}


// FIXME si el subcampo es repetible el boton se cae y queda abajo
function crearAuto(obj){
    var comp = "<input type='text' id='" + obj.getIdCompCliente() + "' name='"+ obj.getIdCompCliente() +"' value='" + obj.getDato() + "' size='55' tabindex="+TAB_INDEX+" class='horizontal' >";

    $("#div" + obj.getIdCompCliente()).append(comp);
    crearBotones(obj);
    _cearAutocompleteParaCamponente(obj);
    //se crea un input hidden para guardar el ID del elemento de la lista que se selecciono
    comp = crearHidden(obj);
    $(comp).insertAfter("#div" + obj.getIdCompCliente());

}

function crearBotonAgregarReferenciaSubcampo(obj){
    if (obj.getReferenciaTabla()) {
        return '<li><a class="click" onclick=agregarTablaReferencias("'+ obj.getReferenciaTabla() +'")><i class="icon-plus"></i> Agregar referencia al subcampo '+ obj.getSubCampo() + ' para el campo ' + obj.getCampo() +'</a></li>';
    } else {  
        return '';
    }
}

function crearCalendar(obj){
    var comp = "<input class='input-xlarge hasDatepicker' type='text' id='" + obj.getIdCompCliente() + "' name='" + obj.getIdCompCliente() + "' value='" + obj.getDato() + "'' tabindex="+TAB_INDEX+">";

    $("#div" + obj.getIdCompCliente()).append(comp);

    // crearDatePicker(obj.getIdCompCliente());
    crearBotones(obj);
    $("#div" + obj.getIdCompCliente()).datepicker();

}

function crearTextAnio(obj){
    var comp = "<input class='input-xlarge' type='text' id='" + obj.getIdCompCliente() + "' name='" + obj.getIdCompCliente() + "' value='" + obj.getDato() + "' size='10' tabindex="+TAB_INDEX+" class='horizontal'>";

    $("#div" + obj.getIdCompCliente()).append(comp);
    crearBotones(obj);
}

function crearTextRangoAnio(obj){
    var comp = "<input class='input-xlarge' type='text' id='" + obj.getIdCompCliente() + "' name='" + obj.getIdCompCliente() + "' value='" + obj.getDato() + "' size='10' tabindex="+TAB_INDEX+" class='horizontal'>";

    $("#div" + obj.getIdCompCliente()).append(comp);
    crearBotones(obj);
    crearAyudaComponete(obj, "un rango de años ej. (1979 - 2000)");
}

// Esta funcion convierte una componete segun idObj en obligatoria, agrega * a la derecha de la misma
function hacerComponenteObligatoria(idObj){
    $("#"+idObj).addClass("obligatorio");

    if(EDICION_N3_GRUPAL == 0){
        $("#"+idObj).addClass("required");
    }

    agregarAHash(HASH_MESSAGES, idObj, ESTE_CAMPO_NO_PUEDE_ESTAR_EN_BLANCO);
    
}

// Esta funcion crea un divComponente con un id segun parametro idObj
function crearDivComponente(idObj){
   return "<div id='"+idObj+"' class='divComponente' style='float: left;'></div>";
}

// Esta funcion crea un divLabel con un Label segun parametro
function crearDivLabel(label, idComp){
    return "<label class='control-label' for='"+ idComp +"'> " + label + " </label>";
}


/*
 * borrarN1
 * Elimina de la base de datos el documento con id1 igual al parametro que ingresa y todos los otros datos 
 * correspondiente a los otros niveles que hacen referencia al id1.
 */
function borrarN1(id1){
  
    bootbox.confirm(ESTA_SEGURO_QUE_DESEA_BORRARLO, function (confirmStatus){ 

          if(confirmStatus){
                objAH               = new AjaxHelper(updateBorrarN1);
                objAH.showOverlay   = true;
                objAH.debug         = true;
                objAH.url           = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
                objAH.id1           = id1;
                objAH.nivel         = 1; 
                objAH.itemtype      = $("#id_tipo_doc").val(); //creo q no es necesario
                objAH.tipoAccion    = "ELIMINAR_NIVEL";
                objAH.sendToServer();
            }
      
        }
    );
}

function updateBorrarN1(responseText){
    var info        = JSONstring.toObject(responseText);  
    //se borrar el nivel 1 y en cascada nivel 2 y 3 si esta permitido
    //se refresca la info   
    var Messages    = info.Message_arrayref;
    setMessages(Messages);

    if (! (hayError(Messages) ) ){
        inicializar();
        $("#detalleComun").html("");
        disableAlert();
        // FIXME no se si esta funcionand
        $('#ajax-indicator').modal({show:true, keyboard: false, backdrop: false,});
        window.location = "mainpage.pl";
    }
}

function borrarN2(id2){
      
    bootbox.confirm(ESTA_SEGURO_QUE_DESEA_BORRARLO, function (confirmStatus){ 

        if(confirmStatus){
            objAH                   = new AjaxHelper(updateBorrarN2);
            objAH.showOverlay       = true;
            objAH.debug             = true;
            objAH.url               = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
            objAH.id2               = id2;
            objAH.nivel             = 2;
            objAH.itemtype          = $("#id_tipo_doc").val();
            objAH.tipoAccion        = "ELIMINAR_NIVEL";
            objAH.sendToServer();
        }
     
    });
}

function updateBorrarN2(responseText){
    var info        = JSONstring.toObject(responseText);  
    var Messages    = info.Message_arrayref;
    setMessages(Messages);

    if (! (hayError(Messages) ) ){
        inicializar();

        refreshMeranPage();
    }
}

function borrarN3(id3){
      
    bootbox.confirm(ESTA_SEGURO_QUE_DESEA_BORRARLO, function (confirmStatus){     

        if(confirmStatus){
            objAH                   = new AjaxHelper(updateBorrarN3);
            objAH.showOverlay       = true;
            objAH.debug             = true;
            objAH.url               = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
            objAH.id3_array         = [id3];
            objAH.nivel             = 3;
            objAH.itemtype          = $("#id_tipo_doc").val();
            objAH.tipoAccion        = "ELIMINAR_NIVEL";
            objAH.sendToServer();
        }
    });
}

function updateBorrarN3(responseText){
    var info        = JSONstring.toObject(responseText);  
    var Messages    = info.Message_arrayref;
    setMessages(Messages);

    if (! (hayError(Messages) ) ){
        inicializar();
        mostrarEstructuraDelNivel3(TEMPLATE_ACTUAL);
        //acutalizo los datos de nivel 2
        mostrarInfoAltaNivel2(ID_N2);
        mostrarInfoAltaNivel3(ID_N2);
    }
}

function borrarEjemplaresN3(id2){

    var selectedItems = new Array();
    
    $('.icon_seleccionar:checked').each(function(){
        selectedItems.push($(this).val());
    });
    
    if (selectedItems.length == 0) {
            jAlert('Debe seleccionar al menos un ejemplar','Advertencia de catalogo');
    }else{      
    
        bootbox.confirm(ESTA_SEGURO_QUE_DESEA_BORRARLO, function (confirmStatus){   
            if(confirmStatus){
                objAH               = new AjaxHelper(updateBorrarEjemplaresN3);
                objAH.showOverlay   = true;
                ID_N2               = id2;
                objAH.debug         = true;
                objAH.url           = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
                var id3_array       = selectedItems;
                objAH.id3_array     = id3_array;
                objAH.nivel         = 3;
                objAH.itemtype      = $("#id_tipo_doc").val();
                objAH.tipoAccion    = "ELIMINAR_NIVEL";
                objAH.sendToServer();
            }
        });
    }
}

function updateBorrarEjemplaresN3(responseText){
    var info        = JSONstring.toObject(responseText);  
    var Messages    = info.Message_arrayref;
    setMessages(Messages);
    
    if (! (hayError(Messages) ) ){
//      inicializar();
//      mostrarEstructuraDelNivel3(TEMPLATE_ACTUAL);
//        mostrarInfoAltaNivel2(ID_N2);
//        mostrarInfoAltaNivel3(ID_N2);
        ejemplaresDelGrupo(ID_N2);
    }
}

function getTemplateString(template_actual){
    $('#tipo_nivel3_id').val(TEMPLATE_ACTUAL);
    return $('#tipo_nivel3_id option:selected').val(TEMPLATE_ACTUAL).html();
}

/*
 * modificarN1
 * Funcion que obtiene los datos ingresados en el nivel 1 para poder crear los componentes con los valores
 * guardados en la base de datos y poder modificarlos.
 */
function modificarN1(id1, template){
    scroll              = "N1";
    inicializar();
    $('#datos_del_leader').show();
  
    TEMPLATE_ACTUAL     = template;
    ID_N1               = id1;
    
// TODO falta agregar boton para modificar el template
    //_mostrarAccion("<h4>Modificando el registro (" + ID_N1 + ") con el esquema: " + $('#tipo_nivel3_id option:selected').html() + " (" + TEMPLATE_ACTUAL + ")</h4>" + crearBotonEsquema());
    _mostrarAccion("<h4>Modificando el registro (" + ID_N1 + ") con el esquema: " + getTemplateString(TEMPLATE_ACTUAL) + " (" + TEMPLATE_ACTUAL + ")</h4>" + crearBotonEsquema());
    
    objAH               = new AjaxHelper(updateModificarN1);
    objAH.url           = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
    objAH.showOverlay   = true;
    objAH.debug         = true;
    objAH.tipoAccion    = "MOSTRAR_ESTRUCTURA_DEL_NIVEL_CON_DATOS";
// FIXME esto es necesario???
    objAH.itemtype      = TEMPLATE_ACTUAL;
    objAH.id            = ID_N1;
    objAH.nivel         = 1;
    objAH.sendToServer();
}

function _mostrarAccion(mensaje){
    $('#estado_accion').html(mensaje);
    $('#estado_accion').show();
    
    $('.estado_accion').html(mensaje);
    $('.estado_accion').show();
}

function updateModificarN1(responseText){
    MODIFICAR       = 1;
    _NIVEL_ACTUAL   = 1;
    updateMostrarEstructuraDelNivel1(responseText);
}

function modificarN2(id2, template){
    inicializar();
    scroll              = "N2";
    ID_N2               = id2;
    ID_TIPO_EJEMPLAR    = template;
// TODO falta agregar boton para modificar el template
    _mostrarAccion("<h4>Modificando el edici&oacute;n (" + ID_N2 + ") con el esquema: " + getTemplateString(TEMPLATE_ACTUAL) + " (" + TEMPLATE_ACTUAL + ")</h4>" + crearBotonEsquema() + "&nbsp;&nbsp;&nbsp;&nbsp;" + crearBotonAgregarEjemplares(ID_N2,template));  
    objAH               = new AjaxHelper(updateModificarN2);
    objAH.url           = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
    objAH.showOverlay   = true;
    objAH.debug         = true;
    objAH.tipoAccion    = "MOSTRAR_ESTRUCTURA_DEL_NIVEL_CON_DATOS";
    objAH.id            = ID_N2;
    objAH.id_tipo_doc   = ID_TIPO_EJEMPLAR;
    objAH.nivel         = 2;
    objAH.sendToServer();
}

function updateModificarN2(responseText){
    MODIFICAR       = 1;
    _NIVEL_ACTUAL   = 2;
    updateMostrarEstructuraDelNivel2(responseText);
// fin prueba
}

function modificarN3(id3, template){
    inicializar();
    scroll              = "N3";
    ID_N3               = id3;  
    ID_TIPO_EJEMPLAR    = template;
// TODO falta agregar boton para modificar el template
    _mostrarAccion("<h4>Modificando el ejemplar (" + ID_N3 + ") con el esquema: " + getTemplateString(TEMPLATE_ACTUAL) + " (" + TEMPLATE_ACTUAL + ")</h4>" + crearBotonEsquema());  
    objAH               = new AjaxHelper(updateModificarN3);
    objAH.url           = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
    objAH.debug         = true;
    objAH.showOverlay   = true;
    objAH.tipoAccion    = "MOSTRAR_ESTRUCTURA_DEL_NIVEL_CON_DATOS";
    objAH.id3           = ID_N3;
    ID3_ARRAY[0]        = ID_N3;
    objAH.nivel         = 3;
    objAH.sendToServer();
}

function updateModificarN3(responseText){
    MODIFICAR       = 1;
    _NIVEL_ACTUAL   = 3;
    $('#divCantEjemplares').hide(); 
    updateMostrarEstructuraDelNivel3(responseText);
}

/*
Esta funcion modifica 1 a n Ejemplares, los ID_N3 se encuentran en ID3_ARRAY
se toma el 1er elemento del arreglo ID3_ARRAY como Ejemplar a modificar, ya
que se puede haber seleccionado por ej. 3 ejemplares distintos, luego se envia
lo modificado al servidor y a los 3 ID_N3 se les modifica esta informacion 
*/
function modificarEjemplaresN3(){

    if(seleccionoAlgo("checkEjemplares")){
        //si selecciono los ejemplares para editar....
        inicializar();
        objAH               = new AjaxHelper(updateModificarEjemplaresN3);
        objAH.url           = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
        objAH.debug         = true;
        objAH.showOverlay   = true;
        objAH.tipoAccion    = "MOSTRAR_ESTRUCTURA_DEL_NIVEL_CON_DATOS";
        objAH.itemtype      = $("#id_tipo_doc").val();
        //obtengo todos los ejemplares seleccionados para modificarf
        ID3_ARRAY           = recuperarSeleccionados("checkEjemplares");
        objAH.id3           = ID3_ARRAY[0]; //muestra la info del primer ejemplar en el arreglo de ejemplares
        objAH.nivel         = 3;
        EDICION_N3_GRUPAL   = 1;  
        objAH.sendToServer();
    }
}

function modificarEjemplaresN3FromRegistro(id1){

    if(ID3_ARRAY.length > 0){
        
        inicializar();
        ID_N1               = id1;
        objAH               = new AjaxHelper(updateModificarEjemplaresN3);
        objAH.url           = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
        objAH.debug         = true;
        objAH.showOverlay   = true;
        objAH.tipoAccion    = "MOSTRAR_ESTRUCTURA_DEL_NIVEL_CON_DATOS";
        objAH.itemtype      = $("#id_tipo_doc").val();
        objAH.id3           = ID3_ARRAY[0]; //muestra la info del primer ejemplar en el arreglo de ejemplares
        objAH.nivel         = 3;
        EDICION_N3_GRUPAL   = 1;  
        objAH.sendToServer();
    }
}

function updateModificarEjemplaresN3(responseText){
    MODIFICAR = 1;
    $('#divCantEjemplares').hide(); 
    mostrarEstructuraDelNivel3(TEMPLATE_ACTUAL);  
}

/*
 * borrarGrupo
 * Elimina de la base de datos el grupo correspodiente a los parametros que ingresan, y los ejemplares que hay en 
 * ese grupo.
 */
function borrarGrupo(id1,id2){  
    objAH               = new AjaxHelper(updateBorrarGrupo);
    objAH.showOverlay       = true;
    objAH.debug         = true;
    objAH.url           = URL_PREFIX+"/catalogacion/estructura/estructuraCataloDB.pl";
    objAH.id2           = id2;
    objAH.nivel         = 2;
    objAH.itemtype      = $("#id_tipo_doc").val();
    objAH.tipoAccion    = "ELIMINAR_NIVEL";
    objAH.sendToServer();
}

function updateBorrarGrupo(){
// TODO
}

/*
Esta funcion es usada cuando se quiere editar N1, N2 o N3 desde otra ventana, se redirecciona aqui
*/
function cargarNivel1(params, TEMPLATE_ACTUAL){
/*
    params.id1
    params.id2
    params.id3
    params.tipoAccion= ('MODIFICAR_NIVEL_1'|'MODIFICAR_NIVEL_2'|'MODIFICAR_NIVEL_3') por defecto 'MODIFICAR_NIVEL_1'
*/
    ID_N1   = params.id1;
    ID_N2   = params.id2;

    if(params.tipoAccion == 'MODIFICAR_NIVEL_2'){
// FIXME falta template
        modificarN2(params.id2, TEMPLATE_ACTUAL);
        // mostrarInfoAltaNivel2(params.id2, TEMPLATE_ACTUAL); 
        getNivel2(params.id2);
    } else   
    if(params.tipoAccion == 'MODIFICAR_NIVEL_3'){
// FIXME falta template
        modificarN3(params.id3, TEMPLATE_ACTUAL);
        mostrarInfoAltaNivel3(params.id2, TEMPLATE_ACTUAL);  
    } else {
// FIXME falta template
        //por defecto se carga el Nivel 1 para modificar
        modificarN1(params.id1, TEMPLATE_ACTUAL);
        mostrarInfoAltaNivel1(params.id1, TEMPLATE_ACTUAL);
    }

// No quieren q se muestre mas el resto de los divs, ya q redirecciona SIEMPRE
    // mostrarInfoAltaNivel1(params.id1, TEMPLATE_ACTUAL);
    // mostrarInfoAltaNivel2(params.id2, TEMPLATE_ACTUAL); 
    // mostrarInfoAltaNivel3(params.id2, TEMPLATE_ACTUAL);  
}

function validateForm(formID, func){

     //if (!Modernizr.input.required) // DO SOME STUFF}
    
    //se setea el handler para el error
    $.validator.setDefaults({
        submitHandler:  func ,
    });

    var _message= LLENE_EL_CAMPO;

    $().ready(function() {
        $("#"+formID).validate({
                errorElement: "span",
                errorClass: "alert alert-error block",
    //             rules: HASH_RULES,
                messages: HASH_MESSAGES,
        })}
    );


    $("#"+formID).validate();
}

function addRegistroAlindice(id1){
    objAH=new AjaxHelper(updateInfoActualizar);
    objAH.url           = URL_PREFIX+'/reports/catalogoDB.pl';
    objAH.tipoAccion    =  "ADD_REGISTRO_AL_INDICE";
    objAH.debug= true;
    objAH.showOverlay = true;
    var array_temp = new Array();
    array_temp[0] = id1;
    objAH.array_id1= array_temp;
    objAH.funcion= "changePage";
    objAH.sendToServer();
}

function updateInfoActualizar(responseText){

    var Messages=JSONstring.toObject(responseText);
    setMessages(Messages);
    setTimeout(refreshMeranPage,5000);
    
}
