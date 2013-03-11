<script>
    $(document).ready(function() {
    	$('.dropdown-toggle').dropdown();
    });
</script>
    
    <div id="tabla_referencia">
        <fieldset>
            <legend>[% "Detalle del esquema " | i18n %] [% esquema_title %]</legend>
            
                  [% IF esquema.size %]               

			            [% IF cantidad %]
			                <div class="resultados_consulta">[% "Total de campos" | i18n %]: <b>[% cantidad %]</b></div>
			                [% END %]
                        
						<form class="well form-search" onsubmit="showEsquemaImportacion(); return false;">
						      <input type="text" class="input-medium search-query" id="campo_search" name="campo_search">
						      <button class="btn" onclick="">[% "Buscar"|i18n %]</button>
   				        </form>                            
                        
                            [% PERL %]
                                print C4::AR::Filtros::tableHeader(   
                                                  id              => "datos_tabla_div_esquema",
                                                  class           => "",
                                                  selectAll_id    => "",
                                                  columns         => ['[% "Campo origen"|i18n %]','[% "SubCampo origen"|i18n %]',
                                                                    '[% "Destino"|i18n %]','[% "Ignorar"|i18n %]','[% "Acciones"|i18n %]',
                                                                     ],
                                            ) ;
                            [% END %]
                                
                            <tbody>
                                [% FOREACH detalle IN esquema %]
                                    <script>var esquema = [% detalle.id %]</script>                               
                                    <tr id="esquema_[% detalle.id %]">
                                        <td class="editable" id="[% detalle.id %]___co">[% detalle.getCampoOrigen %]</td>
                                        <td class="editable" id="[% detalle.id %]___sco">[% detalle.getSubcampoOrigen %]</td>
                                        <td class="" id="[% detalle.id %]___destino">[% detalle.getDestino %]</td>
                                        <td class="editable_hover editable_select" id="[% detalle.id %]___ign">[% detalle.getIgnorarFront %]</td>

                                        <script>
                                            $('.editable_select').editable('[% url_prefix %]/herramientas/importacion/esquemas_importacionDB.pl', { 
                                                data   : " {'[% 'No' | i18n %]':'[% 'No' | i18n %]','[% 'Si' | i18n %]':'[% 'Si' | i18n %]','selected':'[% 'detalle.getIgnorarFront' %]'}",
                                                type      : 'select',
                                                submit    : 'OK',
                                                style   : 'display: inline',
                                                submitdata : {token: "[% token %]", edit: '1'},
                                                indicator : loaderPath,
        
                                           }); 
                                        </script>
                                        <td style="width: 100px;">
                                            [% PERL %]
                                                print C4::AR::Filtros::action_set_button(    
                                                      title           => "[% 'Editar' | i18n %]",
                                                      button          => 'btn btn-primary',
                                                      action		  => "editarOrdenEsquema([% detalle.id %]);",
                                                      actions         => [
                                                                          { title => "[% 'Eliminar' | i18n %]", 
                                                                            action=> "eliminarEsquemaRow([% detalle.id %]);",
                                                                            icon=>"icon-trash"
                                                                          },
                                                                           {title => "[% 'Agregar campo' | i18n %]", 
                                                                            action=>"agregarCampoAEsquema([% detalle.id %]);",
                                                                            icon  =>"icon-plus"
                                                                           },
                                                                          ],
                             
                                                        ) ;
                                        	[% END %]
                                        </td>
                                  </tr>
                                [% END %]
                            </tbody>
                        </table>
                        <div class="contenedor_paginador">[% paginador %]</div>
                        
                [% ELSE %]
                
                    <div class="alert alert-info">[% 'No hay detalle para mostrar'| i18n %]</div>
                
                [% END %]
                <div class="form-actions">
	                [% PERL %]
	                       print C4::AR::Filtros::to_Button(   text    => "[% 'Agregar campo' | i18n %]",
	                                                           boton   => "boton_agregar",
	                                                           onClick => "agregarCampo([% id_esquema %]);",
	                                                           title   => "[% 'Agregar campo' | i18n %]",
	                               ) ;
	                [% END %]
                </div>
             [% IF table_error_message %] 
                <div class="alert alert-info" style="clear:both;"> [% table_error_message %] </div>
             [% END%]
        </fieldset>
    </div>
    <div id="add_campo_esquema_result"></div>
    <div id="tablaResultSubCampos"></div>
