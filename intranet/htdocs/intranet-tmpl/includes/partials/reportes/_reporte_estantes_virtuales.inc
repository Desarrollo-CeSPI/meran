[% INCLUDE  'AutocompleteHelper.inc'  %]

<script type="text/javascript" src="/intranet-tmpl/includes/reports.js"></script>

<div class="center_fieldset report_form_container">  
    <form class="form-horizontal" id="form_reporte_estantes_virtuales" action="[% url_prefix %]/estadisticas/estantes_virtuales.pl">
        <input type="hidden" name="exportar" value="1">

        <div class="control-group">
            <label class="control-label"  for="tipo_item">[% "Estante Virtual" | i18n %]</label>
            <div id="tipo_item" class="controls">  
                     [% comboEstantesVirtuales %]         
            </div>   
        </div>

        <div class="form-actions">
            [% PERL %]
                    print C4::AR::Filtros::action_button( 
                                                        button       => "btn btn-primary",
                                                        action       => "reporteEstantesVirtuales();", 
                                                        icon         => "icon-white icon-search",
                                                        title       =>'[% "Buscar"|i18n %]',
                                                    );
            [% END %]
        </div>
    </form> 
</div>
<div id="report_estante_result" style="display:none;"></div>
<div id="result_chart"></div>

