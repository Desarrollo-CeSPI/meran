[% IF cantidad %]
    <div class="well">
        <div class="resultados_consulta">[% "La cantidad de ejemplares prestados en el per&iacute;odo seleccionado es" | i18n %]: <strong>[% cantidad %]</strong></div>
    </div>
[% END %]

[% IF cantidad %]
    <div class="contenedor_paginador">[% paginador %]</div>  
    
    [% PERL %]
            print C4::AR::Filtros::tableHeader(   
                                id              => "tablaResultCirculacion",
                                columns         => ['[% "T&iacute;tulo" | i18n %]',
                                                    '[% "C&oacute;digo de barras" | i18n %]',
                                                    '[% "Signatura Topogr&aacute;fica" | i18n %]',
                                                    '[% "Tipo de Prestamo" | i18n %]',
                                                    '[% "Responsable" | i18n %]',
                                                    '[% "Cantidad de Renovaciones" | i18n %]',
                                                    '[% "Cantidad de Usuarios" | i18n %]',
                                                    '[% "Cantidad de Devoluciones" | i18n %]',
                                                    '[% "Cantidad de Prestamos Domiciliario" | i18n %]',

                                                    
                                                    ], 
                                order_name_function => "reporte_circ",                            
                            );
        [% END %]

        <tbody>      
            [% FOREACH res IN results %]   
              <tr>
                    <td>
                       
                          [% PERL %]
                            print C4::AR::Filtros::link_to( text      =>  "[% res.nivel1.getTitulo%]",
                                                            url       =>  "[% url_prefix %]/catalogacion/estructura/detalle.pl",
                                                            params    =>  ["id1=[% res.nivel1.getId1 %]"], 
                                                        ) ;
                          [% END %]
                    
                        
                    </td>
                    <td>
                        [% res.nivel3.getCodigoBarra %]
                    </td>
                    <td>
                        [% res.nivel3.getSignatura %]
                    </td>
                    <td>
                        [% res.obj_circulacion.getTipo_prestamo %]
                    </td>
                    <td>
                        [% PERL %]
                          print C4::AR::Filtros::link_to(   text    =>  "[% res.obj_circulacion.responsable %]",
                                                          url       =>  "[% url_prefix %]/usuarios/reales/datosUsuario.pl",
                                                          params    =>  ["nro_socio=[% res.obj_circulacion.responsable %]"], 
                                                          blank     =>  1, 
                                                      ) ;
                        [% END %]
                    </td>
                    <td>
                        [% res.cantidad_renovaciones %]
                    </td>
                    <td>
                        [% res.cantidad_usuarios %]
                    </td>
                    <td>
                        [% res.cantidad_devoluciones %]
                    </td>
                    <td>
                        [% res.cantidad_domiciliario %]
                    </td>
              </tr>
           [% END %]
        </tbody>
    </table>
  [% IF !exportar %]
    <div class="form-actions" style="margin-bottom: 0;">
       <td>
          [% PERL %]
                    print C4::AR::Filtros::action_set_button(    
                            button  => 'btn btn-primary',
                            title   => " [% 'Exportar a PDF' | i18n %]",
                            action  => 'imprimirReporte("formReporteCiruculacionGeneral");',
                            icon    => "icon-white icon-inbox",
                      ) ;
          [% END %]
       </td>
    </div>
    [% END %]
[% ELSE %]
    <div class="alert alert-info">
        [% 'No hay resultados para mostrar' | i18n  %]
    </div>

[% END %]