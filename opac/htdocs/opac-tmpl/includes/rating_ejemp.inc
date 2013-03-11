[% IF count_rating %]		
		<fieldset> 
              <legend class="titulo_legend_resaltado">
                  [% "Ejemplares mas votados" | i18n %]
             </legend>
                     [% IF rating %]
                          [% PERL %]
                                print C4::AR::Filtros::tableHeader(   
                                            id              => "table_tablaPrestamos",
                                            class           => "",
                                            selectAll_id    => "",
                                            columns         => ['[% "T&iacute;tulo"|i18n %]','[% "Autor"|i18n %]',
                                                 				       '[% "Raiting" | i18n %]'
                                                              ]
                                                                            
                                                  ) ;
                          [% END %]
        
                        
                        <tbody>
                        [% FOREACH elem IN rating %]       
                             <tr>
                                <td>
                                [% PERL %]
                                    print C4::AR::Filtros::link_to(	text => "[% HTML.escape(elem.value.getTitulo) %]",
                                                            url=>"[% url_prefix %]/opac-detail.pl", 
                                                            params =>	["id1=[% elem.value.getId1 %]"],
                                                          ) ;
                                [% END %]
                                </td>
                                <td>
                                [% IF elem.value.getAutor %]
                                    [% elem.value.getAutor %]
                                [% ELSE %]
                                    &nbsp;
                                [% END %]
                                </td>
                                <td>
                                      <div id="rating_[% elem.value.getId1 %]"></div>
                                      <script type="text/javascript">
                                          $('#rating_[% elem.value.getId1 %]').raty({
                                              cancel    : true,
                                              cancelOff : 'cancel-off-big.png',
                                              cancelOn  : 'cancel-on-big.png',
                                              half      : true,
                                              score     : '[% elem.value.rating %]',
                                              readOnly: true,
                                          });

                                     </script>
                                </td>

                              </tr>

                             
                      [% END %]
                    </tbody>  
			     </table> 
      [% END %]
       
                         
		</fieldset>
[% ELSE %]
    [% IF !promoted_count %]
        <div class="hero-unit">
              <h1>[% 'Todav&iacute;a nada!'|i18n %]</h1>
              <p>[% 'Volv&eacute; en unos d&iacute;as para ver si la Biblioteca tiene algo para vos.' | i18n %]</p>
              <p>
                  [% PERL %]
                          print C4::AR::Filtros::action_button( 
                                                          button         => "btn btn-primary",
                                                          action       => "historyBack()", 
                                                          icon         => "icon-white icon-arrow-left ",
                                                          title        => "[% 'Volver' | i18n %]",
                                                      ) ;

                  [% END %]
                </p>
        </div>    
    [% END %]
[% END %]