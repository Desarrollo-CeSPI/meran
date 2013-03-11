/*
 * LIBRERIA listaIportaciones v 1.0.1
 * Esta es una libreria creada para el sistema MERAN
 * Fecha de creacion 03/01/2012
 *
 */


//*********************************************Buscar Proveedor*********************************************


function ordenar(orden){
    objAH.sort(orden);
}

function Borrar(){
    $('#nombre_importacion').val('');
}

function consultar(filtro,doScroll){
    if (doScroll)
      shouldScrollUser = doScroll;
    objAH=new AjaxHelper(updateInfoImportaciones);
    objAH.cache = true;
    busqueda = jQuery.trim($('#nombre_importacion').val());
    inicial = '0';
    if (filtro){
        inicial = filtro;
        busqueda = jQuery.trim(filtro);
        objAH.inicial= inicial;
        $('#nombre_importacion').val(FILTRO_POR + filtro);
    }
    else
       {
        if (busqueda.substr(8,5).toUpperCase() == 'TODOS'){
                busqueda = busqueda.substr(8,5);
                $('#nombre_importacion').val(busqueda);
                consultar(busqueda);
        }
        else
           {
            if (busqueda.substr(0,6).toUpperCase() == 'FILTRO'){
                busqueda = busqueda.substr(8,1);
                $('#nombre_importacion').val(busqueda);
                consultar(busqueda);
            }
           }
    }
    if(jQuery.trim(busqueda).length > 0){
        objAH.url               = URL_PREFIX+'/herramientas/importacion/importarDB.pl';
        objAH.debug             = true;
        objAH.showOverlay       = true;
        objAH.funcion           = 'changePage';
        objAH.tipoAccion        = "BUSQUEDA";
        objAH.nombre_importacion  = busqueda;
        objAH.sendToServer();
    }
    else{
// ver estas dos variables donde estan, asi tira bien el aler
        jAlert(INGRESE_UN_DATO,IMPORTACION_ALERT_TITLE);
        $('#nombre_importacion').focus();
    }

}

function changePage(ini){
    objAH.changePage(ini);
}

function updateInfoImportaciones(responseText){
    $('#result').html(responseText);
    zebra('datos_tabla');
    var idArray = [];
    var classes = [];
    idArray[0] = 'importacion';
    classes[0] = 'archivo';
    classes[1] = 'formato';
    classes[2] = 'comentario';
    classes[3] = 'esquema';
    busqueda = jQuery.trim($('#nombre_importacion').val());
    if (busqueda.substr(0,6).toUpperCase() != 'FILTRO') //SI NO SE QUISO FILTRAR POR INICIAL, NO TENDRIA SENTIDO MARCARLO
        highlight(classes,idArray);
    if (shouldScrollUser)
        scrollTo('result');
}

function checkFilter(eventType){
    var str = $('#nombre_importacion').val();

    if (eventType.toUpperCase() == 'FOCUS'){

        if (str.substr(0,6).toUpperCase() == 'FILTRO'){
            globalSearchTemp = $('#nombre_importacion').val();
            Borrar();
        }
    }
    else
       {
        if (jQuery.trim($('#nombre_importacion').val()) == "")
            //no se que hace:
            //$('#nombre_proveedor').val(globalSearchTemp);
            $('#nombre_importacion').val()
       }
}

//************************************************* ELIMINAR IMPORTACION ****************************************************

    function borrarImportacion(id){
        jConfirm(ESTA_SEGURO_QUE_DESEA_BORRARLO,IMPORTACION_ALERT_TITLE, function(confirmStatus){

            if(confirmStatus){
                objAH                   = new AjaxHelper(updateBorrarImportacion);
                objAH.debug             = true;
                objAH.showOverlay       = true;
                objAH.url               = URL_PREFIX+'/herramientas/importacion/importarDB.pl';
                objAH.id_importacion    = id
                objAH.tipoAccion        = "ELIMINAR";
                objAH.sendToServer();
            }
        });
    }

    function updateBorrarImportacion(responseText){
        if (!verificarRespuesta(responseText))
            return(0);
        var Messages=JSONstring.toObject(responseText);
        setMessages(Messages);
        consultar();
    }

