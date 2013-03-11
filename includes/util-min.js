var ancla="";function buttonPost(button_id){$('#'+button_id).addClass("disabled");$('#'+button_id).text(GUARDANDO+"...");}
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
function historyBack(){window.history.back();}