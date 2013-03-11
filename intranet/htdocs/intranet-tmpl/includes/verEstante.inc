
<div id="estante_collapse" class="accordion">
   <!-- <fieldset class="resultados_busqueda">-->
              <div class="accordion-group">
                    <div class="accordion-heading">
                         <a class="accordion-toggle" data-toggle="collapse" data-parent="#estante_collapse" href="#cont_estante">[% "Estantes" | i18n %]</a>
                    </div>
                    <div id="cont_estante" class="accordion-body collapse in ">
                          <div class="accordion-inner">

                               <!-- <legend class="titulo_legend trigger click">[% "Estantes" | i18n %]</legend>-->
                                    <div class="datos_tabla_div_estantes">
                                        [% IF cant_estantes %]
                                          <ul id="ul_tabla_div_estante_0" class="unstyled">
                                              [% FOREACH estante IN ESTANTES %]
                                                  <li>
                                                      <input type=checkbox name="[% estante.getEstante %]" value="[% estante.getId %]">
                                                      <a class="click" onClick="verSubEstantes([% estante.getId %],0)">[% estante.getEstante %]</a>
                                                  </li>
                                              [% END %]
                                          </ul>

                                          <div class="form-actions">
                                               
                                                      [% PERL %]
                                                                    print C4::AR::Filtros::action_button(
                                                                                                        button  => "btn btn-danger",
                                                                                                        action => "borrarEstantesSeleccionados(0,0);",
                                                                                                        icon     => 'icon-white icon-minus',
                                                                                                        title   => " [% 'Borrar seleccionados' | i18n %]",
                                                                            ) ;
                                                      [% END %]
                                            [% ELSE %]
                                          <div class="alert alert-info">
                                                [% 'No se encontraron estantes virtuales.' | i18n %]
                                          </div>
                                      [% END %]
                                          
                                                [% PERL %]
                                                                    print C4::AR::Filtros::action_button(
                                                                                                        button   => "btn btn-success",
                                                                                                        title   => " [% 'Agregar estante' | i18n %]",
                                                                                                        icon     => 'icon-white icon-plus',
                                                                                                        action => "agregarNuevoEstante();",
                                                                            ) ;
                                                [% END %]
                                           
                                                
                                          </div>
                                     
                                    </div>
                          </div>
                    </div>
        </div>
</div>
<div id="subestante">
</div>

