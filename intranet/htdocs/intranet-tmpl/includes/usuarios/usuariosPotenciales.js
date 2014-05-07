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

var objAH;
var fromDetail = false;
//*
/*
 * objeto_usuario
 * Representa al objeto que contendra la informacion del usuario seleccionado del autocomplete.
 */
function objeto_usuario(){
    this.text;
    this.ID;
}

function ordenar(orden){
    objAH.sort(orden);
}

function changePage(ini){
    objAH.changePage(ini);
}

// FIXME ver que cuando el usuario no haya borrado, no redireccione
function updateEliminarUsuario(responseText){
    var Messages=JSONstring.toObject(responseText);
    setMessages(Messages);
    if (!(hayError(Messages))){
        window.location.href = URL_PREFIX+"/usuarios/potenciales/buscarUsuario.pl?token="+token;
    }
}

//*********************************************Fin***Eliminar Usuario**********************************************

function detalleUsuario(){
    objAH=new AjaxHelper(updateDetalleUsuario);
    objAH.url=URL_PREFIX+'/usuarios/potenciales/detalleUsuario.pl';
    objAH.debug= true;
    objAH.showOverlay = true;
    objAH.nro_socio= usuario.ID;
    objAH.sendToServer();
}

function updateDetalleUsuario(responseText){
    $('#detalleUsuario').html(responseText);
}

function habilitar(){
	var checks=$("#tablaResult input[@type='checkbox']:checked");
	var array=checks.get();
	var theStatus="";
	var personNumbers=new Array();
	var cant=checks.length;
	var accion=$("#accion").val();
	if (cant>0){
		theStatus= ($("#accion").val() == "HABILITAR_PERSON")?HABILITAR_POTENCIALES_CONFIRM:DESHABILITAR_POTENCIALES_CONFIRM; 
	
		for(i=0;i<checks.length;i++){
			personNumbers[i]=array[i].value;
		}

		if (cant>0){
			bootbox.confirm(theStatus, function (ok){ 
									if (ok)
										actualizarPersonas(cant,personNumbers);
			}
			);
		}
	}
	else{ jAlert (NO_SE_SELECCIONO_NINGUN_USUARIO);}
}	

function habilitarDesdeDetalle(nro_socio){
	var personas_array = new Array();
	personas_array[0] = nro_socio;
	actualizarPersonas(1,personas_array);
}

function actualizarPersonas(cant,arrayPersonNumbers){
	objAH=new AjaxHelper(updateInfoActualizar);
	objAH.url= URL_PREFIX+"/usuarios/potenciales/usuariosPotencialesDB.pl";
	objAH.debug= true;
	objAH.showOverlay = true;
	objAH.cantidad= cant;
	var tipoAccion = "HABILITAR_PERSON";

	try{
		if ($("#accion").val())
			tipoAccion = $("#accion").val();
		else
			fromDetail = true;
	}
	catch (e){}

	objAH.tipoAccion= tipoAccion;
	objAH.id_personas= arrayPersonNumbers;
	objAH.funcion= "changePage";
	objAH.sendToServer();
}

function updateInfoActualizar(responseText){

 	var Messages=JSONstring.toObject(responseText);
 	setMessages(Messages);
	
	if (!fromDetail)
		buscarUsuariosPotenciales();
}

function eliminarPermanentemente(nro_socio){
	bootbox.confirm(CONFIRMA_LA_ELIMINACION, function (ok){ 
		if (ok){
			bootbox.confirm(CONFIRMA_LA_BAJA, function (status){ 
				if (status){
				    var objAH=new AjaxHelper(updateEliminarPermanentemente);

				    objAH.url=URL_PREFIX+"/usuarios/potenciales/usuariosPotencialesDB.pl";
				    objAH.debug= true;
				    objAH.showOverlay = true;
				    objAH.nro_socio= nro_socio;
				    objAH.tipoAccion= "ELIMINAR_PERMANENTEMENTE";
				    objAH.sendToServer();
				}
			});
		}
	});
}

function updateEliminarPermanentemente(responseText){
 	var Messages=JSONstring.toObject(responseText);
 	setMessages(Messages);
	if (!(hayError(Messages))){
		window.location.href = URL_PREFIX+"/usuarios/potenciales/buscarUsuario.pl?token="+token;
	}
 	
}


