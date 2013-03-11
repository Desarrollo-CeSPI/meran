/*
* LIBRERIA datosPresupuesto v 1.0.0
* Esta es una libreria creada para el sistema KOHA
* Contendran las funciones para editar un presupuesto
* Fecha de creación 12/11/2010
*
*/

var test;


function presupuestosParaPedidoCotizacion(){
                 objAH                     = new AjaxHelper(updatePresupuestosParaPedidoCotizacion);
                 objAH.url                 = URL_PREFIX+'/adquisiciones/mostrarComparacion.pl';
                 objAH.debug               = true;
                 objAH.showOverlay         = true;
                 objAH.pedido_cotizacion   = $('#combo_pedidos').val();
                 objAH.tipoAccion          = 'MOSTRAR_PRESUPUESTOS_PEDIDO';
                 objAH.sendToServer();
}


function updatePresupuestosParaPedidoCotizacion(responseText){
   $('#comparacion').html(responseText);
}
