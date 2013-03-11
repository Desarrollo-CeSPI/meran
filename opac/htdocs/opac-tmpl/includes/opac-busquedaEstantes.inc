[% USE HTML %]
[% IF show_search_details %]
   <div class="well">
          <div class="resultados_consulta">[% "T&eacute;rmino de b&uacute;squeda:" | i18n %] <strong>[% buscoPor | html %]</strong></div>
        
          <div class="resultados_consulta">[% "Cantidad de Registros:" | i18n %] [% cantidad %] en ([% timeSeg %] segundos)</div>
   </div>
     <div class="contenedor_paginador">[% paginador %]</div>
[% END %]

    [% IF cantidad > 0 %]

            [% PERL %]
                      print C4::AR::Filtros::tableHeader(   
                                        id              => "tablaResult",
                                        class           => "",
                                        selectAll_id    => "",
                                        columns         => ['[% "Estante"|i18n %]']                                  
                      ) ;
            [% END %]
    
            </tbody>
            <!-- Actual Resultados de la b&uacute;squeda -->
                  [% FOREACH estante IN SEARCH_RESULTS %]
                      <tr class="datos_tabla_estantes">
                          <td>
                    [% auxEstante = estante %]
                    [% listaEstantes = '' %]
                    [% WHILE auxEstante > 0 %]
                        [% IF listaEstantes != ''%] [%  listaEstantes = ' / ' _ listaEstantes %] [% END %]
                        [%  listaEstantes = auxEstante.getEstante _ listaEstantes %]
                        [% IF auxEstante.getPadre %]
                      [% auxEstante = auxEstante.estante_padre %]
                        [% ELSE %]
                      [% auxEstante = 0 %]
                        [% END %]
                  [% END %]

                        [% PERL %]
                        print C4::AR::Filtros::link_to( text =>     "[% listaEstantes %]",
                                        url=>"[% url_prefix %]/opac-estante.pl", 
                                        params =>   ["id_estante=[% estante.getId %]"],
                                        title =>    "[% 'Mostrar Detalle del Estante' | i18n %]",
                                        class => "link_to_detail"
                                        ) ;
                        [% END %]

                          </td>
                      </tr>
                  [% END %]
              </tbody>
        </table>
 
        <div class="contenedor_paginador">[% paginador %]</div>

[% ELSE %]
    [% IF no_content_message %]
        <h1> [% no_content_message %] </h1>  
    [% ELSE %]
        <h1 style="margin:15px;"> [% 'Nada que mostrar.' | i18n %] </h1>
    [% END %]
    <br />
    <h1 class="pagetitle">
        [% 'Repetir la b&uacute;squeda con otros criterios' | i18n %]
    </h1>    
    
    [% INCLUDE 'opac-advanced_search.inc' %]
[% END %]
