<div class="navbar navbar-inverse navbar-fixed-top">
    <div class="navbar-inner">
      <div class="container" style="width: auto;">
        <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </a>
        <div id="opacLogo">
          [% IF ui.tieneLogoOpacMenu %]
          	<a href="[% url_prefix %]/opac-main.pl" class="logo_opac_menu">
          		<img src="[% temas %]/[% user_theme %]/imagenes/[% logo %]" />
          	</a>
          [% ELSE %]
      			[% PERL %]
      	                   print C4::AR::Filtros::link_to( text    =>  "[% 'MERAN' | i18n %]",
      	                                                    url     =>  '[% url_prefix %]/opac-main.pl',
      	                                                    title   =>  "[% 'Inicio' | i18n %]",
      	                                                    class	=> "brand brand_less_padding white",
      	                            ) ;
      			[% END %]
    		[% END %]
        </div>
        <div class="nav-collapse">
          <ul class="nav">
	            <li class="dropdown">
	              <a href="#" class="dropdown-toggle" data-toggle="dropdown">[% 'Cat&aacute;logo' | i18n %] <b class="caret"></b></a>
	              <ul class="dropdown-menu">
			            <li>
			                [% PERL %]
			                    print C4::AR::Filtros::link_to( text    =>  "[% 'B&uacute;squeda Avanzada' | i18n %]",
                                  							    icon    => "icon-search",
			                                                    url     =>  '[% url_prefix %]/opac-advanced_search.pl',
			                                                    title   =>  "[% 'B&uacute;squeda Avanzada' | i18n %]",
			                            ) ;
			                [% END %]
			            </li>
			            <li>
			                [% PERL %]
			                    print C4::AR::Filtros::link_to( text    =>  " [% 'Estantes Virtuales' | i18n %]",
			                                                    url     =>  '[% url_prefix %]/opac-estante.pl',
			                                                    icon    => "icon-folder-open",
			                                                    title   =>  "[% 'Estantes Virtuales' | i18n %]",
			                            ) ;
			                [% END %]
			            </li>   
		            </ul>
	            </li>  
	            [% IF socio_data.usr_nro_socio %]
	                <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">[% 'Mi cuenta' | i18n %] <b class="caret"></b></a>
                        <ul class="dropdown-menu">
                            <li>
                                [% PERL %]
                                  print C4::AR::Filtros::link_to( text    =>  "[% 'Pr&eacute;stamos vigentes' | i18n %]",
                                                                  url     =>  '[% url_prefix %]/opac-prestamos_vigentes.pl',
                                                                  title   =>  "[% 'Pr&eacute;stamos vigentes' | i18n %]",
                                          ) ;
                                [% END %]
                            </li>
                            <li>
                                [% PERL %]
                                  print C4::AR::Filtros::link_to( text    =>  "[% 'Reservas' | i18n %]",
                                                                  url     =>  '[% url_prefix %]/opac-info_reservas.pl',
                                                                  params  =>   ["action=detalle_asignadas","token=[% token %]"],
                                                                  title   =>  "[% 'Reservas' | i18n %]",
                                          ) ;
                                [% END %]
                            </li>
                            <li>
                                [% PERL %]
                                    #print C4::AR::Filtros::link_to( text    =>  "[% 'Recomendaciones' | i18n %]",
                                    #                              url     =>  '[% url_prefix %]/opac-recomendaciones.pl',
                                    #                              title   =>  "[% 'Recomendaciones' | i18n %]",
                                    #      ) ;
                                [% END %]
                            </li>
                            <li class="divider"></li>
                            <li class="nav-header">[% 'Personal' | i18n %]</li>	
                            <li>
                                [% PERL %]
                                  print C4::AR::Filtros::link_to( text    =>  " [% 'Favoritos' | i18n %]",
                                  								  icon    => "icon-star",
                                                                  url     =>  '[% url_prefix %]/opac-favoritos.pl',
                                                                  title   =>  "[% 'Favoritos' | i18n %]",
                                          ) ;
                                [% END %]
                            </li>		                  
                            <li>
                                [% PERL %]
                                  print C4::AR::Filtros::link_to( text    =>  " [% 'Historial de pr&eacute;stamos' | i18n %]",
                                                                  url     =>  '[% url_prefix %]/opac-historial_prestamos.pl',
                                  								  icon    => "icon-shopping-cart",
                                                                  title   =>  "[% 'Historial de pr&eacute;stamos' | i18n %]",
                                          ) ;
                                [% END %]
                            </li>
                            <li>
                                [% PERL %]
                                  print C4::AR::Filtros::link_to( text    =>  " [% 'Historial de reservas' | i18n %]",
                                  								  icon    => "icon-inbox",
                                                                  url     =>  '[% url_prefix %]/opac-historial_reservas.pl',
                                                                  title   =>  "[% 'Historial de reservas' | i18n %]",
                                          ) ;
                                [% END %]
                            </li>
                        </ul>
                    </li>     
	            [% END %]     
          </ul> 
          <form class="navbar-search pull-left" action="[% url_prefix %]/opac-busquedasDB.pl" method="get" onsubmit="startOverlay(); return true;">
              <input type="text" name="string" id="search_bar" class="search-query span3" placeholder="[% 'Buscar' | i18n %]"
                   		  x-webkit-speech onwebkitspeechchange="javascript:startSearch();" 
                   		  speech onspeechchange="javascript:startSearch();"
                   		  value="[% search_term %]"
              >
              <input type="hidden" name="tipoAccion" value="BUSQUEDA_COMBINABLE" />
              <input type="hidden" name="token" value="[% token %]" />
          </form>

          <ul class="nav pull-right">
            <li>
                    [% PERL %]
	                    print C4::AR::Filtros::link_to( text    =>  "[% 'Contacto' | i18n %]",
	                                                    url     =>  '[% url_prefix %]/opac-contact.pl',
	                                                    title   =>  "[% 'Contacto' | i18n %]",
	                            ) ;
	                [% END %]
			 </li>
            <li class="divider-vertical"></li>
			[% IF socio_data.usr_nro_socio %]
	            <li class="dropdown">
		            <a href="#" class="dropdown-toggle" data-toggle="dropdown">[% socio_data.usr_nombre %]&nbsp;[% socio_data.usr_apellido %]<b class="caret"></b></a>
		            <ul class="dropdown-menu">
                    <li>
                            [% PERL %]
                              print C4::AR::Filtros::link_to( text    =>  '<i class="icon-user"></i> [% "Mis Datos" | i18n %]',
                                                              url     =>  '[% url_prefix %]/misDatos.pl',
                                                              title   =>  "[% 'Mis Datos' | i18n %]",
                                      ) ;
                            [% END %]
                    </li>
		                <li>
		                
		                    [% PERL %]
                              print C4::AR::Filtros::link_to( text    =>  '<i class="icon-cog"></i> [% "Ajustes" | i18n %]',
                                                              url     =>  '[% url_prefix %]/settings.pl',
                                                              title   =>  "[% 'Ajustes' | i18n %]",
                                      ) ;
                            [% END %]
		                </li>
		                <li class="divider"></li>
		                <li><a href="[% url_prefix %]/logout.pl?token=[% token %]"><i class="icon-off"></i> [% "Salir" | i18n %]</a></li>
		            </ul>
				</li>
            [% ELSE %]
            	<li class="active" >
            	
                      [% PERL %]
                          print C4::AR::Filtros::link_to( text    =>  "[% 'Iniciar sesi&oacute;n' | i18n %]",
                                                          url     =>  '[% url_prefix %]/auth.pl',
                                                          title   =>  "[% 'Iniciar sesi&oacute;n' | i18n %]",
                                  ) ;
                      [% END %]
            	</li>
            [% END %]
          </ul>
        </div><!-- /.nav-collapse -->
      </div>
    </div><!-- /navbar-inner -->
  </div>
