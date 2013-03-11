function eliminarPublicacion(id_novedad){

    jConfirm(SEGURO_OCULTAR_NOVEDAD,OPAC_ALERT_TITLE, function(confirmStatus){
        if (confirmStatus){
            objAH                   = new AjaxHelper(updateEliminarPublicacion);
            objAH.showOverlay       = false;
            objAH.debug             = true;
            objAH.url               = URL_PREFIX+'/opac-novedadesDB.pl';
            objAH.id_novedad        = id_novedad;
            objAH.tipoAccion        = 'DELETE_NOVEDAD';
            objAH.sendToServer();
        } 
    
    })
}

function updateEliminarPublicacion(responseText){
    actualizarTabla();
}


function actualizarTabla(){
    $("#resultNovedades").append("<img src="+imagesForJS+"/loaders/facebook_style_green.gif alt=[% 'Cargando..' | i18n %] style='border:0;' />");
    objAH               = new AjaxHelper(updateActualizarTabla);
    objAH.debug         = true;
    objAH.url           = URL_PREFIX+'/opac-novedadesDB.pl';
    objAH.showOverlay   = false;
    objAH.tipoAccion    = "ACTUALIZAR_TABLA_NOVEDADES";
    objAH.sendToServer();
}

function updateActualizarTabla(responseText){
    $("#resultNovedades").html(responseText);
}