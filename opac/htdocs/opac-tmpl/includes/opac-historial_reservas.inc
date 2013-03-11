[% USE HTML %]

[% IF cantidad %]
        <div class="alert alert-info">[% "Cantidad de reservas realizadas" | i18n %]: <strong>[% cantidad %] </strong></div> 
        
        <div class="contenedor_paginador">[% paginador %]</div>
        
        [% PERL %]
            print C4::AR::Filtros::tableHeader(   
                              id              => "tablaResult",
                              columns         => ['[% "T&iacute;tulo"|i18n %]','[% "Autor"|i18n %]','[% "Edici&oacute;n"|i18n %]',
                                                    '[% "Fecha"|i18n %]','[% "Operaci&oacute;n" %]'
                                                 ]

                                                                
                                    ) ;
        [% END %]
        
        <tbody>
            
            [% FOREACH reserva IN reservas %]
            <tr>
                
                <td class="titulo_result">
                    [% TRY %]
                        [% PERL %]
                                print C4::AR::Filtros::link_to( text =>     "[% HTML.escape(reserva.nivel2.nivel1.getTitulo) %]",
                                                                url =>      "[% url_prefix %]/opac-detail.pl",
                                                                params =>   [   "id1=[% HTML.escape(reserva.nivel2.nivel1.getId1) %]"], 
                                                            ) ;
                        [% END %]
                    [% CATCH %]
                        [% "Edici&oacute;n inexistente"|i18n %]
                    [% END %]
                </td>
                
                <td class="autor_result">
                    [% TRY %]
                        <a class="click" onClick="buscarPorAutor('[% reserva.nivel2.nivel1.getAutor %]')" title="[% 'Filtrar por Autor' | i18n %]">
                            [% reserva.nivel2.nivel1.getAutor %]
                        </a>
                    [% CATCH %]
                        --------
                    [% END %]
                </td>
                
                <td>
                    [% TRY %]
                        [% HTML.escape(reserva.nivel2.getEdicion) %]
                    [% CATCH %]
                        --------
                    [% END %]
                </td>
                <td>
                    &nbsp;[% reserva.getFecha_formateada %]&nbsp;
                </td>
                <td>
                    [% reserva.getTipo_operacion %]
                </td>
            [% END %] <!-- FOREACH PRIMERO -->
        </tbody>
        </table>
[% ELSE %]
    <div class="alert alert-info">[% "No se han realizado reservas." | i18n %] &nbsp;[% cant %]</div>
[% END %] 
