function _WinInit(objWin){_WinAddDiv(objWin);}
function _WinAddDiv(objWin){var contenedor=$('#ventana')[0];var opciones={};var d_height=document.height;var d_width=document.width;var dimmer={height:d_height,width:d_width};if((contenedor==null)&&(objWin.dimmer_On==true)){$('body').append("<div id='dimmer' class='dimmer' style='height:"+dimmer.height+"px; width: "+dimmer.width+"px;top: 0px; visibility: visible; position:absolute'></div>");}
$('body').append("<div id='ventana' class='dimming' style='display:none; height:85%; width:85%; top:10px;'><div class='winHeader'><img align='right' id='cerrar' src='"+imagesForJS+'/cerrar.png'+"'/><span width=100px>"+objWin.titulo+"</span></div><div id='ventanaContenido' class='ventanaContenido' style='height:90%; width:100%; top:10px;'></div></div>");$('#ventanaContenido').html(objWin.html);if(objWin.opacity==true){opciones.opacity='0.7777';}
if(objWin.draggable==true){$('#ventana').draggable(opciones);}else{$('#ventana').draggable('disable');}
$('#cerrar').click(function(){objWin.close()});objWin.log();}
jQuery.fn.centerObject=function(options){var obj=this;var total=0;var dif=0;if($(window).scrollTop()==0){obj.css('top',$(window).height()/2-this.height()/2);}else{total=$(window).height()+$(window).scrollTop();dif=total-$(window).height();obj.css('top',dif+($(window).height())/2);}
obj.css('left',$(window).width()/2-this.width()/2);if(options){if((options.debug)&&(window.console)){console.log("centerObject => \n"+
"Total Vertical: "+total+"\n"+
"Dif: "+dif+"\n"+
"Medio: "+(dif+($(window).height())/2)+
"\n"+
"Total Horizontal: "+$(window).width()+"\n"+
"Medio: "+$(window).width()/2);}}}
function WindowHelper(options){this.debug=false;this.titulo='';this.html='';this.dimmer='';this.dimmer_On=true;this.showState=true;this.draggable=true;this.focus='';if(options.draggable==false){this.draggable=options.draggable;}
this.opacity=true;if(options.opacity==false){this.opacity=options.opacity;}
this.auto_focus=function(){if(this.focus!=''){$('#'+this.focus).focus();}}
this.close=function(){$('#ventana').hide();$('#dimmer').hide();}
this.height=function(height){$('#ventana').height(height);}
this.width=function(width){$('#ventana').width(width);}
this.create=function(){_WinInit(this);}
this.open=function(){$('#ventana').centerObject();$('#ventana').show();this.auto_focus();if(this.dimmer_On==true){$('#dimmer').show();}}
this.log=function(){if((this.debug)&&(window.console)){console.log(" 	WindowHelper => create() "+"\n"+
"opacity: "+this.opacity+"\n"+
"draggable: "+this.draggable+"\n"+
"width: "+$(window).width()+"\n"+
"height: "+$(window).height()+"\n");}}}