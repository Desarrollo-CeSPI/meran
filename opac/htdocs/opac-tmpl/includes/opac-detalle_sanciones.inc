
[% IF sanciones %]
            
                  [% PERL %]
                      print C4::AR::Filtros::tableHeader(   
                                        id              => "detalle_sanciones",
                                        class           => "",
                                        selectAll_id    => "",
                                        columns         => ['[% "Tipo de prestamo"|i18n %]','[% "Titulo"|i18n %]',
                                                            '[% "Desde"|i18n %]','[% "Hasta"|i18n %]'
                                                          ]

                                                                          
                                              ) ;
                  [% END %]

                   <tbody>  
                        [% FOREACH sancion IN sanciones %]
                        <tr>  
                            <td>
                                  [% IF sancion.tipo_sancion %] 
                                        [% sancion.ref_tipo_sancion.ref_tipo_prestamo.getDescripcion %]
                                  [% ELSE %]
                                        [% "Reserva no retirada" | i18n %]
                                  [% END %]
                            </td>
                            <td>

                                   [% PERL %]
                                                print C4::AR::Filtros::link_to( text =>     "[% sancion.nivel3.nivel1.getTitulo %]",
                                                                                url =>      "[% url_prefix %]/opac-detail.pl", 
                                                                                params => [ "id1=[% sancion.nivel3.nivel1.getId1 %]", ],
                                                                            ) ;
                                  [% END %]
                            </td>
                            <td>
                                  [% sancion.getFecha_comienzo_formateada %]
                            </td>
                            <td>
                                  [% sancion.getFecha_final_formateada %]
                            </td>
                        </tr>       
                        [% END %]
                  </tbody> 
            </table>

[% ELSE %]
      <div class="alert alert-info">[% 'No ten&eacute;s ninguna sanci&oacute;n' | i18n %]</div>
[% END %]



<!--<br> <h4>[% "Ud. est&aacute; sancionado para los siguientes tipos de pr&eacute;stamo:" | i18n %]</h4--> 
        
