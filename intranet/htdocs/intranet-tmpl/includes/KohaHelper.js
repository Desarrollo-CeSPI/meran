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
 * LIBRERIA KohaHelper v 1.0.1
 * Esta es una libreria creada para el sistema KOHA
 * Para poder utilizarla es necesario incluir en el tmpl la libreria jquery.js
 *
 */

function usuariosConectados(){
	objAH=new AjaxHelper(updateInfoUsuariosConectados);
    objAH.showOverlay       = true;
	objAH.url= URL_PREFIX+'/KohaDB.pl';
// 	objAH.borrowernumber= borrower;
	//se envia la consulta
	objAH.tipo= 'USUARIOS_CONECTADOS';
	objAH.sendToServer();
}


function _AddDiv(){

	var contenedor = $('#state')[0];
	if(contenedor == null){
		$('body').append("<div id='stateUsers' class='loading' style='position:absolute'></div>");
		$('#state').css('top', '0px');
		$('#state').css('left', '0px');

	}
}

function updateInfoUsuariosConectados(responseText){
	$('#stateUsers').html("Usuarios Conectados: " + responseText);
	resfreshUsuariosConectados();
}

function resfreshUsuariosConectados(){
	var segundos= 10;
	setTimeout(usuariosConectados, segundos*1000);
}

//Init Form
$(document).ready(function() {
	
// 	_AddDiv();
// 	resfreshUsuariosConectados();

});
