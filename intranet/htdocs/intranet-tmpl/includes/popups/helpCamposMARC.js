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