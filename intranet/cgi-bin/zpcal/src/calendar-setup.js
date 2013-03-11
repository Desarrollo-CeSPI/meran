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

Zapatec.Setup=function(){};Zapatec.Setup.test=true;Zapatec.Calendar.setup=function(params){function param_default(pname,def){if(typeof params[pname]=="undefined"){params[pname]=def;}};param_default("inputField",null);param_default("displayArea",null);param_default("button",null);param_default("eventName","click");param_default("ifFormat","%Y/%m/%d");param_default("daFormat","%Y/%m/%d");param_default("singleClick",true);param_default("disableFunc",null);param_default("dateStatusFunc",params["disableFunc"]);param_default("dateText",null);param_default("firstDay",null);param_default("align","Br");param_default("range",[1900,2999]);param_default("weekNumbers",true);param_default("flat",null);param_default("flatCallback",null);param_default("onSelect",null);param_default("onClose",null);param_default("onUpdate",null);param_default("date",null);param_default("showsTime",false);param_default("sortOrder","asc");param_default("timeFormat","24");param_default("timeInterval",null);param_default("electric",true);param_default("step",2);param_default("position",null);param_default("cache",false);param_default("showOthers",false);param_default("multiple",null);param_default("saveDate",null);param_default("fdowClick",false);param_default("titleHtml",null);if((params.numberMonths>12)||(params.numberMonths<1)){params.numberMonths=1;}else{param_default("numberMonths",1);}
if(params.numberMonths>1){params.showOthers=false;}
params.numberMonths=parseInt(params.numberMonths,10);if((params.controlMonth>params.numberMonths)||(params.controlMonth<1)){params.controlMonth=1;}else{param_default("controlMonth",1);}
params.controlMonth=parseInt(params.controlMonth,10);param_default("vertical",false);if(params.monthsInRow>params.numberMonths){params.monthsInRow=params.numberMonths;}
param_default("monthsInRow",params.numberMonths);params.monthsInRow=parseInt(params.monthsInRow,10);if(params.multiple){params.singleClick=false;}
var tmp=["inputField","displayArea","button"];for(var i in tmp){if(typeof params[tmp[i]]=="string"){params[tmp[i]]=document.getElementById(params[tmp[i]]);}}
if(!(params.flat||params.multiple||params.inputField||params.displayArea||params.button)){alert("Calendar.setup:\n  Nothing to setup (no fields found).  Please check your code");return false;}
if(((params.timeInterval)&&((params.timeInterval!==Math.floor(params.timeInterval))||((60%params.timeInterval!==0)&&(params.timeInterval%60!==0))))||(params.timeInterval>360)){alert("timeInterval option can only have the following number of minutes:\n1, 2, 3, 4, 5, 6, 10, 15, 30,  60, 120, 180, 240, 300, 360 ");params.timeInterval=null;}
if(params.date&&!Date.parse(params.date)){alert("Start Date Invalid: "+params.date+".\nSee date option.\nDefaulting to today.");params.date=null;}
if(params.saveDate){param_default("cookiePrefix",window.location.href+"--"+params.button.id);var cookieName=params.cookiePrefix;var newdate=Zapatec.Utils.getCookie(cookieName);if(newdate!=null){document.getElementById(params.inputField.id).value=newdate;}}
function onSelect(cal){var p=cal.params;var update=(cal.dateClicked||p.electric);if(update&&p.flat){if(typeof p.flatCallback=="function")
{if(!p.multiple)
p.flatCallback(cal);}else
alert("No flatCallback given -- doing nothing.");return false;}
if(update&&p.inputField){p.inputField.value=cal.currentDate.print(p.ifFormat);if(typeof p.inputField.onchange=="function")
p.inputField.onchange();}
if(update&&p.displayArea)
p.displayArea.innerHTML=cal.currentDate.print(p.daFormat);if(update&&p.singleClick&&cal.dateClicked)
cal.callCloseHandler();if(update&&typeof p.onUpdate=="function")
p.onUpdate(cal);if(p.saveDate){var cookieName=p.cookiePrefix;Zapatec.Utils.writeCookie(cookieName,p.inputField.value,null,'/',p.saveDate);}};if(params.flat!=null){if(typeof params.flat=="string")
params.flat=document.getElementById(params.flat);if(!params.flat){alert("Calendar.setup:\n  Flat specified but can't find parent.");return false;}
var cal=new Zapatec.Calendar(params.firstDay,params.date,params.onSelect||onSelect);cal.showsOtherMonths=params.showOthers;cal.showsTime=params.showsTime;cal.time24=(params.timeFormat=="24");cal.timeInterval=params.timeInterval;cal.params=params;cal.weekNumbers=params.weekNumbers;cal.sortOrder=params.sortOrder.toLowerCase();cal.setRange(params.range[0],params.range[1]);cal.setDateStatusHandler(params.dateStatusFunc);cal.getDateText=params.dateText;cal.numberMonths=params.numberMonths;cal.controlMonth=params.controlMonth;cal.vertical=params.vertical;cal.yearStep=params.step;cal.monthsInRow=params.monthsInRow;if(params.ifFormat){cal.setDateFormat(params.ifFormat);}
if(params.inputField&&params.inputField.type=="text"&&typeof params.inputField.value=="string"){cal.parseDate(params.inputField.value);}
if(params.multiple){cal.setMultipleDates(params.multiple);}
cal.create(params.flat);cal.show();return cal;}
var triggerEl=params.button||params.displayArea||params.inputField;triggerEl["on"+params.eventName]=function(){var dateEl=params.inputField||params.displayArea;if(triggerEl.blur){triggerEl.blur();}
var dateFmt=params.inputField?params.ifFormat:params.daFormat;var mustCreate=false;var cal=window.calendar;if(!(cal&&params.cache)){window.calendar=cal=new Zapatec.Calendar(params.firstDay,params.date,params.onSelect||onSelect,params.onClose||function(cal){if(params.cache)
cal.hide();else
cal.destroy();});cal.showsTime=params.showsTime;cal.time24=(params.timeFormat=="24");cal.timeInterval=params.timeInterval;cal.weekNumbers=params.weekNumbers;cal.numberMonths=params.numberMonths;cal.controlMonth=params.controlMonth;cal.vertical=params.vertical;cal.monthsInRow=params.monthsInRow;cal.historyDateFormat=params.ifFormat||params.daFormat;mustCreate=true;}else{if(params.date)
cal.setDate(params.date);cal.hide();}
if(params.multiple){cal.setMultipleDates(params.multiple);}
cal.showsOtherMonths=params.showOthers;cal.yearStep=params.step;cal.setRange(params.range[0],params.range[1]);cal.params=params;cal.setDateStatusHandler(params.dateStatusFunc);cal.getDateText=params.dateText;cal.setDateFormat(dateFmt);if(mustCreate)
cal.create();if(dateEl){var dateValue;if(dateEl.value){dateValue=dateEl.value;}else{dateValue=dateEl.innerHTML;}
if(dateValue!=""){var parsedDate=Date.parseDate(dateEl.value||dateEl.innerHTML,dateFmt);if(parsedDate!=null){cal.setDate(parsedDate);}}}
if(!params.position)
cal.showAtElement(params.button||params.displayArea||params.inputField,params.align);else
cal.showAt(params.position[0],params.position[1]);return false;};if(params.closeEventName){triggerEl["on"+params.closeEventName]=function(){if(window.calendar)
window.calendar.callCloseHandler();};}
return cal;};