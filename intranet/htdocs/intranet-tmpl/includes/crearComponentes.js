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
 * En este archivo se encuentra todas las funciones para crear los componentes de las paginas, con json.
 * Es utilizado por los tmpl de agregarItem y editarEjemplar
 */

var arrayjson; //arreglo que contendra los objentos que se devuelven como respuesta.

/*
 * objetoRespuesta
 * Objeto que se crea para guardar todos los datos del componente y el valor ingresado para el mismo. Este mismo 
 * se guarda en el arreglo arrayjson.
 */
function objetoRespuesta(nivel,campo,subcampo,idRep,valor){
	this.nivel=nivel;
	this.campo=campo;
	this.subcampo=subcampo;
	this.idRep=idRep;
	this.valor=valor;
}

/*
 * objJSON
 * Objeto que contienen los parametros necesarios para poder ejecutar la consultaAjaxJSON
 * Es un objeto AjaxHelper.
 */
var objJSON;

/*
 * consultarAjaxJSON
 * Funcion que realiza el llamado ajax para obtener el string con los datos necesarios para poder crear los 
 * componentes. Cuando se completa se ejecuta la funcion que procesa el texto que viene de respuesta.
 */
function consultarAjaxJSON(){
	objJSON.url=URL_PREFIX+"/acqui.simple/agregarItemResultsDB.pl";
	objJSON.onComplete=procesarInfoJson;
	objJSON.sendToServer();
}

/*
 * procesarInfoJson
 * procesa la informacion que esta en notacion json, que viene del llamado ajax.
 * @params
 * json, string con formato json.
 */
function procesarInfoJson(json){
	objetos=JSONstring.toObject(json);
	arrayjson=[];
	$("#cantIds").val(objetos.length);
	for(var i=0; i< objetos.length; i++){
		procesarObjeto(objetos[i]);
	}
}

/*
 * procesarObjeto
 * procesa el objeto json, para poder crear el componente adecuado al tipo de datos que vienen en el objeto.
 * @params
 * objeto, elemento que contiene toda la info necesaria.
 */
function procesarObjeto(objeto){
	var libtext=objeto.liblibrarian;
	var tipo= objeto.tipo;
	var ref=objeto.referencia;
	var id=objeto.indice;
	var valor=objeto.valor;
	var varios=objeto.varios;
	var idComp=id;
	var comp;
	var hidden=" ";
	var strComp;
	var auto=0;
	var unoLinea=0;
	var divParrafo="#parrafo1";
	if(objeto.nivel == "3"){
		divParrafo="#parrafo2";
	}
	var idDiv="div"+id;
	var divComp="<div id='"+idDiv+"' style='float: left;padding-right:1%; padding-bottom: 1%;'></div>";
	var divLabel="<div id='label"+id+"' style='float: left; width: 25%;' class='inputFontNormal'>  "+libtext+": </div>";
	strComp="<div id='strComp"+id+"' style='clear:both; padding-top:1%'> "+divLabel+divComp+"</div>";
	$(strComp).appendTo(divParrafo);
	var objetoResp=new objetoRespuesta(objeto.nivel,objeto.campo,objeto.subcampo,objeto.idRep,"");
	arrayjson[id]=objetoResp;
	if(ref==1){
		//id para identificar el input(text) que va a tener el autocomplete
		var accion="reemplazar";
		switch(tipo){
			case "text":
			idComp=parseInt(id)+100;
			comp=crearComponente(tipo,idComp,"","");
			hidden="<br>"+crearComponente("hidden",id,"",valor);
			comp=comp+hidden;
			$(comp).appendTo("#"+idDiv);
			$("#"+idComp).val(objeto.valText);
			auto=1;
			break;
			case "combo":
			var opciones=JSONstring.toObject(objeto.opciones);
			comp=crearComponente(tipo,id,opciones,valor);
			$(comp).appendTo("#"+idDiv);
			break;
			default:
			idComp=parseInt(id)+100;
			accion="concatenar";
			compText=crearComponente("text",idComp,"","");
			comp=crearComponente("texta","texta"+id,"readonly='readonly'","");
			hidden="<br>"+crearComponente("hidden",id,"class='oculto'",valor);
			var boton="<input type='image' value='borrar ultima opcion' onclick='borrarEleccion("+id+")' src='/images/sacar.png'>";
			comp="<div style='float: left;padding-right:1%; padding-bottom: 1%;'>"+comp+hidden+"</div>";
			
			compText=compText+" "+boton;
			$(compText).appendTo("#"+idDiv);
			$(comp).appendTo("#strComp"+id);
			$("#texta"+id).val(objeto.valTextArea);
			auto=1;
			break;
		}
	}
	else{
		if(tipo == "texa2"){
			if(varios){
				var array=valor.split("#");
				valor=array.join("\n");
			}
			comp=(crearComponente("texta",id,"class='unoxlinea'",""));
			$("#label"+id).html($("#label"+id).html()+"<br>UNO POR LINEA");
		}
		else{
			comp=crearComponente(tipo,id,"","");
		}
		$(comp).appendTo("#"+idDiv);
		$("#"+id).val(valor);
	}

	//Se agregan clases para cuando tenga que recuperar los datos.
	if(objeto.obligatorio == "1"){
		$("#"+idComp).addClass("obligatorio");
		$("<b> * </b>").insertAfter($("#"+idComp));
	}
	//Para crear el autocomplete correspondiente
	if(auto){
		var tabla=objeto.tabla;
		var campos=objeto.campos;
		var orden=objeto.orden;
		var separador=objeto.separador;
		crearAuto(idComp,tabla,accion,id,campos,orden,separador);
	}
}

/*
 * crearComponente
 * crea el string HTML del componente correspondiente al parametro tipo.
 * @params
 * tipo, corresponde a la clase de componente html que se quiere crear.
 * id, identificador para el componente que se va a crear.
 * opciones, son las opciones que se generan si el componente es un combobox, para los demas esta en blanco.
 */
function crearComponente(tipo,id,opciones,valor){
	var comp;
	switch(tipo){
		case "text": comp="<input type='"+tipo+"' id='"+id+"' value='"+valor+"'>";
		break;
		case "hidden": comp="<input type='"+tipo+"' "+opciones+" id='"+id+"' value='"+valor+"'>";
		break;
		case "combo": comp="<select id='"+id+"'>\n<option value=''>Elegir opci&oacute;n</option>\n";
			var op="";
			var def="";
			for(var i=0; i< opciones.length; i++){
				if(valor == opciones[i].clave){
					def=" selected='selected' ";
				}
				op=op+"<option value='"+opciones[i].clave+ "'" + def +"'>"+opciones[i].valor+"</option>\n";
				def="";
			}
			comp=comp+op+"</select>";
		break;
		case "texta": comp="<textarea id='"+id+"' "+ opciones +" rows='4'>"+valor+"</textarea>";
		break;
	}
	return comp;
}

/*
 * unoPorLinea
 * genera un array con los elementos que estan el textarea, pero sin blancos o a partir del input hidden que 
 * tiene los id de los datos seleccionados.
 * @params:
 *     id, identificador del textarea que contiene los valores a pasar.
 *     str, string por el cual hay que dividir el valor del componentes ('\n' o '#')
 */
function unoPorLinea(id,str){
	var comp=$("#"+id);
	var arrayValores=comp.val().split(str);
	var array= new Array;
	var i=0;
	for (var j=0;j < arrayValores.length; j++){
		if(arrayValores[j] != ""){
			array[i]=arrayValores[j];
			i++;
		}
	}
	return array;
}

/*
 * obtenerIdsValores
 * obtiene los valores de los componentes generados dinamicamente, y se setea el valor del en el objeto 
 * correspondiente que se encuetra guardado en el arreglo global arrayjson.
 * return ok, 1 si los campos obligatorios no estan vacios, 0 para lo contrario.
 */
function obtenerIdsValores(cantIds){
	//cantIds es la cantidad de input generados dinamicamente
	var i=0;
	var ok=1;
	var comp;
	for(i;i < cantIds; i++){
		comp=$("#"+i);
		if(comp.val() == "" && comp.hasClass("obligatorio")){
			ok=0;
		}
		else{
			if(comp.hasClass("unoxlinea") || comp.hasClass("oculto")){
				var array;
				if(comp.hasClass("unoxlinea")){
					array=unoPorLinea(i,"\n");
				}
				else{
					array=unoPorLinea(i,"#");
				}
				var arrayRep;
				if(arrayjson[i].idRep == ""){
					arrayRep=new Array;
				}
				else{
					arrayRep=arrayjson[i].idRep.split("#");
				}
				arrayjson[i].idRep=arrayRep;
				arrayjson[i].valor=array;
				arrayjson[i].simple=0;
			}
			else{
				arrayjson[i].valor=comp.val();
				arrayjson[i].simple=1;
			}
		}
	}
	return(ok);
}

/*
 * borrarEleccion
 * Borra del componente textarea y del hidden que tiene los ids de la tabla correspondiente, el ultimo valor
 * ingresado.
 * Esta funcion se usa en los input text que son autocompletables con un textarea. (boton).
 */
function borrarEleccion(id){
	var hidden=$("#"+id);
	var texta=$("#texta"+id);
	var arrayHid=hidden.val().split("#");
	var arrayTex=texta.val().split("\n");
	arrayHid.length=arrayHid.length-1;
	arrayTex.length=arrayTex.length-1;
	hidden.val(arrayHid.join("#"));
	texta.val(arrayTex.join("\n"));
}
