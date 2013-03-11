[% USE HTML %]

<script type="text/javascript" >
        
      

        $(document).ready(function(){
              checkTr();
              checkedAll('checkAllRegistros','chkboxRegistros');
        });


</script>
<br />
[% IF CANT_REGISTROS %]
    <div class="well">[% "Cantidad de registros" | i18n %]: &nbsp;[% CANT_REGISTROS %]</div> 
      [% PERL %]
          print C4::AR::Filtros::tableHeader(   
                                                  id              => "tablaResult_registros",
                                                  class           => "",
                                                  selectAll_id    => "checkAllRegistros",

                                                  columns         => ['[% "Autor"|i18n %]','[% "T&iacute;tulo"|i18n %]',
                                                                      
                                                                     ],

                      ) ;
      [% END %]
        
        
        <tbody>
              [% FOREACH registro IN REGISTROS %]
                  <tr>  
                      <td>
                          <input type="checkbox" name="chkboxRegistros" value="[% registro.id1 %]" 
                                  id="[% sancion.getId_sancion %]">
                      </td>                    
                      <td>
                        [% HTML.escape(registro.nomCompleto) %]
                      </td>
                      <td>
                        [% HTML.escape(registro.titulo) %]
                      </td>
                  </tr>
              [% END %]
          </tbody>
       </table>
       <div class="form-actions">
                    [% PERL %]
                                        print C4::AR::Filtros::action_button(   
                                                                            button  => "btn btn-primary",
                                                                            icon    => "icon-white icon-plus",
                                                                            action  => "agregarAlIndice();",
                                                                            title   => "[% 'Agregar al &iacute;ndice' | i18n %]",
                                                                         
                                                ) ;
                    [% END %]
       </div>
[% ELSE %]
       <div class="alert alert-success">[% 'Todos los registros se encuentran indexados' | i18n %] </div>
[% END %]

