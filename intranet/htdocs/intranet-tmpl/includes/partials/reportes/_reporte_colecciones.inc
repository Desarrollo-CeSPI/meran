[% INCLUDE  'AutocompleteHelper.inc'  %]

<script type="text/javascript" src="/intranet-tmpl/includes/reports.js"></script>
<script type="text/javascript" src="/intranet-tmpl/estadisticas/estadisticas.js"></script>


<div class="center_fieldset report_form_container">  
    <form class="form-horizontal" id="form_reporte_colecciones" action="[% url_prefix %]/estadisticas/colecciones.pl">
        <input type="hidden" name="exportar" value="1">

        <div class="control-group">
            <label class="control-label"  for="tipo_item">[% "Tipo de item" | i18n %]</label>
            <div id="tipo_item" class="controls">  
                     [% item_type_combo %]         
            </div>   
        </div>

        <div class="control-group">
            <label class="control-label"  for="ui"> [% "Unidad de informaci&oacute;n" | i18n %]</label>
            <div id="ui" class="controls">  
                     [% ui_combo %]      
             </div>            
        </div>

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
            <label class="control-label"  for="nivel_bibliografico"> [% "Nivel Bibliogr&aacute;fico" | i18n %]</label>
            <div id="nivel_bibliografico" class="controls">  
                     [% comboNivelBibliografico %]      
             </div>            
        </div>

        <div class="control-group">
            <label class="control-label"  for="fecha_alta"> [% "Fecha de Alta" | i18n %]</label>
            <div class="controls">
                    <input type="text" id="fecha_ini" name="fecha_ini" data-datepicker="datepicker"  placeholder="Desde" value="" required>
                    <input type="text" id="fecha_fin" name="fecha_fin" data-datepicker="datepicker" placeholder="Hasta" value="" required>
            </div>         

                  
        
        </div>
        
        <div class="form-actions">
            [% PERL %]
                    print C4::AR::Filtros::action_button( 
                                                        button       => "btn btn-primary",
                                                        action       => "consultarColecciones();", 
                                                        icon         => "icon-white icon-inbox",
                                                        title       =>'[% "Generar Reporte"|i18n %]',
                                                    );
            [% END %]
        </div>
    </form> 
</div>
<div id="report_col_result" style="display:none;"></div>
<div id="result_chart"></div>


