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

// var objAH;
//arreglo de objetos campo
CAMPOS_ARRAY    = new Array();
//arreglo de objetos subcampo
SUBCAMPOS_ARRAY = new Array();

function agregarAyudaMarcShow(){
    $('#addAyudaMarcForm').modal();
} 

function hideAyudaMarcShow(){
    $('#addAyudaMarcForm').modal('hide');
}

function eleccionCampoX(){
    if ( $("#campoX").val() != -1){
        objAH               = new AjaxHelper(updateEleccionCampoX);
        objAH.debug         = true;
        objAH.showOverlay   = true;
        objAH.url           = URL_PREFIX+"/catalogacion/visualizacionOPAC/visualizacionOpacDB.pl";
        objAH.campoX        = $('#campoX').val();
        objAH.tipoAccion    = "GENERAR_ARREGLO_CAMPOS";
        objAH.sendToServer();
    }else{
        enable_disableSelects();
    }
}

function eleccionSubCampo(){

    if ($('#subcampo').val() != -1){
        $('#liblibrarian').val(SUBCAMPOS_ARRAY[$('#subcampo').val()].liblibrarian);
    }else{ 
        enable_disableSelects();
    }
}

//se genera el combo en el cliente
function updateEleccionCampoX(responseText){
    //Arreglo de Objetos Global
    var campos_array = JSONstring.toObject(responseText);
    //se inicializa el combo
    $("#campo").html('')
    var options = "<option value='-1'>Seleccionar CampoX</option>";
    
    for (x=0;x < campos_array.length;x++){
         CAMPOS_ARRAY[campos_array[x].campo]= $.trim(campos_array[x].liblibrarian);   
         options+= "<option value=" + campos_array[x].campo +" >" + campos_array[x].campo + "</option>";
    }
    $("#campo").append(options);
    enable_disableSelects();

}


function enable_disableSelects(){

    $("#campo").removeAttr('disabled');
    $("#subcampo").removeAttr('disabled');

    if ( $('#campoX').val() == -1){
         $("#campo").attr('disabled',true);
         $("#subcampo").attr('disabled',true);
    }else{
        if ( $('#campo').val() == -1){
            $("#subcampo").attr('disabled',true);
        }
    }
}

function eleccionCampo(){
    if ($("#campo").val() != -1){
        objAH               = new AjaxHelper(updateEleccionCampo);
        objAH.debug         = true;
        objAH.showOverlay   = true;  
        objAH.url           = URL_PREFIX+"/catalogacion/visualizacionOPAC/visualizacionOpacDB.pl";
        objAH.campo         = $('#campo').val();
        objAH.tipoAccion    = "GENERAR_ARREGLO_SUBCAMPOS";
        objAH.sendToServer();
    }else{
        enable_disableSelects();
    }
}

//se genera el combo en el cliente
function updateEleccionCampo(responseText){

    $('#nombre_campo').html(CAMPOS_ARRAY[$("#campo").val()]);
    //Arreglo de Objetos Global
    var subcampos_array = JSONstring.toObject(responseText);
    //se inicializa el combo
    $("#subcampo").html('');

    var options = "<option value='-1'>Seleccionar SubCampo</option>";
    
    for (x=0;x < subcampos_array.length;x++){

        var subcampo            = new Object;    
        subcampo.liblibrarian   = '';
        subcampo.obligatorio    = '';
        subcampo.liblibrarian   =  $.trim(subcampos_array[x].liblibrarian);
        subcampo.obligatorio    = $.trim(subcampos_array[x].obligatorio); 
        SUBCAMPOS_ARRAY[ subcampos_array[x].subcampo ]= subcampo;

        options+= "<option value=" + subcampos_array[x].subcampo +" >" + subcampos_array[x].subcampo + "</option>";
    }
    //se agrega la info al combo
    $("#subcampo").append(options);
    enable_disableSelects();
}

function agregarAyudaMarc(){

    objAH               = new AjaxHelper(updateAgregarVisualizacion);
    objAH.debug         = true;
    objAH.showOverlay   = true;
    objAH.url           = URL_PREFIX+"/admin/ayudaMarc/ayudaMarcDB.pl";
    objAH.tipoAccion    = 'AGREGAR_VISUALIZACION';
    var campo           = $.trim($("#campo").val());
    var subcampo        = $.trim($("#subcampo").val());
    var ayuda           = $.trim($("#ayuda").val());  
      
    if ( (campo) && (subcampo) && (ayuda) ){
        objAH.campo         = campo;
        objAH.subcampo      = subcampo;
        objAH.ayuda         = ayuda;   
        $('#addAyudaMarcForm').modal('hide');
        startOverlay();
        objAH.sendToServer();
    }else{
        jAlert(SELECCIONE_VISTA_OPAC);
    }
    
}

function updateAgregarVisualizacion(responseText){
    hideAyudaMarcShow();
    var Messages        = JSONstring.toObject(responseText);
    setMessages(Messages);
    if (! (hayError(Messages) ) ){
        mostrarTabla(); 
    }   
}

function modificarAyudaMarc(id){

    objAH               = new AjaxHelper(updateModificarAyudaMarc);
    objAH.debug         = true;
    objAH.showOverlay   = true;
    objAH.idAyuda       = id;
    objAH.url           = URL_PREFIX+"/admin/ayudaMarc/ayudaMarcDB.pl";
    objAH.tipoAccion    = 'MOD_VISUALIZACION';
    var campo           = $.trim($("#campoMod").val());
    var subcampo        = $.trim($("#subcampoMod").val());
    var ayuda           = $.trim($("#ayudaMod").val());  
      
    if ( (campo) && (subcampo) && (ayuda) ){
        objAH.campo         = campo;
        objAH.subcampo      = subcampo;
        objAH.ayuda         = ayuda;    
        objAH.sendToServer();
    }else{
        jAlert(SELECCIONE_VISTA_OPAC);
    }  
}

function updateModificarAyudaMarc(responseText){
    $('#resultAyudaMarcMod').modal('hide');
    var Messages        = JSONstring.toObject(responseText);
    setMessages(Messages);
    if (! (hayError(Messages) ) ){
        mostrarTabla(); 
    }   
}

function eliminarAyudaMarc(id){

    objAH               = new AjaxHelper(updateModificarAyudaMarc);
    objAH.debug         = true;
    objAH.showOverlay   = true;
    objAH.idAyuda       = id;
    objAH.url           = URL_PREFIX+"/admin/ayudaMarc/ayudaMarcDB.pl";
    objAH.tipoAccion    = 'ELIMINAR';
    
    objAH.sendToServer();
}

function mostrarTabla(){
    objAH               = new AjaxHelper(updateMostrarTabla);
    objAH.debug         = true;
    objAH.showOverlay   = true;
    objAH.url           = URL_PREFIX+"/admin/ayudaMarc/ayudaMarcDB.pl";
    objAH.tipoAccion    = 'LISTAR';

    objAH.sendToServer();
}

function updateMostrarTabla(responseText){
    $("#resultAyudaMarc").html(responseText);
}


function showModificarAyudaMarc(id){
    objAH                   = new AjaxHelper(updateShowModificarAyudaMarc);
    objAH.showOverlay       = true;
    objAH.url               = URL_PREFIX+"/admin/ayudaMarc/ayudaMarcDB.pl";
    objAH.idAyuda           = id;
    objAH.tipoAccion        = 'SHOW_MOD_AYUDA';
    objAH.sendToServer();
}

function updateShowModificarAyudaMarc(responseText){
    $('#resultAyudaMarcMod').html(responseText);
    $('#resultAyudaMarcMod').modal();
}

$(document).ready(function() {
    mostrarTabla();
});
  