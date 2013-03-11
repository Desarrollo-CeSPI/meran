<h3>Resultado de la búsqueda</h3>
   
          [% PERL %]
                 print C4::AR::Filtros::tableHeader(   
                                                         id             => "tablaResult",
                                                         class          => "table table-bordered",
                                                         columns        => ['[% "T&iacute;tulo"|i18n %]','[% "Autor"|i18n %]',
                                                                             '[% "Edici&oacute;n"|i18n %]','[% "Disponibilidad"|i18n %]'
                                                                            
                                                                            ],                         
                             ) ;
          [% END %]                
              <tbody>
                      <!-- Resultados de la busqueda -->
                    [% FOREACH NIVEL IN SEARCH_RESULTS  %]
                    <tr>
                        <td> [% NIVEL.titulo %]</td>
                        <td>[% NIVEL.nomCompleto %]</td>
                        <td>[% FOREACH signatura IN NIVEL.signaturas  %]
                                          [% signatura %]
                            [% END %] 
                        </td>

                        <td>[% IF NIVEL.disponibilidad %]
                                [% FOREACH NIVEL.disponibilidad %]
                                    [% flag = 0 %]
                                    [% IF cantTotal %]
                                        [% IF flag %]
                                          [% 'Disponible para ' | i18n %]&nbsp;
                                          [% flag = 1 %]
                                        [% END %]
                                        <span>[% tipoPrestamo %]</span></br>
                                    [% END %]
                                [% END %]
                            [% END %]
                        
                    </tr>
                   
                  [% END %]
              </tbody>
</table>

       
