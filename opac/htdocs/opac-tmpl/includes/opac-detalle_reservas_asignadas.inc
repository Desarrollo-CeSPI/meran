<div id="detalleReservas">
	<fieldset>
	    <legend> [% 'Material para retirar' | i18n %] </legend>
	        [% IF reservas_asignadas_count %]
	                <div class="well">
	                [% "La cantidad de Reservas es" | i18n %]: <strong>[% reservas_asignadas_count  %]</strong>
	                </div>
	                    [% PERL %]
	                        print C4::AR::Filtros::tableHeader(  
	                                          id              => "tablaResult",
	                                          columns         => ['[% "T&iacute;tulo" | i18n %]',
	                                                              '[% "Autor" | i18n %]',
	                                                              '[% "Edici&oacute;n" | i18n %]',
	                                                              '[% "Disponible desde" | i18n %]',
	                                                              '[% "Disponible hasta" | i18n %]',
	                                                              '[% "Retira en" | i18n %]',
	                                                              '[% "Acci&oacute;n" | i18n %]',
	                                                      
	                                                            ]
	                                                );
	                    [% END %]
	                        
	            <!-- ESTE LOOP MUESTRA LAS RESERVAS EN ESPERA -->
	                [% FOREACH reserva IN RESERVAS_ASIGNADAS %]
	                    <tr>
	                        <td >
	                            [% PERL %]
	                                  print C4::AR::Filtros::link_to( text =>     "[% reserva.nivel2.nivel1.getTitulo %]",
	                                                                  url =>      "[% url_prefix %]/opac-detail.pl", 
	                                                                  params =>   ["id1=[% reserva.nivel2.nivel1.getId1 %]"],
	                                                                  title =>    "[% 'Mostrar Detalle del Ejemplar' | i18n %]"
	                                                              ) ;
	                            [% END %]
	                        </td>
	                        <td >
	                            [% IF reserva.nivel2.nivel1.getAutor %]
	                                [% reserva.nivel2.nivel1.getAutor %]
	                                </a>
	                            [% ELSE %]
	                                &nbsp;
	                            [% END %]
	                        </td> 
	                        <td>  
	                            [% IF reserva.nivel2.getEdicion %] [% reserva.nivel2.getEdicion %] [% ELSE %] - [% END %]
	                        </td>
	                        <td>
	                            [% IF reserva.getFecha_reserva_formateada %] 
	                                [% reserva.getFecha_reserva_formateada %]
	                            [% ELSE %]
	                                - 
	                            [% END %]
	                        </td>
	                        <td>
	                            [% IF reserva.getFecha_recordatorio_formateada %]
	                                <font  [% IF reserva.estaVencida %] color="red" [% END %] >[% reserva.getFecha_recordatorio_formateada %]</font>
	                            [% ELSE %]
	                                - 
	                            [% END %]
	                        </td>
	                    
	                        <td >
	                            <b>[% reserva.ui.getNombre %]</b>
	                        </td>
	                        <td> 
	                        [% IF CirculationEnabled %]
	
	                            [% PERL %]
	                                print C4::AR::Filtros::action_button(   
	                                                                    button   => "btn click btn-danger",
	                                                                    icon => "icon-remove icon-white",
	                                                                    action => "cancelarReserva([% reserva.getId_reserva %])",
	                                                                    title   => " [% 'Cancelar Reserva' | i18n %]",
	                                                            );
	                            [% END %]
	
	
	                        [% ELSE %]
	                            [% "No disponible" | i18n %]
	                        [% END %]
	                        </td>
	                  </tr>
	                [% END %]
	            </table>
	            <br>
	        [% ELSE %]
	
	            <div class="alert alert-info"> [% 'No ten&eacute;s material para retirar.' | i18n %]</div>
	        [% END %]
	<fielset>
</div>