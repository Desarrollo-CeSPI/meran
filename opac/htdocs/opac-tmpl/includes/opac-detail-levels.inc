<div class="main-subcontent" style="width:100%; float:left">
    <div class="subcontent-unit-border" style="width:100%;">
        <div class="round-border-topleft" style="width:90%;"></div>
        <h1>[% "Detalle del Registro" | i18n %]</h1>
        <div class="detalle">
            <ul class="listado_sin_margen">
                [% FOREACH nivel1 %]
                    [% FOREACH subcampos_array %]
                        [% IF liblibrarian %]
                            [% IF dato %]
                            <li>    [% liblibrarian %]: <strong>[% dato %]</strong></li>
                            [% END %]
                        [% END %]
                    [% END %]
                [% END %]
            </ul>
        </div>
    </div>
</div>
<div class="main-subcontent" style="width:100%; float:left">
    <div class="subcontent-unit-border-green" style="width:100%;">
        <div class="round-border-topleft" style="width:90%;"></div>
        <h1 class="green">[% "Detalle del Grupo" | i18n %]</h1>
        [% FOREACH nivel2 %]
            <ul class="listado_sin_margen">
                [% FOREACH nivel2_array %]
                    [% FOREACH subcampos_array %]

                            [% IF liblibrarian %]
                                [% IF dato %]
                                <li> [% liblibrarian %]: <strong>[% dato %]</strong></li>
                                [% END %]
                            [% END %]

                    [% END %] <!-- END FOREACH nivel2_array -->
                [% END %] <!-- END FOREACH subcampos_array-->
            </ul>
    </div>
</div>
    <div id="[% DivDetalle %]">
        <div class="main-subcontent" style="width:100%; float:left">
        <div class="subcontent-unit-border-orange" style="width:100%;">
            <div class="round-border-topleft" style="width:90%;"></div>
            <h1 class="orange">[% "Detalle del Ejemplar" | i18n %]</h1>
            <table id="tablaDetalleNivel" class="tablaDetalleNivel3" cellspacing=0 border="0" cellpadding=0 style="width:95%;">
                <thead>
                <tr class="bordetabla" align="center">
                    <td>[% "C&oacute;digo" | i18n %]</td>
                    <td>[% "Signatura Topogr&aacute;fica" | i18n %]</td> 
                    <td>[% "Biblioteca que lo posee" | i18n %]</td>
                    <td>[% "Biblioteca de origen" | i18n %]</td>
                    <td>[% "Estado" | i18n %]</td>
                    <td>[% "Disponibilidad" | i18n %]</td>
                    <td>[% "MARC" | i18n %]</td>
                </tr>
                </thead>
                <tbody>
                    [% FOREACH nivel3 %]
                        <tr align="center">
                            <td>[% nivel3_obj.getBarcode %]</td>
                            <td>[% nivel3_obj.getSignatura_topografica %]</td>
                            <td>[% nivel3_obj.getId_ui_poseedora %]</td>   
                            <td>[% nivel3_obj.getId_ui_origen %]</td>  
                            <td>[% nivel3_obj.getEstado %]</td>
                            <td>[% nivel3_obj.getDisponibilidadObject.getNombre %]</td>
                            <td>
                                <a class="click" onClick="MARCDetail('[% id3 %]', '[% DivDetalle %]', '[% DivMARC %]');">
                                <img src="[% themelang %]/images/MARC.png" border="0" alt="[% 'Detalle MARC' | i18n %]" title="[% 'Detalle MARC' | i18n %]">
                                </a>
                            </td>
                        </tr>
                    [% END %]
                </tbody>
            </table>
            <!-- FIXME falta revisar!!!!!!!!!!! -->
            <br />
            <hr />
            <br />
            <div class="main-subcontent" style="width:95%;">
                <div class="subcontent-unit-border-green" style="width:100%;">
                    <h1 class="green">[% "Informaci&oacute;n de disponibilidad" | i18n %]</h1>
                    <table  style="width:95%;">
                        <tr>
                            <td class="impar" >
                                <br>
                                [% "Disponibilidad Actual Para Pr&eacute;stamo:" | i18n %] <b>[% cantParaPrestamo %]</b><br>    
                                [% "Disponibilidad Actual Para Sala de Lectura:" | i18n %] <b>[% cantParaSala %]</b><br>
                                [% "Cantidad Actual de Reservas:" | i18n %] <b>[% cantReservas %]</b><br>

                                [% IF socio_data %]
                                    [% PERL %]
                                        print C4::AR::Filtros::to_Icon(   text    => "[% 'Reservar' | i18n %]",
                                                                            boton   => "icon_reservar",
                                                                            width   => "100",
                                                                            onClick => "reservar([% id1 %],[% id2 %])",
                                                                            title   => "[% 'Reservar' | i18n %]"
                                                                    );
                                    [% END %]
                                [% END %]
                            </td>
                        </tr>
                    </table>
                </div>
           </div>
        </div>
      </div>
  </div>
[% END %]
<div id="resultadoReserva"></div>
