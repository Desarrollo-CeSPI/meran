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

var Zapatec={};Zapatec.Utils={};Zapatec.Utils.getAbsolutePos=function(el){var SL=0,ST=0;var is_div=/^div$/i.test(el.tagName);if(is_div&&el.scrollLeft)
SL=el.scrollLeft;if(is_div&&el.scrollTop)
ST=el.scrollTop;var r={x:el.offsetLeft-SL,y:el.offsetTop-ST};if(el.offsetParent){var tmp=this.getAbsolutePos(el.offsetParent);r.x+=tmp.x;r.y+=tmp.y;}
return r;};Zapatec.Utils.fixBoxPosition=function(box){if(box.x<0)
box.x=0;if(box.y<0)
box.y=0;var cp=Zapatec.Utils.createElement("div");var s=cp.style;s.position="absolute";s.right=s.bottom=s.width=s.height="0px";window.document.body.appendChild(cp);var br=Zapatec.Utils.getAbsolutePos(cp);window.document.body.removeChild(cp);if(Zapatec.is_ie){br.y+=window.document.body.scrollTop;br.x+=window.document.body.scrollLeft;}else{br.y+=window.scrollY;br.x+=window.scrollX;}
var tmp=box.x+box.width-br.x;if(tmp>0)box.x-=tmp;tmp=box.y+box.height-br.y;if(tmp>0)box.y-=tmp;};Zapatec.Utils.isRelated=function(el,evt){evt||(evt=window.event);var related=evt.relatedTarget;if(!related){var type=evt.type;if(type=="mouseover"){related=evt.fromElement;}else if(type=="mouseout"){related=evt.toElement;}}
try{while(related){if(related==el){return true;}
related=related.parentNode;}}catch(e){};return false;};Zapatec.Utils.removeClass=function(el,className){if(!(el&&el.className)){return;}
var cls=el.className.split(" ");var ar=[];for(var i=cls.length;i>0;){if(cls[--i]!=className){ar[ar.length]=cls[i];}}
el.className=ar.join(" ");};Zapatec.Utils.addClass=function(el,className){Zapatec.Utils.removeClass(el,className);el.className+=" "+className;};Zapatec.Utils.getElement=function(ev){if(Zapatec.is_ie){return window.event.srcElement;}else{return ev.currentTarget;}};Zapatec.Utils.getTargetElement=function(ev){if(Zapatec.is_ie){return window.event.srcElement;}else{return ev.target;}};Zapatec.Utils.stopEvent=function(ev){ev||(ev=window.event);if(ev){if(Zapatec.is_ie){ev.cancelBubble=true;ev.returnValue=false;}else{ev.preventDefault();ev.stopPropagation();}}
return false;};Zapatec.Utils.addEvent=function(el,evname,func){if(el.attachEvent){el.attachEvent("on"+evname,func);}else if(el.addEventListener){el.addEventListener(evname,func,false);}else{el["on"+evname]=func;}};Zapatec.Utils.removeEvent=function(el,evname,func){if(el.detachEvent){el.detachEvent("on"+evname,func);}else if(el.removeEventListener){el.removeEventListener(evname,func,false);}else{el["on"+evname]=null;}};Zapatec.Utils.createElement=function(type,parent){var el=null;if(window.self.document.createElementNS)
el=window.self.document.createElementNS("http://www.w3.org/1999/xhtml",type);else
el=window.self.document.createElement(type);if(typeof parent!="undefined")
parent.appendChild(el);if(Zapatec.is_ie)
el.setAttribute("unselectable",true);if(Zapatec.is_gecko)
el.style.setProperty("-moz-user-select","none","");return el;};Zapatec.Utils.writeCookie=function(name,value,domain,path,exp_days){value=escape(value);var ck=name+"="+value,exp;if(domain)
ck+=";domain="+domain;if(path)
ck+=";path="+path;if(exp_days){exp=new Date();exp.setTime(exp_days*86400000+exp.getTime());ck+=";expires="+exp.toGMTString();}
document.cookie=ck;};Zapatec.Utils.getCookie=function(name){var re=new RegExp("(^|;\\s*)"+name+"\\s*=(.*?)(;|$)");if(re.test(document.cookie)){var value=RegExp.$2;value=unescape(value);return(value);}
return null;};Zapatec.Utils.makePref=function(obj){function stringify(val){if(typeof val=="object"&&!val)
return"null";else if(typeof val=="number"||typeof val=="boolean")
return val;else if(typeof val=="string")
return'"'+val.replace(/\22/,"\\22")+'"';else return null;};var txt="",i;for(i in obj)
txt+=(txt?",'":"'")+i+"':"+stringify(obj[i]);return txt;};Zapatec.Utils.loadPref=function(txt){var obj=null;try{eval("obj={"+txt+"}");}catch(e){}
return obj;};Zapatec.Utils.mergeObjects=function(dest,src){for(var i in src)
dest[i]=src[i];};Zapatec.Utils.__wch_id=0;Zapatec.Utils.createWCH=function(element){var f=null;element=element||window.self.document.body;if(Zapatec.is_ie&&!Zapatec.is_ie5){var filter='filter:progid:DXImageTransform.Microsoft.alpha(style=0,opacity=0);';var id="WCH"+(++Zapatec.Utils.__wch_id);element.insertAdjacentHTML
('beforeEnd','<iframe id="'+id+'" scroll="no" frameborder="0" '+'style="z-index:0;position:absolute;visibility:hidden;'+filter+'border:0;top:0;left:0;width:0;height:0;" '+'src="javascript:false;"></iframe>');f=window.self.document.getElementById(id);}
return f;};Zapatec.Utils.setupWCH_el=function(f,el,el2){if(f){var pos=Zapatec.Utils.getAbsolutePos(el),X1=pos.x,Y1=pos.y,X2=X1+el.offsetWidth,Y2=Y1+el.offsetHeight;if(el2){var p2=Zapatec.Utils.getAbsolutePos(el2),XX1=p2.x,YY1=p2.y,XX2=XX1+el2.offsetWidth,YY2=YY1+el2.offsetHeight;if(X1>XX1)
X1=XX1;if(Y1>YY1)
Y1=YY1;if(X2<XX2)
X2=XX2;if(Y2<YY2)
Y2=YY2;}
Zapatec.Utils.setupWCH(f,X1,Y1,X2-X1,Y2-Y1);}};Zapatec.Utils.setupWCH=function(f,x,y,w,h){if(f){var s=f.style;(typeof x!="undefined")&&(s.left=x+"px");(typeof y!="undefined")&&(s.top=y+"px");(typeof w!="undefined")&&(s.width=w+"px");(typeof h!="undefined")&&(s.height=h+"px");s.visibility="inherit";}};Zapatec.Utils.hideWCH=function(f){if(f)
f.style.visibility="hidden";};Zapatec.Utils.getPageScrollY=function(){return window.pageYOffset||document.documentElement.scrollTop||(document.body?document.body.scrollTop:0)||0;};Zapatec.ScrollWithWindow={};Zapatec.ScrollWithWindow.list=[];Zapatec.ScrollWithWindow.stickiness=0.25;Zapatec.ScrollWithWindow.register=function(node){var top=parseInt(node.style.top)||0;var scrollY=window.pageYOffset||document.body.scrollTop||document.documentElement.scrollTop||0;top-=scrollY;if(top<0)top=0;Zapatec.ScrollWithWindow.list[Zapatec.ScrollWithWindow.list.length]={node:node,origTop:top};};Zapatec.ScrollWithWindow.unregister=function(node){for(var count=0;count<Zapatec.ScrollWithWindow.list.length;count++){var elm=Zapatec.ScrollWithWindow.list[count];if(node==elm.node){Zapatec.ScrollWithWindow.list.splice(count,1);return;}}};Zapatec.ScrollWithWindow.handler=function(newScrollY){oldScrollY+=((newScrollY-oldScrollY)*this.stickiness);if(Math.abs(oldScrollY-newScrollY)<=1)oldScrollY=newScrollY;for(var count=0;count<Zapatec.ScrollWithWindow.list.length;count++){var elm=Zapatec.ScrollWithWindow.list[count];var node=elm.node;if(!elm.origTop){elm.origTop=Zapatec.Utils.getAbsolutePos(node).y;node.style.position='absolute';}
node.style.top=elm.origTop+parseInt(oldScrollY)+'px';}};var oldScrollY=Zapatec.Utils.getPageScrollY();setInterval('var newScrollY = Zapatec.Utils.getPageScrollY(); '+'if (newScrollY != oldScrollY) { '+'Zapatec.ScrollWithWindow.handler(newScrollY); '+'}',50);Zapatec.Utils.destroy=function(el){if(el&&el.parentNode)
el.parentNode.removeChild(el);};Zapatec.Utils.newCenteredWindow=function(url,windowName,width,height,scrollbars){var leftPosition=0;var topPosition=0;if(screen.width)
leftPosition=(screen.width-width)/2;if(screen.height)
topPosition=(screen.height-height)/2;var winArgs='height='+height+',width='+width+',top='+topPosition+',left='+leftPosition+',scrollbars='+scrollbars+',resizable';var win=window.open(url,windowName,winArgs);return win;};Zapatec.Utils.getWindowSize=function(){var windowHeight;var windowWidth;if(Zapatec.is_ie){if(document.documentElement&&(document.documentElement.clientHeight!=0)){windowHeight=document.documentElement.clientHeight
windowWidth=document.documentElement.clientWidth}else{windowHeight=document.body.clientHeight;windowWidth=document.body.offsetWidth;}}else{windowHeight=window.innerHeight;windowWidth=window.innerWidth;}
var dimension={};dimension.height=windowHeight;dimension.width=windowWidth;return dimension;}
Zapatec.Utils.selectOption=function(sel,val,call_default){var a=sel.options,i,o;for(i=a.length;--i>=0;){o=a[i];o.selected=(o.val==val);}
sel.value=val;if(call_default){if(typeof sel.onchange=="function")
sel.onchange();else if(typeof sel.onchange=="string")
eval(sel.onchange);}};Zapatec.Utils.getNextSibling=function(el,tag){el=el.nextSibling;if(!tag)
return el;tag=tag.toLowerCase();while(el&&(el.nodeType!=1||el.tagName.toLowerCase()!=tag))
el=el.nextSibling;return el;};Zapatec.Utils.getFirstChild=function(el,tag){el=el.firstChild;if(!tag)
return el;tag=tag.toLowerCase();if(el.nodeType==1&&el.tagName.toLowerCase()==tag)
return el;return Zapatec.Utils.getNextSibling(el,tag);};Zapatec.Utils._ids={};Zapatec.Utils.generateID=function(code,id){if(typeof id=="undefined"){if(typeof this._ids[code]=="undefined")
this._ids[code]=0;id=++this._ids[code];}
return"zapatec-"+code+"-"+id;};Zapatec.Utils.addTooltip=function(target,tooltip){return new Zapatec.Tooltip(target,tooltip);};Zapatec.isLite=true;Zapatec.Utils.checkActivation=function(){if(!Zapatec.isLite)return true;var bWizard=false;var arrProducts=[];var ii;var scripts=document.getElementsByTagName('script');for(ii=0;ii<scripts.length;ii++)
{if(/src\/calendar.js/i.test(scripts[ii].src))
arrProducts["calendar"]=true
else
if(/src\/menu.js/i.test(scripts[ii].src))
arrProducts["menu"]=true
else
if(/src\/tree.js/i.test(scripts[ii].src))
arrProducts["tree"]=true
if(/wizard.js/i.test(scripts[ii].src))
bWizard=true}
var bProduct=false;for(ii in arrProducts)
if(arrProducts[ii])
{bProduct=true
break}
if(!bProduct)return true;if(bWizard)return true;var anchors=document.getElementsByTagName('A');for(ii=0;ii<anchors.length;ii++)
if(/(dev|www)\.zapatec\.com/i.test(anchors[ii].href))
return true;var strMsg="";strMsg='You are using the Free version of the Zapatec Software.\n'+'While using the Free version, a link to www.zapatec.com in this page is required.'
if(arrProducts["calendar"])
strMsg+='\nTo purchase the Zapatec Calendar visit www.zapatec.com/website/main/products/prod1/.'
if(arrProducts["menu"])
strMsg+='\nTo purchase the Zapatec Menu visit www.zapatec.com/website/main/products/prod2/.'
if(arrProducts["tree"])
strMsg+='\nTo purchase the Zapatec Tree visit www.zapatec.com/website/main/products/prod3/.'
alert(strMsg)
return false;}
Zapatec.is_opera=/opera/i.test(navigator.userAgent);Zapatec.is_ie=(/msie/i.test(navigator.userAgent)&&!Zapatec.is_opera);Zapatec.is_ie5=(Zapatec.is_ie&&/msie 5\.0/i.test(navigator.userAgent));Zapatec.is_mac_ie=(/msie.*mac/i.test(navigator.userAgent)&&!Zapatec.is_opera);Zapatec.is_khtml=/Konqueror|Safari|KHTML/i.test(navigator.userAgent);Zapatec.is_konqueror=/Konqueror/i.test(navigator.userAgent);Zapatec.is_gecko=/Gecko/i.test(navigator.userAgent);