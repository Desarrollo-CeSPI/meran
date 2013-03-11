[% USE HTML %]


<div class="alert">
	<a class="close" data-dismiss="alert" href="#">×</a>
	<div class="modal-header">
		<h3>[% "Usted tiene los siguientes prestamos" | i18n %]</h3>
	</div>
	<div class="modal-body">
               [% FOREACH prestamo IN prestamos %]
                     <div class="[% IF prestamo.estaVencido %]alert alert-danger[% ELSE %]alert alert-success[% END %]">  
	                      <dt>
	                      [% IF prestamo.nivel3.nivel2.id1 %]
	                          [% PERL %]
	                                  print C4::AR::Filtros::link_to( text =>     "[% HTML.escape(prestamo.nivel3.nivel2.nivel1.getTitulo) %]",
	                                                                  url =>      "[% url_prefix %]/opac-prestamos_vigentes.pl", 
	                                                                  params => [ "id1=[% prestamo.nivel3.nivel2.id1 %]", ],
	                                                              ) ;
	                          [% END %]
	                      [% ELSE %]
	                          &nbsp;
	                      [% END %] 
	                      [% IF prestamo.estaVencido %]
	                            <span style="font-weight: bold;">(Prestamo Vencido)</span>
	                      [% END %] 
	                      </dt>
						  <dd>
	                          [% IF prestamo.nivel3.nivel1.getAutor %]
	                              [% HTML.escape(prestamo.nivel3.nivel1.getAutor) %]
	                          [% ELSE %]
	                              &nbsp;
	                          [% END %]
                          </dd>
                    </div>
                [% END %]
	</div>
                [% PERL %]
                   print C4::AR::Filtros::action_link_button( 
                                                     button         => "btn btn-inverse",
                                                     url       	=> "[% url_prefix %]/opac-prestamos_vigentes.pl",
                                                     params		=> ["token=[% token %]"],
                                                     title        => "[% 'Ver pr&eacute;stamos' | i18n %]",
                                       ) ;
                [% END %]
</div>
