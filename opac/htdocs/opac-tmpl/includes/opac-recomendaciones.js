
//La Variable contador es un nro que se usa como id de cada detalle agregado a mano en la tabla de la recomendacion.
//es un nro negarivo porque si fuera positivo podria ser igual a algun id existente en catalogo. Se usa para compara en caso de querer agregar 
//dos veces el mismo elemento a la tabla.

var contador = -1;


function validateForm(func){

       $().ready(function() {
            // validate signup form on keyup and submit
            $.validator.setDefaults({
                 submitHandler:  func ,
            });
            $('#recom_form').validate({
                errorElement: "em",
                errorClass: "error_adv",
                rules: {
                          autor:   "required",
                          titulo:     "required",  
                          edicion:     "required", 
                          editorial:   "required",              
                          cant_ejemplares:  "required",
                          cant_ejemplares: "number",             
                          motivo_propuesta:    "required",
                        },
                 messages: {
                          autor: POR_FAVOR_INGRESE_UN_AUTOR,
                          titulo: POR_FAVOR_INGRESE_UN_TITULO,
                          edicion: POR_FAVOR_INGRESE_UNA_EDICION,
                          editorial: POR_FAVOR_INGRESE_UNA_EDITORIAL,
                          cant_ejemplares: POR_FAVOR_INGRESE_UNA_CANTIDAD, 
                          motivo_propuesta: POR_FAVOR_INGRESE_UN_MOTIVO,
                     
                        }, 
                 });
            });
             
           
}

function limpiarCampos(){


    $('#cant_ejemplares_disp').hide();
    $('#autor').val("");
    $('#titulo').val("");
    $('#edicion').val("");
    $('#lugar_publicacion').val("");
    $('#editorial').val("");
    $('#fecha').val("");
    $('#isbn_issn').val("");
    $('#cant_ejemplares').val("");
    $('#motivo_propuesta').val("");
    $('#comment').val("");  
    $('#edicion_id').val("");
   
}


function eliminarDetalle(idRecom){
    
        objAH                   = new AjaxHelper(updateEliminarDetalle);
        objAH.debug             = true;
        objAH.showOverlay       = true;
        objAH.url               = URL_PREFIX+'/opac-recomendacionesDB.pl'; 
        objAH.id_rec_det        = idRecom;
        objAH.tipoAccion        = 'ELIMINAR_DETALLE';
        objAH.sendToServer();
}
       
function updateEliminarDetalle(responseText){
    if (!verificarRespuesta(responseText))
            return(0);
    var Messages=JSONstring.toObject(responseText);
    setMessages(Messages);
}

function eliminarFila(filaId, idRecom){
 
    $('#'+filaId).remove();
    eliminarDetalle(idRecom);
     
}

 function agregarRenglonATabla(id_rec_det){
   
        if ($('#catalogo_search_hidden').val() == (-1)){
          var id= contador
          contador--
          id_nivel_2 = " - ";
        } else {
            if ($('#edicion_id').val() != ""){
                var id= $('#edicion_id').val();
                 id_nivel_2 = id;
            } else {
                id= contador;
                contador--
                id_nivel_2 = " - ";
            }
           
        }

       if ($('#'+id).val() == null){
     
            var autor  = $('#autor').val()
            var titulo   = $('#titulo').val()
            var edicion = $('#edicion').val()
            var lugar_publicacion = $('#lugar_publicacion').val();
            var editorial= $('#editorial').val();
            var fecha = $('#fecha').val();
            var coleccion = $('#coleccion').val();
            var ISBN_ISSN = $('#isbn_issn').val();
            var cant_ejemplares = $('#cant_ejemplares').val();
            var renglon_recom= id_rec_det;   
            var comentario= $('#comment').val();
            var motivo= $('#motivo_propuesta').val();
            limpiarCampos();
            
            $('#tabla_recomendacion').append(
                '<tr class="tr" id="tr'+id+'" name="tr'+id+'">' +
                    '<input type="hidden" value="'+id+'" id="'+id+'">' +
                    '<td id="autor'+renglon_recom+'" name=autor'+renglon_recom+'>'+autor+'</td>' +
                    '<td id="titulo'+renglon_recom+'" name=titulo'+renglon_recom+'>'+titulo+'</td>' +
                    '<td id="edicion'+renglon_recom+'" name=edicion'+renglon_recom+'>'+edicion+'</td>'+
                    '<td id="lugar_publicacion'+renglon_recom+'" name=lugar_publicacion'+renglon_recom+'>'+lugar_publicacion+'</td>' +
                    '<td id="editorial'+renglon_recom+'" name=editorial'+renglon_recom+'>'+editorial+'</td>' +
                    '<td id="fecha'+renglon_recom+'" name=fecha'+renglon_recom+'>'+fecha+'</td>' +
                    '<td id="isbn_issn'+renglon_recom+'" name=isbn_issn'+renglon_recom+'>'+ISBN_ISSN+'</td>'+
                    '<td id="nivel_2'+renglon_recom+'" name=nivel_2'+renglon_recom+'>'+id_nivel_2+'</td>'+
                    '<td id="cant_ejemplares'+renglon_recom+'" name=cant_ejemplares'+renglon_recom+'>'+cant_ejemplares+'</td>' +  
                    '<td id="motivo'+renglon_recom+'" name=motivo'+renglon_recom+'>'+motivo+'</td>' + 
                    '<td id="comentario'+renglon_recom+'" name=comentario'+renglon_recom+'>'+comentario+'</td>' + 
                    '<td class="eliminar" id="eliminar'+renglon_recom+'" name=eliminar'+renglon_recom+'><input type="button" onclick=eliminarFila('+'"tr'+id+'","'+renglon_recom+'") id="eliminar'+id+'" value="x" name="eliminar'+id+'"></td>' + 
                 '</tr>'
            )
            $('#recomendacion').show();
          
  }
}
        
function crearRecomendacion(){
        objAH                   = new AjaxHelper(updateCrearRecomendacion);
        objAH.debug             = true;
        objAH.showOverlay       = true;
        objAH.url               = URL_PREFIX+'/opac-recomendacionesDB.pl';     
        objAH.tipoAccion        = 'AGREGAR_RECOMENDACION';
        objAH.sendToServer();

}

function updateCrearRecomendacion(responseText){
    $('#id_recomendacion').val(responseText)
}
      
        
function cancelarRecomendacion(){
        $('.tr').remove();  
        objAH                   = new AjaxHelper(updateCancelarRecomendacion);
        objAH.debug             = true;
        objAH.showOverlay       = true;
        objAH.url               = URL_PREFIX+'/opac-recomendacionesDB.pl';     
        objAH.tipoAccion        = 'CANCELAR_RECOMENDACION';
        objAH.id_rec            = $('#id_recomendacion').val();
        objAH.sendToServer();
}

function updateCancelarRecomendacion(responseText){
//   $('tabla_recomendacion').remove();
  $('#ediciones').hide();
  $('#recomendacion').hide();
  $('#datos_material').hide();
  $('#catalogo_search').val('');
  if (!verificarRespuesta(responseText))
            return(0);
  var Messages=JSONstring.toObject(responseText);
  setMessages(Messages);
}
        

function guardarDetalle() {
    validateForm(agregarRenglon)
    $('#recomendacion').show();
    $('#recom_form').submit(); 
}      
      
      
function agregarRenglon(){  
        objAH                   = new AjaxHelper(updateAgregarRenglon);
        objAH.debug             = true;
        objAH.showOverlay       = true;
        objAH.url               = URL_PREFIX+'/opac-recomendacionesDB.pl';
        objAH.autor             = $('#autor').val();
        objAH.titulo            = $('#titulo').val();
        objAH.edicion           = $('#edicion').val();
        objAH.lugar_publicacion = $('#lugar_publicacion').val();
        objAH.editorial         = $('#editorial').val();
        objAH.fecha             = $('#fecha').val();
        objAH.isbn_issn         = $('#isbn_issn').val();
        objAH.cant_ejemplares   = $('#cant_ejemplares').val();
        objAH.motivo_propuesta  = $('#motivo_propuesta').val();
        objAH.comment           = $('#comment').val();
        objAH.id_recomendacion  = $('#id_recomendacion').val();          
         objAH.idNivel1         = $('#catalogo_search_hidden').val();
        objAH.idNivel2          = $('#edicion_id').val()
        objAH.tipoAccion        = 'AGREGAR_RENGLON';
        objAH.sendToServer();   
}      

function updateAgregarRenglon(responseText){
    // si viene un 1 no paso la comprobacion de XSS en el server
    if (responseText == '1')
            return(0);
    agregarRenglonATabla(responseText); 
    $('#carga_manual').hide();
}
