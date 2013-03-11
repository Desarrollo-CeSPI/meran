[% IF loop_reservas %]
    [% IF cantidad %]
        <div class="resultados_consulta">[% "Cantidad de reservas realizadas:" | i18n %]&nbsp;[% cantidad %]</div>
    [% END %]


    <div class="contenedor_paginador">[% paginador %]</div>


    <table id="tablaHistorial" class="tablaHistorial" width="98%" cellspacing="0" cellpadding="4" align="center">   

        <tr class="tablaResultadoTitulo">
            <th>[% "T&iacute;tulo" | i18n %]</th>
            <th>[% "Autor" | i18n %]</th>
            <th>[% "Estado" | i18n %]</th>
            <th>[% "F. Reserva" | i18n %] </th>
            <th>[% "F. Vto" | i18n %]</th>
        </tr>

    <!-- ESTE LOOP MUESTRA LAS RESERVAS -->
    [% FOREACH loop_reservas %]
        <tr>
            <td> 
        [% IF id1 %]
            [% PERL %]
                print C4::AR::Filtros::link_to( text    => "[% 'Mostrar Detalle' | i18n %]",
                                                boton   => "boton_registrarse", 
                                                width   => "95",
                                                class   => "horizontal",
                                                url     => "/join.html", 
                                                title   => "[% 'Mostrar Detalle' | i18n %]"
                                            ) ;
            [% END %]  
            <a class="click" onClick="detalle('[% id1 %]')" title="[% 'Mostrar Detalle' | i18n %]">
        [% titulo %][% IF unititle %]:&nbsp;[% unititle %][% END %]
            </a> [% ELSE %]&nbsp;[% END %]
            </td>
            <td>
        [% IF idAutor %]
            [% PERL %]
                print C4::AR::Filtros::link_to( text    => [% completo %],
                                                params  => "[authorid=[% idAutor %]]", 
                                                url     => "[% url_prefix %]/opac-searchresults.pl", 
                                                title   => "[% 'Mostrar Detalle' | i18n %]"
                                            ) ;
            [% END %]  

            [% ELSE %]&nbsp;[% END %]
            </td>
            <td align=center>  
        [% IF estado %]
        [% estado %]
        [% ELSE %] - [% END %]
            </td>
            <td align=center>
            [% fechaReserva %]&nbsp;
            </td>
            <td align=center>
                [% fechaVto %]&nbsp;
            </td>
        </tr>
    [% END %]

    </table>

[% ELSE %]
    <h1> [% 'Ud. no tiene registrada ninguna recomendaci&oacute;n.' | i18n %] </h1>
[% END %]