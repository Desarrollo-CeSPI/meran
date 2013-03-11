var objAH;
//arreglo de objetos campo
CAMPOS_ARRAY= new Array();
//arreglo de objetos subcampo
SUBCAMPOS_ARRAY= new Array();

/*
 * Exporta la visualizacion a un XML
*/
function exportarVisualizacion(){

    bootbox.confirm(EXPORTACION_VISUALIZACION, function (ok){ 

        if(ok){
            $('#formExportarVisualizacion').submit();
        }

    });
}

/*
 * Importa la visualizacion desde un XML
*/
function showImportarVisualizacion(){

    $('#importarVisualizacion').modal();
}

/*
 * Hace el submit del form para importar
*/
function realizarImportacion(){

    if ($('#fileImported').val() != ""){

        $('#importarVisualizacion').modal('hide');
        startOverlay();
        $('#formImportarVisualizacion').submit();

    }
}


function eliminarVista(vista_id){

    objAH               = new AjaxHelper(updateAgregarVisualizacion);
    objAH.showOverlay       = true;
    objAH.debug         = true;
    objAH.url           = URL_PREFIX+"/catalogacion/visualizacionINTRA/visualizacionIntraDB.pl";
    objAH.tipoAccion    = 'ELIMINAR_VISUALIZACION';
    objAH.showOverlay   = true;
    
    if ( vista_id ){
        bootbox.confirm(ESTA_SEGURO_QUE_DESEA_BORRARLO, function(confirmStatus){
            if (confirmStatus){
                objAH.vista_id= vista_id;
                objAH.sendToServer();
            }
        });
    }

}

function agregarVisualizacion(){

    $('#add_vista_intra').modal('hide');
    objAH               = new AjaxHelper(updateAgregarVisualizacion);
    objAH.debug         = true;
    objAH.showOverlay   = true;
    objAH.url           = URL_PREFIX+"/catalogacion/visualizacionINTRA/visualizacionIntraDB.pl";
    objAH.tipoAccion    = 'AGREGAR_VISUALIZACION';
    var ejemplar        = $("#tipo_nivel3_id").val();
    var nivel           = $("#eleccion_nivel").val();
    var campo           = $.trim($("#campo").val());
    var subcampo        = $.trim($("#subcampo").val());
    var liblibrarian    = $.trim($("#liblibrarian").val());
    var pre             = $.trim($("#pre").val());
    var post            = $.trim($("#post").val());
    
    if ( (ejemplar) && (campo) && (subcampo) && (liblibrarian) ){
        objAH.ejemplar      = ejemplar;
        objAH.nivel         = nivel;
        objAH.campo         = campo;
        objAH.subcampo      = subcampo;
        objAH.liblibrarian  = liblibrarian;
        objAH.pre           = pre;
        objAH.post          = post;
        objAH.sendToServer();
    }else{
        jAlert(SELECCIONE_VISTA_INTRA);
    }
    
}

function updateAgregarVisualizacion(responseText){

    var Messages        = JSONstring.toObject(responseText);
    
    setMessages(Messages);
    if (! (hayError(Messages) ) ){
        eleccionDeEjemplar(); 
        $("#tablaResultSubCampos").html("");
    }  
}

//no se justifica armar algo por tipo de documento ya q es el único que tiene este comportamiento
function agregar_quitar_nivel3(){
        if($("#tipo_nivel3_id").val() == "ANA"){
            //saco el nivel 3
            $("#eleccion_nivel option[value='3']").remove();
        } else {
            //agrego el nivel 3 si no existe
            var result = $('#eleccion_nivel').find('option[value="3"]');
            if(result.length == 0){
                $("#eleccion_nivel").append('<option value="3">Nivel 3</option>');
            }
        }
}

function eleccionDeEjemplar(){
    var ejemplar    = $("#tipo_nivel3_id").val();
    var ObjDiv      = $("#result");
    if (!isNaN(ejemplar)){
        ObjDiv.hide();
    }else{

        agregar_quitar_nivel3();

        ObjDiv.show();
        objAH               = new AjaxHelper(updateEleccionDeNivel);
        objAH.debug         = true;
        objAH.showOverlay   = true;  
        objAH.url           = URL_PREFIX+"/catalogacion/visualizacionINTRA/visualizacionIntraDB.pl";
        objAH.tipoAccion    = 'MOSTRAR_VISUALIZACION';
        objAH.ejemplar      = ejemplar;

        objAH.sendToServer();
    }
}

function updateEleccionDeNivel(responseText){
    $("#result").html(responseText);
    scrollTo("result");
}



/*
 * eleccionCampoX
 * Funcion que se ejecuta cuando se selecciona un valor del combo campoX (ej. 1xx), y hace un llamado a la 
 * funcion que ejecuta el ajax, con los parametros correspondiente a la accion realizada.
 */
function eleccionCampoX(){
    if ( $("#campoX").val() != -1){
        objAH               = new AjaxHelper(updateEleccionCampoX);
        objAH.debug         = true;
        objAH.showOverlay   = true;  
        objAH.url           = URL_PREFIX+"/catalogacion/visualizacionINTRA/visualizacionIntraDB.pl";
        objAH.campoX        = $('#campoX').val();
        objAH.tipoAccion    = "GENERAR_ARREGLO_CAMPOS";
        objAH.sendToServer();
    }
    else
        enable_disableSelects();
}

//se genera el combo en el cliente
function updateEleccionCampoX(responseText){
    //Arreglo de Objetos Global
    var campos_array = JSONstring.toObject(responseText);
    //se inicializa el combo
    $("#campo").html('');
    var options = "<option value='-1'>Seleccionar CampoX</option>";
    
    for (var x=0;x < campos_array.length;x++){
         CAMPOS_ARRAY[campos_array[x].campo]= $.trim(campos_array[x].liblibrarian);   
         options+= "<option value=" + campos_array[x].campo +" >" + campos_array[x].campo + "</option>";
    }
    $("#campo").append(options);
    //se agrega la info al combo
    enable_disableSelects();

}


function eleccionCampo(){
    if ($("#campo").val() != -1){
        objAH               = new AjaxHelper(updateEleccionCampo);
        objAH.debug         = true;
        objAH.showOverlay   = true;
        objAH.url           = URL_PREFIX+"/catalogacion/visualizacionINTRA/visualizacionIntraDB.pl";
        objAH.campo         = $('#campo').val();
        objAH.tipoAccion    = "GENERAR_ARREGLO_SUBCAMPOS";
        objAH.sendToServer();
    }
    else
        enable_disableSelects();

}

//se genera el combo en el cliente
function updateEleccionCampo(responseText){
    $('#nombre_campo').html(CAMPOS_ARRAY[$("#campo").val()]);
    //Arreglo de Objetos Global
    var subcampos_array=JSONstring.toObject(responseText);
    //se inicializa el combo
    $("#subcampo").html('');
    $("#liblibrarian").val('');
    $("#liblibrarian_esquema").html('');
    var options = "<option value='-1'>Seleccionar SubCampo</option>";
//     var subcampo = new Object;    
//     subcampo.liblibrarian = '';
//     subcampo.obligatorio = '';
    
    for (x=0;x < subcampos_array.length;x++){
//             SUBCAMPOS_ARRAY[ subcampos_array[x].tagsubfield ]= $.trim(subcampos_array[x].liblibrarian);
        var subcampo = new Object;    
        subcampo.liblibrarian = '';
        subcampo.obligatorio = '';
        subcampo.liblibrarian =  $.trim(subcampos_array[x].liblibrarian);
        subcampo.obligatorio = $.trim(subcampos_array[x].obligatorio); 
        SUBCAMPOS_ARRAY[ subcampos_array[x].subcampo ]= subcampo;
//             SUBCAMPOS_ARRAY[ subcampos_array[x].tagsubfield ]= $.trim(subcampos_array[x].obligatorio); 

        options+= "<option value=" + subcampos_array[x].subcampo +" >" + subcampos_array[x].subcampo + "</option>";
    }
    //se agrega la info al combo
    $("#subcampo").append(options);
    enable_disableSelects();
}


function enable_disableSelects(){
    $("#campo").removeAttr('disabled');
    $("#subcampo").removeAttr('disabled');
    $("#tablaRef").removeAttr('disabled');
    $("#tipoInput").removeAttr('disabled');
    $("#divCamposRef").show();
    if ( $('#campoX').val() == -1){
         $("#campo").attr('disabled',true);
         $("#subcampo").attr('disabled',true);
         $("#tablaRef").attr('disabled',true);
         $("#tipoInput").attr('disabled',true);
         $("#divCamposRef").hide();
    }
    else
      if ( $('#campo').val() == -1){
         $("#subcampo").attr('disabled',true);
         $("#tablaRef").attr('disabled',true);
         $("#tipoInput").attr('disabled',true);
         $("#divCamposRef").hide();
      }
    else
       if ( $('#subcampo').val() == -1){
         $("#tablaRef").attr('disabled',true);
         $("#tipoInput").attr('disabled',true);
         $("#divCamposRef").hide();
        }
    else
      if ( $('#tablaRef').val() == -1){
//          $("#tipoInput").attr('disabled',true);
         $("#divCamposRef").hide();
       }
}

function eleccionSubCampo(){

    if ($('#subcampo').val() != -1){
        $('#liblibrarian').val(SUBCAMPOS_ARRAY[$('#subcampo').val()].liblibrarian);
//         mostrarTablaRef();
    }
    else 
        enable_disableSelects();
}

function mostrarTablaRef(){
    objAH=new AjaxHelper(updateMostrarTablaRef);
    objAH.showOverlay       = true;
    objAH.debug= true;
    objAH.url=URL_PREFIX+"/utils/utilsDB.pl";
    objAH.tipoAccion="GENERAR_ARREGLO_TABLA_REF";
    objAH.sendToServer();
}


function mostrarTabla(){
    objAH               = new AjaxHelper(updateMostrarTabla);
    objAH.debug         = true;
    objAH.showOverlay   = true;  
    objAH.url           = URL_PREFIX+"/catalogacion/visualizacionINTRA/visualizacionIntraDB.pl";
    objAH.tipoAccion    = 'MOSTRAR_TABLA_CAMPO';
    objAH.ejemplar      = $("#tipo_nivel3_id").val();
    objAH.nivel         = $("#eleccion_nivel").val();
    objAH.sendToServer();
}

function updateMostrarTabla(responseText){
    $("#tablaResultCampos").html(responseText);
    scrollTo("tablaResultCampos");  
}

var campo;

function editSubcampos(campo_parametro){
    campo               = campo_parametro;
    objAH               = new AjaxHelper(updateEditSubcampos);
    objAH.debug         = true;
    objAH.showOverlay   = true;  
    objAH.url           = URL_PREFIX+"/catalogacion/visualizacionINTRA/visualizacionIntraDB.pl";
    objAH.tipoAccion    = 'MOSTRAR_TABLA_VISUALIZACION';
    objAH.campo         = campo
    objAH.nivel         = $("#eleccion_nivel").val();
    objAH.template      = $("#tipo_nivel3_id").val();;
    objAH.sendToServer();
}

function updateEditSubcampos(responseText){
    $("#tablaResultSubCampos").html(responseText);
    scrollTo("tablaResultSubCampos");  
}

function actualizarOrdenSubCampos(){
    objAH               = new AjaxHelper(updateSortableSC);
    objAH.debug         = true;
    objAH.url           = URL_PREFIX+"/catalogacion/visualizacionINTRA/visualizacionIntraDB.pl";
    objAH.showOverlay   = true;
    objAH.tipoAccion    = "ACTUALIZAR_ORDEN_SUBCAMPOS";
    objAH.newOrderArray = $('#sortable_subcampo').sortable('toArray');
    objAH.sendToServer(); 
}

function updateSortableSC(){
    editSubcampos(campo);        
}

function actualizarOrdenCampo(){
    objAH               = new AjaxHelper(updateSortable);
    objAH.debug         = true;
    objAH.url           = URL_PREFIX+"/catalogacion/visualizacionINTRA/visualizacionIntraDB.pl";
    objAH.showOverlay   = true;
    objAH.tipoAccion    = "ACTUALIZAR_ORDEN_AGRUPANDO";
    objAH.newOrderArray = $('#sortable').sortable('toArray');
    objAH.sendToServer(); 
}

function updateSortable(){
    mostrarTabla();        
}

function eliminarTodoElCampo(campo){
    objAH               = new AjaxHelper(updateEliminarTodoCampo);
    objAH.debug         = true;
    objAH.showOverlay   = true;  
    objAH.url           = URL_PREFIX+"/catalogacion/visualizacionINTRA/visualizacionIntraDB.pl";
    objAH.tipoAccion    = 'ELIMINAR_TODO_EL_CAMPO';
    objAH.nivel         = $("#eleccion_nivel").val();
    objAH.ejemplar      = $("#tipo_nivel3_id").val();
    
    if (campo){
        bootbox.confirm(SEGURO_QUE_DESEA_ELIMINAR_TODO_EL_CAMPO, function(confirmStatus){
            if (confirmStatus){
                objAH.campo         = campo;
                objAH.sendToServer();
            }
        });
    }
}

function updateEliminarTodoCampo(responseText){
    var Messages        = JSONstring.toObject(responseText);
    setMessages(Messages);
    mostrarTabla();
    eleccionDeEjemplar();
}

function showAddVistaINTRA(){
	$('#add_vista_intra').modal();
}


function hideAddVistaINTRA(){
    $('#add_vista_intra').modal('hide');
}
