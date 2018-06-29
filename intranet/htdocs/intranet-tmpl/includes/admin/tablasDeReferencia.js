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

function obtenerTabla(tabla){
    if( $('#tablas_ref option:selected').text() != 'SIN SELECCIONAR' ) {
    
        objAH               = new AjaxHelper(updateObtenerTabla);
        objAH.url           = URL_PREFIX+'/admin/referencias/referenciasDB.pl';
        objAH.cache         = false;
        objAH.showOverlay   = true;
        objAH.accion        = "OBTENER_TABLAS";
        objAH.alias_tabla   = $('#tablas_ref').val() || tabla;
        objAH.funcion       = 'changePage';
        objAH.asignar       = 1;
        objAH.sendToServer();

    } else {
        jAlert(DEBE_SELECCIONAR_UNA_TABLA_DE_REFERENCIA,CATALOGO_ALERT_TITLE);
        $('#tablas_ref').focus();
    }
}


function updateObtenerTabla(responseText){
    $('#detalle_tabla').html(responseText);
    $('#basic-modal-content').modal('hide');

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


function eliminarReferencia(tabla,id,name,nombre_tabla){

    $('#fieldset_tablaResult_involved').addClass("warning");
    bootbox.confirm(TITLE_DELETE_REFERENCE+" <span class='label label-important'>"+name+"</span> de la tabla de referencias <span class='label label-important'>"+nombre_tabla+"</span>?",function(confirmed){
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
    objAH.accion="AGREGAR_REGISTRO";
    objAH.alias_tabla = tabla;
    objAH.asignar = 0;
    objAH.sendToServer();
}


function updateAgregarRegistro(responseText){
    $('#detalle_tabla').html(responseText);
    $('#basic-modal-content').modal('hide');
    var Messages=JSONstring.toObject(responseText);
    setMessages(Messages);
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


function asignarReferencia(tabla,related_id,referer_involved,referer_involved_show,related_show, nombre_tabla, cant_registros){
    $('#fieldset_tablaResult_involved').addClass("warning");
    bootbox.confirm("<span class='label label-info'>Referencia de "+nombre_tabla+"</span>:<br>"+TITLE_FIRST_ASSIGN_REFERENCIES+" <span class='label label-success'>"+related_show+"</span> "+TITLE_TO_ASSIGN_REFERENCIES+" <span class='label label-warning'>"+referer_involved_show+"</span>? <br>Hay <b>"+cant_registros+"</b> registros afectados." ,function(confirmed){
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

function asignarEliminarReferencia(tabla,related_id,referer_involved,referer_involved_show,related_show,nombre_tabla, cant_registros){
    $('#fieldset_tablaResult_involved').addClass("warning");
    bootbox.confirm("<span class='label label-info'>Referencia de "+nombre_tabla+"</span>:<br>"+TITLE_FIRST_ASSIGN_REFERENCIES+" <span class='label label-success'>"+related_show+"</span> "+TITLE_TO_ASSIGN_REFERENCIES+" <span class='label label-warning'>"+referer_involved_show+"</span> y luego eliminar este último? <br>Hay <b>"+cant_registros+"</b> registros afectados.",function(confirmed){
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

function showReferidos(tabla,tabla_referencia,id_referencia){
    objAH=new AjaxHelper(updateShowReferidos);
    objAH.url= URL_PREFIX+'/admin/referencias/referenciasDB.pl';
    objAH.cache = false;
    objAH.accion="MOSTRAR_REFERIDOS";
    objAH.tabla = tabla;    
    objAH.tabla_referencia = tabla_referencia;
    objAH.id_referencia = id_referencia;
    objAH.sendToServer();
}

function updateShowReferidos(responseText){
    $('#mostrar_detalle_referido').html(responseText);
    $('#mostrar_detalle_referido').modal();
}