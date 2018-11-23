<script type="text/javascript" src="/intranet-tmpl/includes/reports.js"></script>
<script type="text/javascript" src="/intranet-tmpl/includes/busquedasCatalogo-min.js"></script>
<script>

    var objAH_repE;
    var TIPO;


    $(document).ready(function(){
          onEnter('titulo_inv',busquedaInventario,true);
          onEnter('autor_inv',busquedaInventario,true);
          onEnter('codBarra_inv',busquedaInventario,true);
          onEnter('signatura_inv',busquedaInventario,true);
          onEnter('fecha_ini_inv',busquedaInventario,true);
          onEnter('fecha_fin_inv',busquedaInventario,true);
          onEnter('codBarra1_inv',busquedaInventario,true);
          onEnter('codBarra2_inv',busquedaInventario,true);
          onEnter('signatura1_inv',busquedaInventario,true);
          onEnter('signatura2_inv',busquedaInventario,true);

          $('#titulo_inv').click(clearRangosInv);
          $('#signatura_inv').click(clearRangosInv);
          $('#autor_inv').click(clearRangosInv);

          $('#fecha_ini_inv').click(clearFromRangoPorFechaInv);
          $('#fecha_fin_inv').click(clearFromRangoPorFechaInv);

          $('#codBarra1_inv').click(clearFromRangoPorBarcodeInv);
          $('#codBarra2_inv').click(clearFromRangoPorBarcodeInv);

          $('#signatura1_inv').click(clearFromRangoPorSignaturaInv);
          $('#signatura2_inv').click(clearFromRangoPorSignaturaInv);
    });

    function busquedaInventario(){

        objAH_repE                   = new AjaxHelper(updateBusqueda);
        // objAH_repE.debug             = true;
        objAH_repE.showOverlay       = true;
        //para busquedas combinables
        objAH_repE.url               = URL_PREFIX+'/reports/catalogoDB.pl';
        objAH_repE.titulo            = $('#titulo_inv').val();
        objAH_repE.autor             = $('#autor_inv').val();
        objAH_repE.codBarra          = $('#codBarra_inv').val();
        objAH_repE.codBarra1         = $('#codBarra1_inv').val();
        objAH_repE.codBarra2         = $('#codBarra2_inv').val();
        objAH_repE.fecha_ini         = $('#fecha_ini_inv').val();
        objAH_repE.fecha_fin         = $('#fecha_fin_inv').val();
        objAH_repE.signatura         = $('#signatura_inv').val();
        objAH_repE.signatura1        = $('#signatura1_inv').val();
        objAH_repE.signatura2        = $('#signatura2_inv').val();
        
        objAH_repE.tipo_reporte      = TIPO;
        //  objAH_repE.asc                = ASC;
        objAH_repE.tipoAccion        = 'REPORTE_INVENTARIO';
        //  se setea la funcion para cambiar de pagina
        objAH_repE.funcion           = 'changePage_ReporteInventario';
        //  se envia la consulta
        objAH_repE.sendToServer();
        $("#seleccionados").html("");
    }


    function clearRangoPorFechaInv(){
        $('#fecha_ini_inv').val("");
        $('#fecha_fin_inv').val("");
    }

    function clearRangoPorBarcodeInv(){
        $('#codBarra1_inv').val("");
        $('#codBarra2_inv').val("");
    }

    function clearRangoPorSignaturaInv(){
        $('#signatura1_inv').val("");
        $('#signatura2_inv').val("");
    }

    function clearRangosInv(){
        clearRangoPorBarcode();
        clearRangoPorFecha();
        TIPO = 'con_grupos';
    }

    function clearCamposCombibablesInv(){
        $('#titulo_inv').val("");
        $('#autor_inv').val("");
        $('#signatura_inv').val("");
    }

    function clearFromRangoPorFechaInv(){
        clearCamposCombibables();
        clearRangoPorBarcode();
        clearRangoPorSignatura();
        TIPO = 'sin_grupos';
    }

    function clearFromRangoPorBarcodeInv(){
        clearCamposCombibables();
        clearRangoPorFecha();
        clearRangoPorSignatura();
        TIPO = 'sin_grupos';
    }


    function clearFromRangoPorSignaturaInv(){
        clearCamposCombibables();
        clearRangoPorFecha();
        clearRangoPorBarcode();
        TIPO = 'sin_grupos';
    }

    function changePage_ReporteInventario(ini){
        objAH_repE.changePage(ini);
    }


    function updateBusqueda(responseText){
        $('#report_result_inventario').html(responseText);
        $('#report_result_inventario').show();
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


    function generarReporteInventario(){

          var limite_caracteres   = 3; //tiene q ser == a lo configurado en sphinx.conf
          var cumple_limite       = true;
          var cumple_vacio        = true;

          
          //primero verifico las busquedas individuales
//           if (doScroll)
//               shouldScroll = doScroll;

          if (  (jQuery.trim($('#titulo_inv').val()) != '') ||
                (jQuery.trim($('#autor_inv').val()) != '') ||
                (jQuery.trim($('#codBarra_inv').val()) != '')||
                (jQuery.trim($('#codBarra1_inv').val()) != '')||
                (jQuery.trim($('#codBarra2_inv').val()) != '')||
                (jQuery.trim($('#fecha_ini_inv').val()) != '')||
                (jQuery.trim($('#fecha_fin_inv').val()) != '')||
                (jQuery.trim($('#signatura_inv').val()) != '')||
                (jQuery.trim($('#signatura1_inv').val()) != '')||
                (jQuery.trim($('#signatura2_inv').val()) != '')
             ){ 
                busquedaInventario();
              }

//           if (!cumple_limite) {
//               jAlert(INGRESE_AL_MENOS_TRES_CARACTERES_PARA_REALIZAR_LA_BUSQUEDA);
//           } else if (!cumple_vacio) {
//               jAlert(INGRESE_DATOS_PARA_LA_BUSQUEDA)
//           }

      
    }
      
</script>


<div class="center_fieldset report_form_container">
      <form class="form-horizontal" id="form_reporte_inventario" action="[% url_prefix %]/reports/catalogoDB.pl" method="get" >
          <input type='hidden' id='accion' name="accion" value='REPORTE_INVENTARIO'>
          <input type='hidden' id='exportar' name="exportar" value='1'>

            <legend class="titulo_legend">Búsqueda</legend>

                <div class="control-group">
                    <label class="control-label"  for="fecha_alta"> [% "Por rango de Nro. de Inventario" | i18n %]</label>
                    <div class="controls">
                            <input type="text" id="codBarra1_inv" name="codBarra1_inv" placeholder="Desde" value="" required>
                            <input type="text" id="codBarra2_inv" name="codBarra2_inv" placeholder="Hasta" value="" required>
                    </div>         
                </div>

                <div class="form-actions">
                  [% PERL %]
                        print C4::AR::Filtros::action_button( 
                                                        button       => "btn btn-primary",
                                                        action       => "generarReporteInventario()", 
                                                        icon         => "icon-white icon-inbox",
                                                        title        => '[% "Generar Reporte" | i18n %]',
                                                    ) ;
                  [% END %]
                </div>
      </form>
      
 </div>

<div id="report_result_inventario" style="display:none;"></div>
