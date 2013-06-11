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
 * LIBRERIA addProveedores v 1.0.1
 * Esta es una libreria creada para el sistema KOHA
 * Contendran las funciones para agregar proveedores al sistema
 * Fecha de creacion 10/11/2010
 *
 */ 
//*********************************************Agregar Proveedor*********************************************

var arreglo             = new Array() // global, arreglo con los id de las moneda que se le agregan al proveedor
var array_materiales    = new Array() // globalarreglo de values de materiales a agregar en la base
var array_envios        = new Array() //global, arreglo de values de envios a agregar en la base

function monedas(){
  // agrega monedas en el cliente solamente, y se guardan todos los datos juntos cuando se selecciona "guardar"
  $('#agregar_moneda').click(function(){
      if(($('#moneda').val() == "") || ($('#id_moneda').val() == "")){
          jConfirm(POR_FAVOR_INGRESE_UNA_MONEDA, function(){ })      
      }else{
          var idMonedaNueva  = $('#id_moneda').val()
          var nombreMoneda   = $('#moneda').val()
          
          // preguntamos si esta agregando la misma moneda nuevamente, que no se muestre porque ya esta
          var cantidad = 0 
          $('.monedas').each(function() {     
          if($(this).attr('value') == idMonedaNueva){ 
              cantidad++
          }
          }); 
          // si es 0 la mostramos
          if(cantidad == 0){      
            $('#monedas').append('<ul id="'+idMonedaNueva+'"> <input name="options" class="monedas" type="checkbox" value="'+idMonedaNueva+'"/>'+nombreMoneda+'</ul>') 
          }
          // obtenemos un array con los ids de las monedas a agregar
          var checkeados = 0
          $('.monedas').each(function(index) {
                arreglo[checkeados] = $(this).val()
                checkeados++
           });  

      }     
  }); 
  

   $('#borrar_moneda').click(function(){
           var checkeados = 0
           $('.monedas').each(function() {
             if($(this).attr('checked')){ 
                 arreglo[checkeados] = $(this).val()
                 checkeados++
             }
           });   
           if(checkeados == 0){
               jConfirm(POR_FAVOR_SELECCIONE_LAS_MONEDAS_A_BORRAR, function(){ })
           }else{
               borrarMoneda(arreglo)
           }          
   }); 
   
    function borrarMoneda(arreglo){
      $('.monedas').each(function() {
        if($(this).attr('checked')){ 
          $(this).remove()
          var value = $(this).val()
          $('#'+value+'').remove()
        }
      });
      $('#moneda').val("")
    }
    
}

// materiales
function getMateriales(){
    var i = 0
    $('#tipo_material_id option:selected').each(function(){  
        // para no agregar en el arreglo el option "SIN SELECCIONAR"
        if($(this).val() != ""){
            array_materiales[i] = $(this).val()
            i++
        }
    })
    return array_materiales

}

// envios
function getEnvios(){
    var i = 0
    $('#forma_envio_id option:selected').each(function(){  
        // para no agregar en el arreglo el option "SIN SELECCIONAR"
        if($(this).val() != ""){
            array_envios[i] = $(this).val()
            i++
        }
    })
    return array_envios

}
   

function updateAgregarProveedor(responseText){
    if (!verificarRespuesta(responseText))
            return(0);
    var Messages=JSONstring.toObject(responseText);
    setMessages(Messages);
}

function agregarProveedor(){

      objAH                     = new AjaxHelper(updateAgregarProveedor);
      objAH.url                 = URL_PREFIX+'/adquisiciones/addProveedores.pl';
      objAH.debug               = true;
      objAH.showOverlay         = true;
      objAH.apellido            = $('#apellido').val();
      objAH.nombre              = $('#nombre').val();
      objAH.domicilio           = $('#domicilio').val();
      objAH.tipo_doc            = $('#tipo_documento_id').val();
      objAH.nro_doc             = $('#nro_doc').val();
      objAH.razon_social        = $('#razon_social').val();
      objAH.telefono            = $('#telefono').val();
      objAH.pais                = $('#pais').val();
      objAH.cuit_cuil           = $('#cuit_cuil').val();
      objAH.provincia           = $('#provincia').val();
      objAH.ciudad              = $('#id_ciudad').val();
      objAH.email               = $('#email').val();
      objAH.plazo_reclamo       = $('#plazo_reclamo').val();
      objAH.fax                 = $('#fax').val();  
      objAH.tipo_proveedor      = $('#proveedorDataForm input:radio:checked').val();
      objAH.monedas_array       = arreglo;
      objAH.materiales_array    = getMateriales();
      objAH.formas_envios_array = getEnvios();
      
      objAH.tipoAccion          = 'AGREGAR_PROVEEDOR';
      objAH.sendToServer();
}
// ***************************************** FIN - Agregar Proveedor ******************************************************




// ***************************************** Validaciones ***************************************************************

var HASH_MESSAGES = new Array(); //para manejar las reglas de validacion y sus mensajes del FORM dinamicamente
     
function _freeMemory(array){
  for(var i=0;i<array.length;i++){
    delete array[i];
  }  
}
    
function agregarAHash(HASH, name, value){
  HASH[name] = value;
}
               
//funcion que muestra solo los input necesarios para una persona fisica
function verDatosPersonaFisica(){
  // mostramos el boton guardar
  $('#agregar_proveedor').show()

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
       
  //lo contrario de arriba
  $('#nombre ').addClass('required')
  $('#apellido ').addClass('required')
  $('#tipo_documento_id ').addClass('required')
  $('#nro_doc ').addClass('required')
     
  agregarAHash(HASH_MESSAGES, "nombre", POR_FAVOR_INGRESE_UN_NOMBRE)   
  agregarAHash(HASH_MESSAGES, "apellido", POR_FAVOR_INGRESE_UN_APELLIDO) 
  agregarAHash(HASH_MESSAGES, "nro_doc", POR_FAVOR_INGRESE_UN_NRO_DE_DOC) 
  agregarAHash(HASH_MESSAGES, "tipo_documento_id", POR_FAVOR_INGRESE_UN_TIPO_DE_DOC) 
  agregarAHash(HASH_MESSAGES, "cuit_cuil", POR_FAVOR_INGRESE_UN_CUIT_CUIL)
  agregarAHash(HASH_MESSAGES, "ciudad", POR_FAVOR_INGRESE_UNA_CIUDAD)
  agregarAHash(HASH_MESSAGES, "domicilio", POR_FAVOR_INGRESE_UN_DOMICILIO)
  agregarAHash(HASH_MESSAGES, "telefono", POR_FAVOR_INGRESE_UN_TELEFONO)
  agregarAHash(HASH_MESSAGES, "email", POR_FAVOR_INGRESE_UNA_DIR_DE_EMAIL_VALIDA)
  agregarAHash(HASH_MESSAGES, "tipo_material_id", POR_FAVOR_INGRESE_UN_TIPO_DE_MATERIAL)
  agregarAHash(HASH_MESSAGES, "forma_envio_id", POR_FAVOR_INGRESE_UNA_FORMA_DE_ENVIO)
      
  //remueve los mensajes de error si hubiera alguno
  $('em').remove()
     
  //quita la class required a los input que no se validan       
  $('#razon_social ').removeClass('required');
            
  validateForm(agregarProveedor)
  
  $('#nombre').focus()
}

//funcion que muestra solo los input necesarios para una persona juridica
function verDatosPersonaJuridica(){
  // mostramos el boton guardar
  $('#agregar_proveedor').show()
  
  $('#datos_proveedor').show()
  $('#nombre').hide()
  $('#label_nombre').hide()
  $('#apellido').hide()  
  $('#label_apellido').hide()  
  $('#nro_doc').hide()    
  $('#label_nro_doc').hide()
  $('#tipo_documento_id').hide()
  $('#razon_social').show()
  $('#label_razon_social').show()      
       
  //lo contrario que hacemos arriba
  $('#razon_social ').addClass('required');     
       
  agregarAHash(HASH_MESSAGES, "razon_social", POR_FAVOR_INGRESE_UNA_RAZON_SOCIAL)
  agregarAHash(HASH_MESSAGES, "cuit_cuil", POR_FAVOR_INGRESE_UN_CUIT_CUIL)
  agregarAHash(HASH_MESSAGES, "ciudad", POR_FAVOR_INGRESE_UNA_CIUDAD)
  agregarAHash(HASH_MESSAGES, "domicilio", POR_FAVOR_INGRESE_UN_DOMICILIO)
  agregarAHash(HASH_MESSAGES, "telefono", POR_FAVOR_INGRESE_UN_TELEFONO)
  agregarAHash(HASH_MESSAGES, "email", POR_FAVOR_INGRESE_UNA_DIR_DE_EMAIL_VALIDA)
  agregarAHash(HASH_MESSAGES, "tipo_material_id", POR_FAVOR_INGRESE_UN_TIPO_DE_MATERIAL)
  agregarAHash(HASH_MESSAGES, "forma_envio_id", POR_FAVOR_INGRESE_UNA_FORMA_DE_ENVIO)
   
  //remueve los mensajes de error si hubiera alguno   
  $('em').remove()
       
  //quitar class required a los input que no se validan
  $('#nombre ').removeClass('required')
  $('#apellido ').removeClass('required')
  $('#tipo_documento_id ').removeClass('required')
  $('#nro_doc ').removeClass('required')
       
  validateForm(agregarProveedor)
  
  $('#razon_social').focus()
}

function save(){
   $('#proveedorDataForm').submit();
}


function validateForm(func){

   
         $().ready(function() {
            // validate signup form on keyup and submit
            $.validator.setDefaults({
              submitHandler:  func ,
            });
            $("#proveedorDataForm").validate({
    
                debug: true,
                errorElement: "em",
                errorClass: "error_adv",
                rules: "",
                messages: HASH_MESSAGES,
            });
         });
   }
// ***************************************** FIN - Validaciones ************************************************************
