<script type="text/javascript" src="/intranet-tmpl/includes/reports.js"></script>
<script type="text/javascript" src="/intranet-tmpl/includes/busquedasCatalogo-min.js"></script>
<script>

    var objAH_repE;
    var TIPO;


    $(document).ready(function(){
          onEnter('titulo',busqueda,true);
          onEnter('autor',busqueda,true);
          onEnter('codBarra',busqueda,true);
          onEnter('signatura',busqueda,true);
          onEnter('fecha_ini',busqueda,true);
          onEnter('fecha_fin',busqueda,true);
          onEnter('codBarra1',busqueda,true);
          onEnter('codBarra2',busqueda,true);

          $('#titulo').click(clearRangos);
          $('#signatura').click(clearRangos);
          $('#autor').click(clearRangos);

          $('#fecha_ini').click(clearFromRangoPorFecha);
          $('#fecha_fin').click(clearFromRangoPorFecha);

          $('#codBarra1').click(clearFromRangoPorBarcode);
          $('#codBarra2').click(clearFromRangoPorBarcode);
    });

    function busqueda(){

        objAH_repE                   = new AjaxHelper(updateBusqueda);
        // objAH_repE.debug             = true;
        objAH_repE.showOverlay       = true;
        //para busquedas combinables
        objAH_repE.url               = URL_PREFIX+'/reports/catalogoDB.pl';
        objAH_repE.titulo            = $('#titulo').val();
        objAH_repE.autor             = $('#autor').val();
        objAH_repE.codBarra          = $('#codBarra').val();
        objAH_repE.codBarra1         = $('#codBarra1').val();
        objAH_repE.codBarra2         = $('#codBarra2').val();
        objAH_repE.fecha_ini         = $('#fecha_ini').val();
        objAH_repE.fecha_fin         = $('#fecha_fin').val();
        objAH_repE.signatura         = $('#signatura').val();
        objAH_repE.tipo_reporte      = TIPO;
        //  objAH_repE.asc                = ASC;
        objAH_repE.tipoAccion        = 'REPORTE_GEN_ETIQUETAS';
        //  se setea la funcion para cambiar de pagina
        objAH_repE.funcion           = 'changePage_ReporteGenEtiquetas';
        //  se envia la consulta
        objAH_repE.sendToServer();
        $("#seleccionados").html("");
    }


    function clearRangoPorFecha(){
        $('#fecha_ini').val("");
        $('#fecha_fin').val("");
    }

    function clearRangoPorBarcode(){
        $('#codBarra1').val("");
        $('#codBarra2').val("");
    }

    function clearRangos(){
        clearRangoPorBarcode();
        clearRangoPorFecha();
        TIPO = 'con_grupos';
    }

    function clearCamposCombibables(){
        $('#titulo').val("");
        $('#autor').val("");
        $('#signatura').val("");
    }

    function clearFromRangoPorFecha(){
        clearCamposCombibables();
        clearRangoPorBarcode();
        TIPO = 'sin_grupos';
    }

    function clearFromRangoPorBarcode(){
        clearCamposCombibables();
        clearRangoPorFecha();
        TIPO = 'sin_grupos';
    }

    function changePage_ReporteGenEtiquetas(ini){
        objAH_repE.changePage(ini);
    }


    function updateBusqueda(responseText){
        $('#report_result_gen_etiquetas').html(responseText);
        $('#report_result_gen_etiquetas').show();
    }


    $(document).scroll(function(){
    // If has not activated (has no attribute "data-top"
    if (!$('.subnav').attr('data-top')) {
        // If already fixed, then do nothing
        if ($('.subnav').hasClass('subnav-fixed')) return;
        // Remember top position
        var offset = $('.subnav').offset()
        $('.subnav').attr('data-top', offset.top);
    }

    if ($('.subnav').attr('data-top') - $('.subnav').outerHeight() <= $(this).scrollTop())
        $('.subnav').addClass('subnav-fixed');
    else
        $('.subnav').removeClass('subnav-fixed');
    });


    function generarReporteGenEtiquetas(){

          var limite_caracteres   = 3; //tiene q ser == a lo configurado en sphinx.conf
          var cumple_limite       = true;
          var cumple_vacio        = true;

          
          //primero verifico las busquedas individuales
//           if (doScroll)
//               shouldScroll = doScroll;

          if (  (jQuery.trim($('#titulo').val()) != '') ||
                (jQuery.trim($('#autor').val()) != '') ||
                (jQuery.trim($('#codBarra').val()) != '')||
                (jQuery.trim($('#codBarra1').val()) != '')||
                (jQuery.trim($('#codBarra2').val()) != '')||
                (jQuery.trim($('#fecha_ini').val()) != '')||
                (jQuery.trim($('#fecha_fin').val()) != '')||
                (jQuery.trim($('#signatura').val()) != '')
             ){ 
                busqueda();
              }

//           if (!cumple_limite) {
//               jAlert(INGRESE_AL_MENOS_TRES_CARACTERES_PARA_REALIZAR_LA_BUSQUEDA);
//           } else if (!cumple_vacio) {
//               jAlert(INGRESE_DATOS_PARA_LA_BUSQUEDA)
//           }

      
    }
      
</script>


<div class="center_fieldset report_form_container">
      <form class="form-horizontal" id="form_reporte_gen_etiquetas" onsubmit="false">
            <legend class="titulo_legend">Búsqueda combinable</legend>

                <div class="control-group">
                        <label class="control-label" for="titulo"> 
                            [% "T&iacute;tulo" %]
                        </label>
                        <div class="controls"> 
                            <input type="text"  size="25" id="titulo">
                        </div>
                </div>
                        
                <div class="control-group">
                        <label class="control-label" for="autor">
                            [% "Autor" %]
                        </label>
                        <div class="controls">
                          <input type="text" size="25" id="autor">
                        </div>
                </div>

                <div class="control-group">
                    <label class="control-label" for="signatura">
                        [% "Signatura Topogr&aacute;fica" | i18n %]
                    </label>
                    <div class="controls">
                        <input type="text" size="25" id="signatura">
                    </div>
                </div>

            <legend class="titulo_legend">Búsqueda no combinable</legend>

                <div class="control-group">
                    <label class="control-label"  for="fecha_alta"> [% "Por rango de Nro. de Inventario" | i18n %]</label>
                    <div class="controls">
                            <input type="text" id="codBarra1" name="codBarra1" placeholder="Desde" value="" required>
                            <input type="text" id="codBarra2" name="codBarra2" placeholder="Hasta" value="" required>
                    </div>         
                </div>
                <div class="control-group">
                    <label class="control-label"  for="fecha_alta"> [% "Por rango de Fecha de Alta" | i18n %]</label>
                    <div class="controls">
                            <input type="text" id="fecha_ini" name="fecha_ini" data-datepicker="datepicker"  placeholder="Desde" value="" required>
                            <input type="text" id="fecha_fin" name="fecha_fin" data-datepicker="datepicker" placeholder="Hasta" value="" required>
                    </div>         
                </div>
          
                <div class="form-actions">
                  [% PERL %]
                        print C4::AR::Filtros::action_button( 
                                                        button       => "btn btn-primary",
                                                        action       => "generarReporteGenEtiquetas()", 
                                                        icon         => "icon-white icon-inbox",
                                                        title        => '[% "Generar Reporte" | i18n %]',
                                                    ) ;
                  [% END %]
                </div>
      </form>
      
 </div>

    <form id="formSeleccionados" name="formSeleccionados" action="[% url_prefix %]/catalogacion/barcode_gen.pl" method="post">      
        <input type='hidden' name='etiquetas' value='etiquetas'>
        <div class="alert alert-info subnav" id="seleccionados" name="seleccionados" style="max-width: 1400px !important; display:none;">
        </div>
    </form>

    <div id="report_result_gen_etiquetas" style="display:none;"></div>
