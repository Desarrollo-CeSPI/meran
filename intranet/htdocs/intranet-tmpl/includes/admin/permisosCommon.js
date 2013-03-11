var objAH = 0;
var superUserGranted = 0;
var tipoPermiso = "CATALOGO";

function changeTipoPermiso(){
    valueSelected = $("#tipo_permisos").val();
    usuarioHidden = $("#nro_socio_hidden").val();
    
    if ($.trim(usuarioHidden) != ''){
	    switch (valueSelected){
		    case "PCAT":
		    	tipoPermiso = "CATALOGO";
		    	break;
		    case "PCIR":
		    	tipoPermiso = "CIRCULACION";
		    	break;
		    case "PGEN":
		    	tipoPermiso = "GENERAL";
		    	break;
	    }
	    obtenerPermisos();
    }
	
}

function armarPermisos(){
}

function seleccionoPerfil(combo){

    valueSelected = $(combo).val();
    return (valueSelected != 'custom');
}

function toggleGrantsDiv(state){

    checkBoxItems = $('#permisos_assign_chk > div > ul > li > input');
    for (y=0; y<checkBoxItems.length; y++){
        riskPart = $(checkBoxItems[y]).attr("disabled",state);
    }
}

function checkChecks(){

    var arreglo = armarArregloDePermisos();

    riskArray = new Array();
    riskArray['consulta'] = "low";
    riskArray['alta'] = "medium";
    riskArray['modif'] = "high";
    riskArray['baja'] = "high";
    riskArray['todos'] = "high";
    
    var dim = arreglo.length;

    for (x=0;x<dim;x++){
        checkBoxItems = $('#'+arreglo[x]+" > ul > li > input");
        checkTouched = false;
        for (y=0; y<checkBoxItems.length; y++){
            riskPart = checkBoxItems[y].id.split("_");
            if (riskPart.length > 2)
                riskPart[1] = riskPart[riskPart.length-1];
            risk = riskArray[riskPart[1]];
            if (!checkTouched){
                checkTouched = adviceGrant(checkBoxItems[y],arreglo[x],risk,true);
            }
          }
    }
}

function adviceGrant(checkBox,divID,risk,dontCallChecks){
    array = new Array();
    array['low']="permissionLow";
    array['medium']="permissionMedium";
    array['high']="permissionHigh";
    dontCallChecks = dontCallChecks?dontCallChecks:false;
    returnValue = false;

    isChecked = ($(checkBox).is(':checked'))?true:false;

    $('#'+divID).removeClass("permissionLow");
    $('#'+divID).removeClass("permissionMedium");
    $('#'+divID).removeClass("permissionHigh");
    
    if (isChecked){
        $('#'+divID).addClass(array[risk]);
        returnValue = true;
    }

    if (!dontCallChecks)
    	checkChecks(divID);
    return(returnValue);

}

function obtenerPermisos(){
	
	var usuario = $('#nro_socio_hidden').val();
	
	if ($.trim(usuario) != ""){	
	    objAH               = new AjaxHelper(updateObtenerPermisos);
	    objAH.url           = URL_PREFIX+'/admin/permisos/permisosDB.pl';
	    objAH.cache         = false;
	    objAH.showOverlay   = true;  
	    objAH.nro_socio     = $('#nro_socio_hidden').val();
	        if ($('#id_ui').val() != "SIN SELECCIONAR")
	            objAH.id_ui = $('#id_ui').val();
	        else
	            objAH.id_ui = 0;
	    comboPerfiles       = $('#perfiles');
	    if (seleccionoPerfil(comboPerfiles)){
	        objAH.perfil=comboPerfiles.val();
	    }
	    objAH.accion            = "OBTENER_PERMISOS_"+tipoPermiso;
	    objAH.permiso           = $('#permisos').val();
	    objAH.sendToServer();
    }else{
        jAlert(NO_SE_SELECCIONO_NINGUN_USUARIO, ERROR_ITSELF);
        $('#usuario').focus();
        $.scrollTo('#usuario');
    }
	    
}


function nuevoPermisoSHOW(){
    objAH               = new AjaxHelper(updateNuevoPermisoSHOW);
    objAH.url           = URL_PREFIX+'/admin/permisos/permisosDB.pl';
    objAH.cache         = false;
    objAH.showOverlay   = true;    
    objAH.accion        = "SHOW_NUEVO_PERMISO_"+tipoPermiso;
    objAH.sendToServer();
}

function updateNuevoPermisoSHOW(responseText){
    $('#permisos_assign_chk').html(responseText);
}

function permiso(nombre){

    actualizarCheckBoxes(nombre);

    this.nombre = nombre;
    this.alta = ($('#'+nombre+'_alta').is(':checked'))?1:0;
    this.baja = ($('#'+nombre+'_baja').is(':checked'))?1:0;
    this.modif = ($('#'+nombre+'_modif').is(':checked'))?1:0;
    this.consulta = ($('#'+nombre+'_consulta').is(':checked'))?1:0;
    this.todos = ($('#'+nombre+'_todos').is(':checked'))?1:0;
    if (this.todos || this.baja || this.modif)
        superUserGranted = 1;

}

function actualizarPermisos(){
    objAH               = new AjaxHelper(updateActualizarPermisos);
    objAH.url           = URL_PREFIX+'/admin/permisos/permisosDB.pl';
    objAH.cache         = false;
    objAH.showOverlay   = true;  
    objAH.nro_socio     = $('#nro_socio_hidden').val();


    if ($('#id_ui').val() != "SIN SELECCIONAR")
        objAH.id_ui = $('#id_ui').val();
    else
        objAH.id_ui = 0;

    objAH.accion    = "ACTUALIZAR_PERMISOS_"+tipoPermiso;
    objAH.permisos  = armarArregloDePermisosSave();
    confirmMessage  = "\n\n";
    if (superUserGranted == 1)
        confirmMessage += SUPER_USER_GRANTED;
    else
        confirmMessage += PERMISSION_GRANTED;
	    bootbox.confirm(confirmMessage, function(confirmStatus){
	    	if (confirmStatus) objAH.sendToServer();
		});
}

function updateActualizarPermisos(responseText){
	var Messages = JSONstring.toObject(responseText);

	setMessages(Messages);
	
    obtenerPermisos();
}

function nuevoPermiso(){

    usuario = $('#nro_socio_hidden').val();
    if ($.trim(usuario) != ""){
        objAH               = new AjaxHelper(updateNuevoPermiso);
        objAH.url           = URL_PREFIX+'/admin/permisos/permisosDB.pl';
        objAH.cache         = false;
        objAH.showOverlay   = true;  
        objAH.nro_socio     = $('#nro_socio_hidden').val();

        if ($('#id_ui').val() != "SIN SELECCIONAR")
            objAH.id_ui = $('#id_ui').val();
        else
            objAH.id_ui = 0;

        objAH.accion="NUEVO_PERMISO_"+tipoPermiso;
        objAH.permisos = armarArregloDePermisosSave();
        confirmMessage = NEW_GRANT+"\n\n";
        if (superUserGranted == 1)
            confirmMessage += SUPER_USER_GRANTED;
        bootbox.confirm(confirmMessage, function(confirmStatus){if (confirmStatus) objAH.sendToServer();});
    }else{
        jAlert(NO_SE_SELECCIONO_NINGUN_USUARIO, ERROR_ITSELF);
        $('#usuario').focus();
        $.scrollTo('#usuario');
    }
}

function updateNuevoPermiso(responseText){
	var Messages = JSONstring.toObject(responseText);

	setMessages(Messages);
	
    obtenerPermisos();
}

function updateObtenerPermisos(responseText){
    $('#permisos_assign_chk').html(responseText);
    superUserGranted = 0;
    checkChecks();
    comboPerfiles = $('#perfiles');
//     if (seleccionoPerfil(comboPerfiles))
//         toggleGrantsDiv(true);
//     else
//         toggleGrantsDiv(false);
}



function armarArregloDePermisosSave(){
	
	switch (tipoPermiso){
	case "CATALOGO":
		return (armarArregloDePermisosSave_CATALOGO());
		break;
		
	case "CIRCULACION":
		return (armarArregloDePermisosSave_CIRCULACION());
		break;
		
	case "GENERAL":
		return (armarArregloDePermisosSave_GENERAL());
		break;
		
	}
	
}


function armarArregloDePermisos(){
	switch (tipoPermiso){
	case "CATALOGO":
		return (armarArregloDePermisos_CATALOGO());
		break;
		
	case "CIRCULACION":
		return (armarArregloDePermisos_CIRCULACION());
		break;
		
	case "GENERAL":
		return (armarArregloDePermisos_GENERAL());
		break;
		
	}
		
}


/* FUNCIONES ESPECIFICAS PARA CADA TIPO DE PERMISO */

function armarArregloDePermisosSave_CATALOGO(){

    var arreglo = new Array();
    arreglo[0] = new permiso('datos_nivel1');
    arreglo[1] = new permiso('datos_nivel2');
    arreglo[2] = new permiso('datos_nivel3');
    arreglo[3] = new permiso('estantes_virtuales');
    arreglo[4] = new permiso('estructura_catalogacion_n1');
    arreglo[5] = new permiso('estructura_catalogacion_n2');
    arreglo[6] = new permiso('estructura_catalogacion_n3');
    arreglo[7] = new permiso('tablas_de_refencia');
    arreglo[8] = new permiso('control_de_autoridades');
    arreglo[9] = new permiso('usuarios');
    arreglo[10] = new permiso('sistema');
    arreglo[11] = new permiso('undefined');

    return(arreglo);
}

function armarArregloDePermisos_CATALOGO(){
    superUserGranted = 0;
    var arreglo = new Array();
    arreglo[0] = 'datos_nivel1';
    arreglo[1] = 'datos_nivel2';
    arreglo[2] = 'datos_nivel3';
    arreglo[3] = 'estantes_virtuales';
    arreglo[4] = 'estructura_catalogacion_n1';
    arreglo[5] = 'estructura_catalogacion_n2';
    arreglo[6] = 'estructura_catalogacion_n3';
    arreglo[7] = 'tablas_de_refencia';
    arreglo[8] = 'control_de_autoridades';
    arreglo[9] = 'usuarios';
    arreglo[10] = 'sistema';
    arreglo[11] = 'undefined';

    return(arreglo);
}


function armarArregloDePermisosSave_CIRCULACION(){
    superUserGranted = 0;
    var arreglo = new Array();
    arreglo[0] = new permiso('prestamos');
    arreglo[1] = new permiso('circ_opac');
    arreglo[2] = new permiso('circ_prestar');
    arreglo[3] = new permiso('circ_renovar');
    arreglo[4] = new permiso('circ_devolver');
    arreglo[5] = new permiso('circ_sanciones');


    return(arreglo);
}

function armarArregloDePermisos_CIRCULACION(){
    superUserGranted = 0;
    var arreglo = new Array();
    arreglo[0] = 'prestamos';
    arreglo[1] = 'circ_opac';
    arreglo[2] = 'circ_prestar';
    arreglo[3] = 'circ_renovar';
    arreglo[4] = 'circ_devolver';
    arreglo[5] = 'circ_sanciones';

    return(arreglo);
}


function armarArregloDePermisosSave_GENERAL(){

    var arreglo = new Array();

    arreglo[0] = new permiso('preferencias');
    arreglo[1] = new permiso('reportes');
    arreglo[2] = new permiso('permisos');
    arreglo[3] = new permiso('adq_opac');
    arreglo[4] = new permiso('adq_intra');

    return(arreglo);
}

function armarArregloDePermisos_GENERAL(){
    superUserGranted = 0;
    var arreglo = new Array();

    arreglo[0] = 'preferencias';
    arreglo[1] = 'reportes';
    arreglo[2] = 'permisos';
    arreglo[3] = 'adq_opac';
    arreglo[4] = 'adq_intra';

    return(arreglo);
}