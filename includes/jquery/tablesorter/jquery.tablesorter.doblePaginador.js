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