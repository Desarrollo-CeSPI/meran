/*
 * LIBRERIA generatePedidoCotizacion v 0.0.9
 * Esta es una libreria creada para el sistema KOHA
 * Contendran las funciones para la generacion de pedidos de cotizacion
 * Fecha de creacion 07/02/2011
 *
 */ 


/******************************************************** PEDIDO COTIZACION **************************************************/

var arreglo                  = new Array() //global, arreglo con las recomendaciones seleccionadas
var array_cantidades         = new Array() //global, arreglo cantidades de ejemplares de las recomendaciones
var array_recomendaciones    = new Array() //global, arreglo de ids de recomendaciones_detalle

function getRecomendacionesSelected(){
    var i = 0
    $('.activo').each(function(){ 
        if($(this).attr('checked') == true){
            $(this).attr('name') // activo1 , activo2 , etc 
            var pos = $(this).attr('name').charAt(6)
            array_recomendaciones[i] = $('#id_recomendacion_detalle'+pos).val()
            i++
        }
    })  
    return array_recomendaciones
}

function getCantidades(array_ids){
    var id
    for(i = 0; i < array_ids.length; i++){
        id = array_ids[i]
        array_cantidades[i] = $('#cantidad'+id).val()
    }
    return array_cantidades
}

function getTemplateAddPedidoCotizacion(){

    // traemos el template de busquedas de ejemplares para que se agreguen pedidos de cotizacion
    
    objAH                       = new AjaxHelper(updateGetTemplateAddPedidoCotizacion)
    objAH.url                   = URL_PREFIX+'/adquisiciones/pedidoCotizacionDB.pl'
    objAH.debug                 = true
    objAH.showOverlay           = true
 
    objAH.tipoAccion            = 'AGREGAR_PEDIDO_COTIZACION_DETALLE'
    objAH.sendToServer()  

}

function updateGetTemplateAddPedidoCotizacion(responseText){
    $('#pedido_cotizacion').html(responseText)
    $('#pedido_cotizacion').show()
}



function addPedidoCotizacion(){
    // agrega pedido de cotizacion a partir de las recomendaciones seleccionadas
    // nota: no es appendPedidoCotizacion que agrega pedidos_cotizacion nuevos desde la busqueda
    if(checkSeleccionados(true)){
        objAH                           = new AjaxHelper(updateAddPedidoCotizacion)
        objAH.url                       = URL_PREFIX+'/adquisiciones/pedidoCotizacionDB.pl'
        objAH.debug                     = true
        objAH.showOverlay               = true
        
        // se mandan los ids de las recomendacion_detalle SELECCIONADAS. 
        // Para agregar un pedido_cotizacion_detalle por c/u.
        // Tambien se mandan las cantidades que pueden ser nuevas.

        objAH.recomendaciones_array     = getRecomendacionesSelected()
        objAH.cantidades_array          = getCantidades(getRecomendacionesSelected())
          
        objAH.tipoAccion                = 'AGREGAR_PEDIDO_COTIZACION'
        objAH.sendToServer()  
    }   
}

function updateAddPedidoCotizacion(responseText){
    if (!verificarRespuesta(responseText))
            return(0);
    var Messages=JSONstring.toObject(responseText);
    setMessages(Messages);
    
    location.href = URL_PREFIX+'/adquisiciones/listPedidoCotizacion.pl'

}

/************************************************************ FIN - PEDIDO COTIZACION ******************************************/





/************************************************************ EXPORTACIONES  *********************************************/

function editar(){
    $('.editable').attr('disabled', false)
} 

function exportar(form_id){
    var proveedores = getProveedoresSelected()
    if(proveedores == ""){
        jConfirm(POR_FAVOR_SELECCIONE_PROVEEDORES_A_PRESUPUESTAR, function(){ })
        return false
    }
    if(checkSeleccionados(true)){
        $('#exportHidden').remove()
        $('.editable').attr('disabled', false) 
        $('#' + form_id).append("<input id='exportHidden' type='hidden' name='exportXLS' value='xls' />")
        $('#proveedores').val(proveedores)
        $('#' + form_id).submit()  
        $('.editable').attr('disabled', true) 
    }
 
}

// checkea que se seleccionen recomendaciones para exportar, o para generar el presupuesto
function checkSeleccionados(bool){
    if(bool){
        var checkeados = 0
        $('.activo').each(function() {
             if($(this).attr('checked')){ 
                arreglo[checkeados] = $(this).val()
                 checkeados++
             }
        });
        if(checkeados == 0){
            jConfirm(POR_FAVOR_SELECCIONE_LAS_RECOMENDACIONES, function(){ })
            return false
        }else{
            return true
        }   
    }         
}
    
function submitFormPDF(form_id) {
        $('#exportHidden').remove()
        $('.editable').attr('disabled', false) 
        $('#' + form_id).append("<input id='exportHidden' type='hidden' name='exportPDF' value='pdf' />")
        if(checkSeleccionados(true)) { $('#' + form_id).submit() }
        $('.editable').attr('disabled', true) 
}
    
function submitFormDOC(form_id){
        $('#exportHidden').remove()
        $('.editable').attr('disabled', false) 
        $('#' + form_id).append("<input id='exportHidden' type='hidden' name='exportDOC' value='doc' />")
        if(checkSeleccionados(true)) { $('#' + form_id).submit() }
        $('.editable').attr('disabled', true) 
}

/************************************************************ FIN - EXPORTACIONES ********************************************/
