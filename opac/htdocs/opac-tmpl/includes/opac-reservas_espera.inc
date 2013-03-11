[% USE HTML %]

<div class="alert">
	<a class="close" data-dismiss="alert" href="#">×</a>
	<div class="modal-header">
		<h3>[% "Debe retirar estos ejemplares" | i18n %]</h3>
	</div>
	<div class="modal-body">
                [% FOREACH reserva IN RESERVAS_ASIGNADAS %]
                    <div class="alert alert-info">
	                    <dl>
	                    	<dt>
			                    [% PERL %]
			                              print C4::AR::Filtros::link_to( text =>     "[% HTML.escape(reserva.nivel2.nivel1.getTitulo) %]",
			                                                              url =>      "[% url_prefix %]/opac-info_reservas.pl", 
			                                                              params =>   ["action=detalle_asignadas"],
			                                                              title =>    "[% 'Mostrar Detalle del Ejemplar' | i18n %]"
			                                                          ) ;
			                    [% END %]
		                    </dt>
		                    <dd>
			                    [% IF reserva.nivel2.nivel1.getAutor %]
			                        [% HTML.escape(reserva.nivel2.nivel1.getAutor) %]
			                    [% ELSE %]
			                        &nbsp;
			                    [% END %]
		                    </dd>
	                        [% IF reserva.getFecha_recordatorio_formateada %]
	                          <span class="help-block">
	                              [% "Tiene tiempo de retirar el ejemplar asignado hasta el d&iacute;a" | i18n %] <span class="label label-info">[% reserva.getFecha_recordatorio_formateada %] [% "a las" | i18n %] [% cierre_ui %]  [% "horas." | i18n %]</span> 
	                          </span>
	                        [% ELSE %]
	                              - 
	                        [% END %]
	                     </dl>
	                 </div>
	                 [% IF !loop.last %]
	                 	<hr />
	                 [% END %]
	             [% END %]
   </div>
</div>


