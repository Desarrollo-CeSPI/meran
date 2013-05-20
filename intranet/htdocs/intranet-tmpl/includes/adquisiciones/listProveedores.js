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
 * LIBRERIA listProveedores v 1.0.1
 * Esta es una libreria creada para el sistema KOHA
 * Contendran las funciones para permitir la circulacion en el sistema
 * Fecha de creacion 22/10/2008
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
    objAH.cache = false;
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

function Borrar(){
    $('#nombre_proveedor').val('');
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
