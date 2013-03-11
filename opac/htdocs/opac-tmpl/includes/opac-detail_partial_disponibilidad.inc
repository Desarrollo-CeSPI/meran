<div id="divDisponivilidadOpac" class="alert alert-success">
		<blockquote>
			[% IF cantParaPrestamoActual && cantParaSalaActual %]
	        	<p>[% "Se cuenta con disponibilidad inmediata para domicilio o la sala de lectura" | i18n %].</p>
			[% ELSE %]
				[% IF cantParaPrestamoActual %]
		        	<p>[% "Se cuenta con disponibilidad inmediata para llevar a domicilio" | i18n %].</p>
		        [% ELSE %]
					[% IF cantParaSalaActual %]
			        	<p>[% "En este momento solamente se cuenta con disponibilidad para sala de lectura" | i18n %].</p>
					[% ELSE %]
						<p>[% "En este momento no hay ning&uacute;n ejemplar disponible" | i18n %].</p>
					[% END %]
				[% END %]
			[% END %]
		<br>
		
		  [% IF mostrarDetalleDisponibilidad %]
	          <small>[% "Disponibilidad Actual Para Pr&eacute;stamo: " | i18n %] [% cantParaPrestamoActual %] [% " " | i18n %]</small>
	          <small>[% "Disponibilidad Actual Para Sala de Lectura: " | i18n %] [% cantParaSalaActual %] [% " " | i18n %]</small>
	
	          <small>[% "Cantidad Actual de Reservas:  " | i18n %] [% cantReservas %]</small>
	      
	          <small>[% "Cantidad Actual de Pr&eacute;stamos:" | i18n %] [% cantPrestados%]</small>
		  [% END %]			             
      	</blockquote>
			
           [% IF CirculationEnabled %]
                                   [% IF socio_data.usr_nro_socio %]    
	                                   [% IF socio_data.object.puedeReservar( id2 ) %]
	                                        [% PERL %]
	                                            print C4::AR::Filtros::action_button(   
	                                                                                button   => "btn btn-primary",
	                                                                                icon   => "icon-white icon-shopping-cart",
	                                                                                title   => "[% 'Reservar un ejemplar' | i18n %]",
	                                                                                [% IF cantParaPrestamo == 0 %]
                                                                                   	      disabled => 1,
	                                                                                      popover		=> {title=>'[% "Disponibilidad" | i18n %]',
	                                                                                      					text => '[% "No hay disponibilidad para domicilio sobre esta edici&oacute;n" | i18n %].' },
		                                                                            [% ELSE %]
			                                                                                action => 'showReservar("modal_reservar_[% id2 %]");',
		                                                                            [% END %]
	                                                                        );
	                                        [% END %]
	                                    [% ELSE %]
	                                    
	                                    
	                                        [% IF socio_data.object.loTienePrestado( id2 ) %]
		                                        [% PERL %]
		                                            
		                                            print C4::AR::Filtros::action_button(   
		                                                                                button   => "btn btn-inverse",
		                                                                                icon   => "icon-white icon-ban-circle",
		                                                                                disabled	=> 1,
		                                                                                title   => "[% 'Ejemplar en pr&eacute;stamo' | i18n %]",
	                                                                                    popover		=> {title=>'[% "Disponibilidad" | i18n %]',
		                                                                                      					text => '[% "UD. ya tiene un pr&eacute;stamo sobre esta edici&oacute;n" | i18n %].' },
		                                                                        );
		                                        [% END %]
	                                    	[% ELSE %]
		                                        [% PERL %]
		                                            
		                                            print C4::AR::Filtros::action_button(   
		                                                                                button   => "btn btn-danger",
		                                                                                icon   => "icon-white icon-remove",
		                                                                                title   => "[% 'Cancelar reserva' | i18n %]",
		                                                                                action => 'cancelarReserva([% socio_data.object.getIdReserva(id2) %]);',
		                                                                        );
		                                        [% END %]
		                                    [% END %]
	                                    [% END %]
                                   [% END %]
           [% END %]



</div>

  [% INCLUDE 'rating.inc' %]
