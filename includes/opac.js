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

function eliminarPublicacion(id_novedad){

    jConfirm(SEGURO_OCULTAR_NOVEDAD,OPAC_ALERT_TITLE, function(confirmStatus){
        if (confirmStatus){
            objAH                   = new AjaxHelper(updateEliminarPublicacion);
            objAH.showOverlay       = false;
            objAH.debug             = true;
            objAH.url               = URL_PREFIX+'/opac-novedadesDB.pl';
            objAH.id_novedad        = id_novedad;
            objAH.tipoAccion        = 'DELETE_NOVEDAD';
            objAH.sendToServer();
        } 
    
    })
}

function updateEliminarPublicacion(responseText){
    actualizarTabla();
}


function actualizarTabla(){
    $("#resultNovedades").append("<img src="+imagesForJS+"/loaders/facebook_style_green.gif alt=[% 'Cargando..' | i18n %] style='border:0;' />");
    objAH               = new AjaxHelper(updateActualizarTabla);
    objAH.debug         = true;
    objAH.url           = URL_PREFIX+'/opac-novedadesDB.pl';
    objAH.showOverlay   = false;
    objAH.tipoAccion    = "ACTUALIZAR_TABLA_NOVEDADES";
    objAH.sendToServer();
}

function updateActualizarTabla(responseText){
    $("#resultNovedades").html(responseText);
}