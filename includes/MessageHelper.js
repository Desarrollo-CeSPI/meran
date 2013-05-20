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
 * LIBRERIA MessageHelper v 1.0.1
 * Esta es una libreria creada para el sistema KOHA
 * Para poder utilizarla es necesario incluir en el tmpl la libreria jquery.js
 * @author Carbone Miguel
 * Fecha de creacion 09/09/2008
 *
 */
/*
* En esta libreria se denerian manejar todos los mensajes de respuesta desde el servidor al cliente,
* ya sean de error, informacion, warnings, etc
*/

// FIXME 
//Faltaria manejar mejor el log, opcion debug idem a demas helpers


// TODO armar objeto
// function MessageHelper(){
//     //defino las propiedades  
// //     this.nombre                     = obj.nombre;
// 
//     function fClearMessages(){     
//         $('#mensajes').css({opacity:0,"filter":"alpha(opacity=0)"});
//         $('#mensajes').hide();
//         $('#mensajes').html(''); 
//     };
//     
//     //metodos
//     this.clearMessages = fClearMessages;
// 
// }

function clearMessages(){
	$('#end_top').html("<div id='mensajes' class='alert hide pagination-centered'><a class='close' data-dismiss='alert'>x</a><br /> </div>");
}

function verificarRespuesta(responseText){
    if (responseText == 0){
        jAlert(DATOS_ENVIADOS_INCORRECTOS,'Info', 'errboxid');
        return(0);
    }else{
        return (1);
    }
}
//Esta funcion setea varios mensajes enviados desde el servidor
function setMessages(Messages_hashref){
//@params
//Message.messages, arreglo de mensajes mensaje para el usuario
//Message.error, error=1 o 0

//Mensajes:
//Message.error, hay error (error=1)
//Message.messages: [message_1, message_2, ... , message_n]
//message1: 	codMsg: 'U324'
//		message: 'Texto para informar'
	var hayError = 0;
    try{
         _createContentMessages();
        var i;
        //se agregan todos los mensajes
        if (Messages_hashref.error == 1)
            $('#mensajes').addClass('alert-error');
        if (Messages_hashref.success == 1)
            $('#mensajes').addClass('alert-success');
        hayError = Messages_hashref.error;
        for(i=0;i<Messages_hashref.messages.length;i++){
            $('#mensajes').append('<p>' + Messages_hashref.messages[i].message + '</p>');
            
        }
        $('#mensajes').removeClass('hide');
        $('html, body').animate({scrollTop:0}, 'slow');
        _delay(clearMessages, 60);
    }
    catch (e){
      // We do nothing ;)
    }
    
    return hayError;
}

//crea el contenedor para los mensajes, si ya esta creado, borra el contenido
function _createContentMessages(){

	var contenedor = $('#mensajes')[0];

	if(contenedor == null){
     //no existe el contenedor, se crea
		//console.log("MessageHelper: Se crea el div cotenedor");
		$('#end_top').append("<div id='mensajes' class='alert hide pagination-centered'><a class='close' data-dismiss='alert'>×</a><br /> </div>"); //faltaria agregar la clase warning, success o danger
	}
	else{
    //existe el contenedor, lo limpio
        clearMessages();
	}
}

//luego de x segundos se ejecuta la funcion pasada por parametro
function _delay(funcion, segundos){
	setTimeout(funcion, segundos*1000);
}

function hayError(msg){
	if (msg.error == 1)
		return (true);

	return (false);
}
