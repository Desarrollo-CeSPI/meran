<script type="text/javascript" src="/intranet-tmpl/includes/reports.js"></script>
<script type="text/javascript" src="/intranet-tmpl/includes/busquedasCatalogo-min.js"></script>
<script>

    var objAH_repE;


    $(document).ready(function(){
          onEnter('titulo',busqueda,true);
          onEnter('autor',busqueda,true);
          onEnter('codBarra',busqueda,true);
          onEnter('signatura',busqueda,true);
    });

    function busqueda(){

        objAH_repE                   = new AjaxHelper(updateBusqueda);
        objAH_repE.debug             = true;
        objAH_repE.showOverlay       = true;
        //para busquedas combinables
        objAH_repE.url               = URL_PREFIX+'/reports/catalogoDB.pl';
        objAH_repE.titulo            = $('#titulo').val();
        objAH_repE.autor             = $('#autor').val();
        objAH_repE.codBarra          = $('#codBarra').val();
        //  objAH_repE.asc                = ASC;
        objAH_repE.tipoAccion        = 'REPORTE_GEN_ETIQUETAS';
        //  se setea la funcion para cambiar de pagina
        objAH_repE.funcion           = 'changePage_ReporteGenEtiquetas';
        //  se envia la consulta
        objAH_repE.sendToServer();
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
                (jQuery.trim($('#codBarra').val()) != '')
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
                    <label class="control-label" for="codBarra">
                        [% "C&oacute;digo de barras" | i18n %]
                    </label>
                    <div class="controls">
                        <input type="text" size="25" id="codBarra">
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
          
                <div class="form-actions">
                  [% PERL %]
                        print C4::AR::Filtros::action_button( 
                                                        button       => "btn btn-primary",
                                                        action       => "generarReporteGenEtiquetas()", 
                                                        icon         => "icon-white icon-search",
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
