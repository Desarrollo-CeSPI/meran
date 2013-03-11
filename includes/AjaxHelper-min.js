var overlay_on=false;function startOverlay(){try{if(!overlay_on){$('#ajax-indicator').modal({show:true,keyboard:false,backdrop:false,});overlay_on=true;}}
catch(e){}}
function closeModal(id){try{if((id=='')||(id==null))
$('#ajax-indicator').modal('hide');else
$('#'+id).modal('hide');}
catch(e){}
overlay_on=false;}
function _Init(options){if(options.showStatusIn!=''){if(options.offIndicator!=true)
$('#'+options.showStatusIn).addClass('cargando');}else{if(options.showOverlay){startOverlay();}else{if(options.showState){_ShowState(options);}}}}
function _AddDiv(){var contenedor=$('#state')[0];if(contenedor==null){$('body').append("<div id='state' class='loading' style='position:absolute'>&nbsp;</div>");$('#state').css('top','0px');$('#state').css('left','0px');}}
function _ShowState(options){_AddDiv();$('#state').centerObject(options);$('#state').show();};function _HiddeState(options){if(options.showStatusIn!=''){$('#'+options.showStatusIn).show();$('#'+options.showStatusIn).removeClass('cargando');}else{$('#state').ajaxStop($('#state').hide());}
if(options.showOverlay){$(document).ajaxStop(closeModal());}};jQuery.fn.centerObject=function(options){var obj=this;var total=0;var dif=0;if($(window).scrollTop()==0){obj.css('top',$(window).height()/2-this.height()/2);}else{total=$(window).height()+$(window).scrollTop();dif=total-$(window).height();obj.css('top',dif+($(window).height())/2);}
obj.css('left',$(window).width()/2-this.width()/2);if(options){if((options.debug)&&(window.console)){window.console.log("centerObject => \n"+
"Total Vertical: "+total+"\n"+
"Dif: "+dif+"\n"+
"Medio: "+(dif+($(window).height())/2)+
"\n"+
"Total Horizontal: "+$(window).width()+"\n"+
"Medio: "+$(window).width()/2);}}}
function AjaxHelper(fncUpdateInfo,fncInit){this.ini='';this.funcion='';this.url='';this.orden='';this.debug=false;this.debugJSON=false;this.onComplete=fncUpdateInfo;this.onBeforeSend=fncInit;this.showState=true;this.cache=false;this.showStatusIn='';this.showOverlay=false;this.autoClose=true;this.async=true;this.sendToServer=function(){this.ajaxCallback(this);}
this.sort=function(ord){this.log("AjaxHelper => sort: "+ord);this.orden=ord;this.sendToServer();}
this.changePage=function(ini){this.log("AjaxHelper => changePage: "+ini);this.ini=ini;this.sendToServer();}
this.log=function(str){}
this.ajaxCallback=function(helper){if(this.debugJSON){JSONstring.debug=true;}
helper.token=token;var params="obj="+JSONstring.make(helper);this.log("AjaxHelper => ajaxCallback \n"+params);this.log("AjaxHelper => token: "+helper.token);var _hash_key;if(this.cache){_hash_key=b64_md5(params);this.log("AjaxHelper => cache element");this.log("AjaxHelper => cache hash_key "+_hash_key);if(($.jCache!=null)&&($.jCache.hasItem(_hash_key))){return helper.onComplete($.jCache.getItem(_hash_key));}}
$.ajax({type:"POST",url:helper.url,data:params,async:helper.async,beforeSend:function(){if(helper.showState){_Init({debug:helper.debug,showStatusIn:helper.showStatusIn,showOverlay:helper.showOverlay,offIndicator:helper.offIndicator});}
if(helper.onBeforeSend){helper.onBeforeSend();}},complete:function(ajax){_HiddeState({showStatusIn:helper.showStatusIn,showOverlay:helper.showOverlay});if(helper.onComplete){if(ajax.responseText=='CLIENT_REDIRECT'){disableAlert();window.location=URL_PREFIX+"/redirectController.pl";}else{if(helper.cache){if($.jCache)
$.jCache.setItem(_hash_key,ajax.responseText);}
helper.onComplete(ajax.responseText);}}}});}}