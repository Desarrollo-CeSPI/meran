
//opac-searchFunciones.js
//*******************************************Para agregar a Favoritos*******************************************


// function busquedaCombinable(){
//     objAH                   = new AjaxHelper(updateBusquedaCombinable);
//     objAH.debug             = true;
//     objAH.showOverlay       = true;
//     //para busquedas combinables
//     objAH.url               = URL_PREFIX+'/opac-busquedasDB.pl';
//     objAH.string            = $('#string').val();
//     objAH.only_available    = ( $('#only_available').attr('checked') )?1:0;
// //     objAH.signatura         = $('#signatura').val();
//     objAH.tipo_nivel3_name  = $('#tipo_nivel3_id').val();
//     objAH.tipoAccion        = 'BUSQUEDA_COMBINABLE';
// //     var radio               = $("#tipo:checked");
// //     var tipo                = radio[0].value;
// //     objAH.tipo              = tipo;
//     //se setea la funcion para cambiar de pagina
//     objAH.funcion           = 'changePage';
//     // FIXME ver parametro ini
//     //se envia la consulta
//     objAH.sendToServer();
// }
// 
// function updateBusquedaCombinable(responseText){
//    $('#result_busqueda').html(responseText);
// //    if (!verificarRespuesta(responseText)) {
// //             return(0);
// //             var Messages=JSONstring.toObject(responseText);
// //             setMessages(Messages);
// //    }
// }


// se va a dejar de usar!!!!!!!!!!!!BORRRRRARR
function mandarArreglo(valores){
        arreglo= new Array();
	
	var checks=document.getElementsByTagName("input");
	if (checks.length>0){
		for(i=0;i<checks.length;i++)
		{
			if((checks[i].type == "checkbox")&&(checks[i].checked)){ 		
				arreglo[arreglo.length]=checks[i].name;
			}
		}       
	}
        valores.value= arreglo.join("#");
}


var objAH;//Objeto AjaxHelper.

function ordenarPor(ord){
	//seteo el orden de los resultados
	objAH.sort(ord);
}

function changePage(ini){
	objAH.changePage(ini);
}

var string;

//***************************************Historiales**********************************************************

function volverDesdeHistorial(){
	$('#resultHistoriales').slideUp('up');
	$('#datosUsuario').slideDown('slow');
	$('#result').slideDown();
}

function mostrarHistorialUpdate(responseText){

	$('#datosUsuario').slideUp('slow');
	$('#result').slideUp('slow');
	$('#resultHistoriales').html(responseText);
	$('#resultHistoriales').slideDown('slow');
	zebra('tabla_datos');
}

function mostrarHistorialPrestamos(){

	objAH=new AjaxHelper(mostrarHistorialUpdate);
  	objAH.debug= true;
    objAH.showOverlay       = true;
	objAH.url= URL_PREFIX+'/opac-HistorialPrestamos.pl';
	//se setea la funcion para cambiar de pagina
	objAH.funcion= 'changePage';
	//se envia la consulta
	objAH.sendToServer();

}

function mostrarHistorialReservas(bornum){

	objAH=new AjaxHelper(mostrarHistorialUpdate);
  	objAH.debug= true;
    objAH.showOverlay       = true;
	//para busquedas combinables
	objAH.url= URL_PREFIX+'/opac-HistorialReservas.pl';
	objAH.bornum= bornum;
	//se setea la funcion para cambiar de pagina
	objAH.funcion= 'changePage';
	//se envia la consulta
	objAH.sendToServer();

}
//************************************Fin***Historiales*******************************************************

//****************************************Busqueda para usuario no logueado************************************
function searchinc(){

    criteriaSelected = $('#criteria').val();
    $('#detalleReservas').html("");
    $('#detallePrestamos').html("");
    switch (criteriaSelected){
        case 'autor':
            buscarPorAutor();
            break;
        case 'titulo':
            buscarPorTitulo();
            break;
        case 'tema':
            buscarPorTema();
            break;
        case 'shelves':
//             buscarPorEstante();
            break;
        default:
            busquedaCombinable('all');
            break;


    }
}

function buscarPorAutor(){
	
	objAH=new AjaxHelper(updateBuscarPorAutor);
  	objAH.debug= true;
    objAH.showOverlay       = true;
	objAH.url= URL_PREFIX+'/opac-busquedasDB.pl';
	objAH.searchField= $('#searchField').val();
	objAH.tipo= 'normal';
	objAH.tipoAccion= 'BUSQUEDA_SIMPLE_POR_AUTOR';
	//se setea la funcion para cambiar de pagina
    objAH.cantR = $('#cantidad').val();

	objAH.funcion= 'changePage';
	//se envia la consulta
	objAH.sendToServer();
}

function highlightBuscarPorAutor(){
	var string = [];
    var classes = [];
	
	if($('#searchField').val() != ''){
		var combinables= ['searchField'];
		classes.push('autor_result');
		highlight(classes,combinables);
	}
}

function updateBuscarPorAutor(responseText){
	updateInfo(responseText);
	highlightBuscarPorAutor();
}

function buscarPorTitulo(){
    objAH=new AjaxHelper(updateBuscarPorTitulo);
    objAH.debug= true;
    objAH.showOverlay       = true;
    objAH.url= URL_PREFIX+'/opac-busquedasDB.pl';
    objAH.searchinc= $('#searchField').val();
    objAH.tipo= 'normal';
    objAH.tipoAccion= 'BUSQUEDA_SIMPLE_POR_TITULO';
    objAH.cantR = $('#cantidad').val();

    //se setea la funcion para cambiar de pagina
    objAH.funcion= 'changePage';
    //se envia la consulta
    objAH.sendToServer();
}

function highlightBuscarPorTitulo(){
    var string = [];
    var classes = [];

	if($('#searchField').val() != ''){
		classes.push('titulo_result');
		var combinables= ['searchField'];
    	highlight(classes,combinables);
	}
}

function updateBuscarPorTitulo(responseText){
	updateInfo(responseText);
	highlightBuscarPorTitulo();
}

function updateInfo(responseText){
	$('#datosUsuario').slideUp('slow');
	$('#result').html(responseText);
	$('#result').slideDown('slow');
    zebra('tabla_datos');
	checkedAll('todos','checkbox');
	scrollTo('tablaResult');
}



// --------------- ORIGINAL--------------------------------------

function busquedaCombinable(typeSearch){

    //seteo normal
    //     var tipo= $("#checkNormal").val();
    //     //busqueda exacta
    //     if($("#checkExacto").attr("checked") == true){
    //         tipo= $("#checkExacto").val();
    //     }

    objAH=new AjaxHelper(updateBusquedaCombinable);
    objAH.debug= true;
    objAH.showOverlay       = true;
    //para busquedas combinables
    objAH.url= URL_PREFIX+'/opac-busquedasDB.pl';
    objAH.tipoAccion= 'BUSQUEDA_COMBINABLE';
    if (typeSearch != 'all'){
//         objAH.codBarra= $('#codBarra').val();
//         objAH.tema=  $('#tema').val();
//         objAH.autor= $('#autor').val();
//         objAH.titulo= $('#titulo').val();
        objAH.titulo= $('#string').val();
//         objAH.tipo= tipo;
//         objAH.cantR = $('#cantidad').val();
        objAH.tipo_nivel3_name= $('#tipo_nivel3_id').val();
    }else
    {
            objAH.string=  $('#searchField').val();
            objAH.tipoBusqueda= 'all';
    }
    //se setea la funcion para cambiar de pagina
    objAH.funcion= 'changePage';
    //se envia la consulta
    objAH.sendToServer();
}


function updateBusquedaCombinable(responseText){
	updateInfo(responseText);
	highlightBusquedaCombinable();
}



function highlightBusquedaCombinable(){
    var string = [];
    var classes = [];
    if($('#autor').val() != ''){
        classes.push('autor_result');
    }

    if($('#titulo').val() != ''){
        classes.push('titulo_result');
    }

    var combinables= ['titulo', 'autor'];
    highlight(classes,combinables);
}


function buscarPorCodigoBarra(){
    objAH=new AjaxHelper(updateInfo);
    objAH.showOverlay       = true;
    objAH.debug= true;
    objAH.url= URL_PREFIX+'/opac-busquedasDB.pl';
    objAH.codBarra= $('#codBarra').val();
    objAH.tipoAccion= 'FILTRAR_POR_BARCODE';
    objAH.funcion= 'changePage';
    objAH.sendToServer();
}


function filtrarPorAutor(idAutor){
    objAH=new AjaxHelper(updateInfo);
    objAH.showOverlay       = true;
    objAH.debug= true;
    objAH.url= URL_PREFIX+'/opac-busquedasDB.pl';
    objAH.idAutor= idAutor;	
    objAH.tipoAccion= 'FILTRAR_POR_AUTOR';
    objAH.funcion= 'changePage';
    //se envia la consulta
    objAH.sendToServer();
}

//**************************************Fin**Busqueda para usuario no logueado********************************




//*******************************************Estantes Virutales**********************************************

function verEstanteVirtual(shelf){
	
	objAH=new AjaxHelper(updateVerEstanteVirtual);
    objAH.showOverlay       = true;
  	objAH.debug= true;
	objAH.url= 'opac-estanteVirtualDB.pl';
	objAH.shelves= shelf;
	objAH.tipo= 'VER_ESTANTE';
	//se setea la funcion para cambiar de pagina
	objAH.funcion= 'changePage';
	//se envia la consulta
	objAH.sendToServer();
}

function verSubEstanteVirtual(shelf){
	
	objAH=new AjaxHelper(updateVerEstanteVirtual);
    objAH.showOverlay       = true;
  	objAH.debug= true;
	objAH.url= 'opac-estanteVirtualDB.pl';
	objAH.shelves= shelf;
	objAH.tipo= 'VER_SUBESTANTE';
	//se setea la funcion para cambiar de pagina
	objAH.funcion= 'changePage';
	//se envia la consulta
	objAH.sendToServer();

}

function updateVerEstanteVirtual(responseText){
	
	$('#result').html(responseText);
	checkedAll('todos','checkbox');
}

function consultarEstanteVirtual(){

	objAH=new AjaxHelper(updateConsultarEstanteVirutal);
    objAH.showOverlay       = true;
  	objAH.debug= true;
	objAH.url= 'opac-estanteVirtual.pl';
	//se setea la funcion para cambiar de pagina
	objAH.funcion= 'changePage';
	//se envia la consulta
	objAH.sendToServer();
}

function updateConsultarEstanteVirutal(responseText){
    $('#datosUsuario').hide();
    $('#result').show();
	$('#result').html(responseText);
}
//***************************************Fin****Estantes Virutales*******************************************


//****************************************Busqueda Avanzada****************************************************

function clearAll(){
	$('#autor').val("");
	$('#dictionary').val("");
	$('#titulo').val("");
	$('#tema').val("");
	$('#codBarra').val("");
	$('#shelves').val("");
	$('#analytical').val("");
}

//************************************Fin****Busqueda Avanzada**************************************************


function buscar(){

	//primero verifico las busquedas individuales
	if ($('#codBarra').val() != ''){
		buscarPorCodigoBarra();
	}else
	if ($('#tema').val() != '') {
		buscarPorTema();
	}
	if ($('#searchField').val() != '') {
		searchinc();
	}
	else {
//si no hay busquedas individuales, se realiza una busqueda combinable y se levantan los parametros
//de la interface
		busquedaCombinable();
	}
}

function registrarEventos(){

	$("input").keypress(function (e) {
 		if(e.which == 13){
 			buscar();
 		}
 	});

}


// $(document).ready(function(){
// 
// 	registrarEventos();
// 
// });
