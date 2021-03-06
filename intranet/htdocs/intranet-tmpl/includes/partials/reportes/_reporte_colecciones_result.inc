<script type="text/javascript" src="/includes/jquery/jquery.nanoscroller.js"></script>
    
<script>
$(document).ready(function(){
     
});

function changePageBusquedas(ini){
    objAH.changePage(ini);
}
</script>



[% IF cant_n3 %]
  	<div class="contenedor_paginador">[% paginador %]</div>
	[% PERL %]
	        print C4::AR::Filtros::tableHeader(   
	                    id              => "tablaReporteColecciones",
	                    class           => "",
	                    selectAll_id    => "",
	                    columns         => ['[% "T&iacute;tulo"|i18n %]','[% "Autor"|i18n %]',
	                                        '[% "Edici&oacute;n" | i18n %]','[% "C&oacute;digo" | i18n %]', '[% "Signatura Topogr&aacute;fica" | i18n %]','[% "Fecha Alta" | i18n %]','[% "Operador" | i18n %]',
	                                        '[% "Editor" | i18n %]','[% "ISBN" | i18n %]'
	                                      ]
	                                                    
	                          ) ;
	[% END %]
	<tbody>    
	[% FOREACH res IN data %]
	  [% TRY %]
	      <tr>
	          <td>
	 
	              [% PERL %]
	                      print C4::AR::Filtros::link_to(	text 	=> 	"[% res.nivel1.getTitulo %]",
	                                                      url 		=>  "[% url_prefix %]/catalogacion/estructura/detalle.pl",
	                                                      params 	=>	["id1=[% res.nivel1.getId1 %]"], 
	                                                  ) ;
	              [% END %]
	          </td>
	          <td>
                  <a class="click" onClick="buscarPorAutor('[% prestamo.nivel3.nivel1.getAutor %]')" title="[% 'Filtrar por Autor' | i18n %]">
                        [% res.nivel1.getAutor %]
                  </a>          
	          </td>
	          <td>      
					[% IF res.nivel2.getEdicion %]
						[% res.nivel2.getEdicion %]
					[% END %]

					[% IF res.nivel2.getAnio_publicacion %]
						([% res.nivel2.getAnio_publicacion %])
					[% END %]
	          </td>
	          <td>
	              [% PERL %]
	                      print C4::AR::Filtros::link_to(	text => 	"[% res.getBarcode %]",
	                                                      url=>"[% url_prefix %]/catalogacion/estructura/detalleEjemplar.pl", 
	                                                      params =>	["id3=[% res.id3 %]"],
	                                                      title =>	"[% "Detalle del Ejemplar" | i18n %]"
	                                                  ) ;
	              [% END %]	
	          </td>
	          <td>
	              [% res.getSignatura %]
	          </td>
	          <td>
	              [% res.getCreatedAt_format %]
	          </td>
	          <td>
	              [% res.getCreatedByToString %]
	          </td>
	             <td>
       [% res.nivel2.getEditorObject.getEditorial %]
   </td>
   <td>
       [% res.nivel2.getISBN %]
   </td>	          
	      </tr>
	    <!-- FOREACH PRIMERO -->
		 [% CATCH %]
		 [% END %]
	[% END %]
	</tbody>
</table>
<div class="well">
      <div class="resultados_consulta">[% "La cantidad de registros" | i18n %]: <strong>[% cant_n1 %]</strong></div>
      <div class="resultados_consulta">[% "La cantidad de ediciones" | i18n %]: <strong>[% cant_n2 %]</strong></div><div class="resultados_consulta">[% "La cantidad de ejemplares" | i18n %]: <strong>[% cant_n3 %]</strong></div>
                 
</div>
[% IF !exportar && cant_n3 %]
<div class="form-actions" id="actions_ejemplares" style="margin-bottom: 0;">
        [% PERL %]
                    print C4::AR::Filtros::action_button(    
                            button  => 'btn click btn-primary',
                            title   => " [% 'Exportar a PDF' | i18n %]",
                            action  => 'imprimirReporte("form_reporte_colecciones","PDF");',
                            icon    => "icon-white icon-inbox",
                      ) ;
        [% END %]
      
        [% PERL %]
                    print C4::AR::Filtros::action_button(    
                            button  => 'btn click btn-primary',
                            title   => " [% 'Exportar a XLS' | i18n %]",
                            action  => 'imprimirReporte("form_reporte_colecciones","XLS");',
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

