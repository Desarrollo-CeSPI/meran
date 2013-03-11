/*
 * LIBRERIA AjaxhHelper v 1.0.1
 * Esta es una libreria creada para el sistema KOHA
 * Para poder utilizarla es necesario incluir en el tmpl la libreria jquery.js
 * @author Carbone Miguel, Di Costanzo Damian
 * Fecha de creacion 22/05/2008
 *
 */
var overlay_on = false;

function startOverlay(){
	try{
		if (!overlay_on){
			$('#ajax-indicator').modal({show:true, keyboard: false, backdrop: false,});
			overlay_on = true;
		}
	}
	catch (e){
		
	}
}


function closeModal(id){

	try{
		if ((id == '') || (id == null))
			$('#ajax-indicator').modal('hide');
		else
			$('#'+id).modal('hide');
	}
	catch (e){
	}
	overlay_on = false;
}
//Funciones Privadas para manejar el estado del la consulta de AJAX

function _Init(options){

    if(options.showStatusIn != ''){
    	if (options.offIndicator != true)
    		$('#' + options.showStatusIn).addClass('cargando');
// //         window.console.log("agrego cargando en " + options.showStatusIn);
    }else{

        if(options.showOverlay){
    		startOverlay();
        } else {         
           if (options.showState){
            _ShowState(options);
           }
        }
    }
    
}


function _AddDiv(){

	var contenedor = $('#state')[0];
	if(contenedor == null){
		$('body').append("<div id='state' class='loading' style='position:absolute'>&nbsp;</div>");
//         $('body').append("<div id='state' class='cargando' style='position:absolute'>&nbsp;</div>");
		$('#state').css('top', '0px');
		$('#state').css('left', '0px');

	}
}

//muestra el div
function _ShowState(options){
    _AddDiv();
	$('#state').centerObject(options);	
	$('#state').show();
};

//oculta el div
function _HiddeState(options){
 	
    if(options.showStatusIn != ''){
        $('#' + options.showStatusIn).show();
        $('#' + options.showStatusIn).removeClass('cargando');
    }else{
//         $('#state').hide();
        $('#state').ajaxStop($('#state').hide());    
    }

    if(options.showOverlay){
        $(document).ajaxStop(closeModal());
    }

};

//Esta funcion sirve para centrar un objeto
jQuery.fn.centerObject = function(options) {
// FIXME se deberia tener en cuenta centrar un div con conetnido
	var obj = this;
	var total= 0;
	var dif= 0;

	//se calcula el centro verticalmente
	if($(window).scrollTop() == 0){
		obj.css('top',  $(window).height()/2 - this.height()/2);
	}else{
	//se hizo scroll
	
		total= $(window).height() + $(window).scrollTop();
		dif= total - $(window).height();
		obj.css('top', dif + ( $(window).height() )/2);
	}

	//se calcula el centro horizontalmente
	obj.css('left',$(window).width()/2 - this.width()/2);

	if(options){
		if( (options.debug)&&(window.console) ){
	
			window.console.log(	"centerObject => \n" +
					"Total Vertical: " + total + "\n" + 
					"Dif: " + dif + "\n" + 
					"Medio: " + (dif + ( $(window).height() )/2) +
					"\n" +
					"Total Horizontal: " + $(window).width() + "\n" + 
					"Medio: " +  $(window).width()/2
			);
	
		}
	}

}

function AjaxHelper(fncUpdateInfo, fncInit){

	this.ini            = '';				//para manejar el actual del paginador
	this.funcion        = '';				//nombre de funcion que tiene q conocer el paginador
	this.url            = '';
	this.orden          = '';				//para ordenar los resultados
	this.debug          = false; 			//para debuguear AjaxhHelper
	this.debugJSON      = false;			//para debuguear jsonStringify (JSON)
	this.onComplete     = fncUpdateInfo;  	//se ejecuta cuando se completa el ajax
	this.onBeforeSend   = fncInit;		    //se ejecuta antes de consultar al servidor con ajax
 	this.showState      = true;
	this.cache          = false; 			//para cachear los resultados
	this.showStatusIn   = '';               //muestra el estado del AJAX en el DIV pasado por parametro
	this.showOverlay    = false;            //muestra el overlay y bloquea la pantalla luego de hacer una peticion AJAX
// 	this.showState      = false;
	this.autoClose      = true;             //cierra automaticamente el overlay
	this.async          = true;             //asincronico por defecto

	this.sendToServer= function(){

			//se ejecuta el ajaxz
			this.ajaxCallback(this);

	}//end sendToServer

	this.sort= function(ord){
			
			this.log("AjaxHelper => sort: " + ord);
			//seteo el orden de los resultados
			this.orden= ord;
			//se envia la consulta
			this.sendToServer();
	}

	this.changePage= function(ini){

				this.log("AjaxHelper => changePage: " + ini);

				this.ini= ini;
				this.sendToServer();

	}

	this.log= function(str){
			// if( (this.debug)&&(window.console) ){
			// 		window.console.log(str);
			// }
	}

	this.ajaxCallback= function(helper){
			
			if(this.debugJSON) {JSONstring.debug= true;}
 			helper.token= token;
  			var params= "obj="+JSONstring.make(helper);
			this.log("AjaxHelper => ajaxCallback \n" + params);
			this.log("AjaxHelper => token: " + helper.token);
			
			var _hash_key;
			if(this.cache){
				_hash_key= b64_md5(params);
		        this.log("AjaxHelper => cache element");
                this.log("AjaxHelper => cache hash_key " + _hash_key);
				if (($.jCache != null) && ( $.jCache.hasItem(_hash_key) )){
				//antes de hacer la peticion al servidor, se verifica si la info esta en la cache
					return helper.onComplete($.jCache.getItem(_hash_key));
				}
			}	

			$.ajax({	
					type: "POST", 
					url: helper.url,
					data: params,
					async: helper.async,
 					beforeSend: function(){
                      
						if(helper.showState){
						//muestra el estado del AJAX
                            _Init({debug: helper.debug, showStatusIn: helper.showStatusIn, showOverlay: helper.showOverlay, offIndicator: helper.offIndicator});
						}

						if(helper.onBeforeSend){
							helper.onBeforeSend();
						}

					},
					complete: function(ajax){
						//oculta el estado del AJAX
//                          $('#ajax-indicator').ajaxStop(_HiddeState({showStatusIn: helper.showStatusIn, showOverlay: helper.showOverlay}));
						_HiddeState({showStatusIn: helper.showStatusIn, showOverlay: helper.showOverlay});
						if(helper.onComplete){
							if(ajax.responseText == 'CLIENT_REDIRECT'){
									disableAlert();
                                    window.location = URL_PREFIX+"/redirectController.pl";
							}else{

								if(helper.cache){
									//guardo la respuesta del servidor en la cache
									if ($.jCache)
										$.jCache.setItem(_hash_key, ajax.responseText);
 								}

								//respuesta normal
								helper.onComplete(ajax.responseText);
							}

						}
  					} 
				});
	}

}


