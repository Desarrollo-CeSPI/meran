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


//28/11/07
//Navegador para mantener en cache las paginas visitadas con Ajax
//**********************************************Navegador***************************************************

var cacheArray= new Array();
var indSig= -1;
var indAnt= -1;
var actual= -1;
var topeMax= 3;

//@IdDiv es el id del div donde se tira la cache
//@funcion es una funcion pasada por parametro q se ejecuta luego de ejecutar ant() 
function ant(IdDiv, funcion){

	//recupero de cache
	$('#'+IdDiv).html(cacheArray[indAnt]);
	//seteo el estado en cached
	$('#'+IdDiv).attr('state', 'cached');
	indAnt--;
	indSig= indAnt + 1;
	if(funcion){
 		funcion();
	}
// 		alert('ant ' + indAnt + ' sig ' + indSig + ' tope ' + tope);
	habilitarBotones();
}

function sig(IdDiv, funcion){
	indSig++;
	//recupero de cache
	$('#'+IdDiv).html(cacheArray[indSig]);
	//seteo el estado en cached
	$('#'+IdDiv).attr('state', 'cached');
	indAnt= indSig - 1;
	if(funcion){
 		funcion();
	}
// 		alert("sig" + indSig + " ant " + indAnt + ' tope ' + tope);
	habilitarBotones();
}

function habilitarBotones(){
	if((indSig > -1)&&(indSig < actual)){
		$('#sig').show();
	}else{
		$('#sig').hide();
	}
	
	if(indAnt > -1){
		$('#ant').show();
	}else{
		$('#ant').hide();
	}
}

function pushCache(info, IdDiv){
 	indSig++;
	actual++;
alert('push cache');

// 	if(indSig == topeMax){
	if(actual == topeMax){
		cacheArray= cacheArray.slice(1,cacheArray.length);
// 		indSig--;
		indSig= cacheArray.length;
// 		tope--;
		actual= cacheArray.length;
// 		alert("indSig " + indSig + " indAnt " + indAnt);
	}
	//guardo en cache
	cacheArray[indSig]= info;
	//actualizo estado
	$('#'+IdDiv).attr('state', 'none');
	//actualizo ant
	indAnt= indSig - 1;
// 	alert("sig " + indSig + " ant " + indAnt + ' tope ' + tope);

	habilitarBotones();
}	

//*******************************************Fin***Navegador************************************************