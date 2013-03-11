/*
* Libreria para menejar la circulacion del OPAC
* Contendran las funciones para permitir la circulacion en el sistema
*/

/*
* Funcion Ajax que hace una reserva
*/
var BUTTON_ID = 0;

function showReservar(id){
	$('#'+id).modal();
}


function hideReservar(id){
	$('#modal_reservar_'+id).modal('hide');
}

function reservar(id1, id2){

	hideReservar(id2);
	objAH               = new AjaxHelper(updateInfoReserva);
    objAH.debug         = true;
    objAH.showOverlay   = true;
    //para busquedas combinables
    objAH.url           = URL_PREFIX+'/opac-reservar.pl';
    objAH.id1           = id1;
    objAH.id2           = id2;
    objAH.sendToServer();
    
        
}

/*
* Funcion que muestra la informacion de las reservas
*/
function updateInfoReserva(responseText){
    var Messages = JSONstring.toObject(responseText);
    setMessages(Messages);
    
    infoReservas();
    infoSanciones();
}

/*
* Funcion Ajax que cancela una reserva
*/
function cancelarReserva(id_reserva){


    bootbox.confirm(ESTA_SEGURO_QUE_DESEA_CANCELAR_RESERVA,function(confirmStatus){
        if (confirmStatus){
        
            objAH               = new AjaxHelper(updateInfoCancelarReserva);
            objAH.debug         = true;
            objAH.showOverlay   = true;
            objAH.url           = URL_PREFIX+'/reservasDB.pl';
            objAH.id_reserva    = id_reserva;
            objAH.accion        = 'CANCELAR_RESERVA';
            objAH.sendToServer();
            
        }
    });
}

/*
* Funcion que muestra el mensaje al usuario, luego de cancelar una reserva
*/
function updateInfoCancelarReserva(responseText){
//  objJSON= JSONstring.toObject(responseText);
//  showMessage(objJSON.message);
    var Messages = JSONstring.toObject(responseText);
    setMessages(Messages);
    DetalleReservas();
    infoReservas();
}
/*
* Funcion que llama a cancelar una reserva
*/
function cancelarYReservar(reserveNumber,id1Nuevo,id2Nuevo){

    objAH               = new AjaxHelper(updateInfoCancelarReserva);

    objAH.debug         = true;
    objAH.showOverlay   = true;
    objAH.url           = URL_PREFIX+'/reservasDB.pl';
    objAH.reserveNumber = reserveNumber;
    objAH.id1Nuevo      = id1Nuevo;
    objAH.id2Nuevo      = id2Nuevo;
    objAH.accion        = 'CANCELAR_Y_RESERVAR';

    objAH.sendToServer();
}

/*
* Funcion que hace consulta Ajax para renovar un prestamo del usuario
*/
function renovar(id_prestamo){

    objAH               = new AjaxHelper(updateInfoRenovar);
    objAH.debug         = true;
    objAH.showOverlay   = true;
    //para busquedas combinables
    objAH.url           = URL_PREFIX+'/opac-renovar.pl';
    objAH.id_prestamo   = id_prestamo;
    objAH.sendToServer();
}

/*
* Funcion que muestra mensajes al usuario luego de renovar un prestamo
*/
function updateInfoRenovar(responseText){
//  var infoArray= JSONstring.toObject(responseText);
//  var mensajes= '';
//  for(i=0; i<infoArray.length;i++){
//      mensajes= mensajes + infoArray[i].message + '<br>';
//  }
//  $('#mensajes font').html(mensajes);
    var Messages = JSONstring.toObject(responseText);
    setMessages(Messages);
    DetallePrestamos(); 
}

/*
* Funcion que hace consulta Ajax para obtener el detalle de las reservas del usuario
*/
function DetalleReservas(){

    objAH           = new AjaxHelper(updateDetalleReserva);
    objAH.showOverlay       = true;
    objAH.debug     = true;
    //para busquedas combinables
    objAH.url       = URL_PREFIX+'/opac-info_reservas.pl';
    objAH.action    = 'detalle_asignadas';
    objAH.sendToServer();
}

/*
* Funcion que muestra el detalle de las reservas del usuario
*/
function updateDetalleReserva(responseText){

    //si estoy logueado, oculta la informacion del usuario
    if (responseText != 0){
        $('#detalleReservas').html(responseText);
        $('#detalleReservas').slideDown('slow');
        $('#datosUsuario').slideDown('slow');
        $('#result').slideUp('slow');
    }
}

/*
* Funcion que hace consulta Ajax para obtener el detalle de los prestamos del usuario
*/
function DetallePrestamos(){

    objAH               = new AjaxHelper(updateDetallePrestamo);
    objAH.debug         = true;
    objAH.showOverlay   = true;
    //para busquedas combinables
    objAH.url           = URL_PREFIX+'/opac-DetallePrestamos.pl';
//  objAH.borrowernumber= borrowernumber;
    objAH.sendToServer();
}

/*
* Funcion que muestra el detalle de los prestamos del usuario
*/
function updateDetallePrestamo(responseText){
    
    //si estoy logueado, oculta la informacion del usuario
    $('#detallePrestamos').html(responseText);
    $('#detallePrestamos').slideDown('slow');   

}

function infoReservas(){
    objAH           = new AjaxHelper(updateInfoReservas);
    objAH.debug     = true;
    objAH.url       = URL_PREFIX+'/opac-info_reservas.pl';
    objAH.action    = 'detalle_espera';
    objAH.sendToServer();
}

function updateInfoReservas(responseText){
    $('#info_reservas').html(responseText);
}

function infoSanciones(){
    objAH               = new AjaxHelper(updateInfoSanciones);
    objAH.debug         = true;
    objAH.url           = URL_PREFIX+'/opac-info_sanciones.pl';
    objAH.sendToServer();
}

function updateInfoSanciones(responseText){
    $('#info_sanciones').html(responseText);
}


function addFavorite(id1,button_id){
    objAH               = new AjaxHelper(updateAddFavorite);
    objAH.debug         = false;
    objAH.showOverlay   = true;
    objAH.url           = URL_PREFIX+'/opac-favoritosDB.pl';
    objAH.action        = 'add_favorite';
    objAH.id1           = id1;
    objAH.sendToServer();
    BUTTON_ID				= button_id;
    
}

function updateAddFavorite(responseText){
    if (responseText == 0)
        jAlert(FAVORITE_ADDED_ERROR,CATALOGO_TITLE);
    else
        $('#'+BUTTON_ID).html(responseText);
}


function deleteFavorite(id1,button_id,from_busqueda){
    objAH                   = new AjaxHelper(updateDeleteFavorite);
    objAH.debug             = true;
    objAH.showOverlay       = false;
    objAH.url               = URL_PREFIX+'/opac-favoritosDB.pl';
    objAH.action            = 'delete_favorite';
    objAH.id1               = id1;
    if (from_busqueda)
        objAH.from_busqueda= 1;

    objAH.sendToServer();
    BUTTON_ID				= button_id;
}

function updateDeleteFavorite(responseText){
    if (responseText == 0)
        jAlert(FAVORITE_DELETED_ERROR);
    else
        $('#'+BUTTON_ID).html(responseText);

}
