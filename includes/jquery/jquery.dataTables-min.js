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

(function($,window,document){$.fn.dataTableSettings=[];var _aoSettings=$.fn.dataTableSettings;$.fn.dataTableExt={};var _oExt=$.fn.dataTableExt;_oExt.sVersion="1.7.6";_oExt.sErrMode="alert";_oExt.iApiIndex=0;_oExt.oApi={};_oExt.afnFiltering=[];_oExt.aoFeatures=[];_oExt.ofnSearch={};_oExt.afnSortData=[];_oExt.oStdClasses={"sPagePrevEnabled":"paginate_enabled_previous","sPagePrevDisabled":"paginate_disabled_previous","sPageNextEnabled":"paginate_enabled_next","sPageNextDisabled":"paginate_disabled_next","sPageJUINext":"","sPageJUIPrev":"","sPageButton":"paginate_button","sPageButtonActive":"paginate_active","sPageButtonStaticDisabled":"paginate_button","sPageFirst":"first","sPagePrevious":"previous","sPageNext":"next","sPageLast":"last","sStripOdd":"odd","sStripEven":"even","sRowEmpty":"dataTables_empty","sWrapper":"dataTables_wrapper","sFilter":"dataTables_filter","sInfo":"dataTables_info","sPaging":"dataTables_paginate paging_","sLength":"dataTables_length","sProcessing":"dataTables_processing","sSortAsc":"sorting_asc","sSortDesc":"sorting_desc","sSortable":"sorting","sSortableAsc":"sorting_asc_disabled","sSortableDesc":"sorting_desc_disabled","sSortableNone":"sorting_disabled","sSortColumn":"sorting_","sSortJUIAsc":"","sSortJUIDesc":"","sSortJUI":"","sSortJUIAscAllowed":"","sSortJUIDescAllowed":"","sSortJUIWrapper":"","sScrollWrapper":"dataTables_scroll","sScrollHead":"dataTables_scrollHead","sScrollHeadInner":"dataTables_scrollHeadInner","sScrollBody":"dataTables_scrollBody","sScrollFoot":"dataTables_scrollFoot","sScrollFootInner":"dataTables_scrollFootInner","sFooterTH":""};_oExt.oJUIClasses={"sPagePrevEnabled":"fg-button ui-button ui-state-default ui-corner-left","sPagePrevDisabled":"fg-button ui-button ui-state-default ui-corner-left ui-state-disabled","sPageNextEnabled":"fg-button ui-button ui-state-default ui-corner-right","sPageNextDisabled":"fg-button ui-button ui-state-default ui-corner-right ui-state-disabled","sPageJUINext":"ui-icon ui-icon-circle-arrow-e","sPageJUIPrev":"ui-icon ui-icon-circle-arrow-w","sPageButton":"fg-button ui-button ui-state-default","sPageButtonActive":"fg-button ui-button ui-state-default ui-state-disabled","sPageButtonStaticDisabled":"fg-button ui-button ui-state-default ui-state-disabled","sPageFirst":"first ui-corner-tl ui-corner-bl","sPagePrevious":"previous","sPageNext":"next","sPageLast":"last ui-corner-tr ui-corner-br","sStripOdd":"odd","sStripEven":"even","sRowEmpty":"dataTables_empty","sWrapper":"dataTables_wrapper","sFilter":"dataTables_filter","sInfo":"dataTables_info","sPaging":"dataTables_paginate fg-buttonset ui-buttonset fg-buttonset-multi "+
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
{_fnInitalise(oSettings);}});};})(jQuery,window,document);