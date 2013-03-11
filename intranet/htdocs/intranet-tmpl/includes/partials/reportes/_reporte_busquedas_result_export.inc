 <div class="encabezado">
        <img src="[% escudoUI %]" alt="escudoUI" width="120px" height="90px" align="left" /><br> 
 </div>


       
      [% PERL %]
            print C4::AR::Filtros::tableHeader(   
                              id              => "tablaResult",
                              class           => "",
                              selectAll_id    => "",
                              columns         => ['[% "Valor" | i18n %]','[% 'Campo' | i18n %]',
                                                  '[% "Usuario" | i18n %]','[% "Fecha" | i18n %]',                
                                                  ],
                              order           => {  'Valor' =>'valor', 
                                                    'Campo' => 'campo',
                                                    'Usuario' => 'busqueda.nro_socio', 
                                                    'Fecha' => 'busqueda.fecha'  
                                                  },
                              order_name_function => "reporte_busquedas",
                              ) ;
        [% END %]
     
        <tbody>  
              
              [% FOREACH res IN results %]
                <tr>
                  <td styel="border:1px solid black;">
                      [% res.valor %]
                  </td>
                  <td>
                      [% res.campo %]
                  </td>
                  <td>
                      [% IF nro_socio %] 
                                [% PERL %]
                                      print C4::AR::Filtros::link_to(   text =>     "[% nro_socio %]",
                                                            url=>"      [% url_prefix %]/usuarios/reales/datosUsuario.pl", 
                                                            params =>   ["nro_socio=[% nro_socio %]"],
                                                            title =>    "[% 'Mostrar Detalle del Usuario' | i18n %]"
                                                      );
                                [% END %] 
                             
                      [% ELSE %]
                                '[% "Desconocido" | i18n %]'
                               
                      [% END %]
                      
                  </td>
                  <td>
                      [% res.busqueda.getFecha_formateada %]
                  </td>
                  <td>
                      
                  </td>
               
                </tr>
             [% END %]
        </tbody>
 </table>


 <div>
              <br><br>
             <div>[% "La cantidad de busquedas es" | i18n %]: <strong>[% cantidad %]</strong></div>
  
</div>
