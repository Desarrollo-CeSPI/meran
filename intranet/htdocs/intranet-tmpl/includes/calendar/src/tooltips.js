/*
 *
 * Copyright (c) 2004-2005 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 *
 *
 */

Zapatec.Tooltip=function(target,tooltip){var self=this;if(typeof target=="string")
target=document.getElementById(target);if(typeof tooltip=="string")
tooltip=document.getElementById(tooltip);this.visible=false;this.target=target;this.tooltip=tooltip;this.inTooltip=false;this.timeout=null;Zapatec.Utils.addClass(tooltip,"tooltip");document.body.appendChild(tooltip);if(tooltip.title){var title=Zapatec.Utils.createElement("div");tooltip.insertBefore(title,tooltip.firstChild);title.className="title";title.innerHTML=unescape(tooltip.title);tooltip.title="";}
Zapatec.Utils.addEvent(target,"mouseover",function(ev){return self._onMouseMove(ev);});if(Zapatec.Tooltip.prefs.move){Zapatec.Utils.addEvent(target,"mousemove",function(ev){return self._onMouseMove(ev);});}
Zapatec.Utils.addEvent(target,"mouseout",function(ev){return self._onMouseOut(ev);});Zapatec.Utils.addEvent(tooltip,"mouseover",function(ev){self.inTooltip=true;});Zapatec.Utils.addEvent(tooltip,"mouseout",function(ev){ev||(ev=window.event);if(!Zapatec.Utils.isRelated(self.tooltip,ev)){self.inTooltip=false;self.hide();}});self.wch=Zapatec.Utils.createWCH();};Zapatec.Tooltip.setupFromDFN=function(class_re){var dfns=document.getElementsByTagName("dfn");if(typeof class_re=="string")
class_re=new RegExp("(^|\\s)"+class_re+"(\\s|$)","i");for(var i=0;i<dfns.length;++i){var dfn=dfns[i];if(!class_re||class_re.test(dfn.className)){var div=document.createElement("div");if(dfn.title){div.title=dfn.title;dfn.title="";}
while(dfn.firstChild)
div.appendChild(dfn.firstChild);dfn.innerHTML="?";dfn.className="helpIcon";new Zapatec.Tooltip(dfn,div);}}};Zapatec.Tooltip.prefs={move:false};Zapatec.Tooltip._C=null;Zapatec.Tooltip.prototype._onMouseMove=function(ev){ev||(ev=window.event);if(this.timeout){clearTimeout(this.timeout);this.timeout=null;}
if(!this.visible&&!Zapatec.Utils.isRelated(this.target,ev)){var
x=ev.clientX+2,y=ev.clientY+4;this.show(x,y);}};Zapatec.Tooltip.prototype._onMouseOut=function(ev){ev||(ev=window.event);var self=this;if(!Zapatec.Utils.isRelated(this.target,ev)){if(this.timeout){clearTimeout(this.timeout);this.timeout=null;}
this.timeout=setTimeout(function(){self.hide();},150);}};Zapatec.Tooltip.prototype.show=function(x,y){if(Zapatec.Tooltip._C){if(Zapatec.Tooltip._C.timeout){clearTimeout(Zapatec.Tooltip._C.timeout);Zapatec.Tooltip._C.timeout=null;}
Zapatec.Tooltip._C.hide();}
var t=this.tooltip;t.style.left=t.style.top="0px";t.style.display="block";var box={x:x,y:y,width:t.offsetWidth,height:t.offsetHeight};Zapatec.Utils.fixBoxPosition(box);t.style.left=box.x+"px";t.style.top=box.y+"px";Zapatec.Utils.setupWCH_el(this.wch,t);Zapatec.Utils.addClass(this.target,"tooltip-hover");this.visible=true;Zapatec.Tooltip._C=this;};Zapatec.Tooltip.prototype.hide=function(){if(!this.inTooltip){this.tooltip.style.display="none";Zapatec.Utils.hideWCH(this.wch);Zapatec.Utils.removeClass(this.target,"tooltip-hover");this.visible=false;}};