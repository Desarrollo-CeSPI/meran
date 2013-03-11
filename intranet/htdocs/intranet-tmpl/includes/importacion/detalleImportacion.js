/*
 * LIBRERIA detalleImportacion v 1.0.1
 * Esta es una libreria creada para el sistema MERAN
 * Fecha de creacion 09/01/2012
 *
 */

//*********************************************Detalle *********************************************


function ordenar(orden){
    objAH.sort(orden);
}

function detalleImportacion(id_importacion){

    objAH=new AjaxHelper(updateDetalleImportacion);
    
    search					= $('#search_importacion').val();
    search					= $.trim(search);
    
    objAH.url               = URL_PREFIX+'/herramientas/importacion/importarDB.pl';
    objAH.debug             = true;
    objAH.showOverlay       = true;
    objAH.funcion           = 'changePage';
    objAH.tipoAccion        = "DETALLE";
    objAH.id_importacion  	= id_importacion;
    if (search)
		objAH.search		= search;
    
    objAH.record_filter  =  $('#record_filter').val();
    objAH.sendToServer();

}

function changePage(ini){
    objAH.changePage(ini);
}

function updateDetalleImportacion(responseText){
    $('#detalleImportacion').html(responseText);
}


function detalleRegistroMARC(id){
    objAHDetalle=new AjaxHelper(updateDetalleRegistroMARC);
    objAHDetalle.url               = URL_PREFIX+'/herramientas/importacion/importarDB.pl';
    objAHDetalle.debug             = true;
    objAHDetalle.showOverlay       = true;
    objAHDetalle.tipoAccion        = "DETALLE_REGISTRO";
    objAHDetalle.id = id;
    objAHDetalle.sendToServer();

}

function updateDetalleRegistroMARC(responseText){
            $('#detalleRegistroMARC').html(responseText);
            scrollTo('detalleRegistroMARC');
}

/*
 * eleccionCampoX
 * Funcion que se ejecuta cuando se selecciona un valor del combo campoX (ej. 1xx), y hace un llamado a la
 * funcion que ejecuta el ajax, con los parametros correspondiente a la accion realizada.
 */
function eleccionCampoOrigenX(id,id_esquema){
    if ( $("#campoX"+id).val() != -1){
        objAH               = new AjaxHelper(updateEleccionCampoOrigenX);
        objAH.debug         = true;
        objAH.showOverlay   = true;
        objAH.url           = URL_PREFIX+'/herramientas/importacion/importarDB.pl';
        objAH.id_campo_seleccion = id;
        objAH.id_esquema = id_esquema;
        objAH.campoX        = $('#campoX'+id).val();
        objAH.tipoAccion    = "GENERAR_ARREGLO_CAMPOS_ESQUEMA_ORIGEN";
        objAH.sendToServer();
    }else
        enable_disableSelectsOrigen();
}

//se genera el combo en el cliente
function updateEleccionCampoOrigenX(responseText){
    //Arreglo de Objetos Global
    var campos_array = JSONstring.toObject(responseText);
    //se inicializa el combo
    var id = objAH.id_campo_seleccion;
    $("#campo"+id).html('');
    var options = "<option value='-1'>Seleccionar CampoX</option>";
    var vacio=1;
    for (x=0;x < campos_array.length;x++){
        if ((campos_array[x].campo_origen)&&(campos_array[x].campo_origen != '')&&(campos_array[x].campo_origen != ' ')) {
         options+= "<option value=" + campos_array[x].campo_origen +" >" + campos_array[x].campo_origen + "</option>";
         vacio = 0;
        }
    }


    if(vacio != 1){
        $("#campo"+id).append(options);
        //se agrega la info al combo
        $("#campo"+id).show();
        $("#subcampo"+id).hide();
    }else{
        $("#campo"+id).hide();
        }
}


function eleccionCampoOrigen(id,id_esquema){

    if ($("#campo"+id).val() != -1){
        objAH               = new AjaxHelper(updateEleccionCampoOrigen);
        objAH.debug         = true;
        objAH.showOverlay   = true;
        objAH.url           = URL_PREFIX+"/herramientas/importacion/importarDB.pl";
        objAH.id_campo_seleccion=id;
        objAH.id_esquema = id_esquema;
        objAH.campo         = $('#campo'+id).val();
        objAH.tipoAccion    = "GENERAR_ARREGLO_SUBCAMPOS_ESQUEMA_ORIGEN";
        objAH.sendToServer();
    }
    else
        enable_disableSelectsOrigen(id);

}

//se genera el combo en el cliente
function updateEleccionCampoOrigen(responseText){

    var id = objAH.id_campo_seleccion;
    //Arreglo de Objetos Global
    var subcampos_array=JSONstring.toObject(responseText);
    //se inicializa el combo
    $("#subcampo"+id).html('');
    var options = "<option value='-1'>Seleccionar SubCampo</option>";
    var vacio=1;
    for (x=0;x < subcampos_array.length;x++){
        if ((subcampos_array[x].subcampo_origen)&&(subcampos_array[x].subcampo_origen != '')&&(subcampos_array[x].subcampo_origen != ' ')) {
            options+= "<option value=" + subcampos_array[x].subcampo_origen +" >" + subcampos_array[x].subcampo_origen + "</option>";
            vacio = 0;
        }
    }

    if (vacio != 1){
        //se agrega la info al combo
        $("#subcampo"+id).append(options);
        $("#campo"+id).show();
        $("#subcampo"+id).show();
    }else{
        $("#subcampo"+id).hide();
        }
}

function enable_disableSelectsOrigen(id){

    $("#campo"+id).show();
    $("#subcampo"+id).show();

    if ( $('#campoX'+id).val() == -1){
         $("#campo"+id).hide();
         $("#subcampo"+id).hide();
    }
    else
      if ( $('#campo'+id).val() == -1){
         $("#campo"+id).show();
         $("#subcampo"+id).hide();
      }
}

function procesarRelacionRegistroEjemplares(id){
    if ($("#campo1").val() != -1){
        objAHDetalle=new AjaxHelper(updateRelacionRegistroEjemplares);
        objAHDetalle.url               = URL_PREFIX+'/herramientas/importacion/importarDB.pl';
        objAHDetalle.debug             = true;
        objAHDetalle.showOverlay       = true;
        objAHDetalle.tipoAccion        = "RELACION_REGISTRO_EJEMPLARES";
        objAHDetalle.id = id;


        objAHDetalle.campo_identificacion = $("#campo1").val();
        if ( $("#subcampo1").val()){
            objAHDetalle.subcampo_identificacion = $("#subcampo1").val();
        }

        objAHDetalle.campo_relacion = $("#campo2").val();
        if ( $("#subcampo2").val()){
        objAHDetalle.subcampo_relacion = $("#subcampo2").val();
        }
        objAHDetalle.preambulo_relacion = $("#preambulo").val();

        objAHDetalle.sendToServer();
    }

}

function updateRelacionRegistroEjemplares(responseText){
        var Messages=JSONstring.toObject(responseText);
        setMessages(Messages);
}




function eliminarCampoReglasMatcheo(pos){

   var nuevas_reglas="";
   var reglas= $('#lista_reglas_matcheo').val();
   var reglas_arr = (reglas).split("#");
   for (regla in reglas_arr){
      if (pos != regla){
         nuevas_reglas=nuevas_reglas+reglas_arr[regla];
      }
   }
   $('#lista_reglas_matcheo').val(nuevas_reglas);
   cargarCampoReglasMatcheo();
}


function agregarCampoReglasMatcheo(){


    if ($('#subcampo').val() != -1){
        var nueva_regla=$('#campo').val()+"$"+$('#subcampo').val()+"$"+$('#nombre_subcampo').html();
        if (existeCampoReglaMatcheo(nueva_regla) == 0){
            var reglas= $('#lista_reglas_matcheo').val();
            if(reglas){
                $('#lista_reglas_matcheo').val(reglas+"#"+nueva_regla);
            }else{
                $('#lista_reglas_matcheo').val(nueva_regla);
            }
            cargarCampoReglasMatcheo();
        }
    }
}

function existeCampoReglaMatcheo(nueva_regla){
   var reglas= $('#lista_reglas_matcheo').val();
   if(reglas){
        var reglas_arr = (reglas).split("#");
        for (regla in reglas_arr){
           if (nueva_regla == reglas_arr[regla]){
                return 1;
               }
        }
    }
   return 0;
}

function cargarCampoReglasMatcheo(){
        var reglas= $('#lista_reglas_matcheo').val();
        var resultado="";
        if(reglas){
            var reglas_arr = (reglas).split("#");
            for (regla in reglas_arr){
                 var regla_actual = reglas_arr[regla];
                 var regla_actual_arr = (regla_actual).split("$");
                resultado=resultado+"<tr align='center'>";
                resultado=resultado+"<td>"+regla_actual_arr[0]+"</td>";
                resultado=resultado+"<td>"+regla_actual_arr[1]+"</td>";
                resultado=resultado+"<td>"+regla_actual_arr[2]+"</td>";
                resultado=resultado+'<td><a onclick="eliminarCampoReglasMatcheo('+regla+')" class="btn btn-danger click" id=""><i class="icon-minus icon-white"></i> </a></td>';
                resultado=resultado+"</tr>";
            }
        }
        $('#reglas_matcheo').html(resultado);

}

function procesarReglasMatcheo(id){

        objAHDetalle=new AjaxHelper(updateReglasMatcheo);
        objAHDetalle.url               = URL_PREFIX+'/herramientas/importacion/importarDB.pl';
        objAHDetalle.debug             = true;
        objAHDetalle.showOverlay       = true;
        objAHDetalle.tipoAccion        = "REGLAS_MATCHEO";
        objAHDetalle.id = id;
        objAHDetalle.reglas_matcheo = $("#lista_reglas_matcheo").val();
        objAHDetalle.sendToServer();

}

function updateReglasMatcheo(responseText){
        var Messages=JSONstring.toObject(responseText);
        setMessages(Messages);
        detalleImportacion(objAHDetalle.id_importacion);
}

function cambiarEstadoRegistro(id_importacion,id_registro,estado){

        objAHDetalle=new AjaxHelper(updateEstadoRegistro);
        objAHDetalle.url               = URL_PREFIX+'/herramientas/importacion/importarDB.pl';
        objAHDetalle.debug             = true;
        objAHDetalle.showOverlay       = true;
        objAHDetalle.tipoAccion        = "CAMBIAR_ESTADO_REGISTRO";
        objAHDetalle.estado = estado;
        objAHDetalle.id = id_registro;
        objAHDetalle.id_importacion = id_importacion;
        objAHDetalle.sendToServer();

}

function updateEstadoRegistro(responseText){
        var Messages=JSONstring.toObject(responseText);
        setMessages(Messages);
        closeModal();
        detalleImportacion(objAHDetalle.id_importacion);
}

function quitarMatcheoRegistro(id_importacion,id_registro,estado){

        objAHDetalle=new AjaxHelper(updateQuitarMatcheoRegistro);
        objAHDetalle.url               = URL_PREFIX+'/herramientas/importacion/importarDB.pl';
        objAHDetalle.debug             = true;
        objAHDetalle.showOverlay       = true;
        objAHDetalle.tipoAccion        = "QUITAR_MATCHEO_REGISTRO";
        objAHDetalle.id = id_registro;
        objAHDetalle.id_importacion = id_importacion;
        objAHDetalle.sendToServer();

}

function updateQuitarMatcheoRegistro(responseText){
        var Messages=JSONstring.toObject(responseText);
        setMessages(Messages);
        detalleImportacion(objAHDetalle.id_importacion);
}

var jobID = 0;

function comenzarImportacion(id_importacion){
        objAH                   = new AjaxHelper(updateComenzarImportacion);
        objAH.url               = URL_PREFIX+'/start_job.pl';
        objAH.debug             = true;
        objAH.showOverlay       = false;
        objAH.id                = id_importacion;
        objAH.accion            = "COMENZAR_IMPORTACION"; 
        objAH.sendToServer();

}

function updateComenzarImportacion(responseText){
    jobID = responseText;
    refreshMeranPage();
}


function cancelarImportacion(id_importacion){
    bootbox.confirm(CANCELAR_IMPORTACION, function (ok){ 
        if (ok){
            objAH                   = new AjaxHelper(updateCancelarImportacion);
            objAH.url               = URL_PREFIX+'/herramientas/importacion/importarDB.pl';
            objAH.debug             = true;
            objAH.showOverlay       = false;
            objAH.id                = id_importacion;
            objAH.jobID             = jobID;
            objAH.tipoAccion        = "CANCELAR_IMPORTACION"; 
            objAH.sendToServer();
        }
    });

}

function updateCancelarImportacion(responseText){
    var Messages=JSONstring.toObject(responseText);

    setMessages(Messages);
    jobID = 0;
    refreshMeranPage();
}


