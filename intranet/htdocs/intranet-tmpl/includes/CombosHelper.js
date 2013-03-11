/*
 * LIBRERIA CombosHelper.js
 * Esta es una libreria creada para el sistema KOHA
 * Para poder utilizarla es necesario incluir en el tmpl la libreria jquery.js
 *
 */

array_info_combo= 0; //para guardar las opciones de los combos que se generan en el cliente

//esta funcion obtiene un arreglo asociativo con todas la UI para crear un SELECT en el cliente
function getOptionsComboUI(){
    objAH=new AjaxHelper(updateGetOptionsComboUI);
    objAH.showOverlay       = true;
    objAH.debug= true;
    objAH.url=URL_PREFIX+"/utils/utilsDB.pl";
    objAH.tipoAccion="GENERAR_ARREGLO_UI";
    objAH.sendToServer();
}

function updateGetOptionsComboUI(responseText){
     array_info_combo= JSONstring.toObject(responseText);
}
