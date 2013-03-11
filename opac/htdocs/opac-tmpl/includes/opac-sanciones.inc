[% USE HTML %]




<div class="alert alert-danger">
	<a class="close" data-dismiss="alert" href="#">×</a>
	<div class="modal-header">
		<h3>[% "Usted tiene las siguientes sanciones" | i18n %]</h3>
	</div>
	<div class="modal-body">
                [% FOREACH sancion IN sanciones %]
                      <dl>
                            <dt> 

	                            [% IF sancion.tipo_sancion %]
	                                [% FOREACH ts IN sancion.ref_tipo_prestamo_sancion %] 
	                                    [% ts.ref_tipo_prestamo.descripcion %]
	                                    [% BREAK %]
	                                [% END %]
	                                [% ELSE %]
	                                    [% "Reserva no retirada" | i18n %]
	                             [% END %]
                            </dt>
							                            
								<div class="well">
		                            <dt class="inline left rightMargin">[% "Autor: " | i18n %]</dt>
		                            <dd>[% HTML.escape(sancion.nivel3.nivel1.getAutor) %]</dd>
		
		                            <dt class="inline left rightMargin">[% "Titulo: " | i18n %]</dt>
		                            <dd>[% HTML.escape(sancion.nivel3.nivel1.getTitulo) %]</dd>
	
									[% IF sancion.nivel3.nivel2.getEdicion %] 
			                            <dt class="inline left rightMargin">[% "Edicion: " | i18n %]</dt>
			                            <dd>		
	                                           [% HTML.escape(sancion.nivel3.nivel2.getEdicion) %]
			                            </dd>
                                    [% END %]
	                            </div>

	                            <dt class="inline left rightMargin">[% "Desde el: " | i18n %]</dt>
	                            <dd>[% sancion.getFecha_comienzo_formateada %]<b> [% " hasta el: " | i18n %]</b>[% sancion.getFecha_final_formateada %] ([% sancion.getDias_sancion %] [% "d&iacute;as" | i18n %]) </dd>
								
                            </dl>
                 [% IF !loop.last %]
                 	<hr />
                 [% END %]
                [% END %]
	</div>
                [% PERL %]
                   print C4::AR::Filtros::action_link_button( 
                                                     button     => "btn btn-inverse",
                                                     url        => "[% url_prefix %]/opac-detalle_sanciones.pl",
                                                     params     => ["token=[% token %]"],
                                                     title      => "[% 'Ver sanciones' | i18n %]",
                                       ) ;
                [% END %]


</div>
                