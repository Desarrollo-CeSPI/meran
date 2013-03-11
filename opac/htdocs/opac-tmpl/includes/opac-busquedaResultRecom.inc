<script type="text/javascript">
    $(document).ready(function() {
        $('.fancylink').fancybox();
    });
</script>
[% IF (cantidad > 0) || ( (!from_suggested) && (suggested) )%]
    [% FOREACH NIVEL IN SEARCH_RESULTS %]
        <script type="text/javascript">
            $(function(){
                $("#rating[% NIVEL.id1 %]").children().not(":radio").hide();
                $("#rating[% NIVEL.id1 %]").stars({
                    cancelShow: false,
                    split: 2,
                    disabled: true
                });
                $("#rating[% NIVEL.id1 %]").stars("select",[% NIVEL.rating %]);
            });
        </script>
    [% END %]
    [% IF SEARCH_RESULTS %]
        [% IF show_search_details %]
            <p><div class="resultados_consulta">[% "T&eacute;rmino de b&uacute;squeda:" | i18n %] [% buscoPor %]</div>
            <div class="resultados_consulta">[% "Cantidad de Registros:" | i18n %] [% cantidad %] en ([% timeSeg %] segundos)</div></p>
            <p><div class="contenedor_paginador">[% paginador %]</div></p>
        [% END %]
        [% IF !from_suggested %]
            [% IF suggested %]
                    <div class="suggested_search">
                        <a href="[% url_prefix %]/opac-busquedasDB.pl?string=[% suggested %]&tipoAccion=[% tipoAccion %]&from_suggested=1&only_available=[% only_available %]&token=[% token %]">
                            [% "Usted quiso decir" | i18n %] <span style="font-style: italic">[% suggested %]</span>?
                        </a>
                    </div>
            [% END %]
        [% END %]
        <table id="tablaResult" class="tabla_datos" cellspacing='0' cellpadding='0' style="text-align:center; width:100%; border:1;">
                <tr class="tablaresultadoTitle" >
                    <th align="center">
                        [% "T&iacute;tulo" | i18n %]
                    </th>
                    <th align="center">
                        [% "Autor" | i18n %]
                    </th>
                    <th align="center">
                        [% "Edici&oacute;n/A&ntilde;o" | i18n %]
                    </th>
                </tr>
        <!-- Resultados de la busqueda -->
                [% FOREACH NIVEL IN SEARCH_RESULTS %]
                    <tr>
                        <td class="titulo_result">  
                            [% IF NIVEL.titulo %]
                                [% PERL %]
                                    print C4::AR::Filtros::link_to( text =>     "( [% NIVEL.hits %] ) - [% NIVEL.titulo %]",
                                                                    url =>      "[% url_prefix %]/opac-detail.pl", 
                                                                    params =>   ["id1=[% NIVEL.id1 %]"],
                                                                    title =>    "[% 'Mostrar Detalle del Ejemplar' | i18n %]"
                                                                ) ;
                                [% END %]
                            [% ELSE %]
                                &nbsp;
                            [% END %]
                        </td>

                        <td class="autor_result click" title="[% 'Filtrar por Autor' | i18n %]">
                            [% IF NIVEL.nomCompleto %]
                                [% NIVEL.nomCompleto %]
                            [% ELSE %]
                                &nbsp;
                            [% END %]
                        </td>
                        <td>
                            [% IF NIVEL.grupos %]
                                [% FOREACH NIVEL.grupos %]
                                    [% IF edicion %]
                                        [% edicion %] &nbsp;
                                    [% END %]
                                    [% IF anio_publicacion %]
                                        ([% anio_publicacion %])
                                    [% END %]
                                    [% IF volume %] 
                                        t [% volume %]
                                    [% END %]
                                    <br />
                                [% END %]
                            [% ELSE %]
                                &nbsp;
                            [% END %]
                        </td>
                    </tr>
                [% END %]
        </table>
        <br />
        <div class="contenedor_paginador">[% paginador %]</div>
    [% END %]
    <!-- FIX PARA W3C PORQUE NO SE PERMITEN SCRIPT DENTRO DE TABLAS -->
[% ELSE %]
    [% IF no_content_message %]
        <h1> [% no_content_message %] </h1>  
    [% ELSE %]
        <h1> [% 'Nada que mostrar.' | i18n %] </h1>
    [% END %]
[% END %]
