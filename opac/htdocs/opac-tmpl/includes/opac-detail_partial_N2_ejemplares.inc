<div id="detalleMARC" class="modal hide fade"></div>

                    <div class="accordion" id="ejemplares_opac[% id2 %]">
                        <div class="accordion-group">
	                        <div class="accordion-heading">
	                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#ejemplares_opac[% id2 %]" href="#ejemplares[% id2 %]">[% "Ejemplares" | i18n %]</a>
	                         </div>
		                     <div id="ejemplares[% id2 %]" class="accordion-body collapse">
		                        <div class="accordion-inner">
									[% IF cant_nivel3 %]

						             [% PERL %]
						                 print C4::AR::Filtros::tableHeader(   
						                                                         id              => "tablaResult",
						                                                         class           => "",
						                                                         columns         => ['[% "C&oacute;digo" | i18n %]','[% "Signatura Topogr&aacute;fica" | i18n %]',
											                                                            [% IF mostrar_ui_opac %]
																						                    '[% "Biblioteca que lo posee" | i18n %]',
																						                    '[% "Biblioteca de origen" | i18n %]',
											                                                            [% END %]
						                                                                             '[% "Estado"|i18n %]','[% "Disponibilidad"|i18n %]', '[% "MARC" | i18n %]',
						                                                                            ]
						                                                         
						                             ) ;
						             [% END %]

									                <tbody>
									                    [% FOREACH nivel3 %]
									                        <tr align="center">
									                            <td>[% nivel3_obj.getBarcode %]</td>
									                            <td>[% nivel3_obj.getSignatura_topografica %]</td>
	                                                            [% IF mostrar_ui_opac %]
										                            <td>[% nivel3_obj.getUiPoseedoraName %]</td>   
										                            <td>[% nivel3_obj.getUiOrigenName %]</td>  
	                                                            [% END %]
									                            <td>[% nivel3_obj.getEstado %]</td>
									                            <td>[% nivel3_obj.getDisponibilidadObject.getNombre %]</td>
									                            <td>
									                          [% PERL %]
									                                  print C4::AR::Filtros::action_button(
									                                  								  button		=> "btn",
									                                                                  icon         	=> "icon-list",
									                                                                  action        => 'detalleMARC([% id3 %]);', 
									                                                              ) ;
									                          [% END %]
									                            </td>
									                        </tr>
									                    [% END %]
									                </tbody>
									              </table>
										[% END %]
								</div>
							</div>
						</div>
					</div>
										