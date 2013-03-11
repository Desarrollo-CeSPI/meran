/*
 * LIBRERIA listProveedoresResult v 1.0.0
 * Esta es una libreria creada para el sistema KOHA
 * Fecha de creación 12/11/2010
 *
 */


//*********************************************Buscar Proveedor*********************************************


function ordenar(orden){
    objAH.sort(orden);
}

function consultar(filtro,doScroll){
    if (doScroll)
      shouldScrollUser = doScroll;
    objAH=new AjaxHelper(updateInfoProveedores);
    objAH.cache = true;
    busqueda = jQuery.trim($('#nombre_proveedor').val());
    inicial = '0';
    if (filtro){
        inicial = filtro;
        busqueda = jQuery.trim(filtro);
        objAH.inicial= inicial;
        $('#nombre_proveedor').val(FILTRO_POR + filtro);
    }
    else
       {
        if (busqueda.substr(8,5).toUpperCase() == 'TODOS'){
                busqueda = busqueda.substr(8,5);
                $('#nombre_proveedor').val(busqueda);
                consultar(busqueda);
        }
        else
           {
            if (busqueda.substr(0,6).toUpperCase() == 'FILTRO'){
                busqueda = busqueda.substr(8,1);
                $('#nombre_proveedor').val(busqueda);
                consultar(busqueda);
            }
           }
    }
    if(jQuery.trim(busqueda).length > 0){
        objAH.url               = URL_PREFIX+'/adquisiciones/listProveedoresResult.pl';
        objAH.debug             = true;
        objAH.showOverlay       = true;
        objAH.funcion           = 'changePage';
        objAH.nombre_proveedor  = busqueda;
        objAH.sendToServer();
    }
    else{
// ver estas dos variables donde estan, asi tira bien el aler
        jAlert(INGRESE_UN_DATO,USUARIOS_ALERT_TITLE);
        $('#nombre_proveedor').focus();
    }

}

function changePage(ini){
    objAH.changePage(ini);
}

function updateInfoProveedores(responseText){
    $('#result').html(responseText);
    zebra('datos_tabla');
    var idArray = [];
    var classes = [];
    idArray[0] = 'proveedor';
    classes[0] = 'nombre';
    classes[1] = 'direccion';
    classes[2] = 'telefono';
    classes[3] = 'email';
    busqueda = jQuery.trim($('#nombre_proveedor').val());
    if (busqueda.substr(0,6).toUpperCase() != 'FILTRO') //SI NO SE QUISO FILTRAR POR INICIAL, NO TENDRIA SENTIDO MARCARLO
        highlight(classes,idArray);
    if (shouldScrollUser)
        scrollTo('result');
}

function checkFilter(eventType){
    var str = $('#nombre_proveedor').val();
    
    if (eventType.toUpperCase() == 'FOCUS'){

        if (str.substr(0,6).toUpperCase() == 'FILTRO'){
            globalSearchTemp = $('#nombre_proveedor').val();
            Borrar();
        }
    }
    else
       {
        if (jQuery.trim($('#nombre_proveedor').val()) == "")
            //no se que hace:
            //$('#nombre_proveedor').val(globalSearchTemp);
            $('#nombre_proveedor').val()
       }
}

//************************************************* ELIMINAR PROVEEDOR ****************************************************

    function borrarProveedor(id){  
        jConfirm(ESTA_SEGURO_QUE_DESEA_BORRARLO,PROVEEDOR_ALERT_TITLE, function(confirmStatus){

            if(confirmStatus){
                objAH                   = new AjaxHelper(updateBorrarProveedor);
                objAH.debug             = true;
                objAH.showOverlay       = true;
                objAH.url               = URL_PREFIX+"/adquisiciones/proveedoresDB.pl";
                objAH.id_proveedor      = id
                objAH.tipoAccion        = "ELIMINAR";
                objAH.sendToServer();
            }
        });
    }

    function updateBorrarProveedor(responseText){   
        if (!verificarRespuesta(responseText))
            return(0);
        var Messages=JSONstring.toObject(responseText);
        setMessages(Messages);
        consultar();
    }

