<script type="text/javascript" src="/includes/jquery/jquery.nanoscroller.js"></script>
    
<script>
$(document).ready(function(){
     
});

function changePageBusquedas(ini){
    objAH.changePage(ini);
}
</script>

<div>
        <fieldset>
            <legend class="titulo_legend">[% nombre_estante | i18n %]</legend>
              

                  [% IF cant %]
                      [% PERL %]
                              print C4::AR::Filtros::tableHeader(   
                                              id              => "tablaResult",
                                              selectAll_id    => "",
                                              columns         => ['[% "Estante" | i18n %]',
                                                                  '[% "Cant. de t&iacute;tulos" | i18n %]',
                                                                  '[% "Cant. de Ejemplares" | i18n %]',
                                                                  '[% "Para Sala" | i18n %]',
                                                                  '[% "Para Prestamo" | i18n %]',
                                                                  '[% "No disponible" | i18n %]'
                                                                ],                              
                                                ) ;
                      
                      [% END %]  
                      <tbody>
                              [% FOREACH res IN data %]
                                  <tr>
                                    
                                      <td class="titulo_result">
                                            [% res.value.nombreEstante %]
                                      </td>
                                      <td class="autor_result">
                                            [% res.value.niveles1 %]
                                      </td>
                                      <td class="autor_result">
                                            [% res.value.niveles3 %]
                                      </td>
                                       <td class="autor_result">
                                            [% res.value.cantSala %]
                                      </td>
                                       <td class="autor_result">
                                            [% res.value.cantPrestamo %]
                                      </td>
                                       <td class="autor_result">
                                            [% res.value.noDisponibles %]
                                      </td>
                                  </tr>
                              [% END %]  
                      </tbody>
                  </table>

        </fieldset>
    </div>
    <div class="well">
        <div class="resultados_consulta">[% "La cantidad de subestantes" | i18n %]: <strong>[% cant %]</strong></div>             
    </div>
   
    [% IF !exportar && cant %]
        <div class="form-actions" id="actions_ejemplares" style="margin-bottom: 0;">
           <td>
              [% PERL %]
                        print C4::AR::Filtros::action_set_button(    
                                button  => 'btn btn-primary',
                                title => " [% 'Exportar a PDF' | i18n %]",
                                action => 'imprimirReporte("form_reporte_estantes_virtuales");',
                                icon => "icon-white icon-inbox",
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
