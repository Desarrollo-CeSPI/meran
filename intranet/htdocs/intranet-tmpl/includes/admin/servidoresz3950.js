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

function save(action){
    if(action == '1'){
        validateAddForm(guardarNewServer)
        $('#form_adding_server').submit();
    }else{
        validateEditForm(guardarServer)
        $('#form_editing_server').submit();
    }
}

function actualizarTabla(){
    objAH               = new AjaxHelper(updateActualizarTabla);
	objAH.debug         = true;
	objAH.url           = URL_PREFIX+"/admin/catalogo/MARC/z3950DB.pl";
    objAH.showOverlay   = true;
	objAH.tipoAccion    = "ACTUALIZAR_TABLA_SERVERS";
	objAH.sendToServer();
}

function updateActualizarTabla(responseText){
    $("#result").html(responseText);
    zebra('datos_tabla');
}

function addServer(){
    objAH               = new AjaxHelper(updateAddServer);
	objAH.debug         = true;
	objAH.url           = URL_PREFIX+"/admin/catalogo/MARC/z3950DB.pl";
    objAH.showOverlay   = true;
	objAH.tipoAccion    = "AGREGAR_SERVIDOR";
	objAH.sendToServer();
}

function updateAddServer(responseText){
    $("#addServer").show();
    $("#addServer").html(responseText);
}

function guardarServer(){
    objAH               = new AjaxHelper(updateGuardarServer);
	objAH.debug         = true;
	objAH.url           = URL_PREFIX+"/admin/catalogo/MARC/z3950DB.pl";
    objAH.showOverlay   = true;
    objAH.servidor      = $('#server').val();
    objAH.puerto        = $('#puerto').val();
    objAH.base          = $('#base').val();
    objAH.usuario       = $('#usuario').val();
    objAH.password      = $('#password').val();
    objAH.nombre        = $('#nombre').val();
    objAH.sintaxis      = $('#sintaxis').val();
    objAH.habilitado    = $('#habilitado').attr('checked');
    objAH.id_servidor   = $('#id_server').val();
	objAH.tipoAccion    = "GUARDAR_MODIFICACION_SERVIDOR";
	objAH.sendToServer();
}

function updateGuardarServer(responseText){
    var Messages=JSONstring.toObject(responseText);
	setMessages(Messages);
	$('#addServer').hide();
    actualizarTabla();
}

function guardarNewServer(){
    objAH               = new AjaxHelper(updateGuardarNewServer);
	objAH.debug         = true;
	objAH.url           = URL_PREFIX+"/admin/catalogo/MARC/z3950DB.pl";
    objAH.showOverlay   = true;
    objAH.servidor      = $('#server').val();
    objAH.puerto        = $('#puerto').val();
    objAH.base          = $('#base').val();
    objAH.usuario       = $('#usuario').val();
    objAH.password      = $('#password').val();
    objAH.nombre        = $('#nombre').val();
    objAH.sintaxis      = $('#sintaxis').val();
    objAH.habilitado    = $('#habilitado').attr('checked');
	objAH.tipoAccion    = "GUARDAR_NUEVO_SERVIDOR";
	objAH.sendToServer();
}

function updateGuardarNewServer(responseText){
    var Messages=JSONstring.toObject(responseText);
	setMessages(Messages);
	$('#addServer').hide();
    actualizarTabla();
}

function editServer(id_server){
    objAH               = new AjaxHelper(updateEditServer);
	objAH.debug         = true;
	objAH.url           = URL_PREFIX+"/admin/catalogo/MARC/z3950DB.pl";
    objAH.showOverlay   = true;
    objAH.id_servidor   = id_server;
    objAH.tipoAccion    = "EDITAR_SERVIDOR";
	objAH.sendToServer();
}

function updateEditServer(responseText){
    $('#addServer').show();
    $('#addServer').html(responseText);
}

function deleteServer(id_server){
    objAH               = new AjaxHelper(updateDeleteServer);
	objAH.debug         = true;
	objAH.url           = URL_PREFIX+"/admin/catalogo/MARC/z3950DB.pl";
    objAH.showOverlay   = true;
    objAH.id_servidor   = id_server;
    objAH.tipoAccion    = "ELIMINAR_SERVIDOR";
	objAH.sendToServer();
}

function updateDeleteServer(responseText){
    var Messages=JSONstring.toObject(responseText);
	setMessages(Messages);
    actualizarTabla();
}

function disableServer(id_server){
    objAH               = new AjaxHelper(updateDisableServer);
	objAH.debug         = true;
	objAH.url           = URL_PREFIX+"/admin/catalogo/MARC/z3950DB.pl";
    objAH.showOverlay   = true;
    objAH.id_servidor   = id_server;
    objAH.tipoAccion    = "DESHABILITAR_SERVIDOR";
	objAH.sendToServer();
}

function updateDisableServer(responseText){
    var Messages=JSONstring.toObject(responseText);
	setMessages(Messages);
    actualizarTabla();
}

function validateAddForm(func){
    $().ready(function() {
        // validate signup form on keyup and submit
        $.validator.setDefaults({
             submitHandler:  func ,
        });
        $('#form_adding_server').validate({
            errorElement: "em",
            errorClass: "error_adv",
            rules: {
                      server:   "required",
                      puerto:   "number",  
                      base:     "required", 
                      usuario:  "required",              
                      password: "required",
                      nombre:   "required",             
                      sintaxis: "required",
                    },
             messages: {
                      server:   POR_FAVOR_INGRESE_SERVER_SERVIDOR,
                      puerto:   POR_FAVOR_INGRESE_PUERTO_SERVIDOR,
                      base:     POR_FAVOR_INGRESE_BASE_SERVIDOR,
                      usuario:  POR_FAVOR_INGRESE_USUARIO_SERVIDOR,
                      password: POR_FAVOR_INGRESE_PASSWORD_SERVIDOR, 
                      nombre:   POR_FAVOR_INGRESE_NOMBRE_SERVIDOR,
                      sintaxis: POR_FAVOR_INGRESE_SINTAXIS_SERVIDOR,
                    }, 
             });
        });        
}

function validateEditForm(func){
    $().ready(function() {
        // validate signup form on keyup and submit
        $.validator.setDefaults({
             submitHandler:  func ,
        });
        $('#form_editing_server').validate({
            errorElement: "em",
            errorClass: "error_adv",
            rules: {
                      server:   "required",
                      puerto:   "number",  
                      base:     "required", 
                      usuario:  "required",              
                      password: "required",
                      nombre:   "required",             
                      sintaxis: "required",
                    },
             messages: {
                      server:   POR_FAVOR_INGRESE_SERVER_SERVIDOR,
                      puerto:   POR_FAVOR_INGRESE_PUERTO_SERVIDOR,
                      base:     POR_FAVOR_INGRESE_BASE_SERVIDOR,
                      usuario:  POR_FAVOR_INGRESE_USUARIO_SERVIDOR,
                      password: POR_FAVOR_INGRESE_PASSWORD_SERVIDOR, 
                      nombre:   POR_FAVOR_INGRESE_NOMBRE_SERVIDOR,
                      sintaxis: POR_FAVOR_INGRESE_SINTAXIS_SERVIDOR,
                    }, 
             });
        });        
}
