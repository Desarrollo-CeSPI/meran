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
* LIBRERIA datosProveedores v 1.0.0
* Esta es una libreria creada para el sistema KOHA
* Contendran las funciones para editar un proveedor
* Fecha de creación 12/11/2010
*
*/
//*********************************************Editar Proveedor********************************************* 

$(document).ready(function() {

    CrearAutocompleteCiudades({IdInput: 'ciudad', IdInputHidden: 'id_ciudad'})
    CrearAutocompleteMonedas({IdInput: 'moneda', IdInputHidden: 'id_moneda'})
    ocultarDatos()
    monedas()
    materiales()
    envios()

});   

var arreglo_formas_envio = new Array() // arreglo de formas de envio a agregar en la base

function envios(){

    // eliminamos la opcion "SIN SELECCIONAR" de la vista
    $('#forma_envio_id option').last().remove()
    
    // se eliminan las opciones seleccionadas de la vista
    $('#quitar_forma_envio').click(function(){
        var seleccionados = 0
        // preguntamos si hay alguna opcion seleccionada
        $('#formas_envio_provedor option:selected').each(function(){  
          seleccionados++
        })
        // si no hay ninguna seleccionada avisamos
        if(seleccionados == 0){
            jConfirm(POR_FAVOR_SELECCIONE_LAS_FORMAS_DE_ENVIO_QUITAR, function(){ }) 
        }else{
            // si hay seleccionadas, las quitamos
            $('#formas_envio_provedor option:selected').each(function(){  
                $(this).remove()
            })
        }
    });
    
    $('#agregar_forma_envio').click(function(){
        var seleccionados = 0
        // preguntamos si hay alguna opcion seleccionada
        $('#forma_envio_id option:selected').each(function(){  
          seleccionados++
        })
        // si no hay ninguna seleccionada avisamos
        if(seleccionados == 0){
            jConfirm(POR_FAVOR_SELECCIONE_LAS_FORMAS_DE_ENVIO_AGREGAR, function(){ }) 
        }else{
            // si hay seleccionadas, las agregamos
            $('#forma_envio_id option:selected').each(function(value){  
                var id = $(this).val()
                var ok = true
                // pero antes preguntamos si ya tiene ese material el proveedor
                $('#formas_envio_provedor option').each(function(key){
                    if($(this).val() == id){
                        ok = false
                    }
                })
                // si no lo tiene se agrega
                if(ok){
                    $(this).clone().appendTo($('#formas_envio_provedor'))
                }
            })
        }
    });

}

// Devuelve un arreglo con los id de las formas de envio a agregar
function getFormasEnvio(){
    var i = 0
    $('#formas_envio_provedor option').each(function(){  
        arreglo_formas_envio[i] = $(this).val()
        i++
    })
    return arreglo_formas_envio
}

var arreglo_materiales = new Array() // arreglo de materiales a agregar en la base

function materiales(){
    
    // eliminamos la opcion "SIN SELECCIONAR" de la vista
    $('#tipo_material_id option').last().remove()
    
    // se eliminan las opciones seleccionadas de la vista
    $('#quitar_material').click(function(){
        var seleccionados = 0
        // preguntamos si hay alguna opcion seleccionada
        $('#materiales_del_provedor option:selected').each(function(){  
          seleccionados++
        })
        // si no hay ninguna seleccionada avisamos
        if(seleccionados == 0){
            jConfirm(POR_FAVOR_SELECCIONE_LOS_MATERIALES_QUITAR, function(){ }) 
        }else{
            // si hay seleccionadas, las quitamos
            $('#materiales_del_provedor option:selected').each(function(){  
                $(this).remove()
            })
        }
    });
    
    $('#agregar_material').click(function(){
        var seleccionados = 0
        // preguntamos si hay alguna opcion seleccionada
        $('#tipo_material_id option:selected').each(function(){  
          seleccionados++
        })
        // si no hay ninguna seleccionada avisamos
        if(seleccionados == 0){
            jConfirm(POR_FAVOR_SELECCIONE_LOS_MATERIALES_AGREGAR, function(){ }) 
        }else{
            // si hay seleccionadas, las agregamos
            $('#tipo_material_id option:selected').each(function(value){  
                var id = $(this).val()
                var ok = true
                // pero antes preguntamos si ya tiene ese material el proveedor
                $('#materiales_del_provedor option').each(function(key){
                    if($(this).val() == id){
                        ok = false
                    }
                })
                // si no lo tiene se agrega
                if(ok){
                    $(this).clone().appendTo($('#materiales_del_provedor'))
                }
            })
        }
    });

}

// Devuelve un arreglo con los id de los materiales a agregar
function getMateriales(){
    var i = 0
    $('#materiales_del_provedor option').each(function(){  
        arreglo_materiales[i] = $(this).val()
        i++
    })
    return arreglo_materiales
}

function monedas(){

    $('#agregar_moneda').click(function(){
        if(($('#moneda').val() == "") || ($('#id_moneda').val() == "")){
            jConfirm(POR_FAVOR_INGRESE_UNA_MONEDA, function(){ })                
        }else{
            var idMonedaNueva = $('#id_moneda').val()        
            var cantidad = 0
            $('.monedas').each(function(index) {     
            if($(this).attr('value') == idMonedaNueva){ 
                cantidad++
            }
            }); 
            if(cantidad == 0){      
                agregarMoneda(idMonedaNueva)
                $('#moneda').val("") 
            }
        }

    }); 

    $('#borrar_moneda').click(function(){
        var checkeados = 0
        var arreglo = new Array() 
        $('.monedas').each(function(index) {
            if($(this).attr('checked')){ 
                arreglo[checkeados] = $(this).val()
                checkeados++
            }
        });   
        if(checkeados == 0){
            jConfirm(POR_FAVOR_SELECCIONE_LAS_MONEDAS_A_BORRAR, function(){ })
        }else{
            borrarMoneda(arreglo)
            $('#moneda').val("")                
        }
    }); 

}

// elimina la/s monedas seleccionadas, borra en la base por ajax y vuelve a cargarlas en el div
function borrarMoneda(arreglo){
    objAH                     = new AjaxHelper(updateMonedasProveedor)
    objAH.url                 = URL_PREFIX+'/adquisiciones/proveedoresDB.pl'
    objAH.debug               = true
    objAH.showOverlay         = true

    objAH.id_proveedor        = $('#id_proveedor').val()
    objAH.monedas_array       = arreglo

    objAH.tipoAccion          = 'ELIMINAR_MONEDA_PROVEEDOR'
    objAH.sendToServer();   
}

// agregar la moneda en la base por ajax y vulve a cargarlas en el div
function agregarMoneda(idMonedaNueva){
    objAH                     = new AjaxHelper(updateMonedasProveedor)
    objAH.url                 = URL_PREFIX+'/adquisiciones/proveedoresDB.pl'
    objAH.debug               = true
    objAH.showOverlay         = true

    objAH.id_proveedor        = $('#id_proveedor').val()
    objAH.id_moneda           = idMonedaNueva

    objAH.tipoAccion          = 'GUARDAR_MONEDA_PROVEEDOR'
    objAH.sendToServer();   
}


function updateMonedasProveedor(responseText){
    $('#monedas_proveedor').html(responseText); 
}


function ocultarDatos(){
    if(($('#apellido').val() == "") && ($('#razon_social').val() != "")){
        //es una persona juridica
        $('#datos_proveedor').show()
        $('#nombre').hide()
        $('#label_nombre').hide()
        $('#apellido').hide()  
        $('#label_apellido').hide()  
        $('#nro_doc').hide()    
        $('#label_tipo_documento_id').hide()
        $('#numero_documento').hide()
        $('#tipo_documento_id').hide()
        $('#razon_social').show()
        $('#label_razon_social').show()    
    }else{
        //es una persona fisica
        $('#datos_proveedor').show()
        $('#razon_social').hide()
        $('#label_razon_social').hide()
        $('#nombre').show()
        $('#label_nombre').show()
        $('#apellido').show()  
        $('#label_apellido').show()  
        $('#nro_doc').show()    
        $('#label_nro_doc').show()
        $('#tipo_documento_id').show()   
    }     
}

function modificarDatosDeProveedor(){
    objAH                     = new AjaxHelper(updateDatosProveedor);
    objAH.url                 = URL_PREFIX+'/adquisiciones/proveedoresDB.pl';
    objAH.debug               = true;
    objAH.showOverlay         = true;

    objAH.id_proveedor        = $('#id_proveedor').val();
    
    // preguntamos que tipo de proveedor estamos guardando
    if(($('#apellido').val() == "") && ($('#razon_social').val() != "")){
        // es una persona juridica
        objAH.razon_social    = $('#razon_social').val();
        objAH.tipo_proveedor  = 'persona_juridica';
    }else{
        // persona fisica
        objAH.nombre              = $('#nombre').val();
        objAH.apellido            = $('#apellido').val();
        objAH.tipo_documento      = $('#tipo_documento_id').val();
        objAH.nro_doc             = $('#numero_documento').val(); 
        objAH.tipo_proveedor      = 'persona_fisica';
    }
    objAH.cuit_cuil           = $('#cuit_cuil').val();
    objAH.ciudad              = $('#id_ciudad').val();
    objAH.domicilio           = $('#domicilio').val();
    objAH.telefono            = $('#telefono').val();
    objAH.fax                 = $('#fax').val();
    objAH.email               = $('#email').val();
    objAH.plazo_reclamo       = $('#plazo_reclamo').val();
    objAH.proveedor_activo    = $('#proveedor_activo').val();
    objAH.materiales_array    = getMateriales() 
    objAH.formas_envios_array = getFormasEnvio() 

    objAH.tipoAccion          = 'GUARDAR_MODIFICACION_PROVEEDOR';
    objAH.sendToServer();
}

function updateDatosProveedor(responseText){
    if (!verificarRespuesta(responseText))
        return(0);
    var Messages=JSONstring.toObject(responseText);
    setMessages(Messages);
}

function changePage(ini){
    objAH.changePage(ini);
}
