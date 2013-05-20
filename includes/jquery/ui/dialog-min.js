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

(function($,undefined){var uiDialogClasses='ui-dialog '+
'ui-widget '+
'ui-widget-content '+
'ui-corner-all ';$.widget("ui.dialog",{options:{autoOpen:true,buttons:{},closeOnEscape:true,closeText:'close',dialogClass:'',draggable:true,hide:null,height:'auto',maxHeight:false,maxWidth:false,minHeight:150,minWidth:150,modal:false,position:{my:'center',at:'center',of:window,collision:'fit',using:function(pos){var topOffset=$(this).css(pos).offset().top;if(topOffset<0){$(this).css('top',pos.top-topOffset);}}},resizable:true,show:null,stack:true,title:'',width:300,zIndex:1000},_create:function(){this.originalTitle=this.element.attr('title');if(typeof this.originalTitle!=="string"){this.originalTitle="";}
this.options.title=this.options.title||this.originalTitle;var self=this,options=self.options,title=options.title||'&#160;',titleId=$.ui.dialog.getTitleId(self.element),uiDialog=(self.uiDialog=$('<div></div>'))
.appendTo(document.body)
.hide()
.addClass(uiDialogClasses+options.dialogClass)
.css({zIndex:options.zIndex})
.attr('tabIndex',-1).css('outline',0).keydown(function(event){if(options.closeOnEscape&&event.keyCode&&event.keyCode===$.ui.keyCode.ESCAPE){self.close(event);event.preventDefault();}})
.attr({role:'dialog','aria-labelledby':titleId})
.mousedown(function(event){self.moveToTop(false,event);}),uiDialogContent=self.element
.show()
.removeAttr('title')
.addClass('ui-dialog-content '+
'ui-widget-content')
.appendTo(uiDialog),uiDialogTitlebar=(self.uiDialogTitlebar=$('<div></div>'))
.addClass('ui-dialog-titlebar '+
'ui-widget-header '+
'ui-corner-all '+
'ui-helper-clearfix')
.prependTo(uiDialog),uiDialogTitlebarClose=$('<a href="#"></a>')
.addClass('ui-dialog-titlebar-close '+
'ui-corner-all')
.attr('role','button')
.hover(function(){uiDialogTitlebarClose.addClass('ui-state-hover');},function(){uiDialogTitlebarClose.removeClass('ui-state-hover');})
.focus(function(){uiDialogTitlebarClose.addClass('ui-state-focus');})
.blur(function(){uiDialogTitlebarClose.removeClass('ui-state-focus');})
.click(function(event){self.close(event);return false;})
.appendTo(uiDialogTitlebar),uiDialogTitlebarCloseText=(self.uiDialogTitlebarCloseText=$('<span></span>'))
.addClass('ui-icon '+
'ui-icon-closethick')
.text(options.closeText)
.appendTo(uiDialogTitlebarClose),uiDialogTitle=$('<span></span>')
.addClass('ui-dialog-title')
.attr('id',titleId)
.html(title)
.prependTo(uiDialogTitlebar);if($.isFunction(options.beforeclose)&&!$.isFunction(options.beforeClose)){options.beforeClose=options.beforeclose;}
uiDialogTitlebar.find("*").add(uiDialogTitlebar).disableSelection();if(options.draggable&&$.fn.draggable){self._makeDraggable();}
if(options.resizable&&$.fn.resizable){self._makeResizable();}
self._createButtons(options.buttons);self._isOpen=false;if($.fn.bgiframe){uiDialog.bgiframe();}},_init:function(){if(this.options.autoOpen){this.open();}},destroy:function(){var self=this;if(self.overlay){self.overlay.destroy();}
self.uiDialog.hide();self.element
.unbind('.dialog')
.removeData('dialog')
.removeClass('ui-dialog-content ui-widget-content')
.hide().appendTo('body');self.uiDialog.remove();if(self.originalTitle){self.element.attr('title',self.originalTitle);}
return self;},widget:function(){return this.uiDialog;},close:function(event){var self=this,maxZ;if(false===self._trigger('beforeClose',event)){return;}
if(self.overlay){self.overlay.destroy();}
self.uiDialog.unbind('keypress.ui-dialog');self._isOpen=false;if(self.options.hide){self.uiDialog.hide(self.options.hide,function(){self._trigger('close',event);});}else{self.uiDialog.hide();self._trigger('close',event);}
$.ui.dialog.overlay.resize();if(self.options.modal){maxZ=0;$('.ui-dialog').each(function(){if(this!==self.uiDialog[0]){maxZ=Math.max(maxZ,$(this).css('z-index'));}});$.ui.dialog.maxZ=maxZ;}
return self;},isOpen:function(){return this._isOpen;},moveToTop:function(force,event){var self=this,options=self.options,saveScroll;if((options.modal&&!force)||(!options.stack&&!options.modal)){return self._trigger('focus',event);}
if(options.zIndex>$.ui.dialog.maxZ){$.ui.dialog.maxZ=options.zIndex;}
if(self.overlay){$.ui.dialog.maxZ+=1;self.overlay.$el.css('z-index',$.ui.dialog.overlay.maxZ=$.ui.dialog.maxZ);}
saveScroll={scrollTop:self.element.attr('scrollTop'),scrollLeft:self.element.attr('scrollLeft')};$.ui.dialog.maxZ+=1;self.uiDialog.css('z-index',$.ui.dialog.maxZ);self.element.attr(saveScroll);self._trigger('focus',event);return self;},open:function(){if(this._isOpen){return;}
var self=this,options=self.options,uiDialog=self.uiDialog;self.overlay=options.modal?new $.ui.dialog.overlay(self):null;if(uiDialog.next().length){uiDialog.appendTo('body');}
self._size();self._position(options.position);uiDialog.show(options.show);self.moveToTop(true);if(options.modal){uiDialog.bind('keypress.ui-dialog',function(event){if(event.keyCode!==$.ui.keyCode.TAB){return;}
var tabbables=$(':tabbable',this),first=tabbables.filter(':first'),last=tabbables.filter(':last');if(event.target===last[0]&&!event.shiftKey){first.focus(1);return false;}else if(event.target===first[0]&&event.shiftKey){last.focus(1);return false;}});}
$(self.element.find(':tabbable').get().concat(uiDialog.find('.ui-dialog-buttonpane :tabbable').get().concat(uiDialog.get()))).eq(0).focus();self._isOpen=true;self._trigger('open');return self;},_createButtons:function(buttons){var self=this,hasButtons=false,uiDialogButtonPane=$('<div></div>')
.addClass('ui-dialog-buttonpane '+
'ui-widget-content '+
'ui-helper-clearfix'),uiButtonSet=$("<div></div>")
.addClass("ui-dialog-buttonset")
.appendTo(uiDialogButtonPane);self.uiDialog.find('.ui-dialog-buttonpane').remove();if(typeof buttons==='object'&&buttons!==null){$.each(buttons,function(){return!(hasButtons=true);});}
if(hasButtons){$.each(buttons,function(name,props){props=$.isFunction(props)?{click:props,text:name}:props;var button=$('<button></button>',props)
.unbind('click')
.click(function(){props.click.apply(self.element[0],arguments);})
.appendTo(uiButtonSet);if($.fn.button){button.button();}});uiDialogButtonPane.appendTo(self.uiDialog);}},_makeDraggable:function(){var self=this,options=self.options,doc=$(document),heightBeforeDrag;function filteredUi(ui){return{position:ui.position,offset:ui.offset};}
self.uiDialog.draggable({cancel:'.ui-dialog-content, .ui-dialog-titlebar-close',handle:'.ui-dialog-titlebar',containment:'document',start:function(event,ui){heightBeforeDrag=options.height==="auto"?"auto":$(this).height();$(this).height($(this).height()).addClass("ui-dialog-dragging");self._trigger('dragStart',event,filteredUi(ui));},drag:function(event,ui){self._trigger('drag',event,filteredUi(ui));},stop:function(event,ui){options.position=[ui.position.left-doc.scrollLeft(),ui.position.top-doc.scrollTop()];$(this).removeClass("ui-dialog-dragging").height(heightBeforeDrag);self._trigger('dragStop',event,filteredUi(ui));$.ui.dialog.overlay.resize();}});},_makeResizable:function(handles){handles=(handles===undefined?this.options.resizable:handles);var self=this,options=self.options,position=self.uiDialog.css('position'),resizeHandles=(typeof handles==='string'?handles:'n,e,s,w,se,sw,ne,nw');function filteredUi(ui){return{originalPosition:ui.originalPosition,originalSize:ui.originalSize,position:ui.position,size:ui.size};}
self.uiDialog.resizable({cancel:'.ui-dialog-content',containment:'document',alsoResize:self.element,maxWidth:options.maxWidth,maxHeight:options.maxHeight,minWidth:options.minWidth,minHeight:self._minHeight(),handles:resizeHandles,start:function(event,ui){$(this).addClass("ui-dialog-resizing");self._trigger('resizeStart',event,filteredUi(ui));},resize:function(event,ui){self._trigger('resize',event,filteredUi(ui));},stop:function(event,ui){$(this).removeClass("ui-dialog-resizing");options.height=$(this).height();options.width=$(this).width();self._trigger('resizeStop',event,filteredUi(ui));$.ui.dialog.overlay.resize();}})
.css('position',position)
.find('.ui-resizable-se').addClass('ui-icon ui-icon-grip-diagonal-se');},_minHeight:function(){var options=this.options;if(options.height==='auto'){return options.minHeight;}else{return Math.min(options.minHeight,options.height);}},_position:function(position){var myAt=[],offset=[0,0],isVisible;if(position){if(typeof position==='string'||(typeof position==='object'&&'0'in position)){myAt=position.split?position.split(' '):[position[0],position[1]];if(myAt.length===1){myAt[1]=myAt[0];}
$.each(['left','top'],function(i,offsetPosition){if(+myAt[i]===myAt[i]){offset[i]=myAt[i];myAt[i]=offsetPosition;}});position={my:myAt.join(" "),at:myAt.join(" "),offset:offset.join(" ")};}
position=$.extend({},$.ui.dialog.prototype.options.position,position);}else{position=$.ui.dialog.prototype.options.position;}
isVisible=this.uiDialog.is(':visible');if(!isVisible){this.uiDialog.show();}
this.uiDialog
.css({top:0,left:0})
.position(position);if(!isVisible){this.uiDialog.hide();}},_setOption:function(key,value){var self=this,uiDialog=self.uiDialog,isResizable=uiDialog.is(':data(resizable)'),resize=false;switch(key){case"beforeclose":key="beforeClose";break;case"buttons":self._createButtons(value);resize=true;break;case"closeText":self.uiDialogTitlebarCloseText.text(""+value);break;case"dialogClass":uiDialog
.removeClass(self.options.dialogClass)
.addClass(uiDialogClasses+value);break;case"disabled":if(value){uiDialog.addClass('ui-dialog-disabled');}else{uiDialog.removeClass('ui-dialog-disabled');}
break;case"draggable":if(value){self._makeDraggable();}else{uiDialog.draggable('destroy');}
break;case"height":resize=true;break;case"maxHeight":if(isResizable){uiDialog.resizable('option','maxHeight',value);}
resize=true;break;case"maxWidth":if(isResizable){uiDialog.resizable('option','maxWidth',value);}
resize=true;break;case"minHeight":if(isResizable){uiDialog.resizable('option','minHeight',value);}
resize=true;break;case"minWidth":if(isResizable){uiDialog.resizable('option','minWidth',value);}
resize=true;break;case"position":self._position(value);break;case"resizable":if(isResizable&&!value){uiDialog.resizable('destroy');}
if(isResizable&&typeof value==='string'){uiDialog.resizable('option','handles',value);}
if(!isResizable&&value!==false){self._makeResizable(value);}
break;case"title":$(".ui-dialog-title",self.uiDialogTitlebar).html(""+(value||'&#160;'));break;case"width":resize=true;break;}
$.Widget.prototype._setOption.apply(self,arguments);if(resize){self._size();}},_size:function(){var options=this.options,nonContentHeight;this.element.css({width:'auto',minHeight:0,height:0});if(options.minWidth>options.width){options.width=options.minWidth;}
nonContentHeight=this.uiDialog.css({height:'auto',width:options.width})
.height();this.element
.css(options.height==='auto'?{minHeight:Math.max(options.minHeight-nonContentHeight,0),height:$.support.minHeight?'auto':Math.max(options.minHeight-nonContentHeight,0)}:{minHeight:0,height:Math.max(options.height-nonContentHeight,0)})
.show();if(this.uiDialog.is(':data(resizable)')){this.uiDialog.resizable('option','minHeight',this._minHeight());}}});$.extend($.ui.dialog,{version:"1.8.5",uuid:0,maxZ:0,getTitleId:function($el){var id=$el.attr('id');if(!id){this.uuid+=1;id=this.uuid;}
return'ui-dialog-title-'+id;},overlay:function(dialog){this.$el=$.ui.dialog.overlay.create(dialog);}});$.extend($.ui.dialog.overlay,{instances:[],oldInstances:[],maxZ:0,events:$.map('focus,mousedown,mouseup,keydown,keypress,click'.split(','),function(event){return event+'.dialog-overlay';}).join(' '),create:function(dialog){if(this.instances.length===0){setTimeout(function(){if($.ui.dialog.overlay.instances.length){$(document).bind($.ui.dialog.overlay.events,function(event){if($(event.target).zIndex()<$.ui.dialog.overlay.maxZ){return false;}});}},1);$(document).bind('keydown.dialog-overlay',function(event){if(dialog.options.closeOnEscape&&event.keyCode&&event.keyCode===$.ui.keyCode.ESCAPE){dialog.close(event);event.preventDefault();}});$(window).bind('resize.dialog-overlay',$.ui.dialog.overlay.resize);}
var $el=(this.oldInstances.pop()||$('<div></div>').addClass('ui-widget-overlay'))
.appendTo(document.body)
.css({width:this.width(),height:this.height()});if($.fn.bgiframe){$el.bgiframe();}
this.instances.push($el);return $el;},destroy:function($el){this.oldInstances.push(this.instances.splice($.inArray($el,this.instances),1)[0]);if(this.instances.length===0){$([document,window]).unbind('.dialog-overlay');}
$el.remove();var maxZ=0;$.each(this.instances,function(){maxZ=Math.max(maxZ,this.css('z-index'));});this.maxZ=maxZ;},height:function(){var scrollHeight,offsetHeight;if($.browser.msie&&$.browser.version<7){scrollHeight=Math.max(document.documentElement.scrollHeight,document.body.scrollHeight);offsetHeight=Math.max(document.documentElement.offsetHeight,document.body.offsetHeight);if(scrollHeight<offsetHeight){return $(window).height()+'px';}else{return scrollHeight+'px';}
}else{return $(document).height()+'px';}},width:function(){var scrollWidth,offsetWidth;if($.browser.msie&&$.browser.version<7){scrollWidth=Math.max(document.documentElement.scrollWidth,document.body.scrollWidth);offsetWidth=Math.max(document.documentElement.offsetWidth,document.body.offsetWidth);if(scrollWidth<offsetWidth){return $(window).width()+'px';}else{return scrollWidth+'px';}
}else{return $(document).width()+'px';}},resize:function(){var $overlays=$([]);$.each($.ui.dialog.overlay.instances,function(){$overlays=$overlays.add(this);});$overlays.css({width:0,height:0}).css({width:$.ui.dialog.overlay.width(),height:$.ui.dialog.overlay.height()});}});$.extend($.ui.dialog.overlay.prototype,{destroy:function(){$.ui.dialog.overlay.destroy(this.$el);}});}(jQuery));