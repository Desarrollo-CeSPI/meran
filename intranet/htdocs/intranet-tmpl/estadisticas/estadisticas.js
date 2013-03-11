
function toggleChecks(){

    var total_checked=($("#total").attr("checked"))?1:0;
    var registrados_checked=($("#registrados:checked").attr("checked"))?1:0;
    var categorias=$("#categoria_socio_id");
    var f_inicio=$("#f_inicio");
    var f_fin=$("#f_fin");

    $("#registrados").removeAttr("disabled");
    categorias.removeAttr("disabled");
    f_inicio.removeAttr("disabled");
    f_fin.removeAttr("disabled");

    if (total_checked){
        $("#registrados").attr("disabled","disabled");
        categorias.attr("disabled","disabled");
        f_inicio.attr("disabled","disabled");
        f_fin.attr("disabled","disabled");
    }
    else{
        if (!registrados_checked){
            categorias.attr("disabled","disabled");
        }
    }
}

function consultarColecciones(){
    var ui=$("#id_ui").val();
    var item_type=$("#tipo_nivel3_id").val();
    var nivel_biblio=$("#id_nivel_bibliografico").val();
    objAH=new AjaxHelper(updateInfo);
    objAH.debug= true;
    objAH.showOverlay = true;
    objAH.url= URL_PREFIX+"/estadisticas/colecciones.pl";
    objAH.ui= ui;
    objAH.nivel_biblio= nivel_biblio;
    objAH.item_type= item_type;
    objAH.fecha_ini= $("#fecha_ini").val();
    objAH.fecha_fin= $("#fecha_fin").val();
    objAH.funcion= 'changePage';
    //se envia la consulta
    objAH.sendToServer();
}

function updateInfo(responseText){
    $("#result_chart").html(responseText);
}

function consultarAccesosOPAC(){
    var total=($("#total").attr("checked"))?1:0;
    var registrados=($("#registrados:checked").attr("checked"))?1:0;
    var tipo_socio=$("#categoria_socio_id").val();
    var f_inicio=$("#f_inicio").val();
    var f_fin=$("#f_fin").val();
    
    objAH=new AjaxHelper(updateInfo);
    objAH.debug= true;
    objAH.url= URL_PREFIX+"/estadisticas/consultas_opac.pl";
    objAH.showOverlay = true;
    objAH.total= total;
    objAH.registrados= registrados;
    objAH.tipo_socio= tipo_socio;
    objAH.f_inicio= f_inicio;
    objAH.f_fin= f_fin;
    //se envia la consulta
    objAH.sendToServer();
}

function consultarBusquedasOPAC(){
    var total=($("#total").attr("checked"))?1:0;
    var registrados=($("#registrados:checked").attr("checked"))?1:0;
    var tipo_socio=$("#categoria_socio_id").val();
    var f_inicio=$("#f_inicio").val();
    var f_fin=$("#f_fin").val();
    
    objAH=new AjaxHelper(updateInfo);
    objAH.debug= true;
    objAH.funcion="changePage";
    objAH.showOverlay = true;
    objAH.url= URL_PREFIX+"/reports/busquedas_opac.pl";
    objAH.total= total;
    objAH.registrados= registrados;
    objAH.tipo_socio= tipo_socio;
    objAH.f_inicio= f_inicio;
    objAH.f_fin= f_fin;
    //se envia la consulta
    objAH.sendToServer();
}

function consultarEstantesVirtuales(){
    var estante=$("#estante_id").val();
    
    objAH=new AjaxHelper(updateInfo);
    objAH.debug= true;
    objAH.funcion="changePage";
    objAH.url= URL_PREFIX+"/estadisticas/estantes_virtuales.pl";
    objAH.showOverlay = true;

    objAH.estante= estante;
    //se envia la consulta
    objAH.sendToServer();
}

jQuery.download = function(url, data, method){
    //url and data options required
    if( url && data ){ 
        //data can be string of parameters or array/object
        data = typeof data == 'string' ? data : jQuery.param(data);
        //split params into form inputs
        var inputs = '';
        jQuery.each(data.split('&'), function(){ 
            var pair = this.split('=');
            inputs+='<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />'; 
        });
        //send request
        jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
        .appendTo('body').submit().remove();
    };
};



function tableToXLS(fileName){

     window.location.href=fileName;


}
