
[% IF cantidad %]
    <div class="well">
        <div class="resultados_consulta">[% "La cantidad de resultados es" | i18n %]: <strong>[% cantidad %]</strong></div>
    </div>
[% END %]


[% IF cantidad %]
  <script>
    $(document).ready(function(){
      $('.popover_button').popover({delay: {show: 200,  hide: 100 }, trigger: 'hover'});
      });
  </script>
    <div class="contenedor_paginador">[% paginador %]</div>  
    
    [% PERL %]
            print C4::AR::Filtros::tableHeader(   
                              id              => "tablaResultCirculacion",
                              columns         => ['[% 'Responsable'|i18n %]',
                                                  '[% 'T&iacute;tulo' | i18n %]',
                                                  '[% 'Autor' | i18n %]',
                                                  '[% "C&oacute;digo de barras" | i18n %]',
                                                  '[% 'Signatura Topogr&aacute;fica' | i18n %]',
                                                  '[% "Usuario" | i18n %]',
                                                  '[% 'Fecha' | i18n %]',
                                                  '[% 'Operaci&oacute;n' | i18n %]',
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
                    [% IF res.responsable == "Sistema" %]
                    <span class="label label-warning">
                        [% 'SISTEMA' | i18n %]
                    </span>
                    [% ELSE %]
                      [% TRY %]
                        [% res.responsable_ref.persona.getApeYNom %]
                      [% CATCH %]  
                        [% 'Usuario Inexistente' | i18n %]
                      [% END %]
                    [% END %]
                   </td>
                  <td>
                  [% TRY %]
                      [% IF res.nivel2.nivel1 %]
                        [% res.nivel2.nivel1.getTituloStringEscaped %]
                      [% END %]
                  [% CATCH %]
                      [% "Material inexistente"|i18n %]
                  [% END %]
                  </td>
                  <td>
                  [% TRY %]
                      [% IF res.nivel2.nivel1 %]
                        [% res.nivel2.nivel1.getAutorStringEscaped %]
                      [% END %]
                  [% CATCH %]
                      [% "Material inexistente"|i18n %]
                  [% END %]
                  </td>
                  <td>  
                  [% TRY %]
                      [% IF res.id3 %]

                          [% PERL %]
                                  print C4::AR::Filtros::link_to( text =>   "[% res.nivel3.getBarcode %]",
                                                                  url =>    "[% url_prefix %]/catalogacion/estructura/detalleEjemplar.pl", 
                                                                  params => ["id3=[% res.getId3 %]"],
                                                                  title =>  "[% "Detalle del Ejemplar" | i18n %]"
                                                              );
                          [% END %] 
                          
                      [% ELSE %]
                          ([% 'Reserva de grupo' | i18n %])
                      [% END %]
                  [% CATCH %]
                      [% "Material inexistente"|i18n %]
                  [% END %]
                  </td>
                  <td>
                      [% TRY %]
                        [% IF res.tipo_operacion == "ESPERA" %]
                          [% res.nivel2.getPrimerSignatura %]
                        [% ELSE %]
                          [% TRY %]
                            [% res.nivel3.getSignatura %]
                          [% CATCH %]
                            [% res.nivel2.getPrimerSignatura %]
                          [% END %]
                        [% END %]
                      [% CATCH %]  
                        [% 'Sin Signatura Topogr&aacute;fica' | i18n %]
                      [% END %]
                  </td>

                  <td>
                      [% TRY %]
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
                      [% CATCH %]  
                        [% 'Usuario Inexistente' | i18n %]
                      [% END %]
                  </td>
                  <td>
                      [% res.getFecha_formateada %]
                  </td>
                  <td>
                     <span class="label 
                        [% IF res.getTipo_operacion == 'CANCELACION' %]
                            label-warning
                        [% ELSE %]
                            [% IF res.getTipo_operacion == 'RESERVA'  || res.getTipo_operacion == 'ASIGNACION' %]
                            label-success
                            [% ELSE %]
                                label-info
                            [% END %]
                        [% END %]">
                    [% res.getTipo_operacion | i18n %]
                    </span>
                   
                    [% IF res.getNota %] 
                        [% PERL %]
                          print C4::AR::Filtros::action_button( 
                                                          button   => "",
                                                                    action   => '',
                                                                    icon     => "icon-comment",
                                                                    id       => 'text_nota_[% res.id %]',
                                                                    popover => { title   =>'[% "Nota" | i18n %]',
                                                                                 text    => "[% res.getNota %]",
                                                                                 placement => "left",
                                                                               }
                                                      ) ;
                      [% END %]
                    [% END %]
                  </td>
                </tr>
             [% END %]
        </tbody>
    </table>
    [% IF !exportar %]
    <div class="form-actions" >
          [% PERL %]
                    print C4::AR::Filtros::action_button(    
                            button  => 'btn click btn-primary',
                            title   => " [% 'Exportar a PDF' | i18n %]",
                            action  => 'imprimirReporte("formReporteCirculacion","PDF");',
                            icon    => "icon-white icon-inbox",
                      ) ;
          [% END %]
          [% PERL %]
                    print C4::AR::Filtros::action_button(    
                            button  => 'btn click btn-primary',
                            title   => " [% 'Exportar a XLS' | i18n %]",
                            action  => 'imprimirReporte("formReporteCirculacion","XLS");',
                            icon    => "icon-white icon-inbox",
                      ) ;
          [% END %]
    </div>
    [% END %]
[% ELSE %]
    <div class="alert alert-info">
        [% 'No hay resultados para mostrar' | i18n  %]
    </div>

[% END %]
