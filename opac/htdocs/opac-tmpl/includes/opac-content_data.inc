
[% USE HTML %]

    <div class="hero-unit row" id="search-bar">
      <section>
	     	<h1 class="medium_font">[% 'Bienvenido ' | i18n %]
	     		<div style="display:inline"><small>&nbsp; [% ui.getNombre %]</small></div>
	     	</h1>
	        <p>
		        [% IF cant_sanciones > 0 %]
		              [% INCLUDE 'opac-sanciones.inc' %]
		        [% END %]
		        [% IF cantidad_prestamos > 0  %]
		            <div class="prestamos_opac_main">
		                  [% INCLUDE 'opac-prestamos.inc' %]
		            </div>
		        [% END %]
		
		        [% IF reservas_asignadas_count > 0 %]
		             <div class="reservas_asig_opac_main">
		                  [% INCLUDE 'opac-reservas_asignadas.inc' %]
		            </div>
		        [% END %]
		
			</p>
	          	
			[% IF cant_portada %]
			     <div id="carousel_portada_opac" class="carousel slide">
			            <div class="carousel-inner">
			            [% FOREACH p IN portada %]
			              <div class="item [% IF loop.first %]active[% END %]">
			                <img src="/opac-tmpl/uploads/portada/[% p.getImagePath %]" alt>
			                [% IF p.getFooter %]
				                <div class="carousel-caption">
				                  <h4>[% p.getFooterTitle %]</h4>
				                  <p style="font-size: 13px; color: white;">[% p.getFooter %]</p>
				                </div>
				            [% END %]
			              </div>
			            [% END %]
			        	</div>
			         [% IF cant_portada > 1 %]
						 <!-- Carousel nav -->
						  <a class="carousel-control left" href="#carousel_portada_opac" data-slide="prev">&lsaquo;</a>
						  <a class="carousel-control right" href="#carousel_portada_opac" data-slide="next">&rsaquo;</a>
					 [% END %]	        	
				</div>
			[% END %]
	
	        <form class="" action="[% url_prefix %]/opac-busquedasDB.pl" method="get" onsubmit="startOverlay();">
	            <input type="hidden" name="tipoAccion" value="BUSQUEDA_COMBINABLE" />
	            <input type="hidden" name="token" value="[% token %]" />
		        <p>
		        	<input type="text" name="string" class="input-medium search-query span98 bigInput"
	                 		  x-webkit-speech onwebkitspeechchange="javascript:startSearch();" 
	                   		  speech onspeechchange="javascript:startSearch();"
	                   		  id="input-bar-search-opac-main"
	                   		  placeholder="[% IF title_search_bar %] [% title_search_bar %] [% ELSE %] [% 'Qu&eacute; necesit&aacute;s' | i18n %]? [% END %]"
	                   		  autofocus="on"
		        	>
		        </p>
		    </form>
	 </section>
    </div>

      <!-- Example row of columns -->
      <div class="row">
         <div class="columns">
	        <div class="span4" id="[% IF novedad %]last_new[% END %]">
		        [% IF novedad %]
			          <h2>[% novedad.getTitulo %]</h2>
			           <p>[% novedad.getResumen %]</p>
			          <p>
		                [% PERL %]
		                   print C4::AR::Filtros::action_link_button( 
		                                                     button         => "btn click",
		                                                     url       	=> "[% url_prefix %]/opac-novedades.pl",
		                                                     params		=> ["token=[% token %]"],
		                                                     title        => "[% 'Novedades' | i18n %] &raquo;",
		                                       ) ;
		                [% END %]
		          	  </p>
				[% ELSE %]
			          <h2>[% 'Novedades' | i18n %]</h2>
			           <p>[% 'Todav&iacute;a no se ha publicado ninguna novedad. Siempre consult&aacute; esta secci&oacute;n para enterarte de las cosas que la biblioteca tiene para decirte' | i18n %].</p>
			          <p>
				[% END %]	        
	        </div>
	        <div class="span4">
	          	<h2>[% 'Ejemplares destacados' | i18n %]</h2>
	           	<p>[% 'Revis&aacute; los ejemplares promovidos por la biblioteca' | i18n %].</p>
				<p>
		            [% PERL %]
	                   print C4::AR::Filtros::action_link_button( 
	                                                     button         => "btn click",
	                                                     url       	=> "[% url_prefix %]/opac-destacados.pl",
	                                                     params		=> ["token=[% token %]"],
	                                                     title        => "[% 'Ver Destacados' | i18n %] &raquo;",
	                                       ) ;
	                [% END %]
				</p>
	          
	       </div>
	       
	        <div class="span4">
	          <h2>[% 'La biblioteca' | i18n %]</h2>
	          <p>[% ui.getNombre %]</p>
	          <p>[% ui.getTituloFormal %]</p>
	          <p>
                [% PERL %]
                   print C4::AR::Filtros::action_link_button( 
                                                     button         => "btn click",
                                                     url       	=> "[% url_prefix %]/opac-about.pl",
                                                     params		=> ["token=[% token %]"],
                                                     title        => "[% 'Acerca de' | i18n %] &raquo;",
                                       ) ;
                [% END %]
          	  </p>
	        </div>
	     </div>
      </div>

