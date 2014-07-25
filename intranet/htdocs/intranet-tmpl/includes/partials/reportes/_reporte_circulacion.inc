[% INCLUDE 'AutocompleteHelper.inc' %]

<script type="text/javascript" src="/intranet-tmpl/includes/reports.js"></script>
<script>

    var ORDEN   = 'fecha';
    var ASC     = 0;

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

    
    function generarReporteCirculacion(){

        objAH                   = new AjaxHelper(updateGenerarReporteCirculacion);
        objAH.debug             = true;
        objAH.cache             = true;
        objAH.showOverlay       = true;
        objAH.url               = URL_PREFIX+'/reports/circulacionDB.pl';
        objAH.tipoAccion        = "BUSQUEDAS";
        objAH.funcion           = "changePageBusquedas";
        objAH.categoriaSocio    = $('#categoriaSocioReservas').val();
        objAH.tipoDoc           = $('#tipo_nivel3_id').val();
        objAH.titulo            = $('#titulo').val();
        objAH.autor             = $('#autor').val();
        objAH.estadoReserva     = $('#estadoReserva').val();
        objAH.fecha_inicio      = $('#date-from').val();
        objAH.fecha_fin         = $('#date-to').val();
        objAH.signatura         = $('#signatura').val();
        objAH.orden             = ORDEN;
        objAH.asc               = ASC;
        objAH.sendToServer();
    }

    function updateGenerarReporteCirculacion(responseText){
        $('#reportResultCirc2').html(responseText);
        $('#reportResultCirc2').show();
        if (ORDEN){
              cambiarSentidoOrd();
        } 

    }   
   

    $(document).ready( function(){ 
         if (!Modernizr.inputtypes.date) {
              $("date-from").datepicker();
              $("date-to").datepicker();
        }
        $(".cb-enable").click(function(){
            var parent = $(this).parents('.switch');
            $('.cb-disable',parent).removeClass('selected');
            $(this).addClass('selected');
            $('.checkbox',parent).attr('checked', true);
        });
        $(".cb-disable").click(function(){
            var parent = $(this).parents('.switch');
            $('.cb-enable',parent).removeClass('selected');
            $(this).addClass('selected');
            $('.checkbox',parent).attr('checked', false);
        });
    });
        
</script>

<div class="center_fieldset report_form_container">
    <form class="form-horizontal" id="formReporteCirculacion" action="[% url_prefix %]/reports/circulacionDB.pl">

        <input type="hidden" name="tipoAccion" value="EXPORT_CIRC">

        <div class="control-group">
            <label class="control-label" for="categoria_socio_id">[% 'Categor&iacute;­a del usuario' | i18n %]</label>
            <div class="controls">  
                [% comboDeCategoriasReservas %]          
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="tipo_documento_id">[% 'Tipo de documento' | i18n %]</label>
            <div class="controls">  
                [% comboDeTipoDoc %]          
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="autor">
                [% "Autor" %]
            </label>
            <div class="controls">
              <input type="text" size="25" name="autor" id="autor">
            </div>
        </div>


        <div class="control-group">
            <label class="control-label" for="titulo">[% 'T&iacute;­tulo' | i18n %]</label>
            <div class="controls">  
                <input type="text" id="titulo" name="titulo" >       
            </div>
        </div>

        <div class="control-group" >
            <label for="estadoReserva" class="control-label">[% 'Operaci&oacute;n' | i18n %]</label>  
            <div class="controls">
                <select name="estadoReserva" id="estadoReserva">
                    <option value="TODAS">Todas</option>
                    <option value="RESERVA">Reserva</option>
                    <option value="ASIGNACION">Asignaci&oacute;n</option>
                    <option value="ESPERA">Reserva en espera</option>
                    <option value="CANCELACION">Cancelaci&oacute;n</option>
                    <option value="CANCELACION SISTEMA">Cancelaci&oacute;n por Sistema</option>
                </select>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label"> [% "Rango de Fechas" | i18n %] </label>
            <div class="controls">
                <input type="text" id="date-from" name="date-from" data-datepicker="datepicker" placeholder="[% 'Desde' | i18n %]" value="" required>
                <input type="text" id="date-to" name="date-to" data-datepicker="datepicker" placeholder="[% 'Hasta' | i18n %]" value="" required>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="signatura">
                [% "Signatura Topogr&aacute;fica" | i18n %]
            </label>
            <div class="controls">
                <input type="text" size="25" id="signatura" name="signatura">
            </div>
        </div>
          
        <div class="form-actions">
            [% PERL %]
                  print C4::AR::Filtros::action_button( 
                                                  button       => "btn btn-primary",
                                                  action       => "generarReporteCirculacion();", 
                                                  icon         => "icon-white icon-inbox",
                                                  title        => "Generar Reporte",
                                              ) ;
            [% END %]
        </div>
    </form>
</div>


<div id="reportResultCirc2" style="display:none;"></div>
 