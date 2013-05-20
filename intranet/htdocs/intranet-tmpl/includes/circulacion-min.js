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

var comp;var INFO_PRESTAMOS_ARRAY=new Array();var objAH;function infoPrestamo(){this.id3='';this.id3Old='';this.tipoPrestamo;}
function objeto_usuario(){this.text;this.ID;}
function detalleUsuario(nro_socio){objAH=new AjaxHelper(updateInfoUsuario);objAH.debug=true;objAH.cache=true;objAH.showOverlay=true;objAH.url=URL_PREFIX+'/circ/detalleUsuario.pl';objAH.nro_socio=nro_socio;objAH.sendToServer();}
function updateInfoUsuario(responseText){$('#detalleUsuario').slideDown('slow');$('#detalleUsuario').html(responseText);}
function detalleSanciones(nro_socio){objAH=new AjaxHelper(updateDetalleSanciones);objAH.debug=true;objAH.showOverlay=true;objAH.url=URL_PREFIX+'/usuarios/reales/detalleSanciones.pl';objAH.nro_socio=nro_socio;objAH.sendToServer();}
function updateDetalleSanciones(responseText){$('#sanciones').slideDown('slow');$('#sanciones').html(responseText);}
function detalleReservas(nro_socio,funcion){objAH=new AjaxHelper(funcion);objAH.debug=true;objAH.showOverlay=true;objAH.url=URL_PREFIX+'/circ/detalleReservas.pl';objAH.nro_socio=nro_socio;objAH.sendToServer();}
function updateInfoReservas(responseText){$('#tablaReservas').slideDown('slow');$('#tablaReservas').html(responseText);zebra('tablaReservas');checkedAll('checkAllReservas','chkboxReservas');}
function detallePrestamos(nro_socio,funcion){objAH=new AjaxHelper(funcion);objAH.debug=true;objAH.showOverlay=true;objAH.url=URL_PREFIX+'/circ/detallePrestamos.pl';objAH.nro_socio=nro_socio;objAH.sendToServer();}
function updateInfoPrestamos(responseText){$('#tablaPrestamos').slideDown('slow');$('#tablaPrestamos').html(responseText);zebra('tablaPrestamos');checkedAll('checkAllPrestamos','chkboxPrestamos');}
function realizarAccion(accion,id_table,funcion){var chck=$('#'+id_table).find(':checked');var array=new Array;var long=chck.length;if(long==0){jAlert(ELIJA_AL_MENOS_UN_EJEMPLAR);}else{for(var i=0;i<long;i++){array[i]=chck[i].value;}
objAH=new AjaxHelper(funcion);objAH.debug=true;objAH.showOverlay=true;objAH.url=URL_PREFIX+"/circ/circulacionDB.pl";objAH.tipoAccion=accion;objAH.datosArray=array;objAH.nro_socio=USUARIO.ID;objAH.sendToServer();}}
function generaDivPrestamo(responseText){var infoArray=new Array;infoArray=JSONstring.toObject(responseText);var html="<div id='div_circ_rapida_devolucion' class=''>";var accion;accion=PRESTAMO_STRING;html+="<div class='modal-header'><a href='#' class='close' data-dismiss='modal'>×</a><h3>"+accion+"</h3></div>";html+="<div class='modal-body'>";var i;for(i=0;i<infoArray.length;i++){var coma="";html+="<p>";html+="<dl>";var infoPrestamoObj=new infoPrestamo();infoPrestamoObj.id3Old=infoArray[i].id3Old;INFO_PRESTAMOS_ARRAY[i]=infoPrestamoObj;var comboItems=crearComboDeItems(infoArray[i].items,'comboItems'+i,infoArray[i].id3Old);var comboTipoPrestamo=crearComboDeItems(infoArray[i].tipoPrestamo,'tiposPrestamos'+i);if((infoArray[i].autor!="")&&(infoArray[i].autor!=null)){html+="<dt>";html=html+infoArray[i].autor;html+="</dt>";};if((infoArray[i].titulo!="")&&(infoArray[i].titulo!=null)){html+="<dd>";html=html+infoArray[i].titulo;if((infoArray[i].edicion!="")&&(infoArray[i].edicion!=null)){html=html+", "+infoArray[i].edicion};html+="</dd>";};html+="</dl>";html=html+"<br>C&oacute;digo de barras: "+comboItems;html=html+"<br>Tipo de pr&eacute;stamo: "+comboTipoPrestamo;html+="</p>";}
html=html+"</div>";html=html+"<div class='modal-footer'><button class='btn btn-primary' onClick='prestar(1)'>Prestar</button></div>";html=html+"</div>";$('#confirmar_div').html(html);$('#confirmar_div').modal();}
function crearComboDeItems(items_array,idSelect,itemSelected){var opciones='';var html="<select id='"+idSelect+"'>";var i;for(i=0;i<items_array.length;i++){opciones=opciones+"<option value="+items_array[i].value;if((itemSelected)&&(itemSelected==items_array[i].value)){opciones=opciones+" selected ";}
opciones=opciones+">"+items_array[i].label+"</option>";}
html=html+opciones+"</select>";return html;}
function prestar(is_modal){for(var i=0;i<INFO_PRESTAMOS_ARRAY.length;i++){INFO_PRESTAMOS_ARRAY[i].id3=$('#comboItems'+i).val();INFO_PRESTAMOS_ARRAY[i].barcode=$("#comboItems"+i+" option:selected").text();INFO_PRESTAMOS_ARRAY[i].tipoPrestamo=$('#tiposPrestamos'+i).val();INFO_PRESTAMOS_ARRAY[i].descripcionTipoPrestamo=$("#tiposPrestamos"+i+" option:selected").text();}
objAH=new AjaxHelper(updateInfoPrestarReserva);objAH.debug=true;objAH.showOverlay=true;objAH.url=URL_PREFIX+'/circ/circulacionDB.pl';objAH.tipoAccion='PRESTAMO';objAH.datosArray=INFO_PRESTAMOS_ARRAY;objAH.nro_socio=USUARIO.ID;objAH.sendToServer();if(is_modal)
$('#confirmar_div').modal('hide');}
function updateInfoPrestarReserva(responseText){cancelarDiv();var infoHash=JSONstring.toObject(responseText);var messageArray=infoHash.messages;var ticketsArray=infoHash.tickets;var mensajes='';var hayError=0;for(i=0;i<messageArray.length;i++){setMessages(messageArray[i]);}
for(i=0;i<messageArray.length;i++){if(messageArray[i].error){hayError=1;}}
if(!hayError){imprimirTicket(ticketsArray);}
detalleReservas(USUARIO.ID,updateInfoReservas);ejemplaresDelGrupo(ID_N2);}
function cancelarDiv(){$('#confirmar_div').html('');}
function cancelarReserva(reserveNumber){bootbox.confirm(ESTA_SEGURO_QUE_DESEA_CANCELAR_LA_RESERVA,function(ok){if(ok){objAH=new AjaxHelper(updateInfoCancelacion);objAH.debug=true;objAH.showOverlay=true;objAH.url=URL_PREFIX+'/circ/circulacionDB.pl';objAH.tipoAccion='CANCELAR_RESERVA';objAH.nro_socio=USUARIO.ID;objAH.id_reserva=reserveNumber;objAH.sendToServer();}});}
function updateInfoCancelacion(responseText){var Messages=JSONstring.toObject(responseText);setMessages(Messages);detalleReservas(USUARIO.ID,updateInfoReservas);}
function generaDivDevolucion(responseText){var infoArray=new Array;INFO_PRESTAMOS_ARRAY=new Array();infoArray=JSONstring.toObject(responseText);var html="<div id='div_circ_rapida_devolucion' class=''>";var accion=infoArray[0].accion;html+="<div class='modal-header'><a href='#' class='close' data-dismiss='modal'>×</a><h3>"+infoArray[0].accion+"</h3></div>";html+="<div class='modal-body'><dl>";for(var i=0;i<infoArray.length;i++){INFO_PRESTAMOS_ARRAY[i]=infoArray[i].id_prestamo;html+="<dt>";if((infoArray[i].autor!="")&&(infoArray[i].autor!=null)){html=html+infoArray[i].autor;if((infoArray[i].titulo!="")&&(infoArray[i].titulo!=null)){html=html+", ";}}else{html+="SIN AUTOR";}
html+="</dt>";html+="<dd>";if((infoArray[i].titulo!="")&&(infoArray[i].titulo!=null)){html=html+infoArray[i].titulo;}
if((infoArray[i].edicion!="")&&(infoArray[i].edicion!=null)){html=html+" - "+infoArray[i].edicion+"<br>"};html=html+" ("+infoArray[i].barcode+")<br>"
html+="</dd>";}
html=html+"</div>";html=html+"<div class='modal-footer'><button class='btn btn-primary' onClick='devolver(1)'>Devolver</button></div>";html=html+"</div>";$('#confirmar_div').html(html);$('#confirmar_div').modal();}
function generaDivRenovacion(responseText){var infoArray=new Array;INFO_PRESTAMOS_ARRAY=new Array();infoArray=JSONstring.toObject(responseText);var html="<div id='div_circ_rapida_devolucion' class=''>";var accion=infoArray[0].accion;html="<div class='modal-header'><a href='#' class='close' data-dismiss='modal'>×</a><h3>"+infoArray[0].accion+"</h3></div>";html+="<div class='modal-body'><dl>";for(var i=0;i<infoArray.length;i++){var infoDevRenObj=new infoPrestamo();infoDevRenObj.nro_socio=infoArray[0].nro_socio;infoDevRenObj.id_prestamo=infoArray[i].id_prestamo;infoDevRenObj.id3=infoArray[i].id3;infoDevRenObj.barcode=infoArray[i].barcode;INFO_PRESTAMOS_ARRAY[i]=infoDevRenObj;html+="<dt>";if((infoArray[i].autor!="")&&(infoArray[i].autor!=null)){html=html+infoArray[i].autor;if((infoArray[i].titulo!="")&&(infoArray[i].titulo!=null)){html=html+", ";}}else{html+="SIN AUTOR";}
html+="</dt>";html+="<dd>";if((infoArray[i].titulo!="")&&(infoArray[i].titulo!=null)){html=html+infoArray[i].titulo;}
if((infoArray[i].edicion!="")&&(infoArray[i].edicion!=null)){html=html+" - "+infoArray[i].edicion+"<br>"};html=html+" ("+infoArray[i].barcode+")<br>"
html+="</dd>";}
html=html+"</div>";html=html+"<div class='modal-footer'><button class='btn btn-primary' onClick='renovar()'>Renovar</button></div>";html=html+"</div>";$('#confirmar_div').html(html);$('#confirmar_div').modal();}
function renovar(){objAH=new AjaxHelper(updateInfoRenovar);objAH.debug=true;objAH.showOverlay=true;objAH.url=URL_PREFIX+'/circ/circulacionDB.pl';objAH.tipoAccion='REALIZAR_RENOVACION';objAH.datosArray=INFO_PRESTAMOS_ARRAY;objAH.nro_socio=USUARIO.ID;$('#confirmar_div').modal('hide');objAH.sendToServer();}
function updateInfoRenovar(responseText){cancelarDiv();var infoHash=JSONstring.toObject(responseText);var messageArray=infoHash.messages;var ticketsArray=infoHash.tickets;var hayError=0;setMessages(messageArray);for(i=0;i<messageArray.length;i++){setMessages(messageArray[i]);}
for(i=0;i<messageArray.length;i++){if(messageArray[i].error){hayError=1;}}
if(!hayError){imprimirTicket(ticketsArray);}
detallePrestamos(USUARIO.ID,updateInfoPrestamos);ejemplaresDelGrupo(ID_N2);}
function devolver(is_modal){objAH=new AjaxHelper(updateInfoDevolver);objAH.debug=true;objAH.showOverlay=true;objAH.url=URL_PREFIX+'/circ/circulacionDB.pl';objAH.tipoAccion='REALIZAR_DEVOLUCION';objAH.datosArray=INFO_PRESTAMOS_ARRAY;objAH.nro_socio=USUARIO.ID;objAH.sendToServer();if(is_modal)
$('#confirmar_div').modal('hide');}
function updateInfoDevolver(responseText){}
function imprimirTicket(tickets){var comprobantes=new Array();if(tickets.length>0){for(i=0;i<tickets.length;i++){comprobantes[i]=tickets[i];}}
comp=JSONstring.make(comprobantes);if(AUTO_GENERAR_COMPROBANTE==1){window.open(URL_PREFIX+"/circ/ticket.pl?token="+token+"&comp="+comp,this.href);window.close();}
$('#ticket').load(URL_PREFIX+"/circ/ticket.pl?token="+token+"&comp="+comp,this.href);$('#ticket').hide();linkComp="<a onclick=mostrarComprobante();>Imprimir</a>";$('#mensajes').append(linkComp);}
function mostrarComprobante(responseText){window.open(URL_PREFIX+"/circ/ticket.pl?token="+token+"&comp="+comp,this.href);}