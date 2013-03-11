var objAH_usuarios;var shouldScrollUser=true;var globalSearchTemp;function ordenar(orden){objAH_usuarios.sort(orden);}
function changePage_usuarios(ini){objAH_usuarios.changePage(ini);}
function consultarBar(filtro,doScroll){if(doScroll)
shouldScrollUser=doScroll;objAH_usuarios=new AjaxHelper(updateInfoUsuariosBar);objAH_usuarios.showOverlay=true;objAH_usuarios.cache=true;busqueda=jQuery.trim($('#socio-bar').val());inicial='0';if(jQuery.trim(busqueda).length>0){objAH_usuarios.url=URL_PREFIX+'/usuarios/reales/buscarUsuarioResult.pl';objAH_usuarios.showOverlay=true;objAH_usuarios.debug=true;objAH_usuarios.funcion='changePage_usuarios';objAH_usuarios.socio=busqueda;objAH_usuarios.sendToServer();}}
function consultar(filtro,doScroll){if(doScroll)
shouldScrollUser=doScroll;objAH_usuarios=new AjaxHelper(updateInfoUsuarios);objAH_usuarios.showOverlay=true;objAH_usuarios.cache=true;busqueda=jQuery.trim($('#socio').val());inicial='0';if(filtro){inicial=filtro;busqueda=jQuery.trim(filtro);objAH_usuarios.inicial=inicial;$('#socio').val(FILTRO_POR+filtro);}
else
{if(busqueda.substr(8,5).toUpperCase()=='TODOS'){busqueda=busqueda.substr(8,5);$('#socio').val(busqueda);consultar(busqueda);}
else
{if(busqueda.substr(0,6).toUpperCase()=='FILTRO'){busqueda=busqueda.substr(8,1);$('#socio').val(busqueda);consultar(busqueda);}}}
if(jQuery.trim(busqueda).length>0){objAH_usuarios.url=URL_PREFIX+'/usuarios/reales/buscarUsuarioResult.pl';objAH_usuarios.showOverlay=true;objAH_usuarios.debug=true;objAH_usuarios.funcion='changePage_usuarios';objAH_usuarios.socio=busqueda;objAH_usuarios.sendToServer();}
else{jAlert(INGRESE_UN_DATO,USUARIOS_ALERT_TITLE);$('#socio').focus();}}
function updateInfoUsuarios(responseText){$('#marco_contenido_datos').html(responseText);$('#resultBusqueda').html("");var idArray=[];var classes=[];idArray[0]='socio';classes[0]='nomCompleto';classes[1]='documento';classes[2]='legajo';classes[3]='tarjetaId';busqueda=jQuery.trim($('#socio').val());scrollTo('marco_contenido_datos');}
function updateInfoUsuariosBar(responseText){updateInfoUsuarios(responseText);}
function Borrar(){$('#socio').val('');}
function checkFilter(eventType){var str=$('#socio').val();if(eventType.toUpperCase()=='FOCUS'){if(str.substr(0,6).toUpperCase()=='FILTRO'){globalSearchTemp=$('#socio').val();Borrar();}}
else
{if(jQuery.trim($('#socio').val())=="")
$('#socio').val(globalSearchTemp);}}