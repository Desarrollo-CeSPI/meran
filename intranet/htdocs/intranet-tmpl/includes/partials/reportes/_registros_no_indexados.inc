[% INCLUDE  'AutocompleteHelper.inc'  %]

<script type="text/javascript" src="/intranet-tmpl/includes/reports.js"></script>
<script>

    function generarReporteRegistrosNoIndexados(){

        objAH               = new AjaxHelper(updateGenerarReporteRegistrosNoIndexados);
        objAH.debug         = true;
        objAH.cache         = false;
        objAH.showOverlay   = true;
        objAH.url           = URL_PREFIX+'/reports/catalogoDB.pl';
        objAH.tipoAccion    =  "REGISTROS_NO_INDEXADOS";
        //se envia la consulta
        objAH.sendToServer();
    }

    function updateGenerarReporteRegistrosNoIndexados(responseText){
        $('#report_result_registros_no_indexados').html(responseText);
        $('#report_result_registros_no_indexados').show();
    }
   
        
</script>

<div style="width: 300px; margin: 0 auto;">

        [% PERL %]
                print C4::AR::Filtros::action_button( 
                                                button         => "btn btn-warning btn-large",
                                                action       => "generarReporteRegistrosNoIndexados()", 
                                                icon         => "icon-white icon-eye-open",
                                                title        => "[% 'Ver registros no indexados' | i18n %]",
                                            ) ;

        [% END %]
</div>

<div id="report_result_registros_no_indexados" style="display:none;"></div>