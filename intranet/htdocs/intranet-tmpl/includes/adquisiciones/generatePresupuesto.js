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

/*
 * LIBRERIA generatePresupuesto v 0.0.9
 * Esta es una libreria creada para el sistema Meran
 * Contendran las funciones para la generacion de presupuestos
 * y pedidos de cotizacion para la compra de ejemplares
 * Fecha de creacion 07/02/2011
 */ 
 
 
/******************************************************** AGREGAR PRESUPUESTO **************************************************/

var arreglo                  = new Array() //global, arreglo con las recomendaciones seleccionadas
var array_proveedores        = new Array() //global, arreglo de ids de proveedores a generar presupuesto

function presupuestar(position){
    var pos = position
    objAH                       = new AjaxHelper(updatePresupuestar)
    objAH.url                   = URL_PREFIX+'/adquisiciones/pedidoCotizacionDB.pl'
    objAH.debug                 = true
    objAH.showOverlay           = true
        
    objAH.pedido_cotizacion_id  = $('#pedido_cotizacion_id'+position).val()
 
    objAH.tipoAccion            = 'PRESUPUESTAR'
    objAH.sendToServer()  
    $('#pedidoCotizacion'+position).css('background-color', 'blue')
    $('#pedido_cotizacion_selected').val($('#pedido_cotizacion_id'+position).val())
}
  
function updatePresupuestar(responseText){
    $('#presupuesto').html(responseText)
    $('#presupuesto').show()
}

function generatePresupuesto(pedido_cotizacion_id){

    var proveedores = getProveedoresSelected()
    if(proveedores == ""){
        jConfirm(POR_FAVOR_SELECCIONE_PROVEEDORES_A_PRESUPUESTAR)
        return false
    }

    objAH                       = new AjaxHelper(updateAgregarPresupuesto)
    objAH.url                   = URL_PREFIX+'/adquisiciones/presupuestoDB.pl'
    objAH.debug                 = true
    objAH.showOverlay           = true

    objAH.proveedores_array     = getProveedoresSelected()
    objAH.pedido_cotizacion_id  = pedido_cotizacion_id
          
    objAH.tipoAccion            = 'AGREGAR_PRESUPUESTO'
    objAH.sendToServer()  
}

function updateAgregarPresupuesto(responseText){
    if (!verificarRespuesta(responseText))
            return(0);
    var Messages=JSONstring.toObject(responseText);
    setMessages(Messages);
    
    exportar()
}

function getProveedoresSelected(){
    array_proveedores = new Array()
    var i = 0
    $('#proveedor option:selected').each(function(){  
        array_proveedores[i] = $(this).val()
        i++
    })
    return array_proveedores
}

/************************************************************ FIN - AGREGAR PRESUPUESTO ******************************************/





/************************************************************ EXPORTACIONES  *********************************************/

function exportar(){

    var proveedores = getProveedoresSelected()
    if(proveedores == ""){
        jConfirm(POR_FAVOR_SELECCIONE_PROVEEDORES_A_PRESUPUESTAR)
        return false
    }

    objAH                       = new AjaxHelper(updateExportarPresupuesto)
    objAH.url                   = URL_PREFIX+'/adquisiciones/presupuestoDB.pl'
    objAH.debug                 = true
    objAH.showOverlay           = true

    objAH.proveedores_array     = proveedores
    objAH.pedido_cotizacion_id  = $('#pedido_cotizacion_selected').val()
          
    objAH.tipoAccion            = 'EXPORTAR_PRESUPUESTO'
    objAH.sendToServer() 
 
}

function updateExportarPresupuesto(responseText){
    $('#links').html(responseText)
    $('#links').show()
}

/************************************************************ FIN - EXPORTACIONES ********************************************/
