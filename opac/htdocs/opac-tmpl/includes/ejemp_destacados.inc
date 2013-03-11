<script type="text/javascript">
  $(window).load(function() {
    $('.flexslider').flexslider({
      animation: "slide",
      animationLoop: false,
      itemWidth: 160,
      itemMargin: 10
    });
});
  $(document).ready(function(){
    $('.fancy_link').fancybox();
  });

</script>

<script type="text/javascript" src="/includes/flexSlider/jquery.flexslider.js"></script>

<link rel="stylesheet" href="/includes/flexSlider/flexslider.css" type="text/css" media="screen"/>


[% IF promoted_count %]       
        <fieldset> 
              <legend class="titulo_legend_resaltado">
                  [% "Ejemplares destacados por la biblioteca" | i18n %]
             </legend>
                     [% IF promoted_count %]
 
                    <div class="flexslider"> 
                      <ul class="thumbnails slides">
                            [% FOREACH elem IN promoted %]
                                <li class="span2">
                                  <div class="thumbnail">
                                     

                                          [% IF elem.portada_registro or isbn %]
                                             <div class="">
                                                [% IF elem.portada_registro %]
                                       
                                                    <a class="fancy_link" href="/uploads/covers/[% elem.portada_registro_medium %]">
                                                        <img style="margin-left:19px; height: 160px; width:110px;" src="/uploads/covers/[% elem.portada_registro_medium %]" title="Portada" alt="[% 'Portada del ejemplar' | i18n %]" />
                                                    </a>
                                       
                                                [% END %]
                                             </div>
                                          [% ELSE %]
                                            
                                                [% IF elem.portada_edicion_local %]
                                                  [% FOREACH p IN elem.portada_edicion_local %]

                                                    <div class="item portadaEdicionImage" [% IF !loop.first %]style="display:none; "[% END %]>
                                                    <a class="fancy_link" href="/uploads/covers-added/[% p.getImageName %]">
                                                      <img border="0" style="margin-left:19px; height: 160px; width:110px;"  src="/uploads/covers-added/[% p.getImageName %]" title="Portada" alt="[% 'Portada del ejemplar' | i18n %]" >        
                                                   
                                                    </a>
                                                   </div>
                                                  [% END %]

                                                [% ELSE %]

                                                    <div class="">
                                                            <a>
                                                                <img style="margin-left:19px;height: 160px; width:110px;" src="/uploads/covers/sin_portada.jpg" title="Portada" alt="[% 'Portada del ejemplar' | i18n %]" />
                                                            </a>
                                                       
                                                    </div>
                                                [% END %]

                                          [% END %]

                                      <div id="wrapping" style="heigth: 40%;">
                                        <div id="ellipsis" > 
                                            [% PERL %]
                                              print C4::AR::Filtros::link_to( text => "[% HTML.escape(elem.nivel1.getTitulo) %]",
                                                                url=>"[% url_prefix %]/opac-detail.pl", 
                                                                params => ["id1=[% elem.nivel1.getId1 %]"],
                                                                  ) ;
                                             [% END %]


                                        </div>
                                        <div id="ellipsis"> 
                                          [% IF elem.nivel1.getAutor %]
                                                  [% elem.nivel1.getAutor %]
                                                [% ELSE %]
                                                    &nbsp;
                                                [% END %]
                                          
                                        </div>  
                                        <div id="ellipsis">   
                                              [% IF elem.getEdicion %] 
                                                  [% elem.getEdicion %] 
                                              [% END %]
                                        </div> 
                                        
                                      </div>
                                   
                                  </div>  
                                </li>
                            [% END %] 

                          </ul>
                      </div> 




                      [% END %]
            </table> 
        </fieldset>
[% END %]
