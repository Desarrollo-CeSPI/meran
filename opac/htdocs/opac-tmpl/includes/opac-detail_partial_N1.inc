<dl>
    [% FOREACH nivel1 %]
            [% IF liblibrarian %]
                [% IF dato %]
                <dt class="inline left rightMargin">[% liblibrarian %]:</dt><dd>[% dato %]</dd>
                [% END %]
            [% END %]
    [% END %]
    [% IF cat_ref_tipo_nivel3 == "ANA" %]
    	[% FOREACH nivel2 %]
			[% IF cant_nivel3 == 0 %]
		    <!-- ANA y ELE  no tienen nivel3 -->
		    <!-- si es ELE no muestro nada -->
		        [% IF (cat_ref_tipo_nivel3 == 'ANA') %]        
				    <dt class="inline left rightMargin">Articulo de:&nbsp; </dt> 
		            <dd>
		            	[% PERL %]
                            print C4::AR::Filtros::link_to(
                            	text =>   
                            			"[% IF HTML.escape(titulo_registro_padre) %]
                                            [% HTML.escape( titulo_registro_padre) %]
                                           [% ELSE %]
                                           SIN T&Iacute;TULO
                                           [% END %]
                                           [% IF HTML.escape(autor_registro_padre) %]
                                            / [% HTML.escape(autor_registro_padre) %]
                                           [% END %]
                                           [% IF HTML.escape(detalle_grupo_registro_padre) %]
                                            / [% HTML.escape(detalle_grupo_registro_padre) %]
                                           [% END %]
                                           [% IF HTML.escape(tipo_documento_padre) %]
                                            ([% HTML.escape(tipo_documento_padre) %])
                                           [% END %]
                                           ",
                                url 		=>   "[% url_prefix %]/opac-detail.pl", 
                                params 		=>   ["id1=[%  nivel1_padre %]","id2=[%  nivel2_padre %]"],
                                title 		=>    "[% 'Mostrar Detalle del registro' | i18n %]",
                            ) ;
                        [% END %]
		            </dd>	
		             
		        [% END %]
		        
		    [% ELSE %]
		    
			    <div class="alert fade in">
		           <strong>[% 'Este grupo no dispone de ejemplares' | i18n %]</strong>
			    </div> 
		 
		    [% END %]


    	[% END %]
    [% END %]
</dl>
