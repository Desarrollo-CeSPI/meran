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

$(document).ready(function() {
    mostrarTabla();
});

function agregarTipoDeDocumento(){
    $('#addTipoDocumento').modal();
}

// function agregarTipoDeDocumento(){
//     objAH               = new AjaxHelper(updateAgregarTipoDeDocumento);
//     objAH.debug         = true;
//     objAH.showOverlay   = true;
//     objAH.url           = URL_PREFIX+"/catalogacion/tipoDocumentoDB.pl";
//     objAH.tipoAccion    = 'AGREGAR_TIPO_DE_DOCUMENTO';

//     objAH.sendToServer();
// }

// function updateAgregarTipoDeDocumento(responseText){
//     var Messages = JSONstring.toObject(responseText);
//     setMessages(Messages);
//     mostrarTabla();
// }

function mostrarTabla(){
    objAH               = new AjaxHelper(updateMostrarTabla);
    objAH.debug         = true;
    objAH.showOverlay   = true;
    objAH.url           = URL_PREFIX+"/catalogacion/tipoDocumentoDB.pl";
    objAH.tipoAccion    = 'LISTAR';

    objAH.sendToServer();
}

function updateMostrarTabla(responseText){
    $("#resultTipoDocumento").html(responseText);
}

function modificarTipoDocumento(idTipoDoc){

    objAH               = new AjaxHelper(updateModificarTipoDocumento);
    objAH.debug         = true;
    objAH.showOverlay   = true;
    objAH.idTipoDoc     = idTipoDoc;
    objAH.url           = URL_PREFIX+"/catalogacion/tipoDocumentoDB.pl";
    objAH.tipoAccion    = 'SHOW_MOD_TIPO_DOC';

    objAH.sendToServer();

}

function updateModificarTipoDocumento(responseText){
    $('#accionesTipoDocumento').html(responseText);
    $('#accionesTipoDocumento').modal();
}

function eliminarTipoDocumento(idTipoDoc){
    objAH               = new AjaxHelper(updateEliminarTipoDocumento);
    objAH.debug         = true;
    objAH.showOverlay   = true;
    objAH.idTipoDoc     = idTipoDoc;
    objAH.url           = URL_PREFIX+"/catalogacion/tipoDocumentoDB.pl";
    objAH.tipoAccion    = 'DEL_TIPO_DOC';

    objAH.sendToServer();
}

function updateEliminarTipoDocumento(responseText){
    var Messages = JSONstring.toObject(responseText);
    setMessages(Messages);
    mostrarTabla();
}

function guardarModificacion(){
    $('#accionesTipoDocumento').modal('hide');
    $('#modTipoDocumento').submit();
    startOverlay();
}

function guardarTipoDoc(){
    $('#addTipoDocumento').modal('hide');
    $('#addTipoDocumentoForm').submit();
    startOverlay();
}