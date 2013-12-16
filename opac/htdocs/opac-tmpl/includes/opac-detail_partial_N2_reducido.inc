[% USE HTML %]
<script type="text/javascript">
    $(document).ready(function() {
        $('.fancylink').fancybox();
    });
</script>

[% FOREACH nivel2 %]
    [% IF nivel2_array %]
        <section class="detalle_grupo" id="detalle_grupo_[% id2 %]">
                <div class="page-header">
                    <h1>[% nivel1_obj.getTitulo %] <small> [% edicion %]</small></h1>
                    <h3>[% nivel1_obj.getAutor %] </h3> 
                </div>                          
                <div class="well">
                   [% IF isbn %]
                      <div class="right">
                          <a id="ISBN:[% isbn %]"  style="display:none" target="_blank">
                              <img src="/includes/css/gbs_preview_button1.gif" border="0" style="margin: 0"/>
                          </a>
                      </div>
                      <script src="http://books.google.com/books?jscmd=viewapi&bibkeys=ISBN:[% isbn %]&callback=ProcessGBSBookInfo"></script>
                   [% END %]
                    <div class="right" style="width: 150px; margin-bottom: 20px;">
                        <!-- AddThis Button BEGIN -->
                        <div class="addthis_toolbox addthis_default_style ">
                        <a class="addthis_button_preferred_1"></a>
                        <a class="addthis_button_preferred_2"></a>
                        <a class="addthis_button_preferred_3"></a>
                        <a class="addthis_button_preferred_4"></a>
                        <a class="addthis_button_compact"></a>
                        <a class="addthis_counter addthis_bubble_style"></a>
                        </div>
                        <script type="text/javascript">var addthis_config = {"data_track_addressbar":true};</script>
                        <script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#pubid=ra-4fc3cfd82e6bcc52"></script>
                        <!-- AddThis Button END -->
                    </div>
                    
                             
                       <div class="detalle_total">                            
                                <div class="">
                                [% IF portada_edicion_local %]

                                    [% FOREACH p IN portada_edicion_local %]
                                        <div class="item portadaEdicionImage" [% IF !loop.first %]style="display:none;"[% END %]>
                                            <a class="fancylink" id="imagen_[% p.getImageName %]" rel="group_[% id2 %]" href="/uploads/covers-added/[% p.getImageName %]">
                                                <img border="0" src="/uploads/covers-added/[% p.getImageName %]" title="Portada" alt="[% 'Portada del ejemplar' | i18n %]" >
                                            </a>
                                        </div>
                                    [% END %]

                                [% ELSE %]
                                    [% IF portada_registro %]
                                        <a class="fancylink" href="/uploads/covers/[% portada_registro_big %]">
                                            <img src="/uploads/covers/[% portada_registro_medium %]" class="book_cover" title="Portada" alt="[% 'Portada del ejemplar' | i18n %]" />
                                        </a>
                                    [% END %]
                                [% END %]
                                </div>       
                                <input class="btn btn-primary btn-large" disabled value="[% cat_ref_tipo_nivel3_name %]" />
                            [% INCLUDE 'opac-detail_partial_N1.inc' %]
                              <dl class="listado_sin_margen">
                                  [% FOREACH nivel2_array %]
                                              [% IF liblibrarian %]
                                                  [% IF dato %]
                                                  <dt class="inline left rightMargin">[% liblibrarian %]:</dt><dd>[% dato %]</dd>
                                                  [% END %]
                                              [% END %]
                                  [% END %]
                                
                              </dl>
                              
                              [% IF mostrarSignaturaEnDetalleOPAC %]
                                <p>[% 'Puede solicitar m&aacute;s f&aacute;cilmente el ejemplar con:' | i18n %] <strong> [% HTML.escape(primer_signatura) %]</strong></p>
                              [% END %]
                                [% IF tiene_indice %]
                                    [% PERL %]
                                            print C4::AR::Filtros::action_button(  
                                                                                button  => "btn btn-success",
                                                                                action  => 'mostrarIndice([% id2 %]);',
                                                                                icon    => "icon-white icon-book",
                                                                                title   => "[% 'Ver &iacute;ndice' | i18n %]",
                                                    ) ;
                                    [% END %]
                                [% END %]

                                [% IF indice %]
                                    <div id="indice_data[% id2 %]"  class="modal hide fade">
                                          <div class="modal-header">
                                            <a href="#" class="close" data-dismiss="modal">×</a>
                                            <h3>[% 'Indice del grupo' | i18n %]</h3>
                                          </div>
                                          <div class="modal-body">
                                              <pre>[% indice | trim %]</pre>
                                                [% IF hay_indice_file %]
                                                       [% PERL %]
                                                           print C4::AR::Filtros::link_to( text =>     " [% 'Contenido del &iacute;ndice' |i18n %]",
                                                                                           url =>      "getIndiceFile.pl", 
                                                                                           params =>   ["id2=[% id2 %]"],
                                                                                           title =>    "[% 'Contenido del &iacute;ndice' |i18n %]",
                                                                                           icon => "icon-file",
                                                                                       ) ;
                                                       [% END %]
                                                [% END %]
                                              </div>
                                          <div class="modal-footer"></div>
                                  </div>
                                [% END %]
                                 
                                [% IF esta_en_estante_virtual %]

                                        [% PERL %]

                                           print C4::AR::Filtros::action_link_button( 
                                                              button    => "btn btn-inverse",
                                                              url       => "[% url_prefix %]/opac-busquedasDB.pl", 
                                                              params    => ["tipoAccion=BUSQUEDA_AVANZADA",
                                                                             "estantes_grupo=[% id2 %]"],
                                                              icon      => "",
                                                              title     => "[% 'Ver estantes' | i18n %]",
                                                          );
                                        [% END %]

                               [% END %]
                            [% IF socio_data.usr_nro_socio && informar_error %]
                                [% PERL %]

                                   print C4::AR::Filtros::action_button( 
                                                      button    => "btn btn-info disabled btn-mini 10_top_margin",
                                                      action    => "showModalReporteCatalogo([% id2 %])",
                                                      icon      => "",
                                                      title     => "[% 'Algo est&aacute; mal' | i18n %]",
                                                      popover => { title   =>'[% "Informe" | i18n %]',
                                                                   text    => '[% "Podes informarnos acerca de posibles errores que haya con esta edici&oacute;n" | i18n %]',
                                                                   placement => "right",
                                                                 }
                                                  );
                                [% END %]
                            [% END %]
                          </div>
                    </div>
                    
                    <div id="modal_reservar_[% id2 %]" class="modal hide fade">
                              <div class="modal-header">
                                <a href="#" class="close" data-dismiss="modal">×</a>
                                <h3>[% 'Reserva de ejemplar' | i18n %]</h3>
                              </div>
                              <div class="modal-body">
                                 [% IF portada_registro %]
                                    <div class="mid-center" >
                                        <img src="/uploads/covers/[% portada_registro_medium %]" title="Portada" alt="[% 'Portada del ejemplar' | i18n %]" />
                                    </div>
                                 [% END %]
                                
                                <p>
                                   [% 'Est&aacute; a punto de reservar un ejemplar de' | i18n %] 
                                   <h4>[% nivel1_obj.getTitulo %]</h4> [% IF edicion %]<span class="label label-info">[% edicion %]</span>[% END %]
                                </p>
                              </div>
                              <div class="modal-footer">
                                <a href="#" class="btn btn-primary" onclick="reservar([% id1 %],[% id2 %]);">[% 'Reservar' | i18n %]</a>
                              </div>
                    </div>

                    [% IF socio_data.usr_nro_socio %]
                        <div id="modal_reporte_catalogo[% id2 %]" class="modal hide fade">
                            <div class="modal-header">
                              <a href="#" class="close" data-dismiss="modal">×</a>
                              <h4>[% 'Reportar problema de registro' | i18n %]</h4>
                            </div>
                            <div class="modal-body">
                              <textarea type="text" rows="6" style="width: 90%; white-space: pre-line;" id="text_reporte_catalogo[% id2 %]"
                                      placeholder="[% 'Contanos cual es el problema con el registro. S&eacute; lo m&aacute;s detallado posible.  
                                                       Ej.: La edici&oacute;n es incorrecta. // Algunos car&aacute;cteres no se ven. // No figura el a&ntilde;o // Etc...  
                                                       Gracias por el inter&eacute;s.' | i18n %]"></textarea>
                            </div>
                            <div class="modal-footer">
                              <a href="#" class="btn btn-primary" onclick="enviarReporteCatalogo([% id2 %]);">
                                <i class="icon-white icon-ok"></i> [% 'Enviar' | i18n %]
                              </a>
                            </div>
                        </div>
                    [% END %]
        [% END %]  <!--END  IF nivel2_array -->

        [% INCLUDE 'e-docs_grupo.inc' %]
                                
        [% IF !preferencias.resumido %]
            [% INCLUDE 'opac-detail_partial_N2_ejemplares.inc' %]
        [% END %]                             

        [% IF cat_ref_tipo_nivel3 != "ANA" %]
          [% IF disponible %]
            [% INCLUDE 'opac-detail_partial_disponibilidad.inc' %]
          [% END %]
        [% END %]

        [% IF show_analiticas > 0 %]
            <div class="accordion-heading">

                       [% PERL %]
                               print C4::AR::Filtros::link_to( text   => "[% 'Anal&iacute;ticas' | i18n %] <span class='badge badge-warning' style='cursor: default;'>[% cant_analiticas %]</span>",
                                                               url    => "[% url_prefix %]/catalogacion/estructura/analiticas.pl", 
                                                               params   => ["id2=[% id2 %]"],
                                                               title  => "[% 'Anal&iacute;ticas' | i18n %]",
                                                               class  => "accordion-toggle"
                                                           ) ;
                       [% END %]
            </div>
        [% END %]


  </section>


[% END %]  <!--END FOREACH nivel2 -->
