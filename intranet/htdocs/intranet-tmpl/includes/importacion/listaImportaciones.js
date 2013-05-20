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

