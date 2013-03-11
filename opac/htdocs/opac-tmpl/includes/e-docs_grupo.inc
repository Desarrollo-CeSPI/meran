[% USE HTML %]

[% IF pref_e_documents %]
	[% IF cant_docs > 0 %]
	            <div class="alert ">
		            <h4>[% "La edici&oacute;n contiene los siguientes documentos electr&oacute;nicos para descargar" | i18n %]:</h4>		    
		            <div id="lista_docs_[% id2 %]" class="">
				        <dl>
				               [% FOREACH file IN lista_docs %] 
									<dt>
				                           [% PERL %]
				                               print C4::AR::Filtros::link_to( text =>     " [% HTML.escape(file.getTitle) %]",
				                                                               url =>      "getDocument.pl", 
				                                                               params =>   ["id=[% file.getId %]"],
				                                                               title =>    "[% HTML.escape(file.getTitle) %]",
				                                                               icon => "icon-file",
				                                                           ) ;
				                           [% END %]
		                           </dt>
				            [% END %]
				        </dl>
				    </div>
				</div>
	[% END %]	
[% END %]   
		
