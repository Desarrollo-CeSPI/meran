
[% IF cantidad %]
    <div class="well">
        <div class="resultados_consulta">[% "La cantidad de reservas es" | i18n %]: <strong>[% cantidad %]</strong></div>
    </div>
[% END %]

[% IF cantidad %]
    <div class="contenedor_paginador">[% paginador %]</div>  
    
    [% PERL %]
            print C4::AR::Filtros::tableHeader(   
                              id              => "tablaResultCirculacion",
                              columns         => ['[% 'T&iacute;tulo' | i18n %]',
                                                  '[% 'Autor' | i18n %]',
                                                  '[% 'Fecha' | i18n %]',
                                                  '[% 'Estado' | i18n %]',
                                                  '[% "C&oacute;digo de barras" | i18n %]',
                                                  '[% 'Signatura Topogr&aacute;fica' | i18n %]',
                                                  '[% "Usuario" | i18n %]',
                                                  
                                                  ],
                              order           => {  'T&iacute;tulo'         => 'titulo',
                                                    'Usuario'               => 'usuario',
                                                    'Cantidad de reservas'  => 'cantidad_reservas',
                                                  } ,   
                              order_name_function => "reporte_circ",                            
                                    ) ;
        [% END %]

        <tbody>
              [% FOREACH res IN results %]   
                <tr>
                  <td>
                      [% res.nivel3.nivel1.getTitulo %]
                  </td>
                  <td>
                      [% res.nivel3.nivel1.getAutor %]
                  </td>
                  <td>
                      [% res.getFecha_formateada %]
                  </td>
                  <td>
                      [% res.tipo_operacion %]
                  </td>
                  <td>  
                      [% TRY %]
                          [% res.nivel3.getCodigoBarra %]
                      [% CATCH %]
                          Reserva de grupo
                      [% END %]
                  </td>
                  <td>
                      [% TRY %]
                        [% res.nivel3.getSignatura %]
                      [% CATCH %]
                        [% 'Sin Signatura Topogr&aacute;fica' | i18n %]
                      [% END %]
                  </td>
                  <!-- <td>
                      [% PERL %]
                        print C4::AR::Filtros::link_to(   text    =>  "[% res.responsable %]",
                                                        url       =>  "[% url_prefix %]/usuarios/reales/datosUsuario.pl",
                                                        params    =>  ["nro_socio=[% res.responsable %]"], 
                                                        blank     =>  1, 
                                                    ) ;
                      [% END %]
                  </td> -->
                  <td>
                      [% IF nro_socio %] 
                                [% PERL %]
                                      print C4::AR::Filtros::link_to(   text =>     "[% res.socio.nro_socio %]",
                                                            url=>"      [% url_prefix %]/usuarios/reales/datosUsuario.pl", 
                                                            params =>   ["nro_socio=[% res.socio.nro_socio %]"],
                                                            title =>    "[% 'Mostrar Detalle del Usuario' | i18n %]",
                                                            blank =>    1
                                                      );
                                [% END %]             
                      [% ELSE %]
                                '[% "Desconocido" | i18n %]'
                      [% END %]
                      

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
                            action  => 'imprimirReporte("formReporteCirculacion");',
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
