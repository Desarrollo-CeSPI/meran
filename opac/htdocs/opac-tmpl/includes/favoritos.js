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
* Libreria para menejar los favoritos de OPAC
* Contendran las funciones para permitir la circulacion en el sistema
*/



function consultarFavoritos(){

	objAH=new AjaxHelper(updateConsultarFavoritos);
    objAH.showOverlay       = true;
  	objAH.debug= true;
	objAH.url= 'opac-privateshelfs.pl';
	//se setea la funcion para cambiar de pagina
	objAH.funcion= 'changePage';
	//se envia la consulta
	objAH.sendToServer();
}

function updateConsultarFavoritos(responseText){

	$('#datosUsuario').slideUp('slow');
    $('#resultHistoriales').slideUp('slow');
	$('#result').html(responseText);
    $('#result').show();
// 	pushCache(responseText, 'result');
	zebra('zebra');

	checkedAll('todos','checkbox');
}

function agregarAFavoritos(){

	var chck=$("input[@name=checkbox]:checked");
	var array= new Array;
	var long=chck.length;
	if ( long == 0){
		alert("Seleccione un ejemplar para agregar a Favoritos");
	}
	else{

		for(var i=0; i< long; i++){
			array[i]=chck[i].value;
		}
		
		objAH=new AjaxHelper(updateAgregarAFavoritos);
        objAH.showOverlay       = true;
		objAH.debug= true;
		objAH.url= 'opac-privateshelfsDB.pl';
		objAH.datosArray= array;
		objAH.Accion= 'ADD';
		//se envia la consulta
		objAH.sendToServer();
	}
}

function updateAgregarAFavoritos(){
	consultarFavoritos();
}

function borrarDeFavoritos(){

// 	var result="";
// //hacer con jquery
// 	var checks=document.getElementsByTagName("input");
// 	if (checks.length>0){
// 		for(i=0;i<checks.length;i++)
// 		{
// 			if((checks[i].type == "checkbox")&&(checks[i].checked)){ 		
// 				result= result + checks[i].name + '#';
// 			}
// 		}       
// 	}
// // 	params= result;



	var chck=$("input[@name=checkbox]:checked");
	var array= new Array;
	var long=chck.length;
	if ( long == 0){
		alert("Seleccione un ejemplar para eliminar de Favoritos");
	}
	else{

		for(var i=0; i< long; i++){
			array[i]=chck[i].value;
		}
		
		objAH=new AjaxHelper(updateAgregarAFavoritos);
        objAH.showOverlay       = true;
		objAH.debug= true;
		objAH.url= 'opac-privateshelfsDB.pl';
		objAH.datosArray= array;
		objAH.Accion= 'DELETE';
		//se envia la consulta
		objAH.sendToServer();	
	}
	
}

function obtenerFavoritos(){
    objAH=new AjaxHelper(updateObtenerFavoritos);
    objAH.showOverlay       = true;
    objAH.debug= true;
    objAH.url=URL_PREFIX+'/opac-favoritosDB.pl';
    objAH.action='get_favoritos';
    objAH.sendToServer();
}

function updateObtenerFavoritos(responseText){
        if (!verificarRespuesta(responseText))
            return(0);
        $('#mis_favoritos').html(responseText);
        zebra('datos_tabla');
}

function eliminarFavorito(id_favorito){
	
            objAH=new AjaxHelper(updateEliminarFavorito);
            objAH.showOverlay       = false;
            objAH.debug= true;
            objAH.url=URL_PREFIX+'/opac-favoritosDB.pl';
            objAH.action='delete_favorite';
            objAH.id1=id_favorito;
            objAH.sendToServer();
    
}

function updateEliminarFavorito(responseText){
        if (!verificarRespuesta(responseText))
            return(0);
        $('#mis_favoritos').html(responseText);
}