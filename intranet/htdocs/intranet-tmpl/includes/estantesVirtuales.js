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
 * LIBRERIA Estantes Virtuales v 1.0
 *
 */

function mostrarLayer(){
        $('#layer').css('opacity','0.2');
        $('#layer').css('z-index','10000');
        $('#layer').focus();
}


function ocultarLayer(){
        $('#layer').css('opacity','1');
        $('#layer').css('z-index','-1');
}

function changePage(ini){
        mostrarLayer();
        objAH.changePage(ini);
        
    }

function ordenar(orden){
            objAH.sort(orden);
}

function verEstanteDesdeBusqueda(idEstante){
        objAH=new AjaxHelper(updateVerEstanteDesdeBusqueda);
        objAH.debug= true;
        objAH.estante= idEstante;
        objAH.url= '../estantes/estanteDB.pl';
        objAH.tipo= 'VER_ESTANTE_BY_ID';
        objAH.sendToServer();
}

function updateVerEstanteDesdeBusqueda(responseText){
        $('#estante').html(responseText);
        $('.datos_tabla_div').hide();
}



function verEstantes(){
        objAH=new AjaxHelper(updateVerEstantes);
        objAH.debug= true;
        objAH.url= 'estanteDB.pl';
        objAH.tipo= 'VER_ESTANTES';
        objAH.sendToServer();
}

function updateVerEstantes(responseText){
        $('#estante_collapse').html(responseText);
      //  $('#subestante').html('');
        makeToggle('datos_tabla_div_estantes','trigger',null,false);
}



function agregarNuevoSubEstante(estante,padre){
        $('#padre_nuevo_sub_estante').val(padre);
        $('#estante_nuevo_sub_estante').val(estante);
        objAH=new AjaxHelper();
        objAH.showOverlay       = true;
        $('#nuevo_sub_estante').modal();
}



function agregarSubEstante(){

  if ( objAH.valor= $("#input_nuevo_sub_estante").val() ) {
          objAH=new AjaxHelper(updateAgregarSubEstante);
          objAH.debug= true;
          objAH.padre= $("#padre_nuevo_sub_estante").val();
          objAH.estante= $("#estante_nuevo_sub_estante").val();
          objAH.valor= $("#input_nuevo_sub_estante").val();
          objAH.url= 'estanteDB.pl';
          objAH.tipo= 'AGREGAR_SUBESTANTE';
          objAH.sendToServer();
          $('#nuevo_sub_estante').modal('hide');
  }
}

function updateAgregarSubEstante(responseText){
        var Messages= JSONstring.toObject(responseText);
        setMessages(Messages);
         verSubEstantes(objAH.estante,objAH.padre);
}



function verSubEstantes(estante,padre){
        objAH=new AjaxHelper(updateVerSubEstantes);
        objAH.debug= true;
        objAH.showOverlay= true;
        objAH.url= 'estanteDB.pl';
        objAH.estante= estante;
        objAH.padre= padre;
        objAH.tipo= 'VER_SUBESTANTE';
        objAH.sendToServer();
}

function updateVerSubEstantes(responseText){
    if(objAH.padre == 0){
        $('#subestante').html(responseText);
        scrollTo('subestante');
    }
    else{
        $('#subestante-'+ objAH.padre).html(responseText);
        scrollTo('subestante-'+ objAH.padre);
    }
}




function borrarEstantesSeleccionados(estante,padre) {
    var checks;
    if(estante == 0) { 
                        checks=$("#ul_tabla_div_estante_0 input[type='checkbox']:checked");
    } else { 
                        checks=$(".ul_tabla_div_subestante_"+estante+" input[type='checkbox']:checked");
    }
    
    var array=checks.get();
    var theStatus="";
    var estantes=new Array();
    var cant=checks.length;
    if (cant > 0){
        theStatus= ELIMINAR_LOS_ESTANTES+":\n";

        for(i=0;i<checks.length;i++) {
            theStatus=theStatus+"<span class='label label-success'>"+array[i].name+"</span>\n";
            estantes[i]=array[i].value;
        }
        theStatus+= "<br />"+ESTA_SEGURO+"?";

        bootbox.confirm(theStatus, function(confirmStatus){if (confirmStatus) borrarEstantes(estantes,estante,padre);});
    } else { 
        jAlert(NO_SE_SELECCIONO_NINGUN_ESTANTE,ELIMINAR_ESTANTE_TITLE);}
}


function updateBorrarEstantesSeleccionados(responseText){
    var Messages= JSONstring.toObject(responseText);
    setMessages(Messages);
    if (objAH.estante == 0) {verEstantes();} 
        else {verSubEstantes(objAH.estante,objAH.padre);}
}

function borrarEstantes(estantes,estante,padre) {
        objAH=new AjaxHelper(updateBorrarEstantesSeleccionados);
        objAH.debug= true;
        objAH.url= 'estanteDB.pl';
        objAH.estante= estante;
        objAH.padre= padre;
        objAH.estantes= estantes;
        objAH.tipo= 'BORRAR_ESTANTES';
        objAH.sendToServer();
}

function borrarContenidoSeleccionado (estante,padre) {
    var checks=$(".datos_tabla_div_contenido_"+estante+" input[type='checkbox']:checked");
    var array=checks.get();
    var theStatus="";
    var contenido=new Array();
    var cant=checks.length;
    if (cant>0){
        theStatus= ELIMINAR_EL_CONTENIDO+":\n";

        for(i=0;i<checks.length;i++) {
            theStatus=theStatus+"<span class='label label-success'>"+ $('#titulo_'+ estante).val()+ "</span>\n";
            contenido[i]=array[i].value;
        }

        theStatus=theStatus + " " + ESTA_SEGURO+"?";
        
        bootbox.confirm(theStatus, function(confirmStatus){if (confirmStatus) borrarContenido(contenido,estante,padre);});
    }
    else{ jAlert(NO_SE_SELECCIONO_NINGUN_CONTENIDO ,ELIMINAR_CONTENIDO_TITLE);}
}

function updateBorrarContenidoSeleccionado(responseText){
        var Messages= JSONstring.toObject(responseText);
        setMessages(Messages);
        verSubEstantes(objAH.estante,objAH.padre);
}

function borrarContenido(contenido,estante,padre) {
        objAH=new AjaxHelper(updateBorrarContenidoSeleccionado);
        objAH.debug= true;
        objAH.url= 'estanteDB.pl';
        objAH.estante= estante;
        objAH.padre= padre;
        objAH.contenido= contenido;
        if ($('#eliminar_uno').val() == contenido){
          objAH.eliminar_uno= 1;
        }
        objAH.tipo= 'BORRAR_CONTENIDO';
        objAH.sendToServer();
}



function agregarNuevoEstante(){
    objAH=new AjaxHelper();
    objAH.showOverlay       = true;
    $('#nuevo_estante').modal();
}

function agregarEstante(){
    if($("#input_nuevo_estante").val()){
            objAH=new AjaxHelper(updateAgregarEstante);
            objAH.debug= true;
            objAH.url= 'estanteDB.pl';
            objAH.padre=0;
            objAH.estante=$("#input_nuevo_estante").val();
            objAH.tipo= 'AGREGAR_ESTANTE';
            objAH.sendToServer();
            $('#nuevo_estante').modal('hide');
    }
}

function updateAgregarEstante(responseText){
    var Messages= JSONstring.toObject(responseText);
    setMessages(Messages);
    if (!(hayError(Messages))){
            verEstantes();
    }
}


function editarEstante(estante,id,padre,abuelo){
    $('#input_id_estante').val(id);
    $('#input_valor_estante').val(estante);
    $('#input_padre_estante').val(padre);
    $('#input_abuelo_estante').val(abuelo);
    objAH=new AjaxHelper();
    objAH.showOverlay       = true;
    $('#editar_estante').modal();
}

function modificarEstante(){
    if($('#input_valor_estante').val()){
            objAH=new AjaxHelper(updateModificarEstante);
            objAH.debug= true;
            objAH.url= 'estanteDB.pl';
            objAH.estante= $('#input_id_estante').val();
            objAH.abuelo= $('#input_abuelo_estante').val();
            objAH.padre= $('#input_padre_estante').val();
            objAH.valor=$('#input_valor_estante').val();   
            objAH.tipo= 'MODIFICAR_ESTANTE';
            objAH.sendToServer();
            $('#editar_estante').modal('hide');
    }
}

function updateModificarEstante(responseText){
    var Messages= JSONstring.toObject(responseText);
    setMessages(Messages);
    if (!(hayError(Messages))){
        if (objAH.padre == 0){
            verEstantes();
            $('.datos_tabla_div_estantes').hide();
        }
        else {
            verSubEstantes(objAH.padre,objAH.abuelo);
        }
    }
}

function agregarContenido(estante,padre){
      $('#input_contenido_id_estante').val(estante);
      $('#input_contenido_id_padre_estante').val(padre);
      objAH=new AjaxHelper();
      objAH.showOverlay       = true;
      $('#resultado_contenido_estante').hide();
      $('#input_busqueda_contenido').val("");
      $('#contenido_estante').modal();
}

function buscarContenido(){
    
        $('#buscarContBoton').text('Cargando...'); 
        $('#buscarContBoton').toggleClass('disabled');
        objAH=new AjaxHelper(updateBuscarContenido);
        objAH.debug= true;
        objAH.showOverlay       = true;
        objAH.url= 'estanteDB.pl';
        objAH.showStatusIn  = 'busqueda_contenido_estante';
        objAH.funcion = "changePage";
        objAH.only_sphinx = 1;
        objAH.valor=$('#input_busqueda_contenido').val();
        objAH.tipo= 'BUSCAR_CONTENIDO';
        
        objAH.orden= ORDEN;
        objAH.sentido_orden= SENTIDO_ORDEN;

        objAH.sendToServer();
}

function updateBuscarContenido(responseText){
    // var infoHash = JSONstring.toObject(responseText);
    $('#buscarContBoton').replaceWith("<a id=buscarContBoton class='btn btn-primary click' onclick=buscarContenido();><i class='icon-search icon-white'></i> Buscar</a>"); 
	$('#resultado_contenido_estante').html(responseText);

    $('#resultado_contenido_estante').show();
    ocultarLayer();
    
}

// function cambiarSentidoOrd(){
//     if (objAH.sentido_orden == 1){
//                 $('#icon_'+ ORDEN).attr("class","icon-chevron-down click");
//     } else {
//                 $('#icon_'+ ORDEN).attr("class","icon-chevron-up click");
//     }   
// }

function ordenar_busqueda_contenido(orden){

        if (orden == ORDEN) {
             if (SENTIDO_ORDEN == 1){
                    SENTIDO_ORDEN= 0;
             } else {
                    SENTIDO_ORDEN= 1;
             }
          } else {
              SENTIDO_ORDEN= 1;
              ORDEN = orden;
          }
          objAH.sentido_orden = SENTIDO_ORDEN;
          objAH.orden = orden;
          objAH.sort(orden);    
}


function agregarContenidoAEstante(id2 ){
    objAH=new AjaxHelper(updateAgregarContenidoAEstante);
        objAH.debug= true;
        objAH.url= 'estanteDB.pl';
        objAH.estante=$('#input_contenido_id_estante').val();
        objAH.padre=$('#input_contenido_id_padre_estante').val();
        objAH.id2=id2;
        objAH.tipo= 'AGREGAR_CONTENIDO';
        objAH.sendToServer();

}

function updateAgregarContenidoAEstante(responseText){
    var Messages= JSONstring.toObject(responseText);
    
    setMessages(Messages);
    if (!(hayError(Messages))){
            verSubEstantes(objAH.estante,objAH.padre);
    }   
}


function mostrarEstantesVirtualesDeGrupo(id2){
    objAH               = new AjaxHelper(updateInfoEstantesVirtualesDeGrupo);
    objAH.showOverlay       = true;
    objAH.url           = URL_PREFIX+'/busquedas/busquedasDB.pl';
    //se setea la funcion para cambiar de pagina
    objAH.debug         = true;
    objAH.funcion       = 'changePage';
    objAH.estantes_grupo = id2;
    objAH.tipoAccion    = "BUSQUEDA_ESTANTE_DE_GRUPO";
    objAH.sendToServer();
}

function updateInfoEstantesVirtualesDeGrupo(responseText){
    $('#estantes_'+objAH.estantes_grupo).html(responseText);
    $('#estantes_'+objAH.estantes_grupo).slideDown("fast");
//             zebra('datos_tabla');
//             $('#grupo_estantes_'+objAH.estantes_grupo).show();
    scrollTo('estantes_grupo_'+objAH.estantes_grupo);
}

