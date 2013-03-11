(function(window,undefined){var document=window.document,navigator=window.navigator,location=window.location;var jQuery=(function(){var jQuery=function(selector,context){return new jQuery.fn.init(selector,context,rootjQuery);},_jQuery=window.jQuery,_$=window.$,rootjQuery,quickExpr=/^(?:[^#<]*(<[\w\W]+>)[^>]*$|#([\w\-]*)$)/,rnotwhite=/\S/,trimLeft=/^\s+/,trimRight=/\s+$/,rsingleTag=/^<(\w+)\s*\/?>(?:<\/\1>)?$/,rvalidchars=/^[\],:{}\s]*$/,rvalidescape=/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,rvalidtokens=/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,rvalidbraces=/(?:^|:|,)(?:\s*\[)+/g,rwebkit=/(webkit)[ \/]([\w.]+)/,ropera=/(opera)(?:.*version)?[ \/]([\w.]+)/,rmsie=/(msie) ([\w.]+)/,rmozilla=/(mozilla)(?:.*? rv:([\w.]+))?/,rdashAlpha=/-([a-z]|[0-9])/ig,rmsPrefix=/^-ms-/,fcamelCase=function(all,letter){return(letter+"").toUpperCase();},userAgent=navigator.userAgent,browserMatch,readyList,DOMContentLoaded,toString=Object.prototype.toString,hasOwn=Object.prototype.hasOwnProperty,push=Array.prototype.push,slice=Array.prototype.slice,trim=String.prototype.trim,indexOf=Array.prototype.indexOf,class2type={};jQuery.fn=jQuery.prototype={constructor:jQuery,init:function(selector,context,rootjQuery){var match,elem,ret,doc;if(!selector){return this;}
if(selector.nodeType){this.context=this[0]=selector;this.length=1;return this;}
if(selector==="body"&&!context&&document.body){this.context=document;this[0]=document.body;this.selector=selector;this.length=1;return this;}
if(typeof selector==="string"){if(selector.charAt(0)==="<"&&selector.charAt(selector.length-1)===">"&&selector.length>=3){match=[null,selector,null];}else{match=quickExpr.exec(selector);}
if(match&&(match[1]||!context)){if(match[1]){context=context instanceof jQuery?context[0]:context;doc=(context?context.ownerDocument||context:document);ret=rsingleTag.exec(selector);if(ret){if(jQuery.isPlainObject(context)){selector=[document.createElement(ret[1])];jQuery.fn.attr.call(selector,context,true);}else{selector=[doc.createElement(ret[1])];}}else{ret=jQuery.buildFragment([match[1]],[doc]);selector=(ret.cacheable?jQuery.clone(ret.fragment):ret.fragment).childNodes;}
return jQuery.merge(this,selector);}else{elem=document.getElementById(match[2]);if(elem&&elem.parentNode){if(elem.id!==match[2]){return rootjQuery.find(selector);}
this.length=1;this[0]=elem;}
this.context=document;this.selector=selector;return this;}
}else if(!context||context.jquery){return(context||rootjQuery).find(selector);}else{return this.constructor(context).find(selector);}
}else if(jQuery.isFunction(selector)){return rootjQuery.ready(selector);}
if(selector.selector!==undefined){this.selector=selector.selector;this.context=selector.context;}
return jQuery.makeArray(selector,this);},selector:"",jquery:"1.7.2",length:0,size:function(){return this.length;},toArray:function(){return slice.call(this,0);},get:function(num){return num==null?this.toArray():(num<0?this[this.length+num]:this[num]);},pushStack:function(elems,name,selector){var ret=this.constructor();if(jQuery.isArray(elems)){push.apply(ret,elems);}else{jQuery.merge(ret,elems);}
ret.prevObject=this;ret.context=this.context;if(name==="find"){ret.selector=this.selector+(this.selector?" ":"")+selector;}else if(name){ret.selector=this.selector+"."+name+"("+selector+")";}
return ret;},each:function(callback,args){return jQuery.each(this,callback,args);},ready:function(fn){jQuery.bindReady();readyList.add(fn);return this;},eq:function(i){i=+i;return i===-1?this.slice(i):this.slice(i,i+1);},first:function(){return this.eq(0);},last:function(){return this.eq(-1);},slice:function(){return this.pushStack(slice.apply(this,arguments),"slice",slice.call(arguments).join(","));},map:function(callback){return this.pushStack(jQuery.map(this,function(elem,i){return callback.call(elem,i,elem);}));},end:function(){return this.prevObject||this.constructor(null);},push:push,sort:[].sort,splice:[].splice};jQuery.fn.init.prototype=jQuery.fn;jQuery.extend=jQuery.fn.extend=function(){var options,name,src,copy,copyIsArray,clone,target=arguments[0]||{},i=1,length=arguments.length,deep=false;if(typeof target==="boolean"){deep=target;target=arguments[1]||{};i=2;}
if(typeof target!=="object"&&!jQuery.isFunction(target)){target={};}
if(length===i){target=this;--i;}
for(;i<length;i++){if((options=arguments[i])!=null){for(name in options){src=target[name];copy=options[name];if(target===copy){continue;}
if(deep&&copy&&(jQuery.isPlainObject(copy)||(copyIsArray=jQuery.isArray(copy)))){if(copyIsArray){copyIsArray=false;clone=src&&jQuery.isArray(src)?src:[];}else{clone=src&&jQuery.isPlainObject(src)?src:{};}
target[name]=jQuery.extend(deep,clone,copy);}else if(copy!==undefined){target[name]=copy;}}}}
return target;};jQuery.extend({noConflict:function(deep){if(window.$===jQuery){window.$=_$;}
if(deep&&window.jQuery===jQuery){window.jQuery=_jQuery;}
return jQuery;},isReady:false,readyWait:1,holdReady:function(hold){if(hold){jQuery.readyWait++;}else{jQuery.ready(true);}},ready:function(wait){if((wait===true&&!--jQuery.readyWait)||(wait!==true&&!jQuery.isReady)){if(!document.body){return setTimeout(jQuery.ready,1);}
jQuery.isReady=true;if(wait!==true&&--jQuery.readyWait>0){return;}
readyList.fireWith(document,[jQuery]);if(jQuery.fn.trigger){jQuery(document).trigger("ready").off("ready");}}},bindReady:function(){if(readyList){return;}
readyList=jQuery.Callbacks("once memory");if(document.readyState==="complete"){return setTimeout(jQuery.ready,1);}
if(document.addEventListener){document.addEventListener("DOMContentLoaded",DOMContentLoaded,false);window.addEventListener("load",jQuery.ready,false);}else if(document.attachEvent){document.attachEvent("onreadystatechange",DOMContentLoaded);window.attachEvent("onload",jQuery.ready);var toplevel=false;try{toplevel=window.frameElement==null;}catch(e){}
if(document.documentElement.doScroll&&toplevel){doScrollCheck();}}},isFunction:function(obj){return jQuery.type(obj)==="function";},isArray:Array.isArray||function(obj){return jQuery.type(obj)==="array";},isWindow:function(obj){return obj!=null&&obj==obj.window;},isNumeric:function(obj){return!isNaN(parseFloat(obj))&&isFinite(obj);},type:function(obj){return obj==null?String(obj):class2type[toString.call(obj)]||"object";},isPlainObject:function(obj){if(!obj||jQuery.type(obj)!=="object"||obj.nodeType||jQuery.isWindow(obj)){return false;}
try{if(obj.constructor&&!hasOwn.call(obj,"constructor")&&!hasOwn.call(obj.constructor.prototype,"isPrototypeOf")){return false;}}catch(e){return false;}
var key;for(key in obj){}
return key===undefined||hasOwn.call(obj,key);},isEmptyObject:function(obj){for(var name in obj){return false;}
return true;},error:function(msg){throw new Error(msg);},parseJSON:function(data){if(typeof data!=="string"||!data){return null;}
data=jQuery.trim(data);if(window.JSON&&window.JSON.parse){return window.JSON.parse(data);}
if(rvalidchars.test(data.replace(rvalidescape,"@")
.replace(rvalidtokens,"]")
.replace(rvalidbraces,""))){return(new Function("return "+data))();}
jQuery.error("Invalid JSON: "+data);},parseXML:function(data){if(typeof data!=="string"||!data){return null;}
var xml,tmp;try{if(window.DOMParser){tmp=new DOMParser();xml=tmp.parseFromString(data,"text/xml");}else{xml=new ActiveXObject("Microsoft.XMLDOM");xml.async="false";xml.loadXML(data);}}catch(e){xml=undefined;}
if(!xml||!xml.documentElement||xml.getElementsByTagName("parsererror").length){jQuery.error("Invalid XML: "+data);}
return xml;},noop:function(){},globalEval:function(data){if(data&&rnotwhite.test(data)){(window.execScript||function(data){window["eval"].call(window,data);})(data);}},camelCase:function(string){return string.replace(rmsPrefix,"ms-").replace(rdashAlpha,fcamelCase);},nodeName:function(elem,name){return elem.nodeName&&elem.nodeName.toUpperCase()===name.toUpperCase();},each:function(object,callback,args){var name,i=0,length=object.length,isObj=length===undefined||jQuery.isFunction(object);if(args){if(isObj){for(name in object){if(callback.apply(object[name],args)===false){break;}}}else{for(;i<length;){if(callback.apply(object[i++],args)===false){break;}}}
}else{if(isObj){for(name in object){if(callback.call(object[name],name,object[name])===false){break;}}}else{for(;i<length;){if(callback.call(object[i],i,object[i++])===false){break;}}}}
return object;},trim:trim?function(text){return text==null?"":trim.call(text);}:function(text){return text==null?"":text.toString().replace(trimLeft,"").replace(trimRight,"");},makeArray:function(array,results){var ret=results||[];if(array!=null){var type=jQuery.type(array);if(array.length==null||type==="string"||type==="function"||type==="regexp"||jQuery.isWindow(array)){push.call(ret,array);}else{jQuery.merge(ret,array);}}
return ret;},inArray:function(elem,array,i){var len;if(array){if(indexOf){return indexOf.call(array,elem,i);}
len=array.length;i=i?i<0?Math.max(0,len+i):i:0;for(;i<len;i++){if(i in array&&array[i]===elem){return i;}}}
return-1;},merge:function(first,second){var i=first.length,j=0;if(typeof second.length==="number"){for(var l=second.length;j<l;j++){first[i++]=second[j];}}else{while(second[j]!==undefined){first[i++]=second[j++];}}
first.length=i;return first;},grep:function(elems,callback,inv){var ret=[],retVal;inv=!!inv;for(var i=0,length=elems.length;i<length;i++){retVal=!!callback(elems[i],i);if(inv!==retVal){ret.push(elems[i]);}}
return ret;},map:function(elems,callback,arg){var value,key,ret=[],i=0,length=elems.length,isArray=elems instanceof jQuery||length!==undefined&&typeof length==="number"&&((length>0&&elems[0]&&elems[length-1])||length===0||jQuery.isArray(elems));if(isArray){for(;i<length;i++){value=callback(elems[i],i,arg);if(value!=null){ret[ret.length]=value;}}
}else{for(key in elems){value=callback(elems[key],key,arg);if(value!=null){ret[ret.length]=value;}}}
return ret.concat.apply([],ret);},guid:1,proxy:function(fn,context){if(typeof context==="string"){var tmp=fn[context];context=fn;fn=tmp;}
if(!jQuery.isFunction(fn)){return undefined;}
var args=slice.call(arguments,2),proxy=function(){return fn.apply(context,args.concat(slice.call(arguments)));};proxy.guid=fn.guid=fn.guid||proxy.guid||jQuery.guid++;return proxy;},access:function(elems,fn,key,value,chainable,emptyGet,pass){var exec,bulk=key==null,i=0,length=elems.length;if(key&&typeof key==="object"){for(i in key){jQuery.access(elems,fn,i,key[i],1,emptyGet,value);}
chainable=1;}else if(value!==undefined){exec=pass===undefined&&jQuery.isFunction(value);if(bulk){if(exec){exec=fn;fn=function(elem,key,value){return exec.call(jQuery(elem),value);};}else{fn.call(elems,value);fn=null;}}
if(fn){for(;i<length;i++){fn(elems[i],key,exec?value.call(elems[i],i,fn(elems[i],key)):value,pass);}}
chainable=1;}
return chainable?elems:bulk?fn.call(elems):length?fn(elems[0],key):emptyGet;},now:function(){return(new Date()).getTime();},uaMatch:function(ua){ua=ua.toLowerCase();var match=rwebkit.exec(ua)||ropera.exec(ua)||rmsie.exec(ua)||ua.indexOf("compatible")<0&&rmozilla.exec(ua)||[];return{browser:match[1]||"",version:match[2]||"0"};},sub:function(){function jQuerySub(selector,context){return new jQuerySub.fn.init(selector,context);}
jQuery.extend(true,jQuerySub,this);jQuerySub.superclass=this;jQuerySub.fn=jQuerySub.prototype=this();jQuerySub.fn.constructor=jQuerySub;jQuerySub.sub=this.sub;jQuerySub.fn.init=function init(selector,context){if(context&&context instanceof jQuery&&!(context instanceof jQuerySub)){context=jQuerySub(context);}
return jQuery.fn.init.call(this,selector,context,rootjQuerySub);};jQuerySub.fn.init.prototype=jQuerySub.fn;var rootjQuerySub=jQuerySub(document);return jQuerySub;},browser:{}});jQuery.each("Boolean Number String Function Array Date RegExp Object".split(" "),function(i,name){class2type["[object "+name+"]"]=name.toLowerCase();});browserMatch=jQuery.uaMatch(userAgent);if(browserMatch.browser){jQuery.browser[browserMatch.browser]=true;jQuery.browser.version=browserMatch.version;}
if(jQuery.browser.webkit){jQuery.browser.safari=true;}
if(rnotwhite.test("\xA0")){trimLeft=/^[\s\xA0]+/;trimRight=/[\s\xA0]+$/;}
rootjQuery=jQuery(document);if(document.addEventListener){DOMContentLoaded=function(){document.removeEventListener("DOMContentLoaded",DOMContentLoaded,false);jQuery.ready();};}else if(document.attachEvent){DOMContentLoaded=function(){if(document.readyState==="complete"){document.detachEvent("onreadystatechange",DOMContentLoaded);jQuery.ready();}};}
function doScrollCheck(){if(jQuery.isReady){return;}
try{document.documentElement.doScroll("left");}catch(e){setTimeout(doScrollCheck,1);return;}
jQuery.ready();}
return jQuery;})();var flagsCache={};function createFlags(flags){var object=flagsCache[flags]={},i,length;flags=flags.split(/\s+/);for(i=0,length=flags.length;i<length;i++){object[flags[i]]=true;}
return object;}
jQuery.Callbacks=function(flags){flags=flags?(flagsCache[flags]||createFlags(flags)):{};var
list=[],stack=[],memory,fired,firing,firingStart,firingLength,firingIndex,add=function(args){var i,length,elem,type,actual;for(i=0,length=args.length;i<length;i++){elem=args[i];type=jQuery.type(elem);if(type==="array"){add(elem);}else if(type==="function"){if(!flags.unique||!self.has(elem)){list.push(elem);}}}},fire=function(context,args){args=args||[];memory=!flags.memory||[context,args];fired=true;firing=true;firingIndex=firingStart||0;firingStart=0;firingLength=list.length;for(;list&&firingIndex<firingLength;firingIndex++){if(list[firingIndex].apply(context,args)===false&&flags.stopOnFalse){memory=true;break;}}
firing=false;if(list){if(!flags.once){if(stack&&stack.length){memory=stack.shift();self.fireWith(memory[0],memory[1]);}}else if(memory===true){self.disable();}else{list=[];}}},self={add:function(){if(list){var length=list.length;add(arguments);if(firing){firingLength=list.length;}else if(memory&&memory!==true){firingStart=length;fire(memory[0],memory[1]);}}
return this;},remove:function(){if(list){var args=arguments,argIndex=0,argLength=args.length;for(;argIndex<argLength;argIndex++){for(var i=0;i<list.length;i++){if(args[argIndex]===list[i]){if(firing){if(i<=firingLength){firingLength--;if(i<=firingIndex){firingIndex--;}}}
list.splice(i--,1);if(flags.unique){break;}}}}}
return this;},has:function(fn){if(list){var i=0,length=list.length;for(;i<length;i++){if(fn===list[i]){return true;}}}
return false;},empty:function(){list=[];return this;},disable:function(){list=stack=memory=undefined;return this;},disabled:function(){return!list;},lock:function(){stack=undefined;if(!memory||memory===true){self.disable();}
return this;},locked:function(){return!stack;},fireWith:function(context,args){if(stack){if(firing){if(!flags.once){stack.push([context,args]);}}else if(!(flags.once&&memory)){fire(context,args);}}
return this;},fire:function(){self.fireWith(this,arguments);return this;},fired:function(){return!!fired;}};return self;};var
sliceDeferred=[].slice;jQuery.extend({Deferred:function(func){var doneList=jQuery.Callbacks("once memory"),failList=jQuery.Callbacks("once memory"),progressList=jQuery.Callbacks("memory"),state="pending",lists={resolve:doneList,reject:failList,notify:progressList},promise={done:doneList.add,fail:failList.add,progress:progressList.add,state:function(){return state;},isResolved:doneList.fired,isRejected:failList.fired,then:function(doneCallbacks,failCallbacks,progressCallbacks){deferred.done(doneCallbacks).fail(failCallbacks).progress(progressCallbacks);return this;},always:function(){deferred.done.apply(deferred,arguments).fail.apply(deferred,arguments);return this;},pipe:function(fnDone,fnFail,fnProgress){return jQuery.Deferred(function(newDefer){jQuery.each({done:[fnDone,"resolve"],fail:[fnFail,"reject"],progress:[fnProgress,"notify"]},function(handler,data){var fn=data[0],action=data[1],returned;if(jQuery.isFunction(fn)){deferred[handler](function(){returned=fn.apply(this,arguments);if(returned&&jQuery.isFunction(returned.promise)){returned.promise().then(newDefer.resolve,newDefer.reject,newDefer.notify);}else{newDefer[action+"With"](this===deferred?newDefer:this,[returned]);}});}else{deferred[handler](newDefer[action]);}});}).promise();},promise:function(obj){if(obj==null){obj=promise;}else{for(var key in promise){obj[key]=promise[key];}}
return obj;}},deferred=promise.promise({}),key;for(key in lists){deferred[key]=lists[key].fire;deferred[key+"With"]=lists[key].fireWith;}
deferred.done(function(){state="resolved";},failList.disable,progressList.lock).fail(function(){state="rejected";},doneList.disable,progressList.lock);if(func){func.call(deferred,deferred);}
return deferred;},when:function(firstParam){var args=sliceDeferred.call(arguments,0),i=0,length=args.length,pValues=new Array(length),count=length,pCount=length,deferred=length<=1&&firstParam&&jQuery.isFunction(firstParam.promise)?firstParam:jQuery.Deferred(),promise=deferred.promise();function resolveFunc(i){return function(value){args[i]=arguments.length>1?sliceDeferred.call(arguments,0):value;if(!(--count)){deferred.resolveWith(deferred,args);}};}
function progressFunc(i){return function(value){pValues[i]=arguments.length>1?sliceDeferred.call(arguments,0):value;deferred.notifyWith(promise,pValues);};}
if(length>1){for(;i<length;i++){if(args[i]&&args[i].promise&&jQuery.isFunction(args[i].promise)){args[i].promise().then(resolveFunc(i),deferred.reject,progressFunc(i));}else{--count;}}
if(!count){deferred.resolveWith(deferred,args);}}else if(deferred!==firstParam){deferred.resolveWith(deferred,length?[firstParam]:[]);}
return promise;}});jQuery.support=(function(){var support,all,a,select,opt,input,fragment,tds,events,eventName,i,isSupported,div=document.createElement("div"),documentElement=document.documentElement;div.setAttribute("className","t");div.innerHTML="   <link/><table></table><a href='/a' style='top:1px;float:left;opacity:.55;'>a</a><input type='checkbox'/>";all=div.getElementsByTagName("*");a=div.getElementsByTagName("a")[0];if(!all||!all.length||!a){return{};}
select=document.createElement("select");opt=select.appendChild(document.createElement("option"));input=div.getElementsByTagName("input")[0];support={leadingWhitespace:(div.firstChild.nodeType===3),tbody:!div.getElementsByTagName("tbody").length,htmlSerialize:!!div.getElementsByTagName("link").length,style:/top/.test(a.getAttribute("style")),hrefNormalized:(a.getAttribute("href")==="/a"),opacity:/^0.55/.test(a.style.opacity),cssFloat:!!a.style.cssFloat,checkOn:(input.value==="on"),optSelected:opt.selected,getSetAttribute:div.className!=="t",enctype:!!document.createElement("form").enctype,html5Clone:document.createElement("nav").cloneNode(true).outerHTML!=="<:nav></:nav>",submitBubbles:true,changeBubbles:true,focusinBubbles:false,deleteExpando:true,noCloneEvent:true,inlineBlockNeedsLayout:false,shrinkWrapBlocks:false,reliableMarginRight:true,pixelMargin:true};jQuery.boxModel=support.boxModel=(document.compatMode==="CSS1Compat");input.checked=true;support.noCloneChecked=input.cloneNode(true).checked;select.disabled=true;support.optDisabled=!opt.disabled;try{delete div.test;}catch(e){support.deleteExpando=false;}
if(!div.addEventListener&&div.attachEvent&&div.fireEvent){div.attachEvent("onclick",function(){support.noCloneEvent=false;});div.cloneNode(true).fireEvent("onclick");}
input=document.createElement("input");input.value="t";input.setAttribute("type","radio");support.radioValue=input.value==="t";input.setAttribute("checked","checked");input.setAttribute("name","t");div.appendChild(input);fragment=document.createDocumentFragment();fragment.appendChild(div.lastChild);support.checkClone=fragment.cloneNode(true).cloneNode(true).lastChild.checked;support.appendChecked=input.checked;fragment.removeChild(input);fragment.appendChild(div);if(div.attachEvent){for(i in{submit:1,change:1,focusin:1}){eventName="on"+i;isSupported=(eventName in div);if(!isSupported){div.setAttribute(eventName,"return;");isSupported=(typeof div[eventName]==="function");}
support[i+"Bubbles"]=isSupported;}}
fragment.removeChild(div);fragment=select=opt=div=input=null;jQuery(function(){var container,outer,inner,table,td,offsetSupport,marginDiv,conMarginTop,style,html,positionTopLeftWidthHeight,paddingMarginBorderVisibility,paddingMarginBorder,body=document.getElementsByTagName("body")[0];if(!body){return;}
conMarginTop=1;paddingMarginBorder="padding:0;margin:0;border:";positionTopLeftWidthHeight="position:absolute;top:0;left:0;width:1px;height:1px;";paddingMarginBorderVisibility=paddingMarginBorder+"0;visibility:hidden;";style="style='"+positionTopLeftWidthHeight+paddingMarginBorder+"5px solid #000;";html="<div "+style+"display:block;'><div style='"+paddingMarginBorder+"0;display:block;overflow:hidden;'></div></div>"+
"<table "+style+"' cellpadding='0' cellspacing='0'>"+
"<tr><td></td></tr></table>";container=document.createElement("div");container.style.cssText=paddingMarginBorderVisibility+"width:0;height:0;position:static;top:0;margin-top:"+conMarginTop+"px";body.insertBefore(container,body.firstChild);div=document.createElement("div");container.appendChild(div);div.innerHTML="<table><tr><td style='"+paddingMarginBorder+"0;display:none'></td><td>t</td></tr></table>";tds=div.getElementsByTagName("td");isSupported=(tds[0].offsetHeight===0);tds[0].style.display="";tds[1].style.display="none";support.reliableHiddenOffsets=isSupported&&(tds[0].offsetHeight===0);if(window.getComputedStyle){div.innerHTML="";marginDiv=document.createElement("div");marginDiv.style.width="0";marginDiv.style.marginRight="0";div.style.width="2px";div.appendChild(marginDiv);support.reliableMarginRight=(parseInt((window.getComputedStyle(marginDiv,null)||{marginRight:0}).marginRight,10)||0)===0;}
if(typeof div.style.zoom!=="undefined"){div.innerHTML="";div.style.width=div.style.padding="1px";div.style.border=0;div.style.overflow="hidden";div.style.display="inline";div.style.zoom=1;support.inlineBlockNeedsLayout=(div.offsetWidth===3);div.style.display="block";div.style.overflow="visible";div.innerHTML="<div style='width:5px;'></div>";support.shrinkWrapBlocks=(div.offsetWidth!==3);}
div.style.cssText=positionTopLeftWidthHeight+paddingMarginBorderVisibility;div.innerHTML=html;outer=div.firstChild;inner=outer.firstChild;td=outer.nextSibling.firstChild.firstChild;offsetSupport={doesNotAddBorder:(inner.offsetTop!==5),doesAddBorderForTableAndCells:(td.offsetTop===5)};inner.style.position="fixed";inner.style.top="20px";offsetSupport.fixedPosition=(inner.offsetTop===20||inner.offsetTop===15);inner.style.position=inner.style.top="";outer.style.overflow="hidden";outer.style.position="relative";offsetSupport.subtractsBorderForOverflowNotVisible=(inner.offsetTop===-5);offsetSupport.doesNotIncludeMarginInBodyOffset=(body.offsetTop!==conMarginTop);if(window.getComputedStyle){div.style.marginTop="1%";support.pixelMargin=(window.getComputedStyle(div,null)||{marginTop:0}).marginTop!=="1%";}
if(typeof container.style.zoom!=="undefined"){container.style.zoom=1;}
body.removeChild(container);marginDiv=div=container=null;jQuery.extend(support,offsetSupport);});return support;})();var rbrace=/^(?:\{.*\}|\[.*\])$/,rmultiDash=/([A-Z])/g;jQuery.extend({cache:{},uuid:0,expando:"jQuery"+(jQuery.fn.jquery+Math.random()).replace(/\D/g,""),noData:{"embed":true,"object":"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000","applet":true},hasData:function(elem){elem=elem.nodeType?jQuery.cache[elem[jQuery.expando]]:elem[jQuery.expando];return!!elem&&!isEmptyDataObject(elem);},data:function(elem,name,data,pvt){if(!jQuery.acceptData(elem)){return;}
var privateCache,thisCache,ret,internalKey=jQuery.expando,getByName=typeof name==="string",isNode=elem.nodeType,cache=isNode?jQuery.cache:elem,id=isNode?elem[internalKey]:elem[internalKey]&&internalKey,isEvents=name==="events";if((!id||!cache[id]||(!isEvents&&!pvt&&!cache[id].data))&&getByName&&data===undefined){return;}
if(!id){if(isNode){elem[internalKey]=id=++jQuery.uuid;}else{id=internalKey;}}
if(!cache[id]){cache[id]={};if(!isNode){cache[id].toJSON=jQuery.noop;}}
if(typeof name==="object"||typeof name==="function"){if(pvt){cache[id]=jQuery.extend(cache[id],name);}else{cache[id].data=jQuery.extend(cache[id].data,name);}}
privateCache=thisCache=cache[id];if(!pvt){if(!thisCache.data){thisCache.data={};}
thisCache=thisCache.data;}
if(data!==undefined){thisCache[jQuery.camelCase(name)]=data;}
if(isEvents&&!thisCache[name]){return privateCache.events;}
if(getByName){ret=thisCache[name];if(ret==null){ret=thisCache[jQuery.camelCase(name)];}}else{ret=thisCache;}
return ret;},removeData:function(elem,name,pvt){if(!jQuery.acceptData(elem)){return;}
var thisCache,i,l,internalKey=jQuery.expando,isNode=elem.nodeType,cache=isNode?jQuery.cache:elem,id=isNode?elem[internalKey]:internalKey;if(!cache[id]){return;}
if(name){thisCache=pvt?cache[id]:cache[id].data;if(thisCache){if(!jQuery.isArray(name)){if(name in thisCache){name=[name];}else{name=jQuery.camelCase(name);if(name in thisCache){name=[name];}else{name=name.split(" ");}}}
for(i=0,l=name.length;i<l;i++){delete thisCache[name[i]];}
if(!(pvt?isEmptyDataObject:jQuery.isEmptyObject)(thisCache)){return;}}}
if(!pvt){delete cache[id].data;if(!isEmptyDataObject(cache[id])){return;}}
if(jQuery.support.deleteExpando||!cache.setInterval){delete cache[id];}else{cache[id]=null;}
if(isNode){if(jQuery.support.deleteExpando){delete elem[internalKey];}else if(elem.removeAttribute){elem.removeAttribute(internalKey);}else{elem[internalKey]=null;}}},_data:function(elem,name,data){return jQuery.data(elem,name,data,true);},acceptData:function(elem){if(elem.nodeName){var match=jQuery.noData[elem.nodeName.toLowerCase()];if(match){return!(match===true||elem.getAttribute("classid")!==match);}}
return true;}});jQuery.fn.extend({data:function(key,value){var parts,part,attr,name,l,elem=this[0],i=0,data=null;if(key===undefined){if(this.length){data=jQuery.data(elem);if(elem.nodeType===1&&!jQuery._data(elem,"parsedAttrs")){attr=elem.attributes;for(l=attr.length;i<l;i++){name=attr[i].name;if(name.indexOf("data-")===0){name=jQuery.camelCase(name.substring(5));dataAttr(elem,name,data[name]);}}
jQuery._data(elem,"parsedAttrs",true);}}
return data;}
if(typeof key==="object"){return this.each(function(){jQuery.data(this,key);});}
parts=key.split(".",2);parts[1]=parts[1]?"."+parts[1]:"";part=parts[1]+"!";return jQuery.access(this,function(value){if(value===undefined){data=this.triggerHandler("getData"+part,[parts[0]]);if(data===undefined&&elem){data=jQuery.data(elem,key);data=dataAttr(elem,key,data);}
return data===undefined&&parts[1]?this.data(parts[0]):data;}
parts[1]=value;this.each(function(){var self=jQuery(this);self.triggerHandler("setData"+part,parts);jQuery.data(this,key,value);self.triggerHandler("changeData"+part,parts);});},null,value,arguments.length>1,null,false);},removeData:function(key){return this.each(function(){jQuery.removeData(this,key);});}});function dataAttr(elem,key,data){if(data===undefined&&elem.nodeType===1){var name="data-"+key.replace(rmultiDash,"-$1").toLowerCase();data=elem.getAttribute(name);if(typeof data==="string"){try{data=data==="true"?true:data==="false"?false:data==="null"?null:jQuery.isNumeric(data)?+data:rbrace.test(data)?jQuery.parseJSON(data):data;}catch(e){}
jQuery.data(elem,key,data);}else{data=undefined;}}
return data;}
function isEmptyDataObject(obj){for(var name in obj){if(name==="data"&&jQuery.isEmptyObject(obj[name])){continue;}
if(name!=="toJSON"){return false;}}
return true;}
function handleQueueMarkDefer(elem,type,src){var deferDataKey=type+"defer",queueDataKey=type+"queue",markDataKey=type+"mark",defer=jQuery._data(elem,deferDataKey);if(defer&&(src==="queue"||!jQuery._data(elem,queueDataKey))&&(src==="mark"||!jQuery._data(elem,markDataKey))){setTimeout(function(){if(!jQuery._data(elem,queueDataKey)&&!jQuery._data(elem,markDataKey)){jQuery.removeData(elem,deferDataKey,true);defer.fire();}},0);}}
jQuery.extend({_mark:function(elem,type){if(elem){type=(type||"fx")+"mark";jQuery._data(elem,type,(jQuery._data(elem,type)||0)+1);}},_unmark:function(force,elem,type){if(force!==true){type=elem;elem=force;force=false;}
if(elem){type=type||"fx";var key=type+"mark",count=force?0:((jQuery._data(elem,key)||1)-1);if(count){jQuery._data(elem,key,count);}else{jQuery.removeData(elem,key,true);handleQueueMarkDefer(elem,type,"mark");}}},queue:function(elem,type,data){var q;if(elem){type=(type||"fx")+"queue";q=jQuery._data(elem,type);if(data){if(!q||jQuery.isArray(data)){q=jQuery._data(elem,type,jQuery.makeArray(data));}else{q.push(data);}}
return q||[];}},dequeue:function(elem,type){type=type||"fx";var queue=jQuery.queue(elem,type),fn=queue.shift(),hooks={};if(fn==="inprogress"){fn=queue.shift();}
if(fn){if(type==="fx"){queue.unshift("inprogress");}
jQuery._data(elem,type+".run",hooks);fn.call(elem,function(){jQuery.dequeue(elem,type);},hooks);}
if(!queue.length){jQuery.removeData(elem,type+"queue "+type+".run",true);handleQueueMarkDefer(elem,type,"queue");}}});jQuery.fn.extend({queue:function(type,data){var setter=2;if(typeof type!=="string"){data=type;type="fx";setter--;}
if(arguments.length<setter){return jQuery.queue(this[0],type);}
return data===undefined?this:this.each(function(){var queue=jQuery.queue(this,type,data);if(type==="fx"&&queue[0]!=="inprogress"){jQuery.dequeue(this,type);}});},dequeue:function(type){return this.each(function(){jQuery.dequeue(this,type);});},delay:function(time,type){time=jQuery.fx?jQuery.fx.speeds[time]||time:time;type=type||"fx";return this.queue(type,function(next,hooks){var timeout=setTimeout(next,time);hooks.stop=function(){clearTimeout(timeout);};});},clearQueue:function(type){return this.queue(type||"fx",[]);},promise:function(type,object){if(typeof type!=="string"){object=type;type=undefined;}
type=type||"fx";var defer=jQuery.Deferred(),elements=this,i=elements.length,count=1,deferDataKey=type+"defer",queueDataKey=type+"queue",markDataKey=type+"mark",tmp;function resolve(){if(!(--count)){defer.resolveWith(elements,[elements]);}}
while(i--){if((tmp=jQuery.data(elements[i],deferDataKey,undefined,true)||(jQuery.data(elements[i],queueDataKey,undefined,true)||jQuery.data(elements[i],markDataKey,undefined,true))&&jQuery.data(elements[i],deferDataKey,jQuery.Callbacks("once memory"),true))){count++;tmp.add(resolve);}}
resolve();return defer.promise(object);}});var rclass=/[\n\t\r]/g,rspace=/\s+/,rreturn=/\r/g,rtype=/^(?:button|input)$/i,rfocusable=/^(?:button|input|object|select|textarea)$/i,rclickable=/^a(?:rea)?$/i,rboolean=/^(?:autofocus|autoplay|async|checked|controls|defer|disabled|hidden|loop|multiple|open|readonly|required|scoped|selected)$/i,getSetAttribute=jQuery.support.getSetAttribute,nodeHook,boolHook,fixSpecified;jQuery.fn.extend({attr:function(name,value){return jQuery.access(this,jQuery.attr,name,value,arguments.length>1);},removeAttr:function(name){return this.each(function(){jQuery.removeAttr(this,name);});},prop:function(name,value){return jQuery.access(this,jQuery.prop,name,value,arguments.length>1);},removeProp:function(name){name=jQuery.propFix[name]||name;return this.each(function(){try{this[name]=undefined;delete this[name];}catch(e){}});},addClass:function(value){var classNames,i,l,elem,setClass,c,cl;if(jQuery.isFunction(value)){return this.each(function(j){jQuery(this).addClass(value.call(this,j,this.className));});}
if(value&&typeof value==="string"){classNames=value.split(rspace);for(i=0,l=this.length;i<l;i++){elem=this[i];if(elem.nodeType===1){if(!elem.className&&classNames.length===1){elem.className=value;}else{setClass=" "+elem.className+" ";for(c=0,cl=classNames.length;c<cl;c++){if(!~setClass.indexOf(" "+classNames[c]+" ")){setClass+=classNames[c]+" ";}}
elem.className=jQuery.trim(setClass);}}}}
return this;},removeClass:function(value){var classNames,i,l,elem,className,c,cl;if(jQuery.isFunction(value)){return this.each(function(j){jQuery(this).removeClass(value.call(this,j,this.className));});}
if((value&&typeof value==="string")||value===undefined){classNames=(value||"").split(rspace);for(i=0,l=this.length;i<l;i++){elem=this[i];if(elem.nodeType===1&&elem.className){if(value){className=(" "+elem.className+" ").replace(rclass," ");for(c=0,cl=classNames.length;c<cl;c++){className=className.replace(" "+classNames[c]+" "," ");}
elem.className=jQuery.trim(className);}else{elem.className="";}}}}
return this;},toggleClass:function(value,stateVal){var type=typeof value,isBool=typeof stateVal==="boolean";if(jQuery.isFunction(value)){return this.each(function(i){jQuery(this).toggleClass(value.call(this,i,this.className,stateVal),stateVal);});}
return this.each(function(){if(type==="string"){var className,i=0,self=jQuery(this),state=stateVal,classNames=value.split(rspace);while((className=classNames[i++])){state=isBool?state:!self.hasClass(className);self[state?"addClass":"removeClass"](className);}}else if(type==="undefined"||type==="boolean"){if(this.className){jQuery._data(this,"__className__",this.className);}
this.className=this.className||value===false?"":jQuery._data(this,"__className__")||"";}});},hasClass:function(selector){var className=" "+selector+" ",i=0,l=this.length;for(;i<l;i++){if(this[i].nodeType===1&&(" "+this[i].className+" ").replace(rclass," ").indexOf(className)>-1){return true;}}
return false;},val:function(value){var hooks,ret,isFunction,elem=this[0];if(!arguments.length){if(elem){hooks=jQuery.valHooks[elem.type]||jQuery.valHooks[elem.nodeName.toLowerCase()];if(hooks&&"get"in hooks&&(ret=hooks.get(elem,"value"))!==undefined){return ret;}
ret=elem.value;return typeof ret==="string"?ret.replace(rreturn,""):ret==null?"":ret;}
return;}
isFunction=jQuery.isFunction(value);return this.each(function(i){var self=jQuery(this),val;if(this.nodeType!==1){return;}
if(isFunction){val=value.call(this,i,self.val());}else{val=value;}
if(val==null){val="";}else if(typeof val==="number"){val+="";}else if(jQuery.isArray(val)){val=jQuery.map(val,function(value){return value==null?"":value+"";});}
hooks=jQuery.valHooks[this.type]||jQuery.valHooks[this.nodeName.toLowerCase()];if(!hooks||!("set"in hooks)||hooks.set(this,val,"value")===undefined){this.value=val;}});}});jQuery.extend({valHooks:{option:{get:function(elem){var val=elem.attributes.value;return!val||val.specified?elem.value:elem.text;}},select:{get:function(elem){var value,i,max,option,index=elem.selectedIndex,values=[],options=elem.options,one=elem.type==="select-one";if(index<0){return null;}
i=one?index:0;max=one?index+1:options.length;for(;i<max;i++){option=options[i];if(option.selected&&(jQuery.support.optDisabled?!option.disabled:option.getAttribute("disabled")===null)&&(!option.parentNode.disabled||!jQuery.nodeName(option.parentNode,"optgroup"))){value=jQuery(option).val();if(one){return value;}
values.push(value);}}
if(one&&!values.length&&options.length){return jQuery(options[index]).val();}
return values;},set:function(elem,value){var values=jQuery.makeArray(value);jQuery(elem).find("option").each(function(){this.selected=jQuery.inArray(jQuery(this).val(),values)>=0;});if(!values.length){elem.selectedIndex=-1;}
return values;}}},attrFn:{val:true,css:true,html:true,text:true,data:true,width:true,height:true,offset:true},attr:function(elem,name,value,pass){var ret,hooks,notxml,nType=elem.nodeType;if(!elem||nType===3||nType===8||nType===2){return;}
if(pass&&name in jQuery.attrFn){return jQuery(elem)[name](value);}
if(typeof elem.getAttribute==="undefined"){return jQuery.prop(elem,name,value);}
notxml=nType!==1||!jQuery.isXMLDoc(elem);if(notxml){name=name.toLowerCase();hooks=jQuery.attrHooks[name]||(rboolean.test(name)?boolHook:nodeHook);}
if(value!==undefined){if(value===null){jQuery.removeAttr(elem,name);return;}else if(hooks&&"set"in hooks&&notxml&&(ret=hooks.set(elem,value,name))!==undefined){return ret;}else{elem.setAttribute(name,""+value);return value;}}else if(hooks&&"get"in hooks&&notxml&&(ret=hooks.get(elem,name))!==null){return ret;}else{ret=elem.getAttribute(name);return ret===null?undefined:ret;}},removeAttr:function(elem,value){var propName,attrNames,name,l,isBool,i=0;if(value&&elem.nodeType===1){attrNames=value.toLowerCase().split(rspace);l=attrNames.length;for(;i<l;i++){name=attrNames[i];if(name){propName=jQuery.propFix[name]||name;isBool=rboolean.test(name);if(!isBool){jQuery.attr(elem,name,"");}
elem.removeAttribute(getSetAttribute?name:propName);if(isBool&&propName in elem){elem[propName]=false;}}}}},attrHooks:{type:{set:function(elem,value){if(rtype.test(elem.nodeName)&&elem.parentNode){jQuery.error("type property can't be changed");}else if(!jQuery.support.radioValue&&value==="radio"&&jQuery.nodeName(elem,"input")){var val=elem.value;elem.setAttribute("type",value);if(val){elem.value=val;}
return value;}}},value:{get:function(elem,name){if(nodeHook&&jQuery.nodeName(elem,"button")){return nodeHook.get(elem,name);}
return name in elem?elem.value:null;},set:function(elem,value,name){if(nodeHook&&jQuery.nodeName(elem,"button")){return nodeHook.set(elem,value,name);}
elem.value=value;}}},propFix:{tabindex:"tabIndex",readonly:"readOnly","for":"htmlFor","class":"className",maxlength:"maxLength",cellspacing:"cellSpacing",cellpadding:"cellPadding",rowspan:"rowSpan",colspan:"colSpan",usemap:"useMap",frameborder:"frameBorder",contenteditable:"contentEditable"},prop:function(elem,name,value){var ret,hooks,notxml,nType=elem.nodeType;if(!elem||nType===3||nType===8||nType===2){return;}
notxml=nType!==1||!jQuery.isXMLDoc(elem);if(notxml){name=jQuery.propFix[name]||name;hooks=jQuery.propHooks[name];}
if(value!==undefined){if(hooks&&"set"in hooks&&(ret=hooks.set(elem,value,name))!==undefined){return ret;}else{return(elem[name]=value);}}else{if(hooks&&"get"in hooks&&(ret=hooks.get(elem,name))!==null){return ret;}else{return elem[name];}}},propHooks:{tabIndex:{get:function(elem){var attributeNode=elem.getAttributeNode("tabindex");return attributeNode&&attributeNode.specified?parseInt(attributeNode.value,10):rfocusable.test(elem.nodeName)||rclickable.test(elem.nodeName)&&elem.href?0:undefined;}}}});jQuery.attrHooks.tabindex=jQuery.propHooks.tabIndex;boolHook={get:function(elem,name){var attrNode,property=jQuery.prop(elem,name);return property===true||typeof property!=="boolean"&&(attrNode=elem.getAttributeNode(name))&&attrNode.nodeValue!==false?name.toLowerCase():undefined;},set:function(elem,value,name){var propName;if(value===false){jQuery.removeAttr(elem,name);}else{propName=jQuery.propFix[name]||name;if(propName in elem){elem[propName]=true;}
elem.setAttribute(name,name.toLowerCase());}
return name;}};if(!getSetAttribute){fixSpecified={name:true,id:true,coords:true};nodeHook=jQuery.valHooks.button={get:function(elem,name){var ret;ret=elem.getAttributeNode(name);return ret&&(fixSpecified[name]?ret.nodeValue!=="":ret.specified)?ret.nodeValue:undefined;},set:function(elem,value,name){var ret=elem.getAttributeNode(name);if(!ret){ret=document.createAttribute(name);elem.setAttributeNode(ret);}
return(ret.nodeValue=value+"");}};jQuery.attrHooks.tabindex.set=nodeHook.set;jQuery.each(["width","height"],function(i,name){jQuery.attrHooks[name]=jQuery.extend(jQuery.attrHooks[name],{set:function(elem,value){if(value===""){elem.setAttribute(name,"auto");return value;}}});});jQuery.attrHooks.contenteditable={get:nodeHook.get,set:function(elem,value,name){if(value===""){value="false";}
nodeHook.set(elem,value,name);}};}
if(!jQuery.support.hrefNormalized){jQuery.each(["href","src","width","height"],function(i,name){jQuery.attrHooks[name]=jQuery.extend(jQuery.attrHooks[name],{get:function(elem){var ret=elem.getAttribute(name,2);return ret===null?undefined:ret;}});});}
if(!jQuery.support.style){jQuery.attrHooks.style={get:function(elem){return elem.style.cssText.toLowerCase()||undefined;},set:function(elem,value){return(elem.style.cssText=""+value);}};}
if(!jQuery.support.optSelected){jQuery.propHooks.selected=jQuery.extend(jQuery.propHooks.selected,{get:function(elem){var parent=elem.parentNode;if(parent){parent.selectedIndex;if(parent.parentNode){parent.parentNode.selectedIndex;}}
return null;}});}
if(!jQuery.support.enctype){jQuery.propFix.enctype="encoding";}
if(!jQuery.support.checkOn){jQuery.each(["radio","checkbox"],function(){jQuery.valHooks[this]={get:function(elem){return elem.getAttribute("value")===null?"on":elem.value;}};});}
jQuery.each(["radio","checkbox"],function(){jQuery.valHooks[this]=jQuery.extend(jQuery.valHooks[this],{set:function(elem,value){if(jQuery.isArray(value)){return(elem.checked=jQuery.inArray(jQuery(elem).val(),value)>=0);}}});});var rformElems=/^(?:textarea|input|select)$/i,rtypenamespace=/^([^\.]*)?(?:\.(.+))?$/,rhoverHack=/(?:^|\s)hover(\.\S+)?\b/,rkeyEvent=/^key/,rmouseEvent=/^(?:mouse|contextmenu)|click/,rfocusMorph=/^(?:focusinfocus|focusoutblur)$/,rquickIs=/^(\w*)(?:#([\w\-]+))?(?:\.([\w\-]+))?$/,quickParse=function(selector){var quick=rquickIs.exec(selector);if(quick){quick[1]=(quick[1]||"").toLowerCase();quick[3]=quick[3]&&new RegExp("(?:^|\\s)"+quick[3]+"(?:\\s|$)");}
return quick;},quickIs=function(elem,m){var attrs=elem.attributes||{};return((!m[1]||elem.nodeName.toLowerCase()===m[1])&&(!m[2]||(attrs.id||{}).value===m[2])&&(!m[3]||m[3].test((attrs["class"]||{}).value)));},hoverHack=function(events){return jQuery.event.special.hover?events:events.replace(rhoverHack,"mouseenter$1 mouseleave$1");};jQuery.event={add:function(elem,types,handler,data,selector){var elemData,eventHandle,events,t,tns,type,namespaces,handleObj,handleObjIn,quick,handlers,special;if(elem.nodeType===3||elem.nodeType===8||!types||!handler||!(elemData=jQuery._data(elem))){return;}
if(handler.handler){handleObjIn=handler;handler=handleObjIn.handler;selector=handleObjIn.selector;}
if(!handler.guid){handler.guid=jQuery.guid++;}
events=elemData.events;if(!events){elemData.events=events={};}
eventHandle=elemData.handle;if(!eventHandle){elemData.handle=eventHandle=function(e){return typeof jQuery!=="undefined"&&(!e||jQuery.event.triggered!==e.type)?jQuery.event.dispatch.apply(eventHandle.elem,arguments):undefined;};eventHandle.elem=elem;}
types=jQuery.trim(hoverHack(types)).split(" ");for(t=0;t<types.length;t++){tns=rtypenamespace.exec(types[t])||[];type=tns[1];namespaces=(tns[2]||"").split(".").sort();special=jQuery.event.special[type]||{};type=(selector?special.delegateType:special.bindType)||type;special=jQuery.event.special[type]||{};handleObj=jQuery.extend({type:type,origType:tns[1],data:data,handler:handler,guid:handler.guid,selector:selector,quick:selector&&quickParse(selector),namespace:namespaces.join(".")},handleObjIn);handlers=events[type];if(!handlers){handlers=events[type]=[];handlers.delegateCount=0;if(!special.setup||special.setup.call(elem,data,namespaces,eventHandle)===false){if(elem.addEventListener){elem.addEventListener(type,eventHandle,false);}else if(elem.attachEvent){elem.attachEvent("on"+type,eventHandle);}}}
if(special.add){special.add.call(elem,handleObj);if(!handleObj.handler.guid){handleObj.handler.guid=handler.guid;}}
if(selector){handlers.splice(handlers.delegateCount++,0,handleObj);}else{handlers.push(handleObj);}
jQuery.event.global[type]=true;}
elem=null;},global:{},remove:function(elem,types,handler,selector,mappedTypes){var elemData=jQuery.hasData(elem)&&jQuery._data(elem),t,tns,type,origType,namespaces,origCount,j,events,special,handle,eventType,handleObj;if(!elemData||!(events=elemData.events)){return;}
types=jQuery.trim(hoverHack(types||"")).split(" ");for(t=0;t<types.length;t++){tns=rtypenamespace.exec(types[t])||[];type=origType=tns[1];namespaces=tns[2];if(!type){for(type in events){jQuery.event.remove(elem,type+types[t],handler,selector,true);}
continue;}
special=jQuery.event.special[type]||{};type=(selector?special.delegateType:special.bindType)||type;eventType=events[type]||[];origCount=eventType.length;namespaces=namespaces?new RegExp("(^|\\.)"+namespaces.split(".").sort().join("\\.(?:.*\\.)?")+"(\\.|$)"):null;for(j=0;j<eventType.length;j++){handleObj=eventType[j];if((mappedTypes||origType===handleObj.origType)&&(!handler||handler.guid===handleObj.guid)&&(!namespaces||namespaces.test(handleObj.namespace))&&(!selector||selector===handleObj.selector||selector==="**"&&handleObj.selector)){eventType.splice(j--,1);if(handleObj.selector){eventType.delegateCount--;}
if(special.remove){special.remove.call(elem,handleObj);}}}
if(eventType.length===0&&origCount!==eventType.length){if(!special.teardown||special.teardown.call(elem,namespaces)===false){jQuery.removeEvent(elem,type,elemData.handle);}
delete events[type];}}
if(jQuery.isEmptyObject(events)){handle=elemData.handle;if(handle){handle.elem=null;}
jQuery.removeData(elem,["events","handle"],true);}},customEvent:{"getData":true,"setData":true,"changeData":true},trigger:function(event,data,elem,onlyHandlers){if(elem&&(elem.nodeType===3||elem.nodeType===8)){return;}
var type=event.type||event,namespaces=[],cache,exclusive,i,cur,old,ontype,special,handle,eventPath,bubbleType;if(rfocusMorph.test(type+jQuery.event.triggered)){return;}
if(type.indexOf("!")>=0){type=type.slice(0,-1);exclusive=true;}
if(type.indexOf(".")>=0){namespaces=type.split(".");type=namespaces.shift();namespaces.sort();}
if((!elem||jQuery.event.customEvent[type])&&!jQuery.event.global[type]){return;}
event=typeof event==="object"?event[jQuery.expando]?event:new jQuery.Event(type,event):new jQuery.Event(type);event.type=type;event.isTrigger=true;event.exclusive=exclusive;event.namespace=namespaces.join(".");event.namespace_re=event.namespace?new RegExp("(^|\\.)"+namespaces.join("\\.(?:.*\\.)?")+"(\\.|$)"):null;ontype=type.indexOf(":")<0?"on"+type:"";if(!elem){cache=jQuery.cache;for(i in cache){if(cache[i].events&&cache[i].events[type]){jQuery.event.trigger(event,data,cache[i].handle.elem,true);}}
return;}
event.result=undefined;if(!event.target){event.target=elem;}
data=data!=null?jQuery.makeArray(data):[];data.unshift(event);special=jQuery.event.special[type]||{};if(special.trigger&&special.trigger.apply(elem,data)===false){return;}
eventPath=[[elem,special.bindType||type]];if(!onlyHandlers&&!special.noBubble&&!jQuery.isWindow(elem)){bubbleType=special.delegateType||type;cur=rfocusMorph.test(bubbleType+type)?elem:elem.parentNode;old=null;for(;cur;cur=cur.parentNode){eventPath.push([cur,bubbleType]);old=cur;}
if(old&&old===elem.ownerDocument){eventPath.push([old.defaultView||old.parentWindow||window,bubbleType]);}}
for(i=0;i<eventPath.length&&!event.isPropagationStopped();i++){cur=eventPath[i][0];event.type=eventPath[i][1];handle=(jQuery._data(cur,"events")||{})[event.type]&&jQuery._data(cur,"handle");if(handle){handle.apply(cur,data);}
handle=ontype&&cur[ontype];if(handle&&jQuery.acceptData(cur)&&handle.apply(cur,data)===false){event.preventDefault();}}
event.type=type;if(!onlyHandlers&&!event.isDefaultPrevented()){if((!special._default||special._default.apply(elem.ownerDocument,data)===false)&&!(type==="click"&&jQuery.nodeName(elem,"a"))&&jQuery.acceptData(elem)){if(ontype&&elem[type]&&((type!=="focus"&&type!=="blur")||event.target.offsetWidth!==0)&&!jQuery.isWindow(elem)){old=elem[ontype];if(old){elem[ontype]=null;}
jQuery.event.triggered=type;elem[type]();jQuery.event.triggered=undefined;if(old){elem[ontype]=old;}}}}
return event.result;},dispatch:function(event){event=jQuery.event.fix(event||window.event);var handlers=((jQuery._data(this,"events")||{})[event.type]||[]),delegateCount=handlers.delegateCount,args=[].slice.call(arguments,0),run_all=!event.exclusive&&!event.namespace,special=jQuery.event.special[event.type]||{},handlerQueue=[],i,j,cur,jqcur,ret,selMatch,matched,matches,handleObj,sel,related;args[0]=event;event.delegateTarget=this;if(special.preDispatch&&special.preDispatch.call(this,event)===false){return;}
if(delegateCount&&!(event.button&&event.type==="click")){jqcur=jQuery(this);jqcur.context=this.ownerDocument||this;for(cur=event.target;cur!=this;cur=cur.parentNode||this){if(cur.disabled!==true){selMatch={};matches=[];jqcur[0]=cur;for(i=0;i<delegateCount;i++){handleObj=handlers[i];sel=handleObj.selector;if(selMatch[sel]===undefined){selMatch[sel]=(handleObj.quick?quickIs(cur,handleObj.quick):jqcur.is(sel));}
if(selMatch[sel]){matches.push(handleObj);}}
if(matches.length){handlerQueue.push({elem:cur,matches:matches});}}}}
if(handlers.length>delegateCount){handlerQueue.push({elem:this,matches:handlers.slice(delegateCount)});}
for(i=0;i<handlerQueue.length&&!event.isPropagationStopped();i++){matched=handlerQueue[i];event.currentTarget=matched.elem;for(j=0;j<matched.matches.length&&!event.isImmediatePropagationStopped();j++){handleObj=matched.matches[j];if(run_all||(!event.namespace&&!handleObj.namespace)||event.namespace_re&&event.namespace_re.test(handleObj.namespace)){event.data=handleObj.data;event.handleObj=handleObj;ret=((jQuery.event.special[handleObj.origType]||{}).handle||handleObj.handler)
.apply(matched.elem,args);if(ret!==undefined){event.result=ret;if(ret===false){event.preventDefault();event.stopPropagation();}}}}}
if(special.postDispatch){special.postDispatch.call(this,event);}
return event.result;},props:"attrChange attrName relatedNode srcElement altKey bubbles cancelable ctrlKey currentTarget eventPhase metaKey relatedTarget shiftKey target timeStamp view which".split(" "),fixHooks:{},keyHooks:{props:"char charCode key keyCode".split(" "),filter:function(event,original){if(event.which==null){event.which=original.charCode!=null?original.charCode:original.keyCode;}
return event;}},mouseHooks:{props:"button buttons clientX clientY fromElement offsetX offsetY pageX pageY screenX screenY toElement".split(" "),filter:function(event,original){var eventDoc,doc,body,button=original.button,fromElement=original.fromElement;if(event.pageX==null&&original.clientX!=null){eventDoc=event.target.ownerDocument||document;doc=eventDoc.documentElement;body=eventDoc.body;event.pageX=original.clientX+(doc&&doc.scrollLeft||body&&body.scrollLeft||0)-(doc&&doc.clientLeft||body&&body.clientLeft||0);event.pageY=original.clientY+(doc&&doc.scrollTop||body&&body.scrollTop||0)-(doc&&doc.clientTop||body&&body.clientTop||0);}
if(!event.relatedTarget&&fromElement){event.relatedTarget=fromElement===event.target?original.toElement:fromElement;}
if(!event.which&&button!==undefined){event.which=(button&1?1:(button&2?3:(button&4?2:0)));}
return event;}},fix:function(event){if(event[jQuery.expando]){return event;}
var i,prop,originalEvent=event,fixHook=jQuery.event.fixHooks[event.type]||{},copy=fixHook.props?this.props.concat(fixHook.props):this.props;event=jQuery.Event(originalEvent);for(i=copy.length;i;){prop=copy[--i];event[prop]=originalEvent[prop];}
if(!event.target){event.target=originalEvent.srcElement||document;}
if(event.target.nodeType===3){event.target=event.target.parentNode;}
if(event.metaKey===undefined){event.metaKey=event.ctrlKey;}
return fixHook.filter?fixHook.filter(event,originalEvent):event;},special:{ready:{setup:jQuery.bindReady},load:{noBubble:true},focus:{delegateType:"focusin"},blur:{delegateType:"focusout"},beforeunload:{setup:function(data,namespaces,eventHandle){if(jQuery.isWindow(this)){this.onbeforeunload=eventHandle;}},teardown:function(namespaces,eventHandle){if(this.onbeforeunload===eventHandle){this.onbeforeunload=null;}}}},simulate:function(type,elem,event,bubble){var e=jQuery.extend(new jQuery.Event(),event,{type:type,isSimulated:true,originalEvent:{}});if(bubble){jQuery.event.trigger(e,null,elem);}else{jQuery.event.dispatch.call(elem,e);}
if(e.isDefaultPrevented()){event.preventDefault();}}};jQuery.event.handle=jQuery.event.dispatch;jQuery.removeEvent=document.removeEventListener?function(elem,type,handle){if(elem.removeEventListener){elem.removeEventListener(type,handle,false);}}:function(elem,type,handle){if(elem.detachEvent){elem.detachEvent("on"+type,handle);}};jQuery.Event=function(src,props){if(!(this instanceof jQuery.Event)){return new jQuery.Event(src,props);}
if(src&&src.type){this.originalEvent=src;this.type=src.type;this.isDefaultPrevented=(src.defaultPrevented||src.returnValue===false||src.getPreventDefault&&src.getPreventDefault())?returnTrue:returnFalse;}else{this.type=src;}
if(props){jQuery.extend(this,props);}
this.timeStamp=src&&src.timeStamp||jQuery.now();this[jQuery.expando]=true;};function returnFalse(){return false;}
function returnTrue(){return true;}
jQuery.Event.prototype={preventDefault:function(){this.isDefaultPrevented=returnTrue;var e=this.originalEvent;if(!e){return;}
if(e.preventDefault){e.preventDefault();}else{e.returnValue=false;}},stopPropagation:function(){this.isPropagationStopped=returnTrue;var e=this.originalEvent;if(!e){return;}
if(e.stopPropagation){e.stopPropagation();}
e.cancelBubble=true;},stopImmediatePropagation:function(){this.isImmediatePropagationStopped=returnTrue;this.stopPropagation();},isDefaultPrevented:returnFalse,isPropagationStopped:returnFalse,isImmediatePropagationStopped:returnFalse};jQuery.each({mouseenter:"mouseover",mouseleave:"mouseout"},function(orig,fix){jQuery.event.special[orig]={delegateType:fix,bindType:fix,handle:function(event){var target=this,related=event.relatedTarget,handleObj=event.handleObj,selector=handleObj.selector,ret;if(!related||(related!==target&&!jQuery.contains(target,related))){event.type=handleObj.origType;ret=handleObj.handler.apply(this,arguments);event.type=fix;}
return ret;}};});if(!jQuery.support.submitBubbles){jQuery.event.special.submit={setup:function(){if(jQuery.nodeName(this,"form")){return false;}
jQuery.event.add(this,"click._submit keypress._submit",function(e){var elem=e.target,form=jQuery.nodeName(elem,"input")||jQuery.nodeName(elem,"button")?elem.form:undefined;if(form&&!form._submit_attached){jQuery.event.add(form,"submit._submit",function(event){event._submit_bubble=true;});form._submit_attached=true;}});},postDispatch:function(event){if(event._submit_bubble){delete event._submit_bubble;if(this.parentNode&&!event.isTrigger){jQuery.event.simulate("submit",this.parentNode,event,true);}}},teardown:function(){if(jQuery.nodeName(this,"form")){return false;}
jQuery.event.remove(this,"._submit");}};}
if(!jQuery.support.changeBubbles){jQuery.event.special.change={setup:function(){if(rformElems.test(this.nodeName)){if(this.type==="checkbox"||this.type==="radio"){jQuery.event.add(this,"propertychange._change",function(event){if(event.originalEvent.propertyName==="checked"){this._just_changed=true;}});jQuery.event.add(this,"click._change",function(event){if(this._just_changed&&!event.isTrigger){this._just_changed=false;jQuery.event.simulate("change",this,event,true);}});}
return false;}
jQuery.event.add(this,"beforeactivate._change",function(e){var elem=e.target;if(rformElems.test(elem.nodeName)&&!elem._change_attached){jQuery.event.add(elem,"change._change",function(event){if(this.parentNode&&!event.isSimulated&&!event.isTrigger){jQuery.event.simulate("change",this.parentNode,event,true);}});elem._change_attached=true;}});},handle:function(event){var elem=event.target;if(this!==elem||event.isSimulated||event.isTrigger||(elem.type!=="radio"&&elem.type!=="checkbox")){return event.handleObj.handler.apply(this,arguments);}},teardown:function(){jQuery.event.remove(this,"._change");return rformElems.test(this.nodeName);}};}
if(!jQuery.support.focusinBubbles){jQuery.each({focus:"focusin",blur:"focusout"},function(orig,fix){var attaches=0,handler=function(event){jQuery.event.simulate(fix,event.target,jQuery.event.fix(event),true);};jQuery.event.special[fix]={setup:function(){if(attaches++===0){document.addEventListener(orig,handler,true);}},teardown:function(){if(--attaches===0){document.removeEventListener(orig,handler,true);}}};});}
jQuery.fn.extend({on:function(types,selector,data,fn,one){var origFn,type;if(typeof types==="object"){if(typeof selector!=="string"){data=data||selector;selector=undefined;}
for(type in types){this.on(type,selector,data,types[type],one);}
return this;}
if(data==null&&fn==null){fn=selector;data=selector=undefined;}else if(fn==null){if(typeof selector==="string"){fn=data;data=undefined;}else{fn=data;data=selector;selector=undefined;}}
if(fn===false){fn=returnFalse;}else if(!fn){return this;}
if(one===1){origFn=fn;fn=function(event){jQuery().off(event);return origFn.apply(this,arguments);};fn.guid=origFn.guid||(origFn.guid=jQuery.guid++);}
return this.each(function(){jQuery.event.add(this,types,fn,data,selector);});},one:function(types,selector,data,fn){return this.on(types,selector,data,fn,1);},off:function(types,selector,fn){if(types&&types.preventDefault&&types.handleObj){var handleObj=types.handleObj;jQuery(types.delegateTarget).off(handleObj.namespace?handleObj.origType+"."+handleObj.namespace:handleObj.origType,handleObj.selector,handleObj.handler);return this;}
if(typeof types==="object"){for(var type in types){this.off(type,selector,types[type]);}
return this;}
if(selector===false||typeof selector==="function"){fn=selector;selector=undefined;}
if(fn===false){fn=returnFalse;}
return this.each(function(){jQuery.event.remove(this,types,fn,selector);});},bind:function(types,data,fn){return this.on(types,null,data,fn);},unbind:function(types,fn){return this.off(types,null,fn);},live:function(types,data,fn){jQuery(this.context).on(types,this.selector,data,fn);return this;},die:function(types,fn){jQuery(this.context).off(types,this.selector||"**",fn);return this;},delegate:function(selector,types,data,fn){return this.on(types,selector,data,fn);},undelegate:function(selector,types,fn){return arguments.length==1?this.off(selector,"**"):this.off(types,selector,fn);},trigger:function(type,data){return this.each(function(){jQuery.event.trigger(type,data,this);});},triggerHandler:function(type,data){if(this[0]){return jQuery.event.trigger(type,data,this[0],true);}},toggle:function(fn){var args=arguments,guid=fn.guid||jQuery.guid++,i=0,toggler=function(event){var lastToggle=(jQuery._data(this,"lastToggle"+fn.guid)||0)%i;jQuery._data(this,"lastToggle"+fn.guid,lastToggle+1);event.preventDefault();return args[lastToggle].apply(this,arguments)||false;};toggler.guid=guid;while(i<args.length){args[i++].guid=guid;}
return this.click(toggler);},hover:function(fnOver,fnOut){return this.mouseenter(fnOver).mouseleave(fnOut||fnOver);}});jQuery.each(("blur focus focusin focusout load resize scroll unload click dblclick "+
"mousedown mouseup mousemove mouseover mouseout mouseenter mouseleave "+
"change select submit keydown keypress keyup error contextmenu").split(" "),function(i,name){jQuery.fn[name]=function(data,fn){if(fn==null){fn=data;data=null;}
return arguments.length>0?this.on(name,null,data,fn):this.trigger(name);};if(jQuery.attrFn){jQuery.attrFn[name]=true;}
if(rkeyEvent.test(name)){jQuery.event.fixHooks[name]=jQuery.event.keyHooks;}
if(rmouseEvent.test(name)){jQuery.event.fixHooks[name]=jQuery.event.mouseHooks;}});(function(){var chunker=/((?:\((?:\([^()]+\)|[^()]+)+\)|\[(?:\[[^\[\]]*\]|['"][^'"]*['"]|[^\[\]'"]+)+\]|\\.|[^ >+~,(\[\\]+)+|[>+~])(\s*,\s*)?((?:.|\r|\n)*)/g,expando="sizcache"+(Math.random()+'').replace('.',''),done=0,toString=Object.prototype.toString,hasDuplicate=false,baseHasDuplicate=true,rBackslash=/\\/g,rReturn=/\r\n/g,rNonWord=/\W/;[0,0].sort(function(){baseHasDuplicate=false;return 0;});var Sizzle=function(selector,context,results,seed){results=results||[];context=context||document;var origContext=context;if(context.nodeType!==1&&context.nodeType!==9){return[];}
if(!selector||typeof selector!=="string"){return results;}
var m,set,checkSet,extra,ret,cur,pop,i,prune=true,contextXML=Sizzle.isXML(context),parts=[],soFar=selector;do{chunker.exec("");m=chunker.exec(soFar);if(m){soFar=m[3];parts.push(m[1]);if(m[2]){extra=m[3];break;}}}while(m);if(parts.length>1&&origPOS.exec(selector)){if(parts.length===2&&Expr.relative[parts[0]]){set=posProcess(parts[0]+parts[1],context,seed);}else{set=Expr.relative[parts[0]]?[context]:Sizzle(parts.shift(),context);while(parts.length){selector=parts.shift();if(Expr.relative[selector]){selector+=parts.shift();}
set=posProcess(selector,set,seed);}}}else{if(!seed&&parts.length>1&&context.nodeType===9&&!contextXML&&Expr.match.ID.test(parts[0])&&!Expr.match.ID.test(parts[parts.length-1])){ret=Sizzle.find(parts.shift(),context,contextXML);context=ret.expr?Sizzle.filter(ret.expr,ret.set)[0]:ret.set[0];}
if(context){ret=seed?{expr:parts.pop(),set:makeArray(seed)}:Sizzle.find(parts.pop(),parts.length===1&&(parts[0]==="~"||parts[0]==="+")&&context.parentNode?context.parentNode:context,contextXML);set=ret.expr?Sizzle.filter(ret.expr,ret.set):ret.set;if(parts.length>0){checkSet=makeArray(set);}else{prune=false;}
while(parts.length){cur=parts.pop();pop=cur;if(!Expr.relative[cur]){cur="";}else{pop=parts.pop();}
if(pop==null){pop=context;}
Expr.relative[cur](checkSet,pop,contextXML);}}else{checkSet=parts=[];}}
if(!checkSet){checkSet=set;}
if(!checkSet){Sizzle.error(cur||selector);}
if(toString.call(checkSet)==="[object Array]"){if(!prune){results.push.apply(results,checkSet);}else if(context&&context.nodeType===1){for(i=0;checkSet[i]!=null;i++){if(checkSet[i]&&(checkSet[i]===true||checkSet[i].nodeType===1&&Sizzle.contains(context,checkSet[i]))){results.push(set[i]);}}}else{for(i=0;checkSet[i]!=null;i++){if(checkSet[i]&&checkSet[i].nodeType===1){results.push(set[i]);}}}}else{makeArray(checkSet,results);}
if(extra){Sizzle(extra,origContext,results,seed);Sizzle.uniqueSort(results);}
return results;};Sizzle.uniqueSort=function(results){if(sortOrder){hasDuplicate=baseHasDuplicate;results.sort(sortOrder);if(hasDuplicate){for(var i=1;i<results.length;i++){if(results[i]===results[i-1]){results.splice(i--,1);}}}}
return results;};Sizzle.matches=function(expr,set){return Sizzle(expr,null,null,set);};Sizzle.matchesSelector=function(node,expr){return Sizzle(expr,null,null,[node]).length>0;};Sizzle.find=function(expr,context,isXML){var set,i,len,match,type,left;if(!expr){return[];}
for(i=0,len=Expr.order.length;i<len;i++){type=Expr.order[i];if((match=Expr.leftMatch[type].exec(expr))){left=match[1];match.splice(1,1);if(left.substr(left.length-1)!=="\\"){match[1]=(match[1]||"").replace(rBackslash,"");set=Expr.find[type](match,context,isXML);if(set!=null){expr=expr.replace(Expr.match[type],"");break;}}}}
if(!set){set=typeof context.getElementsByTagName!=="undefined"?context.getElementsByTagName("*"):[];}
return{set:set,expr:expr};};Sizzle.filter=function(expr,set,inplace,not){var match,anyFound,type,found,item,filter,left,i,pass,old=expr,result=[],curLoop=set,isXMLFilter=set&&set[0]&&Sizzle.isXML(set[0]);while(expr&&set.length){for(type in Expr.filter){if((match=Expr.leftMatch[type].exec(expr))!=null&&match[2]){filter=Expr.filter[type];left=match[1];anyFound=false;match.splice(1,1);if(left.substr(left.length-1)==="\\"){continue;}
if(curLoop===result){result=[];}
if(Expr.preFilter[type]){match=Expr.preFilter[type](match,curLoop,inplace,result,not,isXMLFilter);if(!match){anyFound=found=true;}else if(match===true){continue;}}
if(match){for(i=0;(item=curLoop[i])!=null;i++){if(item){found=filter(item,match,i,curLoop);pass=not^found;if(inplace&&found!=null){if(pass){anyFound=true;}else{curLoop[i]=false;}}else if(pass){result.push(item);anyFound=true;}}}}
if(found!==undefined){if(!inplace){curLoop=result;}
expr=expr.replace(Expr.match[type],"");if(!anyFound){return[];}
break;}}}
if(expr===old){if(anyFound==null){Sizzle.error(expr);}else{break;}}
old=expr;}
return curLoop;};Sizzle.error=function(msg){throw new Error("Syntax error, unrecognized expression: "+msg);};var getText=Sizzle.getText=function(elem){var i,node,nodeType=elem.nodeType,ret="";if(nodeType){if(nodeType===1||nodeType===9||nodeType===11){if(typeof elem.textContent==='string'){return elem.textContent;}else if(typeof elem.innerText==='string'){return elem.innerText.replace(rReturn,'');}else{for(elem=elem.firstChild;elem;elem=elem.nextSibling){ret+=getText(elem);}}}else if(nodeType===3||nodeType===4){return elem.nodeValue;}}else{for(i=0;(node=elem[i]);i++){if(node.nodeType!==8){ret+=getText(node);}}}
return ret;};var Expr=Sizzle.selectors={order:["ID","NAME","TAG"],match:{ID:/#((?:[\w\u00c0-\uFFFF\-]|\\.)+)/,CLASS:/\.((?:[\w\u00c0-\uFFFF\-]|\\.)+)/,NAME:/\[name=['"]*((?:[\w\u00c0-\uFFFF\-]|\\.)+)['"]*\]/,ATTR:/\[\s*((?:[\w\u00c0-\uFFFF\-]|\\.)+)\s*(?:(\S?=)\s*(?:(['"])(.*?)\3|(#?(?:[\w\u00c0-\uFFFF\-]|\\.)*)|)|)\s*\]/,TAG:/^((?:[\w\u00c0-\uFFFF\*\-]|\\.)+)/,CHILD:/:(only|nth|last|first)-child(?:\(\s*(even|odd|(?:[+\-]?\d+|(?:[+\-]?\d*)?n\s*(?:[+\-]\s*\d+)?))\s*\))?/,POS:/:(nth|eq|gt|lt|first|last|even|odd)(?:\((\d*)\))?(?=[^\-]|$)/,PSEUDO:/:((?:[\w\u00c0-\uFFFF\-]|\\.)+)(?:\((['"]?)((?:\([^\)]+\)|[^\(\)]*)+)\2\))?/},leftMatch:{},attrMap:{"class":"className","for":"htmlFor"},attrHandle:{href:function(elem){return elem.getAttribute("href");},type:function(elem){return elem.getAttribute("type");}},relative:{"+":function(checkSet,part){var isPartStr=typeof part==="string",isTag=isPartStr&&!rNonWord.test(part),isPartStrNotTag=isPartStr&&!isTag;if(isTag){part=part.toLowerCase();}
for(var i=0,l=checkSet.length,elem;i<l;i++){if((elem=checkSet[i])){while((elem=elem.previousSibling)&&elem.nodeType!==1){}
checkSet[i]=isPartStrNotTag||elem&&elem.nodeName.toLowerCase()===part?elem||false:elem===part;}}
if(isPartStrNotTag){Sizzle.filter(part,checkSet,true);}},">":function(checkSet,part){var elem,isPartStr=typeof part==="string",i=0,l=checkSet.length;if(isPartStr&&!rNonWord.test(part)){part=part.toLowerCase();for(;i<l;i++){elem=checkSet[i];if(elem){var parent=elem.parentNode;checkSet[i]=parent.nodeName.toLowerCase()===part?parent:false;}}}else{for(;i<l;i++){elem=checkSet[i];if(elem){checkSet[i]=isPartStr?elem.parentNode:elem.parentNode===part;}}
if(isPartStr){Sizzle.filter(part,checkSet,true);}}},"":function(checkSet,part,isXML){var nodeCheck,doneName=done++,checkFn=dirCheck;if(typeof part==="string"&&!rNonWord.test(part)){part=part.toLowerCase();nodeCheck=part;checkFn=dirNodeCheck;}
checkFn("parentNode",part,doneName,checkSet,nodeCheck,isXML);},"~":function(checkSet,part,isXML){var nodeCheck,doneName=done++,checkFn=dirCheck;if(typeof part==="string"&&!rNonWord.test(part)){part=part.toLowerCase();nodeCheck=part;checkFn=dirNodeCheck;}
checkFn("previousSibling",part,doneName,checkSet,nodeCheck,isXML);}},find:{ID:function(match,context,isXML){if(typeof context.getElementById!=="undefined"&&!isXML){var m=context.getElementById(match[1]);return m&&m.parentNode?[m]:[];}},NAME:function(match,context){if(typeof context.getElementsByName!=="undefined"){var ret=[],results=context.getElementsByName(match[1]);for(var i=0,l=results.length;i<l;i++){if(results[i].getAttribute("name")===match[1]){ret.push(results[i]);}}
return ret.length===0?null:ret;}},TAG:function(match,context){if(typeof context.getElementsByTagName!=="undefined"){return context.getElementsByTagName(match[1]);}}},preFilter:{CLASS:function(match,curLoop,inplace,result,not,isXML){match=" "+match[1].replace(rBackslash,"")+" ";if(isXML){return match;}
for(var i=0,elem;(elem=curLoop[i])!=null;i++){if(elem){if(not^(elem.className&&(" "+elem.className+" ").replace(/[\t\n\r]/g," ").indexOf(match)>=0)){if(!inplace){result.push(elem);}}else if(inplace){curLoop[i]=false;}}}
return false;},ID:function(match){return match[1].replace(rBackslash,"");},TAG:function(match,curLoop){return match[1].replace(rBackslash,"").toLowerCase();},CHILD:function(match){if(match[1]==="nth"){if(!match[2]){Sizzle.error(match[0]);}
match[2]=match[2].replace(/^\+|\s*/g,'');var test=/(-?)(\d*)(?:n([+\-]?\d*))?/.exec(match[2]==="even"&&"2n"||match[2]==="odd"&&"2n+1"||!/\D/.test(match[2])&&"0n+"+match[2]||match[2]);match[2]=(test[1]+(test[2]||1))-0;match[3]=test[3]-0;}
else if(match[2]){Sizzle.error(match[0]);}
match[0]=done++;return match;},ATTR:function(match,curLoop,inplace,result,not,isXML){var name=match[1]=match[1].replace(rBackslash,"");if(!isXML&&Expr.attrMap[name]){match[1]=Expr.attrMap[name];}
match[4]=(match[4]||match[5]||"").replace(rBackslash,"");if(match[2]==="~="){match[4]=" "+match[4]+" ";}
return match;},PSEUDO:function(match,curLoop,inplace,result,not){if(match[1]==="not"){if((chunker.exec(match[3])||"").length>1||/^\w/.test(match[3])){match[3]=Sizzle(match[3],null,null,curLoop);}else{var ret=Sizzle.filter(match[3],curLoop,inplace,true^not);if(!inplace){result.push.apply(result,ret);}
return false;}}else if(Expr.match.POS.test(match[0])||Expr.match.CHILD.test(match[0])){return true;}
return match;},POS:function(match){match.unshift(true);return match;}},filters:{enabled:function(elem){return elem.disabled===false&&elem.type!=="hidden";},disabled:function(elem){return elem.disabled===true;},checked:function(elem){return elem.checked===true;},selected:function(elem){if(elem.parentNode){elem.parentNode.selectedIndex;}
return elem.selected===true;},parent:function(elem){return!!elem.firstChild;},empty:function(elem){return!elem.firstChild;},has:function(elem,i,match){return!!Sizzle(match[3],elem).length;},header:function(elem){return(/h\d/i).test(elem.nodeName);},text:function(elem){var attr=elem.getAttribute("type"),type=elem.type;return elem.nodeName.toLowerCase()==="input"&&"text"===type&&(attr===type||attr===null);},radio:function(elem){return elem.nodeName.toLowerCase()==="input"&&"radio"===elem.type;},checkbox:function(elem){return elem.nodeName.toLowerCase()==="input"&&"checkbox"===elem.type;},file:function(elem){return elem.nodeName.toLowerCase()==="input"&&"file"===elem.type;},password:function(elem){return elem.nodeName.toLowerCase()==="input"&&"password"===elem.type;},submit:function(elem){var name=elem.nodeName.toLowerCase();return(name==="input"||name==="button")&&"submit"===elem.type;},image:function(elem){return elem.nodeName.toLowerCase()==="input"&&"image"===elem.type;},reset:function(elem){var name=elem.nodeName.toLowerCase();return(name==="input"||name==="button")&&"reset"===elem.type;},button:function(elem){var name=elem.nodeName.toLowerCase();return name==="input"&&"button"===elem.type||name==="button";},input:function(elem){return(/input|select|textarea|button/i).test(elem.nodeName);},focus:function(elem){return elem===elem.ownerDocument.activeElement;}},setFilters:{first:function(elem,i){return i===0;},last:function(elem,i,match,array){return i===array.length-1;},even:function(elem,i){return i%2===0;},odd:function(elem,i){return i%2===1;},lt:function(elem,i,match){return i<match[3]-0;},gt:function(elem,i,match){return i>match[3]-0;},nth:function(elem,i,match){return match[3]-0===i;},eq:function(elem,i,match){return match[3]-0===i;}},filter:{PSEUDO:function(elem,match,i,array){var name=match[1],filter=Expr.filters[name];if(filter){return filter(elem,i,match,array);}else if(name==="contains"){return(elem.textContent||elem.innerText||getText([elem])||"").indexOf(match[3])>=0;}else if(name==="not"){var not=match[3];for(var j=0,l=not.length;j<l;j++){if(not[j]===elem){return false;}}
return true;}else{Sizzle.error(name);}},CHILD:function(elem,match){var first,last,doneName,parent,cache,count,diff,type=match[1],node=elem;switch(type){case"only":case"first":while((node=node.previousSibling)){if(node.nodeType===1){return false;}}
if(type==="first"){return true;}
node=elem;case"last":while((node=node.nextSibling)){if(node.nodeType===1){return false;}}
return true;case"nth":first=match[2];last=match[3];if(first===1&&last===0){return true;}
doneName=match[0];parent=elem.parentNode;if(parent&&(parent[expando]!==doneName||!elem.nodeIndex)){count=0;for(node=parent.firstChild;node;node=node.nextSibling){if(node.nodeType===1){node.nodeIndex=++count;}}
parent[expando]=doneName;}
diff=elem.nodeIndex-last;if(first===0){return diff===0;}else{return(diff%first===0&&diff/first>=0);}}},ID:function(elem,match){return elem.nodeType===1&&elem.getAttribute("id")===match;},TAG:function(elem,match){return(match==="*"&&elem.nodeType===1)||!!elem.nodeName&&elem.nodeName.toLowerCase()===match;},CLASS:function(elem,match){return(" "+(elem.className||elem.getAttribute("class"))+" ")
.indexOf(match)>-1;},ATTR:function(elem,match){var name=match[1],result=Sizzle.attr?Sizzle.attr(elem,name):Expr.attrHandle[name]?Expr.attrHandle[name](elem):elem[name]!=null?elem[name]:elem.getAttribute(name),value=result+"",type=match[2],check=match[4];return result==null?type==="!=":!type&&Sizzle.attr?result!=null:type==="="?value===check:type==="*="?value.indexOf(check)>=0:type==="~="?(" "+value+" ").indexOf(check)>=0:!check?value&&result!==false:type==="!="?value!==check:type==="^="?value.indexOf(check)===0:type==="$="?value.substr(value.length-check.length)===check:type==="|="?value===check||value.substr(0,check.length+1)===check+"-":false;},POS:function(elem,match,i,array){var name=match[2],filter=Expr.setFilters[name];if(filter){return filter(elem,i,match,array);}}}};var origPOS=Expr.match.POS,fescape=function(all,num){return"\\"+(num-0+1);};for(var type in Expr.match){Expr.match[type]=new RegExp(Expr.match[type].source+(/(?![^\[]*\])(?![^\(]*\))/.source));Expr.leftMatch[type]=new RegExp(/(^(?:.|\r|\n)*?)/.source+Expr.match[type].source.replace(/\\(\d+)/g,fescape));}
Expr.match.globalPOS=origPOS;var makeArray=function(array,results){array=Array.prototype.slice.call(array,0);if(results){results.push.apply(results,array);return results;}
return array;};try{Array.prototype.slice.call(document.documentElement.childNodes,0)[0].nodeType;}catch(e){makeArray=function(array,results){var i=0,ret=results||[];if(toString.call(array)==="[object Array]"){Array.prototype.push.apply(ret,array);}else{if(typeof array.length==="number"){for(var l=array.length;i<l;i++){ret.push(array[i]);}}else{for(;array[i];i++){ret.push(array[i]);}}}
return ret;};}
var sortOrder,siblingCheck;if(document.documentElement.compareDocumentPosition){sortOrder=function(a,b){if(a===b){hasDuplicate=true;return 0;}
if(!a.compareDocumentPosition||!b.compareDocumentPosition){return a.compareDocumentPosition?-1:1;}
return a.compareDocumentPosition(b)&4?-1:1;};}else{sortOrder=function(a,b){if(a===b){hasDuplicate=true;return 0;}else if(a.sourceIndex&&b.sourceIndex){return a.sourceIndex-b.sourceIndex;}
var al,bl,ap=[],bp=[],aup=a.parentNode,bup=b.parentNode,cur=aup;if(aup===bup){return siblingCheck(a,b);}else if(!aup){return-1;}else if(!bup){return 1;}
while(cur){ap.unshift(cur);cur=cur.parentNode;}
cur=bup;while(cur){bp.unshift(cur);cur=cur.parentNode;}
al=ap.length;bl=bp.length;for(var i=0;i<al&&i<bl;i++){if(ap[i]!==bp[i]){return siblingCheck(ap[i],bp[i]);}}
return i===al?siblingCheck(a,bp[i],-1):siblingCheck(ap[i],b,1);};siblingCheck=function(a,b,ret){if(a===b){return ret;}
var cur=a.nextSibling;while(cur){if(cur===b){return-1;}
cur=cur.nextSibling;}
return 1;};}
(function(){var form=document.createElement("div"),id="script"+(new Date()).getTime(),root=document.documentElement;form.innerHTML="<a name='"+id+"'/>";root.insertBefore(form,root.firstChild);if(document.getElementById(id)){Expr.find.ID=function(match,context,isXML){if(typeof context.getElementById!=="undefined"&&!isXML){var m=context.getElementById(match[1]);return m?m.id===match[1]||typeof m.getAttributeNode!=="undefined"&&m.getAttributeNode("id").nodeValue===match[1]?[m]:undefined:[];}};Expr.filter.ID=function(elem,match){var node=typeof elem.getAttributeNode!=="undefined"&&elem.getAttributeNode("id");return elem.nodeType===1&&node&&node.nodeValue===match;};}
root.removeChild(form);root=form=null;})();(function(){var div=document.createElement("div");div.appendChild(document.createComment(""));if(div.getElementsByTagName("*").length>0){Expr.find.TAG=function(match,context){var results=context.getElementsByTagName(match[1]);if(match[1]==="*"){var tmp=[];for(var i=0;results[i];i++){if(results[i].nodeType===1){tmp.push(results[i]);}}
results=tmp;}
return results;};}
div.innerHTML="<a href='#'></a>";if(div.firstChild&&typeof div.firstChild.getAttribute!=="undefined"&&div.firstChild.getAttribute("href")!=="#"){Expr.attrHandle.href=function(elem){return elem.getAttribute("href",2);};}
div=null;})();if(document.querySelectorAll){(function(){var oldSizzle=Sizzle,div=document.createElement("div"),id="__sizzle__";div.innerHTML="<p class='TEST'></p>";if(div.querySelectorAll&&div.querySelectorAll(".TEST").length===0){return;}
Sizzle=function(query,context,extra,seed){context=context||document;if(!seed&&!Sizzle.isXML(context)){var match=/^(\w+$)|^\.([\w\-]+$)|^#([\w\-]+$)/.exec(query);if(match&&(context.nodeType===1||context.nodeType===9)){if(match[1]){return makeArray(context.getElementsByTagName(query),extra);}else if(match[2]&&Expr.find.CLASS&&context.getElementsByClassName){return makeArray(context.getElementsByClassName(match[2]),extra);}}
if(context.nodeType===9){if(query==="body"&&context.body){return makeArray([context.body],extra);}else if(match&&match[3]){var elem=context.getElementById(match[3]);if(elem&&elem.parentNode){if(elem.id===match[3]){return makeArray([elem],extra);}}else{return makeArray([],extra);}}
try{return makeArray(context.querySelectorAll(query),extra);}catch(qsaError){}
}else if(context.nodeType===1&&context.nodeName.toLowerCase()!=="object"){var oldContext=context,old=context.getAttribute("id"),nid=old||id,hasParent=context.parentNode,relativeHierarchySelector=/^\s*[+~]/.test(query);if(!old){context.setAttribute("id",nid);}else{nid=nid.replace(/'/g,"\\$&");}
if(relativeHierarchySelector&&hasParent){context=context.parentNode;}
try{if(!relativeHierarchySelector||hasParent){return makeArray(context.querySelectorAll("[id='"+nid+"'] "+query),extra);}}catch(pseudoError){}finally{if(!old){oldContext.removeAttribute("id");}}}}
return oldSizzle(query,context,extra,seed);};for(var prop in oldSizzle){Sizzle[prop]=oldSizzle[prop];}
div=null;})();}
(function(){var html=document.documentElement,matches=html.matchesSelector||html.mozMatchesSelector||html.webkitMatchesSelector||html.msMatchesSelector;if(matches){var disconnectedMatch=!matches.call(document.createElement("div"),"div"),pseudoWorks=false;try{matches.call(document.documentElement,"[test!='']:sizzle");}catch(pseudoError){pseudoWorks=true;}
Sizzle.matchesSelector=function(node,expr){expr=expr.replace(/\=\s*([^'"\]]*)\s*\]/g,"='$1']");if(!Sizzle.isXML(node)){try{if(pseudoWorks||!Expr.match.PSEUDO.test(expr)&&!/!=/.test(expr)){var ret=matches.call(node,expr);if(ret||!disconnectedMatch||node.document&&node.document.nodeType!==11){return ret;}}}catch(e){}}
return Sizzle(expr,null,null,[node]).length>0;};}})();(function(){var div=document.createElement("div");div.innerHTML="<div class='test e'></div><div class='test'></div>";if(!div.getElementsByClassName||div.getElementsByClassName("e").length===0){return;}
div.lastChild.className="e";if(div.getElementsByClassName("e").length===1){return;}
Expr.order.splice(1,0,"CLASS");Expr.find.CLASS=function(match,context,isXML){if(typeof context.getElementsByClassName!=="undefined"&&!isXML){return context.getElementsByClassName(match[1]);}};div=null;})();function dirNodeCheck(dir,cur,doneName,checkSet,nodeCheck,isXML){for(var i=0,l=checkSet.length;i<l;i++){var elem=checkSet[i];if(elem){var match=false;elem=elem[dir];while(elem){if(elem[expando]===doneName){match=checkSet[elem.sizset];break;}
if(elem.nodeType===1&&!isXML){elem[expando]=doneName;elem.sizset=i;}
if(elem.nodeName.toLowerCase()===cur){match=elem;break;}
elem=elem[dir];}
checkSet[i]=match;}}}
function dirCheck(dir,cur,doneName,checkSet,nodeCheck,isXML){for(var i=0,l=checkSet.length;i<l;i++){var elem=checkSet[i];if(elem){var match=false;elem=elem[dir];while(elem){if(elem[expando]===doneName){match=checkSet[elem.sizset];break;}
if(elem.nodeType===1){if(!isXML){elem[expando]=doneName;elem.sizset=i;}
if(typeof cur!=="string"){if(elem===cur){match=true;break;}}else if(Sizzle.filter(cur,[elem]).length>0){match=elem;break;}}
elem=elem[dir];}
checkSet[i]=match;}}}
if(document.documentElement.contains){Sizzle.contains=function(a,b){return a!==b&&(a.contains?a.contains(b):true);};}else if(document.documentElement.compareDocumentPosition){Sizzle.contains=function(a,b){return!!(a.compareDocumentPosition(b)&16);};}else{Sizzle.contains=function(){return false;};}
Sizzle.isXML=function(elem){var documentElement=(elem?elem.ownerDocument||elem:0).documentElement;return documentElement?documentElement.nodeName!=="HTML":false;};var posProcess=function(selector,context,seed){var match,tmpSet=[],later="",root=context.nodeType?[context]:context;while((match=Expr.match.PSEUDO.exec(selector))){later+=match[0];selector=selector.replace(Expr.match.PSEUDO,"");}
selector=Expr.relative[selector]?selector+"*":selector;for(var i=0,l=root.length;i<l;i++){Sizzle(selector,root[i],tmpSet,seed);}
return Sizzle.filter(later,tmpSet);};Sizzle.attr=jQuery.attr;Sizzle.selectors.attrMap={};jQuery.find=Sizzle;jQuery.expr=Sizzle.selectors;jQuery.expr[":"]=jQuery.expr.filters;jQuery.unique=Sizzle.uniqueSort;jQuery.text=Sizzle.getText;jQuery.isXMLDoc=Sizzle.isXML;jQuery.contains=Sizzle.contains;})();var runtil=/Until$/,rparentsprev=/^(?:parents|prevUntil|prevAll)/,rmultiselector=/,/,isSimple=/^.[^:#\[\.,]*$/,slice=Array.prototype.slice,POS=jQuery.expr.match.globalPOS,guaranteedUnique={children:true,contents:true,next:true,prev:true};jQuery.fn.extend({find:function(selector){var self=this,i,l;if(typeof selector!=="string"){return jQuery(selector).filter(function(){for(i=0,l=self.length;i<l;i++){if(jQuery.contains(self[i],this)){return true;}}});}
var ret=this.pushStack("","find",selector),length,n,r;for(i=0,l=this.length;i<l;i++){length=ret.length;jQuery.find(selector,this[i],ret);if(i>0){for(n=length;n<ret.length;n++){for(r=0;r<length;r++){if(ret[r]===ret[n]){ret.splice(n--,1);break;}}}}}
return ret;},has:function(target){var targets=jQuery(target);return this.filter(function(){for(var i=0,l=targets.length;i<l;i++){if(jQuery.contains(this,targets[i])){return true;}}});},not:function(selector){return this.pushStack(winnow(this,selector,false),"not",selector);},filter:function(selector){return this.pushStack(winnow(this,selector,true),"filter",selector);},is:function(selector){return!!selector&&(typeof selector==="string"?POS.test(selector)?jQuery(selector,this.context).index(this[0])>=0:jQuery.filter(selector,this).length>0:this.filter(selector).length>0);},closest:function(selectors,context){var ret=[],i,l,cur=this[0];if(jQuery.isArray(selectors)){var level=1;while(cur&&cur.ownerDocument&&cur!==context){for(i=0;i<selectors.length;i++){if(jQuery(cur).is(selectors[i])){ret.push({selector:selectors[i],elem:cur,level:level});}}
cur=cur.parentNode;level++;}
return ret;}
var pos=POS.test(selectors)||typeof selectors!=="string"?jQuery(selectors,context||this.context):0;for(i=0,l=this.length;i<l;i++){cur=this[i];while(cur){if(pos?pos.index(cur)>-1:jQuery.find.matchesSelector(cur,selectors)){ret.push(cur);break;}else{cur=cur.parentNode;if(!cur||!cur.ownerDocument||cur===context||cur.nodeType===11){break;}}}}
ret=ret.length>1?jQuery.unique(ret):ret;return this.pushStack(ret,"closest",selectors);},index:function(elem){if(!elem){return(this[0]&&this[0].parentNode)?this.prevAll().length:-1;}
if(typeof elem==="string"){return jQuery.inArray(this[0],jQuery(elem));}
return jQuery.inArray(elem.jquery?elem[0]:elem,this);},add:function(selector,context){var set=typeof selector==="string"?jQuery(selector,context):jQuery.makeArray(selector&&selector.nodeType?[selector]:selector),all=jQuery.merge(this.get(),set);return this.pushStack(isDisconnected(set[0])||isDisconnected(all[0])?all:jQuery.unique(all));},andSelf:function(){return this.add(this.prevObject);}});function isDisconnected(node){return!node||!node.parentNode||node.parentNode.nodeType===11;}
jQuery.each({parent:function(elem){var parent=elem.parentNode;return parent&&parent.nodeType!==11?parent:null;},parents:function(elem){return jQuery.dir(elem,"parentNode");},parentsUntil:function(elem,i,until){return jQuery.dir(elem,"parentNode",until);},next:function(elem){return jQuery.nth(elem,2,"nextSibling");},prev:function(elem){return jQuery.nth(elem,2,"previousSibling");},nextAll:function(elem){return jQuery.dir(elem,"nextSibling");},prevAll:function(elem){return jQuery.dir(elem,"previousSibling");},nextUntil:function(elem,i,until){return jQuery.dir(elem,"nextSibling",until);},prevUntil:function(elem,i,until){return jQuery.dir(elem,"previousSibling",until);},siblings:function(elem){return jQuery.sibling((elem.parentNode||{}).firstChild,elem);},children:function(elem){return jQuery.sibling(elem.firstChild);},contents:function(elem){return jQuery.nodeName(elem,"iframe")?elem.contentDocument||elem.contentWindow.document:jQuery.makeArray(elem.childNodes);}},function(name,fn){jQuery.fn[name]=function(until,selector){var ret=jQuery.map(this,fn,until);if(!runtil.test(name)){selector=until;}
if(selector&&typeof selector==="string"){ret=jQuery.filter(selector,ret);}
ret=this.length>1&&!guaranteedUnique[name]?jQuery.unique(ret):ret;if((this.length>1||rmultiselector.test(selector))&&rparentsprev.test(name)){ret=ret.reverse();}
return this.pushStack(ret,name,slice.call(arguments).join(","));};});jQuery.extend({filter:function(expr,elems,not){if(not){expr=":not("+expr+")";}
return elems.length===1?jQuery.find.matchesSelector(elems[0],expr)?[elems[0]]:[]:jQuery.find.matches(expr,elems);},dir:function(elem,dir,until){var matched=[],cur=elem[dir];while(cur&&cur.nodeType!==9&&(until===undefined||cur.nodeType!==1||!jQuery(cur).is(until))){if(cur.nodeType===1){matched.push(cur);}
cur=cur[dir];}
return matched;},nth:function(cur,result,dir,elem){result=result||1;var num=0;for(;cur;cur=cur[dir]){if(cur.nodeType===1&&++num===result){break;}}
return cur;},sibling:function(n,elem){var r=[];for(;n;n=n.nextSibling){if(n.nodeType===1&&n!==elem){r.push(n);}}
return r;}});function winnow(elements,qualifier,keep){qualifier=qualifier||0;if(jQuery.isFunction(qualifier)){return jQuery.grep(elements,function(elem,i){var retVal=!!qualifier.call(elem,i,elem);return retVal===keep;});}else if(qualifier.nodeType){return jQuery.grep(elements,function(elem,i){return(elem===qualifier)===keep;});}else if(typeof qualifier==="string"){var filtered=jQuery.grep(elements,function(elem){return elem.nodeType===1;});if(isSimple.test(qualifier)){return jQuery.filter(qualifier,filtered,!keep);}else{qualifier=jQuery.filter(qualifier,filtered);}}
return jQuery.grep(elements,function(elem,i){return(jQuery.inArray(elem,qualifier)>=0)===keep;});}
function createSafeFragment(document){var list=nodeNames.split("|"),safeFrag=document.createDocumentFragment();if(safeFrag.createElement){while(list.length){safeFrag.createElement(list.pop());}}
return safeFrag;}
var nodeNames="abbr|article|aside|audio|bdi|canvas|data|datalist|details|figcaption|figure|footer|"+
"header|hgroup|mark|meter|nav|output|progress|section|summary|time|video",rinlinejQuery=/ jQuery\d+="(?:\d+|null)"/g,rleadingWhitespace=/^\s+/,rxhtmlTag=/<(?!area|br|col|embed|hr|img|input|link|meta|param)(([\w:]+)[^>]*)\/>/ig,rtagName=/<([\w:]+)/,rtbody=/<tbody/i,rhtml=/<|&#?\w+;/,rnoInnerhtml=/<(?:script|style)/i,rnocache=/<(?:script|object|embed|option|style)/i,rnoshimcache=new RegExp("<(?:"+nodeNames+")[\\s/>]","i"),rchecked=/checked\s*(?:[^=]|=\s*.checked.)/i,rscriptType=/\/(java|ecma)script/i,rcleanScript=/^\s*<!(?:\[CDATA\[|\-\-)/,wrapMap={option:[1,"<select multiple='multiple'>","</select>"],legend:[1,"<fieldset>","</fieldset>"],thead:[1,"<table>","</table>"],tr:[2,"<table><tbody>","</tbody></table>"],td:[3,"<table><tbody><tr>","</tr></tbody></table>"],col:[2,"<table><tbody></tbody><colgroup>","</colgroup></table>"],area:[1,"<map>","</map>"],_default:[0,"",""]},safeFragment=createSafeFragment(document);wrapMap.optgroup=wrapMap.option;wrapMap.tbody=wrapMap.tfoot=wrapMap.colgroup=wrapMap.caption=wrapMap.thead;wrapMap.th=wrapMap.td;if(!jQuery.support.htmlSerialize){wrapMap._default=[1,"div<div>","</div>"];}
jQuery.fn.extend({text:function(value){return jQuery.access(this,function(value){return value===undefined?jQuery.text(this):this.empty().append((this[0]&&this[0].ownerDocument||document).createTextNode(value));},null,value,arguments.length);},wrapAll:function(html){if(jQuery.isFunction(html)){return this.each(function(i){jQuery(this).wrapAll(html.call(this,i));});}
if(this[0]){var wrap=jQuery(html,this[0].ownerDocument).eq(0).clone(true);if(this[0].parentNode){wrap.insertBefore(this[0]);}
wrap.map(function(){var elem=this;while(elem.firstChild&&elem.firstChild.nodeType===1){elem=elem.firstChild;}
return elem;}).append(this);}
return this;},wrapInner:function(html){if(jQuery.isFunction(html)){return this.each(function(i){jQuery(this).wrapInner(html.call(this,i));});}
return this.each(function(){var self=jQuery(this),contents=self.contents();if(contents.length){contents.wrapAll(html);}else{self.append(html);}});},wrap:function(html){var isFunction=jQuery.isFunction(html);return this.each(function(i){jQuery(this).wrapAll(isFunction?html.call(this,i):html);});},unwrap:function(){return this.parent().each(function(){if(!jQuery.nodeName(this,"body")){jQuery(this).replaceWith(this.childNodes);}}).end();},append:function(){return this.domManip(arguments,true,function(elem){if(this.nodeType===1){this.appendChild(elem);}});},prepend:function(){return this.domManip(arguments,true,function(elem){if(this.nodeType===1){this.insertBefore(elem,this.firstChild);}});},before:function(){if(this[0]&&this[0].parentNode){return this.domManip(arguments,false,function(elem){this.parentNode.insertBefore(elem,this);});}else if(arguments.length){var set=jQuery.clean(arguments);set.push.apply(set,this.toArray());return this.pushStack(set,"before",arguments);}},after:function(){if(this[0]&&this[0].parentNode){return this.domManip(arguments,false,function(elem){this.parentNode.insertBefore(elem,this.nextSibling);});}else if(arguments.length){var set=this.pushStack(this,"after",arguments);set.push.apply(set,jQuery.clean(arguments));return set;}},remove:function(selector,keepData){for(var i=0,elem;(elem=this[i])!=null;i++){if(!selector||jQuery.filter(selector,[elem]).length){if(!keepData&&elem.nodeType===1){jQuery.cleanData(elem.getElementsByTagName("*"));jQuery.cleanData([elem]);}
if(elem.parentNode){elem.parentNode.removeChild(elem);}}}
return this;},empty:function(){for(var i=0,elem;(elem=this[i])!=null;i++){if(elem.nodeType===1){jQuery.cleanData(elem.getElementsByTagName("*"));}
while(elem.firstChild){elem.removeChild(elem.firstChild);}}
return this;},clone:function(dataAndEvents,deepDataAndEvents){dataAndEvents=dataAndEvents==null?false:dataAndEvents;deepDataAndEvents=deepDataAndEvents==null?dataAndEvents:deepDataAndEvents;return this.map(function(){return jQuery.clone(this,dataAndEvents,deepDataAndEvents);});},html:function(value){return jQuery.access(this,function(value){var elem=this[0]||{},i=0,l=this.length;if(value===undefined){return elem.nodeType===1?elem.innerHTML.replace(rinlinejQuery,""):null;}
if(typeof value==="string"&&!rnoInnerhtml.test(value)&&(jQuery.support.leadingWhitespace||!rleadingWhitespace.test(value))&&!wrapMap[(rtagName.exec(value)||["",""])[1].toLowerCase()]){value=value.replace(rxhtmlTag,"<$1></$2>");try{for(;i<l;i++){elem=this[i]||{};if(elem.nodeType===1){jQuery.cleanData(elem.getElementsByTagName("*"));elem.innerHTML=value;}}
elem=0;}catch(e){}}
if(elem){this.empty().append(value);}},null,value,arguments.length);},replaceWith:function(value){if(this[0]&&this[0].parentNode){if(jQuery.isFunction(value)){return this.each(function(i){var self=jQuery(this),old=self.html();self.replaceWith(value.call(this,i,old));});}
if(typeof value!=="string"){value=jQuery(value).detach();}
return this.each(function(){var next=this.nextSibling,parent=this.parentNode;jQuery(this).remove();if(next){jQuery(next).before(value);}else{jQuery(parent).append(value);}});}else{return this.length?this.pushStack(jQuery(jQuery.isFunction(value)?value():value),"replaceWith",value):this;}},detach:function(selector){return this.remove(selector,true);},domManip:function(args,table,callback){var results,first,fragment,parent,value=args[0],scripts=[];if(!jQuery.support.checkClone&&arguments.length===3&&typeof value==="string"&&rchecked.test(value)){return this.each(function(){jQuery(this).domManip(args,table,callback,true);});}
if(jQuery.isFunction(value)){return this.each(function(i){var self=jQuery(this);args[0]=value.call(this,i,table?self.html():undefined);self.domManip(args,table,callback);});}
if(this[0]){parent=value&&value.parentNode;if(jQuery.support.parentNode&&parent&&parent.nodeType===11&&parent.childNodes.length===this.length){results={fragment:parent};}else{results=jQuery.buildFragment(args,this,scripts);}
fragment=results.fragment;if(fragment.childNodes.length===1){first=fragment=fragment.firstChild;}else{first=fragment.firstChild;}
if(first){table=table&&jQuery.nodeName(first,"tr");for(var i=0,l=this.length,lastIndex=l-1;i<l;i++){callback.call(table?root(this[i],first):this[i],results.cacheable||(l>1&&i<lastIndex)?jQuery.clone(fragment,true,true):fragment);}}
if(scripts.length){jQuery.each(scripts,function(i,elem){if(elem.src){jQuery.ajax({type:"GET",global:false,url:elem.src,async:false,dataType:"script"});}else{jQuery.globalEval((elem.text||elem.textContent||elem.innerHTML||"").replace(rcleanScript,"/*$0*/"));}
if(elem.parentNode){elem.parentNode.removeChild(elem);}});}}
return this;}});function root(elem,cur){return jQuery.nodeName(elem,"table")?(elem.getElementsByTagName("tbody")[0]||elem.appendChild(elem.ownerDocument.createElement("tbody"))):elem;}
function cloneCopyEvent(src,dest){if(dest.nodeType!==1||!jQuery.hasData(src)){return;}
var type,i,l,oldData=jQuery._data(src),curData=jQuery._data(dest,oldData),events=oldData.events;if(events){delete curData.handle;curData.events={};for(type in events){for(i=0,l=events[type].length;i<l;i++){jQuery.event.add(dest,type,events[type][i]);}}}
if(curData.data){curData.data=jQuery.extend({},curData.data);}}
function cloneFixAttributes(src,dest){var nodeName;if(dest.nodeType!==1){return;}
if(dest.clearAttributes){dest.clearAttributes();}
if(dest.mergeAttributes){dest.mergeAttributes(src);}
nodeName=dest.nodeName.toLowerCase();if(nodeName==="object"){dest.outerHTML=src.outerHTML;}else if(nodeName==="input"&&(src.type==="checkbox"||src.type==="radio")){if(src.checked){dest.defaultChecked=dest.checked=src.checked;}
if(dest.value!==src.value){dest.value=src.value;}
}else if(nodeName==="option"){dest.selected=src.defaultSelected;}else if(nodeName==="input"||nodeName==="textarea"){dest.defaultValue=src.defaultValue;}else if(nodeName==="script"&&dest.text!==src.text){dest.text=src.text;}
dest.removeAttribute(jQuery.expando);dest.removeAttribute("_submit_attached");dest.removeAttribute("_change_attached");}
jQuery.buildFragment=function(args,nodes,scripts){var fragment,cacheable,cacheresults,doc,first=args[0];if(nodes&&nodes[0]){doc=nodes[0].ownerDocument||nodes[0];}
if(!doc.createDocumentFragment){doc=document;}
if(args.length===1&&typeof first==="string"&&first.length<512&&doc===document&&first.charAt(0)==="<"&&!rnocache.test(first)&&(jQuery.support.checkClone||!rchecked.test(first))&&(jQuery.support.html5Clone||!rnoshimcache.test(first))){cacheable=true;cacheresults=jQuery.fragments[first];if(cacheresults&&cacheresults!==1){fragment=cacheresults;}}
if(!fragment){fragment=doc.createDocumentFragment();jQuery.clean(args,doc,fragment,scripts);}
if(cacheable){jQuery.fragments[first]=cacheresults?fragment:1;}
return{fragment:fragment,cacheable:cacheable};};jQuery.fragments={};jQuery.each({appendTo:"append",prependTo:"prepend",insertBefore:"before",insertAfter:"after",replaceAll:"replaceWith"},function(name,original){jQuery.fn[name]=function(selector){var ret=[],insert=jQuery(selector),parent=this.length===1&&this[0].parentNode;if(parent&&parent.nodeType===11&&parent.childNodes.length===1&&insert.length===1){insert[original](this[0]);return this;}else{for(var i=0,l=insert.length;i<l;i++){var elems=(i>0?this.clone(true):this).get();jQuery(insert[i])[original](elems);ret=ret.concat(elems);}
return this.pushStack(ret,name,insert.selector);}};});function getAll(elem){if(typeof elem.getElementsByTagName!=="undefined"){return elem.getElementsByTagName("*");}else if(typeof elem.querySelectorAll!=="undefined"){return elem.querySelectorAll("*");}else{return[];}}
function fixDefaultChecked(elem){if(elem.type==="checkbox"||elem.type==="radio"){elem.defaultChecked=elem.checked;}}
function findInputs(elem){var nodeName=(elem.nodeName||"").toLowerCase();if(nodeName==="input"){fixDefaultChecked(elem);}else if(nodeName!=="script"&&typeof elem.getElementsByTagName!=="undefined"){jQuery.grep(elem.getElementsByTagName("input"),fixDefaultChecked);}}
function shimCloneNode(elem){var div=document.createElement("div");safeFragment.appendChild(div);div.innerHTML=elem.outerHTML;return div.firstChild;}
jQuery.extend({clone:function(elem,dataAndEvents,deepDataAndEvents){var srcElements,destElements,i,clone=jQuery.support.html5Clone||jQuery.isXMLDoc(elem)||!rnoshimcache.test("<"+elem.nodeName+">")?elem.cloneNode(true):shimCloneNode(elem);if((!jQuery.support.noCloneEvent||!jQuery.support.noCloneChecked)&&(elem.nodeType===1||elem.nodeType===11)&&!jQuery.isXMLDoc(elem)){cloneFixAttributes(elem,clone);srcElements=getAll(elem);destElements=getAll(clone);for(i=0;srcElements[i];++i){if(destElements[i]){cloneFixAttributes(srcElements[i],destElements[i]);}}}
if(dataAndEvents){cloneCopyEvent(elem,clone);if(deepDataAndEvents){srcElements=getAll(elem);destElements=getAll(clone);for(i=0;srcElements[i];++i){cloneCopyEvent(srcElements[i],destElements[i]);}}}
srcElements=destElements=null;return clone;},clean:function(elems,context,fragment,scripts){var checkScriptType,script,j,ret=[];context=context||document;if(typeof context.createElement==="undefined"){context=context.ownerDocument||context[0]&&context[0].ownerDocument||document;}
for(var i=0,elem;(elem=elems[i])!=null;i++){if(typeof elem==="number"){elem+="";}
if(!elem){continue;}
if(typeof elem==="string"){if(!rhtml.test(elem)){elem=context.createTextNode(elem);}else{elem=elem.replace(rxhtmlTag,"<$1></$2>");var tag=(rtagName.exec(elem)||["",""])[1].toLowerCase(),wrap=wrapMap[tag]||wrapMap._default,depth=wrap[0],div=context.createElement("div"),safeChildNodes=safeFragment.childNodes,remove;if(context===document){safeFragment.appendChild(div);}else{createSafeFragment(context).appendChild(div);}
div.innerHTML=wrap[1]+elem+wrap[2];while(depth--){div=div.lastChild;}
if(!jQuery.support.tbody){var hasBody=rtbody.test(elem),tbody=tag==="table"&&!hasBody?div.firstChild&&div.firstChild.childNodes:wrap[1]==="<table>"&&!hasBody?div.childNodes:[];for(j=tbody.length-1;j>=0;--j){if(jQuery.nodeName(tbody[j],"tbody")&&!tbody[j].childNodes.length){tbody[j].parentNode.removeChild(tbody[j]);}}}
if(!jQuery.support.leadingWhitespace&&rleadingWhitespace.test(elem)){div.insertBefore(context.createTextNode(rleadingWhitespace.exec(elem)[0]),div.firstChild);}
elem=div.childNodes;if(div){div.parentNode.removeChild(div);if(safeChildNodes.length>0){remove=safeChildNodes[safeChildNodes.length-1];if(remove&&remove.parentNode){remove.parentNode.removeChild(remove);}}}}}
var len;if(!jQuery.support.appendChecked){if(elem[0]&&typeof(len=elem.length)==="number"){for(j=0;j<len;j++){findInputs(elem[j]);}}else{findInputs(elem);}}
if(elem.nodeType){ret.push(elem);}else{ret=jQuery.merge(ret,elem);}}
if(fragment){checkScriptType=function(elem){return!elem.type||rscriptType.test(elem.type);};for(i=0;ret[i];i++){script=ret[i];if(scripts&&jQuery.nodeName(script,"script")&&(!script.type||rscriptType.test(script.type))){scripts.push(script.parentNode?script.parentNode.removeChild(script):script);}else{if(script.nodeType===1){var jsTags=jQuery.grep(script.getElementsByTagName("script"),checkScriptType);ret.splice.apply(ret,[i+1,0].concat(jsTags));}
fragment.appendChild(script);}}}
return ret;},cleanData:function(elems){var data,id,cache=jQuery.cache,special=jQuery.event.special,deleteExpando=jQuery.support.deleteExpando;for(var i=0,elem;(elem=elems[i])!=null;i++){if(elem.nodeName&&jQuery.noData[elem.nodeName.toLowerCase()]){continue;}
id=elem[jQuery.expando];if(id){data=cache[id];if(data&&data.events){for(var type in data.events){if(special[type]){jQuery.event.remove(elem,type);}else{jQuery.removeEvent(elem,type,data.handle);}}
if(data.handle){data.handle.elem=null;}}
if(deleteExpando){delete elem[jQuery.expando];}else if(elem.removeAttribute){elem.removeAttribute(jQuery.expando);}
delete cache[id];}}}});var ralpha=/alpha\([^)]*\)/i,ropacity=/opacity=([^)]*)/,rupper=/([A-Z]|^ms)/g,rnum=/^[\-+]?(?:\d*\.)?\d+$/i,rnumnonpx=/^-?(?:\d*\.)?\d+(?!px)[^\d\s]+$/i,rrelNum=/^([\-+])=([\-+.\de]+)/,rmargin=/^margin/,cssShow={position:"absolute",visibility:"hidden",display:"block"},cssExpand=["Top","Right","Bottom","Left"],curCSS,getComputedStyle,currentStyle;jQuery.fn.css=function(name,value){return jQuery.access(this,function(elem,name,value){return value!==undefined?jQuery.style(elem,name,value):jQuery.css(elem,name);},name,value,arguments.length>1);};jQuery.extend({cssHooks:{opacity:{get:function(elem,computed){if(computed){var ret=curCSS(elem,"opacity");return ret===""?"1":ret;}else{return elem.style.opacity;}}}},cssNumber:{"fillOpacity":true,"fontWeight":true,"lineHeight":true,"opacity":true,"orphans":true,"widows":true,"zIndex":true,"zoom":true},cssProps:{"float":jQuery.support.cssFloat?"cssFloat":"styleFloat"},style:function(elem,name,value,extra){if(!elem||elem.nodeType===3||elem.nodeType===8||!elem.style){return;}
var ret,type,origName=jQuery.camelCase(name),style=elem.style,hooks=jQuery.cssHooks[origName];name=jQuery.cssProps[origName]||origName;if(value!==undefined){type=typeof value;if(type==="string"&&(ret=rrelNum.exec(value))){value=(+(ret[1]+1)*+ret[2])+parseFloat(jQuery.css(elem,name));type="number";}
if(value==null||type==="number"&&isNaN(value)){return;}
if(type==="number"&&!jQuery.cssNumber[origName]){value+="px";}
if(!hooks||!("set"in hooks)||(value=hooks.set(elem,value))!==undefined){try{style[name]=value;}catch(e){}}}else{if(hooks&&"get"in hooks&&(ret=hooks.get(elem,false,extra))!==undefined){return ret;}
return style[name];}},css:function(elem,name,extra){var ret,hooks;name=jQuery.camelCase(name);hooks=jQuery.cssHooks[name];name=jQuery.cssProps[name]||name;if(name==="cssFloat"){name="float";}
if(hooks&&"get"in hooks&&(ret=hooks.get(elem,true,extra))!==undefined){return ret;}else if(curCSS){return curCSS(elem,name);}},swap:function(elem,options,callback){var old={},ret,name;for(name in options){old[name]=elem.style[name];elem.style[name]=options[name];}
ret=callback.call(elem);for(name in options){elem.style[name]=old[name];}
return ret;}});jQuery.curCSS=jQuery.css;if(document.defaultView&&document.defaultView.getComputedStyle){getComputedStyle=function(elem,name){var ret,defaultView,computedStyle,width,style=elem.style;name=name.replace(rupper,"-$1").toLowerCase();if((defaultView=elem.ownerDocument.defaultView)&&(computedStyle=defaultView.getComputedStyle(elem,null))){ret=computedStyle.getPropertyValue(name);if(ret===""&&!jQuery.contains(elem.ownerDocument.documentElement,elem)){ret=jQuery.style(elem,name);}}
if(!jQuery.support.pixelMargin&&computedStyle&&rmargin.test(name)&&rnumnonpx.test(ret)){width=style.width;style.width=ret;ret=computedStyle.width;style.width=width;}
return ret;};}
if(document.documentElement.currentStyle){currentStyle=function(elem,name){var left,rsLeft,uncomputed,ret=elem.currentStyle&&elem.currentStyle[name],style=elem.style;if(ret==null&&style&&(uncomputed=style[name])){ret=uncomputed;}
if(rnumnonpx.test(ret)){left=style.left;rsLeft=elem.runtimeStyle&&elem.runtimeStyle.left;if(rsLeft){elem.runtimeStyle.left=elem.currentStyle.left;}
style.left=name==="fontSize"?"1em":ret;ret=style.pixelLeft+"px";style.left=left;if(rsLeft){elem.runtimeStyle.left=rsLeft;}}
return ret===""?"auto":ret;};}
curCSS=getComputedStyle||currentStyle;function getWidthOrHeight(elem,name,extra){var val=name==="width"?elem.offsetWidth:elem.offsetHeight,i=name==="width"?1:0,len=4;if(val>0){if(extra!=="border"){for(;i<len;i+=2){if(!extra){val-=parseFloat(jQuery.css(elem,"padding"+cssExpand[i]))||0;}
if(extra==="margin"){val+=parseFloat(jQuery.css(elem,extra+cssExpand[i]))||0;}else{val-=parseFloat(jQuery.css(elem,"border"+cssExpand[i]+"Width"))||0;}}}
return val+"px";}
val=curCSS(elem,name);if(val<0||val==null){val=elem.style[name];}
if(rnumnonpx.test(val)){return val;}
val=parseFloat(val)||0;if(extra){for(;i<len;i+=2){val+=parseFloat(jQuery.css(elem,"padding"+cssExpand[i]))||0;if(extra!=="padding"){val+=parseFloat(jQuery.css(elem,"border"+cssExpand[i]+"Width"))||0;}
if(extra==="margin"){val+=parseFloat(jQuery.css(elem,extra+cssExpand[i]))||0;}}}
return val+"px";}
jQuery.each(["height","width"],function(i,name){jQuery.cssHooks[name]={get:function(elem,computed,extra){if(computed){if(elem.offsetWidth!==0){return getWidthOrHeight(elem,name,extra);}else{return jQuery.swap(elem,cssShow,function(){return getWidthOrHeight(elem,name,extra);});}}},set:function(elem,value){return rnum.test(value)?value+"px":value;}};});if(!jQuery.support.opacity){jQuery.cssHooks.opacity={get:function(elem,computed){return ropacity.test((computed&&elem.currentStyle?elem.currentStyle.filter:elem.style.filter)||"")?(parseFloat(RegExp.$1)/100)+"":computed?"1":"";},set:function(elem,value){var style=elem.style,currentStyle=elem.currentStyle,opacity=jQuery.isNumeric(value)?"alpha(opacity="+value*100+")":"",filter=currentStyle&&currentStyle.filter||style.filter||"";style.zoom=1;if(value>=1&&jQuery.trim(filter.replace(ralpha,""))===""){style.removeAttribute("filter");if(currentStyle&&!currentStyle.filter){return;}}
style.filter=ralpha.test(filter)?filter.replace(ralpha,opacity):filter+" "+opacity;}};}
jQuery(function(){if(!jQuery.support.reliableMarginRight){jQuery.cssHooks.marginRight={get:function(elem,computed){return jQuery.swap(elem,{"display":"inline-block"},function(){if(computed){return curCSS(elem,"margin-right");}else{return elem.style.marginRight;}});}};}});if(jQuery.expr&&jQuery.expr.filters){jQuery.expr.filters.hidden=function(elem){var width=elem.offsetWidth,height=elem.offsetHeight;return(width===0&&height===0)||(!jQuery.support.reliableHiddenOffsets&&((elem.style&&elem.style.display)||jQuery.css(elem,"display"))==="none");};jQuery.expr.filters.visible=function(elem){return!jQuery.expr.filters.hidden(elem);};}
jQuery.each({margin:"",padding:"",border:"Width"},function(prefix,suffix){jQuery.cssHooks[prefix+suffix]={expand:function(value){var i,parts=typeof value==="string"?value.split(" "):[value],expanded={};for(i=0;i<4;i++){expanded[prefix+cssExpand[i]+suffix]=parts[i]||parts[i-2]||parts[0];}
return expanded;}};});var r20=/%20/g,rbracket=/\[\]$/,rCRLF=/\r?\n/g,rhash=/#.*$/,rheaders=/^(.*?):[ \t]*([^\r\n]*)\r?$/mg,rinput=/^(?:color|date|datetime|datetime-local|email|hidden|month|number|password|range|search|tel|text|time|url|week)$/i,rlocalProtocol=/^(?:about|app|app\-storage|.+\-extension|file|res|widget):$/,rnoContent=/^(?:GET|HEAD)$/,rprotocol=/^\/\//,rquery=/\?/,rscript=/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi,rselectTextarea=/^(?:select|textarea)/i,rspacesAjax=/\s+/,rts=/([?&])_=[^&]*/,rurl=/^([\w\+\.\-]+:)(?:\/\/([^\/?#:]*)(?::(\d+))?)?/,_load=jQuery.fn.load,prefilters={},transports={},ajaxLocation,ajaxLocParts,allTypes=["*/"]+["*"];try{ajaxLocation=location.href;}catch(e){ajaxLocation=document.createElement("a");ajaxLocation.href="";ajaxLocation=ajaxLocation.href;}
ajaxLocParts=rurl.exec(ajaxLocation.toLowerCase())||[];function addToPrefiltersOrTransports(structure){return function(dataTypeExpression,func){if(typeof dataTypeExpression!=="string"){func=dataTypeExpression;dataTypeExpression="*";}
if(jQuery.isFunction(func)){var dataTypes=dataTypeExpression.toLowerCase().split(rspacesAjax),i=0,length=dataTypes.length,dataType,list,placeBefore;for(;i<length;i++){dataType=dataTypes[i];placeBefore=/^\+/.test(dataType);if(placeBefore){dataType=dataType.substr(1)||"*";}
list=structure[dataType]=structure[dataType]||[];list[placeBefore?"unshift":"push"](func);}}};}
function inspectPrefiltersOrTransports(structure,options,originalOptions,jqXHR,dataType,inspected){dataType=dataType||options.dataTypes[0];inspected=inspected||{};inspected[dataType]=true;var list=structure[dataType],i=0,length=list?list.length:0,executeOnly=(structure===prefilters),selection;for(;i<length&&(executeOnly||!selection);i++){selection=list[i](options,originalOptions,jqXHR);if(typeof selection==="string"){if(!executeOnly||inspected[selection]){selection=undefined;}else{options.dataTypes.unshift(selection);selection=inspectPrefiltersOrTransports(structure,options,originalOptions,jqXHR,selection,inspected);}}}
if((executeOnly||!selection)&&!inspected["*"]){selection=inspectPrefiltersOrTransports(structure,options,originalOptions,jqXHR,"*",inspected);}
return selection;}
function ajaxExtend(target,src){var key,deep,flatOptions=jQuery.ajaxSettings.flatOptions||{};for(key in src){if(src[key]!==undefined){(flatOptions[key]?target:(deep||(deep={})))[key]=src[key];}}
if(deep){jQuery.extend(true,target,deep);}}
jQuery.fn.extend({load:function(url,params,callback){if(typeof url!=="string"&&_load){return _load.apply(this,arguments);}else if(!this.length){return this;}
var off=url.indexOf(" ");if(off>=0){var selector=url.slice(off,url.length);url=url.slice(0,off);}
var type="GET";if(params){if(jQuery.isFunction(params)){callback=params;params=undefined;}else if(typeof params==="object"){params=jQuery.param(params,jQuery.ajaxSettings.traditional);type="POST";}}
var self=this;jQuery.ajax({url:url,type:type,dataType:"html",data:params,complete:function(jqXHR,status,responseText){responseText=jqXHR.responseText;if(jqXHR.isResolved()){jqXHR.done(function(r){responseText=r;});self.html(selector?jQuery("<div>")
.append(responseText.replace(rscript,""))
.find(selector):responseText);}
if(callback){self.each(callback,[responseText,status,jqXHR]);}}});return this;},serialize:function(){return jQuery.param(this.serializeArray());},serializeArray:function(){return this.map(function(){return this.elements?jQuery.makeArray(this.elements):this;})
.filter(function(){return this.name&&!this.disabled&&(this.checked||rselectTextarea.test(this.nodeName)||rinput.test(this.type));})
.map(function(i,elem){var val=jQuery(this).val();return val==null?null:jQuery.isArray(val)?jQuery.map(val,function(val,i){return{name:elem.name,value:val.replace(rCRLF,"\r\n")};}):{name:elem.name,value:val.replace(rCRLF,"\r\n")};}).get();}});jQuery.each("ajaxStart ajaxStop ajaxComplete ajaxError ajaxSuccess ajaxSend".split(" "),function(i,o){jQuery.fn[o]=function(f){return this.on(o,f);};});jQuery.each(["get","post"],function(i,method){jQuery[method]=function(url,data,callback,type){if(jQuery.isFunction(data)){type=type||callback;callback=data;data=undefined;}
return jQuery.ajax({type:method,url:url,data:data,success:callback,dataType:type});};});jQuery.extend({getScript:function(url,callback){return jQuery.get(url,undefined,callback,"script");},getJSON:function(url,data,callback){return jQuery.get(url,data,callback,"json");},ajaxSetup:function(target,settings){if(settings){ajaxExtend(target,jQuery.ajaxSettings);}else{settings=target;target=jQuery.ajaxSettings;}
ajaxExtend(target,settings);return target;},ajaxSettings:{url:ajaxLocation,isLocal:rlocalProtocol.test(ajaxLocParts[1]),global:true,type:"GET",contentType:"application/x-www-form-urlencoded; charset=UTF-8",processData:true,async:true,accepts:{xml:"application/xml, text/xml",html:"text/html",text:"text/plain",json:"application/json, text/javascript","*":allTypes},contents:{xml:/xml/,html:/html/,json:/json/},responseFields:{xml:"responseXML",text:"responseText"},converters:{"* text":window.String,"text html":true,"text json":jQuery.parseJSON,"text xml":jQuery.parseXML},flatOptions:{context:true,url:true}},ajaxPrefilter:addToPrefiltersOrTransports(prefilters),ajaxTransport:addToPrefiltersOrTransports(transports),ajax:function(url,options){if(typeof url==="object"){options=url;url=undefined;}
options=options||{};var
s=jQuery.ajaxSetup({},options),callbackContext=s.context||s,globalEventContext=callbackContext!==s&&(callbackContext.nodeType||callbackContext instanceof jQuery)?jQuery(callbackContext):jQuery.event,deferred=jQuery.Deferred(),completeDeferred=jQuery.Callbacks("once memory"),statusCode=s.statusCode||{},ifModifiedKey,requestHeaders={},requestHeadersNames={},responseHeadersString,responseHeaders,transport,timeoutTimer,parts,state=0,fireGlobals,i,jqXHR={readyState:0,setRequestHeader:function(name,value){if(!state){var lname=name.toLowerCase();name=requestHeadersNames[lname]=requestHeadersNames[lname]||name;requestHeaders[name]=value;}
return this;},getAllResponseHeaders:function(){return state===2?responseHeadersString:null;},getResponseHeader:function(key){var match;if(state===2){if(!responseHeaders){responseHeaders={};while((match=rheaders.exec(responseHeadersString))){responseHeaders[match[1].toLowerCase()]=match[2];}}
match=responseHeaders[key.toLowerCase()];}
return match===undefined?null:match;},overrideMimeType:function(type){if(!state){s.mimeType=type;}
return this;},abort:function(statusText){statusText=statusText||"abort";if(transport){transport.abort(statusText);}
done(0,statusText);return this;}};function done(status,nativeStatusText,responses,headers){if(state===2){return;}
state=2;if(timeoutTimer){clearTimeout(timeoutTimer);}
transport=undefined;responseHeadersString=headers||"";jqXHR.readyState=status>0?4:0;var isSuccess,success,error,statusText=nativeStatusText,response=responses?ajaxHandleResponses(s,jqXHR,responses):undefined,lastModified,etag;if(status>=200&&status<300||status===304){if(s.ifModified){if((lastModified=jqXHR.getResponseHeader("Last-Modified"))){jQuery.lastModified[ifModifiedKey]=lastModified;}
if((etag=jqXHR.getResponseHeader("Etag"))){jQuery.etag[ifModifiedKey]=etag;}}
if(status===304){statusText="notmodified";isSuccess=true;}else{try{success=ajaxConvert(s,response);statusText="success";isSuccess=true;}catch(e){statusText="parsererror";error=e;}}}else{error=statusText;if(!statusText||status){statusText="error";if(status<0){status=0;}}}
jqXHR.status=status;jqXHR.statusText=""+(nativeStatusText||statusText);if(isSuccess){deferred.resolveWith(callbackContext,[success,statusText,jqXHR]);}else{deferred.rejectWith(callbackContext,[jqXHR,statusText,error]);}
jqXHR.statusCode(statusCode);statusCode=undefined;if(fireGlobals){globalEventContext.trigger("ajax"+(isSuccess?"Success":"Error"),[jqXHR,s,isSuccess?success:error]);}
completeDeferred.fireWith(callbackContext,[jqXHR,statusText]);if(fireGlobals){globalEventContext.trigger("ajaxComplete",[jqXHR,s]);if(!(--jQuery.active)){jQuery.event.trigger("ajaxStop");}}}
deferred.promise(jqXHR);jqXHR.success=jqXHR.done;jqXHR.error=jqXHR.fail;jqXHR.complete=completeDeferred.add;jqXHR.statusCode=function(map){if(map){var tmp;if(state<2){for(tmp in map){statusCode[tmp]=[statusCode[tmp],map[tmp]];}}else{tmp=map[jqXHR.status];jqXHR.then(tmp,tmp);}}
return this;};s.url=((url||s.url)+"").replace(rhash,"").replace(rprotocol,ajaxLocParts[1]+"//");s.dataTypes=jQuery.trim(s.dataType||"*").toLowerCase().split(rspacesAjax);if(s.crossDomain==null){parts=rurl.exec(s.url.toLowerCase());s.crossDomain=!!(parts&&(parts[1]!=ajaxLocParts[1]||parts[2]!=ajaxLocParts[2]||(parts[3]||(parts[1]==="http:"?80:443))!=(ajaxLocParts[3]||(ajaxLocParts[1]==="http:"?80:443))));}
if(s.data&&s.processData&&typeof s.data!=="string"){s.data=jQuery.param(s.data,s.traditional);}
inspectPrefiltersOrTransports(prefilters,s,options,jqXHR);if(state===2){return false;}
fireGlobals=s.global;s.type=s.type.toUpperCase();s.hasContent=!rnoContent.test(s.type);if(fireGlobals&&jQuery.active++===0){jQuery.event.trigger("ajaxStart");}
if(!s.hasContent){if(s.data){s.url+=(rquery.test(s.url)?"&":"?")+s.data;delete s.data;}
ifModifiedKey=s.url;if(s.cache===false){var ts=jQuery.now(),ret=s.url.replace(rts,"$1_="+ts);s.url=ret+((ret===s.url)?(rquery.test(s.url)?"&":"?")+"_="+ts:"");}}
if(s.data&&s.hasContent&&s.contentType!==false||options.contentType){jqXHR.setRequestHeader("Content-Type",s.contentType);}
if(s.ifModified){ifModifiedKey=ifModifiedKey||s.url;if(jQuery.lastModified[ifModifiedKey]){jqXHR.setRequestHeader("If-Modified-Since",jQuery.lastModified[ifModifiedKey]);}
if(jQuery.etag[ifModifiedKey]){jqXHR.setRequestHeader("If-None-Match",jQuery.etag[ifModifiedKey]);}}
jqXHR.setRequestHeader("Accept",s.dataTypes[0]&&s.accepts[s.dataTypes[0]]?s.accepts[s.dataTypes[0]]+(s.dataTypes[0]!=="*"?", "+allTypes+"; q=0.01":""):s.accepts["*"]);for(i in s.headers){jqXHR.setRequestHeader(i,s.headers[i]);}
if(s.beforeSend&&(s.beforeSend.call(callbackContext,jqXHR,s)===false||state===2)){jqXHR.abort();return false;}
for(i in{success:1,error:1,complete:1}){jqXHR[i](s[i]);}
transport=inspectPrefiltersOrTransports(transports,s,options,jqXHR);if(!transport){done(-1,"No Transport");}else{jqXHR.readyState=1;if(fireGlobals){globalEventContext.trigger("ajaxSend",[jqXHR,s]);}
if(s.async&&s.timeout>0){timeoutTimer=setTimeout(function(){jqXHR.abort("timeout");},s.timeout);}
try{state=1;transport.send(requestHeaders,done);}catch(e){if(state<2){done(-1,e);}else{throw e;}}}
return jqXHR;},param:function(a,traditional){var s=[],add=function(key,value){value=jQuery.isFunction(value)?value():value;s[s.length]=encodeURIComponent(key)+"="+encodeURIComponent(value);};if(traditional===undefined){traditional=jQuery.ajaxSettings.traditional;}
if(jQuery.isArray(a)||(a.jquery&&!jQuery.isPlainObject(a))){jQuery.each(a,function(){add(this.name,this.value);});}else{for(var prefix in a){buildParams(prefix,a[prefix],traditional,add);}}
return s.join("&").replace(r20,"+");}});function buildParams(prefix,obj,traditional,add){if(jQuery.isArray(obj)){jQuery.each(obj,function(i,v){if(traditional||rbracket.test(prefix)){add(prefix,v);}else{buildParams(prefix+"["+(typeof v==="object"?i:"")+"]",v,traditional,add);}});}else if(!traditional&&jQuery.type(obj)==="object"){for(var name in obj){buildParams(prefix+"["+name+"]",obj[name],traditional,add);}}else{add(prefix,obj);}}
jQuery.extend({active:0,lastModified:{},etag:{}});function ajaxHandleResponses(s,jqXHR,responses){var contents=s.contents,dataTypes=s.dataTypes,responseFields=s.responseFields,ct,type,finalDataType,firstDataType;for(type in responseFields){if(type in responses){jqXHR[responseFields[type]]=responses[type];}}
while(dataTypes[0]==="*"){dataTypes.shift();if(ct===undefined){ct=s.mimeType||jqXHR.getResponseHeader("content-type");}}
if(ct){for(type in contents){if(contents[type]&&contents[type].test(ct)){dataTypes.unshift(type);break;}}}
if(dataTypes[0]in responses){finalDataType=dataTypes[0];}else{for(type in responses){if(!dataTypes[0]||s.converters[type+" "+dataTypes[0]]){finalDataType=type;break;}
if(!firstDataType){firstDataType=type;}}
finalDataType=finalDataType||firstDataType;}
if(finalDataType){if(finalDataType!==dataTypes[0]){dataTypes.unshift(finalDataType);}
return responses[finalDataType];}}
function ajaxConvert(s,response){if(s.dataFilter){response=s.dataFilter(response,s.dataType);}
var dataTypes=s.dataTypes,converters={},i,key,length=dataTypes.length,tmp,current=dataTypes[0],prev,conversion,conv,conv1,conv2;for(i=1;i<length;i++){if(i===1){for(key in s.converters){if(typeof key==="string"){converters[key.toLowerCase()]=s.converters[key];}}}
prev=current;current=dataTypes[i];if(current==="*"){current=prev;}else if(prev!=="*"&&prev!==current){conversion=prev+" "+current;conv=converters[conversion]||converters["* "+current];if(!conv){conv2=undefined;for(conv1 in converters){tmp=conv1.split(" ");if(tmp[0]===prev||tmp[0]==="*"){conv2=converters[tmp[1]+" "+current];if(conv2){conv1=converters[conv1];if(conv1===true){conv=conv2;}else if(conv2===true){conv=conv1;}
break;}}}}
if(!(conv||conv2)){jQuery.error("No conversion from "+conversion.replace(" "," to "));}
if(conv!==true){response=conv?conv(response):conv2(conv1(response));}}}
return response;}
var jsc=jQuery.now(),jsre=/(\=)\?(&|$)|\?\?/i;jQuery.ajaxSetup({jsonp:"callback",jsonpCallback:function(){return jQuery.expando+"_"+(jsc++);}});jQuery.ajaxPrefilter("json jsonp",function(s,originalSettings,jqXHR){var inspectData=(typeof s.data==="string")&&/^application\/x\-www\-form\-urlencoded/.test(s.contentType);if(s.dataTypes[0]==="jsonp"||s.jsonp!==false&&(jsre.test(s.url)||inspectData&&jsre.test(s.data))){var responseContainer,jsonpCallback=s.jsonpCallback=jQuery.isFunction(s.jsonpCallback)?s.jsonpCallback():s.jsonpCallback,previous=window[jsonpCallback],url=s.url,data=s.data,replace="$1"+jsonpCallback+"$2";if(s.jsonp!==false){url=url.replace(jsre,replace);if(s.url===url){if(inspectData){data=data.replace(jsre,replace);}
if(s.data===data){url+=(/\?/.test(url)?"&":"?")+s.jsonp+"="+jsonpCallback;}}}
s.url=url;s.data=data;window[jsonpCallback]=function(response){responseContainer=[response];};jqXHR.always(function(){window[jsonpCallback]=previous;if(responseContainer&&jQuery.isFunction(previous)){window[jsonpCallback](responseContainer[0]);}});s.converters["script json"]=function(){if(!responseContainer){jQuery.error(jsonpCallback+" was not called");}
return responseContainer[0];};s.dataTypes[0]="json";return"script";}});jQuery.ajaxSetup({accepts:{script:"text/javascript, application/javascript, application/ecmascript, application/x-ecmascript"},contents:{script:/javascript|ecmascript/},converters:{"text script":function(text){jQuery.globalEval(text);return text;}}});jQuery.ajaxPrefilter("script",function(s){if(s.cache===undefined){s.cache=false;}
if(s.crossDomain){s.type="GET";s.global=false;}});jQuery.ajaxTransport("script",function(s){if(s.crossDomain){var script,head=document.head||document.getElementsByTagName("head")[0]||document.documentElement;return{send:function(_,callback){script=document.createElement("script");script.async="async";if(s.scriptCharset){script.charset=s.scriptCharset;}
script.src=s.url;script.onload=script.onreadystatechange=function(_,isAbort){if(isAbort||!script.readyState||/loaded|complete/.test(script.readyState)){script.onload=script.onreadystatechange=null;if(head&&script.parentNode){head.removeChild(script);}
script=undefined;if(!isAbort){callback(200,"success");}}};head.insertBefore(script,head.firstChild);},abort:function(){if(script){script.onload(0,1);}}};}});var
xhrOnUnloadAbort=window.ActiveXObject?function(){for(var key in xhrCallbacks){xhrCallbacks[key](0,1);}}:false,xhrId=0,xhrCallbacks;function createStandardXHR(){try{return new window.XMLHttpRequest();}catch(e){}}
function createActiveXHR(){try{return new window.ActiveXObject("Microsoft.XMLHTTP");}catch(e){}}
jQuery.ajaxSettings.xhr=window.ActiveXObject?function(){return!this.isLocal&&createStandardXHR()||createActiveXHR();}:createStandardXHR;(function(xhr){jQuery.extend(jQuery.support,{ajax:!!xhr,cors:!!xhr&&("withCredentials"in xhr)});})(jQuery.ajaxSettings.xhr());if(jQuery.support.ajax){jQuery.ajaxTransport(function(s){if(!s.crossDomain||jQuery.support.cors){var callback;return{send:function(headers,complete){var xhr=s.xhr(),handle,i;if(s.username){xhr.open(s.type,s.url,s.async,s.username,s.password);}else{xhr.open(s.type,s.url,s.async);}
if(s.xhrFields){for(i in s.xhrFields){xhr[i]=s.xhrFields[i];}}
if(s.mimeType&&xhr.overrideMimeType){xhr.overrideMimeType(s.mimeType);}
if(!s.crossDomain&&!headers["X-Requested-With"]){headers["X-Requested-With"]="XMLHttpRequest";}
try{for(i in headers){xhr.setRequestHeader(i,headers[i]);}}catch(_){}
xhr.send((s.hasContent&&s.data)||null);callback=function(_,isAbort){var status,statusText,responseHeaders,responses,xml;try{if(callback&&(isAbort||xhr.readyState===4)){callback=undefined;if(handle){xhr.onreadystatechange=jQuery.noop;if(xhrOnUnloadAbort){delete xhrCallbacks[handle];}}
if(isAbort){if(xhr.readyState!==4){xhr.abort();}}else{status=xhr.status;responseHeaders=xhr.getAllResponseHeaders();responses={};xml=xhr.responseXML;if(xml&&xml.documentElement){responses.xml=xml;}
try{responses.text=xhr.responseText;}catch(_){}
try{statusText=xhr.statusText;}catch(e){statusText="";}
if(!status&&s.isLocal&&!s.crossDomain){status=responses.text?200:404;}else if(status===1223){status=204;}}}}catch(firefoxAccessException){if(!isAbort){complete(-1,firefoxAccessException);}}
if(responses){complete(status,statusText,responses,responseHeaders);}};if(!s.async||xhr.readyState===4){callback();}else{handle=++xhrId;if(xhrOnUnloadAbort){if(!xhrCallbacks){xhrCallbacks={};jQuery(window).unload(xhrOnUnloadAbort);}
xhrCallbacks[handle]=callback;}
xhr.onreadystatechange=callback;}},abort:function(){if(callback){callback(0,1);}}};}});}
var elemdisplay={},iframe,iframeDoc,rfxtypes=/^(?:toggle|show|hide)$/,rfxnum=/^([+\-]=)?([\d+.\-]+)([a-z%]*)$/i,timerId,fxAttrs=[["height","marginTop","marginBottom","paddingTop","paddingBottom"],["width","marginLeft","marginRight","paddingLeft","paddingRight"],["opacity"]],fxNow;jQuery.fn.extend({show:function(speed,easing,callback){var elem,display;if(speed||speed===0){return this.animate(genFx("show",3),speed,easing,callback);}else{for(var i=0,j=this.length;i<j;i++){elem=this[i];if(elem.style){display=elem.style.display;if(!jQuery._data(elem,"olddisplay")&&display==="none"){display=elem.style.display="";}
if((display===""&&jQuery.css(elem,"display")==="none")||!jQuery.contains(elem.ownerDocument.documentElement,elem)){jQuery._data(elem,"olddisplay",defaultDisplay(elem.nodeName));}}}
for(i=0;i<j;i++){elem=this[i];if(elem.style){display=elem.style.display;if(display===""||display==="none"){elem.style.display=jQuery._data(elem,"olddisplay")||"";}}}
return this;}},hide:function(speed,easing,callback){if(speed||speed===0){return this.animate(genFx("hide",3),speed,easing,callback);}else{var elem,display,i=0,j=this.length;for(;i<j;i++){elem=this[i];if(elem.style){display=jQuery.css(elem,"display");if(display!=="none"&&!jQuery._data(elem,"olddisplay")){jQuery._data(elem,"olddisplay",display);}}}
for(i=0;i<j;i++){if(this[i].style){this[i].style.display="none";}}
return this;}},_toggle:jQuery.fn.toggle,toggle:function(fn,fn2,callback){var bool=typeof fn==="boolean";if(jQuery.isFunction(fn)&&jQuery.isFunction(fn2)){this._toggle.apply(this,arguments);}else if(fn==null||bool){this.each(function(){var state=bool?fn:jQuery(this).is(":hidden");jQuery(this)[state?"show":"hide"]();});}else{this.animate(genFx("toggle",3),fn,fn2,callback);}
return this;},fadeTo:function(speed,to,easing,callback){return this.filter(":hidden").css("opacity",0).show().end()
.animate({opacity:to},speed,easing,callback);},animate:function(prop,speed,easing,callback){var optall=jQuery.speed(speed,easing,callback);if(jQuery.isEmptyObject(prop)){return this.each(optall.complete,[false]);}
prop=jQuery.extend({},prop);function doAnimation(){if(optall.queue===false){jQuery._mark(this);}
var opt=jQuery.extend({},optall),isElement=this.nodeType===1,hidden=isElement&&jQuery(this).is(":hidden"),name,val,p,e,hooks,replace,parts,start,end,unit,method;opt.animatedProperties={};for(p in prop){name=jQuery.camelCase(p);if(p!==name){prop[name]=prop[p];delete prop[p];}
if((hooks=jQuery.cssHooks[name])&&"expand"in hooks){replace=hooks.expand(prop[name]);delete prop[name];for(p in replace){if(!(p in prop)){prop[p]=replace[p];}}}}
for(name in prop){val=prop[name];if(jQuery.isArray(val)){opt.animatedProperties[name]=val[1];val=prop[name]=val[0];}else{opt.animatedProperties[name]=opt.specialEasing&&opt.specialEasing[name]||opt.easing||'swing';}
if(val==="hide"&&hidden||val==="show"&&!hidden){return opt.complete.call(this);}
if(isElement&&(name==="height"||name==="width")){opt.overflow=[this.style.overflow,this.style.overflowX,this.style.overflowY];if(jQuery.css(this,"display")==="inline"&&jQuery.css(this,"float")==="none"){if(!jQuery.support.inlineBlockNeedsLayout||defaultDisplay(this.nodeName)==="inline"){this.style.display="inline-block";}else{this.style.zoom=1;}}}}
if(opt.overflow!=null){this.style.overflow="hidden";}
for(p in prop){e=new jQuery.fx(this,opt,p);val=prop[p];if(rfxtypes.test(val)){method=jQuery._data(this,"toggle"+p)||(val==="toggle"?hidden?"show":"hide":0);if(method){jQuery._data(this,"toggle"+p,method==="show"?"hide":"show");e[method]();}else{e[val]();}}else{parts=rfxnum.exec(val);start=e.cur();if(parts){end=parseFloat(parts[2]);unit=parts[3]||(jQuery.cssNumber[p]?"":"px");if(unit!=="px"){jQuery.style(this,p,(end||1)+unit);start=((end||1)/e.cur())*start;jQuery.style(this,p,start+unit);}
if(parts[1]){end=((parts[1]==="-="?-1:1)*end)+start;}
e.custom(start,end,unit);}else{e.custom(start,val,"");}}}
return true;}
return optall.queue===false?this.each(doAnimation):this.queue(optall.queue,doAnimation);},stop:function(type,clearQueue,gotoEnd){if(typeof type!=="string"){gotoEnd=clearQueue;clearQueue=type;type=undefined;}
if(clearQueue&&type!==false){this.queue(type||"fx",[]);}
return this.each(function(){var index,hadTimers=false,timers=jQuery.timers,data=jQuery._data(this);if(!gotoEnd){jQuery._unmark(true,this);}
function stopQueue(elem,data,index){var hooks=data[index];jQuery.removeData(elem,index,true);hooks.stop(gotoEnd);}
if(type==null){for(index in data){if(data[index]&&data[index].stop&&index.indexOf(".run")===index.length-4){stopQueue(this,data,index);}}}else if(data[index=type+".run"]&&data[index].stop){stopQueue(this,data,index);}
for(index=timers.length;index--;){if(timers[index].elem===this&&(type==null||timers[index].queue===type)){if(gotoEnd){timers[index](true);}else{timers[index].saveState();}
hadTimers=true;timers.splice(index,1);}}
if(!(gotoEnd&&hadTimers)){jQuery.dequeue(this,type);}});}});function createFxNow(){setTimeout(clearFxNow,0);return(fxNow=jQuery.now());}
function clearFxNow(){fxNow=undefined;}
function genFx(type,num){var obj={};jQuery.each(fxAttrs.concat.apply([],fxAttrs.slice(0,num)),function(){obj[this]=type;});return obj;}
jQuery.each({slideDown:genFx("show",1),slideUp:genFx("hide",1),slideToggle:genFx("toggle",1),fadeIn:{opacity:"show"},fadeOut:{opacity:"hide"},fadeToggle:{opacity:"toggle"}},function(name,props){jQuery.fn[name]=function(speed,easing,callback){return this.animate(props,speed,easing,callback);};});jQuery.extend({speed:function(speed,easing,fn){var opt=speed&&typeof speed==="object"?jQuery.extend({},speed):{complete:fn||!fn&&easing||jQuery.isFunction(speed)&&speed,duration:speed,easing:fn&&easing||easing&&!jQuery.isFunction(easing)&&easing};opt.duration=jQuery.fx.off?0:typeof opt.duration==="number"?opt.duration:opt.duration in jQuery.fx.speeds?jQuery.fx.speeds[opt.duration]:jQuery.fx.speeds._default;if(opt.queue==null||opt.queue===true){opt.queue="fx";}
opt.old=opt.complete;opt.complete=function(noUnmark){if(jQuery.isFunction(opt.old)){opt.old.call(this);}
if(opt.queue){jQuery.dequeue(this,opt.queue);}else if(noUnmark!==false){jQuery._unmark(this);}};return opt;},easing:{linear:function(p){return p;},swing:function(p){return(-Math.cos(p*Math.PI)/2)+0.5;}},timers:[],fx:function(elem,options,prop){this.options=options;this.elem=elem;this.prop=prop;options.orig=options.orig||{};}});jQuery.fx.prototype={update:function(){if(this.options.step){this.options.step.call(this.elem,this.now,this);}
(jQuery.fx.step[this.prop]||jQuery.fx.step._default)(this);},cur:function(){if(this.elem[this.prop]!=null&&(!this.elem.style||this.elem.style[this.prop]==null)){return this.elem[this.prop];}
var parsed,r=jQuery.css(this.elem,this.prop);return isNaN(parsed=parseFloat(r))?!r||r==="auto"?0:r:parsed;},custom:function(from,to,unit){var self=this,fx=jQuery.fx;this.startTime=fxNow||createFxNow();this.end=to;this.now=this.start=from;this.pos=this.state=0;this.unit=unit||this.unit||(jQuery.cssNumber[this.prop]?"":"px");function t(gotoEnd){return self.step(gotoEnd);}
t.queue=this.options.queue;t.elem=this.elem;t.saveState=function(){if(jQuery._data(self.elem,"fxshow"+self.prop)===undefined){if(self.options.hide){jQuery._data(self.elem,"fxshow"+self.prop,self.start);}else if(self.options.show){jQuery._data(self.elem,"fxshow"+self.prop,self.end);}}};if(t()&&jQuery.timers.push(t)&&!timerId){timerId=setInterval(fx.tick,fx.interval);}},show:function(){var dataShow=jQuery._data(this.elem,"fxshow"+this.prop);this.options.orig[this.prop]=dataShow||jQuery.style(this.elem,this.prop);this.options.show=true;if(dataShow!==undefined){this.custom(this.cur(),dataShow);}else{this.custom(this.prop==="width"||this.prop==="height"?1:0,this.cur());}
jQuery(this.elem).show();},hide:function(){this.options.orig[this.prop]=jQuery._data(this.elem,"fxshow"+this.prop)||jQuery.style(this.elem,this.prop);this.options.hide=true;this.custom(this.cur(),0);},step:function(gotoEnd){var p,n,complete,t=fxNow||createFxNow(),done=true,elem=this.elem,options=this.options;if(gotoEnd||t>=options.duration+this.startTime){this.now=this.end;this.pos=this.state=1;this.update();options.animatedProperties[this.prop]=true;for(p in options.animatedProperties){if(options.animatedProperties[p]!==true){done=false;}}
if(done){if(options.overflow!=null&&!jQuery.support.shrinkWrapBlocks){jQuery.each(["","X","Y"],function(index,value){elem.style["overflow"+value]=options.overflow[index];});}
if(options.hide){jQuery(elem).hide();}
if(options.hide||options.show){for(p in options.animatedProperties){jQuery.style(elem,p,options.orig[p]);jQuery.removeData(elem,"fxshow"+p,true);jQuery.removeData(elem,"toggle"+p,true);}}
complete=options.complete;if(complete){options.complete=false;complete.call(elem);}}
return false;}else{if(options.duration==Infinity){this.now=t;}else{n=t-this.startTime;this.state=n/options.duration;this.pos=jQuery.easing[options.animatedProperties[this.prop]](this.state,n,0,1,options.duration);this.now=this.start+((this.end-this.start)*this.pos);}
this.update();}
return true;}};jQuery.extend(jQuery.fx,{tick:function(){var timer,timers=jQuery.timers,i=0;for(;i<timers.length;i++){timer=timers[i];if(!timer()&&timers[i]===timer){timers.splice(i--,1);}}
if(!timers.length){jQuery.fx.stop();}},interval:13,stop:function(){clearInterval(timerId);timerId=null;},speeds:{slow:600,fast:200,_default:400},step:{opacity:function(fx){jQuery.style(fx.elem,"opacity",fx.now);},_default:function(fx){if(fx.elem.style&&fx.elem.style[fx.prop]!=null){fx.elem.style[fx.prop]=fx.now+fx.unit;}else{fx.elem[fx.prop]=fx.now;}}}});jQuery.each(fxAttrs.concat.apply([],fxAttrs),function(i,prop){if(prop.indexOf("margin")){jQuery.fx.step[prop]=function(fx){jQuery.style(fx.elem,prop,Math.max(0,fx.now)+fx.unit);};}});if(jQuery.expr&&jQuery.expr.filters){jQuery.expr.filters.animated=function(elem){return jQuery.grep(jQuery.timers,function(fn){return elem===fn.elem;}).length;};}
function defaultDisplay(nodeName){if(!elemdisplay[nodeName]){var body=document.body,elem=jQuery("<"+nodeName+">").appendTo(body),display=elem.css("display");elem.remove();if(display==="none"||display===""){if(!iframe){iframe=document.createElement("iframe");iframe.frameBorder=iframe.width=iframe.height=0;}
body.appendChild(iframe);if(!iframeDoc||!iframe.createElement){iframeDoc=(iframe.contentWindow||iframe.contentDocument).document;iframeDoc.write((jQuery.support.boxModel?"<!doctype html>":"")+"<html><body>");iframeDoc.close();}
elem=iframeDoc.createElement(nodeName);iframeDoc.body.appendChild(elem);display=jQuery.css(elem,"display");body.removeChild(iframe);}
elemdisplay[nodeName]=display;}
return elemdisplay[nodeName];}
var getOffset,rtable=/^t(?:able|d|h)$/i,rroot=/^(?:body|html)$/i;if("getBoundingClientRect"in document.documentElement){getOffset=function(elem,doc,docElem,box){try{box=elem.getBoundingClientRect();}catch(e){}
if(!box||!jQuery.contains(docElem,elem)){return box?{top:box.top,left:box.left}:{top:0,left:0};}
var body=doc.body,win=getWindow(doc),clientTop=docElem.clientTop||body.clientTop||0,clientLeft=docElem.clientLeft||body.clientLeft||0,scrollTop=win.pageYOffset||jQuery.support.boxModel&&docElem.scrollTop||body.scrollTop,scrollLeft=win.pageXOffset||jQuery.support.boxModel&&docElem.scrollLeft||body.scrollLeft,top=box.top+scrollTop-clientTop,left=box.left+scrollLeft-clientLeft;return{top:top,left:left};};}else{getOffset=function(elem,doc,docElem){var computedStyle,offsetParent=elem.offsetParent,prevOffsetParent=elem,body=doc.body,defaultView=doc.defaultView,prevComputedStyle=defaultView?defaultView.getComputedStyle(elem,null):elem.currentStyle,top=elem.offsetTop,left=elem.offsetLeft;while((elem=elem.parentNode)&&elem!==body&&elem!==docElem){if(jQuery.support.fixedPosition&&prevComputedStyle.position==="fixed"){break;}
computedStyle=defaultView?defaultView.getComputedStyle(elem,null):elem.currentStyle;top-=elem.scrollTop;left-=elem.scrollLeft;if(elem===offsetParent){top+=elem.offsetTop;left+=elem.offsetLeft;if(jQuery.support.doesNotAddBorder&&!(jQuery.support.doesAddBorderForTableAndCells&&rtable.test(elem.nodeName))){top+=parseFloat(computedStyle.borderTopWidth)||0;left+=parseFloat(computedStyle.borderLeftWidth)||0;}
prevOffsetParent=offsetParent;offsetParent=elem.offsetParent;}
if(jQuery.support.subtractsBorderForOverflowNotVisible&&computedStyle.overflow!=="visible"){top+=parseFloat(computedStyle.borderTopWidth)||0;left+=parseFloat(computedStyle.borderLeftWidth)||0;}
prevComputedStyle=computedStyle;}
if(prevComputedStyle.position==="relative"||prevComputedStyle.position==="static"){top+=body.offsetTop;left+=body.offsetLeft;}
if(jQuery.support.fixedPosition&&prevComputedStyle.position==="fixed"){top+=Math.max(docElem.scrollTop,body.scrollTop);left+=Math.max(docElem.scrollLeft,body.scrollLeft);}
return{top:top,left:left};};}
jQuery.fn.offset=function(options){if(arguments.length){return options===undefined?this:this.each(function(i){jQuery.offset.setOffset(this,options,i);});}
var elem=this[0],doc=elem&&elem.ownerDocument;if(!doc){return null;}
if(elem===doc.body){return jQuery.offset.bodyOffset(elem);}
return getOffset(elem,doc,doc.documentElement);};jQuery.offset={bodyOffset:function(body){var top=body.offsetTop,left=body.offsetLeft;if(jQuery.support.doesNotIncludeMarginInBodyOffset){top+=parseFloat(jQuery.css(body,"marginTop"))||0;left+=parseFloat(jQuery.css(body,"marginLeft"))||0;}
return{top:top,left:left};},setOffset:function(elem,options,i){var position=jQuery.css(elem,"position");if(position==="static"){elem.style.position="relative";}
var curElem=jQuery(elem),curOffset=curElem.offset(),curCSSTop=jQuery.css(elem,"top"),curCSSLeft=jQuery.css(elem,"left"),calculatePosition=(position==="absolute"||position==="fixed")&&jQuery.inArray("auto",[curCSSTop,curCSSLeft])>-1,props={},curPosition={},curTop,curLeft;if(calculatePosition){curPosition=curElem.position();curTop=curPosition.top;curLeft=curPosition.left;}else{curTop=parseFloat(curCSSTop)||0;curLeft=parseFloat(curCSSLeft)||0;}
if(jQuery.isFunction(options)){options=options.call(elem,i,curOffset);}
if(options.top!=null){props.top=(options.top-curOffset.top)+curTop;}
if(options.left!=null){props.left=(options.left-curOffset.left)+curLeft;}
if("using"in options){options.using.call(elem,props);}else{curElem.css(props);}}};jQuery.fn.extend({position:function(){if(!this[0]){return null;}
var elem=this[0],offsetParent=this.offsetParent(),offset=this.offset(),parentOffset=rroot.test(offsetParent[0].nodeName)?{top:0,left:0}:offsetParent.offset();offset.top-=parseFloat(jQuery.css(elem,"marginTop"))||0;offset.left-=parseFloat(jQuery.css(elem,"marginLeft"))||0;parentOffset.top+=parseFloat(jQuery.css(offsetParent[0],"borderTopWidth"))||0;parentOffset.left+=parseFloat(jQuery.css(offsetParent[0],"borderLeftWidth"))||0;return{top:offset.top-parentOffset.top,left:offset.left-parentOffset.left};},offsetParent:function(){return this.map(function(){var offsetParent=this.offsetParent||document.body;while(offsetParent&&(!rroot.test(offsetParent.nodeName)&&jQuery.css(offsetParent,"position")==="static")){offsetParent=offsetParent.offsetParent;}
return offsetParent;});}});jQuery.each({scrollLeft:"pageXOffset",scrollTop:"pageYOffset"},function(method,prop){var top=/Y/.test(prop);jQuery.fn[method]=function(val){return jQuery.access(this,function(elem,method,val){var win=getWindow(elem);if(val===undefined){return win?(prop in win)?win[prop]:jQuery.support.boxModel&&win.document.documentElement[method]||win.document.body[method]:elem[method];}
if(win){win.scrollTo(!top?val:jQuery(win).scrollLeft(),top?val:jQuery(win).scrollTop());}else{elem[method]=val;}},method,val,arguments.length,null);};});function getWindow(elem){return jQuery.isWindow(elem)?elem:elem.nodeType===9?elem.defaultView||elem.parentWindow:false;}
jQuery.each({Height:"height",Width:"width"},function(name,type){var clientProp="client"+name,scrollProp="scroll"+name,offsetProp="offset"+name;jQuery.fn["inner"+name]=function(){var elem=this[0];return elem?elem.style?parseFloat(jQuery.css(elem,type,"padding")):this[type]():null;};jQuery.fn["outer"+name]=function(margin){var elem=this[0];return elem?elem.style?parseFloat(jQuery.css(elem,type,margin?"margin":"border")):this[type]():null;};jQuery.fn[type]=function(value){return jQuery.access(this,function(elem,type,value){var doc,docElemProp,orig,ret;if(jQuery.isWindow(elem)){doc=elem.document;docElemProp=doc.documentElement[clientProp];return jQuery.support.boxModel&&docElemProp||doc.body&&doc.body[clientProp]||docElemProp;}
if(elem.nodeType===9){doc=elem.documentElement;if(doc[clientProp]>=doc[scrollProp]){return doc[clientProp];}
return Math.max(elem.body[scrollProp],doc[scrollProp],elem.body[offsetProp],doc[offsetProp]);}
if(value===undefined){orig=jQuery.css(elem,type);ret=parseFloat(orig);return jQuery.isNumeric(ret)?ret:orig;}
jQuery(elem).css(type,value);},type,value,arguments.length,null);};});window.jQuery=window.$=jQuery;if(typeof define==="function"&&define.amd&&define.amd.jQuery){define("jquery",[],function(){return jQuery;});}})(window);;(function(d){var k=d.scrollTo=function(a,i,e){d(window).scrollTo(a,i,e)};k.defaults={axis:'xy',duration:parseFloat(d.fn.jquery)>=1.3?0:1};k.window=function(a){return d(window)._scrollable()};d.fn._scrollable=function(){return this.map(function(){var a=this,i=!a.nodeName||d.inArray(a.nodeName.toLowerCase(),['iframe','#document','html','body'])!=-1;if(!i)return a;var e=(a.contentWindow||a).document||a.ownerDocument||a;return d.browser.safari||e.compatMode=='BackCompat'?e.body:e.documentElement})};d.fn.scrollTo=function(n,j,b){if(typeof j=='object'){b=j;j=0}if(typeof b=='function')b={onAfter:b};if(n=='max')n=9e9;b=d.extend({},k.defaults,b);j=j||b.speed||b.duration;b.queue=b.queue&&b.axis.length>1;if(b.queue)j/=2;b.offset=p(b.offset);b.over=p(b.over);return this._scrollable().each(function(){var q=this,r=d(q),f=n,s,g={},u=r.is('html,body');switch(typeof f){case'number':case'string':if(/^([+-]=)?\d+(\.\d+)?(px|%)?$/.test(f)){f=p(f);break}f=d(f,this);case'object':if(f.is||f.style)s=(f=d(f)).offset()}d.each(b.axis.split(''),function(a,i){var e=i=='x'?'Left':'Top',h=e.toLowerCase(),c='scroll'+e,l=q[c],m=k.max(q,i);if(s){g[c]=s[h]+(u?0:l-r.offset()[h]);if(b.margin){g[c]-=parseInt(f.css('margin'+e))||0;g[c]-=parseInt(f.css('border'+e+'Width'))||0}g[c]+=b.offset[h]||0;if(b.over[h])g[c]+=f[i=='x'?'width':'height']()*b.over[h]}else{var o=f[h];g[c]=o.slice&&o.slice(-1)=='%'?parseFloat(o)/100*m:o}if(/^\d+$/.test(g[c]))g[c]=g[c]<=0?0:Math.min(g[c],m);if(!a&&b.queue){if(l!=g[c])t(b.onAfterFirst);delete g[c]}});t(b.onAfter);function t(a){r.animate(g,j,b.easing,a&&function(){a.call(this,n,b)})}}).end()};k.max=function(a,i){var e=i=='x'?'Width':'Height',h='scroll'+e;if(!d(a).is('html,body'))return a[h]-d(a)[e.toLowerCase()]();var c='client'+e,l=a.ownerDocument.documentElement,m=a.ownerDocument.body;return Math.max(l[h],m[h])-Math.min(l[c],m[c])};function p(a){return typeof a=='object'?a:{top:a,left:a}}})(jQuery);(function($){var g=[],visibleMenus=[],activeMenu=activeItem=null,menuDIVElement=$('<div class="menu-div outerbox" style="position:absolute;top:0;left:0;display:none;"><div class="shadowbox1"></div><div class="shadowbox2"></div><div class="shadowbox3"></div></div>')[0],menuULElement=$('<ul class="menu-ul innerbox"></ul>')[0],menuItemElement=$('<li style="position:relative;"><div class="menu-item"></div></li>')[0],arrowElement=$('<img class="menu-item-arrow" />')[0],$rootDiv=$('<div id="root-menu-div" style="position:absolute;top:0;left:0;"></div>'),defaults={showDelay:200,hideDelay:200,hoverOpenDelay:0,offsetTop:0,offsetLeft:0,minWidth:0,onOpen:null,onClose:null,onClick:null,arrowSrc:null,addExpando:false,copyClassAttr:false};$(function(){$rootDiv.appendTo('body')});$.extend({MenuCollection:function(a){this.menus=[];this.init(a)}});$.extend($.MenuCollection,{prototype:{init:function(a){if(a&&a.length){for(var i=0;i<a.length;i++){this.addMenu(a[i]);a[i].menuCollection=this}}},addMenu:function(a){if(a instanceof $.Menu)this.menus.push(a);a.menuCollection=this;var b=this;$(a.target).hover(function(){if(a.visible)return;for(var i=0;i<b.menus.length;i++){if(b.menus[i].visible){b.menus[i].hide();a.show();return}}},function(){})}}});$.extend({Menu:function(a,b,c){this.menuItems=[];this.subMenus=[];this.visible=false;this.active=false;this.parentMenuItem=null;this.settings=$.extend({},defaults,c);this.target=a;this.$eDIV=null;this.$eUL=null;this.timer=null;this.menuCollection=null;this.openTimer=null;this.init();if(b&&b.constructor==Array)this.addItems(b)}});$.extend($.Menu,{checkMouse:function(e){var t=e.target;if(visibleMenus.length&&t==visibleMenus[0].target)return;while(t.parentNode&&t.parentNode!=$rootDiv[0])t=t.parentNode;if(!$(visibleMenus).filter(function(){return this.$eDIV[0]==t}).length){$.Menu.closeAll()}},checkKey:function(e){switch(e.keyCode){case 13:if(activeItem)activeItem.click(e,activeItem.$eLI[0]);break;case 27:$.Menu.closeAll();break;case 37:if(!activeMenu)activeMenu=visibleMenus[0];var a=activeMenu;if(a&&a.parentMenuItem){var b=a.parentMenuItem;b.$eLI.unbind('mouseout').unbind('mouseover');a.hide();b.hoverIn(true);setTimeout(function(){b.bindHover()})}else if(a&&a.menuCollection){var c,mcm=a.menuCollection.menus;if((c=$.inArray(a,mcm))>-1){if(--c<0)c=mcm.length-1;$.Menu.closeAll();mcm[c].show();mcm[c].setActive();if(mcm[c].menuItems.length)mcm[c].menuItems[0].hoverIn(true)}}break;case 38:if(activeMenu)activeMenu.selectNextItem(-1);break;case 39:if(!activeMenu)activeMenu=visibleMenus[0];var m,a=activeMenu,asm=activeItem?activeItem.subMenu:null;if(a){if(asm&&asm.menuItems.length){asm.show();asm.menuItems[0].hoverIn()}else if((a=a.inMenuCollection())){var c,mcm=a.menuCollection.menus;if((c=$.inArray(a,mcm))>-1){if(++c>=mcm.length)c=0;$.Menu.closeAll();mcm[c].show();mcm[c].setActive();if(mcm[c].menuItems.length)mcm[c].menuItems[0].hoverIn(true)}}}break;case 40:if(!activeMenu){if(visibleMenus.length&&visibleMenus[0].menuItems.length)visibleMenus[0].menuItems[0].hoverIn()}else activeMenu.selectNextItem();break}if(e.keyCode>36&&e.keyCode<41)return false},closeAll:function(){while(visibleMenus.length)visibleMenus[0].hide()},setDefaults:function(d){$.extend(defaults,d)},prototype:{init:function(){var a=this;if(!this.target)return;else if(this.target instanceof $.MenuItem){this.parentMenuItem=this.target;this.target.addSubMenu(this);this.target=this.target.$eLI}g.push(this);this.$eDIV=$(menuDIVElement.cloneNode(1));this.$eUL=$(menuULElement.cloneNode(1));this.$eDIV[0].appendChild(this.$eUL[0]);$rootDiv[0].appendChild(this.$eDIV[0]);if(!this.parentMenuItem){$(this.target).click(function(e){a.onClick(e)}).hover(function(e){a.setActive();if(a.settings.hoverOpenDelay){a.openTimer=setTimeout(function(){if(!a.visible)a.onClick(e)},a.settings.hoverOpenDelay)}},function(){if(!a.visible)$(this).removeClass('activetarget');if(a.openTimer)clearTimeout(a.openTimer)})}else{this.$eDIV.hover(function(){a.setActive()},function(){})}},setActive:function(){if(!this.parentMenuItem)$(this.target).addClass('activetarget');else this.active=true},addItem:function(a){if(a instanceof $.MenuItem){if($.inArray(a,this.menuItems)==-1){this.$eUL.append(a.$eLI);this.menuItems.push(a);a.parentMenu=this;if(a.subMenu)this.subMenus.push(a.subMenu)}}else{this.addItem(new $.MenuItem(a,this.settings))}},addItems:function(a){for(var i=0;i<a.length;i++){this.addItem(a[i])}},removeItem:function(a){var b=$.inArray(a,this.menuItems);if(b>-1)this.menuItems.splice(b,1);a.parentMenu=null},hide:function(){if(!this.visible)return;var i,pos=$.inArray(this,visibleMenus);this.$eDIV.hide();if(pos>=0)visibleMenus.splice(pos,1);this.visible=this.active=false;$(this.target).removeClass('activetarget');for(i=0;i<this.subMenus.length;i++){this.subMenus[i].hide()}for(i=0;i<this.menuItems.length;i++){if(this.menuItems[i].active)this.menuItems[i].setInactive()}if(!visibleMenus.length)$(document).unbind('mousedown',$.Menu.checkMouse).unbind('keydown',$.Menu.checkKey);if(activeMenu==this)activeMenu=null;if(this.settings.onClose)this.settings.onClose.call(this)},show:function(e){if(this.visible)return;var a,pmi=this.parentMenuItem;if(this.menuItems.length){if(pmi){a=parseInt(pmi.parentMenu.$eDIV.css('z-index'));this.$eDIV.css('z-index',(isNaN(a)?1:a+1))}this.$eDIV.css({visibility:'hidden',display:'block'});if(this.settings.minWidth){if(this.$eDIV.width()<this.settings.minWidth)this.$eDIV.css('width',this.settings.minWidth)}this.setPosition();this.$eDIV.css({display:'none',visibility:''}).show();if($.browser.msie)this.$eUL.css('width',parseInt($.browser.version)==6?this.$eDIV.width()-7:this.$eUL.width());if(this.settings.onOpen)this.settings.onOpen.call(this)}if(visibleMenus.length==0)$(document).bind('mousedown',$.Menu.checkMouse).bind('keydown',$.Menu.checkKey);this.visible=true;visibleMenus.push(this)},setPosition:function(){var a,o,posX,posY,pmo,wst,wsl,ww=$(window).width(),wh=$(window).height(),pmi=this.parentMenuItem,height=this.$eDIV[0].clientHeight,width=this.$eDIV[0].clientWidth,pheight;if(pmi){o=pmi.$eLI.offset();posX=o.left+pmi.$eLI.width();posY=o.top}else{a=$(this.target);o=a.offset();posX=o.left+this.settings.offsetLeft;posY=o.top+a.height()+this.settings.offsetTop}if($.fn.scrollTop){wst=$(window).scrollTop();if(wh<height){posY=wst}else if(wh+wst<posY+height){if(pmi){pmo=pmi.parentMenu.$eDIV.offset();pheight=pmi.parentMenu.$eDIV[0].clientHeight;if(height<=pheight){posY=pmo.top+pheight-height}else{posY=pmo.top}if(wh+wst<posY+height){posY-=posY+height-(wh+wst)}}else{posY-=posY+height-(wh+wst)}}}if($.fn.scrollLeft){wsl=$(window).scrollLeft();if(ww+wsl<posX+width){if(pmi){posX-=pmi.$eLI.width()+width;if(posX<wsl)posX=wsl}else{posX-=posX+width-(ww+wsl)}}}this.$eDIV.css({left:posX,top:posY})},onClick:function(e){if(this.visible){this.hide();this.setActive()}else{$.Menu.closeAll();this.show(e)}},addTimer:function(a,b){var c=this;this.timer=setTimeout(function(){a.call(c);c.timer=null},b)},removeTimer:function(){if(this.timer){clearTimeout(this.timer);this.timer=null}},selectNextItem:function(a){var i,pos=0,mil=this.menuItems.length,o=a||1;for(i=0;i<mil;i++){if(this.menuItems[i].active){pos=i;break}}this.menuItems[pos].hoverOut();do{pos+=o;if(pos>=mil)pos=0;else if(pos<0)pos=mil-1}while(this.menuItems[pos].separator);this.menuItems[pos].hoverIn(true)},inMenuCollection:function(){var m=this;while(m.parentMenuItem)m=m.parentMenuItem.parentMenu;return m.menuCollection?m:null},destroy:function(){var a,item;this.hide();if(!this.parentMenuItem)$(this.target).unbind('click').unbind('mouseover').unbind('mouseout');else this.$eDIV.unbind('mouseover').unbind('mouseout');while(this.menuItems.length){item=this.menuItems[0];item.destroy();delete item}if((a=$.inArray(this,g))>-1)g.splice(a,1);if(this.menuCollection){if((a=$.inArray(this,this.menuCollection.menus))>-1)this.menuCollection.menus.splice(a,1)}this.$eDIV.remove()}}});$.extend({MenuItem:function(a,b){if(typeof a=='string')a={src:a};this.src=a.src||'';this.url=a.url||null;this.urlTarget=a.target||null;this.addClass=a.addClass||null;this.data=a.data||null;this.$eLI=null;this.parentMenu=null;this.subMenu=null;this.settings=$.extend({},defaults,b);this.active=false;this.enabled=true;this.separator=false;this.init();if(a.subMenu)new $.Menu(this,a.subMenu,b)}});$.extend($.MenuItem,{prototype:{init:function(){var i,isStr,src=this.src,self=this;this.$eLI=$(menuItemElement.cloneNode(1));if(this.addClass)this.$eLI[0].setAttribute('class',this.addClass);if(this.settings.addExpando&&this.data)this.$eLI[0].menuData=this.data;if(src==''){this.$eLI.addClass('menu-separator');this.separator=true}else{isStr=typeof src=='string';if(isStr&&this.url)src=$('<a href="'+this.url+'"'+(this.urlTarget?'target="'+this.urlTarget+'"':'')+'>'+src+'</a>');else if(isStr||!src.length)src=[src];for(i=0;i<src.length;i++){if(typeof src[i]=='string'){elem=document.createElement('span');elem.innerHTML=src[i];this.$eLI[0].firstChild.appendChild(elem)}else this.$eLI[0].firstChild.appendChild(src[i].cloneNode(1))}}this.$eLI.click(function(e){self.click(e,this)});this.bindHover()},click:function(e,a){if(this.enabled&&this.settings.onClick)this.settings.onClick.call(a,e,this)},bindHover:function(){var a=this;this.$eLI.hover(function(){a.hoverIn()},function(){a.hoverOut()})},hoverIn:function(a){this.removeTimer();var i,pms=this.parentMenu.subMenus,pmi=this.parentMenu.menuItems,self=this;if(this.parentMenu.timer)this.parentMenu.removeTimer();if(!this.enabled)return;for(i=0;i<pmi.length;i++){if(pmi[i].active)pmi[i].setInactive()}this.setActive();activeMenu=this.parentMenu;for(i=0;i<pms.length;i++){if(pms[i].visible&&pms[i]!=this.subMenu&&!pms[i].timer)pms[i].addTimer(function(){this.hide()},pms[i].settings.hideDelay)}if(this.subMenu&&!a){this.subMenu.addTimer(function(){this.show()},this.subMenu.settings.showDelay)}},hoverOut:function(){this.removeTimer();if(!this.enabled)return;if(!this.subMenu||!this.subMenu.visible)this.setInactive()},removeTimer:function(){if(this.subMenu){this.subMenu.removeTimer()}},setActive:function(){this.active=true;this.$eLI.addClass('active');var a=this.parentMenu.parentMenuItem;if(a&&!a.active)a.setActive();activeItem=this},setInactive:function(){this.active=false;this.$eLI.removeClass('active');if(this==activeItem)activeItem=null},enable:function(){this.$eLI.removeClass('disabled');this.enabled=true},disable:function(){this.$eLI.addClass('disabled');this.enabled=false},destroy:function(){this.removeTimer();this.$eLI.remove();this.$eLI.unbind('mouseover').unbind('mouseout').unbind('click');if(this.subMenu){this.subMenu.destroy();delete this.subMenu}this.parentMenu.removeItem(this)},addSubMenu:function(b){if(this.subMenu)return;this.subMenu=b;if(this.parentMenu&&$.inArray(b,this.parentMenu.subMenus)==-1)this.parentMenu.subMenus.push(b);if(this.settings.arrowSrc){var a=arrowElement.cloneNode(0);a.setAttribute('src',this.settings.arrowSrc);this.$eLI[0].firstChild.appendChild(a)}}}});$.extend($.fn,{menuFromElement:function(c,d,e){var f=function(a){var b=[],subItems,menuItem,lis,$li,i,subUL,submenu,target,classNames=null;lis=j(a,'LI');for(i=0;i<lis.length;i++){subItems=[];if(!lis[i].childNodes.length){b.push(new $.MenuItem('',c));continue}if((subUL=h(lis[i],'UL'))){subItems=f(subUL);$(subUL).remove()}$li=$(lis[i]);if($li[0].childNodes.length==1&&$li[0].childNodes[0].nodeType==3)target=$li[0].childNodes[0].nodeValue;else target=$li[0].childNodes;if(c&&c.copyClassAttr)classNames=$li.attr('class');menuItem=new $.MenuItem({src:target,addClass:classNames},c);b.push(menuItem);if(subItems.length)new $.Menu(menuItem,subItems,c)}return b};return this.each(function(){var a,m;if(d||(a=h(this,'UL'))){a=d?$(d).clone(true)[0]:a;menuItems=f(a);if(menuItems.length){m=new $.Menu(this,menuItems,c);if(e)e.addMenu(m)}$(a).hide()}})},menuBarFromUL:function(a){return this.each(function(){var i,lis=j(this,'LI');if(lis.length){bar=new $.MenuCollection();for(i=0;i<lis.length;i++)$(lis[i]).menuFromElement(a,null,bar)}})},menu:function(a,b){return this.each(function(){if(b&&b.constructor==Array)new $.Menu(this,b,a);else{if(this.nodeName.toUpperCase()=='UL')$(this).menuBarFromUL(a);else $(this).menuFromElement(a,b)}})}});var h=function(a,b){if(!a)return null;var n=a.firstChild;for(;n;n=n.nextSibling){if(n.nodeType==1&&n.nodeName.toUpperCase()==b)return n}return null};var j=function(a,b){if(!a)return[];var r=[],n=a.firstChild;for(;n;n=n.nextSibling){if(n.nodeType==1&&n.nodeName.toUpperCase()==b)r[r.length]=n}return r}})(jQuery);(function(jQuery){this.version='(beta)(0.0.1)';this.maxSize=10;this.keys=new Array();this.cache_length=0;this.items=new Array();this.setItem=function(pKey,pValue)
{if(typeof(pValue)!='undefined')
{if(typeof(this.items[pKey])=='undefined')
{this.cache_length++;}
this.keys.push(pKey);this.items[pKey]=pValue;if(this.cache_length>this.maxSize)
{this.removeOldestItem();}}
return pValue;}
this.removeItem=function(pKey)
{var tmp;if(typeof(this.items[pKey])!='undefined')
{this.cache_length--;var tmp=this.items[pKey];delete this.items[pKey];}
return tmp;}
this.getItem=function(pKey)
{return this.items[pKey];}
this.hasItem=function(pKey)
{return typeof(this.items[pKey])!='undefined';}
this.removeOldestItem=function()
{this.removeItem(this.keys.shift());}
this.clear=function()
{var tmp=this.cache_length;this.keys=new Array();this.cache_length=0;this.items=new Array();return tmp;}
jQuery.jCache=this;return jQuery;})(jQuery);function jAlert(message){bootbox.alert(message);}
function jConfirm(message,funcion){}
function jPrompt(mensaje,inputText,title,funcion){var result=prompt(mensaje,inputText);if(result)
funcion(result);}(function($,window,document){$.fn.dataTableSettings=[];var _aoSettings=$.fn.dataTableSettings;$.fn.dataTableExt={};var _oExt=$.fn.dataTableExt;_oExt.sVersion="1.7.6";_oExt.sErrMode="alert";_oExt.iApiIndex=0;_oExt.oApi={};_oExt.afnFiltering=[];_oExt.aoFeatures=[];_oExt.ofnSearch={};_oExt.afnSortData=[];_oExt.oStdClasses={"sPagePrevEnabled":"paginate_enabled_previous","sPagePrevDisabled":"paginate_disabled_previous","sPageNextEnabled":"paginate_enabled_next","sPageNextDisabled":"paginate_disabled_next","sPageJUINext":"","sPageJUIPrev":"","sPageButton":"paginate_button","sPageButtonActive":"paginate_active","sPageButtonStaticDisabled":"paginate_button","sPageFirst":"first","sPagePrevious":"previous","sPageNext":"next","sPageLast":"last","sStripOdd":"odd","sStripEven":"even","sRowEmpty":"dataTables_empty","sWrapper":"dataTables_wrapper","sFilter":"dataTables_filter","sInfo":"dataTables_info","sPaging":"dataTables_paginate paging_","sLength":"dataTables_length","sProcessing":"dataTables_processing","sSortAsc":"sorting_asc","sSortDesc":"sorting_desc","sSortable":"sorting","sSortableAsc":"sorting_asc_disabled","sSortableDesc":"sorting_desc_disabled","sSortableNone":"sorting_disabled","sSortColumn":"sorting_","sSortJUIAsc":"","sSortJUIDesc":"","sSortJUI":"","sSortJUIAscAllowed":"","sSortJUIDescAllowed":"","sSortJUIWrapper":"","sScrollWrapper":"dataTables_scroll","sScrollHead":"dataTables_scrollHead","sScrollHeadInner":"dataTables_scrollHeadInner","sScrollBody":"dataTables_scrollBody","sScrollFoot":"dataTables_scrollFoot","sScrollFootInner":"dataTables_scrollFootInner","sFooterTH":""};_oExt.oJUIClasses={"sPagePrevEnabled":"fg-button ui-button ui-state-default ui-corner-left","sPagePrevDisabled":"fg-button ui-button ui-state-default ui-corner-left ui-state-disabled","sPageNextEnabled":"fg-button ui-button ui-state-default ui-corner-right","sPageNextDisabled":"fg-button ui-button ui-state-default ui-corner-right ui-state-disabled","sPageJUINext":"ui-icon ui-icon-circle-arrow-e","sPageJUIPrev":"ui-icon ui-icon-circle-arrow-w","sPageButton":"fg-button ui-button ui-state-default","sPageButtonActive":"fg-button ui-button ui-state-default ui-state-disabled","sPageButtonStaticDisabled":"fg-button ui-button ui-state-default ui-state-disabled","sPageFirst":"first ui-corner-tl ui-corner-bl","sPagePrevious":"previous","sPageNext":"next","sPageLast":"last ui-corner-tr ui-corner-br","sStripOdd":"odd","sStripEven":"even","sRowEmpty":"dataTables_empty","sWrapper":"dataTables_wrapper","sFilter":"dataTables_filter","sInfo":"dataTables_info","sPaging":"dataTables_paginate fg-buttonset ui-buttonset fg-buttonset-multi "+
"ui-buttonset-multi paging_","sLength":"dataTables_length","sProcessing":"dataTables_processing","sSortAsc":"ui-state-default","sSortDesc":"ui-state-default","sSortable":"ui-state-default","sSortableAsc":"ui-state-default","sSortableDesc":"ui-state-default","sSortableNone":"ui-state-default","sSortColumn":"sorting_","sSortJUIAsc":"css_right ui-icon ui-icon-triangle-1-n","sSortJUIDesc":"css_right ui-icon ui-icon-triangle-1-s","sSortJUI":"css_right ui-icon ui-icon-carat-2-n-s","sSortJUIAscAllowed":"css_right ui-icon ui-icon-carat-1-n","sSortJUIDescAllowed":"css_right ui-icon ui-icon-carat-1-s","sSortJUIWrapper":"DataTables_sort_wrapper","sScrollWrapper":"dataTables_scroll","sScrollHead":"dataTables_scrollHead ui-state-default","sScrollHeadInner":"dataTables_scrollHeadInner","sScrollBody":"dataTables_scrollBody","sScrollFoot":"dataTables_scrollFoot ui-state-default","sScrollFootInner":"dataTables_scrollFootInner","sFooterTH":"ui-state-default"};_oExt.oPagination={"two_button":{"fnInit":function(oSettings,nPaging,fnCallbackDraw)
{var nPrevious,nNext,nPreviousInner,nNextInner;if(!oSettings.bJUI)
{nPrevious=document.createElement('div');nNext=document.createElement('div');}
else
{nPrevious=document.createElement('a');nNext=document.createElement('a');nNextInner=document.createElement('span');nNextInner.className=oSettings.oClasses.sPageJUINext;nNext.appendChild(nNextInner);nPreviousInner=document.createElement('span');nPreviousInner.className=oSettings.oClasses.sPageJUIPrev;nPrevious.appendChild(nPreviousInner);}
nPrevious.className=oSettings.oClasses.sPagePrevDisabled;nNext.className=oSettings.oClasses.sPageNextDisabled;nPrevious.title=oSettings.oLanguage.oPaginate.sPrevious;nNext.title=oSettings.oLanguage.oPaginate.sNext;nPaging.appendChild(nPrevious);nPaging.appendChild(nNext);$(nPrevious).bind('click.DT',function(){if(oSettings.oApi._fnPageChange(oSettings,"previous"))
{fnCallbackDraw(oSettings);}});$(nNext).bind('click.DT',function(){if(oSettings.oApi._fnPageChange(oSettings,"next"))
{fnCallbackDraw(oSettings);}});$(nPrevious).bind('selectstart.DT',function(){return false;});$(nNext).bind('selectstart.DT',function(){return false;});if(oSettings.sTableId!==''&&typeof oSettings.aanFeatures.p=="undefined")
{nPaging.setAttribute('id',oSettings.sTableId+'_paginate');nPrevious.setAttribute('id',oSettings.sTableId+'_previous');nNext.setAttribute('id',oSettings.sTableId+'_next');}},"fnUpdate":function(oSettings,fnCallbackDraw)
{if(!oSettings.aanFeatures.p)
{return;}
var an=oSettings.aanFeatures.p;for(var i=0,iLen=an.length;i<iLen;i++)
{if(an[i].childNodes.length!==0)
{an[i].childNodes[0].className=(oSettings._iDisplayStart===0)?oSettings.oClasses.sPagePrevDisabled:oSettings.oClasses.sPagePrevEnabled;an[i].childNodes[1].className=(oSettings.fnDisplayEnd()==oSettings.fnRecordsDisplay())?oSettings.oClasses.sPageNextDisabled:oSettings.oClasses.sPageNextEnabled;}}}},"iFullNumbersShowPages":5,"full_numbers":{"fnInit":function(oSettings,nPaging,fnCallbackDraw)
{var nFirst=document.createElement('span');var nPrevious=document.createElement('span');var nList=document.createElement('span');var nNext=document.createElement('span');var nLast=document.createElement('span');nFirst.innerHTML=oSettings.oLanguage.oPaginate.sFirst;nPrevious.innerHTML=oSettings.oLanguage.oPaginate.sPrevious;nNext.innerHTML=oSettings.oLanguage.oPaginate.sNext;nLast.innerHTML=oSettings.oLanguage.oPaginate.sLast;var oClasses=oSettings.oClasses;nFirst.className=oClasses.sPageButton+" "+oClasses.sPageFirst;nPrevious.className=oClasses.sPageButton+" "+oClasses.sPagePrevious;nNext.className=oClasses.sPageButton+" "+oClasses.sPageNext;nLast.className=oClasses.sPageButton+" "+oClasses.sPageLast;nPaging.appendChild(nFirst);nPaging.appendChild(nPrevious);nPaging.appendChild(nList);nPaging.appendChild(nNext);nPaging.appendChild(nLast);$(nFirst).bind('click.DT',function(){if(oSettings.oApi._fnPageChange(oSettings,"first"))
{fnCallbackDraw(oSettings);}});$(nPrevious).bind('click.DT',function(){if(oSettings.oApi._fnPageChange(oSettings,"previous"))
{fnCallbackDraw(oSettings);}});$(nNext).bind('click.DT',function(){if(oSettings.oApi._fnPageChange(oSettings,"next"))
{fnCallbackDraw(oSettings);}});$(nLast).bind('click.DT',function(){if(oSettings.oApi._fnPageChange(oSettings,"last"))
{fnCallbackDraw(oSettings);}});$('span',nPaging)
.bind('mousedown.DT',function(){return false;})
.bind('selectstart.DT',function(){return false;});if(oSettings.sTableId!==''&&typeof oSettings.aanFeatures.p=="undefined")
{nPaging.setAttribute('id',oSettings.sTableId+'_paginate');nFirst.setAttribute('id',oSettings.sTableId+'_first');nPrevious.setAttribute('id',oSettings.sTableId+'_previous');nNext.setAttribute('id',oSettings.sTableId+'_next');nLast.setAttribute('id',oSettings.sTableId+'_last');}},"fnUpdate":function(oSettings,fnCallbackDraw)
{if(!oSettings.aanFeatures.p)
{return;}
var iPageCount=_oExt.oPagination.iFullNumbersShowPages;var iPageCountHalf=Math.floor(iPageCount/2);var iPages=Math.ceil((oSettings.fnRecordsDisplay())/oSettings._iDisplayLength);var iCurrentPage=Math.ceil(oSettings._iDisplayStart/oSettings._iDisplayLength)+1;var sList="";var iStartButton,iEndButton,i,iLen;var oClasses=oSettings.oClasses;if(iPages<iPageCount)
{iStartButton=1;iEndButton=iPages;}
else
{if(iCurrentPage<=iPageCountHalf)
{iStartButton=1;iEndButton=iPageCount;}
else
{if(iCurrentPage>=(iPages-iPageCountHalf))
{iStartButton=iPages-iPageCount+1;iEndButton=iPages;}
else
{iStartButton=iCurrentPage-Math.ceil(iPageCount/2)+1;iEndButton=iStartButton+iPageCount-1;}}}
for(i=iStartButton;i<=iEndButton;i++)
{if(iCurrentPage!=i)
{sList+='<span class="'+oClasses.sPageButton+'">'+i+'</span>';}
else
{sList+='<span class="'+oClasses.sPageButtonActive+'">'+i+'</span>';}}
var an=oSettings.aanFeatures.p;var anButtons,anStatic,nPaginateList;var fnClick=function(){var iTarget=(this.innerHTML*1)-1;oSettings._iDisplayStart=iTarget*oSettings._iDisplayLength;fnCallbackDraw(oSettings);return false;};var fnFalse=function(){return false;};for(i=0,iLen=an.length;i<iLen;i++)
{if(an[i].childNodes.length===0)
{continue;}
var qjPaginateList=$('span:eq(2)',an[i]);qjPaginateList.html(sList);$('span',qjPaginateList).bind('click.DT',fnClick).bind('mousedown.DT',fnFalse)
.bind('selectstart.DT',fnFalse);anButtons=an[i].getElementsByTagName('span');anStatic=[anButtons[0],anButtons[1],anButtons[anButtons.length-2],anButtons[anButtons.length-1]];$(anStatic).removeClass(oClasses.sPageButton+" "+oClasses.sPageButtonActive+" "+oClasses.sPageButtonStaticDisabled);if(iCurrentPage==1)
{anStatic[0].className+=" "+oClasses.sPageButtonStaticDisabled;anStatic[1].className+=" "+oClasses.sPageButtonStaticDisabled;}
else
{anStatic[0].className+=" "+oClasses.sPageButton;anStatic[1].className+=" "+oClasses.sPageButton;}
if(iPages===0||iCurrentPage==iPages||oSettings._iDisplayLength==-1)
{anStatic[2].className+=" "+oClasses.sPageButtonStaticDisabled;anStatic[3].className+=" "+oClasses.sPageButtonStaticDisabled;}
else
{anStatic[2].className+=" "+oClasses.sPageButton;anStatic[3].className+=" "+oClasses.sPageButton;}}}}};_oExt.oSort={"string-asc":function(a,b)
{var x=a.toLowerCase();var y=b.toLowerCase();return((x<y)?-1:((x>y)?1:0));},"string-desc":function(a,b)
{var x=a.toLowerCase();var y=b.toLowerCase();return((x<y)?1:((x>y)?-1:0));},"html-asc":function(a,b)
{var x=a.replace(/<.*?>/g,"").toLowerCase();var y=b.replace(/<.*?>/g,"").toLowerCase();return((x<y)?-1:((x>y)?1:0));},"html-desc":function(a,b)
{var x=a.replace(/<.*?>/g,"").toLowerCase();var y=b.replace(/<.*?>/g,"").toLowerCase();return((x<y)?1:((x>y)?-1:0));},"date-asc":function(a,b)
{var x=Date.parse(a);var y=Date.parse(b);if(isNaN(x)||x==="")
{x=Date.parse("01/01/1970 00:00:00");}
if(isNaN(y)||y==="")
{y=Date.parse("01/01/1970 00:00:00");}
return x-y;},"date-desc":function(a,b)
{var x=Date.parse(a);var y=Date.parse(b);if(isNaN(x)||x==="")
{x=Date.parse("01/01/1970 00:00:00");}
if(isNaN(y)||y==="")
{y=Date.parse("01/01/1970 00:00:00");}
return y-x;},"numeric-asc":function(a,b)
{var x=(a=="-"||a==="")?0:a*1;var y=(b=="-"||b==="")?0:b*1;return x-y;},"numeric-desc":function(a,b)
{var x=(a=="-"||a==="")?0:a*1;var y=(b=="-"||b==="")?0:b*1;return y-x;}};_oExt.aTypes=[function(sData)
{if(sData.length===0)
{return'numeric';}
var sValidFirstChars="0123456789-";var sValidChars="0123456789.";var Char;var bDecimal=false;Char=sData.charAt(0);if(sValidFirstChars.indexOf(Char)==-1)
{return null;}
for(var i=1;i<sData.length;i++)
{Char=sData.charAt(i);if(sValidChars.indexOf(Char)==-1)
{return null;}
if(Char==".")
{if(bDecimal)
{return null;}
bDecimal=true;}}
return'numeric';},function(sData)
{var iParse=Date.parse(sData);if((iParse!==null&&!isNaN(iParse))||sData.length===0)
{return'date';}
return null;},function(sData)
{if(sData.indexOf('<')!=-1&&sData.indexOf('>')!=-1)
{return'html';}
return null;}];_oExt.fnVersionCheck=function(sVersion)
{var fnZPad=function(Zpad,count)
{while(Zpad.length<count){Zpad+='0';}
return Zpad;};var aThis=_oExt.sVersion.split('.');var aThat=sVersion.split('.');var sThis='',sThat='';for(var i=0,iLen=aThat.length;i<iLen;i++)
{sThis+=fnZPad(aThis[i],3);sThat+=fnZPad(aThat[i],3);}
return parseInt(sThis,10)>=parseInt(sThat,10);};_oExt._oExternConfig={"iNextUnique":0};$.fn.dataTable=function(oInit)
{function classSettings()
{this.fnRecordsTotal=function()
{if(this.oFeatures.bServerSide){return parseInt(this._iRecordsTotal,10);}else{return this.aiDisplayMaster.length;}};this.fnRecordsDisplay=function()
{if(this.oFeatures.bServerSide){return parseInt(this._iRecordsDisplay,10);}else{return this.aiDisplay.length;}};this.fnDisplayEnd=function()
{if(this.oFeatures.bServerSide){if(this.oFeatures.bPaginate===false||this._iDisplayLength==-1){return this._iDisplayStart+this.aiDisplay.length;}else{return Math.min(this._iDisplayStart+this._iDisplayLength,this._iRecordsDisplay);}}else{return this._iDisplayEnd;}};this.oInstance=null;this.sInstance=null;this.oFeatures={"bPaginate":true,"bLengthChange":true,"bFilter":true,"bSort":true,"bInfo":true,"bAutoWidth":true,"bProcessing":false,"bSortClasses":true,"bStateSave":false,"bServerSide":false};this.oScroll={"sX":"","sXInner":"","sY":"","bCollapse":false,"bInfinite":false,"iLoadGap":100,"iBarWidth":0,"bAutoCss":true};this.aanFeatures=[];this.oLanguage={"sProcessing":"Processing...","sLengthMenu":"Show _MENU_ entries","sZeroRecords":"No matching records found","sEmptyTable":"No data available in table","sInfo":"Showing _START_ to _END_ of _TOTAL_ entries","sInfoEmpty":"Showing 0 to 0 of 0 entries","sInfoFiltered":"(filtered from _MAX_ total entries)","sInfoPostFix":"","sSearch":"Search:","sUrl":"","oPaginate":{"sFirst":"First","sPrevious":"Previous","sNext":"Next","sLast":"Last"},"fnInfoCallback":null};this.aoData=[];this.aiDisplay=[];this.aiDisplayMaster=[];this.aoColumns=[];this.iNextId=0;this.asDataSearch=[];this.oPreviousSearch={"sSearch":"","bRegex":false,"bSmart":true};this.aoPreSearchCols=[];this.aaSorting=[[0,'asc',0]];this.aaSortingFixed=null;this.asStripClasses=[];this.asDestoryStrips=[];this.sDestroyWidth=0;this.fnRowCallback=null;this.fnHeaderCallback=null;this.fnFooterCallback=null;this.aoDrawCallback=[];this.fnInitComplete=null;this.sTableId="";this.nTable=null;this.nTHead=null;this.nTFoot=null;this.nTBody=null;this.nTableWrapper=null;this.bInitialised=false;this.aoOpenRows=[];this.sDom='lfrtip';this.sPaginationType="two_button";this.iCookieDuration=60*60*2;this.sCookiePrefix="SpryMedia_DataTables_";this.fnCookieCallback=null;this.aoStateSave=[];this.aoStateLoad=[];this.oLoadedState=null;this.sAjaxSource=null;this.bAjaxDataGet=true;this.fnServerData=function(url,data,callback){$.ajax({"url":url,"data":data,"success":callback,"dataType":"json","cache":false,"error":function(xhr,error,thrown){if(error=="parsererror"){alert("DataTables warning: JSON data from server could not be parsed. "+
"This is caused by a JSON formatting error.");}}});};this.fnFormatNumber=function(iIn)
{if(iIn<1000)
{return iIn;}
else
{var s=(iIn+""),a=s.split(""),out="",iLen=s.length;for(var i=0;i<iLen;i++)
{if(i%3===0&&i!==0)
{out=','+out;}
out=a[iLen-i-1]+out;}}
return out;};this.aLengthMenu=[10,25,50,100];this.iDraw=0;this.bDrawing=0;this.iDrawError=-1;this._iDisplayLength=10;this._iDisplayStart=0;this._iDisplayEnd=10;this._iRecordsTotal=0;this._iRecordsDisplay=0;this.bJUI=false;this.oClasses=_oExt.oStdClasses;this.bFiltered=false;this.bSorted=false;this.oInit=null;}
this.oApi={};this.fnDraw=function(bComplete)
{var oSettings=_fnSettingsFromNode(this[_oExt.iApiIndex]);if(typeof bComplete!='undefined'&&bComplete===false)
{_fnCalculateEnd(oSettings);_fnDraw(oSettings);}
else
{_fnReDraw(oSettings);}};this.fnFilter=function(sInput,iColumn,bRegex,bSmart,bShowGlobal)
{var oSettings=_fnSettingsFromNode(this[_oExt.iApiIndex]);if(!oSettings.oFeatures.bFilter)
{return;}
if(typeof bRegex=='undefined')
{bRegex=false;}
if(typeof bSmart=='undefined')
{bSmart=true;}
if(typeof bShowGlobal=='undefined')
{bShowGlobal=true;}
if(typeof iColumn=="undefined"||iColumn===null)
{_fnFilterComplete(oSettings,{"sSearch":sInput,"bRegex":bRegex,"bSmart":bSmart},1);if(bShowGlobal&&typeof oSettings.aanFeatures.f!='undefined')
{var n=oSettings.aanFeatures.f;for(var i=0,iLen=n.length;i<iLen;i++)
{$('input',n[i]).val(sInput);}}}
else
{oSettings.aoPreSearchCols[iColumn].sSearch=sInput;oSettings.aoPreSearchCols[iColumn].bRegex=bRegex;oSettings.aoPreSearchCols[iColumn].bSmart=bSmart;_fnFilterComplete(oSettings,oSettings.oPreviousSearch,1);}};this.fnSettings=function(nNode)
{return _fnSettingsFromNode(this[_oExt.iApiIndex]);};this.fnVersionCheck=_oExt.fnVersionCheck;this.fnSort=function(aaSort)
{var oSettings=_fnSettingsFromNode(this[_oExt.iApiIndex]);oSettings.aaSorting=aaSort;_fnSort(oSettings);};this.fnSortListener=function(nNode,iColumn,fnCallback)
{_fnSortAttachListener(_fnSettingsFromNode(this[_oExt.iApiIndex]),nNode,iColumn,fnCallback);};this.fnAddData=function(mData,bRedraw)
{if(mData.length===0)
{return[];}
var aiReturn=[];var iTest;var oSettings=_fnSettingsFromNode(this[_oExt.iApiIndex]);if(typeof mData[0]=="object")
{for(var i=0;i<mData.length;i++)
{iTest=_fnAddData(oSettings,mData[i]);if(iTest==-1)
{return aiReturn;}
aiReturn.push(iTest);}}
else
{iTest=_fnAddData(oSettings,mData);if(iTest==-1)
{return aiReturn;}
aiReturn.push(iTest);}
oSettings.aiDisplay=oSettings.aiDisplayMaster.slice();if(typeof bRedraw=='undefined'||bRedraw)
{_fnReDraw(oSettings);}
return aiReturn;};this.fnDeleteRow=function(mTarget,fnCallBack,bRedraw)
{var oSettings=_fnSettingsFromNode(this[_oExt.iApiIndex]);var i,iAODataIndex;iAODataIndex=(typeof mTarget=='object')?_fnNodeToDataIndex(oSettings,mTarget):mTarget;var oData=oSettings.aoData.splice(iAODataIndex,1);var iDisplayIndex=$.inArray(iAODataIndex,oSettings.aiDisplay);oSettings.asDataSearch.splice(iDisplayIndex,1);_fnDeleteIndex(oSettings.aiDisplayMaster,iAODataIndex);_fnDeleteIndex(oSettings.aiDisplay,iAODataIndex);if(typeof fnCallBack=="function")
{fnCallBack.call(this,oSettings,oData);}
if(oSettings._iDisplayStart>=oSettings.aiDisplay.length)
{oSettings._iDisplayStart-=oSettings._iDisplayLength;if(oSettings._iDisplayStart<0)
{oSettings._iDisplayStart=0;}}
if(typeof bRedraw=='undefined'||bRedraw)
{_fnCalculateEnd(oSettings);_fnDraw(oSettings);}
return oData;};this.fnClearTable=function(bRedraw)
{var oSettings=_fnSettingsFromNode(this[_oExt.iApiIndex]);_fnClearTable(oSettings);if(typeof bRedraw=='undefined'||bRedraw)
{_fnDraw(oSettings);}};this.fnOpen=function(nTr,sHtml,sClass)
{var oSettings=_fnSettingsFromNode(this[_oExt.iApiIndex]);this.fnClose(nTr);var nNewRow=document.createElement("tr");var nNewCell=document.createElement("td");nNewRow.appendChild(nNewCell);nNewCell.className=sClass;nNewCell.colSpan=_fnVisbleColumns(oSettings);nNewCell.innerHTML=sHtml;var nTrs=$('tr',oSettings.nTBody);if($.inArray(nTr,nTrs)!=-1)
{$(nNewRow).insertAfter(nTr);}
oSettings.aoOpenRows.push({"nTr":nNewRow,"nParent":nTr});return nNewRow;};this.fnClose=function(nTr)
{var oSettings=_fnSettingsFromNode(this[_oExt.iApiIndex]);for(var i=0;i<oSettings.aoOpenRows.length;i++)
{if(oSettings.aoOpenRows[i].nParent==nTr)
{var nTrParent=oSettings.aoOpenRows[i].nTr.parentNode;if(nTrParent)
{nTrParent.removeChild(oSettings.aoOpenRows[i].nTr);}
oSettings.aoOpenRows.splice(i,1);return 0;}}
return 1;};this.fnGetData=function(mRow)
{var oSettings=_fnSettingsFromNode(this[_oExt.iApiIndex]);if(typeof mRow!='undefined')
{var iRow=(typeof mRow=='object')?_fnNodeToDataIndex(oSettings,mRow):mRow;return((aRowData=oSettings.aoData[iRow])?aRowData._aData:null);}
return _fnGetDataMaster(oSettings);};this.fnGetNodes=function(iRow)
{var oSettings=_fnSettingsFromNode(this[_oExt.iApiIndex]);if(typeof iRow!='undefined')
{return((aRowData=oSettings.aoData[iRow])?aRowData.nTr:null);}
return _fnGetTrNodes(oSettings);};this.fnGetPosition=function(nNode)
{var oSettings=_fnSettingsFromNode(this[_oExt.iApiIndex]);var i;if(nNode.nodeName.toUpperCase()=="TR")
{return _fnNodeToDataIndex(oSettings,nNode);}
else if(nNode.nodeName.toUpperCase()=="TD")
{var iDataIndex=_fnNodeToDataIndex(oSettings,nNode.parentNode);var iCorrector=0;for(var j=0;j<oSettings.aoColumns.length;j++)
{if(oSettings.aoColumns[j].bVisible)
{if(oSettings.aoData[iDataIndex].nTr.getElementsByTagName('td')[j-iCorrector]==nNode)
{return[iDataIndex,j-iCorrector,j];}}
else
{iCorrector++;}}}
return null;};this.fnUpdate=function(mData,mRow,iColumn,bRedraw,bAction)
{var oSettings=_fnSettingsFromNode(this[_oExt.iApiIndex]);var iVisibleColumn;var sDisplay;var iRow=(typeof mRow=='object')?_fnNodeToDataIndex(oSettings,mRow):mRow;if(typeof mData!='object')
{sDisplay=mData;oSettings.aoData[iRow]._aData[iColumn]=sDisplay;if(oSettings.aoColumns[iColumn].fnRender!==null)
{sDisplay=oSettings.aoColumns[iColumn].fnRender({"iDataRow":iRow,"iDataColumn":iColumn,"aData":oSettings.aoData[iRow]._aData,"oSettings":oSettings});if(oSettings.aoColumns[iColumn].bUseRendered)
{oSettings.aoData[iRow]._aData[iColumn]=sDisplay;}}
iVisibleColumn=_fnColumnIndexToVisible(oSettings,iColumn);if(iVisibleColumn!==null)
{oSettings.aoData[iRow].nTr.getElementsByTagName('td')[iVisibleColumn].innerHTML=sDisplay;}
else
{oSettings.aoData[iRow]._anHidden[iColumn].innerHTML=sDisplay;}}
else
{if(mData.length!=oSettings.aoColumns.length)
{_fnLog(oSettings,0,'An array passed to fnUpdate must have the same number of '+
'columns as the table in question - in this case '+oSettings.aoColumns.length);return 1;}
for(var i=0;i<mData.length;i++)
{sDisplay=mData[i];oSettings.aoData[iRow]._aData[i]=sDisplay;if(oSettings.aoColumns[i].fnRender!==null)
{sDisplay=oSettings.aoColumns[i].fnRender({"iDataRow":iRow,"iDataColumn":i,"aData":oSettings.aoData[iRow]._aData,"oSettings":oSettings});if(oSettings.aoColumns[i].bUseRendered)
{oSettings.aoData[iRow]._aData[i]=sDisplay;}}
iVisibleColumn=_fnColumnIndexToVisible(oSettings,i);if(iVisibleColumn!==null)
{oSettings.aoData[iRow].nTr.getElementsByTagName('td')[iVisibleColumn].innerHTML=sDisplay;}
else
{oSettings.aoData[iRow]._anHidden[i].innerHTML=sDisplay;}}}
var iDisplayIndex=$.inArray(iRow,oSettings.aiDisplay);oSettings.asDataSearch[iDisplayIndex]=_fnBuildSearchRow(oSettings,oSettings.aoData[iRow]._aData);if(typeof bAction=='undefined'||bAction)
{_fnAjustColumnSizing(oSettings);}
if(typeof bRedraw=='undefined'||bRedraw)
{_fnReDraw(oSettings);}
return 0;};this.fnSetColumnVis=function(iCol,bShow,bRedraw)
{var oSettings=_fnSettingsFromNode(this[_oExt.iApiIndex]);var i,iLen;var iColumns=oSettings.aoColumns.length;var nTd,anTds,nCell,anTrs,jqChildren;if(oSettings.aoColumns[iCol].bVisible==bShow)
{return;}
var nTrHead=$('>tr',oSettings.nTHead)[0];var nTrFoot=$('>tr',oSettings.nTFoot)[0];var anTheadTh=[];var anTfootTh=[];for(i=0;i<iColumns;i++)
{anTheadTh.push(oSettings.aoColumns[i].nTh);anTfootTh.push(oSettings.aoColumns[i].nTf);}
if(bShow)
{var iInsert=0;for(i=0;i<iCol;i++)
{if(oSettings.aoColumns[i].bVisible)
{iInsert++;}}
if(iInsert>=_fnVisbleColumns(oSettings))
{nTrHead.appendChild(anTheadTh[iCol]);anTrs=$('>tr',oSettings.nTHead);for(i=1,iLen=anTrs.length;i<iLen;i++)
{anTrs[i].appendChild(oSettings.aoColumns[iCol].anThExtra[i-1]);}
if(nTrFoot)
{nTrFoot.appendChild(anTfootTh[iCol]);anTrs=$('>tr',oSettings.nTFoot);for(i=1,iLen=anTrs.length;i<iLen;i++)
{anTrs[i].appendChild(oSettings.aoColumns[iCol].anTfExtra[i-1]);}}
for(i=0,iLen=oSettings.aoData.length;i<iLen;i++)
{nTd=oSettings.aoData[i]._anHidden[iCol];oSettings.aoData[i].nTr.appendChild(nTd);}}
else
{var iBefore;for(i=iCol;i<iColumns;i++)
{iBefore=_fnColumnIndexToVisible(oSettings,i);if(iBefore!==null)
{break;}}
nTrHead.insertBefore(anTheadTh[iCol],nTrHead.getElementsByTagName('th')[iBefore]);anTrs=$('>tr',oSettings.nTHead);for(i=1,iLen=anTrs.length;i<iLen;i++)
{jqChildren=$(anTrs[i]).children();anTrs[i].insertBefore(oSettings.aoColumns[iCol].anThExtra[i-1],jqChildren[iBefore]);}
if(nTrFoot)
{nTrFoot.insertBefore(anTfootTh[iCol],nTrFoot.getElementsByTagName('th')[iBefore]);anTrs=$('>tr',oSettings.nTFoot);for(i=1,iLen=anTrs.length;i<iLen;i++)
{jqChildren=$(anTrs[i]).children();anTrs[i].insertBefore(oSettings.aoColumns[iCol].anTfExtra[i-1],jqChildren[iBefore]);}}
anTds=_fnGetTdNodes(oSettings);for(i=0,iLen=oSettings.aoData.length;i<iLen;i++)
{nTd=oSettings.aoData[i]._anHidden[iCol];oSettings.aoData[i].nTr.insertBefore(nTd,$('>td:eq('+iBefore+')',oSettings.aoData[i].nTr)[0]);}}
oSettings.aoColumns[iCol].bVisible=true;}
else
{nTrHead.removeChild(anTheadTh[iCol]);for(i=0,iLen=oSettings.aoColumns[iCol].anThExtra.length;i<iLen;i++)
{nCell=oSettings.aoColumns[iCol].anThExtra[i];nCell.parentNode.removeChild(nCell);}
if(nTrFoot)
{nTrFoot.removeChild(anTfootTh[iCol]);for(i=0,iLen=oSettings.aoColumns[iCol].anTfExtra.length;i<iLen;i++)
{nCell=oSettings.aoColumns[iCol].anTfExtra[i];nCell.parentNode.removeChild(nCell);}}
anTds=_fnGetTdNodes(oSettings);for(i=0,iLen=oSettings.aoData.length;i<iLen;i++)
{nTd=anTds[(i*oSettings.aoColumns.length)+(iCol*1)];oSettings.aoData[i]._anHidden[iCol]=nTd;nTd.parentNode.removeChild(nTd);}
oSettings.aoColumns[iCol].bVisible=false;}
for(i=0,iLen=oSettings.aoOpenRows.length;i<iLen;i++)
{oSettings.aoOpenRows[i].nTr.colSpan=_fnVisbleColumns(oSettings);}
if(typeof bRedraw=='undefined'||bRedraw)
{_fnAjustColumnSizing(oSettings);_fnDraw(oSettings);}
_fnSaveState(oSettings);};this.fnPageChange=function(sAction,bRedraw)
{var oSettings=_fnSettingsFromNode(this[_oExt.iApiIndex]);_fnPageChange(oSettings,sAction);_fnCalculateEnd(oSettings);if(typeof bRedraw=='undefined'||bRedraw)
{_fnDraw(oSettings);}};this.fnDestroy=function()
{var oSettings=_fnSettingsFromNode(this[_oExt.iApiIndex]);var nOrig=oSettings.nTableWrapper.parentNode;var nBody=oSettings.nTBody;var i,iLen;oSettings.bDestroying=true;$(oSettings.nTableWrapper).find('*').andSelf().unbind('.DT');for(i=0,iLen=oSettings.aoColumns.length;i<iLen;i++)
{if(oSettings.aoColumns[i].bVisible===false)
{this.fnSetColumnVis(i,true);}}
$('tbody>tr>td.'+oSettings.oClasses.sRowEmpty,oSettings.nTable).parent().remove();if(oSettings.nTable!=oSettings.nTHead.parentNode)
{$('>thead',oSettings.nTable).remove();oSettings.nTable.appendChild(oSettings.nTHead);}
if(oSettings.nTFoot&&oSettings.nTable!=oSettings.nTFoot.parentNode)
{$('>tfoot',oSettings.nTable).remove();oSettings.nTable.appendChild(oSettings.nTFoot);}
oSettings.nTable.parentNode.removeChild(oSettings.nTable);$(oSettings.nTableWrapper).remove();oSettings.aaSorting=[];oSettings.aaSortingFixed=[];_fnSortingClasses(oSettings);$(_fnGetTrNodes(oSettings)).removeClass(oSettings.asStripClasses.join(' '));if(!oSettings.bJUI)
{$('th',oSettings.nTHead).removeClass([_oExt.oStdClasses.sSortable,_oExt.oStdClasses.sSortableAsc,_oExt.oStdClasses.sSortableDesc,_oExt.oStdClasses.sSortableNone].join(' '));}
else
{$('th',oSettings.nTHead).removeClass([_oExt.oStdClasses.sSortable,_oExt.oJUIClasses.sSortableAsc,_oExt.oJUIClasses.sSortableDesc,_oExt.oJUIClasses.sSortableNone].join(' '));$('th span',oSettings.nTHead).remove();}
nOrig.appendChild(oSettings.nTable);for(i=0,iLen=oSettings.aoData.length;i<iLen;i++)
{nBody.appendChild(oSettings.aoData[i].nTr);}
oSettings.nTable.style.width=_fnStringToCss(oSettings.sDestroyWidth);$('>tr:even',nBody).addClass(oSettings.asDestoryStrips[0]);$('>tr:odd',nBody).addClass(oSettings.asDestoryStrips[1]);for(i=0,iLen=_aoSettings.length;i<iLen;i++)
{if(_aoSettings[i]==oSettings)
{_aoSettings.splice(i,1);}}
oSettings=null;};this.fnAdjustColumnSizing=function(bRedraw)
{var oSettings=_fnSettingsFromNode(this[_oExt.iApiIndex]);_fnAjustColumnSizing(oSettings);if(typeof bRedraw=='undefined'||bRedraw)
{this.fnDraw(false);}
else if(oSettings.oScroll.sX!==""||oSettings.oScroll.sY!=="")
{this.oApi._fnScrollDraw(oSettings);}};function _fnExternApiFunc(sFunc)
{return function(){var aArgs=[_fnSettingsFromNode(this[_oExt.iApiIndex])].concat(Array.prototype.slice.call(arguments));return _oExt.oApi[sFunc].apply(this,aArgs);};}
for(var sFunc in _oExt.oApi)
{if(sFunc)
{this[sFunc]=_fnExternApiFunc(sFunc);}}
function _fnInitalise(oSettings)
{var i,iLen;if(oSettings.bInitialised===false)
{setTimeout(function(){_fnInitalise(oSettings);},200);return;}
_fnAddOptionsHtml(oSettings);_fnDrawHead(oSettings);_fnProcessingDisplay(oSettings,true);if(oSettings.oFeatures.bAutoWidth)
{_fnCalculateColumnWidths(oSettings);}
for(i=0,iLen=oSettings.aoColumns.length;i<iLen;i++)
{if(oSettings.aoColumns[i].sWidth!==null)
{oSettings.aoColumns[i].nTh.style.width=_fnStringToCss(oSettings.aoColumns[i].sWidth);}}
if(oSettings.oFeatures.bSort)
{_fnSort(oSettings);}
else
{oSettings.aiDisplay=oSettings.aiDisplayMaster.slice();_fnCalculateEnd(oSettings);_fnDraw(oSettings);}
if(oSettings.sAjaxSource!==null&&!oSettings.oFeatures.bServerSide)
{oSettings.fnServerData.call(oSettings.oInstance,oSettings.sAjaxSource,[],function(json){for(i=0;i<json.aaData.length;i++)
{_fnAddData(oSettings,json.aaData[i]);}
oSettings.iInitDisplayStart=oSettings._iDisplayStart;if(oSettings.oFeatures.bSort)
{_fnSort(oSettings);}
else
{oSettings.aiDisplay=oSettings.aiDisplayMaster.slice();_fnCalculateEnd(oSettings);_fnDraw(oSettings);}
_fnProcessingDisplay(oSettings,false);_fnInitComplete(oSettings,json);});return;}
if(!oSettings.oFeatures.bServerSide)
{_fnProcessingDisplay(oSettings,false);_fnInitComplete(oSettings);}}
function _fnInitComplete(oSettings,json)
{oSettings._bInitComplete=true;if(typeof oSettings.fnInitComplete=='function')
{if(typeof json!='undefined')
{oSettings.fnInitComplete.call(oSettings.oInstance,oSettings,json);}
else
{oSettings.fnInitComplete.call(oSettings.oInstance,oSettings);}}}
function _fnLanguageProcess(oSettings,oLanguage,bInit)
{_fnMap(oSettings.oLanguage,oLanguage,'sProcessing');_fnMap(oSettings.oLanguage,oLanguage,'sLengthMenu');_fnMap(oSettings.oLanguage,oLanguage,'sEmptyTable');_fnMap(oSettings.oLanguage,oLanguage,'sZeroRecords');_fnMap(oSettings.oLanguage,oLanguage,'sInfo');_fnMap(oSettings.oLanguage,oLanguage,'sInfoEmpty');_fnMap(oSettings.oLanguage,oLanguage,'sInfoFiltered');_fnMap(oSettings.oLanguage,oLanguage,'sInfoPostFix');_fnMap(oSettings.oLanguage,oLanguage,'sSearch');if(typeof oLanguage.oPaginate!='undefined')
{_fnMap(oSettings.oLanguage.oPaginate,oLanguage.oPaginate,'sFirst');_fnMap(oSettings.oLanguage.oPaginate,oLanguage.oPaginate,'sPrevious');_fnMap(oSettings.oLanguage.oPaginate,oLanguage.oPaginate,'sNext');_fnMap(oSettings.oLanguage.oPaginate,oLanguage.oPaginate,'sLast');}
if(typeof oLanguage.sEmptyTable=='undefined'&&typeof oLanguage.sZeroRecords!='undefined')
{_fnMap(oSettings.oLanguage,oLanguage,'sZeroRecords','sEmptyTable');}
if(bInit)
{_fnInitalise(oSettings);}}
function _fnAddColumn(oSettings,nTh)
{oSettings.aoColumns[oSettings.aoColumns.length++]={"sType":null,"_bAutoType":true,"bVisible":true,"bSearchable":true,"bSortable":true,"asSorting":['asc','desc'],"sSortingClass":oSettings.oClasses.sSortable,"sSortingClassJUI":oSettings.oClasses.sSortJUI,"sTitle":nTh?nTh.innerHTML:'',"sName":'',"sWidth":null,"sWidthOrig":null,"sClass":null,"fnRender":null,"bUseRendered":true,"iDataSort":oSettings.aoColumns.length-1,"sSortDataType":'std',"nTh":nTh?nTh:document.createElement('th'),"nTf":null,"anThExtra":[],"anTfExtra":[]};var iCol=oSettings.aoColumns.length-1;var oCol=oSettings.aoColumns[iCol];if(typeof oSettings.aoPreSearchCols[iCol]=='undefined'||oSettings.aoPreSearchCols[iCol]===null)
{oSettings.aoPreSearchCols[iCol]={"sSearch":"","bRegex":false,"bSmart":true};}
else
{if(typeof oSettings.aoPreSearchCols[iCol].bRegex=='undefined')
{oSettings.aoPreSearchCols[iCol].bRegex=true;}
if(typeof oSettings.aoPreSearchCols[iCol].bSmart=='undefined')
{oSettings.aoPreSearchCols[iCol].bSmart=true;}}
_fnColumnOptions(oSettings,iCol,null);}
function _fnColumnOptions(oSettings,iCol,oOptions)
{var oCol=oSettings.aoColumns[iCol];if(typeof oOptions!='undefined'&&oOptions!==null)
{if(typeof oOptions.sType!='undefined')
{oCol.sType=oOptions.sType;oCol._bAutoType=false;}
_fnMap(oCol,oOptions,"bVisible");_fnMap(oCol,oOptions,"bSearchable");_fnMap(oCol,oOptions,"bSortable");_fnMap(oCol,oOptions,"sTitle");_fnMap(oCol,oOptions,"sName");_fnMap(oCol,oOptions,"sWidth");_fnMap(oCol,oOptions,"sWidth","sWidthOrig");_fnMap(oCol,oOptions,"sClass");_fnMap(oCol,oOptions,"fnRender");_fnMap(oCol,oOptions,"bUseRendered");_fnMap(oCol,oOptions,"iDataSort");_fnMap(oCol,oOptions,"asSorting");_fnMap(oCol,oOptions,"sSortDataType");}
if(!oSettings.oFeatures.bSort)
{oCol.bSortable=false;}
if(!oCol.bSortable||($.inArray('asc',oCol.asSorting)==-1&&$.inArray('desc',oCol.asSorting)==-1))
{oCol.sSortingClass=oSettings.oClasses.sSortableNone;oCol.sSortingClassJUI="";}
else if($.inArray('asc',oCol.asSorting)!=-1&&$.inArray('desc',oCol.asSorting)==-1)
{oCol.sSortingClass=oSettings.oClasses.sSortableAsc;oCol.sSortingClassJUI=oSettings.oClasses.sSortJUIAscAllowed;}
else if($.inArray('asc',oCol.asSorting)==-1&&$.inArray('desc',oCol.asSorting)!=-1)
{oCol.sSortingClass=oSettings.oClasses.sSortableDesc;oCol.sSortingClassJUI=oSettings.oClasses.sSortJUIDescAllowed;}}
function _fnAddData(oSettings,aDataSupplied)
{if(aDataSupplied.length!=oSettings.aoColumns.length&&oSettings.iDrawError!=oSettings.iDraw)
{_fnLog(oSettings,0,"Added data (size "+aDataSupplied.length+") does not match known "+
"number of columns ("+oSettings.aoColumns.length+")");oSettings.iDrawError=oSettings.iDraw;return-1;}
var aData=aDataSupplied.slice();var iThisIndex=oSettings.aoData.length;oSettings.aoData.push({"nTr":document.createElement('tr'),"_iId":oSettings.iNextId++,"_aData":aData,"_anHidden":[],"_sRowStripe":''});var nTd,sThisType;for(var i=0;i<aData.length;i++)
{nTd=document.createElement('td');if(aData[i]===null)
{aData[i]='';}
if(typeof oSettings.aoColumns[i].fnRender=='function')
{var sRendered=oSettings.aoColumns[i].fnRender({"iDataRow":iThisIndex,"iDataColumn":i,"aData":aData,"oSettings":oSettings});nTd.innerHTML=sRendered;if(oSettings.aoColumns[i].bUseRendered)
{oSettings.aoData[iThisIndex]._aData[i]=sRendered;}}
else
{nTd.innerHTML=aData[i];}
if(typeof aData[i]!='string')
{aData[i]+="";}
aData[i]=$.trim(aData[i]);if(oSettings.aoColumns[i].sClass!==null)
{nTd.className=oSettings.aoColumns[i].sClass;}
if(oSettings.aoColumns[i]._bAutoType&&oSettings.aoColumns[i].sType!='string')
{sThisType=_fnDetectType(oSettings.aoData[iThisIndex]._aData[i]);if(oSettings.aoColumns[i].sType===null)
{oSettings.aoColumns[i].sType=sThisType;}
else if(oSettings.aoColumns[i].sType!=sThisType)
{oSettings.aoColumns[i].sType='string';}}
if(oSettings.aoColumns[i].bVisible)
{oSettings.aoData[iThisIndex].nTr.appendChild(nTd);oSettings.aoData[iThisIndex]._anHidden[i]=null;}
else
{oSettings.aoData[iThisIndex]._anHidden[i]=nTd;}}
oSettings.aiDisplayMaster.push(iThisIndex);return iThisIndex;}
function _fnGatherData(oSettings)
{var iLoop,i,iLen,j,jLen,jInner,nTds,nTrs,nTd,aLocalData,iThisIndex,iRow,iRows,iColumn,iColumns;if(oSettings.sAjaxSource===null)
{nTrs=oSettings.nTBody.childNodes;for(i=0,iLen=nTrs.length;i<iLen;i++)
{if(nTrs[i].nodeName.toUpperCase()=="TR")
{iThisIndex=oSettings.aoData.length;oSettings.aoData.push({"nTr":nTrs[i],"_iId":oSettings.iNextId++,"_aData":[],"_anHidden":[],"_sRowStripe":''});oSettings.aiDisplayMaster.push(iThisIndex);aLocalData=oSettings.aoData[iThisIndex]._aData;nTds=nTrs[i].childNodes;jInner=0;for(j=0,jLen=nTds.length;j<jLen;j++)
{if(nTds[j].nodeName.toUpperCase()=="TD")
{aLocalData[jInner]=$.trim(nTds[j].innerHTML);jInner++;}}}}}
nTrs=_fnGetTrNodes(oSettings);nTds=[];for(i=0,iLen=nTrs.length;i<iLen;i++)
{for(j=0,jLen=nTrs[i].childNodes.length;j<jLen;j++)
{nTd=nTrs[i].childNodes[j];if(nTd.nodeName.toUpperCase()=="TD")
{nTds.push(nTd);}}}
if(nTds.length!=nTrs.length*oSettings.aoColumns.length)
{_fnLog(oSettings,1,"Unexpected number of TD elements. Expected "+
(nTrs.length*oSettings.aoColumns.length)+" and got "+nTds.length+". DataTables does "+
"not support rowspan / colspan in the table body, and there must be one cell for each "+
"row/column combination.");}
for(iColumn=0,iColumns=oSettings.aoColumns.length;iColumn<iColumns;iColumn++)
{if(oSettings.aoColumns[iColumn].sTitle===null)
{oSettings.aoColumns[iColumn].sTitle=oSettings.aoColumns[iColumn].nTh.innerHTML;}
var
bAutoType=oSettings.aoColumns[iColumn]._bAutoType,bRender=typeof oSettings.aoColumns[iColumn].fnRender=='function',bClass=oSettings.aoColumns[iColumn].sClass!==null,bVisible=oSettings.aoColumns[iColumn].bVisible,nCell,sThisType,sRendered;if(bAutoType||bRender||bClass||!bVisible)
{for(iRow=0,iRows=oSettings.aoData.length;iRow<iRows;iRow++)
{nCell=nTds[(iRow*iColumns)+iColumn];if(bAutoType)
{if(oSettings.aoColumns[iColumn].sType!='string')
{sThisType=_fnDetectType(oSettings.aoData[iRow]._aData[iColumn]);if(oSettings.aoColumns[iColumn].sType===null)
{oSettings.aoColumns[iColumn].sType=sThisType;}
else if(oSettings.aoColumns[iColumn].sType!=sThisType)
{oSettings.aoColumns[iColumn].sType='string';}}}
if(bRender)
{sRendered=oSettings.aoColumns[iColumn].fnRender({"iDataRow":iRow,"iDataColumn":iColumn,"aData":oSettings.aoData[iRow]._aData,"oSettings":oSettings});nCell.innerHTML=sRendered;if(oSettings.aoColumns[iColumn].bUseRendered)
{oSettings.aoData[iRow]._aData[iColumn]=sRendered;}}
if(bClass)
{nCell.className+=' '+oSettings.aoColumns[iColumn].sClass;}
if(!bVisible)
{oSettings.aoData[iRow]._anHidden[iColumn]=nCell;nCell.parentNode.removeChild(nCell);}
else
{oSettings.aoData[iRow]._anHidden[iColumn]=null;}}}}}
function _fnDrawHead(oSettings)
{var i,nTh,iLen,j,jLen;var anTr=oSettings.nTHead.getElementsByTagName('tr');var iThs=oSettings.nTHead.getElementsByTagName('th').length;var iCorrector=0;var jqChildren;if(iThs!==0)
{for(i=0,iLen=oSettings.aoColumns.length;i<iLen;i++)
{nTh=oSettings.aoColumns[i].nTh;if(oSettings.aoColumns[i].sClass!==null)
{$(nTh).addClass(oSettings.aoColumns[i].sClass);}
for(j=1,jLen=anTr.length;j<jLen;j++)
{jqChildren=$(anTr[j]).children();oSettings.aoColumns[i].anThExtra.push(jqChildren[i-iCorrector]);if(!oSettings.aoColumns[i].bVisible)
{anTr[j].removeChild(jqChildren[i-iCorrector]);}}
if(oSettings.aoColumns[i].bVisible)
{if(oSettings.aoColumns[i].sTitle!=nTh.innerHTML)
{nTh.innerHTML=oSettings.aoColumns[i].sTitle;}}
else
{nTh.parentNode.removeChild(nTh);iCorrector++;}}}
else
{var nTr=document.createElement("tr");for(i=0,iLen=oSettings.aoColumns.length;i<iLen;i++)
{nTh=oSettings.aoColumns[i].nTh;nTh.innerHTML=oSettings.aoColumns[i].sTitle;if(oSettings.aoColumns[i].sClass!==null)
{$(nTh).addClass(oSettings.aoColumns[i].sClass);}
if(oSettings.aoColumns[i].bVisible)
{nTr.appendChild(nTh);}}
$(oSettings.nTHead).html('')[0].appendChild(nTr);}
if(oSettings.bJUI)
{for(i=0,iLen=oSettings.aoColumns.length;i<iLen;i++)
{nTh=oSettings.aoColumns[i].nTh;var nDiv=document.createElement('div');nDiv.className=oSettings.oClasses.sSortJUIWrapper;$(nTh).contents().appendTo(nDiv);nDiv.appendChild(document.createElement('span'));nTh.appendChild(nDiv);}}
var fnNoSelect=function(e){this.onselectstart=function(){return false;};return false;};if(oSettings.oFeatures.bSort)
{for(i=0;i<oSettings.aoColumns.length;i++)
{if(oSettings.aoColumns[i].bSortable!==false)
{_fnSortAttachListener(oSettings,oSettings.aoColumns[i].nTh,i);$(oSettings.aoColumns[i].nTh).bind('mousedown.DT',fnNoSelect);}
else
{$(oSettings.aoColumns[i].nTh).addClass(oSettings.oClasses.sSortableNone);}}}
if(oSettings.nTFoot!==null)
{iCorrector=0;anTr=oSettings.nTFoot.getElementsByTagName('tr');var nTfs=anTr[0].getElementsByTagName('th');for(i=0,iLen=nTfs.length;i<iLen;i++)
{if(typeof oSettings.aoColumns[i]!='undefined')
{oSettings.aoColumns[i].nTf=nTfs[i-iCorrector];if(oSettings.oClasses.sFooterTH!=="")
{oSettings.aoColumns[i].nTf.className+=" "+oSettings.oClasses.sFooterTH;}
for(j=1,jLen=anTr.length;j<jLen;j++)
{jqChildren=$(anTr[j]).children();oSettings.aoColumns[i].anTfExtra.push(jqChildren[i-iCorrector]);if(!oSettings.aoColumns[i].bVisible)
{anTr[j].removeChild(jqChildren[i-iCorrector]);}}
if(!oSettings.aoColumns[i].bVisible)
{nTfs[i-iCorrector].parentNode.removeChild(nTfs[i-iCorrector]);iCorrector++;}}}}}
function _fnDraw(oSettings)
{var i,iLen;var anRows=[];var iRowCount=0;var bRowError=false;var iStrips=oSettings.asStripClasses.length;var iOpenRows=oSettings.aoOpenRows.length;oSettings.bDrawing=true;if(typeof oSettings.iInitDisplayStart!='undefined'&&oSettings.iInitDisplayStart!=-1)
{if(oSettings.oFeatures.bServerSide)
{oSettings._iDisplayStart=oSettings.iInitDisplayStart;}
else
{oSettings._iDisplayStart=(oSettings.iInitDisplayStart>=oSettings.fnRecordsDisplay())?0:oSettings.iInitDisplayStart;}
oSettings.iInitDisplayStart=-1;_fnCalculateEnd(oSettings);}
if(!oSettings.bDestroying&&oSettings.oFeatures.bServerSide&&!_fnAjaxUpdate(oSettings))
{return;}
else if(!oSettings.oFeatures.bServerSide)
{oSettings.iDraw++;}
if(oSettings.aiDisplay.length!==0)
{var iStart=oSettings._iDisplayStart;var iEnd=oSettings._iDisplayEnd;if(oSettings.oFeatures.bServerSide)
{iStart=0;iEnd=oSettings.aoData.length;}
for(var j=iStart;j<iEnd;j++)
{var aoData=oSettings.aoData[oSettings.aiDisplay[j]];var nRow=aoData.nTr;if(iStrips!==0)
{var sStrip=oSettings.asStripClasses[iRowCount%iStrips];if(aoData._sRowStripe!=sStrip)
{$(nRow).removeClass(aoData._sRowStripe).addClass(sStrip);aoData._sRowStripe=sStrip;}}
if(typeof oSettings.fnRowCallback=="function")
{nRow=oSettings.fnRowCallback.call(oSettings.oInstance,nRow,oSettings.aoData[oSettings.aiDisplay[j]]._aData,iRowCount,j);if(!nRow&&!bRowError)
{_fnLog(oSettings,0,"A node was not returned by fnRowCallback");bRowError=true;}}
anRows.push(nRow);iRowCount++;if(iOpenRows!==0)
{for(var k=0;k<iOpenRows;k++)
{if(nRow==oSettings.aoOpenRows[k].nParent)
{anRows.push(oSettings.aoOpenRows[k].nTr);}}}}}
else
{anRows[0]=document.createElement('tr');if(typeof oSettings.asStripClasses[0]!='undefined')
{anRows[0].className=oSettings.asStripClasses[0];}
var nTd=document.createElement('td');nTd.setAttribute('valign',"top");nTd.colSpan=_fnVisbleColumns(oSettings);nTd.className=oSettings.oClasses.sRowEmpty;if(typeof oSettings.oLanguage.sEmptyTable!='undefined'&&oSettings.fnRecordsTotal()===0)
{nTd.innerHTML=oSettings.oLanguage.sEmptyTable;}
else
{nTd.innerHTML=oSettings.oLanguage.sZeroRecords.replace('_MAX_',oSettings.fnFormatNumber(oSettings.fnRecordsTotal()));}
anRows[iRowCount].appendChild(nTd);}
if(typeof oSettings.fnHeaderCallback=='function')
{oSettings.fnHeaderCallback.call(oSettings.oInstance,$('>tr',oSettings.nTHead)[0],_fnGetDataMaster(oSettings),oSettings._iDisplayStart,oSettings.fnDisplayEnd(),oSettings.aiDisplay);}
if(typeof oSettings.fnFooterCallback=='function')
{oSettings.fnFooterCallback.call(oSettings.oInstance,$('>tr',oSettings.nTFoot)[0],_fnGetDataMaster(oSettings),oSettings._iDisplayStart,oSettings.fnDisplayEnd(),oSettings.aiDisplay);}
var
nAddFrag=document.createDocumentFragment(),nRemoveFrag=document.createDocumentFragment(),nBodyPar,nTrs;if(oSettings.nTBody)
{nBodyPar=oSettings.nTBody.parentNode;nRemoveFrag.appendChild(oSettings.nTBody);if(!oSettings.oScroll.bInfinite||!oSettings._bInitComplete||oSettings.bSorted||oSettings.bFiltered)
{nTrs=oSettings.nTBody.childNodes;for(i=nTrs.length-1;i>=0;i--)
{nTrs[i].parentNode.removeChild(nTrs[i]);}}
for(i=0,iLen=anRows.length;i<iLen;i++)
{nAddFrag.appendChild(anRows[i]);}
oSettings.nTBody.appendChild(nAddFrag);if(nBodyPar!==null)
{nBodyPar.appendChild(oSettings.nTBody);}}
for(i=oSettings.aoDrawCallback.length-1;i>=0;i--)
{oSettings.aoDrawCallback[i].fn.call(oSettings.oInstance,oSettings);}
oSettings.bSorted=false;oSettings.bFiltered=false;oSettings.bDrawing=false;if(oSettings.oFeatures.bServerSide)
{_fnProcessingDisplay(oSettings,false);if(typeof oSettings._bInitComplete=='undefined')
{_fnInitComplete(oSettings);}}}
function _fnReDraw(oSettings)
{if(oSettings.oFeatures.bSort)
{_fnSort(oSettings,oSettings.oPreviousSearch);}
else if(oSettings.oFeatures.bFilter)
{_fnFilterComplete(oSettings,oSettings.oPreviousSearch);}
else
{_fnCalculateEnd(oSettings);_fnDraw(oSettings);}}
function _fnAjaxUpdate(oSettings)
{if(oSettings.bAjaxDataGet)
{_fnProcessingDisplay(oSettings,true);var iColumns=oSettings.aoColumns.length;var aoData=[];var i;oSettings.iDraw++;aoData.push({"name":"sEcho","value":oSettings.iDraw});aoData.push({"name":"iColumns","value":iColumns});aoData.push({"name":"sColumns","value":_fnColumnOrdering(oSettings)});aoData.push({"name":"iDisplayStart","value":oSettings._iDisplayStart});aoData.push({"name":"iDisplayLength","value":oSettings.oFeatures.bPaginate!==false?oSettings._iDisplayLength:-1});if(oSettings.oFeatures.bFilter!==false)
{aoData.push({"name":"sSearch","value":oSettings.oPreviousSearch.sSearch});aoData.push({"name":"bRegex","value":oSettings.oPreviousSearch.bRegex});for(i=0;i<iColumns;i++)
{aoData.push({"name":"sSearch_"+i,"value":oSettings.aoPreSearchCols[i].sSearch});aoData.push({"name":"bRegex_"+i,"value":oSettings.aoPreSearchCols[i].bRegex});aoData.push({"name":"bSearchable_"+i,"value":oSettings.aoColumns[i].bSearchable});}}
if(oSettings.oFeatures.bSort!==false)
{var iFixed=oSettings.aaSortingFixed!==null?oSettings.aaSortingFixed.length:0;var iUser=oSettings.aaSorting.length;aoData.push({"name":"iSortingCols","value":iFixed+iUser});for(i=0;i<iFixed;i++)
{aoData.push({"name":"iSortCol_"+i,"value":oSettings.aaSortingFixed[i][0]});aoData.push({"name":"sSortDir_"+i,"value":oSettings.aaSortingFixed[i][1]});}
for(i=0;i<iUser;i++)
{aoData.push({"name":"iSortCol_"+(i+iFixed),"value":oSettings.aaSorting[i][0]});aoData.push({"name":"sSortDir_"+(i+iFixed),"value":oSettings.aaSorting[i][1]});}
for(i=0;i<iColumns;i++)
{aoData.push({"name":"bSortable_"+i,"value":oSettings.aoColumns[i].bSortable});}}
oSettings.fnServerData.call(oSettings.oInstance,oSettings.sAjaxSource,aoData,function(json){_fnAjaxUpdateDraw(oSettings,json);});return false;}
else
{return true;}}
function _fnAjaxUpdateDraw(oSettings,json)
{if(typeof json.sEcho!='undefined')
{if(json.sEcho*1<oSettings.iDraw)
{return;}
else
{oSettings.iDraw=json.sEcho*1;}}
if(!oSettings.oScroll.bInfinite||(oSettings.oScroll.bInfinite&&(oSettings.bSorted||oSettings.bFiltered)))
{_fnClearTable(oSettings);}
oSettings._iRecordsTotal=json.iTotalRecords;oSettings._iRecordsDisplay=json.iTotalDisplayRecords;var sOrdering=_fnColumnOrdering(oSettings);var bReOrder=(typeof json.sColumns!='undefined'&&sOrdering!==""&&json.sColumns!=sOrdering);if(bReOrder)
{var aiIndex=_fnReOrderIndex(oSettings,json.sColumns);}
for(var i=0,iLen=json.aaData.length;i<iLen;i++)
{if(bReOrder)
{var aData=[];for(var j=0,jLen=oSettings.aoColumns.length;j<jLen;j++)
{aData.push(json.aaData[i][aiIndex[j]]);}
_fnAddData(oSettings,aData);}
else
{_fnAddData(oSettings,json.aaData[i]);}}
oSettings.aiDisplay=oSettings.aiDisplayMaster.slice();oSettings.bAjaxDataGet=false;_fnDraw(oSettings);oSettings.bAjaxDataGet=true;_fnProcessingDisplay(oSettings,false);}
function _fnAddOptionsHtml(oSettings)
{var nHolding=document.createElement('div');oSettings.nTable.parentNode.insertBefore(nHolding,oSettings.nTable);oSettings.nTableWrapper=document.createElement('div');oSettings.nTableWrapper.className=oSettings.oClasses.sWrapper;if(oSettings.sTableId!=='')
{oSettings.nTableWrapper.setAttribute('id',oSettings.sTableId+'_wrapper');}
var nInsertNode=oSettings.nTableWrapper;var aDom=oSettings.sDom.split('');var nTmp,iPushFeature,cOption,nNewNode,cNext,sAttr,j;for(var i=0;i<aDom.length;i++)
{iPushFeature=0;cOption=aDom[i];if(cOption=='<')
{nNewNode=document.createElement('div');cNext=aDom[i+1];if(cNext=="'"||cNext=='"')
{sAttr="";j=2;while(aDom[i+j]!=cNext)
{sAttr+=aDom[i+j];j++;}
if(sAttr=="H")
{sAttr="fg-toolbar ui-toolbar ui-widget-header ui-corner-tl ui-corner-tr ui-helper-clearfix";}
else if(sAttr=="F")
{sAttr="fg-toolbar ui-toolbar ui-widget-header ui-corner-bl ui-corner-br ui-helper-clearfix";}
if(sAttr.indexOf('.')!=-1)
{var aSplit=sAttr.split('.');nNewNode.setAttribute('id',aSplit[0].substr(1,aSplit[0].length-1));nNewNode.className=aSplit[1];}
else if(sAttr.charAt(0)=="#")
{nNewNode.setAttribute('id',sAttr.substr(1,sAttr.length-1));}
else
{nNewNode.className=sAttr;}
i+=j;}
nInsertNode.appendChild(nNewNode);nInsertNode=nNewNode;}
else if(cOption=='>')
{nInsertNode=nInsertNode.parentNode;}
else if(cOption=='l'&&oSettings.oFeatures.bPaginate&&oSettings.oFeatures.bLengthChange)
{nTmp=_fnFeatureHtmlLength(oSettings);iPushFeature=1;}
else if(cOption=='f'&&oSettings.oFeatures.bFilter)
{nTmp=_fnFeatureHtmlFilter(oSettings);iPushFeature=1;}
else if(cOption=='r'&&oSettings.oFeatures.bProcessing)
{nTmp=_fnFeatureHtmlProcessing(oSettings);iPushFeature=1;}
else if(cOption=='t')
{nTmp=_fnFeatureHtmlTable(oSettings);iPushFeature=1;}
else if(cOption=='i'&&oSettings.oFeatures.bInfo)
{nTmp=_fnFeatureHtmlInfo(oSettings);iPushFeature=1;}
else if(cOption=='p'&&oSettings.oFeatures.bPaginate)
{nTmp=_fnFeatureHtmlPaginate(oSettings);iPushFeature=1;}
else if(_oExt.aoFeatures.length!==0)
{var aoFeatures=_oExt.aoFeatures;for(var k=0,kLen=aoFeatures.length;k<kLen;k++)
{if(cOption==aoFeatures[k].cFeature)
{nTmp=aoFeatures[k].fnInit(oSettings);if(nTmp)
{iPushFeature=1;}
break;}}}
if(iPushFeature==1&&nTmp!==null)
{if(typeof oSettings.aanFeatures[cOption]!='object')
{oSettings.aanFeatures[cOption]=[];}
oSettings.aanFeatures[cOption].push(nTmp);nInsertNode.appendChild(nTmp);}}
nHolding.parentNode.replaceChild(oSettings.nTableWrapper,nHolding);}
function _fnFeatureHtmlTable(oSettings)
{if(oSettings.oScroll.sX===""&&oSettings.oScroll.sY==="")
{return oSettings.nTable;}
var
nScroller=document.createElement('div'),nScrollHead=document.createElement('div'),nScrollHeadInner=document.createElement('div'),nScrollBody=document.createElement('div'),nScrollFoot=document.createElement('div'),nScrollFootInner=document.createElement('div'),nScrollHeadTable=oSettings.nTable.cloneNode(false),nScrollFootTable=oSettings.nTable.cloneNode(false),nThead=oSettings.nTable.getElementsByTagName('thead')[0],nTfoot=oSettings.nTable.getElementsByTagName('tfoot').length===0?null:oSettings.nTable.getElementsByTagName('tfoot')[0],oClasses=(typeof oInit.bJQueryUI!='undefined'&&oInit.bJQueryUI)?_oExt.oJUIClasses:_oExt.oStdClasses;nScrollHead.appendChild(nScrollHeadInner);nScrollFoot.appendChild(nScrollFootInner);nScrollBody.appendChild(oSettings.nTable);nScroller.appendChild(nScrollHead);nScroller.appendChild(nScrollBody);nScrollHeadInner.appendChild(nScrollHeadTable);nScrollHeadTable.appendChild(nThead);if(nTfoot!==null)
{nScroller.appendChild(nScrollFoot);nScrollFootInner.appendChild(nScrollFootTable);nScrollFootTable.appendChild(nTfoot);}
nScroller.className=oClasses.sScrollWrapper;nScrollHead.className=oClasses.sScrollHead;nScrollHeadInner.className=oClasses.sScrollHeadInner;nScrollBody.className=oClasses.sScrollBody;nScrollFoot.className=oClasses.sScrollFoot;nScrollFootInner.className=oClasses.sScrollFootInner;if(oSettings.oScroll.bAutoCss)
{nScrollHead.style.overflow="hidden";nScrollHead.style.position="relative";nScrollFoot.style.overflow="hidden";nScrollBody.style.overflow="auto";}
nScrollHead.style.border="0";nScrollHead.style.width="100%";nScrollFoot.style.border="0";nScrollHeadInner.style.width="150%";nScrollHeadTable.removeAttribute('id');nScrollHeadTable.style.marginLeft="0";oSettings.nTable.style.marginLeft="0";if(nTfoot!==null)
{nScrollFootTable.removeAttribute('id');nScrollFootTable.style.marginLeft="0";}
var nCaptions=$('>caption',oSettings.nTable);for(var i=0,iLen=nCaptions.length;i<iLen;i++)
{nScrollHeadTable.appendChild(nCaptions[i]);}
if(oSettings.oScroll.sX!=="")
{nScrollHead.style.width=_fnStringToCss(oSettings.oScroll.sX);nScrollBody.style.width=_fnStringToCss(oSettings.oScroll.sX);if(nTfoot!==null)
{nScrollFoot.style.width=_fnStringToCss(oSettings.oScroll.sX);}
$(nScrollBody).scroll(function(e){nScrollHead.scrollLeft=this.scrollLeft;if(nTfoot!==null)
{nScrollFoot.scrollLeft=this.scrollLeft;}});}
if(oSettings.oScroll.sY!=="")
{nScrollBody.style.height=_fnStringToCss(oSettings.oScroll.sY);}
oSettings.aoDrawCallback.push({"fn":_fnScrollDraw,"sName":"scrolling"});if(oSettings.oScroll.bInfinite)
{$(nScrollBody).scroll(function(){if(!oSettings.bDrawing)
{if($(this).scrollTop()+$(this).height()>$(oSettings.nTable).height()-oSettings.oScroll.iLoadGap)
{if(oSettings.fnDisplayEnd()<oSettings.fnRecordsDisplay())
{_fnPageChange(oSettings,'next');_fnCalculateEnd(oSettings);_fnDraw(oSettings);}}}});}
oSettings.nScrollHead=nScrollHead;oSettings.nScrollFoot=nScrollFoot;return nScroller;}
function _fnScrollDraw(o)
{var
nScrollHeadInner=o.nScrollHead.getElementsByTagName('div')[0],nScrollHeadTable=nScrollHeadInner.getElementsByTagName('table')[0],nScrollBody=o.nTable.parentNode,i,iLen,j,jLen,anHeadToSize,anHeadSizers,anFootSizers,anFootToSize,oStyle,iVis,iWidth,aApplied=[],iSanityWidth;var nTheadSize=o.nTable.getElementsByTagName('thead');if(nTheadSize.length>0)
{o.nTable.removeChild(nTheadSize[0]);}
if(o.nTFoot!==null)
{var nTfootSize=o.nTable.getElementsByTagName('tfoot');if(nTfootSize.length>0)
{o.nTable.removeChild(nTfootSize[0]);}}
nTheadSize=o.nTHead.cloneNode(true);o.nTable.insertBefore(nTheadSize,o.nTable.childNodes[0]);if(o.nTFoot!==null)
{nTfootSize=o.nTFoot.cloneNode(true);o.nTable.insertBefore(nTfootSize,o.nTable.childNodes[1]);}
var nThs=_fnGetUniqueThs(nTheadSize);for(i=0,iLen=nThs.length;i<iLen;i++)
{iVis=_fnVisibleToColumnIndex(o,i);nThs[i].style.width=o.aoColumns[iVis].sWidth;}
if(o.nTFoot!==null)
{_fnApplyToChildren(function(n){n.style.width="";},nTfootSize.getElementsByTagName('tr'));}
iSanityWidth=$(o.nTable).outerWidth();if(o.oScroll.sX==="")
{o.nTable.style.width="100%";if($.browser.msie&&$.browser.version<=7)
{o.nTable.style.width=_fnStringToCss($(o.nTable).outerWidth()-o.oScroll.iBarWidth);}}
else
{if(o.oScroll.sXInner!=="")
{o.nTable.style.width=_fnStringToCss(o.oScroll.sXInner);}
else if(iSanityWidth==$(nScrollBody).width()&&$(nScrollBody).height()<$(o.nTable).height())
{o.nTable.style.width=_fnStringToCss(iSanityWidth-o.oScroll.iBarWidth);if($(o.nTable).outerWidth()>iSanityWidth-o.oScroll.iBarWidth)
{o.nTable.style.width=_fnStringToCss(iSanityWidth);}}
else
{o.nTable.style.width=_fnStringToCss(iSanityWidth);}}
iSanityWidth=$(o.nTable).outerWidth();anHeadToSize=o.nTHead.getElementsByTagName('tr');anHeadSizers=nTheadSize.getElementsByTagName('tr');_fnApplyToChildren(function(nSizer,nToSize){oStyle=nSizer.style;oStyle.paddingTop="0";oStyle.paddingBottom="0";oStyle.borderTopWidth="0";oStyle.borderBottomWidth="0";oStyle.height=0;iWidth=$(nSizer).width();nToSize.style.width=_fnStringToCss(iWidth);aApplied.push(iWidth);},anHeadSizers,anHeadToSize);$(anHeadSizers).height(0);if(o.nTFoot!==null)
{anFootSizers=nTfootSize.getElementsByTagName('tr');anFootToSize=o.nTFoot.getElementsByTagName('tr');_fnApplyToChildren(function(nSizer,nToSize){oStyle=nSizer.style;oStyle.paddingTop="0";oStyle.paddingBottom="0";oStyle.borderTopWidth="0";oStyle.borderBottomWidth="0";oStyle.height=0;iWidth=$(nSizer).width();nToSize.style.width=_fnStringToCss(iWidth);aApplied.push(iWidth);},anFootSizers,anFootToSize);$(anFootSizers).height(0);}
_fnApplyToChildren(function(nSizer){nSizer.innerHTML="";nSizer.style.width=_fnStringToCss(aApplied.shift());},anHeadSizers);if(o.nTFoot!==null)
{_fnApplyToChildren(function(nSizer){nSizer.innerHTML="";nSizer.style.width=_fnStringToCss(aApplied.shift());},anFootSizers);}
if($(o.nTable).outerWidth()<iSanityWidth)
{if(o.oScroll.sX==="")
{_fnLog(o,1,"The table cannot fit into the current element which will cause column"+
" misalignment. It is suggested that you enable x-scrolling or increase the width"+
" the table has in which to be drawn");}
else if(o.oScroll.sXInner!=="")
{_fnLog(o,1,"The table cannot fit into the current element which will cause column"+
" misalignment. It is suggested that you increase the sScrollXInner property to"+
" allow it to draw in a larger area, or simply remove that parameter to allow"+
" automatic calculation");}}
if(o.oScroll.sY==="")
{if($.browser.msie&&$.browser.version<=7)
{nScrollBody.style.height=_fnStringToCss(o.nTable.offsetHeight+o.oScroll.iBarWidth);}}
if(o.oScroll.sY!==""&&o.oScroll.bCollapse)
{nScrollBody.style.height=_fnStringToCss(o.oScroll.sY);var iExtra=(o.oScroll.sX!==""&&o.nTable.offsetWidth>nScrollBody.offsetWidth)?o.oScroll.iBarWidth:0;if(o.nTable.offsetHeight<nScrollBody.offsetHeight)
{nScrollBody.style.height=_fnStringToCss($(o.nTable).height()+iExtra);}}
var iOuterWidth=$(o.nTable).outerWidth();nScrollHeadTable.style.width=_fnStringToCss(iOuterWidth);nScrollHeadInner.style.width=_fnStringToCss(iOuterWidth+o.oScroll.iBarWidth);if(o.nTFoot!==null)
{var
nScrollFootInner=o.nScrollFoot.getElementsByTagName('div')[0],nScrollFootTable=nScrollFootInner.getElementsByTagName('table')[0];nScrollFootInner.style.width=_fnStringToCss(o.nTable.offsetWidth+o.oScroll.iBarWidth);nScrollFootTable.style.width=_fnStringToCss(o.nTable.offsetWidth);}
if(o.bSorted||o.bFiltered)
{nScrollBody.scrollTop=0;}}
function _fnAjustColumnSizing(oSettings)
{if(oSettings.oFeatures.bAutoWidth===false)
{return false;}
_fnCalculateColumnWidths(oSettings);for(var i=0,iLen=oSettings.aoColumns.length;i<iLen;i++)
{oSettings.aoColumns[i].nTh.style.width=oSettings.aoColumns[i].sWidth;}}
function _fnFeatureHtmlFilter(oSettings)
{var nFilter=document.createElement('div');if(oSettings.sTableId!==''&&typeof oSettings.aanFeatures.f=="undefined")
{nFilter.setAttribute('id',oSettings.sTableId+'_filter');}
nFilter.className=oSettings.oClasses.sFilter;var sSpace=oSettings.oLanguage.sSearch===""?"":" ";nFilter.innerHTML=oSettings.oLanguage.sSearch+sSpace+'<input type="text" />';var jqFilter=$("input",nFilter);jqFilter.val(oSettings.oPreviousSearch.sSearch.replace('"','&quot;'));jqFilter.bind('keyup.DT',function(e){var n=oSettings.aanFeatures.f;for(var i=0,iLen=n.length;i<iLen;i++)
{if(n[i]!=this.parentNode)
{$('input',n[i]).val(this.value);}}
if(this.value!=oSettings.oPreviousSearch.sSearch)
{_fnFilterComplete(oSettings,{"sSearch":this.value,"bRegex":oSettings.oPreviousSearch.bRegex,"bSmart":oSettings.oPreviousSearch.bSmart});}});jqFilter.bind('keypress.DT',function(e){if(e.keyCode==13)
{return false;}});return nFilter;}
function _fnFilterComplete(oSettings,oInput,iForce)
{_fnFilter(oSettings,oInput.sSearch,iForce,oInput.bRegex,oInput.bSmart);for(var i=0;i<oSettings.aoPreSearchCols.length;i++)
{_fnFilterColumn(oSettings,oSettings.aoPreSearchCols[i].sSearch,i,oSettings.aoPreSearchCols[i].bRegex,oSettings.aoPreSearchCols[i].bSmart);}
if(_oExt.afnFiltering.length!==0)
{_fnFilterCustom(oSettings);}
oSettings.bFiltered=true;oSettings._iDisplayStart=0;_fnCalculateEnd(oSettings);_fnDraw(oSettings);_fnBuildSearchArray(oSettings,0);}
function _fnFilterCustom(oSettings)
{var afnFilters=_oExt.afnFiltering;for(var i=0,iLen=afnFilters.length;i<iLen;i++)
{var iCorrector=0;for(var j=0,jLen=oSettings.aiDisplay.length;j<jLen;j++)
{var iDisIndex=oSettings.aiDisplay[j-iCorrector];if(!afnFilters[i](oSettings,oSettings.aoData[iDisIndex]._aData,iDisIndex))
{oSettings.aiDisplay.splice(j-iCorrector,1);iCorrector++;}}}}
function _fnFilterColumn(oSettings,sInput,iColumn,bRegex,bSmart)
{if(sInput==="")
{return;}
var iIndexCorrector=0;var rpSearch=_fnFilterCreateSearch(sInput,bRegex,bSmart);for(var i=oSettings.aiDisplay.length-1;i>=0;i--)
{var sData=_fnDataToSearch(oSettings.aoData[oSettings.aiDisplay[i]]._aData[iColumn],oSettings.aoColumns[iColumn].sType);if(!rpSearch.test(sData))
{oSettings.aiDisplay.splice(i,1);iIndexCorrector++;}}}
function _fnFilter(oSettings,sInput,iForce,bRegex,bSmart)
{var i;var rpSearch=_fnFilterCreateSearch(sInput,bRegex,bSmart);if(typeof iForce=='undefined'||iForce===null)
{iForce=0;}
if(_oExt.afnFiltering.length!==0)
{iForce=1;}
if(sInput.length<=0)
{oSettings.aiDisplay.splice(0,oSettings.aiDisplay.length);oSettings.aiDisplay=oSettings.aiDisplayMaster.slice();}
else
{if(oSettings.aiDisplay.length==oSettings.aiDisplayMaster.length||oSettings.oPreviousSearch.sSearch.length>sInput.length||iForce==1||sInput.indexOf(oSettings.oPreviousSearch.sSearch)!==0)
{oSettings.aiDisplay.splice(0,oSettings.aiDisplay.length);_fnBuildSearchArray(oSettings,1);for(i=0;i<oSettings.aiDisplayMaster.length;i++)
{if(rpSearch.test(oSettings.asDataSearch[i]))
{oSettings.aiDisplay.push(oSettings.aiDisplayMaster[i]);}}}
else
{var iIndexCorrector=0;for(i=0;i<oSettings.asDataSearch.length;i++)
{if(!rpSearch.test(oSettings.asDataSearch[i]))
{oSettings.aiDisplay.splice(i-iIndexCorrector,1);iIndexCorrector++;}}}}
oSettings.oPreviousSearch.sSearch=sInput;oSettings.oPreviousSearch.bRegex=bRegex;oSettings.oPreviousSearch.bSmart=bSmart;}
function _fnBuildSearchArray(oSettings,iMaster)
{oSettings.asDataSearch.splice(0,oSettings.asDataSearch.length);var aArray=(typeof iMaster!='undefined'&&iMaster==1)?oSettings.aiDisplayMaster:oSettings.aiDisplay;for(var i=0,iLen=aArray.length;i<iLen;i++)
{oSettings.asDataSearch[i]=_fnBuildSearchRow(oSettings,oSettings.aoData[aArray[i]]._aData);}}
function _fnBuildSearchRow(oSettings,aData)
{var sSearch='';var nTmp=document.createElement('div');for(var j=0,jLen=oSettings.aoColumns.length;j<jLen;j++)
{if(oSettings.aoColumns[j].bSearchable)
{var sData=aData[j];sSearch+=_fnDataToSearch(sData,oSettings.aoColumns[j].sType)+'  ';}}
if(sSearch.indexOf('&')!==-1)
{nTmp.innerHTML=sSearch;sSearch=nTmp.textContent?nTmp.textContent:nTmp.innerText;sSearch=sSearch.replace(/\n/g," ").replace(/\r/g,"");}
return sSearch;}
function _fnFilterCreateSearch(sSearch,bRegex,bSmart)
{var asSearch,sRegExpString;if(bSmart)
{asSearch=bRegex?sSearch.split(' '):_fnEscapeRegex(sSearch).split(' ');sRegExpString='^(?=.*?'+asSearch.join(')(?=.*?')+').*$';return new RegExp(sRegExpString,"i");}
else
{sSearch=bRegex?sSearch:_fnEscapeRegex(sSearch);return new RegExp(sSearch,"i");}}
function _fnDataToSearch(sData,sType)
{if(typeof _oExt.ofnSearch[sType]=="function")
{return _oExt.ofnSearch[sType](sData);}
else if(sType=="html")
{return sData.replace(/\n/g," ").replace(/<.*?>/g,"");}
else if(typeof sData=="string")
{return sData.replace(/\n/g," ");}
return sData;}
function _fnSort(oSettings,bApplyClasses)
{var
iDataSort,iDataType,i,iLen,j,jLen,aaSort=[],aiOrig=[],oSort=_oExt.oSort,aoData=oSettings.aoData,aoColumns=oSettings.aoColumns;if(!oSettings.oFeatures.bServerSide&&(oSettings.aaSorting.length!==0||oSettings.aaSortingFixed!==null))
{if(oSettings.aaSortingFixed!==null)
{aaSort=oSettings.aaSortingFixed.concat(oSettings.aaSorting);}
else
{aaSort=oSettings.aaSorting.slice();}
for(i=0;i<aaSort.length;i++)
{var iColumn=aaSort[i][0];var iVisColumn=_fnColumnIndexToVisible(oSettings,iColumn);var sDataType=oSettings.aoColumns[iColumn].sSortDataType;if(typeof _oExt.afnSortData[sDataType]!='undefined')
{var aData=_oExt.afnSortData[sDataType](oSettings,iColumn,iVisColumn);for(j=0,jLen=aoData.length;j<jLen;j++)
{aoData[j]._aData[iColumn]=aData[j];}}}
for(i=0,iLen=oSettings.aiDisplayMaster.length;i<iLen;i++)
{aiOrig[oSettings.aiDisplayMaster[i]]=i;}
var iSortLen=aaSort.length;oSettings.aiDisplayMaster.sort(function(a,b){var iTest;for(i=0;i<iSortLen;i++)
{iDataSort=aoColumns[aaSort[i][0]].iDataSort;iDataType=aoColumns[iDataSort].sType;iTest=oSort[iDataType+"-"+aaSort[i][1]](aoData[a]._aData[iDataSort],aoData[b]._aData[iDataSort]);if(iTest!==0)
{return iTest;}}
return oSort['numeric-asc'](aiOrig[a],aiOrig[b]);});}
if(typeof bApplyClasses=='undefined'||bApplyClasses)
{_fnSortingClasses(oSettings);}
oSettings.bSorted=true;if(oSettings.oFeatures.bFilter)
{_fnFilterComplete(oSettings,oSettings.oPreviousSearch,1);}
else
{oSettings.aiDisplay=oSettings.aiDisplayMaster.slice();oSettings._iDisplayStart=0;_fnCalculateEnd(oSettings);_fnDraw(oSettings);}}
function _fnSortAttachListener(oSettings,nNode,iDataIndex,fnCallback)
{$(nNode).bind('click.DT',function(e){if(oSettings.aoColumns[iDataIndex].bSortable===false)
{return;}
var fnInnerSorting=function(){var iColumn,iNextSort;if(e.shiftKey)
{var bFound=false;for(var i=0;i<oSettings.aaSorting.length;i++)
{if(oSettings.aaSorting[i][0]==iDataIndex)
{bFound=true;iColumn=oSettings.aaSorting[i][0];iNextSort=oSettings.aaSorting[i][2]+1;if(typeof oSettings.aoColumns[iColumn].asSorting[iNextSort]=='undefined')
{oSettings.aaSorting.splice(i,1);}
else
{oSettings.aaSorting[i][1]=oSettings.aoColumns[iColumn].asSorting[iNextSort];oSettings.aaSorting[i][2]=iNextSort;}
break;}}
if(bFound===false)
{oSettings.aaSorting.push([iDataIndex,oSettings.aoColumns[iDataIndex].asSorting[0],0]);}}
else
{if(oSettings.aaSorting.length==1&&oSettings.aaSorting[0][0]==iDataIndex)
{iColumn=oSettings.aaSorting[0][0];iNextSort=oSettings.aaSorting[0][2]+1;if(typeof oSettings.aoColumns[iColumn].asSorting[iNextSort]=='undefined')
{iNextSort=0;}
oSettings.aaSorting[0][1]=oSettings.aoColumns[iColumn].asSorting[iNextSort];oSettings.aaSorting[0][2]=iNextSort;}
else
{oSettings.aaSorting.splice(0,oSettings.aaSorting.length);oSettings.aaSorting.push([iDataIndex,oSettings.aoColumns[iDataIndex].asSorting[0],0]);}}
_fnSort(oSettings);};if(!oSettings.oFeatures.bProcessing)
{fnInnerSorting();}
else
{_fnProcessingDisplay(oSettings,true);setTimeout(function(){fnInnerSorting();if(!oSettings.oFeatures.bServerSide)
{_fnProcessingDisplay(oSettings,false);}},0);}
if(typeof fnCallback=='function')
{fnCallback(oSettings);}});}
function _fnSortingClasses(oSettings)
{var i,iLen,j,jLen,iFound;var aaSort,sClass;var iColumns=oSettings.aoColumns.length;var oClasses=oSettings.oClasses;for(i=0;i<iColumns;i++)
{if(oSettings.aoColumns[i].bSortable)
{$(oSettings.aoColumns[i].nTh).removeClass(oClasses.sSortAsc+" "+oClasses.sSortDesc+
" "+oSettings.aoColumns[i].sSortingClass);}}
if(oSettings.aaSortingFixed!==null)
{aaSort=oSettings.aaSortingFixed.concat(oSettings.aaSorting);}
else
{aaSort=oSettings.aaSorting.slice();}
for(i=0;i<oSettings.aoColumns.length;i++)
{if(oSettings.aoColumns[i].bSortable)
{sClass=oSettings.aoColumns[i].sSortingClass;iFound=-1;for(j=0;j<aaSort.length;j++)
{if(aaSort[j][0]==i)
{sClass=(aaSort[j][1]=="asc")?oClasses.sSortAsc:oClasses.sSortDesc;iFound=j;break;}}
$(oSettings.aoColumns[i].nTh).addClass(sClass);if(oSettings.bJUI)
{var jqSpan=$("span",oSettings.aoColumns[i].nTh);jqSpan.removeClass(oClasses.sSortJUIAsc+" "+oClasses.sSortJUIDesc+" "+
oClasses.sSortJUI+" "+oClasses.sSortJUIAscAllowed+" "+oClasses.sSortJUIDescAllowed);var sSpanClass;if(iFound==-1)
{sSpanClass=oSettings.aoColumns[i].sSortingClassJUI;}
else if(aaSort[iFound][1]=="asc")
{sSpanClass=oClasses.sSortJUIAsc;}
else
{sSpanClass=oClasses.sSortJUIDesc;}
jqSpan.addClass(sSpanClass);}}
else
{$(oSettings.aoColumns[i].nTh).addClass(oSettings.aoColumns[i].sSortingClass);}}
sClass=oClasses.sSortColumn;if(oSettings.oFeatures.bSort&&oSettings.oFeatures.bSortClasses)
{var nTds=_fnGetTdNodes(oSettings);if(nTds.length>=iColumns)
{for(i=0;i<iColumns;i++)
{if(nTds[i].className.indexOf(sClass+"1")!=-1)
{for(j=0,jLen=(nTds.length/iColumns);j<jLen;j++)
{nTds[(iColumns*j)+i].className=$.trim(nTds[(iColumns*j)+i].className.replace(sClass+"1",""));}}
else if(nTds[i].className.indexOf(sClass+"2")!=-1)
{for(j=0,jLen=(nTds.length/iColumns);j<jLen;j++)
{nTds[(iColumns*j)+i].className=$.trim(nTds[(iColumns*j)+i].className.replace(sClass+"2",""));}}
else if(nTds[i].className.indexOf(sClass+"3")!=-1)
{for(j=0,jLen=(nTds.length/iColumns);j<jLen;j++)
{nTds[(iColumns*j)+i].className=$.trim(nTds[(iColumns*j)+i].className.replace(" "+sClass+"3",""));}}}}
var iClass=1,iTargetCol;for(i=0;i<aaSort.length;i++)
{iTargetCol=parseInt(aaSort[i][0],10);for(j=0,jLen=(nTds.length/iColumns);j<jLen;j++)
{nTds[(iColumns*j)+iTargetCol].className+=" "+sClass+iClass;}
if(iClass<3)
{iClass++;}}}}
function _fnFeatureHtmlPaginate(oSettings)
{if(oSettings.oScroll.bInfinite)
{return null;}
var nPaginate=document.createElement('div');nPaginate.className=oSettings.oClasses.sPaging+oSettings.sPaginationType;_oExt.oPagination[oSettings.sPaginationType].fnInit(oSettings,nPaginate,function(oSettings){_fnCalculateEnd(oSettings);_fnDraw(oSettings);});if(typeof oSettings.aanFeatures.p=="undefined")
{oSettings.aoDrawCallback.push({"fn":function(oSettings){_oExt.oPagination[oSettings.sPaginationType].fnUpdate(oSettings,function(oSettings){_fnCalculateEnd(oSettings);_fnDraw(oSettings);});},"sName":"pagination"});}
return nPaginate;}
function _fnPageChange(oSettings,sAction)
{var iOldStart=oSettings._iDisplayStart;if(sAction=="first")
{oSettings._iDisplayStart=0;}
else if(sAction=="previous")
{oSettings._iDisplayStart=oSettings._iDisplayLength>=0?oSettings._iDisplayStart-oSettings._iDisplayLength:0;if(oSettings._iDisplayStart<0)
{oSettings._iDisplayStart=0;}}
else if(sAction=="next")
{if(oSettings._iDisplayLength>=0)
{if(oSettings._iDisplayStart+oSettings._iDisplayLength<oSettings.fnRecordsDisplay())
{oSettings._iDisplayStart+=oSettings._iDisplayLength;}}
else
{oSettings._iDisplayStart=0;}}
else if(sAction=="last")
{if(oSettings._iDisplayLength>=0)
{var iPages=parseInt((oSettings.fnRecordsDisplay()-1)/oSettings._iDisplayLength,10)+1;oSettings._iDisplayStart=(iPages-1)*oSettings._iDisplayLength;}
else
{oSettings._iDisplayStart=0;}}
else
{_fnLog(oSettings,0,"Unknown paging action: "+sAction);}
return iOldStart!=oSettings._iDisplayStart;}
function _fnFeatureHtmlInfo(oSettings)
{var nInfo=document.createElement('div');nInfo.className=oSettings.oClasses.sInfo;if(typeof oSettings.aanFeatures.i=="undefined")
{oSettings.aoDrawCallback.push({"fn":_fnUpdateInfo,"sName":"information"});if(oSettings.sTableId!=='')
{nInfo.setAttribute('id',oSettings.sTableId+'_info');}}
return nInfo;}
function _fnUpdateInfo(oSettings)
{if(!oSettings.oFeatures.bInfo||oSettings.aanFeatures.i.length===0)
{return;}
var
iStart=oSettings._iDisplayStart+1,iEnd=oSettings.fnDisplayEnd(),iMax=oSettings.fnRecordsTotal(),iTotal=oSettings.fnRecordsDisplay(),sStart=oSettings.fnFormatNumber(iStart),sEnd=oSettings.fnFormatNumber(iEnd),sMax=oSettings.fnFormatNumber(iMax),sTotal=oSettings.fnFormatNumber(iTotal),sOut;if(oSettings.oScroll.bInfinite)
{sStart=oSettings.fnFormatNumber(1);}
if(oSettings.fnRecordsDisplay()===0&&oSettings.fnRecordsDisplay()==oSettings.fnRecordsTotal())
{sOut=oSettings.oLanguage.sInfoEmpty+oSettings.oLanguage.sInfoPostFix;}
else if(oSettings.fnRecordsDisplay()===0)
{sOut=oSettings.oLanguage.sInfoEmpty+' '+
oSettings.oLanguage.sInfoFiltered.replace('_MAX_',sMax)+
oSettings.oLanguage.sInfoPostFix;}
else if(oSettings.fnRecordsDisplay()==oSettings.fnRecordsTotal())
{sOut=oSettings.oLanguage.sInfo.replace('_START_',sStart).replace('_END_',sEnd).replace('_TOTAL_',sTotal)+
oSettings.oLanguage.sInfoPostFix;}
else
{sOut=oSettings.oLanguage.sInfo.replace('_START_',sStart).replace('_END_',sEnd).replace('_TOTAL_',sTotal)+' '+
oSettings.oLanguage.sInfoFiltered.replace('_MAX_',oSettings.fnFormatNumber(oSettings.fnRecordsTotal()))+
oSettings.oLanguage.sInfoPostFix;}
if(oSettings.oLanguage.fnInfoCallback!==null)
{sOut=oSettings.oLanguage.fnInfoCallback(oSettings,iStart,iEnd,iMax,iTotal,sOut);}
var n=oSettings.aanFeatures.i;for(var i=0,iLen=n.length;i<iLen;i++)
{$(n[i]).html(sOut);}}
function _fnFeatureHtmlLength(oSettings)
{if(oSettings.oScroll.bInfinite)
{return null;}
var sName=(oSettings.sTableId==="")?"":'name="'+oSettings.sTableId+'_length"';var sStdMenu='<select size="1" '+sName+'>';var i,iLen;if(oSettings.aLengthMenu.length==2&&typeof oSettings.aLengthMenu[0]=='object'&&typeof oSettings.aLengthMenu[1]=='object')
{for(i=0,iLen=oSettings.aLengthMenu[0].length;i<iLen;i++)
{sStdMenu+='<option value="'+oSettings.aLengthMenu[0][i]+'">'+
oSettings.aLengthMenu[1][i]+'</option>';}}
else
{for(i=0,iLen=oSettings.aLengthMenu.length;i<iLen;i++)
{sStdMenu+='<option value="'+oSettings.aLengthMenu[i]+'">'+
oSettings.aLengthMenu[i]+'</option>';}}
sStdMenu+='</select>';var nLength=document.createElement('div');if(oSettings.sTableId!==''&&typeof oSettings.aanFeatures.l=="undefined")
{nLength.setAttribute('id',oSettings.sTableId+'_length');}
nLength.className=oSettings.oClasses.sLength;nLength.innerHTML=oSettings.oLanguage.sLengthMenu.replace('_MENU_',sStdMenu);$('select option[value="'+oSettings._iDisplayLength+'"]',nLength).attr("selected",true);$('select',nLength).bind('change.DT',function(e){var iVal=$(this).val();var n=oSettings.aanFeatures.l;for(i=0,iLen=n.length;i<iLen;i++)
{if(n[i]!=this.parentNode)
{$('select',n[i]).val(iVal);}}
oSettings._iDisplayLength=parseInt(iVal,10);_fnCalculateEnd(oSettings);if(oSettings.fnDisplayEnd()==oSettings.fnRecordsDisplay())
{oSettings._iDisplayStart=oSettings.fnDisplayEnd()-oSettings._iDisplayLength;if(oSettings._iDisplayStart<0)
{oSettings._iDisplayStart=0;}}
if(oSettings._iDisplayLength==-1)
{oSettings._iDisplayStart=0;}
_fnDraw(oSettings);});return nLength;}
function _fnFeatureHtmlProcessing(oSettings)
{var nProcessing=document.createElement('div');if(oSettings.sTableId!==''&&typeof oSettings.aanFeatures.r=="undefined")
{nProcessing.setAttribute('id',oSettings.sTableId+'_processing');}
nProcessing.innerHTML=oSettings.oLanguage.sProcessing;nProcessing.className=oSettings.oClasses.sProcessing;oSettings.nTable.parentNode.insertBefore(nProcessing,oSettings.nTable);return nProcessing;}
function _fnProcessingDisplay(oSettings,bShow)
{if(oSettings.oFeatures.bProcessing)
{var an=oSettings.aanFeatures.r;for(var i=0,iLen=an.length;i<iLen;i++)
{an[i].style.visibility=bShow?"visible":"hidden";}}}
function _fnVisibleToColumnIndex(oSettings,iMatch)
{var iColumn=-1;for(var i=0;i<oSettings.aoColumns.length;i++)
{if(oSettings.aoColumns[i].bVisible===true)
{iColumn++;}
if(iColumn==iMatch)
{return i;}}
return null;}
function _fnColumnIndexToVisible(oSettings,iMatch)
{var iVisible=-1;for(var i=0;i<oSettings.aoColumns.length;i++)
{if(oSettings.aoColumns[i].bVisible===true)
{iVisible++;}
if(i==iMatch)
{return oSettings.aoColumns[i].bVisible===true?iVisible:null;}}
return null;}
function _fnNodeToDataIndex(s,n)
{var i,iLen;for(i=s._iDisplayStart,iLen=s._iDisplayEnd;i<iLen;i++)
{if(s.aoData[s.aiDisplay[i]].nTr==n)
{return s.aiDisplay[i];}}
for(i=0,iLen=s.aoData.length;i<iLen;i++)
{if(s.aoData[i].nTr==n)
{return i;}}
return null;}
function _fnVisbleColumns(oS)
{var iVis=0;for(var i=0;i<oS.aoColumns.length;i++)
{if(oS.aoColumns[i].bVisible===true)
{iVis++;}}
return iVis;}
function _fnCalculateEnd(oSettings)
{if(oSettings.oFeatures.bPaginate===false)
{oSettings._iDisplayEnd=oSettings.aiDisplay.length;}
else
{if(oSettings._iDisplayStart+oSettings._iDisplayLength>oSettings.aiDisplay.length||oSettings._iDisplayLength==-1)
{oSettings._iDisplayEnd=oSettings.aiDisplay.length;}
else
{oSettings._iDisplayEnd=oSettings._iDisplayStart+oSettings._iDisplayLength;}}}
function _fnConvertToWidth(sWidth,nParent)
{if(!sWidth||sWidth===null||sWidth==='')
{return 0;}
if(typeof nParent=="undefined")
{nParent=document.getElementsByTagName('body')[0];}
var iWidth;var nTmp=document.createElement("div");nTmp.style.width=sWidth;nParent.appendChild(nTmp);iWidth=nTmp.offsetWidth;nParent.removeChild(nTmp);return(iWidth);}
function _fnCalculateColumnWidths(oSettings)
{var iTableWidth=oSettings.nTable.offsetWidth;var iUserInputs=0;var iTmpWidth;var iVisibleColumns=0;var iColums=oSettings.aoColumns.length;var i;var oHeaders=$('th',oSettings.nTHead);for(i=0;i<iColums;i++)
{if(oSettings.aoColumns[i].bVisible)
{iVisibleColumns++;if(oSettings.aoColumns[i].sWidth!==null)
{iTmpWidth=_fnConvertToWidth(oSettings.aoColumns[i].sWidthOrig,oSettings.nTable.parentNode);if(iTmpWidth!==null)
{oSettings.aoColumns[i].sWidth=_fnStringToCss(iTmpWidth);}
iUserInputs++;}}}
if(iColums==oHeaders.length&&iUserInputs===0&&iVisibleColumns==iColums&&oSettings.oScroll.sX===""&&oSettings.oScroll.sY==="")
{for(i=0;i<oSettings.aoColumns.length;i++)
{iTmpWidth=$(oHeaders[i]).width();if(iTmpWidth!==null)
{oSettings.aoColumns[i].sWidth=_fnStringToCss(iTmpWidth);}}}
else
{var
nCalcTmp=oSettings.nTable.cloneNode(false),nBody=document.createElement('tbody'),nTr=document.createElement('tr'),nDivSizing;nCalcTmp.removeAttribute("id");nCalcTmp.appendChild(oSettings.nTHead.cloneNode(true));if(oSettings.nTFoot!==null)
{nCalcTmp.appendChild(oSettings.nTFoot.cloneNode(true));_fnApplyToChildren(function(n){n.style.width="";},nCalcTmp.getElementsByTagName('tr'));}
nCalcTmp.appendChild(nBody);nBody.appendChild(nTr);var jqColSizing=$('thead th',nCalcTmp);if(jqColSizing.length===0)
{jqColSizing=$('tbody tr:eq(0)>td',nCalcTmp);}
jqColSizing.each(function(i){this.style.width="";var iIndex=_fnVisibleToColumnIndex(oSettings,i);if(iIndex!==null&&oSettings.aoColumns[iIndex].sWidthOrig!=="")
{this.style.width=oSettings.aoColumns[iIndex].sWidthOrig;}});for(i=0;i<iColums;i++)
{if(oSettings.aoColumns[i].bVisible)
{var nTd=_fnGetWidestNode(oSettings,i);if(nTd!==null)
{nTd=nTd.cloneNode(true);nTr.appendChild(nTd);}}}
var nWrapper=oSettings.nTable.parentNode;nWrapper.appendChild(nCalcTmp);if(oSettings.oScroll.sX!==""&&oSettings.oScroll.sXInner!=="")
{nCalcTmp.style.width=_fnStringToCss(oSettings.oScroll.sXInner);}
else if(oSettings.oScroll.sX!=="")
{nCalcTmp.style.width="";if($(nCalcTmp).width()<nWrapper.offsetWidth)
{nCalcTmp.style.width=_fnStringToCss(nWrapper.offsetWidth);}}
else if(oSettings.oScroll.sY!=="")
{nCalcTmp.style.width=_fnStringToCss(nWrapper.offsetWidth);}
nCalcTmp.style.visibility="hidden";_fnScrollingWidthAdjust(oSettings,nCalcTmp);var oNodes=$("tbody tr:eq(0)>td",nCalcTmp);if(oNodes.length===0)
{oNodes=$("thead tr:eq(0)>th",nCalcTmp);}
var iIndex,iCorrector=0,iWidth;for(i=0;i<oSettings.aoColumns.length;i++)
{if(oSettings.aoColumns[i].bVisible)
{iWidth=$(oNodes[iCorrector]).outerWidth();if(iWidth!==null&&iWidth>0)
{oSettings.aoColumns[i].sWidth=_fnStringToCss(iWidth);}
iCorrector++;}}
oSettings.nTable.style.width=_fnStringToCss($(nCalcTmp).outerWidth());nCalcTmp.parentNode.removeChild(nCalcTmp);}}
function _fnScrollingWidthAdjust(oSettings,n)
{if(oSettings.oScroll.sX===""&&oSettings.oScroll.sY!=="")
{var iOrigWidth=$(n).width();n.style.width=_fnStringToCss($(n).outerWidth()-oSettings.oScroll.iBarWidth);}
else if(oSettings.oScroll.sX!=="")
{n.style.width=_fnStringToCss($(n).outerWidth());}}
function _fnGetWidestNode(oSettings,iCol,bFast)
{if(typeof bFast=='undefined'||bFast)
{var iMaxLen=_fnGetMaxLenString(oSettings,iCol);var iFastVis=_fnColumnIndexToVisible(oSettings,iCol);if(iMaxLen<0)
{return null;}
return oSettings.aoData[iMaxLen].nTr.getElementsByTagName('td')[iFastVis];}
var
iMax=-1,i,iLen,iMaxIndex=-1,n=document.createElement('div');n.style.visibility="hidden";n.style.position="absolute";document.body.appendChild(n);for(i=0,iLen=oSettings.aoData.length;i<iLen;i++)
{n.innerHTML=oSettings.aoData[i]._aData[iCol];if(n.offsetWidth>iMax)
{iMax=n.offsetWidth;iMaxIndex=i;}}
document.body.removeChild(n);if(iMaxIndex>=0)
{var iVis=_fnColumnIndexToVisible(oSettings,iCol);var nRet=oSettings.aoData[iMaxIndex].nTr.getElementsByTagName('td')[iVis];if(nRet)
{return nRet;}}
return null;}
function _fnGetMaxLenString(oSettings,iCol)
{var iMax=-1;var iMaxIndex=-1;for(var i=0;i<oSettings.aoData.length;i++)
{var s=oSettings.aoData[i]._aData[iCol];if(s.length>iMax)
{iMax=s.length;iMaxIndex=i;}}
return iMaxIndex;}
function _fnStringToCss(s)
{if(s===null)
{return"0px";}
if(typeof s=='number')
{if(s<0)
{return"0px";}
return s+"px";}
var c=s.charCodeAt(s.length-1);if(c<0x30||c>0x39)
{return s;}
return s+"px";}
function _fnArrayCmp(aArray1,aArray2)
{if(aArray1.length!=aArray2.length)
{return 1;}
for(var i=0;i<aArray1.length;i++)
{if(aArray1[i]!=aArray2[i])
{return 2;}}
return 0;}
function _fnDetectType(sData)
{var aTypes=_oExt.aTypes;var iLen=aTypes.length;for(var i=0;i<iLen;i++)
{var sType=aTypes[i](sData);if(sType!==null)
{return sType;}}
return'string';}
function _fnSettingsFromNode(nTable)
{for(var i=0;i<_aoSettings.length;i++)
{if(_aoSettings[i].nTable==nTable)
{return _aoSettings[i];}}
return null;}
function _fnGetDataMaster(oSettings)
{var aData=[];var iLen=oSettings.aoData.length;for(var i=0;i<iLen;i++)
{aData.push(oSettings.aoData[i]._aData);}
return aData;}
function _fnGetTrNodes(oSettings)
{var aNodes=[];var iLen=oSettings.aoData.length;for(var i=0;i<iLen;i++)
{aNodes.push(oSettings.aoData[i].nTr);}
return aNodes;}
function _fnGetTdNodes(oSettings)
{var nTrs=_fnGetTrNodes(oSettings);var nTds=[],nTd;var anReturn=[];var iCorrector;var iRow,iRows,iColumn,iColumns;for(iRow=0,iRows=nTrs.length;iRow<iRows;iRow++)
{nTds=[];for(iColumn=0,iColumns=nTrs[iRow].childNodes.length;iColumn<iColumns;iColumn++)
{nTd=nTrs[iRow].childNodes[iColumn];if(nTd.nodeName.toUpperCase()=="TD")
{nTds.push(nTd);}}
iCorrector=0;for(iColumn=0,iColumns=oSettings.aoColumns.length;iColumn<iColumns;iColumn++)
{if(oSettings.aoColumns[iColumn].bVisible)
{anReturn.push(nTds[iColumn-iCorrector]);}
else
{anReturn.push(oSettings.aoData[iRow]._anHidden[iColumn]);iCorrector++;}}}
return anReturn;}
function _fnEscapeRegex(sVal)
{var acEscape=['/','.','*','+','?','|','(',')','[',']','{','}','\\','$','^'];var reReplace=new RegExp('(\\'+acEscape.join('|\\')+')','g');return sVal.replace(reReplace,'\\$1');}
function _fnDeleteIndex(a,iTarget)
{var iTargetIndex=-1;for(var i=0,iLen=a.length;i<iLen;i++)
{if(a[i]==iTarget)
{iTargetIndex=i;}
else if(a[i]>iTarget)
{a[i]--;}}
if(iTargetIndex!=-1)
{a.splice(iTargetIndex,1);}}
function _fnReOrderIndex(oSettings,sColumns)
{var aColumns=sColumns.split(',');var aiReturn=[];for(var i=0,iLen=oSettings.aoColumns.length;i<iLen;i++)
{for(var j=0;j<iLen;j++)
{if(oSettings.aoColumns[i].sName==aColumns[j])
{aiReturn.push(j);break;}}}
return aiReturn;}
function _fnColumnOrdering(oSettings)
{var sNames='';for(var i=0,iLen=oSettings.aoColumns.length;i<iLen;i++)
{sNames+=oSettings.aoColumns[i].sName+',';}
if(sNames.length==iLen)
{return"";}
return sNames.slice(0,-1);}
function _fnLog(oSettings,iLevel,sMesg)
{var sAlert=oSettings.sTableId===""?"DataTables warning: "+sMesg:"DataTables warning (table id = '"+oSettings.sTableId+"'): "+sMesg;if(iLevel===0)
{if(_oExt.sErrMode=='alert')
{alert(sAlert);}
else
{throw sAlert;}
return;}
else if(typeof console!='undefined'&&typeof console.log!='undefined')
{console.log(sAlert);}}
function _fnClearTable(oSettings)
{oSettings.aoData.splice(0,oSettings.aoData.length);oSettings.aiDisplayMaster.splice(0,oSettings.aiDisplayMaster.length);oSettings.aiDisplay.splice(0,oSettings.aiDisplay.length);_fnCalculateEnd(oSettings);}
function _fnSaveState(oSettings)
{if(!oSettings.oFeatures.bStateSave||typeof oSettings.bDestroying!='undefined')
{return;}
var i,iLen,sTmp;var sValue="{";sValue+='"iCreate":'+new Date().getTime()+',';sValue+='"iStart":'+oSettings._iDisplayStart+',';sValue+='"iEnd":'+oSettings._iDisplayEnd+',';sValue+='"iLength":'+oSettings._iDisplayLength+',';sValue+='"sFilter":"'+encodeURIComponent(oSettings.oPreviousSearch.sSearch)+'",';sValue+='"sFilterEsc":'+!oSettings.oPreviousSearch.bRegex+',';sValue+='"aaSorting":[ ';for(i=0;i<oSettings.aaSorting.length;i++)
{sValue+='['+oSettings.aaSorting[i][0]+',"'+oSettings.aaSorting[i][1]+'"],';}
sValue=sValue.substring(0,sValue.length-1);sValue+="],";sValue+='"aaSearchCols":[ ';for(i=0;i<oSettings.aoPreSearchCols.length;i++)
{sValue+='["'+encodeURIComponent(oSettings.aoPreSearchCols[i].sSearch)+
'",'+!oSettings.aoPreSearchCols[i].bRegex+'],';}
sValue=sValue.substring(0,sValue.length-1);sValue+="],";sValue+='"abVisCols":[ ';for(i=0;i<oSettings.aoColumns.length;i++)
{sValue+=oSettings.aoColumns[i].bVisible+",";}
sValue=sValue.substring(0,sValue.length-1);sValue+="]";for(i=0,iLen=oSettings.aoStateSave.length;i<iLen;i++)
{sTmp=oSettings.aoStateSave[i].fn(oSettings,sValue);if(sTmp!=="")
{sValue=sTmp;}}
sValue+="}";_fnCreateCookie(oSettings.sCookiePrefix+oSettings.sInstance,sValue,oSettings.iCookieDuration,oSettings.sCookiePrefix,oSettings.fnCookieCallback);}
function _fnLoadState(oSettings,oInit)
{if(!oSettings.oFeatures.bStateSave)
{return;}
var oData,i,iLen;var sData=_fnReadCookie(oSettings.sCookiePrefix+oSettings.sInstance);if(sData!==null&&sData!=='')
{try
{oData=(typeof $.parseJSON=='function')?$.parseJSON(sData.replace(/'/g,'"')):eval('('+sData+')');}
catch(e)
{return;}
for(i=0,iLen=oSettings.aoStateLoad.length;i<iLen;i++)
{if(!oSettings.aoStateLoad[i].fn(oSettings,oData))
{return;}}
oSettings.oLoadedState=$.extend(true,{},oData);oSettings._iDisplayStart=oData.iStart;oSettings.iInitDisplayStart=oData.iStart;oSettings._iDisplayEnd=oData.iEnd;oSettings._iDisplayLength=oData.iLength;oSettings.oPreviousSearch.sSearch=decodeURIComponent(oData.sFilter);oSettings.aaSorting=oData.aaSorting.slice();oSettings.saved_aaSorting=oData.aaSorting.slice();if(typeof oData.sFilterEsc!='undefined')
{oSettings.oPreviousSearch.bRegex=!oData.sFilterEsc;}
if(typeof oData.aaSearchCols!='undefined')
{for(i=0;i<oData.aaSearchCols.length;i++)
{oSettings.aoPreSearchCols[i]={"sSearch":decodeURIComponent(oData.aaSearchCols[i][0]),"bRegex":!oData.aaSearchCols[i][1]};}}
if(typeof oData.abVisCols!='undefined')
{oInit.saved_aoColumns=[];for(i=0;i<oData.abVisCols.length;i++)
{oInit.saved_aoColumns[i]={};oInit.saved_aoColumns[i].bVisible=oData.abVisCols[i];}}}}
function _fnCreateCookie(sName,sValue,iSecs,sBaseName,fnCallback)
{var date=new Date();date.setTime(date.getTime()+(iSecs*1000));var aParts=window.location.pathname.split('/');var sNameFile=sName+'_'+aParts.pop().replace(/[\/:]/g,"").toLowerCase();var sFullCookie,oData;if(fnCallback!==null)
{oData=(typeof $.parseJSON=='function')?$.parseJSON(sValue):eval('('+sValue+')');sFullCookie=fnCallback(sNameFile,oData,date.toGMTString(),aParts.join('/')+"/");}
else
{sFullCookie=sNameFile+"="+encodeURIComponent(sValue)+
"; expires="+date.toGMTString()+"; path="+aParts.join('/')+"/";}
var sOldName="",iOldTime=9999999999999;var iLength=_fnReadCookie(sNameFile)!==null?document.cookie.length:sFullCookie.length+document.cookie.length;if(iLength+10>4096)
{var aCookies=document.cookie.split(';');for(var i=0,iLen=aCookies.length;i<iLen;i++)
{if(aCookies[i].indexOf(sBaseName)!=-1)
{var aSplitCookie=aCookies[i].split('=');try{oData=eval('('+decodeURIComponent(aSplitCookie[1])+')');}
catch(e){continue;}
if(typeof oData.iCreate!='undefined'&&oData.iCreate<iOldTime)
{sOldName=aSplitCookie[0];iOldTime=oData.iCreate;}}}
if(sOldName!=="")
{document.cookie=sOldName+"=; expires=Thu, 01-Jan-1970 00:00:01 GMT; path="+
aParts.join('/')+"/";}}
document.cookie=sFullCookie;}
function _fnReadCookie(sName)
{var
aParts=window.location.pathname.split('/'),sNameEQ=sName+'_'+aParts[aParts.length-1].replace(/[\/:]/g,"").toLowerCase()+'=',sCookieContents=document.cookie.split(';');for(var i=0;i<sCookieContents.length;i++)
{var c=sCookieContents[i];while(c.charAt(0)==' ')
{c=c.substring(1,c.length);}
if(c.indexOf(sNameEQ)===0)
{return decodeURIComponent(c.substring(sNameEQ.length,c.length));}}
return null;}
function _fnGetUniqueThs(nThead)
{var nTrs=nThead.getElementsByTagName('tr');if(nTrs.length==1)
{return nTrs[0].getElementsByTagName('th');}
var aLayout=[],aReturn=[];var ROWSPAN=2,COLSPAN=3,TDELEM=4;var i,j,k,iLen,jLen,iColumnShifted;var fnShiftCol=function(a,i,j){while(typeof a[i][j]!='undefined'){j++;}
return j;};var fnAddRow=function(i){if(typeof aLayout[i]=='undefined'){aLayout[i]=[];}};for(i=0,iLen=nTrs.length;i<iLen;i++)
{fnAddRow(i);var iColumn=0;var nTds=[];for(j=0,jLen=nTrs[i].childNodes.length;j<jLen;j++)
{if(nTrs[i].childNodes[j].nodeName.toUpperCase()=="TD"||nTrs[i].childNodes[j].nodeName.toUpperCase()=="TH")
{nTds.push(nTrs[i].childNodes[j]);}}
for(j=0,jLen=nTds.length;j<jLen;j++)
{var iColspan=nTds[j].getAttribute('colspan')*1;var iRowspan=nTds[j].getAttribute('rowspan')*1;if(!iColspan||iColspan===0||iColspan===1)
{iColumnShifted=fnShiftCol(aLayout,i,iColumn);aLayout[i][iColumnShifted]=(nTds[j].nodeName.toUpperCase()=="TD")?TDELEM:nTds[j];if(iRowspan||iRowspan===0||iRowspan===1)
{for(k=1;k<iRowspan;k++)
{fnAddRow(i+k);aLayout[i+k][iColumnShifted]=ROWSPAN;}}
iColumn++;}
else
{iColumnShifted=fnShiftCol(aLayout,i,iColumn);for(k=0;k<iColspan;k++)
{aLayout[i][iColumnShifted+k]=COLSPAN;}
iColumn+=iColspan;}}}
for(i=0,iLen=aLayout.length;i<iLen;i++)
{for(j=0,jLen=aLayout[i].length;j<jLen;j++)
{if(typeof aLayout[i][j]=='object'&&typeof aReturn[j]=='undefined')
{aReturn[j]=aLayout[i][j];}}}
return aReturn;}
function _fnScrollBarWidth()
{var inner=document.createElement('p');var style=inner.style;style.width="100%";style.height="200px";var outer=document.createElement('div');style=outer.style;style.position="absolute";style.top="0px";style.left="0px";style.visibility="hidden";style.width="200px";style.height="150px";style.overflow="hidden";outer.appendChild(inner);document.body.appendChild(outer);var w1=inner.offsetWidth;outer.style.overflow='scroll';var w2=inner.offsetWidth;if(w1==w2)
{w2=outer.clientWidth;}
document.body.removeChild(outer);return(w1-w2);}
function _fnApplyToChildren(fn,an1,an2)
{for(var i=0,iLen=an1.length;i<iLen;i++)
{for(var j=0,jLen=an1[i].childNodes.length;j<jLen;j++)
{if(an1[i].childNodes[j].nodeType==1)
{if(typeof an2!='undefined')
{fn(an1[i].childNodes[j],an2[i].childNodes[j]);}
else
{fn(an1[i].childNodes[j]);}}}}}
function _fnMap(oRet,oSrc,sName,sMappedName)
{if(typeof sMappedName=='undefined')
{sMappedName=sName;}
if(typeof oSrc[sName]!='undefined')
{oRet[sMappedName]=oSrc[sName];}}
this.oApi._fnExternApiFunc=_fnExternApiFunc;this.oApi._fnInitalise=_fnInitalise;this.oApi._fnLanguageProcess=_fnLanguageProcess;this.oApi._fnAddColumn=_fnAddColumn;this.oApi._fnColumnOptions=_fnColumnOptions;this.oApi._fnAddData=_fnAddData;this.oApi._fnGatherData=_fnGatherData;this.oApi._fnDrawHead=_fnDrawHead;this.oApi._fnDraw=_fnDraw;this.oApi._fnReDraw=_fnReDraw;this.oApi._fnAjaxUpdate=_fnAjaxUpdate;this.oApi._fnAjaxUpdateDraw=_fnAjaxUpdateDraw;this.oApi._fnAddOptionsHtml=_fnAddOptionsHtml;this.oApi._fnFeatureHtmlTable=_fnFeatureHtmlTable;this.oApi._fnScrollDraw=_fnScrollDraw;this.oApi._fnAjustColumnSizing=_fnAjustColumnSizing;this.oApi._fnFeatureHtmlFilter=_fnFeatureHtmlFilter;this.oApi._fnFilterComplete=_fnFilterComplete;this.oApi._fnFilterCustom=_fnFilterCustom;this.oApi._fnFilterColumn=_fnFilterColumn;this.oApi._fnFilter=_fnFilter;this.oApi._fnBuildSearchArray=_fnBuildSearchArray;this.oApi._fnBuildSearchRow=_fnBuildSearchRow;this.oApi._fnFilterCreateSearch=_fnFilterCreateSearch;this.oApi._fnDataToSearch=_fnDataToSearch;this.oApi._fnSort=_fnSort;this.oApi._fnSortAttachListener=_fnSortAttachListener;this.oApi._fnSortingClasses=_fnSortingClasses;this.oApi._fnFeatureHtmlPaginate=_fnFeatureHtmlPaginate;this.oApi._fnPageChange=_fnPageChange;this.oApi._fnFeatureHtmlInfo=_fnFeatureHtmlInfo;this.oApi._fnUpdateInfo=_fnUpdateInfo;this.oApi._fnFeatureHtmlLength=_fnFeatureHtmlLength;this.oApi._fnFeatureHtmlProcessing=_fnFeatureHtmlProcessing;this.oApi._fnProcessingDisplay=_fnProcessingDisplay;this.oApi._fnVisibleToColumnIndex=_fnVisibleToColumnIndex;this.oApi._fnColumnIndexToVisible=_fnColumnIndexToVisible;this.oApi._fnNodeToDataIndex=_fnNodeToDataIndex;this.oApi._fnVisbleColumns=_fnVisbleColumns;this.oApi._fnCalculateEnd=_fnCalculateEnd;this.oApi._fnConvertToWidth=_fnConvertToWidth;this.oApi._fnCalculateColumnWidths=_fnCalculateColumnWidths;this.oApi._fnScrollingWidthAdjust=_fnScrollingWidthAdjust;this.oApi._fnGetWidestNode=_fnGetWidestNode;this.oApi._fnGetMaxLenString=_fnGetMaxLenString;this.oApi._fnStringToCss=_fnStringToCss;this.oApi._fnArrayCmp=_fnArrayCmp;this.oApi._fnDetectType=_fnDetectType;this.oApi._fnSettingsFromNode=_fnSettingsFromNode;this.oApi._fnGetDataMaster=_fnGetDataMaster;this.oApi._fnGetTrNodes=_fnGetTrNodes;this.oApi._fnGetTdNodes=_fnGetTdNodes;this.oApi._fnEscapeRegex=_fnEscapeRegex;this.oApi._fnDeleteIndex=_fnDeleteIndex;this.oApi._fnReOrderIndex=_fnReOrderIndex;this.oApi._fnColumnOrdering=_fnColumnOrdering;this.oApi._fnLog=_fnLog;this.oApi._fnClearTable=_fnClearTable;this.oApi._fnSaveState=_fnSaveState;this.oApi._fnLoadState=_fnLoadState;this.oApi._fnCreateCookie=_fnCreateCookie;this.oApi._fnReadCookie=_fnReadCookie;this.oApi._fnGetUniqueThs=_fnGetUniqueThs;this.oApi._fnScrollBarWidth=_fnScrollBarWidth;this.oApi._fnApplyToChildren=_fnApplyToChildren;this.oApi._fnMap=_fnMap;var _that=this;return this.each(function()
{var i=0,iLen,j,jLen,k,kLen;for(i=0,iLen=_aoSettings.length;i<iLen;i++)
{if(_aoSettings[i].nTable==this)
{if(typeof oInit=='undefined'||(typeof oInit.bRetrieve!='undefined'&&oInit.bRetrieve===true))
{return _aoSettings[i].oInstance;}
else if(typeof oInit.bDestroy!='undefined'&&oInit.bDestroy===true)
{_aoSettings[i].oInstance.fnDestroy();break;}
else
{_fnLog(_aoSettings[i],0,"Cannot reinitialise DataTable.\n\n"+
"To retrieve the DataTables object for this table, please pass either no arguments "+
"to the dataTable() function, or set bRetrieve to true. Alternatively, to destory "+
"the old table and create a new one, set bDestroy to true (note that a lot of "+
"changes to the configuration can be made through the API which is usually much "+
"faster).");return;}}
if(_aoSettings[i].sTableId!==""&&_aoSettings[i].sTableId==this.getAttribute('id'))
{_aoSettings.splice(i,1);break;}}
var oSettings=new classSettings();_aoSettings.push(oSettings);var bInitHandedOff=false;var bUsePassedData=false;var sId=this.getAttribute('id');if(sId!==null)
{oSettings.sTableId=sId;oSettings.sInstance=sId;}
else
{oSettings.sInstance=_oExt._oExternConfig.iNextUnique++;}
if(this.nodeName.toLowerCase()!='table')
{_fnLog(oSettings,0,"Attempted to initialise DataTables on a node which is not a "+
"table: "+this.nodeName);return;}
oSettings.nTable=this;oSettings.oInstance=_that.length==1?_that:$(this).dataTable();oSettings.oApi=_that.oApi;oSettings.sDestroyWidth=$(this).width();if(typeof oInit!='undefined'&&oInit!==null)
{oSettings.oInit=oInit;_fnMap(oSettings.oFeatures,oInit,"bPaginate");_fnMap(oSettings.oFeatures,oInit,"bLengthChange");_fnMap(oSettings.oFeatures,oInit,"bFilter");_fnMap(oSettings.oFeatures,oInit,"bSort");_fnMap(oSettings.oFeatures,oInit,"bInfo");_fnMap(oSettings.oFeatures,oInit,"bProcessing");_fnMap(oSettings.oFeatures,oInit,"bAutoWidth");_fnMap(oSettings.oFeatures,oInit,"bSortClasses");_fnMap(oSettings.oFeatures,oInit,"bServerSide");_fnMap(oSettings.oScroll,oInit,"sScrollX","sX");_fnMap(oSettings.oScroll,oInit,"sScrollXInner","sXInner");_fnMap(oSettings.oScroll,oInit,"sScrollY","sY");_fnMap(oSettings.oScroll,oInit,"bScrollCollapse","bCollapse");_fnMap(oSettings.oScroll,oInit,"bScrollInfinite","bInfinite");_fnMap(oSettings.oScroll,oInit,"iScrollLoadGap","iLoadGap");_fnMap(oSettings.oScroll,oInit,"bScrollAutoCss","bAutoCss");_fnMap(oSettings,oInit,"asStripClasses");_fnMap(oSettings,oInit,"fnRowCallback");_fnMap(oSettings,oInit,"fnHeaderCallback");_fnMap(oSettings,oInit,"fnFooterCallback");_fnMap(oSettings,oInit,"fnCookieCallback");_fnMap(oSettings,oInit,"fnInitComplete");_fnMap(oSettings,oInit,"fnServerData");_fnMap(oSettings,oInit,"fnFormatNumber");_fnMap(oSettings,oInit,"aaSorting");_fnMap(oSettings,oInit,"aaSortingFixed");_fnMap(oSettings,oInit,"aLengthMenu");_fnMap(oSettings,oInit,"sPaginationType");_fnMap(oSettings,oInit,"sAjaxSource");_fnMap(oSettings,oInit,"iCookieDuration");_fnMap(oSettings,oInit,"sCookiePrefix");_fnMap(oSettings,oInit,"sDom");_fnMap(oSettings,oInit,"oSearch","oPreviousSearch");_fnMap(oSettings,oInit,"aoSearchCols","aoPreSearchCols");_fnMap(oSettings,oInit,"iDisplayLength","_iDisplayLength");_fnMap(oSettings,oInit,"bJQueryUI","bJUI");_fnMap(oSettings.oLanguage,oInit,"fnInfoCallback");if(typeof oInit.fnDrawCallback=='function')
{oSettings.aoDrawCallback.push({"fn":oInit.fnDrawCallback,"sName":"user"});}
if(typeof oInit.fnStateSaveCallback=='function')
{oSettings.aoStateSave.push({"fn":oInit.fnStateSaveCallback,"sName":"user"});}
if(typeof oInit.fnStateLoadCallback=='function')
{oSettings.aoStateLoad.push({"fn":oInit.fnStateLoadCallback,"sName":"user"});}
if(oSettings.oFeatures.bServerSide&&oSettings.oFeatures.bSort&&oSettings.oFeatures.bSortClasses)
{oSettings.aoDrawCallback.push({"fn":_fnSortingClasses,"sName":"server_side_sort_classes"});}
if(typeof oInit.bJQueryUI!='undefined'&&oInit.bJQueryUI)
{oSettings.oClasses=_oExt.oJUIClasses;if(typeof oInit.sDom=='undefined')
{oSettings.sDom='<"H"lfr>t<"F"ip>';}}
if(oSettings.oScroll.sX!==""||oSettings.oScroll.sY!=="")
{oSettings.oScroll.iBarWidth=_fnScrollBarWidth();}
if(typeof oInit.iDisplayStart!='undefined'&&typeof oSettings.iInitDisplayStart=='undefined')
{oSettings.iInitDisplayStart=oInit.iDisplayStart;oSettings._iDisplayStart=oInit.iDisplayStart;}
if(typeof oInit.bStateSave!='undefined')
{oSettings.oFeatures.bStateSave=oInit.bStateSave;_fnLoadState(oSettings,oInit);oSettings.aoDrawCallback.push({"fn":_fnSaveState,"sName":"state_save"});}
if(typeof oInit.aaData!='undefined')
{bUsePassedData=true;}
if(typeof oInit!='undefined'&&typeof oInit.aoData!='undefined')
{oInit.aoColumns=oInit.aoData;}
if(typeof oInit.oLanguage!='undefined')
{if(typeof oInit.oLanguage.sUrl!='undefined'&&oInit.oLanguage.sUrl!=="")
{oSettings.oLanguage.sUrl=oInit.oLanguage.sUrl;$.getJSON(oSettings.oLanguage.sUrl,null,function(json){_fnLanguageProcess(oSettings,json,true);});bInitHandedOff=true;}
else
{_fnLanguageProcess(oSettings,oInit.oLanguage,false);}}
}
else
{oInit={};}
if(typeof oInit.asStripClasses=='undefined')
{oSettings.asStripClasses.push(oSettings.oClasses.sStripOdd);oSettings.asStripClasses.push(oSettings.oClasses.sStripEven);}
var bStripeRemove=false;var anRows=$('>tbody>tr',this);for(i=0,iLen=oSettings.asStripClasses.length;i<iLen;i++)
{if(anRows.filter(":lt(2)").hasClass(oSettings.asStripClasses[i]))
{bStripeRemove=true;break;}}
if(bStripeRemove)
{oSettings.asDestoryStrips=['',''];if($(anRows[0]).hasClass(oSettings.oClasses.sStripOdd))
{oSettings.asDestoryStrips[0]+=oSettings.oClasses.sStripOdd+" ";}
if($(anRows[0]).hasClass(oSettings.oClasses.sStripEven))
{oSettings.asDestoryStrips[0]+=oSettings.oClasses.sStripEven;}
if($(anRows[1]).hasClass(oSettings.oClasses.sStripOdd))
{oSettings.asDestoryStrips[1]+=oSettings.oClasses.sStripOdd+" ";}
if($(anRows[1]).hasClass(oSettings.oClasses.sStripEven))
{oSettings.asDestoryStrips[1]+=oSettings.oClasses.sStripEven;}
anRows.removeClass(oSettings.asStripClasses.join(' '));}
var nThead=this.getElementsByTagName('thead');var anThs=nThead.length===0?[]:_fnGetUniqueThs(nThead[0]);var aoColumnsInit;if(typeof oInit.aoColumns=='undefined')
{aoColumnsInit=[];for(i=0,iLen=anThs.length;i<iLen;i++)
{aoColumnsInit.push(null);}}
else
{aoColumnsInit=oInit.aoColumns;}
for(i=0,iLen=aoColumnsInit.length;i<iLen;i++)
{if(typeof oInit.saved_aoColumns!='undefined'&&oInit.saved_aoColumns.length==iLen)
{if(aoColumnsInit[i]===null)
{aoColumnsInit[i]={};}
aoColumnsInit[i].bVisible=oInit.saved_aoColumns[i].bVisible;}
_fnAddColumn(oSettings,anThs?anThs[i]:null);}
if(typeof oInit.aoColumnDefs!='undefined')
{for(i=oInit.aoColumnDefs.length-1;i>=0;i--)
{var aTargets=oInit.aoColumnDefs[i].aTargets;if(!$.isArray(aTargets))
{_fnLog(oSettings,1,'aTargets must be an array of targets, not a '+(typeof aTargets));}
for(j=0,jLen=aTargets.length;j<jLen;j++)
{if(typeof aTargets[j]=='number'&&aTargets[j]>=0)
{while(oSettings.aoColumns.length<=aTargets[j])
{_fnAddColumn(oSettings);}
_fnColumnOptions(oSettings,aTargets[j],oInit.aoColumnDefs[i]);}
else if(typeof aTargets[j]=='number'&&aTargets[j]<0)
{_fnColumnOptions(oSettings,oSettings.aoColumns.length+aTargets[j],oInit.aoColumnDefs[i]);}
else if(typeof aTargets[j]=='string')
{for(k=0,kLen=oSettings.aoColumns.length;k<kLen;k++)
{if(aTargets[j]=="_all"||oSettings.aoColumns[k].nTh.className.indexOf(aTargets[j])!=-1)
{_fnColumnOptions(oSettings,k,oInit.aoColumnDefs[i]);}}}}}}
if(typeof aoColumnsInit!='undefined')
{for(i=0,iLen=aoColumnsInit.length;i<iLen;i++)
{_fnColumnOptions(oSettings,i,aoColumnsInit[i]);}}
for(i=0,iLen=oSettings.aaSorting.length;i<iLen;i++)
{if(oSettings.aaSorting[i][0]>=oSettings.aoColumns.length)
{oSettings.aaSorting[i][0]=0;}
var oColumn=oSettings.aoColumns[oSettings.aaSorting[i][0]];if(typeof oSettings.aaSorting[i][2]=='undefined')
{oSettings.aaSorting[i][2]=0;}
if(typeof oInit.aaSorting=="undefined"&&typeof oSettings.saved_aaSorting=="undefined")
{oSettings.aaSorting[i][1]=oColumn.asSorting[0];}
for(j=0,jLen=oColumn.asSorting.length;j<jLen;j++)
{if(oSettings.aaSorting[i][1]==oColumn.asSorting[j])
{oSettings.aaSorting[i][2]=j;break;}}}
_fnSortingClasses(oSettings);if(this.getElementsByTagName('thead').length===0)
{this.appendChild(document.createElement('thead'));}
if(this.getElementsByTagName('tbody').length===0)
{this.appendChild(document.createElement('tbody'));}
oSettings.nTHead=this.getElementsByTagName('thead')[0];oSettings.nTBody=this.getElementsByTagName('tbody')[0];if(this.getElementsByTagName('tfoot').length>0)
{oSettings.nTFoot=this.getElementsByTagName('tfoot')[0];}
if(bUsePassedData)
{for(i=0;i<oInit.aaData.length;i++)
{_fnAddData(oSettings,oInit.aaData[i]);}}
else
{_fnGatherData(oSettings);}
oSettings.aiDisplay=oSettings.aiDisplayMaster.slice();oSettings.bInitialised=true;if(bInitHandedOff===false)
{_fnInitalise(oSettings);}});};})(jQuery,window,document);;(function($){var helper={},current,title,tID,IE=$.browser.msie&&/MSIE\s(5\.5|6\.)/.test(navigator.userAgent),track=false;$.tooltip={blocked:false,defaults:{delay:200,fade:false,showURL:true,extraClass:"",top:15,left:15,id:"tooltip"},block:function(){$.tooltip.blocked=!$.tooltip.blocked;}};$.fn.extend({tooltip:function(settings){settings=$.extend({},$.tooltip.defaults,settings);createHelper(settings);return this.each(function(){$.data(this,"tooltip",settings);this.tOpacity=helper.parent.css("opacity");this.tooltipText=this.title;$(this).removeAttr("title");this.alt="";}).mouseover(save).mouseout(hide).click(hide);},fixPNG:IE?function(){return this.each(function(){var image=$(this).css('backgroundImage');if(image.match(/^url\(["']?(.*\.png)["']?\)$/i)){image=RegExp.$1;$(this).css({'backgroundImage':'none','filter':"progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, sizingMethod=crop, src='"+image+"')"}).each(function(){var position=$(this).css('position');if(position!='absolute'&&position!='relative')$(this).css('position','relative');});}});}:function(){return this;},unfixPNG:IE?function(){return this.each(function(){$(this).css({'filter':'',backgroundImage:''});});}:function(){return this;},hideWhenEmpty:function(){return this.each(function(){$(this)[$(this).html()?"show":"hide"]();});},url:function(){return this.attr('href')||this.attr('src');}});function createHelper(settings){if(helper.parent)return;helper.parent=$('<div id="'+settings.id+'"><h3></h3><div class="body"></div><div class="url"></div></div>').appendTo(document.body).hide();if($.fn.bgiframe)helper.parent.bgiframe();helper.title=$('h3',helper.parent);helper.body=$('div.body',helper.parent);helper.url=$('div.url',helper.parent);}function settings(element){return $.data(element,"tooltip");}function handle(event){if(settings(this).delay)tID=setTimeout(show,settings(this).delay);else
show();track=!!settings(this).track;$(document.body).bind('mousemove',update);update(event);}function save(){if($.tooltip.blocked||this==current||(!this.tooltipText&&!settings(this).bodyHandler))return;current=this;title=this.tooltipText;if(settings(this).bodyHandler){helper.title.hide();var bodyContent=settings(this).bodyHandler.call(this);if(bodyContent.nodeType||bodyContent.jquery){helper.body.empty().append(bodyContent)}else{helper.body.html(bodyContent);}helper.body.show();}else if(settings(this).showBody){var parts=title.split(settings(this).showBody);helper.title.html(parts.shift()).show();helper.body.empty();for(var i=0,part;(part=parts[i]);i++){if(i>0)helper.body.append("<br/>");helper.body.append(part);}helper.body.hideWhenEmpty();}else{helper.title.html(title).show();helper.body.hide();}if(settings(this).showURL&&$(this).url())helper.url.html($(this).url().replace('http://','')).show();else
helper.url.hide();helper.parent.addClass(settings(this).extraClass);if(settings(this).fixPNG)helper.parent.fixPNG();handle.apply(this,arguments);}function show(){tID=null;if((!IE||!$.fn.bgiframe)&&settings(current).fade){if(helper.parent.is(":animated"))helper.parent.stop().show().fadeTo(settings(current).fade,current.tOpacity);else
helper.parent.is(':visible')?helper.parent.fadeTo(settings(current).fade,current.tOpacity):helper.parent.fadeIn(settings(current).fade);}else{helper.parent.show();}update();}function update(event){if($.tooltip.blocked)return;if(event&&event.target.tagName=="OPTION"){return;}if(!track&&helper.parent.is(":visible")){$(document.body).unbind('mousemove',update)}if(current==null){$(document.body).unbind('mousemove',update);return;}helper.parent.removeClass("viewport-right").removeClass("viewport-bottom");var left=helper.parent[0].offsetLeft;var top=helper.parent[0].offsetTop;if(event){left=event.pageX+settings(current).left;top=event.pageY+settings(current).top;var right='auto';if(settings(current).positionLeft){right=$(window).width()-left;left='auto';}helper.parent.css({left:left,right:right,top:top});}var v=viewport(),h=helper.parent[0];if(v.x+v.cx<h.offsetLeft+h.offsetWidth){left-=h.offsetWidth+20+settings(current).left;helper.parent.css({left:left+'px'}).addClass("viewport-right");}if(v.y+v.cy<h.offsetTop+h.offsetHeight){top-=h.offsetHeight+20+settings(current).top;helper.parent.css({top:top+'px'}).addClass("viewport-bottom");}}function viewport(){return{x:$(window).scrollLeft(),y:$(window).scrollTop(),cx:$(window).width(),cy:$(window).height()};}function hide(event){if($.tooltip.blocked)return;if(tID)clearTimeout(tID);current=null;var tsettings=settings(this);function complete(){helper.parent.removeClass(tsettings.extraClass).hide().css("opacity","");}if((!IE||!$.fn.bgiframe)&&tsettings.fade){if(helper.parent.is(':animated'))helper.parent.stop().fadeTo(tsettings.fade,0,complete);else
helper.parent.stop().fadeOut(tsettings.fade,complete);}else
complete();if(settings(this).fixPNG)helper.parent.unfixPNG();}})(jQuery);var ancla="";function buttonPost(button_id){$('#'+button_id).addClass("disabled");$('#'+button_id).text(GUARDANDO+"...");}
function refreshMeranPage(){location.reload(true);}
function crearAncla(id,strAncla){if(!$("#"+strAncla)){new Insertion.Before(id,"<a id="+strAncla+" name="+strAncla
+"></a>");}
ancla="#"+strAncla;}
function delay(funcion,segundos){setTimeout(funcion,segundos*1000);}
function fancybox(id){$('#'+id).fancybox();}
function crearForm(url,params){var arrayParam=params.split("&");var formu=$("#formulario");var inputs="";for(var i=0;i<arrayParam.length;i++){var nombre=arrayParam[i].split("=")[0];var valor=arrayParam[i].split("=")[1];inputs=inputs+"<input type='hidden' name="+nombre+" value="
+valor+"><br>";}
inputs=inputs+"<input type='hidden' name='token' value="+token
+"><br>";formu.html("<form id='miForm' action="+url+" method='post'>"+inputs
+"</form>");$("#miForm")[0].submit();}
function zebra(classObj){}
function zebraList(classObj){$("."+classObj+" li:gt(0):odd").addClass("impar");$("."+classObj+" li:gt(0):even").addClass("par");}
function zebraId(idObj){$("#"+idObj+" tr:gt(0):odd").addClass("impar");$("#"+idObj+" tr:gt(0):even").addClass("par");}
function tomarTiempo(){var currentTime=new Date()
var hours=currentTime.getHours()
var minutes=currentTime.getMinutes()
var seconds=currentTime.getSeconds();if(minutes<10)
minutes="0"+minutes
if(seconds<10)
seconds="0"+seconds;return hours+":"+minutes+" "+" "+seconds;}
function checkedAll(id,nombreCheckbox){$("#"+id).toggle(function(){$("input[name="+nombreCheckbox+"]").each(function(){this.checked=true;$(this).parent().parent().addClass("marked");$(this).parent().parent().children().each(function(){$(this).addClass("marked");});})},function(){$("input[name="+nombreCheckbox+"]").each(function(){this.checked=false;$(this).parent().parent().removeClass("marked");$(this).parent().parent().children().each(function(){$(this).removeClass("marked");});})});}
function recuperarSeleccionados(chckbox){var chck=$("input[name="+chckbox+"]:checked");var array=new Array;var long=chck.length;for(var i=0;i<long;i++){array[i]=chck[i].value;}
return array;}
function checkedAllById(id){$("#"+id+" input[type='checkbox']").each(function(){this.checked=!this.checked;});}
function onEnter(idInput,funcion,param){var result_array=$("#"+idInput);if(result_array.length==0)
return;$("#"+idInput).keypress(function(e){if(e.which==13){if(this.value!=''){if(param)
funcion(param);else
funcion();}}});}
function registrarKeypress(typeObject){var componentes=["input","INPUT"];var bool1=componentes[0]==typeObject;var bool2=componentes[1]==typeObject;var result=bool1||bool2;if(result==-1)
return;$(typeObject).keypress(function(e){if(e.which==13){if(this.value!=''){buscar();}}});}
function scrollTo(idObj){var result_array=$("#"+idObj);if(result_array.length==0)
return;var divOffset=$('#'+idObj).offset().top-110;$('html,body').animate({scrollTop:divOffset},200);}
function getRadioButtonSelectedValue(ctrl){for(i=0;i<ctrl.length;i++)
if(ctrl[i].checked)
return ctrl[i].value;}
function highlight(classesArray,idKeywordsArray){for(x=0;x<idKeywordsArray.length;x++){stringArray=($('#'+idKeywordsArray[x]).val()).split(' ');for(y=0;y<stringArray.length;y++){if($.trim(stringArray[y]).length!=0){for(z=0;z<classesArray.length;z++){$('.'+classesArray[z]).highlight(stringArray[y]);}}}}}
function toggle_ayuda_in_line(){$("#ayuda").click(function(){$("#ayuda_in_line").toggle("slow");});}
function toggle_component(id_componente,container_class){$("#"+id_componente).toggle(function(){$(this).addClass("active");},function(){$(this).removeClass("active");});$("#"+id_componente).click(function(){$("#"+container_class).slideToggle("fast");});}
function esBrowser(browser){browser=browser.toLowerCase();ok=false;jQuery.each(jQuery.browser,function(i,val){if((val)&&(i==browser))
ok=true;});return(ok);}
function makeToggle(container_class,trigger,afterToggleFunction,hide){if(hide)
$("."+container_class).hide();$("legend."+trigger).toggle(function(){if(afterToggleFunction!=null)
afterToggleFunction();$(this).addClass("active");},function(){$(this).removeClass("active");});$("legend."+trigger).click(function(){$(this).next("."+container_class).slideToggle("fast");});}
function makeDataTable(id){try{$(id).dataTable({"bFilter":true,"bPaginate":false,"bDestroy":true,"oLanguage":{"sLengthMenu":S_LENGTH_MENU,"sZeroRecords":S_ZERO_RECORDS,"sInfo":S_INFO,"sInfoEmpty":S_INFO_EMPTY,"sInfoFiltered":S_INFO_FILTERED,"sSearch":S_SEARCH,}});}catch(e){}}
function changePage(ini){objAH.changePage(ini);}
function registrarTooltips(){$('input[type=text]').tooltip({track:true,});$('a').tooltip({showURL:false,track:true,});$('li').tooltip({showURL:false,track:true,});$('tr td').tooltip({showURL:false,track:true,});$('select option').tooltip({track:true,delay:0,showURL:false,opacity:1,fixPNG:true,showBody:" - ",extraClass:"pretty fancy",top:-15,left:5});}
function print_objetc(o){for(property in o){alert(property);}}
function copy(o){var newO=new Object();for(property in o){newO[property]=o[property];}
return newO;}
function log(string){if(window.console){window.console.log(string);}}
function replaceAccents(s){var r=s.toLowerCase();r=r.replace(new RegExp(/\s/g),"");r=r.replace(new RegExp(/[àáâãäå]/g),"a");r=r.replace(new RegExp(/æ/g),"ae");r=r.replace(new RegExp(/ç/g),"c");r=r.replace(new RegExp(/[èéêë]/g),"e");r=r.replace(new RegExp(/[ìíîï]/g),"i");r=r.replace(new RegExp(/ñ/g),"n");r=r.replace(new RegExp(/[òóôõö]/g),"o");r=r.replace(new RegExp(/œ/g),"oe");r=r.replace(new RegExp(/[ùúûü]/g),"u");r=r.replace(new RegExp(/[ýÿ]/g),"y");r=r.replace(new RegExp(/\W/g),"");return r;}
function replaceNonAccents(s){var r=s.toLowerCase();r=r.replace(new RegExp(/\s/g),"");r=r.replace(new RegExp(/[àaâãäå]/g),"á");r=r.replace(new RegExp(/[èeêë]/g),"é");r=r.replace(new RegExp(/[ìiîï]/g),"í");r=r.replace(new RegExp(/n/g),"ñ");r=r.replace(new RegExp(/[òoôõö]/g),"ó");r=r.replace(new RegExp(/[ùuûü]/g),"ú");r=r.replace(new RegExp(/[y]/g),"ÿ");r=r.replace(new RegExp(/\W/g),"");return r;}
function disableComponent(id){$('#'+id).attr('disabled',true);}
var bytesUploaded=0;var bytesTotal=0;var previousBytesLoaded=0;var intervalTimer=0;var ID2_file;var xhr;function fileSelectedIndice(id2){ID2_file=id2;var file=document.getElementById('indiceToUpload'+'_'+ID2_file).files[0];var fileSize=0;if(file.size>1024*1024)
fileSize=(Math.round(file.size*100/(1024*1024))/100)
.toString()
+'MB';else
fileSize=(Math.round(file.size*100/1024)/100).toString()+'KB';document.getElementById('indiceInfo'+'_'+ID2_file).style.display='block';document.getElementById('indiceName'+'_'+ID2_file).innerHTML='Name: '+file.name;document.getElementById('indiceSize'+'_'+ID2_file).innerHTML='Size: '+fileSize;document.getElementById('indiceType'+'_'+ID2_file).innerHTML='Type: '+file.type;}
function fileSelected(id2){ID2_file=id2;var file=document.getElementById('fileToUpload'+'_'+ID2_file).files[0];var fileSize=0;if(file.size>1024*1024)
fileSize=(Math.round(file.size*100/(1024*1024))/100)
.toString()
+'MB';else
fileSize=(Math.round(file.size*100/1024)/100).toString()+'KB';document.getElementById('fileInfo'+'_'+ID2_file).style.display='block';document.getElementById('fileName'+'_'+ID2_file).innerHTML='Name: '+file.name;document.getElementById('fileSize'+'_'+ID2_file).innerHTML='Size: '+fileSize;document.getElementById('fileType'+'_'+ID2_file).innerHTML='Type: '+file.type;}
function cancelUpload(){try{xhr.abort();}
catch(e){}}
function updateTransferSpeed(){var currentBytes=bytesUploaded;var bytesDiff=currentBytes-previousBytesLoaded;if(bytesDiff==0)
return;previousBytesLoaded=currentBytes;bytesDiff=bytesDiff*2;var bytesRemaining=bytesTotal-previousBytesLoaded;var secondsRemaining=bytesRemaining/bytesDiff;var speed="";if(bytesDiff>1024*1024)
speed=(Math.round(bytesDiff*100/(1024*1024))/100).toString()
+'MBps';else if(bytesDiff>1024)
speed=(Math.round(bytesDiff*100/1024)/100).toString()+'KBps';else
speed=bytesDiff.toString()+'Bps';document.getElementById('transferSpeedInfo'+'_'+ID2_file).innerHTML=speed;document.getElementById('timeRemainingInfo'+'_'+ID2_file).innerHTML='| '
+secondsToString(secondsRemaining);}
function secondsToString(seconds){var h=Math.floor(seconds/3600);var m=Math.floor(seconds%3600/60);var s=Math.floor(seconds%3600%60);return((h>0?h+":":"")
+(m>0?(h>0&&m<10?"0":"")+m+":":"0:")
+(s<10?"0":"")+s);}
function uploadProgressIndice(evt){if(evt.lengthComputable){bytesUploaded=evt.loaded;bytesTotal=evt.total;var percentComplete=Math.round(evt.loaded*100/evt.total);var bytesTransfered='';if(bytesUploaded>1024*1024)
bytesTransfered=(Math.round(bytesUploaded*100/(1024*1024))/100)
.toString()
+'MB';else if(bytesUploaded>1024)
bytesTransfered=(Math.round(bytesUploaded*100/1024)/100)
.toString()
+'KB';else
bytesTransfered=(Math.round(bytesUploaded*100)/100)
.toString()
+'Bytes';$('#'+'progressIndicatorIndice'+'_'+ID2_file).removeClass('hide');document.getElementById('progressNumberIndice'+'_'+ID2_file).innerHTML=percentComplete
.toString()
+'%';document.getElementById('progressBarIndice'+'_'+ID2_file).style.width=percentComplete.toString()+'%';document.getElementById('transferBytesInfoIndice'+'_'+ID2_file).innerHTML=bytesTransfered;if(percentComplete==100){var uploadResponse=document.getElementById('uploadResponseIndice'+'_'+ID2_file);uploadResponse.innerHTML='<span style="font-size: 18pt; font-weight: bold;">Procesando...</span>';uploadResponse.style.display='block';}}else{document.getElementById('progressBarIndice'+'_'+ID2_file).innerHTML='No se pudo completar';}}
function uploadProgress(evt){if(evt.lengthComputable){bytesUploaded=evt.loaded;bytesTotal=evt.total;var percentComplete=Math.round(evt.loaded*100/evt.total);var bytesTransfered='';if(bytesUploaded>1024*1024)
bytesTransfered=(Math.round(bytesUploaded*100/(1024*1024))/100)
.toString()
+'MB';else if(bytesUploaded>1024)
bytesTransfered=(Math.round(bytesUploaded*100/1024)/100)
.toString()
+'KB';else
bytesTransfered=(Math.round(bytesUploaded*100)/100)
.toString()
+'Bytes';$('#'+'progressIndicator'+'_'+ID2_file).removeClass('hide');document.getElementById('progressNumber'+'_'+ID2_file).innerHTML=percentComplete
.toString()
+'%';document.getElementById('progressBar'+'_'+ID2_file).style.width=percentComplete.toString()+'%';document.getElementById('transferBytesInfo'+'_'+ID2_file).innerHTML=bytesTransfered;if(percentComplete==100){var uploadResponse=document.getElementById('uploadResponse'+'_'+ID2_file);uploadResponse.innerHTML='<span style="font-size: 18pt; font-weight: bold;">Procesando...</span>';uploadResponse.style.display='block';}}else{document.getElementById('progressBar').innerHTML='No se pudo completar';}}
function uploadComplete(evt){clearInterval(intervalTimer);$('#'+'progressIndicator'+'_'+ID2_file+' > div').removeClass('active');$('#'+'progressIndicator'+'_'+ID2_file+' > div').removeClass('progress-striped');var uploadResponse=document.getElementById('uploadResponse'+'_'+ID2_file);uploadResponse.innerHTML=evt.target.responseText;uploadResponse.style.display='block';setTimeout(refreshMeranPage,4000);}
function uploadFailed(evt){clearInterval(intervalTimer);alert("An error occurred while uploading the file.");}
function uploadCanceled(evt){clearInterval(intervalTimer);alert("The upload has been canceled by the user or the browser dropped the connection.");}
function historyBack(){window.history.back();}var overlay_on=false;function startOverlay(){try{if(!overlay_on){$('#ajax-indicator').modal({show:true,keyboard:false,backdrop:false,});overlay_on=true;}}
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
helper.onComplete(ajax.responseText);}}}});}}function clearMessages(){$('#end_top').html("<div id='mensajes' class='alert hide pagination-centered'><a class='close' data-dismiss='alert'>x</a><br /> </div>");}
function verificarRespuesta(responseText){if(responseText==0){jAlert(DATOS_ENVIADOS_INCORRECTOS,'Info','errboxid');return(0);}else{return(1);}}
function setMessages(Messages_hashref){//@params
var hayError=0;try{_createContentMessages();var i;if(Messages_hashref.error==1)
$('#mensajes').addClass('alert-error');if(Messages_hashref.success==1)
$('#mensajes').addClass('alert-success');hayError=Messages_hashref.error;for(i=0;i<Messages_hashref.messages.length;i++){$('#mensajes').append('<p>'+Messages_hashref.messages[i].message+'</p>');}
$('#mensajes').removeClass('hide');$('html, body').animate({scrollTop:0},'slow');_delay(clearMessages,60);}
catch(e){}
return hayError;}
function _createContentMessages(){var contenedor=$('#mensajes')[0];if(contenedor==null){$('#end_top').append("<div id='mensajes' class='alert hide pagination-centered'><a class='close' data-dismiss='alert'>×</a><br /> </div>");}
else{clearMessages();}}
function _delay(funcion,segundos){setTimeout(funcion,segundos*1000);}
function hayError(msg){if(msg.error==1)
return(true);return(false);}function _WinInit(objWin){_WinAddDiv(objWin);}
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
"height: "+$(window).height()+"\n");}}}function _getId(IdObj,id){$('#'+IdObj).val(id);}
function _CrearAutocomplete(options){if(!(options.IdInput)||!(options.IdInputHidden)){alert("AutocompleteHelper=> _CrearAutocomplete=> Error en parametros");return 0;}
url=URL_PREFIX+"/autocompletablesDB.pl?accion="+options.accion+"&token="+token;$("#"+options.IdInput).search();$("#"+options.IdInput).autocomplete(url,{formatItem:function(row){return row[1];},minChars:3,matchSubset:1,matchContains:1,maxItemsToShow:M_LIMITE_RESULTADOS,cacheLength:M_LIMITE_RESULTADOS,selectOnly:1,});$("#"+options.IdInput).result(function(event,data,formatted){$("#"+options.IdInput).val(data[1]);_getId(options.IdInputHidden,data[0]);if(options.callBackFunction){options.callBackFunction();}});}
function _CrearAutocompleteTextArea(options){if(!(options.IdInput)){alert("AutocompleteHelper=> _CrearAutocomplete=> Error en parametros");return 0;}
url=URL_PREFIX+"/autocompletablesDB.pl?accion="+options.accion+"&token="+token;$("#"+options.IdInput).search();$("#"+options.IdInput).autocomplete(url,{formatItem:function(row){return row[1];},minChars:3,matchSubset:1,matchContains:1,maxItemsToShow:10,cacheLength:50,selectOnly:1,multiple:true,matchContains:true,formatItem:formatItem,formatResult:formatResult,multipleSeparator:"\n",});$("#"+options.IdInput).result(function(event,data,formatted){if(options.IdInputHidden){_getId(options.IdInputHidden,data[0]);}
if(options.callBackFunction){options.callBackFunction();}});}
function CrearAutocompleteMonedas(options){_CrearAutocomplete({IdInput:options.IdInput,IdInputHidden:options.IdInputHidden,accion:'autocomplete_monedas',callBackFunction:options.callBackFunction,});}
function CrearAutocompleteCiudades(options){_CrearAutocomplete({IdInput:options.IdInput,IdInputHidden:options.IdInputHidden,accion:'autocomplete_ciudades',callBackFunction:options.callBackFunction,});}
function CrearAutocompletePaises(options){_CrearAutocomplete({IdInput:options.IdInput,IdInputHidden:options.IdInputHidden,accion:'autocomplete_paises',callBackFunction:options.callBackFunction,});}
function CrearAutocompleteLenguajes(options){_CrearAutocomplete({IdInput:options.IdInput,IdInputHidden:options.IdInputHidden,accion:'autocomplete_lenguajes',callBackFunction:options.callBackFunction,});}
function CrearAutocompleteAutores(options){_CrearAutocomplete({IdInput:options.IdInput,IdInputHidden:options.IdInputHidden,accion:'autocomplete_autores',callBackFunction:options.callBackFunction,});}
function CrearAutocompleteSoportes(options){_CrearAutocomplete({IdInput:options.IdInput,IdInputHidden:options.IdInputHidden,accion:'autocomplete_soportes',callBackFunction:options.callBackFunction,});}
function CrearAutocompleteUsuarios(options){_CrearAutocomplete({IdInput:options.IdInput,IdInputHidden:options.IdInputHidden,accion:'autocomplete_usuarios',callBackFunction:options.callBackFunction,});}
function CrearAutocompleteUsuariosByCredential(options){_CrearAutocomplete({IdInput:options.IdInput,IdInputHidden:options.IdInputHidden,accion:'autocomplete_usuarios_by_credential',callBackFunction:options.callBackFunction,});}
function CrearAutocompleteUsuariosConRegularidad(options){_CrearAutocomplete({IdInput:options.IdInput,IdInputHidden:options.IdInputHidden,accion:'autocomplete_usuarios_con_regularidad',callBackFunction:options.callBackFunction,});}
function CrearAutocompleteBarcodes(options){_CrearAutocomplete({IdInput:options.IdInput,IdInputHidden:options.IdInputHidden,accion:'autocomplete_barcodes',callBackFunction:options.callBackFunction,});}
function CrearAutocompleteBarcodesPrestados(options){_CrearAutocomplete({IdInput:options.IdInput,IdInputHidden:options.IdInputHidden,accion:'autocomplete_barcodes_prestados',callBackFunction:options.callBackFunction,});}
function CrearAutocompleteTemas(options){_CrearAutocomplete({IdInput:options.IdInput,IdInputHidden:options.IdInputHidden,accion:'autocomplete_temas',callBackFunction:options.callBackFunction,});}
function CrearAutocompleteEditoriales(options){_CrearAutocomplete({IdInput:options.IdInput,IdInputHidden:options.IdInputHidden,accion:'autocomplete_editoriales',callBackFunction:options.callBackFunction,});}
function CrearAutocompleteAyudaMARC(options){_CrearAutocomplete({IdInput:options.IdInput,IdInputHidden:options.IdInputHidden,accion:'autocomplete_ayuda_marc',callBackFunction:options.callBackFunction,});}
function CrearAutocompleteUI(options){_CrearAutocomplete({IdInput:options.IdInput,IdInputHidden:options.IdInputHidden,accion:'autocomplete_UI',callBackFunction:options.callBackFunction,});}
function CrearAutocompleteCatalogo(options){_CrearAutocomplete({IdInput:options.IdInput,IdInputHidden:options.IdInputHidden,IdInputAutor:options.IdInputAutor,accion:'autocomplete_catalogo',callBackFunction:options.callBackFunction,});}
function CrearAutocompleteNivel2(options){_CrearAutocomplete({IdInput:options.IdInput,IdInputHidden:options.IdInputHidden,IdInputAutor:options.IdInputAutor,accion:'autocomplete_nivel2',callBackFunction:options.callBackFunction,});}
function CrearAutocompleteCatalogoId(options){_CrearAutocomplete({IdInput:options.IdInput,IdInputHidden:options.IdInputHidden,IdInputAutor:options.IdInputAutor,accion:'autocomplete_catalogo_id',callBackFunction:options.callBackFunction,});}
function CrearAutocompleteNivel2Id(options){_CrearAutocomplete({IdInput:options.IdInput,IdInputHidden:options.IdInputHidden,IdInputAutor:options.IdInputAutor,accion:'autocomplete_nivel2_id',callBackFunction:options.callBackFunction,});}var hexcase=0;var b64pad="";var chrsz=8;function hex_md5(s){return binl2hex(core_md5(str2binl(s),s.length*chrsz));}
function b64_md5(s){return binl2b64(core_md5(str2binl(s),s.length*chrsz));}
function str_md5(s){return binl2str(core_md5(str2binl(s),s.length*chrsz));}
function hex_hmac_md5(key,data){return binl2hex(core_hmac_md5(key,data));}
function b64_hmac_md5(key,data){return binl2b64(core_hmac_md5(key,data));}
function str_hmac_md5(key,data){return binl2str(core_hmac_md5(key,data));}
function md5_vm_test()
{return hex_md5("abc")=="900150983cd24fb0d6963f7d28e17f72";}
function core_md5(x,len)
{x[len>>5]|=0x80<<((len)%32);x[(((len+64)>>>9)<<4)+14]=len;var a=1732584193;var b=-271733879;var c=-1732584194;var d=271733878;for(var i=0;i<x.length;i+=16)
{var olda=a;var oldb=b;var oldc=c;var oldd=d;a=md5_ff(a,b,c,d,x[i+0],7,-680876936);d=md5_ff(d,a,b,c,x[i+1],12,-389564586);c=md5_ff(c,d,a,b,x[i+2],17,606105819);b=md5_ff(b,c,d,a,x[i+3],22,-1044525330);a=md5_ff(a,b,c,d,x[i+4],7,-176418897);d=md5_ff(d,a,b,c,x[i+5],12,1200080426);c=md5_ff(c,d,a,b,x[i+6],17,-1473231341);b=md5_ff(b,c,d,a,x[i+7],22,-45705983);a=md5_ff(a,b,c,d,x[i+8],7,1770035416);d=md5_ff(d,a,b,c,x[i+9],12,-1958414417);c=md5_ff(c,d,a,b,x[i+10],17,-42063);b=md5_ff(b,c,d,a,x[i+11],22,-1990404162);a=md5_ff(a,b,c,d,x[i+12],7,1804603682);d=md5_ff(d,a,b,c,x[i+13],12,-40341101);c=md5_ff(c,d,a,b,x[i+14],17,-1502002290);b=md5_ff(b,c,d,a,x[i+15],22,1236535329);a=md5_gg(a,b,c,d,x[i+1],5,-165796510);d=md5_gg(d,a,b,c,x[i+6],9,-1069501632);c=md5_gg(c,d,a,b,x[i+11],14,643717713);b=md5_gg(b,c,d,a,x[i+0],20,-373897302);a=md5_gg(a,b,c,d,x[i+5],5,-701558691);d=md5_gg(d,a,b,c,x[i+10],9,38016083);c=md5_gg(c,d,a,b,x[i+15],14,-660478335);b=md5_gg(b,c,d,a,x[i+4],20,-405537848);a=md5_gg(a,b,c,d,x[i+9],5,568446438);d=md5_gg(d,a,b,c,x[i+14],9,-1019803690);c=md5_gg(c,d,a,b,x[i+3],14,-187363961);b=md5_gg(b,c,d,a,x[i+8],20,1163531501);a=md5_gg(a,b,c,d,x[i+13],5,-1444681467);d=md5_gg(d,a,b,c,x[i+2],9,-51403784);c=md5_gg(c,d,a,b,x[i+7],14,1735328473);b=md5_gg(b,c,d,a,x[i+12],20,-1926607734);a=md5_hh(a,b,c,d,x[i+5],4,-378558);d=md5_hh(d,a,b,c,x[i+8],11,-2022574463);c=md5_hh(c,d,a,b,x[i+11],16,1839030562);b=md5_hh(b,c,d,a,x[i+14],23,-35309556);a=md5_hh(a,b,c,d,x[i+1],4,-1530992060);d=md5_hh(d,a,b,c,x[i+4],11,1272893353);c=md5_hh(c,d,a,b,x[i+7],16,-155497632);b=md5_hh(b,c,d,a,x[i+10],23,-1094730640);a=md5_hh(a,b,c,d,x[i+13],4,681279174);d=md5_hh(d,a,b,c,x[i+0],11,-358537222);c=md5_hh(c,d,a,b,x[i+3],16,-722521979);b=md5_hh(b,c,d,a,x[i+6],23,76029189);a=md5_hh(a,b,c,d,x[i+9],4,-640364487);d=md5_hh(d,a,b,c,x[i+12],11,-421815835);c=md5_hh(c,d,a,b,x[i+15],16,530742520);b=md5_hh(b,c,d,a,x[i+2],23,-995338651);a=md5_ii(a,b,c,d,x[i+0],6,-198630844);d=md5_ii(d,a,b,c,x[i+7],10,1126891415);c=md5_ii(c,d,a,b,x[i+14],15,-1416354905);b=md5_ii(b,c,d,a,x[i+5],21,-57434055);a=md5_ii(a,b,c,d,x[i+12],6,1700485571);d=md5_ii(d,a,b,c,x[i+3],10,-1894986606);c=md5_ii(c,d,a,b,x[i+10],15,-1051523);b=md5_ii(b,c,d,a,x[i+1],21,-2054922799);a=md5_ii(a,b,c,d,x[i+8],6,1873313359);d=md5_ii(d,a,b,c,x[i+15],10,-30611744);c=md5_ii(c,d,a,b,x[i+6],15,-1560198380);b=md5_ii(b,c,d,a,x[i+13],21,1309151649);a=md5_ii(a,b,c,d,x[i+4],6,-145523070);d=md5_ii(d,a,b,c,x[i+11],10,-1120210379);c=md5_ii(c,d,a,b,x[i+2],15,718787259);b=md5_ii(b,c,d,a,x[i+9],21,-343485551);a=safe_add(a,olda);b=safe_add(b,oldb);c=safe_add(c,oldc);d=safe_add(d,oldd);}
return Array(a,b,c,d);}
function md5_cmn(q,a,b,x,s,t)
{return safe_add(bit_rol(safe_add(safe_add(a,q),safe_add(x,t)),s),b);}
function md5_ff(a,b,c,d,x,s,t)
{return md5_cmn((b&c)|((~b)&d),a,b,x,s,t);}
function md5_gg(a,b,c,d,x,s,t)
{return md5_cmn((b&d)|(c&(~d)),a,b,x,s,t);}
function md5_hh(a,b,c,d,x,s,t)
{return md5_cmn(b^c^d,a,b,x,s,t);}
function md5_ii(a,b,c,d,x,s,t)
{return md5_cmn(c^(b|(~d)),a,b,x,s,t);}
function core_hmac_md5(key,data)
{var bkey=str2binl(key);if(bkey.length>16)bkey=core_md5(bkey,key.length*chrsz);var ipad=Array(16),opad=Array(16);for(var i=0;i<16;i++)
{ipad[i]=bkey[i]^0x36363636;opad[i]=bkey[i]^0x5C5C5C5C;}
var hash=core_md5(ipad.concat(str2binl(data)),512+data.length*chrsz);return core_md5(opad.concat(hash),512+128);}
function safe_add(x,y)
{var lsw=(x&0xFFFF)+(y&0xFFFF);var msw=(x>>16)+(y>>16)+(lsw>>16);return(msw<<16)|(lsw&0xFFFF);}
function bit_rol(num,cnt)
{return(num<<cnt)|(num>>>(32-cnt));}
function str2binl(str)
{var bin=Array();var mask=(1<<chrsz)-1;for(var i=0;i<str.length*chrsz;i+=chrsz)
bin[i>>5]|=(str.charCodeAt(i/chrsz)&mask)<<(i%32);return bin;}
function binl2str(bin)
{var str="";var mask=(1<<chrsz)-1;for(var i=0;i<bin.length*32;i+=chrsz)
str+=String.fromCharCode((bin[i>>5]>>>(i%32))&mask);return str;}
function binl2hex(binarray)
{var hex_tab=hexcase?"0123456789ABCDEF":"0123456789abcdef";var str="";for(var i=0;i<binarray.length*4;i++)
{str+=hex_tab.charAt((binarray[i>>2]>>((i%4)*8+4))&0xF)+
hex_tab.charAt((binarray[i>>2]>>((i%4)*8))&0xF);}
return str;}
function binl2b64(binarray)
{var tab="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";var str="";for(var i=0;i<binarray.length*4;i+=3)
{var triplet=(((binarray[i>>2]>>8*(i%4))&0xFF)<<16)|(((binarray[i+1>>2]>>8*((i+1)%4))&0xFF)<<8)|((binarray[i+2>>2]>>8*((i+2)%4))&0xFF);for(var j=0;j<4;j++)
{if(i*8+j*6>binarray.length*32)str+=b64pad;else str+=tab.charAt((triplet>>6*(3-j))&0x3F);}}
return str;}window.Modernizr=(function(window,document,undefined){var version='2.6.1',Modernizr={},enableClasses=true,docElement=document.documentElement,mod='modernizr',modElem=document.createElement(mod),mStyle=modElem.style,inputElem=document.createElement('input'),smile=':)',toString={}.toString,prefixes=' -webkit- -moz- -o- -ms- '.split(' '),omPrefixes='Webkit Moz O ms',cssomPrefixes=omPrefixes.split(' '),domPrefixes=omPrefixes.toLowerCase().split(' '),ns={'svg':'http://www.w3.org/2000/svg'},tests={},inputs={},attrs={},classes=[],slice=classes.slice,featureName,injectElementWithStyles=function(rule,callback,nodes,testnames){var style,ret,node,div=document.createElement('div'),body=document.body,fakeBody=body?body:document.createElement('body');if(parseInt(nodes,10)){while(nodes--){node=document.createElement('div');node.id=testnames?testnames[nodes]:mod+(nodes+1);div.appendChild(node);}}
style=['&#173;','<style id="s',mod,'">',rule,'</style>'].join('');div.id=mod;(body?div:fakeBody).innerHTML+=style;fakeBody.appendChild(div);if(!body){fakeBody.style.background="";docElement.appendChild(fakeBody);}
ret=callback(div,rule);!body?fakeBody.parentNode.removeChild(fakeBody):div.parentNode.removeChild(div);return!!ret;},testMediaQuery=function(mq){var matchMedia=window.matchMedia||window.msMatchMedia;if(matchMedia){return matchMedia(mq).matches;}
var bool;injectElementWithStyles('@media '+mq+' { #'+mod+' { position: absolute; } }',function(node){bool=(window.getComputedStyle?getComputedStyle(node,null):node.currentStyle)['position']=='absolute';});return bool;},isEventSupported=(function(){var TAGNAMES={'select':'input','change':'input','submit':'form','reset':'form','error':'img','load':'img','abort':'img'};function isEventSupported(eventName,element){element=element||document.createElement(TAGNAMES[eventName]||'div');eventName='on'+eventName;var isSupported=eventName in element;if(!isSupported){if(!element.setAttribute){element=document.createElement('div');}
if(element.setAttribute&&element.removeAttribute){element.setAttribute(eventName,'');isSupported=is(element[eventName],'function');if(!is(element[eventName],'undefined')){element[eventName]=undefined;}
element.removeAttribute(eventName);}}
element=null;return isSupported;}
return isEventSupported;})(),_hasOwnProperty=({}).hasOwnProperty,hasOwnProp;if(!is(_hasOwnProperty,'undefined')&&!is(_hasOwnProperty.call,'undefined')){hasOwnProp=function(object,property){return _hasOwnProperty.call(object,property);};}
else{hasOwnProp=function(object,property){return((property in object)&&is(object.constructor.prototype[property],'undefined'));};}
if(!Function.prototype.bind){Function.prototype.bind=function bind(that){var target=this;if(typeof target!="function"){throw new TypeError();}
var args=slice.call(arguments,1),bound=function(){if(this instanceof bound){var F=function(){};F.prototype=target.prototype;var self=new F();var result=target.apply(self,args.concat(slice.call(arguments)));if(Object(result)===result){return result;}
return self;}else{return target.apply(that,args.concat(slice.call(arguments)));}};return bound;};}
function setCss(str){mStyle.cssText=str;}
function setCssAll(str1,str2){return setCss(prefixes.join(str1+';')+(str2||''));}
function is(obj,type){return typeof obj===type;}
function contains(str,substr){return!!~(''+str).indexOf(substr);}
function testProps(props,prefixed){for(var i in props){var prop=props[i];if(!contains(prop,"-")&&mStyle[prop]!==undefined){return prefixed=='pfx'?prop:true;}}
return false;}
function testDOMProps(props,obj,elem){for(var i in props){var item=obj[props[i]];if(item!==undefined){if(elem===false)return props[i];if(is(item,'function')){return item.bind(elem||obj);}
return item;}}
return false;}
function testPropsAll(prop,prefixed,elem){var ucProp=prop.charAt(0).toUpperCase()+prop.slice(1),props=(prop+' '+cssomPrefixes.join(ucProp+' ')+ucProp).split(' ');if(is(prefixed,"string")||is(prefixed,"undefined")){return testProps(props,prefixed);}else{props=(prop+' '+(domPrefixes).join(ucProp+' ')+ucProp).split(' ');return testDOMProps(props,prefixed,elem);}}
tests['flexbox']=function(){return testPropsAll('flexWrap');};tests['flexboxlegacy']=function(){return testPropsAll('boxDirection');};tests['canvas']=function(){var elem=document.createElement('canvas');return!!(elem.getContext&&elem.getContext('2d'));};tests['canvastext']=function(){return!!(Modernizr['canvas']&&is(document.createElement('canvas').getContext('2d').fillText,'function'));};tests['webgl']=function(){return!!window.WebGLRenderingContext;};tests['touch']=function(){var bool;if(('ontouchstart'in window)||window.DocumentTouch&&document instanceof DocumentTouch){bool=true;}else{injectElementWithStyles(['@media (',prefixes.join('touch-enabled),('),mod,')','{#modernizr{top:9px;position:absolute}}'].join(''),function(node){bool=node.offsetTop===9;});}
return bool;};tests['geolocation']=function(){return'geolocation'in navigator;};tests['postmessage']=function(){return!!window.postMessage;};tests['websqldatabase']=function(){return!!window.openDatabase;};tests['indexedDB']=function(){return!!testPropsAll("indexedDB",window);};tests['hashchange']=function(){return isEventSupported('hashchange',window)&&(document.documentMode===undefined||document.documentMode>7);};tests['history']=function(){return!!(window.history&&history.pushState);};tests['draganddrop']=function(){var div=document.createElement('div');return('draggable'in div)||('ondragstart'in div&&'ondrop'in div);};tests['websockets']=function(){return'WebSocket'in window||'MozWebSocket'in window;};tests['rgba']=function(){setCss('background-color:rgba(150,255,150,.5)');return contains(mStyle.backgroundColor,'rgba');};tests['hsla']=function(){setCss('background-color:hsla(120,40%,100%,.5)');return contains(mStyle.backgroundColor,'rgba')||contains(mStyle.backgroundColor,'hsla');};tests['multiplebgs']=function(){setCss('background:url(https://),url(https://),red url(https://)');return(/(url\s*\(.*?){3}/).test(mStyle.background);};tests['backgroundsize']=function(){return testPropsAll('backgroundSize');};tests['borderimage']=function(){return testPropsAll('borderImage');};tests['borderradius']=function(){return testPropsAll('borderRadius');};tests['boxshadow']=function(){return testPropsAll('boxShadow');};tests['textshadow']=function(){return document.createElement('div').style.textShadow==='';};tests['opacity']=function(){setCssAll('opacity:.55');return(/^0.55$/).test(mStyle.opacity);};tests['cssanimations']=function(){return testPropsAll('animationName');};tests['csscolumns']=function(){return testPropsAll('columnCount');};tests['cssgradients']=function(){var str1='background-image:',str2='gradient(linear,left top,right bottom,from(#9f9),to(white));',str3='linear-gradient(left top,#9f9, white);';setCss((str1+'-webkit- '.split(' ').join(str2+str1)+
prefixes.join(str3+str1)).slice(0,-str1.length));return contains(mStyle.backgroundImage,'gradient');};tests['cssreflections']=function(){return testPropsAll('boxReflect');};tests['csstransforms']=function(){return!!testPropsAll('transform');};tests['csstransforms3d']=function(){var ret=!!testPropsAll('perspective');if(ret&&'webkitPerspective'in docElement.style){injectElementWithStyles('@media (transform-3d),(-webkit-transform-3d){#modernizr{left:9px;position:absolute;height:3px;}}',function(node,rule){ret=node.offsetLeft===9&&node.offsetHeight===3;});}
return ret;};tests['csstransitions']=function(){return testPropsAll('transition');};tests['fontface']=function(){var bool;injectElementWithStyles('@font-face {font-family:"font";src:url("https://")}',function(node,rule){var style=document.getElementById('smodernizr'),sheet=style.sheet||style.styleSheet,cssText=sheet?(sheet.cssRules&&sheet.cssRules[0]?sheet.cssRules[0].cssText:sheet.cssText||''):'';bool=/src/i.test(cssText)&&cssText.indexOf(rule.split(' ')[0])===0;});return bool;};tests['generatedcontent']=function(){var bool;injectElementWithStyles(['#modernizr:after{content:"',smile,'";visibility:hidden}'].join(''),function(node){bool=node.offsetHeight>=1;});return bool;};tests['video']=function(){var elem=document.createElement('video'),bool=false;try{if(bool=!!elem.canPlayType){bool=new Boolean(bool);bool.ogg=elem.canPlayType('video/ogg; codecs="theora"').replace(/^no$/,'');bool.h264=elem.canPlayType('video/mp4; codecs="avc1.42E01E"').replace(/^no$/,'');bool.webm=elem.canPlayType('video/webm; codecs="vp8, vorbis"').replace(/^no$/,'');}}catch(e){}
return bool;};tests['audio']=function(){var elem=document.createElement('audio'),bool=false;try{if(bool=!!elem.canPlayType){bool=new Boolean(bool);bool.ogg=elem.canPlayType('audio/ogg; codecs="vorbis"').replace(/^no$/,'');bool.mp3=elem.canPlayType('audio/mpeg;').replace(/^no$/,'');bool.wav=elem.canPlayType('audio/wav; codecs="1"').replace(/^no$/,'');bool.m4a=(elem.canPlayType('audio/x-m4a;')||elem.canPlayType('audio/aac;')).replace(/^no$/,'');}}catch(e){}
return bool;};tests['localstorage']=function(){try{localStorage.setItem(mod,mod);localStorage.removeItem(mod);return true;}catch(e){return false;}};tests['sessionstorage']=function(){try{sessionStorage.setItem(mod,mod);sessionStorage.removeItem(mod);return true;}catch(e){return false;}};tests['webworkers']=function(){return!!window.Worker;};tests['applicationcache']=function(){return!!window.applicationCache;};tests['svg']=function(){return!!document.createElementNS&&!!document.createElementNS(ns.svg,'svg').createSVGRect;};tests['inlinesvg']=function(){var div=document.createElement('div');div.innerHTML='<svg/>';return(div.firstChild&&div.firstChild.namespaceURI)==ns.svg;};tests['smil']=function(){return!!document.createElementNS&&/SVGAnimate/.test(toString.call(document.createElementNS(ns.svg,'animate')));};tests['svgclippaths']=function(){return!!document.createElementNS&&/SVGClipPath/.test(toString.call(document.createElementNS(ns.svg,'clipPath')));};function webforms(){Modernizr['input']=(function(props){for(var i=0,len=props.length;i<len;i++){attrs[props[i]]=!!(props[i]in inputElem);}
if(attrs.list){attrs.list=!!(document.createElement('datalist')&&window.HTMLDataListElement);}
return attrs;})('autocomplete autofocus list placeholder max min multiple pattern required step'.split(' '));Modernizr['inputtypes']=(function(props){for(var i=0,bool,inputElemType,defaultView,len=props.length;i<len;i++){inputElem.setAttribute('type',inputElemType=props[i]);bool=inputElem.type!=='text';if(bool){inputElem.value=smile;inputElem.style.cssText='position:absolute;visibility:hidden;';if(/^range$/.test(inputElemType)&&inputElem.style.WebkitAppearance!==undefined){docElement.appendChild(inputElem);defaultView=document.defaultView;bool=defaultView.getComputedStyle&&defaultView.getComputedStyle(inputElem,null).WebkitAppearance!=='textfield'&&(inputElem.offsetHeight!==0);docElement.removeChild(inputElem);}else if(/^(search|tel)$/.test(inputElemType)){}else if(/^(url|email)$/.test(inputElemType)){bool=inputElem.checkValidity&&inputElem.checkValidity()===false;}else{bool=inputElem.value!=smile;}}
inputs[props[i]]=!!bool;}
return inputs;})('search tel url email datetime date month week time datetime-local number range color'.split(' '));}
for(var feature in tests){if(hasOwnProp(tests,feature)){featureName=feature.toLowerCase();Modernizr[featureName]=tests[feature]();classes.push((Modernizr[featureName]?'':'no-')+featureName);}}
Modernizr.input||webforms();Modernizr.addTest=function(feature,test){if(typeof feature=='object'){for(var key in feature){if(hasOwnProp(feature,key)){Modernizr.addTest(key,feature[key]);}}}else{feature=feature.toLowerCase();if(Modernizr[feature]!==undefined){return Modernizr;}
test=typeof test=='function'?test():test;if(enableClasses){docElement.className+=' '+(test?'':'no-')+feature;}
Modernizr[feature]=test;}
return Modernizr;};setCss('');modElem=inputElem=null;;(function(window,document){var options=window.html5||{};var reSkip=/^<|^(?:button|map|select|textarea|object|iframe|option|optgroup)$/i;var saveClones=/^<|^(?:a|b|button|code|div|fieldset|form|h1|h2|h3|h4|h5|h6|i|iframe|img|input|label|li|link|ol|option|p|param|q|script|select|span|strong|style|table|tbody|td|textarea|tfoot|th|thead|tr|ul)$/i;var supportsHtml5Styles;var expando='_html5shiv';var expanID=0;var expandoData={};var supportsUnknownElements;(function(){try{var a=document.createElement('a');a.innerHTML='<xyz></xyz>';supportsHtml5Styles=('hidden'in a);supportsUnknownElements=a.childNodes.length==1||(function(){(document.createElement)('a');var frag=document.createDocumentFragment();return(typeof frag.cloneNode=='undefined'||typeof frag.createDocumentFragment=='undefined'||typeof frag.createElement=='undefined');}());}catch(e){supportsHtml5Styles=true;supportsUnknownElements=true;}}());function addStyleSheet(ownerDocument,cssText){var p=ownerDocument.createElement('p'),parent=ownerDocument.getElementsByTagName('head')[0]||ownerDocument.documentElement;p.innerHTML='x<style>'+cssText+'</style>';return parent.insertBefore(p.lastChild,parent.firstChild);}
function getElements(){var elements=html5.elements;return typeof elements=='string'?elements.split(' '):elements;}
function getExpandoData(ownerDocument){var data=expandoData[ownerDocument[expando]];if(!data){data={};expanID++;ownerDocument[expando]=expanID;expandoData[expanID]=data;}
return data;}
function createElement(nodeName,ownerDocument,data){if(!ownerDocument){ownerDocument=document;}
if(supportsUnknownElements){return ownerDocument.createElement(nodeName);}
if(!data){data=getExpandoData(ownerDocument);}
var node;if(data.cache[nodeName]){node=data.cache[nodeName].cloneNode();}else if(saveClones.test(nodeName)){node=(data.cache[nodeName]=data.createElem(nodeName)).cloneNode();}else{node=data.createElem(nodeName);}
return node.canHaveChildren&&!reSkip.test(nodeName)?data.frag.appendChild(node):node;}
function createDocumentFragment(ownerDocument,data){if(!ownerDocument){ownerDocument=document;}
if(supportsUnknownElements){return ownerDocument.createDocumentFragment();}
data=data||getExpandoData(ownerDocument);var clone=data.frag.cloneNode(),i=0,elems=getElements(),l=elems.length;for(;i<l;i++){clone.createElement(elems[i]);}
return clone;}
function shivMethods(ownerDocument,data){if(!data.cache){data.cache={};data.createElem=ownerDocument.createElement;data.createFrag=ownerDocument.createDocumentFragment;data.frag=data.createFrag();}
ownerDocument.createElement=function(nodeName){if(!html5.shivMethods){return data.createElem(nodeName);}
return createElement(nodeName,ownerDocument,data);};ownerDocument.createDocumentFragment=Function('h,f','return function(){'+
'var n=f.cloneNode(),c=n.createElement;'+
'h.shivMethods&&('+
getElements().join().replace(/\w+/g,function(nodeName){data.createElem(nodeName);data.frag.createElement(nodeName);return'c("'+nodeName+'")';})+
');return n}')(html5,data.frag);}
function shivDocument(ownerDocument){if(!ownerDocument){ownerDocument=document;}
var data=getExpandoData(ownerDocument);if(html5.shivCSS&&!supportsHtml5Styles&&!data.hasCSS){data.hasCSS=!!addStyleSheet(ownerDocument,'article,aside,figcaption,figure,footer,header,hgroup,nav,section{display:block}'+
'mark{background:#FF0;color:#000}');}
if(!supportsUnknownElements){shivMethods(ownerDocument,data);}
return ownerDocument;}
var html5={'elements':options.elements||'abbr article aside audio bdi canvas data datalist details figcaption figure footer header hgroup mark meter nav output progress section summary time video','shivCSS':(options.shivCSS!==false),'supportsUnknownElements':supportsUnknownElements,'shivMethods':(options.shivMethods!==false),'type':'default','shivDocument':shivDocument,createElement:createElement,createDocumentFragment:createDocumentFragment};window.html5=html5;shivDocument(document);}(this,document));Modernizr._version=version;Modernizr._prefixes=prefixes;Modernizr._domPrefixes=domPrefixes;Modernizr._cssomPrefixes=cssomPrefixes;Modernizr.mq=testMediaQuery;Modernizr.hasEvent=isEventSupported;Modernizr.testProp=function(prop){return testProps([prop]);};Modernizr.testAllProps=testPropsAll;Modernizr.testStyles=injectElementWithStyles;Modernizr.prefixed=function(prop,obj,elem){if(!obj){return testPropsAll(prop,'pfx');}else{return testPropsAll(prop,obj,elem);}};docElement.className=docElement.className.replace(/(^|\s)no-js(\s|$)/,'$1$2')+
(enableClasses?' js '+classes.join(' '):'');return Modernizr;})(this,this.document);