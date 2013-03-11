        <table id="tablaResult" class="datos_tabla_char" cellspacing=0 cellpadding=0 style="width:12%; float:right; border:0">
            <thead>
                <tr class="titulo_tabla_resultado">
                    <th>[% "Color" | i18n %]</th>
                    <th>[% "Item" | i18n %]</th>
                    <th>[% "Cantidad" | i18n %]</th>
                </tr>
            </thead>
            <tdoby>
                [% FOREACH item IN data %]
                    <tr>
                        <td style="background:[% item.color %]">
                            &nbsp;
                        </td>
                        <td>
                            [% item.item %]
                        </td>
                        <td>
                            [% item.cant %]
                        </td>
                    </tr>
                [% END %]
            </tbody>
        </table>