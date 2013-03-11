[% INCLUDE  'AutocompleteHelper.inc'  %]

<script type="text/javascript" src="/intranet-tmpl/includes/reports.js"></script>
<script>

    var ORDEN="valor";
    var ASC= 1;

    function changePageBusquedas(ini){
        objAH.changePage(ini);
    }


    function exportarPDF(){
        $('#accion').val('EXPORTAR_PDF');  
        $('#form_reporte_busquedas').submit();
    }

  
    function ordenar_reporte_busquedas(orden){
              if (orden == ORDEN) {
                  ASC= !ASC;
              }
              ORDEN = orden; 
              $('#orden').val(ORDEN);
              $('#asc').val(ASC);
              generarReporteBusquedas();
    }


    function generarReporteBusquedas(){

        objAH               = new AjaxHelper(updateGenerarReporteBusquedas);
        objAH.debug         = true;
        objAH.cache         = true;
        objAH.showOverlay   = true;
        objAH.url           = URL_PREFIX+'/reports/catalogoDB.pl';
        objAH.tipoAccion    =  "BUSQUEDAS";
        objAH.funcion       = "changePageBusquedas";
        objAH.usuario       =  $('#nro_socio_hidden').val();
        objAH.categoria     =  $('#categoria_socio_id').val();
        objAH.interfaz      =  $('#interfaz').val();
        objAH.valor         =  $('#valor').val();
        objAH.fecha_inicio  =  $('#date-from').val();
        objAH.fecha_fin     =  $('#date-to').val();
        objAH.statistics    =  $('#statistics_check').val();
        objAH.orden         = ORDEN;
        objAH.asc           = ASC;
        //se envia la consulta
        objAH.sendToServer();
    }

    function updateGenerarReporteBusquedas(responseText){
        $('#report_result_busq').html(responseText);
        $('#report_result_busq').show();
        if (ORDEN){
              cambiarSentidoOrd();
        } 
    }
   

    $(document).ready( function(){ 
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
         if (!Modernizr.inputtypes.date) {
              $("date-from").datepicker();
              $("date-to").datepicker();
        }
       
        $('#orden').val(ORDEN);
        $('#asc').val(ASC);

        CrearAutocompleteUsuarios({ 
                                                    IdInput: 'usuario', 
                                                    IdInputHidden: 'nro_socio_hidden', 
                                                    callBackFunction: '',
                                });
    });
        
</script>

<div class="center_fieldset report_form_container">
      <form class="form-horizontal" id="form_reporte_busquedas" action="[% url_prefix %]/reports/catalogoDB.pl" method="get">
          <input type='hidden' id='accion' name="accion" value='BUSQUEDAS'>
          <input type='hidden' id='orden' name="orden" value=''>
          <input type='hidden' id='asc' name="asc" value=''>
          <input type='hidden' id='exportar' name="exportar" value='1'>

          <div id="divInfoUsuario" class="control-group" >
              <label for="usuario" class="control-label">[% 'Usuario' | i18n %]
                  [% PERL %]
                      print C4::AR::Filtros::setHelpIcon( text => "[% 'Campo autocompletable, b&uacute;squeda por nombre, apellido, nro. de documento, legajo, nro. socio' | i18n %]",);
                  [% END %]
              </label>
              <div class="controls">
                  <input type='text' id='usuario' name='usuario' value='' size=32 tabindex='3' style="float: left">
                  <div id="estadoUsuario"></div>
                  <input type='hidden' id='nro_socio_hidden' name="nro_socio" value='' tabindex='-1'>
              </div>
          </div>
  
          <div class="control-group">
            <label class="control-label"  for="categoria_socio_id">Categor&iacute;­a del usuario</label>
            <div class="controls">  
                          [% comboDeCategorias %]          
            </div>
          </div><!-- /control-group -->

          <div class="control-group">
              <label class="control-label"  for="interfaz">Interfaz</label>
              <div class="controls">
                <select name="interfaz" id="interfaz">
                  <option>OPAC</option>
                  <option>Intra</option>
                  <option>Ambas</option>
                </select>
              </div>
          </div><!-- /control-group -->


          <div class="control-group">
            <label class="control-label"  for="name">Valor</label>
            <div class="controls">
                <input class="xlarge" id="valor" name="valor" size="30" type="text">
              <p class="help-block">Ej. Econom&iacute;a</p>
            </div>
          </div><!-- /control-group -->
         <!-- <div class="control-group">
            <label class="control-label"  for="name">Estantes virtuales/subestante</label>
            <div class="controls">
              <input class="xlarge" id="estante" name="estante" size="30" type="text">
              <p class="help-block">Ej. Econom&iacute;a</p>
            </div>
          </div>--><!-- /control-group -->
           <div class="control-group">
                    <label class="control-label"> [% "Rango de Fechas" | i18n %] </label>
                    <div class="controls">
                          <input type="date" id="date-from" name="date-from" data-datepicker="datepicker" placeholder="Desde" value="" required>
                          <input type="date" id="date-to" name="date-to" data-datepicker="datepicker" placeholder="Hasta" value="" required>

                    </div>
          </div>
          <div class="control-group">
                    <label  class="control-label" for="statistics_check">Generar estadisticas</label>
                    <div class="controls">
                        <label class="checkbox">
                          <input type="checkbox" name="statistics_check" id="statistics_check"/>
                        </label>
                    </div>
          </div>        
          
          <div class="form-actions">
            [% PERL %]
                  print C4::AR::Filtros::action_button( 
                                                  button       => "btn btn-primary",
                                                  action       => "generarReporteBusquedas();", 
                                                  icon         => "icon-white icon-inbox",
                                                  title        => ' [% "Generar Reporte" | i18n %]',
                                              ) ;
            [% END %]
          </div>
      </form>
 </div>
 
<div id="report_result_busq" style="display:none;"></div>