
var esquema_orden_actual = 0;
var esquema_padre		 = 0;


function nuevoEsquemaImportacion(title){

	objAH               = new AjaxHelper(updateNuevoEsquemaImportacion);
    objAH.url           = URL_PREFIX+'/herramientas/importacion/esquemas_importacionDB.pl';
    objAH.cache         = false;
    objAH.showOverlay   = true;  
    objAH.accion        = "NUEVO_ESQUEMA";
    objAH.esquema_title = title;
    objAH.sendToServer();	
}

function updateNuevoEsquemaImportacion(responseText){
    $('#esquema_result').html(responseText);
    scrollTo('esquema_result');
}

function showEsquemaImportacion(id_esquema){

    var id = id_esquema;

	worker.onmessage = function(event) {showEsquemaImportacion_func(id); };
	worker.postMessage('data');
}


function showEsquemaImportacion_func(id_esquema){
	
    var final_id;

    if (id_esquema)
        final_id = id_esquema;
    else
        final_id = $('#esquemaImportacion').val();

    objAH               = new AjaxHelper(updateShowEsquemaImportacion);
    objAH.url           = URL_PREFIX+'/herramientas/importacion/esquemas_importacionDB.pl';
    objAH.cache         = false;
    objAH.showOverlay   = true;  
    objAH.esquema	 	= final_id;
    objAH.accion        = "OBTENER_ESQUEMA";
    objAH.funcion		= 'changePage';
    objAH.filtro		= $('#campo_search').val();
    esquema_padre		= $('#esquemaImportacion').val();
    
    objAH.sendToServer();	
}

function updateShowEsquemaImportacion(responseText){
    $('#esquema_result').html(responseText);
    scrollTo('esquema_result');
}

function agregarCampo(id_esquema){
    objAH=new AjaxHelper(updateAgregarCampo);
    objAH.url           = URL_PREFIX+'/herramientas/importacion/esquemas_importacionDB.pl';
    objAH.cache = false;
    objAH.showOverlay       = true;
    objAH.accion="AGREGAR_CAMPO";
    objAH.esquema = id_esquema;
    
    objAH.sendToServer();
}


function updateAgregarCampo(responseText){

    $('#esquema_result').html(responseText);
}

function eliminarEsquemaRow(id_esquema){

    objAH=new AjaxHelper(updateAgregarCampo);
    objAH.url           = URL_PREFIX+'/herramientas/importacion/esquemas_importacionDB.pl';
    objAH.cache = false;
    objAH.showOverlay       = true;
    objAH.accion="ELIMINAR_CAMPO";
    objAH.id_row = id_esquema;
    
    objAH.sendToServer();
    
}

function eliminarEsquemaRowOne(id_esquema){

    objAH=new AjaxHelper(updateSortableSC);
    objAH.url           = URL_PREFIX+'/herramientas/importacion/esquemas_importacionDB.pl';
    objAH.cache 		= false;
    objAH.showOverlay   = true;
    objAH.accion		="ELIMINAR_CAMPO_ONE";
    objAH.id_row 		= id_esquema;
    
    objAH.sendToServer();
    
}

function eliminarEsquema(id_esquema){

    objAH=new AjaxHelper(updateAgregarCampo);
    objAH.url           = URL_PREFIX+'/herramientas/importacion/esquemas_importacionDB.pl';
    objAH.cache 		= false;
    objAH.showOverlay   = true;
    objAH.accion		="ELIMINAR_ESQUEMA";
    objAH.id_esquema 	= id_esquema;
    
    objAH.sendToServer();
    
}

/* FUNCIONES PARA AGREGAR UN NUEVO MAPPEO DE CAMPOS */


function agregarCampoAEsquema(id_esquema){
    objAH=new AjaxHelper(updateAgregarCampoAEsquema);
    objAH.url           = URL_PREFIX+'/herramientas/importacion/esquemas_importacionDB.pl';
    objAH.cache = false;
    objAH.showOverlay       = true;
    objAH.accion="MOSTRAR_AGREGAR_CAMPO_A_ESQUEMA";
    objAH.esquema = id_esquema;
    
    objAH.sendToServer();
}


function updateAgregarCampoAEsquema(responseText){

    $('#add_campo_esquema_result').html(responseText);
    scrollTo('add_campo_esquema_result');
}

function agregarCampoEsquema(id_esquema){

    objAH               = new AjaxHelper(updateAgregarCampoEsquema);
    objAH.debug         = true;
    objAH.showOverlay   = true;
    objAH.url           = URL_PREFIX+'/herramientas/importacion/esquemas_importacionDB.pl';
    objAH.accion    	= 'AGREGAR_CAMPO_A_ESQUEMA';
    var campo           = $.trim($("#campo").val());
    var subcampo        = $.trim($("#subcampo").val());
    var separador    	= $.trim($("#separador").val());
    if ( (campo) && (subcampo) ){
        objAH.campo         = campo;
        objAH.subcampo      = subcampo;
        objAH.separador  	= separador;
        objAH.id_esquema 	= id_esquema;
        
        objAH.sendToServer();
    }else{
        jAlert(SELECCIONE_VISTA_INTRA,CATALOGO_ALERT_TITLE);
    }
    
}

function updateAgregarCampoEsquema(responseText){

    var Messages        = JSONstring.toObject(responseText);
    
    setMessages(Messages);
    if (! (hayError(Messages) ) ){
        $("#add_campo_esquema_result").html("");
        updateSortableSC();
    }  
}

function editarOrdenEsquema(id_esquema){
	worker.onmessage = function(event) {editarOrdenEsquema_func(id_esquema); };
	worker.postMessage('data');
}

function editarOrdenEsquema_func(id_esquema){
    objAH               = new AjaxHelper(updateEditarOrdenEsquema);
    objAH.debug         = true;
    objAH.showOverlay   = true;  
    objAH.url           = URL_PREFIX+'/herramientas/importacion/esquemas_importacionDB.pl';
    objAH.accion    	= 'MOSTRAR_TABLA_ORDEN_ESQUEMA';
    objAH.id_esquema	= id_esquema;
    
    esquema_orden_actual = id_esquema;
    
    objAH.sendToServer();
}

function updateEditarOrdenEsquema(responseText){
    $("#tablaResultSubCampos").html(responseText);
    scrollTo('tablaResultSubCampos');
    $('tr').removeClass('highlightedRow');
    $('#esquema_'+esquema_orden_actual).addClass('highlightedRow');
    
    
}

function actualizarOrdenSubCampos(object_array){
    objAH               = new AjaxHelper(updateSortableSC);
    objAH.debug         = true;
    objAH.url           = URL_PREFIX+'/herramientas/importacion/esquemas_importacionDB.pl';
    objAH.showOverlay   = true;
    objAH.accion    	= "ACTUALIZAR_ORDEN_ESQUEMA";
    objAH.newOrderArray = object_array;
    objAH.id_esquema	= esquema_padre;
    objAH.sendToServer(); 
}

function updateSortableSC(){
	editarOrdenEsquema(esquema_orden_actual);    
}

function eleccionSubCampoEsquema(){

    if ($('#subcampo').val() != -1){
        $('#liblibrarian_esquema').html(SUBCAMPOS_ARRAY[$('#subcampo').val()].liblibrarian);
//         mostrarTablaRef();
    }
    else 
        enable_disableSelects();
}


