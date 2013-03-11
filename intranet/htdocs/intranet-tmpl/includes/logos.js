function listarLogos(){
    objAH               = new AjaxHelper(updateListarLogos);
    objAH.debug         = true;
    objAH.showOverlay   = true;
    objAH.url           = URL_PREFIX+'/admin/logosDB.pl';
    objAH.tipoAccion    = 'LISTAR';
    objAH.sendToServer();
}

function updateListarLogos(responseText){
    if (!verificarRespuesta(responseText))
        return(0);
    $('#logos_ajax').html(responseText);
}

function eliminarLogo(id){
   objAH                   = new AjaxHelper(updateEliminarLogo);
   objAH.showOverlay       = true;
   objAH.url               = URL_PREFIX+'/admin/logosDB.pl';
   objAH.idLogo            = id;
   objAH.context           = 'intranet';
   objAH.tipoAccion        = 'DEL_LOGO';
   objAH.sendToServer();
}

function updateEliminarLogo(responseText){
   if (!verificarRespuesta(responseText))
    return(0);
    indexLogos();
}

function listarLogosUI(){
    objAH               = new AjaxHelper(updateListarLogosUI);
    objAH.debug         = true;
    objAH.showOverlay   = true;
    objAH.url           = URL_PREFIX+'/admin/logosDB.pl';
    objAH.tipoAccion    = 'LISTAR_UI';
    objAH.sendToServer();
}

function updateListarLogosUI(responseText){
    if (!verificarRespuesta(responseText))
        return(0);
    $('#logos_ajax_ui').html(responseText);
}

function eliminarLogoUI(id){
    objAH                   = new AjaxHelper(updateEliminarLogoUI);
    objAH.showOverlay       = true;
    objAH.url               = URL_PREFIX+'/admin/logosDB.pl';
    objAH.idLogo            = id;
    objAH.context           = 'intranet';
    objAH.tipoAccion        = 'DEL_LOGO_UI';
    objAH.sendToServer();
}

function updateEliminarLogoUI(responseText){
    if (!verificarRespuesta(responseText))
        return(0);
    indexLogos();
}

function indexLogos(){
    startOverlay();
    listarLogos();
    listarLogosUI();
}

function agregarPortada_show(){
    $('#agregarLogoForm').modal();
} 
  
function submitForm(){
    $('#agregarLogoForm').modal('hide');
    startOverlay();
    $('#formAgregarLogo').submit();
}

function modificarLogo(id){
    objAH                   = new AjaxHelper(updateModificarLogo);
    objAH.showOverlay       = true;
    objAH.url               = URL_PREFIX+'/admin/logosDB.pl';
    objAH.idLogo            = id;
    objAH.tipoAccion        = 'SHOW_MOD_LOGO';
    objAH.sendToServer();
}

function updateModificarLogo(responseText){
    if (!verificarRespuesta(responseText))
          return(0);
    $('#agregarLogoForm').html(responseText);
    $('#agregarLogoForm').modal();
}

function agregarPortada_showUI(){
    $('#agregarLogoUIForm').modal();
} 
  
function submitFormUI(){
    $('#agregarLogoUIForm').modal('hide');
    startOverlay();
    $('#agregarLogoUIForm').submit();
}

function modificarLogoUI(id){
  objAH                   = new AjaxHelper(updateModificarLogoUI);
  objAH.showOverlay       = true;
  objAH.url               = URL_PREFIX+'/admin/logosDB.pl';
  objAH.idLogo            = id;
  objAH.tipoAccion        = 'SHOW_MOD_LOGO_UI';
  objAH.sendToServer();
}

function updateModificarLogoUI(responseText){
  if (!verificarRespuesta(responseText))
        return(0);
    $('#agregarLogoUI').html(responseText);
    $('#agregarLogoUI').modal();
}

function agregarPortada_showUI(){
    $('#agregarLogoUI').modal();
} 
  
function submitFormUI(){
    $('#agregarLogoUI').modal('hide');
    startOverlay();
    $('#agregarLogoUIForm').submit();
}

function modificarLogo(id){
    objAH                   = new AjaxHelper(updateModificarLogo);
    objAH.showOverlay       = true;
    objAH.url               = URL_PREFIX+'/admin/logosDB.pl';
    objAH.idLogo            = id;
    objAH.tipoAccion        = 'SHOW_MOD_LOGO_UI';
    objAH.sendToServer();
}

function updateModificarLogo(responseText){
    if (!verificarRespuesta(responseText))
        return(0);
    $('#agregarLogoUI').html(responseText);
    $('#agregarLogoUI').modal();
}

$(document).ready(function() {
    indexLogos();
});