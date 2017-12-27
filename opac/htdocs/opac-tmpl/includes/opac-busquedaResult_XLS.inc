<h3>Resultado de la búsqueda</h3>
   
          [% PERL %]
                 print C4::AR::Filtros::tableHeader(   
                                                         id             => "tablaResult",
                                                         class          => "table table-bordered",
                                                         columns        => [ '[% "T&iacute;tulo"|i18n %]','[% "Autor"|i18n %]',
                                                                             '[% "Edici&oacute;n"|i18n %]',
                                                                             '[% "Signatura Topogr&aacute;fica"|i18n %]'
                                                                            ],                         
                             ) ;
          [% END %]                
              <tbody>
                      <!-- Resultados de la busqueda -->
                    [% FOREACH NIVEL IN SEARCH_RESULTS  %]
                    <tr>
                        <td> [% NIVEL.titulo %]</td>
                        <td>[% NIVEL.nomCompleto %]</td>
                                         <td>
                         
                                  [% IF NIVEL.estadoDeColeccion %]
                                  <span id="coleccion_[% NIVEL.id1 %]">
                                    <ul class="listado_sin_margen estado_coleccion unstyled">
                                    [% FOREACH anio IN NIVEL.estadoDeColeccion.keys.sort %]
                                    [% IF NIVEL.estadoDeColeccion.$anio.keys %]
                                    <li>
                                        [% IF  (NIVEL.estadoDeColeccion.$anio.size > 1 || (NIVEL.estadoDeColeccion.$anio.keys.first && NIVEL.estadoDeColeccion.$anio.keys.first != '#'))||
                                        (NIVEL.estadoDeColeccion.$anio.item('#').size > 1 || (NIVEL.estadoDeColeccion.$anio.item('#').keys.first && NIVEL.estadoDeColeccion.$anio.item('#').keys.first != '#')) 
                                               %]
                                           [% IF anio != '#' %] <b>[% anio %]</b>  [% END %]

                                          [% FOREACH volumen IN NIVEL.estadoDeColeccion.$anio.keys.sort %]
                                            
                                              [% IF  NIVEL.estadoDeColeccion.$anio.$volumen.keys.size > 1 || NIVEL.estadoDeColeccion.$anio.$volumen.keys.sort.first != '#' %]
                                               [% IF volumen != '#' %] <b>[% volumen %]</b>[% END %]
                                                (
                                                  [% FOREACH fasciculo IN NIVEL.estadoDeColeccion.$anio.$volumen.keys.sort %]
                                                      [% IF fasciculo != '#' %] <b>[% fasciculo %]</b>[% END %]
                                                  [% END %]
                                                 )
                                              [% ELSE %]
                                                  [% IF volumen != '#' %] <b>[% volumen %]</b>[% END %]
                                              [% END %]
                                          [% END %]
                                        [% ELSE %]
                                          [% IF anio != '#' %] <b>[% anio %]</b>  [% END %]
                                        [% END %]
                                    </li>
                                    [% END %]
                                    [% END %]
                                    </ul>
                                    </span>
                          <script type="text/javascript">$("#coleccion_[% NIVEL.id1 %]").expander({
                            slicePoint: 2000, 
                            widow: 10,
                            expandEffect: 'fadeIn', 
                            expandText: '<i class="icon-arrow-down"></i>',
                            userCollapseText: '<i class="icon-arrow-up"></i>',
                                          expandPrefix: '',
                          });
                         </script>
                     
                    [% ELSE %]
                      [% IF NIVEL.grupos %]
                        <span id="grupos_[% NIVEL.id1 %]" class="detalle_registro_edicion">
                          [% FOREACH NIVEL.grupos %]
                            [% IF edicion %]
                              [% edicion %] &nbsp;
                            [% END %]
                            [% IF loop.prev.anio_publicacion != anio_publicacion %]
                              [% IF anio_publicacion %]
                                ([% anio_publicacion %])<br/>
                              [% END %]
                            [% END %]
                              
                          [% END %]
                        </span>
                      <script type="text/javascript">$("#grupos_[% NIVEL.id1 %]").expander({
                        slicePoint: 2000, 
                        widow: 10,
                        expandEffect: 'fadeIn', 
                        expandText: '<i class="icon-arrow-down"></i>',
                        userCollapseText: '<i class="icon-arrow-up"></i>',
                                      expandPrefix: '',
                      });
                     </script>
                      [% END %]
                    [% END %]
           


                        [% IF NIVEL.cat_ref_tipo_nivel3 == "ANA" %]
                           [% IF NIVEL.titulo_registro_padre %]
                              EN: <br>

                              [% IF NIVEL.titulo_registro_padre %]
                                        [%  NIVEL.titulo_registro_padre %]
                                       [% ELSE %]
                                       SIN T&Iacute;TULO
                                       [% END %]
                                       [% IF NIVEL.autor_registro_padre %]
                                        / [% NIVEL.autor_registro_padre %]
                                       [% END %]
                                       [% IF NIVEL.detalle_grupo_registro_padre %]
                                         <br>[% NIVEL.detalle_grupo_registro_padre %]
                                       [% END %]
                                       [% IF NIVEL.tipo_documento_padre %]
                                         <br>([% NIVEL.tipo_documento_padre %])
                                       [% END %]
                            [% END %]
                        [% END %]


                         </td> 
                        <td>[% FOREACH signatura IN NIVEL.signaturas  %]
                                          [% signatura %]
                            [% END %] 
                        </td>
                    </tr>
                   
                  [% END %]
              </tbody>
</table>

       
