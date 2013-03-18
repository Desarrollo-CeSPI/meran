[% INCLUDE  'AutocompleteHelper.inc'  %]

<script type="text/javascript" src="/intranet-tmpl/includes/reports.js"></script>

<script type="text/javascript">

    var ORDEN   = '';
    var ASC     = 1;

    function changePageBusquedas(ini){
        objAH.changePage(ini);
    }

    function ordenar_reporte_circ(orden){

        if (orden == ORDEN) {
          ASC= !ASC;
        }

        ORDEN = orden;
        generarReporteCirculacion();
    }

    function generarReporteCirculacionGeneral(){

        objAH                   = new AjaxHelper(updateGenerarReporteCirculacionGeneral);
        objAH.debug             = true;
        objAH.cache             = true;
        objAH.showOverlay       = true;
        objAH.url               = URL_PREFIX+'/reports/circulacionDB.pl';
        objAH.tipoAccion        = "CIRC_GENERAL";
        objAH.funcion           = "changePageBusquedas";
        objAH.categoriaSocio    = $('#categoria_socio_id').val();
        // objAH.tipoOperacion     = $('#tipoOperacion').val();
        objAH.nroSocio          = $('#nro_socio_hidden').val();
        objAH.tipoPrestamo      = $('#tipo_prestamo_id').val();
        objAH.fecha_inicio      = $('#date-from-gen').val();
        objAH.fecha_fin         = $('#date-to-gen').val();
        objAH.statistics        = $('#statistics_check').val();
        objAH.orden             = ORDEN;
        objAH.asc               = ASC;
        objAH.sendToServer();
    }

    function updateGenerarReporteCirculacionGeneral(responseText){
        $('#reportResultCirc').html(responseText);
        $('#reportResultCirc').show();
        if (ORDEN){
              cambiarSentidoOrd();
        } 

    }   

    clearUsuario = function(){
        $('#nro_socio_hidden').val('');
        $('#usuario').val('');
    }

    $(document).ready(function(){
        $('#date-from').datepicker();
        $('#date-to').datepicker();

        CrearAutocompleteUsuariosByCredential({ 
            IdInput: 'usuario', 
            IdInputHidden: 'nro_socio_hidden', 
            // callBackFunction: onCompleteUsuarios,
        });
                
    });

</script>

<div class="center_fieldset report_form_container">
    <form class="form-horizontal" id="formReporteCiruculacionGeneral" action="[% url_prefix %]/reports/circulacionDB.pl">

        <input type="hidden" name="tipoAccion" value="EXPORT_CIRC_GENERAL">

        <div class="control-group" id="divComboTipoPrestamo">
            <label for="tipo_prestamo_id" class="control-label">[% 'Tipo de pr&eacute;stamo' | i18n %]</label>  
            <div class="controls">
                [% comboDeTipoPrestamos %]
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="categoria_socio_id">[% 'Categor&iacute;a del usuario' | i18n %]</label>
            <div class="controls">  
                [% comboDeCategorias %]          
            </div>
        </div>

        <div class="control-group">
            <label class="control-label"> [% "Rango de Fechas" | i18n %] </label>
            <div class="controls">
                <input type="text" id="date-from-gen" name="date-from-gen" data-datepicker="datepicker" placeholder="[% 'Desde' | i18n %]" value="" required>
                <input type="text" id="date-to-gen" name="date-to-gen" data-datepicker="datepicker" placeholder="[% 'Hasta' | i18n %]" value="" required>
            </div>
        </div>

        <div id="divInfoUsuario" class="control-group" >
            <label for="usuario" class="control-label">[% 'Responsable' | i18n %]</label>
            <div class="controls">
                <input type='text' id='usuario' name='usuario' value='' size='32' tabindex='3' style="float: left" onclick="clearUsuario();">
                <div id="estadoUsuario"></div>
                <input type='hidden' id='nro_socio_hidden' value='' tabindex='-1'>
            </div>
        </div>

     
          <div class="form-actions">
            [% PERL %]
                  print C4::AR::Filtros::action_button( 
                                                  button       => "btn btn-primary",
                                                  action       => "generarReporteCirculacionGeneral();", 
                                                  icon         => "icon-white icon-inbox",
                                                  title        => "Generar Reporte",
                                              ) ;
            [% END %]
          </div>
      </form>
 </div>
 
<div id="reportResultCirc" style="display:none;"></div>