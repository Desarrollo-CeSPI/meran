
     <form class="form-horizontal" onsubmit="return false;">
        <div class="control-group">
              <div class="controls">
                  <input id="socio" class="textInput" type=text name="socio" onFocus="checkFilter('focus')"> 

                  [% PERL %]
                        print C4::AR::Filtros::setHelpInput(
                                                   text =>"[% 'Tipear el apellido, DNI, tarjeta de id. o legajo del usuario.' | i18n %]",
                                                   
                                                    
                        );
                  [% END %]
              </div>
        </div>
  
        <div class="form-actions">
                    [% PERL %]
                            print C4::AR::Filtros::action_button(
                                                            button       => "btn click",
                                                            action       => "Borrar();",
                                                            icon         => "",
                                                            title        => "[% 'Limpiar' | i18n %]",
                                                        ) ;

                    [% END %]
                    [% PERL %]
                            print C4::AR::Filtros::action_button(
                                                            button       => "btn btn-primary",
                                                            action       => "consultar();",
                                                            icon         => "icon-white icon-search",
                                                            title        => "[% 'Buscar' | i18n %]",
                                                        ) ;

                    [% END %]
                   
                    
        </div>
     </form>

