[% INCLUDE "FormValidateHelper.inc" %]
[% INCLUDE  "AutocompleteHelper.inc"  %]


<script src="/opac-tmpl/includes/opac-searchFunciones.js" type="text/javascript"></script>
<script src="/opac-tmpl/includes/tabletojson.js" type="text/javascript"> </script>
<script src="/opac-tmpl/includes/opac-recomendaciones.js" type="text/javascript"></script>
<script src="/includes/jquery/modal/jquery.simplemodal.js" type="text/javascript"></script>
<script type="text/javascript">

recomendacionCreada= false;

function buscarDatosNivel2(){
        objAH                   = new AjaxHelper(updateBuscarDatosNivel2);
        objAH.debug             = true;
        objAH.showOverlay       = true;
        objAH.url               = '[% url_prefix %]/opac-recomendacionesDB.pl';
        objAH.tipoAccion        = 'BUSQUEDA_EDICIONES';
        objAH.idCatalogoSearch  = $('#catalogo_search_hidden').val();
        objAH.sendToServer();
}

function traerImputsVacios(){
        objAH                   = new AjaxHelper(updateTraerImputsVacios);
        objAH.debug             = true;
        objAH.showOverlay       = true;
        objAH.url               = '[% url_prefix %]/opac-recomendacionesDB.pl';
        objAH.tipoAccion        = 'BUSQUEDA_RECOMENDACION_SIN_RESULTADOS';
        objAH.sendToServer();
}


function aceptarRecomendacion(user_id){
//         $('tabla_recomendacion').empty(); 
        objAH                   = new AjaxHelper(updateAceptarRecomendacion);
        objAH.debug             = true;
        objAH.showOverlay       = true;
        objAH.url               = '[% url_prefix %]/opac-recomendacionesDB.pl';
        objAH.id_rec            = $('#id_recomendacion').val();
        objAH.user_id           = user_id;
        objAH.tipoAccion        = 'ACTIVAR_RECOMENDACION';
        objAH.sendToServer();
                

}


function updateAceptarRecomendacion(responseText){
//   $('tabla_recomendacion').remove;


  $('#ediciones').hide();
  $('#recomendacion').hide();
  $('#datos_material').hide();
  $('#catalogo_search').val('');
  if (!verificarRespuesta(responseText))
            return(0);
  var Messages=JSONstring.toObject(responseText);
  setMessages(Messages);


}


function updateTraerImputsVacios(responseText){
  $('#datos_edicion_seleccionada').html(responseText); 
}

// function guardarRecomendacion(){
//    
//     $(".eliminar").remove();
//     $("#tabla_recomendacion").hide();
//     alert( $("#tabla_recomendacion"));
//     $("#tabla_recomendacion").tabletojson({
//             headers: "Autor,Titulo, Edicion, Lugar Publicacion, Editorial, Fecha, ISBN/ISSN, Nivel 2, Cantidad, Motivo, Comentario",
//             attribHeaders: "{}",
//             returnElement: "#table",
//             complete: function(x){
//                 
//                  objAH                     = new AjaxHelper(updateGuardarRecomendacion);
//                  objAH.url                 = '[% url_prefix %]/opac-recomendacionesAdd.pl';
//                  objAH.debug               = true;
//                  objAH.showOverlay         = true;
//                  objAH.table               = JSONstring.toObject(x);
//                  objAH.motivo_propuesta    = $('#motivo_propuesta').val();
//                  objAH.comment             = $('#comment').val();
//                  objAH.tipoAccion          = 'GUARDAR_RECOMENDACION';
//                  objAH.sendToServer();
//             }
//         })
//     $(".tr").remove
//     
// }
// 
// function updateGuardarRecomendacion(responseText){
//   
//    if (!verificarRespuesta(responseText)) {
//             return(0);
//             var Messages=JSONstring.toObject(responseText);
//             setMessages(Messages);
//    }
// }


function updateBuscarDatosNivel2(responseText){
   $('#ediciones').html(responseText);
  
   $('#edicion_id').val('').attr("selected",true);
   $('#edicion_id').change( function(){    
              var edicion=this.options[this.selectedIndex].text 
              cargarDatosEdicionSeleccionada(edicion)
   });
   if (!verificarRespuesta(responseText)) {
            return(0);
            var Messages=JSONstring.toObject(responseText);
            setMessages(Messages);
   }
}


function cargarDatosEdicionSeleccionada(edicion){
        objAH                   = new AjaxHelper(updateCargarDatosEdicionSeleccionada);
        objAH.debug             = true;
        objAH.showOverlay       = true;
        objAH.url               = '[% url_prefix %]/opac-recomendacionesDB.pl';
        objAH.tipoAccion        = 'CARGAR_DATOS_EDICION';
        objAH.edicion_id        = $('#edicion_id').val();
        objAH.edicion           = edicion;
        objAH.idCatalogoSearch  = $('#catalogo_search_hidden').val();
        objAH.sendToServer();
}


function updateCargarDatosEdicionSeleccionada(responseText){
   $('#datos_edicion_seleccionada').html(responseText);    

//    if (!verificarRespuesta(responseText)) {
//             return(0);
//             var Messages=JSONstring.toObject(responseText);
//             setMessages(Messages);
//    }
}

function bloquearCampos(){
     $('#autor').attr('readonly', true); 
     $('#titulo').attr('readonly', true); 
     /*$('#edicion').attr('readonly', true);*/ 
     $('#lugar_publicacion').attr('readonly', true); 
     $('#editorial').attr('readonly', true); 
     $('#isbn_issn').attr('readonly', true); 
     $('#fecha').attr('readonly', true); 

}

function verificarBusqueda(){
    if ($('#catalogo_search_hidden').val() != (-1)){
            $('#carga_manual').hide();
            buscarDatosNivel2();
            bloquearCampos();
            $('#ediciones').show();
    } else {   
           traerImputsVacios();
           $('#carga_manual').show();
           $('#ediciones').hide(); 
    }
    if (!recomendacionCreada){    
      crearRecomendacion();
      recomendacionCreada= true;
    }
}

$(document).ready( function() {
    CrearAutocompleteCatalogo({ 
          IdInput: 'catalogo_search', 
          IdInputHidden: 'catalogo_search_hidden', 
          callBackFunction: verificarBusqueda,
    })
    $('#catalogo_search').blur(function(){        
              limpiarCampos()
    });
    $('#recomendacion').hide();
    makeToggle('carga_manual','trigger',null,true);

    [% IF mensaje %]
      $('#mensajes').html('<div class="message_text">[% mensaje %]</div>');
      $('#mensajes').show()
    [% END %]
});



</script>         
 
<div class="column1-unit">
      <div style= "width: 200%;" class="recomendacionform">
              <input type="hidden" name="action" value="agregar">
              <fieldset> 
              	<legend class="titulo_legend trigger click">[% "Busqueda de Datos del Material" | i18n %]</legend>
                     <p><label for="catalogo_search" style="float: left; padding-right:10px">[% 'Keyword' | i18n %]</label>
                     <input type='text' id='catalogo_search' name='catalogo_search' value='' size=40 tabindex='3' style="float: left"></p>
                     <input type='hidden' id='catalogo_search_hidden' name='catalogo_search_hidden' value=''>
              </fieldset>
              <div id="ediciones"></div>

              <div class="carga_manual" id="carga_manual"> 
                     [% PERL %]
                          print C4::AR::Filtros::setHelp(text => "[% 'No se han encontrado resultados para la busqueda realizada. Si lo desea, puede llenar los campos manualmente' | i18n %]",
                                        );   C4::AR::Debug::debug("Save Detalle");
                     [% END %]
                  
              </div>      
            <input type="hidden" name="id_recomendacion" id="id_recomendacion" value= ""/>
           <div id="datos_edicion_seleccionada"></div>
              <fieldset  id="recomendacion"><legend class="titulo_legend trigger click">&nbsp;[% 'Recomendacion' | i18n %]&nbsp;</legend>
                  <table id="tabla_recomendacion" name= "tabla_recomendacion" class="tabla_datos" cellspacing='0' cellpadding='0'>
                          <thead>    
                              <th align="center">
                                  [% "Autor" | i18n %]
                              </th>
                              <th align="center">
                                  [% "T&iacute;tulo" | i18n %]
                              </th>
                              <th align="center">
                                  [% "Edici&oacute;n" | i18n %]
                              </th>
                              <th align="center">
                                  [% "Lugar de publicaci&oacute;n" | i18n %]
                              </th>
                              <th align="center">
                                  [% "Editorial" | i18n %]
                              </th>
                              <th align="center">
                                  [% "Fecha" | i18n %]
                              </th>
                             <!-- <th align="center">
                                  [% "Colecci&oacute;n" | i18n %]
                              </th>-->
                              <th align="center">
                                  [% "ISBN/ISSN" | i18n %]
                              </th>
                              <th align="center">
                                  [% "Nivel 2" | i18n %]
                              </th>
                              <th align="center">
                                  [% "Cantidad de ejemplares" | i18n %]
                              </th>
                              <th align="center">
                                  [% "Motivo de la Propuesta" | i18n %]
                              </th>
                               <th align="center">
                                  [% "Comentarios" | i18n %]
                              </th>
                              <th class="eliminar" align="center">
                                  [% "Eliminar" | i18n %]
                              </th>
                                  
                        </thead>
                        <tbody>
                        </tbody>
                      </table>
                      <div id="acciones" style="float:left; margin: 20px 10px 10px 10px;" >
                          
                  <!--        <form method="post" id="form_recom" action="opac-recomendaciones.pl?token=[% token %]">-->
                           <!-- <input type="hidden" name="mensaje" value="La recomendacion fue enviada con exito">-->
                            <input type="button" style="float:left;" onclick="aceptarRecomendacion('[% user_id %]')" value="Aceptar Recomendacion">
                              <input type="button" style="float:left" onclick="cancelarRecomendacion()" value="Cancelar Recomendacion">
                      <!--    </form>-->
                        
                      </div>
                      </fieldset>
                  
      </div>         
</div>
        
