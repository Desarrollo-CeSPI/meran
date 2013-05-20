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
