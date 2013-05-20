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
 * Libreria para poder usar 2 paginadores con el plugin de jquery.tablesorted.js
 * El paginador (div) esta en includes/paginadorTabla.inc Debe ser incluido
 * Libreria hecha por nosostros para poder manejar dos paginadores.
 */

function inicializacion(tabla){
	var paginador=$("div[name='paginador']");

	for (var i=0; i< paginador.length; i++){
		paginador[i].id="pager"+i;
	}
	tabla.tablesorterPager({container: $("#pager0")})
	     .tablesorterPager({container: $("#pager1")});

	var pager0=$("#pager0");
	pager0.css({position:""});
	var pager1=$("#pager1");
	pager1.css({position:""});
	$(config.cssPageDisplay).attr("readonly","readonly");
	igualarPaginadores();
}


//Se crean funciones para el evento click de las imagenes, para igualar los display de los paginadores.
function igualarPaginadores(){
	$(config.cssFirst).click(function() {
		igualarDis();
		return false;
	});
	$(config.cssNext).click(function() {
		igualarDis();
		return false;
	});
	$(config.cssPrev).click(function() {
		igualarDis();
		return false;
	});
	$(config.cssLast).click(function() {
		igualarDis();
		return false;
	});
	$(config.cssPageSize).change(function() {
			$(".pager").css({position:""});
			igualarDis();
			$(config.cssPageSize).val(this.value);
			return false;
	});
}

//Iguala los displays de los paginadores, cambiando a la nueva pagina que se paso.
function igualarDis(){
	var s=$(config.cssPageDisplay);
	for(var i=0;i<s.length;i++){
		s.val((config.page+1) + config.seperator + config.totalPages);
	}
}