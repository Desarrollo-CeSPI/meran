[% INCLUDE  'AutocompleteHelper.inc'  %]

<script type="text/javascript" src="/intranet-tmpl/includes/reports.js"></script>
<script type="text/javascript" src="/intranet-tmpl/estadisticas/estadisticas.js"></script>


<div class="center_fieldset report_form_container">  
    <form class="form-horizontal" id="form_reporte_disponibilidad" action="[% url_prefix %]/estadisticas/disponibilidad.pl">
        
        <input type="hidden" name="exportar" value="1">
        <div class="control-group">
            <label class="control-label"  for="ui"> [% "Unidad de informaci&oacute;n" | i18n %]</label>
            <div id="uni_inf" class="controls">  
                     [% ui_combo %]      
            </div>            
        </div>

        <div class="control-group">
            <label class="control-label"  for="ui"> [% "Disponibilidad" | i18n %]</label>
            <div id="disponibilidad" class="controls">  
                     [% disp_combo %]      
            </div>            
        </div>

        <div class="control-group">
            <label class="control-label"  for="fecha_alta"> [% "Fecha de Alta" | i18n %]</label>
            <div class="controls">
                    <input type="text" id="fecha_inicio" name="fecha_ini" data-datepicker="datepicker"  placeholder="Desde" value="" required>
                    <input type="text" id="fecha_final" name="fecha_fin" data-datepicker="datepicker" placeholder="Hasta" value="" required>
            </div>         

        </div>
            <div class="form-actions">
                [% PERL %]
                        print C4::AR::Filtros::action_button( 
                                                            button       => "btn btn-primary",
                                                            action       => "reporteDisponibilidad();", 
                                                            icon         => "icon-white icon-search",
                                                            title       =>'[% "Buscar"|i18n %]',
                                                        );
                [% END %]
            </div>
   
    </form>
</div>

<div id="report_disp_result" style="display:none;"></div>

<!-- <div id="result_chart"></div> -->
