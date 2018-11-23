<script type="text/javascript" src="/intranet-tmpl/includes/adquisiciones/tabletojson.js"> </script>
<script type="text/javascript" src="/includes/jquery/jquery.nanoscroller.js"></script>

[% IF cantidad %]
      <div class="well">

              <div class="resultados_consulta">[% "La cantidad de resultados es" | i18n %]: <strong>[% cantidad %]</strong></div>
                      
      </div>
[% END %]
[% IF cantidad %]
<div class="contenedor_paginador">[% paginador %]</div> 
<div>   
              [% PERL %]
                print C4::AR::Filtros::tableHeader(   
                                  id              => "tablaResult",
                                  class           => "",
                                  columns         => ['[% "Fecha de ingreso" | i18n %]', '[% "Inventario" | i18n %]', '[% "Autor" | i18n %]', '[% "Título" | i18n %]',  '[% "Edición" | i18n %]','[% 'Editor' | i18n %]', '[% "Año de edición" | i18n %]'               
                                                      ],
                            
                                  ) ;
              [% END %]

              <tbody>
    [% FOREACH SEARCH_RESULTS %]

                <tr id="[% nivel3.id %]_tr">
                        <td id="date[% nivel3.id %]">[% nivel3.getCreatedAt %]</td>
                        <td id="barcode[% nivel3.id %]">[% nivel3.getBarcode %]</td>
                        <td id="autor[% nivel3.id %]">[% nivel3.nivel1.getAutorStringEscaped %]</td>
                        <td>
                        [% PERL %]
                            print C4::AR::Filtros::link_to( text    =>  "[% nivel3.nivel1.getTituloStringEscaped %]",
                                                            url     =>  "[% url_prefix %]/catalogacion/estructura/detalle.pl", 
                                                            params  =>  ["id1=[% nivel3.nivel1.getId1 %]"],
                                                            title   =>  "[% 'Mostrar Detalle del Registro' | i18n %]",
                                                            class   =>  "link_to_detail",
                                                            on_click=> "startOverlay();"

                                                        ) ;
                        [% END %]
                        </td>
                        <td id="edition[% nivel3.id %]">[% nivel3.nivel2.getEdicion %]</td>
                        <td id="editor[% nivel3.id %]">[% nivel3.nivel2.getEditor %]</td>
                        <td id="publication_year[% nivel3.id %]">[% nivel3.nivel2.getAnio_publicacion %]</td> 
                </tr>

          [% END %]
              </tbody>
        </table>
</div>
<div class="form-actions"  id="button-seleccionados"> 
    [% PERL %]
                print C4::AR::Filtros::action_button( 
                                                button      => "btn btn-success",
                                                action      => 'imprimirReporte("form_reporte_inventario","XLS");',
                                                icon        => "icon-white icon-bookmark",
                                                title       => " [% 'Exportar Reporte' | i18n %]"
                                            ) ;
            [% END %]
</div>
[% ELSE %]
      <div class="alert alert-info">No se han encontrado resultados.</div>
[% END %]