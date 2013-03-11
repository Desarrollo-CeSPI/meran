/*
* LIBRERIA datosPresupuesto v 1.0.0
* Esta es una libreria creada para el sistema KOHA
* Contendran las funciones para editar un presupuesto
* Fecha de creación 12/11/2010
*
*/

var test;
//*********************************************Editar Presupuesto********************************************* 


function modificarDatosDePresupuesto(){
        
        $("#tablaResult").tabletojson({
            headers: "Renglon,Cantidad,Articulo,Precio Unitario, Total",
            attribHeaders: "{}",
            returnElement: "#table",
            complete: function(x){
                 objAH                     = new AjaxHelper(updateDatosPresupuesto);
                 objAH.url                 = URL_PREFIX+'/adquisiciones/presupuestoDB.pl';
                 objAH.debug               = true;
                 objAH.showOverlay         = true;
                 objAH.id_presupuesto      = $('#id_pres').val();
                 objAH.table               = JSONstring.toObject(x);
                 objAH.tipoAccion          = 'GUARDAR_MODIFICACION_PRESUPUESTO';
                 objAH.sendToServer();
            }
        })
   
}
//     var table = $('#tablaResult');
//     var renglones= new Array();
//     
//     $('#tablaResult tr').each(function (i, item){
//                 renglones[i]=$(this).find("name=renglon");                 
//                 valor= renglones[i].val();              
//                 $('#tablaResult td').each(function(i,item){
          
/*                              alert(item.html().val());*/  
                      /* });*/ 
//   });
//     test = renglones;

function procesarPlanilla(){
                 objAH                     = new AjaxHelper(updateDatosPresupuesto);
                 objAH.url                 = URL_PREFIX+'/adquisiciones/presupuestoDB.pl';
                 objAH.debug               = true;
                 objAH.showOverlay         = true;
                 objAH.id_proveedor        = $('#id_prov').val();
                 objAH.tipoAccion          = 'GUARDAR_MODIFICACION_PRESUPUESTO';
                 objAH.sendToServer();
}


function updateDatosPresupuesto(responseText){
    if (!verificarRespuesta(responseText))
        return(0);
    var Messages=JSONstring.toObject(responseText);
    setMessages(Messages);
}

function mostrarPresupuesto(){
                 objAH                     = new AjaxHelper(updateMostrarPresupuesto);
                 objAH.url                 = URL_PREFIX+'/adquisiciones/presupuestoDB.pl';
                 objAH.debug               = true;
                 objAH.showOverlay         = true;
                 objAH.filepath            = $('#myUploadFile').val();
                 objAH.tipoAccion          = 'MOSTRAR_PRESUPUESTO';
                 objAH.sendToServer();
}


function updateMostrarPresupuesto(responseText){
   $('#presupuesto').html(responseText);
}

function mostrarPresupuestoManual(){
                 objAH                     = new AjaxHelper(updateMostrarPresupuestoManual);
                 objAH.url                 = URL_PREFIX+'/adquisiciones/presupuestoDB.pl';
                 objAH.debug               = true;
                 objAH.showOverlay         = true;
                 objAH.id_presupuesto      = $('#combo_presupuesto').val();
                 objAH.tipoAccion          = 'MOSTRAR_PRESUPUESTO_MANUAL';
                 objAH.sendToServer();
}


function updateMostrarPresupuestoManual(responseText){
   $('#presupuesto_manual').html(responseText);
}


function changePage(ini){
    objAH.changePage(ini);
}
