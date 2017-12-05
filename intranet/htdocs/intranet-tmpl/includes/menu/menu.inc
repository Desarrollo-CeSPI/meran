[% INCLUDE "header.inc" %]
<div class="navbar navbar-inverse navbar-fixed-top">
    <div class="navbar-inner">
      <div class="container" style="width: auto;">
        <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </a>
        
        <div id="logo"><a href="[% url_prefix %]/mainpage.pl?token=[% token %]">[% 'MERAN' | i18n %]</a></div>
        <div class="nav-collapse">
          <ul class="nav">
            <li class="dropdown">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown">[% 'Cat&aacute;logo' | i18n %] <b class="caret"></b></a>
              <ul class="dropdown-menu">
	              <li>
	                  [% PERL %]
	                  print C4::AR::Filtros::link_to( text =>     " [% 'B&uacute;squeda avanzada' | i18n %]",
	              									  url =>      "[% url_prefix %]/busquedas/filtrado.pl",
	              									  icon	=>		"icon-search",
	                                                  title =>    " [% 'B&uacute;squeda avanzada' | i18n %]"
	                                                );
	                  [% END %]
	              </li>
                <li>
                    [% PERL %]
                    print C4::AR::Filtros::link_to( text =>     " [% 'Buscar en Estantes Virtuales' | i18n %]",
                                    url =>      "[% url_prefix %]/estantes/buscar.pl",
                                    icon  =>    "icon-search",
                                                    title =>    " [% 'Buscar en Estantes Virtuales' | i18n %]"
                                                  );
                    [% END %]
                </li>
	         	  <li>
					       [% PERL %]
	                   print C4::AR::Filtros::link_to( text =>     " [% 'Registros y Grupos' | i18n %]",
	                                                url =>      "[% url_prefix %]/catalogacion/registros_grupos.pl",
													                         icon	=>		"icon-play",	                                                
	                                                title =>    " [% 'Registros y Grupos' | i18n %]"
												  ) ;
	                [% END %]
	              </li>
	              
	              <li class="divider"></li>
	
	                               <li>
	                                   [% PERL %]
	                                       print C4::AR::Filtros::link_to( text =>     " [% 'Agregar documento' | i18n %]",
	                                                                       url =>      "[% url_prefix %]/catalogacion/estructura/datosDocumento.pl",
		                                                                   icon	=>		"icon-plus",
	                                                                       title =>    "[% 'Agregar documento' | i18n %]"
	                                                                   ) ;
	                                   [% END %]
	                               </li>
	                               <li>
	                                   [% PERL %]
	                                       print C4::AR::Filtros::link_to( text =>     "<i class='icon-inbox'></i> [% 'Estantes virtuales' | i18n %]",
	                                                                       url =>      "[% url_prefix %]/estantes/estante.pl",
	                                                                       title =>    "[% 'Estante virtuales' | i18n %]"
	                                                                   ) ;
	                                   [% END %]
	                               </li>
	                          <li>
                                  [% PERL %]
                                      print C4::AR::Filtros::link_to( text  => " [% 'Ayuda MARC' | i18n %]",
                                                                      url   => "[% url_prefix %]/admin/ayudaMarc.pl",
                                                                      icon  => "icon-globe",
                                                                      title =>  "[% 'Ayuda MARC' | i18n %]"
                                                                  ) ;
                                  [% END %]
                          </li>

	      [% IF socio_data.usr_credential_type == "superLibrarian" %]
                            <li class="nav-header">[% 'Preferencias' | i18n %]</li>	
	              			      <li class="divider"></li>
					
                             <li>
                             [% PERL %]
                                print C4::AR::Filtros::link_to( text =>     "<i class='icon-cog'></i> [% 'Preferencias' | i18n %]",
                                                                url =>      "[% url_prefix %]/admin/global/catalogo_config.pl",
                                                                title =>    "[% 'Preferencias' | i18n %]"
                                                            ) ;
                             [% END %]
                             </li>
                             <li>
                             [% PERL %]
                                print C4::AR::Filtros::link_to( text =>     "<i class='icon-cog'></i> [% 'C&oacute;digos de inventario' | i18n %]",
                                                                url =>      "[% url_prefix %]/admin/catalogo/barcode_gen_setup.pl",
                                                                title =>    "[% 'C&oacute;digos de inventario' | i18n %]"
                                                            ) ;
                             [% END %]
                             </li>
                              <li>
                                  [% PERL %]
                                      print C4::AR::Filtros::link_to( text =>     "<i class='icon-cog'></i> [% 'Creaci&oacute;n cat&aacute;logo' | i18n %]",
                                                                      url =>      "[% url_prefix %]/catalogacion/estructura/estructuraCatalo.pl",
                                                                      title =>    "[% 'Creaci&oacute;n cat&aacute;logo' | i18n %]"
                                                                  ) ;
                                  [% END %]
                              </li>
                              <li>
                                  [% PERL %]
                                      print C4::AR::Filtros::link_to( text =>     "<i class='icon-cog'></i> [% 'Visualizaci&oacute;n del OPAC' | i18n %]",
                                                                      url =>      "[% url_prefix %]/catalogacion/visualizacionOPAC/visualizacionOpac.pl",
                                                                      title =>    "[% 'Visualizaci&oacute;n del OPAC' | i18n %]"
                                                                  ) ;
                                  [% END %]
                              </li>
                              <li>
                                  [% PERL %]
                                      print C4::AR::Filtros::link_to( text =>     "<i class='icon-cog'></i> [% 'Visualizaci&oacute;n de INTRANET' | i18n %]",
                                                                      url =>      "[% url_prefix %]/catalogacion/visualizacionINTRA/visualizacionIntra.pl",
                                                                      title =>    "[% 'Visualizaci&oacute;n del INTRANET' | i18n %]"
                                                                  ) ;
                                  [% END %]
                              </li>
                                <li>
                                            [% PERL %]
                                                print C4::AR::Filtros::link_to( text =>     "<i class='icon-eye-open'></i> [% 'Moderar revisiones' | i18n %]",
                                                                                url =>      "[% url_prefix %]/admin/catalogo/revisiones_pendientes.pl",
                                                                                title =>    "[% 'Moderar revisiones' | i18n %]"
                                                                            ) ;
                                            [% END %]
                                </li>
                                <li>
                                            [% PERL %]
                                                print C4::AR::Filtros::link_to( text =>     " [% 'Tipo de documento' | i18n %]",
                                                                                url =>      "[% url_prefix %]/catalogacion/tipo_documento.pl",
                                                                                title =>    " [% 'Tipo de documento' | i18n %]",
                                                                                icon => "icon-cog",
                                                                            ) ;
                                            [% END %]
                                </li>
                                <li>
           [% END %]
        	<li class="divider"></li>
	      [% IF socio_data.usr_credential_type == "librarian" OR  socio_data.usr_credential_type == "superLibrarian" %]
	                    
                                <li>
                                            [% PERL %]
                                                print C4::AR::Filtros::link_to( text =>     "<i class='icon-print'></i> [% 'Reportes' | i18n %]",
                                                                                url =>      "[% url_prefix %]/reports/catalogo.pl",
                                                                                title =>    "[% 'Reportes' | i18n %]"
                                                                            ) ;
                                            [% END %]
                                </li>
		  [% END %]			
              </ul>
            </li>

            <li class="dropdown">
	            <a href="#" class="dropdown-toggle" data-toggle="dropdown">[% 'Usuarios' | i18n %] <b class="caret"></b></a>
	            <ul class="dropdown-menu">
   	      [% IF socio_data.usr_credential_type == "librarian" OR  socio_data.usr_credential_type == "superLibrarian" %]
	            
	                    <li>
	                              [% PERL %]
	                                  print C4::AR::Filtros::link_to( text =>     " [% 'Usuarios Reales' | i18n %]",
	                                                                  url =>      "[% url_prefix %]/usuarios/reales/buscarUsuario.pl",
																	  icon	=>		"icon-user",
	                                                                  title =>    " [% 'Usuarios Reales' | i18n %]"
	                                                              ) ;
	                              [% END %]
	                    </li>
	                    <li>
	                              [% PERL %]
	                                  print C4::AR::Filtros::link_to( text =>     " [% 'Usuarios Potenciales' | i18n %]",
	                                                                  url =>      "[% url_prefix %]/usuarios/potenciales/buscarUsuario.pl",
	                                                                  icon	=>		"icon-random",
	                                                                  title =>    " [% 'Usuarios Potenciales' | i18n %]"
	                                                              ) ;
	                              [% END %]
	                    </li>
	                    <li>
	                              [% PERL %]
	                                  print C4::AR::Filtros::link_to( text =>     " [% 'Agregar Usuarios' | i18n %]",
	                                                                  url =>      "[% url_prefix %]/usuarios/reales/agregarUsuario.pl",
                                                                      icon	=>		"icon-plus",
	                                                                  title =>    "[% 'Agregar Usuarios' | i18n %]"
	                                                              ) ;
	                              [% END %]
	                    </li>
	      [% END %]
	      [% IF socio_data.usr_credential_type == "superLibrarian" %]
	                    
				<li class="divider"></li>
                                <li>
                                            [% PERL %]
                                                print C4::AR::Filtros::link_to( text =>     "<i class='icon-cog'></i> [% 'Admin. libre Deuda' | i18n %]",
                                                                                url =>      "[% url_prefix %]/admin/usuarios/adminLibreDeuda.pl",
                                                                                title =>    "[% 'Admin. libre Deuda' | i18n %]"
                                                                            ) ;
                                            [% END %]
                                </li>
                                <li>
                                            [% PERL %]
                                                print C4::AR::Filtros::link_to( text =>     "<i class='icon-cog'></i> [% 'Regularidades' | i18n %]",
                                                                                url =>      "[% url_prefix %]/admin/usuarios/regularidades.pl",
                                                                                title =>    "[% 'Regularidades' | i18n %]"
                                                                            ) ;
                                            [% END %]
                                </li>
          [% END %]
				<li class="divider"></li>
	      [% IF socio_data.usr_credential_type == "superLibrarian" %]
	                    
                                <li>
                                            [% PERL %]
                                                print C4::AR::Filtros::link_to( text =>     "<i class='icon-flag'></i> [% 'Permisos' | i18n %]",
                                                                                url =>      "[% url_prefix %]/admin/permisos/permisos.pl",
                                                                                title =>    "[% 'Permisos' | i18n %]"
                                                                            ) ;
                                            [% END %]
                                </li>
          [% END %]

				<li class="divider"></li>
	      [% IF socio_data.usr_credential_type == "librarian" OR  socio_data.usr_credential_type == "superLibrarian" %]
	                    
                                <li>
                                            [% PERL %]
                                                print C4::AR::Filtros::link_to( text =>     "<i class='icon-print'></i> [% 'Reportes' | i18n %]",
                                                                                url =>      "[% url_prefix %]/reports/usuarios.pl",
                                                                                title =>    "[% 'Reportes' | i18n %]"
                                                                            ) ;
                                            [% END %]
                                </li>
          [% END %]

				</ul>
		  </li>

            <li class="dropdown">
	            <a href="#" class="dropdown-toggle" data-toggle="dropdown">[% 'Circulaci&oacute;n' | i18n %] <b class="caret"></b></a>
	      [% IF socio_data.usr_credential_type == "librarian" OR  socio_data.usr_credential_type == "superLibrarian" %]
	            <ul class="dropdown-menu">
                    <li>
	                    [% IF (!menu_preferences.showMenuItem_circ_prestamos) AND (!menu_preferences.showMenuItem_circ_devolucion_renovacion) %]
	                              [% PERL %]
	                                  print C4::AR::Filtros::link_to( text =>     "[% 'Circulaci&oacute;n R&aacute;pida' | i18n %]",
	                                                                  url =>      "[% url_prefix %]/circ/circulacionRapida.pl",
	                                                                  title =>    "[% 'Circulaci&oacute;n R&aacute;pida' | i18n %]"
	                                                              ) ;
	                              [% END %]
	                    [% ELSE %]
	                            [% PERL %]
	                                  print C4::AR::Filtros::link_to( text =>     "[% 'Pr&eacute;st., Devol., y Renov.' | i18n %]",
	                                                                  url =>      "[% url_prefix %]/circ/circulacionRapida.pl",
	                                                                  title =>    "[% 'Pr&eacute;stamos, Devoluciones y Renovaciones' | i18n %]"
	                                                              ) ;
	                              [% END %]
	
	                    [% END %]
                    </li>
                    [% IF menu_preferences.showMenuItem_circ_prestamos %]
                                <li>
                                          [% PERL %]
                                              print C4::AR::Filtros::link_to( text =>     "[% 'Pr&eacute;stamos' | i18n %]",
                                                                              url =>      "[% url_prefix %]/circ/prestamos.pl",
                                                                              title =>    "[% 'Pr&eacute;stamos' | i18n %]"
                                                                          ) ;
                                          [% END %]
                                </li>
                    [% END %]
                    [% IF menu_preferences.showMenuItem_circ_devolucion_renovacion %]
                                <li>
                                          [% PERL %]
                                              print C4::AR::Filtros::link_to( text =>     "[% 'Devol. y Renov.' | i18n %]",
                                                                              url =>      "[% url_prefix %]/circ/devoluciones.pl",
                                                                              title =>    "[% 'Devol. y Renov.' | i18n %]"
                                                                          ) ;
                                          [% END %]
                                </li>
                    [% END %]
                    <li>
                              [% PERL %]
                                  print C4::AR::Filtros::link_to( text =>     "[% 'Sanciones' | i18n %]",
                                                                  url =>      "[% url_prefix %]/circ/sanciones.pl",
                                                                  title =>    "[% 'Sanciones' | i18n %]"
                                                              ) ;
                              [% END %]
                    </li>
                    <li>
                              [% PERL %]
                                  print C4::AR::Filtros::link_to( text =>     "[% 'Reservas' | i18n %]",
                                                                  url =>      "[% url_prefix %]/circ/reservas_activas.pl",
                                                                  title =>    "[% 'Reservas' | i18n %]"
                                                              ) ;
                              [% END %]
                    </li>
                [% IF socio_data.usr_credential_type == "superLibrarian" %]
                            <li class="nav-header">[% 'Preferencias' | i18n %]</li>	
	              			<li class="divider"></li>
                    
                                <li>
                                            [% PERL %]
                                                print C4::AR::Filtros::link_to( text  => "<i class='icon-cog'></i> [% 'Preferencias' | i18n %]",
                                                                                url   => "[% url_prefix %]/admin/global/circ_config.pl",
                                                                                title => "[% 'Preferencias' | i18n %]"
                                                                            ) ;
                                            [% END %]
                                </li>
                                <li>
                                            [% PERL %]
                                                print C4::AR::Filtros::link_to( text =>     "<i class='icon-cog'></i> [% 'Esquemas de Sanciones' | i18n %]",
                                                                                url =>      "[% url_prefix %]/admin/circulacion/sanciones.pl",
                                                                                title =>    "[% 'Esquemas de Sanciones' | i18n %]"
                                                                            ) ;
                                            [% END %]
                                </li>
                                <li>
                                            [% PERL %]
                                                print C4::AR::Filtros::link_to( text =>     " [% 'Tipos de pr&eacute;stamo' | i18n %]",
                                                                                url =>      "[% url_prefix %]/admin/circulacion/tipos_de_prestamos.pl",
                                                                                icon => "icon-cog",
                                                                                title =>    " [% 'Tipos de pr&eacute;stamo' | i18n %]"
                                                                            ) ;
                                            [% END %]
                                </li>
              [% END %]
				</li>
        
			      [% IF socio_data.usr_credential_type == "librarian" OR  socio_data.usr_credential_type == "superLibrarian" %]
      <li class="divider">
		                                <li>
		                                            [% PERL %]
		                                                print C4::AR::Filtros::link_to( text =>     "<i class='icon-print'></i> [% 'Reportes' | i18n %]",
		                                                                                url =>      "[% url_prefix %]/reports/circulacion.pl",
		                                                                                title =>    "[% 'Reportes' | i18n %]"
		                                                                            ) ;
		                                            [% END %]
		                            </li>
				 [% END %]
				</ul>
      [% END %]

		  </li>
      </ul>
          <form class="navbar-search pull-left" action="" onsubmit="return false;">
          
		    <input type="text" id="keyword-bar" class="search-query span2" name="keyword-bar" placeholder='[% "Cat&aacute;logo" | i18n %]'>

		    <input type="text" id="socio-bar" class="search-query span2" name="socio-bar" placeholder='[% "Usuarios" | i18n %]' onkeypress="socioSearchEvent(event)">
            
          </form>

      [% IF socio_data.usr_credential_type == "superLibrarian" %]
          <ul class="nav">
            <li class="dropdown">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown">[% 'Sistema' | i18n %] <b class="caret"></b></a>
              <ul class="dropdown-menu">
                      <li class="nav-header">[% 'Intranet' | i18n %]</li>	
	              			<li class="divider"></li>
              
                          <li>
                                      [% PERL %]
                                          print C4::AR::Filtros::link_to( text =>     "<i class='icon-cog'></i> [% 'Preferencias' | i18n %]",
                                                                          url =>      "[% url_prefix %]/admin/global/preferencias.pl",
                                                                          title =>    "[% 'Preferencias' | i18n %]"
                                                                      ) ;
                                      [% END %]
                          </li>
<!--                           <li>
                                      [% PERL %]
                                          print C4::AR::Filtros::link_to( text =>     "<i class='icon-cog'></i> [% 'Configuraci&oacute;n de Estilos' | i18n %]",
                                                                          url =>      "[% url_prefix %]/admin/global/estilos_config.pl",
                                                                          title =>    "[% 'Configuraci&oacute;n de Estilos' | i18n %]"
                                                                      ) ;
                                      [% END %]
                          </li>
 -->                          <li>
                                      [% PERL %]
                                          print C4::AR::Filtros::link_to( text =>     "<i class='icon-flag'></i> [% 'Feriados' | i18n %]",
                                                                          url =>      "[% url_prefix %]/admin/feriados.pl",
                                                                          title =>    "[% 'Feriados' | i18n %]"
                                                                      ) ;
                                      [% END %]
                          </li>
                          <li>
                                    [% PERL %]
                                        print C4::AR::Filtros::link_to( text =>     "<i class='icon-info-sign'></i> [% 'Novedades' | i18n %]",
                                                                        url =>      "[% url_prefix %]/admin/global/novedades_intra.pl",
                                                                        title =>    "[% 'Novedades' | i18n %]"
                                                                    ) ;
                                    [% END %]
                          </li>
                          <li>
                                       [% PERL %]
                                           print C4::AR::Filtros::link_to( text =>     "<i class='icon-info-sign'></i> [% 'Acerca De...' | i18n %]",
                                                                           url =>      "[% url_prefix %]/about/about.pl",
                                                                           title =>    "[% 'Acerca De...' | i18n %]"
                                                                       ) ;
                                       [% END %]
                          </li>
                          <li>
                                  [% PERL %]
                                      print C4::AR::Filtros::link_to( text =>     " [% 'Logos' | i18n %]",
                                                                      url =>      "[% url_prefix %]/admin/logos.pl",
                                                                      icon=>		"icon-picture",
                                                                      title =>    "[% 'Logos' | i18n %]"
                                                                  ) ;
                                  [% END %]
                          </li>
                      <li class="nav-header">[% 'OPAC' | i18n %]</li>	
	              			<li class="divider"></li>
                                <li>
                                          [% PERL %]
                                              print C4::AR::Filtros::link_to( text =>     "<i class='icon-info-sign'></i> [% 'Novedades' | i18n %]",
                                                                              url =>      "[% url_prefix %]/admin/novedades_opac.pl",
                                                                              title =>    "[% 'Novedades' | i18n %]"
                                                                          ) ;
                                          [% END %]
                                </li>
                                <li>
                                        [% PERL %]
                                            print C4::AR::Filtros::link_to( text =>     "<i class='icon-comment'></i> [% 'Mensajes de Contacto' | i18n %]",
                                                                            url =>      "[% url_prefix %]/admin/mensajes_contacto.pl",
                                                                            title =>    "[% 'Mensajes de Contacto' | i18n %]"
                                                                        ) ;
                                        [% END %]
                                </li>
                                <li>
                                        [% PERL %]
                                            print C4::AR::Filtros::link_to( text =>     " [% 'Configuraci&oacute;n de la portada' | i18n %]",
                                                                            url =>      "[% url_prefix %]/admin/portada_opac.pl",
                                                                            icon=>		"icon-picture",
                                                                            title =>    "[% 'Configuraci&oacute;n de la portada' | i18n %]"
                                                                        ) ;
                                        [% END %]
                                </li>
                                [% IF socio_data.object.esAdmin || socio_data.usr_credential_type == "superLibrarian" %]
	                            	<li class="nav-header">[% 'Administraci&oacute;n' | i18n %]</li>	
		              				<li class="divider"></li>
                                <li>
                                            [% PERL %]
                                                print C4::AR::Filtros::link_to( text =>     "<i class='icon-ok'></i> [% 'Tablas de referencia' | i18n %]",
                                                                                url =>      "[% url_prefix %]/admin/referencias/referencias.pl",
                                                                                title =>    "[% 'Tablas de referencia' | i18n %]"
                                                                            ) ;
                                            [% END %]
                                </li>
 	                            	<li>
	                                            [% PERL %]
	                                                print C4::AR::Filtros::link_to( text =>     "<i class='icon-lock'></i> [% 'M&eacute;todos de Autenticaci&oacute;n' | i18n %]",
	                                                                                url =>      "[% url_prefix %]/admin/global/auth_methods.pl",
	                                                                                title =>    "[% 'M&eacute;todos de Autenticaci&oacute;n' | i18n %]"
	                                                                            ) ;
	                                            [% END %]
	                                </li>
                                  <li>
	                                            [% PERL %]
	                                                print C4::AR::Filtros::link_to( text =>     "<i class='icon-envelope'></i> [% 'Configuraci&oacute;n del Mail' | i18n %]",
	                                                                                url =>      "[% url_prefix %]/admin/global/mail_config.pl",
	                                                                                title =>    "[% 'Configuraci&oacute;n del Mail' | i18n %]"
	                                                                            ) ;
	                                            [% END %]
	                                </li>
	                                                            
	                                <li>
	                                            [% PERL %]
	                                                print C4::AR::Filtros::link_to( text =>     "<i class='icon-cog'></i> [% 'Configuraci&oacute;n LDAP' | i18n %]",
	                                                                                url =>      "[% url_prefix %]/admin/global/ldap_config.pl",
	                                                                                title =>    "[% 'Configuraci&oacute;n LDAP' | i18n %]"
	                                                                            ) ;
	                                            [% END %]
	                                </li>
                                  <li>
                                              [% PERL %]
                                                  print C4::AR::Filtros::link_to( text =>     "<i class='icon-list-alt'></i> [% 'Servidores externos' | i18n %]",
                                                                                  url =>      "[% url_prefix %]/admin/global/sys_externos_meran.pl",
                                                                                  title =>    "[% 'Servidores externos' | i18n %]"
                                                                              ) ;
                                              [% END %]
                                  </li>
                                  <li>
                                              [% PERL %]
                                                  print C4::AR::Filtros::link_to( text =>     "<i class='icon-print'></i> [% 'Reporte Anual' | i18n %]",
                                                                                  url =>      "[% url_prefix %]/admin/estadisticas.pl",
                                                                                  title =>    "[% 'Reporte Anual' | i18n %]"
                                                                              ) ;
                                              [% END %]
                                  </li>
              					[% END %]
                        [% IF menu_preferences.showMenuItem_herramientas %]
	                            	<li class="nav-header">[% 'Herramientas' | i18n %]</li>	
		              				      <li class="divider"></li>
                                <li>
                                            [% PERL %]
                                                print C4::AR::Filtros::link_to( text =>     "<i class='icon-upload'></i> [% 'Exportaci&oacute;n' | i18n %]",
                                                                                url =>      "[% url_prefix %]/herramientas/exportacion/exportar.pl",
                                                                                title =>    "[% 'Exportaci&oacute;n' | i18n %]"
                                                                            ) ;
                                            [% END %]
                                </li>
                                        <li>
                                                    [% PERL %]
                                                        print C4::AR::Filtros::link_to( text =>     "<i class='icon-download'></i> [% 'Importaci&oacute;n' | i18n %]",
                                                                                        url =>      "[% url_prefix %]/herramientas/importacion/importar.pl",
                                                                                        title =>    "[% 'Importaci&oacute;n' | i18n %]"
                                                                                    ) ;
                                                    [% END %]
                                        </li>


              					[% END %]
                   </ul>
               </li>
          </ul>

      [% END %]
	           <ul class="nav pull-right">
	            <li class="divider-vertical"></li>
	            <li class="dropdown">
	              <a href="#" class="dropdown-toggle" data-toggle="dropdown">
		              <i class="icon-white icon-user" title="[% socio_data.usr_nro_socio %]"></i>
		              <b class="caret"></b>
				  </a>
	              <ul class="dropdown-menu">
			          <li>
			                    [% PERL %]
			                       print C4::AR::Filtros::link_to( text =>     " [% 'Mis datos' | i18n %]",
			                                                   url=>"[% url_prefix %]/usuarios/reales/datosUsuario.pl", 
			                                                   title =>    "[% 'Mis datos' | i18n %]",
			                                                   params =>   ["nro_socio=[% socio_data.usr_nro_socio %]"],
			                                                   icon => "icon-user",
			                                                   tooltip => "['Ver y/o modificar sus datos' | i18n ]"
			                           );
			                   [% END %]
			          </li>
	                
	                <li>
	                	<a href="[% url_prefix %]/usuarios/reales/settings.pl?token=[% token %]&amp;nro_socio=[% socio_data.usr_nro_socio %]">
	                		<i class="icon-cog"></i> [% "Ajustes" | i18n %]
	                	</a>
	                </li>
	
	                <li class="divider"></li>
	                <li><a href="[% url_prefix %]/logout.pl?token=[% token %]"><i class="icon-off"></i> [% "Salir" | i18n %]</a></li>
	              </ul>
	            </li>
	         </ul>         
        </div><!-- /.nav-collapse -->
      </div>
    </div><!-- /navbar-inner -->
   
  </div>
