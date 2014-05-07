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

var objAH_usuarios;
var shouldScrollUser=true;
var globalSearchTemp;

function ordenar(orden){
    objAH_usuarios.sort(orden);
}

function changePage_usuarios(ini){
    objAH_usuarios.changePage(ini);
}

function consultarBar(filtro,doScroll){
    if (doScroll)
      shouldScrollUser = doScroll;
    objAH_usuarios=new AjaxHelper(updateInfoUsuariosBar);
    objAH_usuarios.showOverlay       = true;
    objAH_usuarios.cache = true;
    busqueda = jQuery.trim($('#socio-bar').val());
    inicial = '0';

    if(jQuery.trim(busqueda).length > 0){
        objAH_usuarios.url= URL_PREFIX+'/usuarios/reales/buscarUsuarioResult.pl';
        objAH_usuarios.showOverlay       = true;
        objAH_usuarios.debug= true;
//      objAH_usuarios.cache= true;
        objAH_usuarios.funcion= 'changePage_usuarios';
        objAH_usuarios.socio= busqueda;
        objAH_usuarios.sendToServer();
    }
}

function consultar(filtro,doScroll){
    if (doScroll)
        shouldScrollUser            = doScroll;
        objAH_usuarios              = new AjaxHelper(updateInfoUsuarios);
        objAH_usuarios.showOverlay  = true;
        objAH_usuarios.cache        = true;
        busqueda                    = jQuery.trim($('#socio').val());
        inicial                     = '0';

    if (filtro){
        inicial                 = filtro;
        busqueda                = jQuery.trim(filtro);
        objAH_usuarios.inicial  = inicial;
        $('#socio').val(FILTRO_POR + filtro);
    } else {
        if (busqueda.substr(8,5).toUpperCase() == 'TODOS'){
            busqueda = busqueda.substr(8,5);
            $('#socio').val(busqueda);
            consultar(busqueda);
        } else {
            if (busqueda.substr(0,6).toUpperCase() == 'FILTRO'){
                busqueda = busqueda.substr(8,1);
                $('#socio').val(busqueda);
                consultar(busqueda);
            }
        }
    }
    if( (jQuery.trim(busqueda).length > 0) || ($('#categoria_socio_id').val() > 0)){
        objAH_usuarios.url          = URL_PREFIX+'/usuarios/reales/buscarUsuarioResult.pl';
        objAH_usuarios.showOverlay  = true;
        objAH_usuarios.debug        = true;
//      objAH_usuarios.cache= true;
        objAH_usuarios.funcion      = 'changePage_usuarios';
        objAH_usuarios.socio        = busqueda;
        objAH_usuarios.categoria    = $('#categoria_socio_id').val();
        objAH_usuarios.sendToServer();
    }
    else{
        jAlert(INGRESE_UN_DATO,USUARIOS_ALERT_TITLE);
        $('#socio').focus();
    }
}

function updateInfoUsuarios(responseText){
    $('#resultBusqueda').html(responseText);
    var idArray = [];
    var classes = [];
    idArray[0] = 'socio';
    classes[0] = 'nomCompleto';
    classes[1] = 'documento';
    classes[2] = 'legajo';
    classes[3] = 'tarjetaId';
    busqueda = jQuery.trim($('#socio').val());
    scrollTo('resultBusqueda');
}

function updateInfoUsuariosBar(responseText){
	updateInfoUsuarios(responseText);
}

function Borrar(){
    $('#socio').val('');
}

function checkFilter(eventType){
    var str = $('#socio').val();
    
    if (eventType.toUpperCase() == 'FOCUS'){

        if (str.substr(0,6).toUpperCase() == 'FILTRO'){
            globalSearchTemp = $('#socio').val();
            Borrar();
        }
    }
    else
       {
        if (jQuery.trim($('#socio').val()) == "")
            $('#socio').val(globalSearchTemp);
       }
}
