<script type="text/javascript">
    ORDEN ="[% orden %]";
    SENTIDO_ORDEN ="[% sentido_orden %]";
    PRIMERA_VEZ = "[% primera_vez %]";

    function cambiarSentidoOrd(){
      if (SENTIDO_ORDEN){
        $('#icon_'+ ORDEN).attr("class","icon-chevron-up click");
      } else {
        $('#icon_'+ ORDEN).attr("class","icon-chevron-down click");
      }
    }


    function submitForm(form_id) {
        $('#' + form_id).submit();
    }

    [% IF external_search %]
    	[% IF cant_external_servers %]
		    var servidores 	= new Array();
		    var server_name	= {};
			var SERVER = "";   
			var numPag = 1;
			var SEARCH = "";
			var results = false;
			
			[% FOREACH server IN external_servers %] 
				servidores.push("[% server.url %]");
				server_name["[% server.url %]"] = "[% server.ui.getNombre %]";
			[% END %]
		
		
			function nextPage(){
				numPag++;
				doExternalSearches(SEARCH);
			}		
		
			function prevPage(){
				if (numPag > 1)
					numPag--;
				doExternalSearches(SEARCH);
			}		
		
			function doExternalSearches(keyword){
				
				$('.popover_button').popover('hide');
				$('#principal').html("");
				startOverlay();
				SEARCH = keyword;
				
				try{
					Concurrent.Thread.create(function(){
						results = false;
						for (x=0; x<servidores.length ;x++){
							externalSearch(SEARCH,servidores[x],server_name[servidores[x]]);
							$('#principal').append("<br />");
							$('#principal').append("<br />");
						} 
						closeModal();
						if (results){
							$('#principal').append("<br />");
						}else{
							$('#principal').append("[% ' LOS SERVIDORES EXTERNOS NO DISPONEN DE MAS RESULTADOS SEGUN SU CRITERIO ' %]");
						}
					});
				}
				catch(e){}
			}
		
		 
		    function externalSearch(keyword,URL,server_name){
		
		  	    objAH                   = new AjaxHelper(updateExternalSearch);
		  	    objAH.debug             = true;
		  	    //para busquedas combinables
		  	    objAH.url               = URL;
		  	    objAH.async				      = false;
		  	    objAH.keyword           = keyword;
		  	    SERVER = server_name;
		  	    //se setea la funcion para cambiar de pagina
		  	    objAH.ini          	 	= numPag;
		  	    //se envia la consulta
		  	    objAH.sendToServer();
		    }
		
		    function updateExternalSearch(responseText){
		
		        var table 	= "";
		        var cant_dc	= 0;
		    	var templates = {
		    	    tr : '<tr>#{row}</tr>',
		    	    th : '<th>#{header}</th>',
		    	    td : '<td>#{cell}</td>'
		    	};

		    	table  = '<fieldset><legend class="server_name">'+SERVER+'</legend></fieldset><table class="table table-striped"><thead>';
				table += '<tr>';
		        table += '<th>[% "T&iacute;tulo" | i18n %]</th>'; 
		        table += '<th>[% "Autor" | i18n %]';
		
				table += '</tr></thead><tbody>';
		         
		        $(responseText).find('rdf\\:Description').each(function() {
		            cant_dc++;
		            
		            var marker = $(this);
		            var title       = marker.find("dc\\:title").text();
		            var creator     = marker.find("dc\\:creator").text();
		            var subject     = marker.find("dc\\:subject").text();
		            var description = marker.find("dc\\:description").text();
		            var publisher   = marker.find("dc\\:publisher").text();
		            var contributor = marker.find("dc\\:contributor").text();
		            var date        = marker.find("dc\\:date").text();
		            var type        = marker.find("dc\\:type").text();
		            var format      = marker.find("dc\\:format").text();
		            var identifier  = marker.find("dc\\:identifier").text();
		            var source      = marker.find("dc\\:source").text();
		            var language    = marker.find("dc\\:language").text();
		            var relation    = marker.find("dc\\:relation").text();
		            var coverage    = marker.find("dc\\:coverage").text();
		            var rights      = marker.find("dc\\:rights").text();
		            var url			= "<a href="+marker.attr('rdf:about')+" target='_blank'>"+title+"</a>";
		            
		            var DC_hash     = {
		            		title: title,
		            		creator: creator,
		            		subject: subject,
		            		description: description,
		            		publisher: publisher,
		            		contributor: contributor,
		            		date: date,
		            		type: type,
		            		format: format,
		            		identifier: identifier,
		            		source: source,
		            		language: language,
		            		relation: relation,
		            		coverage: coverage,
		            		rights: rights,
		            		link: url
		            }
		            table += '<tr>';
		    	    table += $.tmpl(templates.td, {cell: DC_hash.link});
		    	    table += $.tmpl(templates.td, {cell: DC_hash.creator});
		            table += '</tr>';
		        });
		
				table += '</tbody></table>';
				if (cant_dc > 0){
					$('#principal').append(table);
					results = true;

					var previous 	= '<li class="previous"><a href="#" onclick="prevPage();">&larr; [% "Anterior" | i18n %]</a></li>';
					var next 		= '<li class="next"><a href="#" onclick="nextPage();">[% "Siguiente" | i18n %] &rarr;</a></li>';
					var ul_open 	= '<div class="" style="width: 300px; margin: 0 auto;"><ul class="pager">';
					var ul_close	= '</ul></div>';
					var html		= ""+ul_open;
					
					if (numPag > 1){
						html += previous;
					}
					html += next+ul_close;
					
					$('#principal').append(html);
					
				}
				
				return (table);
		    }
          [% END %]
       [% END %]	

      function ordenar_busqueda_opac(orden){
        if (PRIMERA_VEZ == "2"){
             SENTIDO_ORDEN= 0;
             PRIMERA_VEZ="1";
       } else {
            if (orden == ORDEN) {
                    if (SENTIDO_ORDEN == 1){
                        SENTIDO_ORDEN= 0;
                    } else{
                        SENTIDO_ORDEN= 1;
                    }
            }  else {
                      SENTIDO_ORDEN= 0;
                      ORDEN = orden;
            }
        }
      
        $('#orden').val(ORDEN);
        $('#sentido_orden').val(SENTIDO_ORDEN);
        $('#primera_vez').val(PRIMERA_VEZ);

        cambiarSentidoOrd();
        $('#ordenar_tabla').submit();

    }   


	function generarPDF(form_id) {
		$('#export').val("1");
        $('#' + form_id).submit();
    }

    $(document).ready(function() {
        $('.fancylink').fancybox();
    });
</script>

[% USE HTML %]
	        	<div>
		        	[% IF external_search  %]
					          [% IF cant_external_servers %]
						          <div class="right" style="margin-top: 10px">
        									[% PERL %]
        										print C4::AR::Filtros::action_button( 
        											button        => "btn btn-success",
        											action       	=> 'doExternalSearches("[% buscoPor | html %]")', 
        											icon         	=> "icon-white icon-search ",
        											title        	=> "[% 'Externos' | i18n %]",
        											popover => { 
        												title   =>'[% "Atenci&oacute;n" | i18n %]',
        												text    => '[% "Buscar en servidores externos hace la misma b&uacute;squeda 
        																en cat&aacute;logos ajenos a esta biblioteca. 
        																Tenga en cuenta que puede llevar un tiempo considerable." | i18n %]',
        												placement => "left",
        											},
        											
        										) ;
        									[% END %]
								      </div>
				          	[% END %]
			          [% END %]
			          
            		<div class="page-header" style="border-bottom: none; padding-bottom: 0px;">
            			<h3>
		            		[% IF buscoPor %]
		            			[% buscoPor %]
		            		[% END %]
	            			<small>[% 'Se han encontrado' | i18n %] [% cantidad %] [% 'resultados' | i18n %]</small>
            			</h3>
            		</div>
            		
            		
			    </div>


[% IF show_search_details %]
          [% IF only_available %]
                <div class="alert alert-info"> [% 'Solo se muestran ejemplares disponibles.' | i18n %] <a href="[% url_todos %]">([% ' Mostrar todos' | i18n %])</a></div>
          [% END %]

[% END %]

[% IF (cantidad > 0) || ( (!from_suggested) && (suggested) )%]
    
      [% FOREACH NIVEL IN SEARCH_RESULTS %]
                <script type="text/javascript">
                </script>
      [% END %]

    [% IF !from_suggested %]
            
            [% IF suggested %]
                    <div class="suggested_search">
                        <a href="[% url_prefix %]/opac-busquedasDB.pl?string=[% suggested | html %]&tipoAccion=[% tipoAccion | html %]&from_suggested=1&only_available=[% only_available | html %]&token=[% token | html %]">
                            [% "Usted quiso decir" | i18n %] <span style="font-style: italic">[% suggested %]</span>?
                        </a>
                    </div>
            [% END %]
    
    [% END %]
    
    [% IF cantidad > 0 %]
             [% PERL %]
                 print C4::AR::Filtros::sortableTableHeader(   
                                                         id             => "tablaResult",
                                                         class          => "table table-bordered",
                                                         columns        => ['[% "Tipo"|i18n %]','[% "T&iacute;tulo"|i18n %]','[% "Autor"|i18n %]',
                                                                             '[% "Edici&oacute;n"|i18n %]','[% "Disponibilidad"|i18n %]', '[% "Valoraci&oacute;n" | i18n %]',
                                                                             [% IF socio_data.usr_permisos_opac %]'[% "Favoritos" | i18n %]'[% END %]
                                                                            ],
                                                          sortable_fields  => {  'Tipo' => '',
                                                                               'T&iacute;tulo' =>'titulo', 
                                                                               'Autor' => 'autor',
                                                                               'Edici&oacute;n' => '',
                                                                               'Disponibilidad' =>'',
                                                                               'Valoracion' =>'',
                                                                      
                                                                             },
                                                          order => "[% orden %]",
                                                          order_direction => "[% sentido_orden %]",
                                                          order_name_function => "busqueda_opac"
                                                         
                             ) ;

 

             [% END %]
             <tbody>  
                [% FOREACH NIVEL IN SEARCH_RESULTS %]
                    <tr>


                     <td style="width: 60px;">
                      [% IF NIVEL.portadas_perzonalizadas_cant > 0 %]
                             [% FOREACH portadas IN NIVEL.portadas_perzonalizadas %]
                               [% FOREACH portada IN portadas %]
                                [% IF loop.count < 4 %]
                                  [% FOREACH p IN portada.value %]
                                    <a class="fancylink" rel="group_[% grupo %]" href="/uploads/covers-added/[% p.image_name %]">
                                      <img class="cover_result" alt="coverllll" src="/uploads/covers-added/[% p.image_name %]" title="Portada" />
                                   </a>
                                [% END %]
                               [% END %]
                              [% END %]
                            [% END %]
                      [% ELSIF NIVEL.portadas_grupo_cant > 0 %]
                             [% FOREACH portada IN NIVEL.portadas_grupo %]
                                 [% IF loop.count < 4 %]
                                     [% IF portada.portada_registro_big %]
                                         <a class="fancylink" rel="group_[% grupo %]" href="/uploads/covers/[% portada.portada_registro_big %]">
                                             <img alt="coverllll" src="/uploads/covers/[% portada.portada_registro %]" title="Portada" />
                                         </a>
                                     [% ELSE %]
                                       [% IF portada.portada_registro_medium %]
                                           <a class="fancylink" rel="group_[% grupo %]" href="/uploads/covers/[% portada.portada_registro_medium %]">
                                               <img alt="cover" src="/uploads/covers/[% portada.portada_registro %]" title="Portada" />
                                           </a>
                                       [% ELSE %]
                                               <img alt="cover" src="/uploads/covers/[% portada.portada_registro %]" title="Portada" />
                                       [% END %]
                                    [% END %]
                                  [% END %]
                              [% END %]
                       [% ELSE %]
                             <img src="/uploads/covers/[% NIVEL.cat_ref_tipo_nivel3 %].png" 
                                   alt="[% 'Sin Portada' | i18n %]"
                                   title="[% 'Sin Portada' | i18n %]" />
                       [% END %]
                         <br />
                         <center><div style="font-weight: bold; font-size: 10px; clear:both;" >[% NIVEL.cat_ref_tipo_nivel3_name %] </div></center>
                     </td>

                        <td>	
                            [% IF NIVEL.titulo %]
                                    [% PERL %]
                                        print C4::AR::Filtros::link_to( text 		  =>   '[% IF HTML.escape(NIVEL.titulo) %][% NIVEL.titulo %][% ELSE %]SIN T&Iacute;TULO[% END %]',
                                                                        url 		  =>   '[% url_prefix %]/opac-detail.pl', 
                                                                        params 		=>   ['id1=[% NIVEL.id1 %]'],
                                                                        title 		=>   '[% 'Mostrar Detalle del registro' | i18n %]',
    		                                                                on_click 	=>  'startOverlay();'
                                                                    ) ;
                                    [% END %]
                            [% ELSE %]
                                &nbsp;
                            [% END %]
                        </td>

                        <td>
                            [% IF NIVEL.nomCompleto %]
                                [% PERL %]
                                    print C4::AR::Filtros::link_to( text =>     '[% NIVEL.nomCompleto %]',
                                                                    url =>      '[% url_prefix %]/opac-busquedasDB.pl', 
                                                                    params =>   ['tipoAccion=BUSQUEDA_AVANZADA','autor=[% HTML.escape(NIVEL.nomCompleto) %]'],
                                                                    title =>    '[% 'Buscar de este autor' | i18n %]'
                                                                ) ;
                                [% END %]                                
                            [% ELSE %]
                                ----------
                            [% END %]
                        </td>

                        <td>
                        [% IF NIVEL.estadoDeColeccion %]
							            <span id="coleccion_[% NIVEL.id1 %]">
                            <ul class="listado_sin_margen estado_coleccion unstyled">
                            [% FOREACH anio IN NIVEL.estadoDeColeccion.keys.sort %]
                            [% IF NIVEL.estadoDeColeccion.$anio.keys %]
                            <li>
                                [% IF  (NIVEL.estadoDeColeccion.$anio.size > 1 || (NIVEL.estadoDeColeccion.$anio.keys.first && NIVEL.estadoDeColeccion.$anio.keys.first != '#'))||
                                (NIVEL.estadoDeColeccion.$anio.item('#').size > 1 || (NIVEL.estadoDeColeccion.$anio.item('#').keys.first && NIVEL.estadoDeColeccion.$anio.item('#').keys.first != '#')) 
                                       %]
                                   [% IF anio != '#' %] <b>[% anio %]</b>  [% END %]

                                  [% FOREACH volumen IN NIVEL.estadoDeColeccion.$anio.keys.sort %]
                                    
                                      [% IF  NIVEL.estadoDeColeccion.$anio.$volumen.keys.size > 1 || NIVEL.estadoDeColeccion.$anio.$volumen.keys.sort.first != '#' %]
                                       [% IF volumen != '#' %] <b>[% volumen %]</b>[% END %]
                                        (
                                          [% FOREACH fasciculo IN NIVEL.estadoDeColeccion.$anio.$volumen.keys.sort %]

                                              [% PERL %]
                                                print C4::AR::Filtros::link_to( text =>     "[% HTML.escape(fasciculo) %]",
                                                                url=>"[% url_prefix %]/opac-detail.pl", 
                                                                params =>   ["id1=[% NIVEL.id1 %]","id2=[% NIVEL.estadoDeColeccion.$anio.$volumen.$fasciculo %]#detalle_grupo_[% NIVEL.estadoDeColeccion.$anio.$volumen.$fasciculo %]"],
                                                                title =>    "[% 'Mostrar Detalle del Registro' | i18n %]",
                                                                class =>  "link_to_detail"
                                                              ) ;
                                               [% END %]

                                          [% END %]
                                         )
                                      [% ELSE %]
                                            [% PERL %]
                                                print C4::AR::Filtros::link_to( text =>     "[% HTML.escape(volumen) %]",
                                                                url=>"[% url_prefix %]/opac-detail.pl", 
                                                                params =>   ["id1=[% NIVEL.id1 %]","id2=[% NIVEL.estadoDeColeccion.$anio.$volumen.item('#') %]#detalle_grupo_[% NIVEL.estadoDeColeccion.$anio.$volumen.item('#') %]"],
                                                                title =>    "[% 'Mostrar Detalle del Registro' | i18n %]",
                                                                class =>  "link_to_detail"
                                                              ) ;
                                            [% END %]
                                      [% END %]

                                  [% END %]

                                [% ELSE %]
                                           [% PERL %]
                                                print C4::AR::Filtros::link_to( text =>     "[% HTML.escape(anio) %]",
                                                                url=>"[% url_prefix %]/opac-detail.pl", 
                                                                params =>   ["id1=[% NIVEL.id1 %]","id2=[% NIVEL.estadoDeColeccion.$anio.item('#').item('#') %]#detalle_grupo_[% NIVEL.estadoDeColeccion.$anio.item('#').item('#') %]"],
                                                                title =>    "[% 'Mostrar Detalle del Registro' | i18n %]",
                                                                class =>  "link_to_detail"
                                                              ) ;
                                            [% END %]
                                [% END %]
                            </li>
                            [% END %]
                            [% END %]
                            </ul>
                            </span>
    						  <script type="text/javascript">$("#coleccion_[% NIVEL.id1 %]").expander({
    							  slicePoint: 2000, 
    							  widow: 10,
    							  expandEffect: 'fadeIn', 
    							  expandText: '<i class="icon-arrow-down"></i>',
    							  userCollapseText: '<i class="icon-arrow-up"></i>',
                                  expandPrefix: '',
    							});
    						 </script>
						 
						[% ELSE %]
							[% IF NIVEL.grupos %]
								<span id="grupos_[% NIVEL.id1 %]" class="detalle_registro_edicion">
									[% FOREACH NIVEL.grupos %]
										[% IF edicion %]
											[% edicion %] &nbsp;
										[% END %]
										[% IF loop.prev.anio_publicacion != anio_publicacion %]
											[% IF anio_publicacion %]
												([% anio_publicacion %])<br/>
											[% END %]
										[% END %]
											
									[% END %]
								</span>
						  <script type="text/javascript">$("#grupos_[% NIVEL.id1 %]").expander({
							  slicePoint: 2000, 
							  widow: 10,
							  expandEffect: 'fadeIn', 
							  expandText: '<i class="icon-arrow-down"></i>',
							  userCollapseText: '<i class="icon-arrow-up"></i>',
                              expandPrefix: '',
							});
						 </script>
							[% END %]
						[% END %]
   


   	  					[% IF NIVEL.cat_ref_tipo_nivel3 == "ANA" %]
   	  						 [% IF NIVEL.titulo_registro_padre %]
                      EN: <br>
                      [% PERL %]
                          print C4::AR::Filtros::link_to( 
                              text 		=> 
                              "[% IF HTML.escape(NIVEL.titulo_registro_padre) %]
                                [% HTML.escape( NIVEL.titulo_registro_padre) %]
                               [% ELSE %]
                               SIN T&Iacute;TULO
                               [% END %]
                               [% IF HTML.escape(NIVEL.autor_registro_padre) %]
                                / [% HTML.escape(NIVEL.autor_registro_padre) %]
                               [% END %]
                               [% IF HTML.escape(NIVEL.detalle_grupo_registro_padre) %]
                                 <br>[% HTML.escape(NIVEL.detalle_grupo_registro_padre) %]
                               [% END %]
                               [% IF HTML.escape(NIVEL.tipo_documento_padre) %]
                                 <br>([% HTML.escape(NIVEL.tipo_documento_padre) %])
                               [% END %]",
                              url 		=>   "[% url_prefix %]/opac-detail.pl", 
                              params 		=>   ["id1=[% NIVEL.nivel1_padre %]","id2=[% NIVEL.nivel2_padre %]"],
                              title 		=>    "[% 'Mostrar Detalle del registro' | i18n %]", on_click 	=> "startOverlay();"
                          ) ;
                      [% END %]
                    [% END %]
                [% END %]

                        </td>

                        <td>
                            [% IF NIVEL.disponibilidad %]
                                [% FOREACH NIVEL.disponibilidad %]
                                	[% flag = 0 %]
                                    [% IF cantTotal %]
                                        [% IF flag %]
                                    		[% 'Disponible para ' | i18n %]&nbsp;
                                			[% flag = 1 %]
                                    	[% END %]
                                    	<span class="label [% IF domicilio %] label-success [% END %]">[% tipoPrestamo %]</span>
                                        <br /><br />
                                    [% END %]
                                [% END %]
                            [% END %]
                        </td>
                        <td class="span2">
                            [% IF NIVEL.rating > 0 %]
								<div class="rating_div" id="rating_[% NIVEL.id1 %]" data-rating="[% NIVEL.rating %]"></div>
	                         [% ELSE %]
	                           [% '----------' %]
	                         [% END %]
                        </td>
                        [% IF socio_data.usr_permisos_opac %]
                        <td id="fav_[% NIVEL.id1 %]">
                            [% IF NIVEL.esta_en_favoritos %]
			                    [% PERL %]
			                      print C4::AR::Filtros::action_button( 
			                                                      button    => "btn btn-inverse click",
			                                                      action    =>  'deleteFavorite([% NIVEL.id1 %],"fav_[% NIVEL.id1 %]",1);',
			                                                      icon      => "icon-minus icon-white",
			                                                      disabled	=> 1,
			                                                  ) ;
			
			                    [% END %]
                            [% ELSE %]
			                    [% PERL %]
			                      print C4::AR::Filtros::action_button( 
			                                                      button    => "btn btn-primary click",
			                                                      action    => 'addFavorite([% NIVEL.id1 %],"fav_[% NIVEL.id1 %]");',
			                                                      id		=> "button_[% id1 %]",
			                                                      icon      => "icon-heart icon-white",
			                                                  ) ;
			
			                    [% END %]
                            [% END %]
                        </td>
	                     [% END %]
                    </tr>
        			<script>
						$('#rating_[% NIVEL.id1 %]').raty({
							  readOnly : true,
							  half  : true,
							  score    : [% NIVEL.rating %],
						});
					</script>

                [% END %]
             </tbody>
        </table>
        <div class="contenedor_paginador">[% paginador %]</div>
     <div id="datos_busqueda">
          <form id="ordenar_tabla" action="[% url_prefix %]/opac-busquedasDB.pl" method="get">
                <input type="hidden" id="string" name="string" value="[% keyword %]"/>
                <input type="hidden" id="titulo" name="titulo" value="[% titulo %]"/>
                <input type="hidden" id="autor" name="autor" value="[% autor %]"/>
                <input type="hidden" id="isbn" name="isbn" value="[% isbn %]"/>
                <input type="hidden" id="tipo" name="tipo" value="[% tipo %]"/>
                <input type="hidden" id="tema" name="tema" value="[% tema %]"/>
                <input type="hidden" id="estante" name="estante" value="[% estante %]"/>
                <input type="hidden" id="tipoAccion" name="tipoAccion" value="[% tipoAccion %]" />
                <input type="hidden" id="token" name="token" value="[% token %]" />
                <input type="hidden" id="orden" name="orden" value="" />
                <input type="hidden" id="export" name="export" value="" />
                <input type="hidden" id="sentido_orden" name="sentido_orden" value="" />
                <input type="hidden" id="primera_vez" name="primera_vez" value="" />
        </form>
    </div>        
         <div class="form-actions" id="actions_ejemplares" style="margin-bottom: 0;">
               <td>
                  [% PERL %]
                      	print C4::AR::Filtros::action_set_button(    
                            button          => 'btn btn-primary',
                            title => " [% 'Guardar B&uacute;squeda' | i18n %]",
                            action => 'generarPDF("ordenar_tabla")',
                            icon => "icon-white icon-inbox",
                                          
  
                              ) ;
                  [% END %]
               </td>
	         </div>       
  	[% END %]
  [% ELSE %]
    [% IF cantidad > 0%]
	    [% IF no_content_message %]
	        <div class="alert alert-info"> [% no_content_message %] </div>  
	    [% ELSE %]
	        <div class="alert alert-info"> [% 'Nada que mostrar.' | i18n %] </div>
	    [% END %]
	    	<br />
    [% END %]

		<div class="page-header">
		    <h1>Meran <small>[% 'Repetir la b&uacute;squeda con otros criterios' | i18n %]</small></h1>
		</div> 
    
    [% INCLUDE 'opac-advanced_search.inc' %]
[% END %]
