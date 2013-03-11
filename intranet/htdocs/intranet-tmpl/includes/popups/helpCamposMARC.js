/*
 * LIBRERIA helpCamposMARC v 1.0.0
 * Esta es una libreria creada para el sistema KOHA
 * Para poder utilizarla es necesario incluir en el tmpl la libreria jquery.js
 * 
 * El fin de la libreria es centralizar el manejo de la ventan de ayuda de campos MARC
 */

function abrirVentanaHelperMARC(){
    objAH           = new AjaxHelper(updateAbrirVentanaHelperMARC);
// FIXME parametrizar /blue/
    objAH.url       = '/intranet-tmpl/includes/popups/helpCamposMARC.inc';
    objAH.debug     = true;
    objAH.sendToServer();
}

function updateAbrirVentanaHelperMARC(responseText){
    $('#ayuda_marc_content').html(responseText);
//     $('#windowHelp').dialog({ width: 510 });
    
    $("#ayuda_marc_content").modal();    
}