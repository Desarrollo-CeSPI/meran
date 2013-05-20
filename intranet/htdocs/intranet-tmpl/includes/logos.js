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

function listarLogos(){
    objAH               = new AjaxHelper(updateListarLogos);
    objAH.debug         = true;
    objAH.showOverlay   = true;
    objAH.url           = URL_PREFIX+'/admin/logosDB.pl';
    objAH.tipoAccion    = 'LISTAR';
    objAH.sendToServer();
}

function updateListarLogos(responseText){
    if (!verificarRespuesta(responseText))
        return(0);
    $('#logos_ajax').html(responseText);
}

function eliminarLogo(id){
   objAH                   = new AjaxHelper(updateEliminarLogo);
   objAH.showOverlay       = true;
   objAH.url               = URL_PREFIX+'/admin/logosDB.pl';
   objAH.idLogo            = id;
   objAH.context           = 'intranet';
   objAH.tipoAccion        = 'DEL_LOGO';
   objAH.sendToServer();
}

function updateEliminarLogo(responseText){
   if (!verificarRespuesta(responseText))
    return(0);
    indexLogos();
}

function listarLogosUI(){
    objAH               = new AjaxHelper(updateListarLogosUI);
    objAH.debug         = true;
    objAH.showOverlay   = true;
    objAH.url           = URL_PREFIX+'/admin/logosDB.pl';
    objAH.tipoAccion    = 'LISTAR_UI';
    objAH.sendToServer();
}

function updateListarLogosUI(responseText){
    if (!verificarRespuesta(responseText))
        return(0);
    $('#logos_ajax_ui').html(responseText);
}

function eliminarLogoUI(id){
    objAH                   = new AjaxHelper(updateEliminarLogoUI);
    objAH.showOverlay       = true;
    objAH.url               = URL_PREFIX+'/admin/logosDB.pl';
    objAH.idLogo            = id;
    objAH.context           = 'intranet';
    objAH.tipoAccion        = 'DEL_LOGO_UI';
    objAH.sendToServer();
}

function updateEliminarLogoUI(responseText){
    if (!verificarRespuesta(responseText))
        return(0);
    indexLogos();
}

function indexLogos(){
    startOverlay();
    listarLogos();
    listarLogosUI();
}

function agregarPortada_show(){
    $('#agregarLogoForm').modal();
} 
  
function submitForm(){
    $('#agregarLogoForm').modal('hide');
    startOverlay();
    $('#formAgregarLogo').submit();
}

function modificarLogo(id){
    objAH                   = new AjaxHelper(updateModificarLogo);
    objAH.showOverlay       = true;
    objAH.url               = URL_PREFIX+'/admin/logosDB.pl';
    objAH.idLogo            = id;
    objAH.tipoAccion        = 'SHOW_MOD_LOGO';
    objAH.sendToServer();
}

function updateModificarLogo(responseText){
    if (!verificarRespuesta(responseText))
          return(0);
    $('#agregarLogoForm').html(responseText);
    $('#agregarLogoForm').modal();
}

function agregarPortada_showUI(){
    $('#agregarLogoUIForm').modal();
} 
  
function submitFormUI(){
    $('#agregarLogoUIForm').modal('hide');
    startOverlay();
    $('#agregarLogoUIForm').submit();
}

function modificarLogoUI(id){
  objAH                   = new AjaxHelper(updateModificarLogoUI);
  objAH.showOverlay       = true;
  objAH.url               = URL_PREFIX+'/admin/logosDB.pl';
  objAH.idLogo            = id;
  objAH.tipoAccion        = 'SHOW_MOD_LOGO_UI';
  objAH.sendToServer();
}

function updateModificarLogoUI(responseText){
  if (!verificarRespuesta(responseText))
        return(0);
    $('#agregarLogoUI').html(responseText);
    $('#agregarLogoUI').modal();
}

function agregarPortada_showUI(){
    $('#agregarLogoUI').modal();
} 
  
function submitFormUI(){
    $('#agregarLogoUI').modal('hide');
    startOverlay();
    $('#agregarLogoUIForm').submit();
}

function modificarLogo(id){
    objAH                   = new AjaxHelper(updateModificarLogo);
    objAH.showOverlay       = true;
    objAH.url               = URL_PREFIX+'/admin/logosDB.pl';
    objAH.idLogo            = id;
    objAH.tipoAccion        = 'SHOW_MOD_LOGO_UI';
    objAH.sendToServer();
}

function updateModificarLogo(responseText){
    if (!verificarRespuesta(responseText))
        return(0);
    $('#agregarLogoUI').html(responseText);
    $('#agregarLogoUI').modal();
}

$(document).ready(function() {
    indexLogos();
});