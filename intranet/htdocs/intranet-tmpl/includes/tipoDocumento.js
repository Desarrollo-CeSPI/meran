$(document).ready(function() {
    mostrarTabla();
});

function agregarTipoDeDocumento(){
    $('#addTipoDocumento').modal();
}

// function agregarTipoDeDocumento(){
//     objAH               = new AjaxHelper(updateAgregarTipoDeDocumento);
//     objAH.debug         = true;
//     objAH.showOverlay   = true;
//     objAH.url           = URL_PREFIX+"/catalogacion/tipoDocumentoDB.pl";
//     objAH.tipoAccion    = 'AGREGAR_TIPO_DE_DOCUMENTO';

//     objAH.sendToServer();
// }

// function updateAgregarTipoDeDocumento(responseText){
//     var Messages = JSONstring.toObject(responseText);
//     setMessages(Messages);
//     mostrarTabla();
// }

function mostrarTabla(){
    objAH               = new AjaxHelper(updateMostrarTabla);
    objAH.debug         = true;
    objAH.showOverlay   = true;
    objAH.url           = URL_PREFIX+"/catalogacion/tipoDocumentoDB.pl";
    objAH.tipoAccion    = 'LISTAR';

    objAH.sendToServer();
}

function updateMostrarTabla(responseText){
    $("#resultTipoDocumento").html(responseText);
}

function modificarTipoDocumento(idTipoDoc){

    objAH               = new AjaxHelper(updateModificarTipoDocumento);
    objAH.debug         = true;
    objAH.showOverlay   = true;
    objAH.idTipoDoc     = idTipoDoc;
    objAH.url           = URL_PREFIX+"/catalogacion/tipoDocumentoDB.pl";
    objAH.tipoAccion    = 'SHOW_MOD_TIPO_DOC';

    objAH.sendToServer();

}

function updateModificarTipoDocumento(responseText){
    $('#accionesTipoDocumento').html(responseText);
    $('#accionesTipoDocumento').modal();
}

function eliminarTipoDocumento(idTipoDoc){
    objAH               = new AjaxHelper(updateEliminarTipoDocumento);
    objAH.debug         = true;
    objAH.showOverlay   = true;
    objAH.idTipoDoc     = idTipoDoc;
    objAH.url           = URL_PREFIX+"/catalogacion/tipoDocumentoDB.pl";
    objAH.tipoAccion    = 'DEL_TIPO_DOC';

    objAH.sendToServer();
}

function updateEliminarTipoDocumento(responseText){
    var Messages = JSONstring.toObject(responseText);
    setMessages(Messages);
    mostrarTabla();
}

function guardarModificacion(){
    $('#accionesTipoDocumento').modal('hide');
    $('#modTipoDocumento').submit();
    startOverlay();
}

function guardarTipoDoc(){
    $('#addTipoDocumento').modal('hide');
    $('#addTipoDocumentoForm').submit();
    startOverlay();
}