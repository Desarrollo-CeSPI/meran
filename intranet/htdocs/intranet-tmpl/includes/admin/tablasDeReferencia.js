function obtenerTabla(){
    objAH=new AjaxHelper(updateObtenerTabla);
    objAH.url= URL_PREFIX+'/admin/referencias/referenciasDB.pl';
    objAH.cache = false;
    objAH.showOverlay       = true;
    objAH.accion="OBTENER_TABLAS";
    objAH.alias_tabla = $('#tablas_ref').val();
    objAH.funcion= 'changePage';
    objAH.asignar       = 1;
    objAH.sendToServer();
}


function updateObtenerTabla(responseText){
    $('#detalle_tabla').html(responseText);

}

function obtenerTablaFiltrada(){
    objAH=new AjaxHelper(updateObtenerTablaFiltrada);
    objAH.url= URL_PREFIX+'/admin/referencias/referenciasDB.pl';
    objAH.cache = false;
    objAH.showOverlay       = true;
    objAH.accion="OBTENER_TABLAS";
    objAH.alias_tabla = $('#tablas_ref').val();
    objAH.filtro = $.trim($('#search_tabla').val());
    objAH.funcion= 'changePage';
    objAH.asignar       = 1;
    objAH.sendToServer();
}


function updateObtenerTablaFiltrada(responseText){

    $('#detalle_tabla').html(responseText);
}


function eliminarReferencia(tabla,id,name){

    $('#fieldset_tablaResult_involved').addClass("warning");
    bootbox.confirm(TITLE_DELETE_REFERENCE+" <span class='label label-important'>"+name+"</span>?",function(confirmed){
        if (confirmed){
            objAH=new AjaxHelper(updateEliminarReferencia);
            objAH.url= URL_PREFIX+'/admin/referencias/referenciasDB.pl';
            objAH.cache = false;
            objAH.showOverlay       = true;
            objAH.accion="ELIMINAR_REFERENCIA";
            objAH.alias_tabla = tabla;
            objAH.item_id= id;
            objAH.sendToServer();
        }
        $('#fieldset_tablaResult_involved').removeClass("warning");
    });
}


function updateEliminarReferencia(responseText){
    var Messages=JSONstring.toObject(responseText);
    setMessages(Messages);
    obtenerTabla();
}

function agregarRegistro(tabla){
    objAH=new AjaxHelper(updateAgregarRegistro);
    objAH.url= URL_PREFIX+'/admin/referencias/referenciasDB.pl';
    objAH.cache = false;
    objAH.showOverlay       = true;
    objAH.accion="AGREGAR_REGISTRO";
    objAH.alias_tabla = tabla;
    objAH.asignar       = 1;
    objAH.sendToServer();
}


function updateAgregarRegistro(responseText){

    $('#detalle_tabla').html(responseText);
    $('#basic-modal-content').modal('hide');

}


function mostrarReferencias(tabla,value_id){
    objAH=new AjaxHelper(updateObtenerTabla);
    objAH.url= URL_PREFIX+'/admin/referencias/referenciasDB.pl';
    objAH.cache = false;
    objAH.showOverlay       = true;
    objAH.accion="MOSTRAR_REFERENCIAS";
    objAH.alias_tabla = tabla;
    objAH.value_id = value_id;
    objAH.asignar       = 1;
    objAH.sendToServer();
}


function asignarReferencia(tabla,related_id,referer_involved,referer_involved_show){
    $('#fieldset_tablaResult_involved').addClass("warning");
    bootbox.confirm(TITLE_FIRST_ASSIGN_REFERENCIES+referer_involved_show+TITLE_TO_ASSIGN_REFERENCIES+related_id,function(confirmed){
        if (confirmed){
            objAH=new AjaxHelper(updateObtenerTabla);
            objAH.url= URL_PREFIX+'/admin/referencias/referenciasDB.pl';
            objAH.cache = false;
            objAH.accion="ASIGNAR_REFERENCIA";
            objAH.showOverlay       = true;
            objAH.referer_involved= referer_involved;
            objAH.alias_tabla = tabla;
            objAH.related_id = related_id;
            objAH.asignar       = 1;
            objAH.sendToServer();
        }
        $('#fieldset_tablaResult_involved').removeClass("warning");
    });
}

function asignarEliminarReferencia(tabla,related_id,referer_involved,referer_involved_show){
    $('#fieldset_tablaResult_involved').addClass("warning");
    bootbox.confirm(TITLE_FIRST_ASSIGN_DELETE_REFERENCIES+referer_involved_show+TITLE_TO_ASSIGN_REFERENCIES+related_id,function(confirmed){
        if (confirmed){
            objAH=new AjaxHelper(updateObtenerTabla);
            objAH.url= URL_PREFIX+'/admin/referencias/referenciasDB.pl';
            objAH.cache = false;
            objAH.accion="ASIGNAR_Y_ELIMINAR_REFERENCIA";
            objAH.showOverlay       = true;
            objAH.alias_tabla = tabla;
            objAH.referer_involved= referer_involved;
            objAH.related_id = related_id;
            objAH.asignar       = 1;
            objAH.sendToServer();
        }
        $('#fieldset_tablaResult_involved').removeClass("warning");
    });

}
