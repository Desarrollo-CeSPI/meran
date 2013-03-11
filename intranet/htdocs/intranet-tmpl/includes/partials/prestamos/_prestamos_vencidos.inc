    [% FOREACH prestamo IN prestamos %]
            <tr>
                <td>
                <input type="checkbox" id="[% prestamo.getId_prestamo %]" name="prestamo" >
            </td>
                <td>
                  [% TRY %]
                      [% prestamo.socio.persona.getApeYNom %]
                  [% CATCH %]
                      [% 'Usuario inexistente' | i18n %]
                  [% END %]
            </td>
                <td>
                      [% TRY %]
                        [% PERL %]
                            print C4::AR::Filtros::link_to(   text   => "[% prestamo.socio.getNro_socio %]",
                                                              url    => "[% url_prefix %]/usuarios/reales/datosUsuario.pl",
                                                              params => ["nro_socio=[% prestamo.socio.getNro_socio %]"],
                                                              title  => "[% 'Mostrar Detalle del Usuario' | i18n %]",
                                                              blank  => 1,
                                                        );
                        [% END %]
                      [% CATCH %]
                          [% 'Usuario inexistente' | i18n %] ([% prestamo.nro_socio %])
                      [% END %]
            </td>
            <td>
                    [% PERL %]
                            print C4::AR::Filtros::link_to( text    => "[% prestamo.nivel3.codigo_barra %]",
                                                            url     => "[% url_prefix %]/catalogacion/estructura/detalleEjemplar.pl", 
                                                            params  => ["id3=[% prestamo.nivel3.getId3 %]"],
                                                            title   => "[% prestamo.nivel3.codigo_barra %]"
                                                        );
                        [% END %]
            </td>
                <td>
                    [% prestamo.tipo.getDescripcion %]
            </td>
                <td>
                    [% prestamo.getFecha_prestamo_formateada %]
            </td>
            </tr>
    [% END %]