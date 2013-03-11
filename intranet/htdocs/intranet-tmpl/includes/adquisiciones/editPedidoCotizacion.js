/*
 * LIBRERIA editPedidoCotizacion v 0.0.9
 * Esta es una libreria creada para el sistema KOHA
 * Contendran las funciones para la edicion de pedidos de cotizacion
 * Fecha de creacion 04/04/2011
 *
 */ 

var array_ejemplares_id    = new Array() //global, arreglo con los ids de los ejemplares a agregar
var cant_ejemplares_array  = new Array() // global con las cantidades de ejemplares. Se corresponde la posicion con el de ejemplares_id

$(document).ready(function() {
    CrearAutocompleteCatalogo({ 
          IdInput: 'catalogo_search', 
          IdInputHidden: 'catalogo_search_hidden', 
          callBackFunction: buscarDatosNivel2,
    })
    $('#carga_manual').click(function(){        
        $('#datos_edicion').hide()
    });
    $('#catalogo_search').blur(function(){        
        limpiarCampos()
    });
    $('#recomendacion').hide();
});


// busqueda autocomplete por nombre ejemplar, editorial, autor
function buscarDatosNivel2(){
    $('#agregarMano').hide();
    objAH                   = new AjaxHelper(updateBuscarDatosNivel2)
    objAH.debug             = true
    objAH.showOverlay       = true
    
    objAH.url               = URL_PREFIX+'/adquisiciones/recomendacionesDB.pl'
    objAH.tipoAccion        = 'BUSQUEDA_RECOMENDACION'
    objAH.idCatalogoSearch  = $('#catalogo_search_hidden').val()
    objAH.sendToServer()
}

function updateBuscarDatosNivel2(responseText){
    $('#ediciones').html(responseText)
    $('#edicion_id').val('').attr("selected",true)
    $('#edicion_id').change( function(){         
       cargarDatosEdicionSeleccionada()
    });  
}

// trae la edicion cuando selecciona el combo de ediciones
function cargarDatosEdicionSeleccionada(){
    objAH                   = new AjaxHelper(updateCargarDatosEdicionSeleccionada)
    objAH.debug             = true
    objAH.showOverlay       = true
    objAH.url               = URL_PREFIX+'/adquisiciones/recomendacionesDB.pl'
    objAH.tipoAccion        = 'CARGAR_DATOS_EDICION'
    objAH.edicion           = $('#edicion_id').val()
    objAH.idCatalogoSearch  = $('#catalogo_search_hidden').val()
    objAH.sendToServer();
}

function updateCargarDatosEdicionSeleccionada(responseText){
    $('#datos_edicion_seleccionada').html(responseText);    
}

// limpia los inputs cuando se agrega un ejemplar en el cliente
function limpiarCampos(){
    $('#autor').val("")
    $('#titulo').val("")
    $('#edicion').val("")
    $('#lugar_publicacion').val("")
    $('#editorial').val("")
    $('#fecha').val("")
    $('#coleccion').val("")
    $('#isbn_issn').val("")
    $('#cant_ejemplares').val("")
}

// borra una fila de la tabla en el cliente
function eliminarFila(filaId){
    $('#tr'+filaId).remove()
    /*if($('#tabla_recomendacion').length == 1){
        $('#boton_agregar_pedido').hide()
    }*/
}

// agrega una fila en el cliente
function agregarRenglon(){
    var id= $('#edicion_id').val()
    
    cant_ejemplares_array[array_ejemplares_id.length]   =  $('#cant_ejemplares').val()   
    array_ejemplares_id[array_ejemplares_id.length]     = id               

    if( ($('#input'+id).val() == null) ){
        var autor               = $('#autor').val()
        var titulo              = $('#titulo').val()
        var edicion             = $('#edicion').val()
        var lugar_publicacion   = $('#lugar_publicacion').val()
        var editorial           = $('#editorial').val()
        var fecha               = $('#fecha').val()
        var coleccion           = $('#coleccion').val()
        var ISBN_ISSN           = $('#isbn_issn').val()
        var cant_ejemplares     = $('#cant_ejemplares').val()
      
        limpiarCampos();
            
        $('#tabla_recomendacion').append('<tr id="tr'+id+'" name='+id+'><input type="hidden" value="'+id+'" id="input'+id+'"><td>'+autor+'</td><td>'+titulo+'</td><td>'+edicion+'</td><td>'+lugar_publicacion+'</td>'+'<td>'+editorial+'</td><td>'+fecha+'</td><td>'+coleccion+'</td><td>'+ISBN_ISSN+'</td>'+'<td>'+cant_ejemplares+'</td><td><input type="button" onclick="eliminarFila('+id+')"  value="X"></input></td></tr>')
        $('#recomendacion').show();     
     }
}

// agrega el pedido de cotizacion en la base
function appendPedidoCotizacion(formId){

    objAH                       = new AjaxHelper(updateAppendPedidoCotizacion)
    objAH.debug                 = true
    objAH.showOverlay           = true
    objAH.url                   = URL_PREFIX+'/adquisiciones/pedidoCotizacionDB.pl'
    objAH.tipoAccion            = 'APPEND_PEDIDO_COTIZACION'
    
    objAH.pedido_cotizacion_id  = $('#pedido_cotizacion_id').val()
    objAH.ejemplares_ids_array  = array_ejemplares_id
    objAH.cant_ejemplares_array = cant_ejemplares_array
    objAH.sendToServer()
}

function updateAppendPedidoCotizacion(responseText){
    if (!verificarRespuesta(responseText)) 
        return(0)
    var Messages = JSONstring.toObject(responseText)
    setMessages(Messages)

}
