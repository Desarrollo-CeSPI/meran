<script type="text/javascript" src="/includes/jquery/jquery.nanoscroller.js"></script>
    
<script>
$(document).ready(function(){
     
});


function changePageBusquedas(ini){
    objAH.changePage(ini);
}
</script>



[% IF cant %]
    <div class="well">
          <div class="resultados_consulta">[% "La cantidad de registros" | i18n %]: <strong>[% cant %]</strong></div>   
    </div>
    <div class="contenedor_paginador">[% paginador %]</div>
    [% PERL %]
            print C4::AR::Filtros::tableHeader(   
                        id              => "tablaReporteDisponibilidad",
                        class           => "",
                        selectAll_id    => "",
                        columns         => ['[% "T&iacute;tulo"|i18n %]','[% "Autor"|i18n %]','[% "Signatura"|i18n %]',
                                            '[% "C&oacute;digo" | i18n %]','[% "Edici&oacute;n" | i18n %]','[% "Fecha Cambio de disponibilidad" | i18n %]', '[% "Estado"|i18n %]'
                                          ]
                                                        
                              ) ;
    [% END %]
    <tbody>    
    [% FOREACH res IN data %]
      [% TRY %]
          <tr>
              <td>
     
                  [% PERL %]
                          print C4::AR::Filtros::link_to( text =>     "[% res.nivel2.nivel1.getTitulo %]",
                                                          url=>"[% url_prefix %]/catalogacion/estructura/detalle.pl",
                                                          params => ["id1=[% res.nivel2.nivel1.getId1 %]"], 
                                                      ) ;
                  [% END %]
              </td>
              <td>
                  <a class="click" onClick="buscarPorAutor('[% res.nivel2.nivel1.getAutor %]')" title="[% 'Filtrar por Autor' | i18n %]">
                        [% res.nivel2.nivel1.getAutor %]
                  </a>          
              </td>
              <td>      
                  [% res.getSignatura %]
              </td>
              <td>
                  [% PERL %]
                          print C4::AR::Filtros::link_to(   text =>     "[% res.getBarcode %]",
                                                          url=>"[% url_prefix %]/catalogacion/estructura/detalleEjemplar.pl", 
                                                          params => ["id3=[% res.getId3 %]"],
                                                          title =>  "[% "Detalle del Ejemplar" | i18n %]"
                                                      ) ;
                  [% END %] 
              </td>
              <td>

                    [% IF res.nivel2.getEdicion %]
                        [% res.nivel2.getEdicion %]
                    [% END %]

                    [% IF res.nivel3.getAnio_publicacion %]
                        ([% res.nivel3.getAnio_publicacion %])
                    [% END %]
              </td>
  
              <td>
                  [% res.getFechaUltimoCambioDisp %]
              </td>
              <td>      
                  [% res.getEstado %]
              </td>
              
          </tr>
        <!-- FOREACH PRIMERO -->
         [% CATCH %]
         [% END %]
    [% END %]
    </tbody>
</table>

[% IF !exportar && cant %]
<div class="form-actions" id="actions_ejemplares" style="margin-bottom: 0;">
   <td>
        [% PERL %]
                    print C4::AR::Filtros::action_button(    
                            button  => 'btn click btn-primary',
                            title   => " [% 'Exportar a PDF' | i18n %]",
                            action  => 'imprimirReporte("form_reporte_disponibilidad","PDF");',
                            icon    => "icon-white icon-inbox",
                      ) ;
        [% END %]
      
        [% PERL %]
                    print C4::AR::Filtros::action_button(    
                            button  => 'btn click btn-primary',
                            title   => " [% 'Exportar a XLS' | i18n %]",
                            action  => 'imprimirReporte("form_reporte_disponibilidad","XLS");',
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
