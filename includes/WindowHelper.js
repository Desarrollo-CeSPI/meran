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
 * LIBRERIA WindowHelper v 1.0.1
 * Esta es una libreria creada para el sistema KOHA
 * Para poder utilizarla es necesario incluir en el tmpl la libreria jquery.js
 * @author Rajoy Gaspar, Carbone Miguel
 * Fecha de creacion 09/12/2008
 *
 */


//Funciones Privadas para manejar el estado del la consulta de AJAX

function _WinInit(objWin){
	_WinAddDiv(objWin);
}

function _WinAddDiv(objWin){

	var contenedor = $('#ventana')[0];
	var opciones= {};
	var d_height= document.height;
	var d_width= document.width;	
	var dimmer= {height: d_height, width: d_width };

  	if( (contenedor == null)&&(objWin.dimmer_On == true) ){
		//se crea el dimmer que bloquea el fondo
		$('body').append("<div id='dimmer' class='dimmer' style='height:" + dimmer.height + "px; width: " + dimmer.width + "px;top: 0px; visibility: visible; position:absolute'></div>");
 	}
    
    //se crea la ventana 
        $('body').append("<div id='ventana' class='dimming' style='display:none; height:85%; width:85%; top:10px;'><div class='winHeader'><img align='right' id='cerrar' src='"+imagesForJS+'/cerrar.png'+"'/><span width=100px>" + objWin.titulo + "</span></div><div id='ventanaContenido' class='ventanaContenido' style='height:90%; width:100%; top:10px;'></div></div>");


	$('#ventanaContenido').html(objWin.html);	


	if(objWin.opacity == true){
		opciones.opacity= '0.7777';	
	}

	if(objWin.draggable == true){
		$('#ventana').draggable(opciones);
	}else{
		$('#ventana').draggable('disable');
	}
	
	//se crea el evento onClick para el boton cerrar
	$('#cerrar').click( function (){objWin.close()} );

	objWin.log();

}

//Esta funcion sirve para centrar un objeto
jQuery.fn.centerObject = function(options) {
// FIXME se deberia tener en cuenta centrar un div con conetnido
	var obj = this;
	var total= 0;
	var dif= 0;

	//se calcula el centro verticalmente
	if($(window).scrollTop() == 0){
		obj.css('top',  $(window).height()/2 - this.height()/2);
	}else{
	//se hizo scroll
	
		total= $(window).height() + $(window).scrollTop();
		dif= total - $(window).height();
		obj.css('top', dif + ( $(window).height() )/2);
	}

	//se calcula el centro horizontalmente
	obj.css('left',$(window).width()/2 - this.width()/2);

	if(options){
		if( (options.debug)&&(window.console) ){
			console.log(	"centerObject => \n" +
					"Total Vertical: " + total + "\n" + 
					"Dif: " + dif + "\n" + 
					"Medio: " + (dif + ( $(window).height() )/2) +
					"\n" +
					"Total Horizontal: " + $(window).width() + "\n" + 
					"Medio: " +  $(window).width()/2
			);
		}
	}

}



function WindowHelper(options){

	this.debug= false;  //para debuggear
	this.titulo= '';
	this.html= '';		//respuesta del servidor, responseText
	this.dimmer= '';	//oscurecimiento y bloqueo del fondo
    this.dimmer_On= true;  //muestra o no el dimmer
	this.showState= true;   //muestra o no el gif animado
	this.draggable= true;  //para configurar si se quiere que la ventana sea draggable o no
	this.focus= ''; //para el auto_focus, recibe el id del input al que se le va hacer foco

 	if(options.draggable == false){
		this.draggable= options.draggable;
 	}	

	this.opacity= true;	//opacidad de la ventana

	if(options.opacity == false){
		this.opacity= options.opacity;
 	}	
	
	this.auto_focus= function(){
		if(this.focus != ''){
			$('#'+this.focus).focus();	
		}
	}//end auto_focus

	this.close= function(){
			//se oculta la ventana
			$('#ventana').hide();
			$('#dimmer').hide();
			//se elimina el objeto
/*			delete this;*/
	}//end hide

	this.height= function(height){
			//se modifica el ancho
			$('#ventana').height(height);
	}//end height

	this.width= function(width){
			//se modifica el ancho
			$('#ventana').width(width);
	}//end height

	this.create= function(){
			//crea una ventana
			_WinInit(this);

	}//end create

	this.open= function(){
			//se muestra la ventana
			$('#ventana').centerObject();
			$('#ventana').show();
			this.auto_focus();
			if(this.dimmer_On == true){$('#dimmer').show();}
	}//end show

	this.log= function(){
		//se loguea 
		if( (this.debug)&&(window.console) ){
				console.log(" 	WindowHelper => create() " + "\n" +
						"opacity: " + this.opacity + "\n" +	
						"draggable: " + this.draggable + "\n" +
						"width: " + $(window).width() + "\n" +
						"height: " + $(window).height() + "\n"
				);
		}
	}

}


