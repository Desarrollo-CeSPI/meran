var objAH;var fromDetail=false;function objeto_usuario(){this.text;this.ID;}
function ordenar(orden){objAH.sort(orden);}
function changePage(ini){objAH.changePage(ini);}
function updateEliminarUsuario(responseText){var Messages=JSONstring.toObject(responseText);setMessages(Messages);if(!(hayError(Messages))){window.location.href=URL_PREFIX+"/usuarios/potenciales/buscarUsuario.pl?token="+token;}}
function detalleUsuario(){objAH=new AjaxHelper(updateDetalleUsuario);objAH.url=URL_PREFIX+'/usuarios/potenciales/detalleUsuario.pl';objAH.debug=true;objAH.showOverlay=true;objAH.nro_socio=usuario.ID;objAH.sendToServer();}
function updateDetalleUsuario(responseText){$('#detalleUsuario').html(responseText);}
function habilitar(){var checks=$("#result input[@type='checkbox']:checked");var array=checks.get();var theStatus="";var personNumbers=new Array();var cant=checks.length;var accion=$("#accion").val();if(cant>0){theStatus=HABILITAR_POTENCIALES_CONFIRM;for(i=0;i<checks.length;i++){personNumbers[i]=array[i].value;}
if(cant>0){bootbox.confirm(theStatus,function(ok){if(ok)
actualizarPersonas(cant,personNumbers);});}}
else{jAlert(NO_SE_SELECCIONO_NINGUN_USUARIO);}}
function habilitarDesdeDetalle(nro_socio){var personas_array=new Array();personas_array[0]=nro_socio;actualizarPersonas(1,personas_array);}
function actualizarPersonas(cant,arrayPersonNumbers){objAH=new AjaxHelper(updateInfoActualizar);objAH.url=URL_PREFIX+"/usuarios/potenciales/usuariosPotencialesDB.pl";objAH.debug=true;objAH.showOverlay=true;objAH.cantidad=cant;var tipoAccion="HABILITAR_PERSON";try{if($("#accion").val())
tipoAccion=$("#accion").val();else
fromDetail=true;}
catch(e){}
objAH.tipoAccion=tipoAccion;objAH.id_personas=arrayPersonNumbers;objAH.funcion="changePage";objAH.sendToServer();}
function updateInfoActualizar(responseText){var Messages=JSONstring.toObject(responseText);setMessages(Messages);if(!fromDetail)
buscarUsuariosPotenciales();}
function eliminarPermanentemente(nro_socio){bootbox.confirm(CONFIRMA_LA_ELIMINACION,function(ok){if(ok){bootbox.confirm(CONFIRMA_LA_BAJA,function(status){if(status){var objAH=new AjaxHelper(updateEliminarPermanentemente);objAH.url=URL_PREFIX+"/usuarios/potenciales/usuariosPotencialesDB.pl";objAH.debug=true;objAH.showOverlay=true;objAH.nro_socio=nro_socio;objAH.tipoAccion="ELIMINAR_PERMANENTEMENTE";objAH.sendToServer();}});}});}
function updateEliminarPermanentemente(responseText){var Messages=JSONstring.toObject(responseText);setMessages(Messages);if(!(hayError(Messages))){window.location.href=URL_PREFIX+"/usuarios/potenciales/buscarUsuario.pl?token="+token;}}