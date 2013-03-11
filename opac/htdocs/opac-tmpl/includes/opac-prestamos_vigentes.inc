<div id="detallePrestamos">

[% USE HTML %]
[% IF cantidad_prestamos %]

    <div class="alert alert-info">
        [% "Cantidad de pr&eacute;stamos vigentes:" | i18n %] <strong> [% cantidad_prestamos %] </strong>
    </div>

    <div class="contenedor_paginador">[% paginador %]</div>

    [% PERL %]
        print C4::AR::Filtros::tableHeader(   
                          id              => "tablaPrestamos",
                          columns         => ['[% "T&iacute;tulo"|i18n %]','[% "Autor"|i18n %]','[% "Edici&oacute;n"|i18n %]',
                                                '[% "Fecha de Pr&eacute;stamo"|i18n %]', '[% "Fecha de Vencimiento"|i18n %]',
                                                '[% "Estado"|i18n %]',  '[% "Renovar"|i18n %]',
                                             ]

                                                            
                                ) ;
    [% END %]
    <tbody>
        <!-- ESTE LOOP MUESTRA LOS PRESTAMOS -->
        [% FOREACH prestamo IN prestamos %]
            <tr>
              <td> 
                  [% IF prestamo.nivel3.nivel2.id1 %]
                      [% PERL %]
                              print C4::AR::Filtros::link_to( text =>     "[% HTML.escape(prestamo.nivel3.nivel2.nivel1.getTitulo) %]",
                                                              url =>      "[% url_prefix %]/opac-detail.pl", 
                                                              params => [ "id1=[% prestamo.nivel3.nivel2.id1 %]", ],
                                                          ) ;
                      [% END %]
                  [% ELSE %]
                      &nbsp;
                  [% END %]
                  </td>
                  <td class="autor_result click" onClick="filtrarPorAutor([% prestamos.nivel3.nivel2.nivel1.cat_autor.id %])" title="[% 'Filtrar por Autor' | i18n %]">
                      [% IF prestamo.nivel3.nivel1.getAutor %]
                          [% HTML.escape(prestamo.nivel3.nivel1.getAutor) %]
                      [% ELSE %]
                          &nbsp;
                      [% END %]
                  </td>
                  <td>
                    [% IF prestamo.nivel3.nivel2.getEdicion %] [% prestamo.nivel3.nivel2.getEdicion %] [% ELSE %] - [% END %]                  </td>
                  <td>
                      [% prestamo.getFecha_prestamo_formateada %]
                  </td>
                  <td>
                      [% prestamo.getFecha_vencimiento_formateada %]
                  </td>
                  
                  <td>
                      [% IF prestamo.estaVencido %] <span class="label label-important">Vencido</span> [% ELSE %] 
                      <span class="label label-success">Vigente</span>[% END %] 
                  </td>

                  <td>
                  [% IF prestamo.sePuedeRenovar %]
                    [% PERL %]
                                  print C4::AR::Filtros::action_button( 
                                                                  button    => "btn btn-primary click",
                                                                  action    => 'renovar("[% prestamo.getId_prestamo %]")', 
                                                                  icon      => "icon-refresh icon-white",
                                                              ) ;


                      [% END %]
                  [% ELSE %]
					<i 	class="icon-ban-circle popover_button" id="popover_[% prestamo.id_prestamo %]" rel="popover" 
						data-placement="left" data-content="[% prestamo.sePuedeRenovar_text %]" data-original-title="[% 'Renovaciones' | i18n %]"></i>
                  [% END %]
                  </td>
            </tr>
        [% END %]
    </tbody>
    </table>

[% ELSE %]

    <div class="alert alert-info"> [% 'Ud. no tiene pr&eacute;stamos vigentes.' | i18n %] </div>

[% END %]

</div>
