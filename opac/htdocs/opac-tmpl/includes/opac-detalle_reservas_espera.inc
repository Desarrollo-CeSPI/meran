[% USE HTML %]
<div id="info_reservas">
    <fieldset>
        <legend> [% 'Material en espera' | i18n %] </legend>
    [% IF reservas_espera_count %]


        [% PERL %]
                print C4::AR::Filtros::tableHeader(   
                                  id              => "tabla_datos tope",
                                  class           => "",
                                  selectAll_id    => "",
                                  columns         => ['[% "T&iacute;tulo" | i18n %]','[% "Autor" | i18n %]',
                                                      '[% "Edici&oacute;n" | i18n %]','[% "Acci&oacute;n" | i18n %]'
                                                     ]

                                                                    
                                        ) ;
          [% END %]

    

          <tbody>
            <!-- ESTE LOOP MUESTRA LAS RESERVAS -->
            [% FOREACH reserva IN RESERVAS_ESPERA %]
              <tr>
                    <td>
                          [% PERL %]
                                                print C4::AR::Filtros::link_to( text =>     "[% HTML.escape(reserva.nivel2.nivel1.getTitulo) %]",
                                                                                url =>      "[% url_prefix %]/opac-detail.pl", 
                                                                                params =>   ["id1=[% reserva.nivel2.nivel1.getId1 %]"],
                                                                                title =>    "[% 'Mostrar Detalle del Ejemplar' | i18n %]"
                                                                            ) ;
                          [% END %]
                    </td>

                    <td >
                          [% IF reserva.nivel2.nivel1.getAutor %]
                              [% HTML.escape(reserva.nivel2.nivel1.getAutor) %]
                              </a>
                          [% ELSE %]
                              &nbsp;
                          [% END %]
                    </td>
                    <td> 
                            [% IF reserva.nivel2.getEdicion %] [% reserva.nivel2.getEdicion %] [% ELSE %] - [% END %]
                    </td>
                    <td>
                            [% IF CirculationEnabled %]
                      <ul>
                          [% PERL %]
                                              print C4::AR::Filtros::action_button(   
                                                      button=> "btn click btn-danger",
                                                      icon => "icon-remove icon-white",
                                                      action => "cancelarReserva([% reserva.getId_reserva %])",
                                                      title   => "[% "" | i18n %]",
                                                      
                                              );
                          [% END %]
                      </ul>

                                [% ELSE %]
                                    [% "No disponible" | i18n %]
                                [% END %]
                    </td>
             </tr>
           [% END %]
       </table>
                
[% ELSE %]
     <div class="alert alert-info"> [% 'No ten&eacute;s reservas en espera.' | i18n %] </div>
[% END %]
    </fielset>
</div>
