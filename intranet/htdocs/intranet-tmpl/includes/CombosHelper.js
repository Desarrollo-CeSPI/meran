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
