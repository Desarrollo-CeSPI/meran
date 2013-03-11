/*
 * LIBRERIA AutocompleteHelper v 1.0.1
 * Esta es una libreria creada para el sistema KOHA
 * Para poder utilizarla es necesario incluir en el tmpl la libreria jquery.js
 *
 */



function _getId(IdObj, id){
    //guardo en hidden el id
    $('#'+IdObj).val(id);
}
    
/*
Esta funcion necesita:
Id = es el id del input sombre el que se va hacer ingreso de datos
IdHidden= id del input hidden donde se guarda el id del resultado seleccionado
url= url donde se realiza la consulta
*/


function _CrearAutocomplete(options){
/*
@params
IdInput= parametro para la busqueda
IdInputHidden= donde se guarda el ID de la busqueda
accion= filtro para autocompletablesDB.pl
function= funcion a ejecutar luego de traer la respuesta del servidor
*/
	if(!(options.IdInput)||!(options.IdInputHidden)){ 
		alert("AutocompleteHelper=> _CrearAutocomplete=> Error en parametros");
		return 0;
	}

    url = URL_PREFIX+"/autocompletablesDB.pl?accion="+options.accion+"&token="+token;

    $("#"+options.IdInput).search();
    // q= valor de campoHelp
    $("#"+options.IdInput).autocomplete(url,{
        formatItem: function(row){
            return row[1];
        },
//         mustMuch: true,
        minChars:3,
		matchSubset:1,
		matchContains:1,
        maxItemsToShow:M_LIMITE_RESULTADOS,
		cacheLength:M_LIMITE_RESULTADOS,
		selectOnly:1,
    });//end autocomplete
    $("#"+options.IdInput).result(function(event, data, formatted) {
        $("#"+options.IdInput).val(data[1]);
        _getId(options.IdInputHidden, data[0]);
		if(options.callBackFunction){
 			options.callBackFunction();
		}
    });
}


function _CrearAutocompleteTextArea(options){
/*
@params
IdInput= parametro para la busqueda
IdInputHidden= donde se guarda el ID de la busqueda
accion= filtro para autocompletablesDB.pl
function= funcion a ejecutar luego de traer la respuesta del servidor
*/
//  if(!(options.IdInput)||!(options.IdInputHidden)){ 
    if(!(options.IdInput)){ 
        alert("AutocompleteHelper=> _CrearAutocomplete=> Error en parametros");
        return 0;
    }

    url = URL_PREFIX+"/autocompletablesDB.pl?accion="+options.accion+"&token="+token;

    $("#"+options.IdInput).search();
    // q= valor de campoHelp
    $("#"+options.IdInput).autocomplete(url,{
        formatItem: function(row){
            return row[1];
        },
        minChars:3,
        matchSubset:1,
        matchContains:1,
        maxItemsToShow:10,
        cacheLength:50,
        selectOnly:1,
        multiple: true,
        matchContains: true,
        formatItem: formatItem,
        formatResult: formatResult,
        multipleSeparator: "\n",
    });//end autocomplete

    $("#"+options.IdInput).result(function(event, data, formatted) {
//         $("#"+options.IdInput).val(data[1]);

        if(options.IdInputHidden){
            _getId(options.IdInputHidden, data[0]);
        }

        if(options.callBackFunction){
            options.callBackFunction();
        }
    });
}

//Funciones publicas

function CrearAutocompleteMonedas(options){
    _CrearAutocomplete({    IdInput: options.IdInput, 
                            IdInputHidden: options.IdInputHidden, 
                            accion: 'autocomplete_monedas', 
                            callBackFunction: options.callBackFunction,
                    });
}

function CrearAutocompleteCiudades(options){
    _CrearAutocomplete({	IdInput: options.IdInput, 
							IdInputHidden: options.IdInputHidden, 
							accion: 'autocomplete_ciudades', 
							callBackFunction: options.callBackFunction,
					});
}

function CrearAutocompletePaises(options){
    _CrearAutocomplete({	IdInput: options.IdInput, 
							IdInputHidden: options.IdInputHidden, 
							accion: 'autocomplete_paises', 
							callBackFunction: options.callBackFunction,
					});
}

function CrearAutocompleteLenguajes(options){
    _CrearAutocomplete({	IdInput: options.IdInput, 
							IdInputHidden: options.IdInputHidden, 
							accion: 'autocomplete_lenguajes', 
							callBackFunction: options.callBackFunction,
					});
}

function CrearAutocompleteAutores(options){
    _CrearAutocomplete({	IdInput: options.IdInput, 
							IdInputHidden: options.IdInputHidden, 
							accion: 'autocomplete_autores', 
							callBackFunction: options.callBackFunction,
					});
}

function CrearAutocompleteSoportes(options){
    _CrearAutocomplete({	IdInput: options.IdInput, 
							IdInputHidden: options.IdInputHidden, 
							accion: 'autocomplete_soportes', 
							callBackFunction: options.callBackFunction,
					});
}

function CrearAutocompleteUsuarios(options){
	_CrearAutocomplete(	{	IdInput: options.IdInput, 
							IdInputHidden: options.IdInputHidden, 
							accion: 'autocomplete_usuarios', 
							callBackFunction: options.callBackFunction,
					});
}

function CrearAutocompleteUsuariosByCredential(options){
    _CrearAutocomplete( {   IdInput: options.IdInput, 
                            IdInputHidden: options.IdInputHidden, 
                            accion: 'autocomplete_usuarios_by_credential', 
                            callBackFunction: options.callBackFunction,
                    });
}

function CrearAutocompleteUsuariosConRegularidad(options){
    _CrearAutocomplete( {   IdInput: options.IdInput, 
                            IdInputHidden: options.IdInputHidden, 
                            accion: 'autocomplete_usuarios_con_regularidad', 
                            callBackFunction: options.callBackFunction,
                    });
}

function CrearAutocompleteBarcodes(options){
    _CrearAutocomplete({
							IdInput: options.IdInput, 
							IdInputHidden: options.IdInputHidden, 
							accion: 'autocomplete_barcodes', 
							callBackFunction: options.callBackFunction,
					});	
}

function CrearAutocompleteBarcodesPrestados(options){
    _CrearAutocomplete({
							IdInput: options.IdInput, 
							IdInputHidden: options.IdInputHidden, 
							accion: 'autocomplete_barcodes_prestados', 
							callBackFunction: options.callBackFunction,
					});	
}

function CrearAutocompleteTemas(options){
    _CrearAutocomplete({
							IdInput: options.IdInput, 
							IdInputHidden: options.IdInputHidden, 
							accion: 'autocomplete_temas', 
							callBackFunction: options.callBackFunction,
					});	
}

function CrearAutocompleteEditoriales(options){
    _CrearAutocomplete({
							IdInput: options.IdInput, 
							IdInputHidden: options.IdInputHidden, 
							accion: 'autocomplete_editoriales', 
							callBackFunction: options.callBackFunction,
					});	
}

function CrearAutocompleteAyudaMARC(options){
    _CrearAutocomplete({
							IdInput: options.IdInput, 
							IdInputHidden: options.IdInputHidden, 
							accion: 'autocomplete_ayuda_marc', 
							callBackFunction: options.callBackFunction,
					});	
}

function CrearAutocompleteUI(options){
    _CrearAutocomplete({
                            IdInput: options.IdInput, 
                            IdInputHidden: options.IdInputHidden, 
                            accion: 'autocomplete_UI', 
                            callBackFunction: options.callBackFunction,
                    }); 
}

function CrearAutocompleteCatalogo(options){
     _CrearAutocomplete({	IdInput: options.IdInput, 
 							IdInputHidden: options.IdInputHidden,
 							IdInputAutor: options.IdInputAutor,
 							accion: 'autocomplete_catalogo', 
 							callBackFunction: options.callBackFunction,
 					});
}

// TODO estoy probando el link de analiticas
function CrearAutocompleteNivel2(options){
     _CrearAutocomplete({   IdInput: options.IdInput, 
                            IdInputHidden: options.IdInputHidden,
                            IdInputAutor: options.IdInputAutor,
                            accion: 'autocomplete_nivel2', 
                            callBackFunction: options.callBackFunction,
                    });
}

function CrearAutocompleteCatalogoId(options){
    _CrearAutocomplete({	IdInput: options.IdInput, 
							IdInputHidden: options.IdInputHidden,
							IdInputAutor: options.IdInputAutor,
							accion: 'autocomplete_catalogo_id', 
							callBackFunction: options.callBackFunction,
					});
}

//TODO estoy probando el link de analiticas
function CrearAutocompleteNivel2Id(options){
    _CrearAutocomplete({   IdInput: options.IdInput, 
                           IdInputHidden: options.IdInputHidden,
                           IdInputAutor: options.IdInputAutor,
                           accion: 'autocomplete_nivel2_id', 
                           callBackFunction: options.callBackFunction,
                   });
}