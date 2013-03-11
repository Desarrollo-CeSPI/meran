<script type="text/javascript">
    $(document).ready(function() {
        $(function()
        {
            $('.fancylink').fancybox();
        });
    });
</script>

[% USE HTML %]
	<div class="page-header">
	    <h1>[% 'Comentarios' | i18n %] <small> [% titulo %] [% IF nivel2_obj.getEdicion %]([% nivel2_obj.getEdicion %]) [% END %]</small></h1>
	</div>      
    <div class="container-fluid">
        <div class="row-fluid">
            <div class="span2">
                [% IF portada_registro %]
                    <a class="fancylink" href="/uploads/covers/[% portada_registro_big %]">
                        <img src="/uploads/covers/[% portada_registro_medium %]" class="book_cover" title="Portada" alt="[% 'Portada del ejemplar' | i18n %]" />
                    </a>
                [% END %]
            </div>
            
        </div>
  </div>

<fieldset>
      [% IF reviews %]
          [% FOREACH review IN reviews %]

            <blockquote>
              <p>[% HTML.escape(review.getReview) %]</p>
              <small>
                  [% TRY %]
                      [% IF socio_data.usr_nro_socio != review.socio.getNro_socio %]
                          [% review.socio.persona.getApellido %], [% review.socio.persona.getNombre %],
                      [% ELSE %]
                          [% 'usted' | i18n %],
                      [% END %]
                  [% CATCH %]
                      [% 'Usuario inexistente' | i18n %],
                  [% END %]
                  <cite title=""> [% 'el' | i18n %] [% review.getDate %]</cite>
              </small>
            </blockquote>

          [% END %]

      [% ELSE %]

          <div class="alert alert-info"> [% 'Esta edici&oacute;n no tiene ningun comentario' | i18n %]</div>
      [% END %]


        [% IF socio_data.usr_permisos_opac %]
            <form class="form-horizontal" action="[% url_prefix %]/reviews.pl" method="post">
                <fieldset>
                  <legend> [% 'Contanos qu&eacute; te parece esta edici&oacute;n ' | i18n %]</legend>
                      <div class="control-group">
                          <div class="controls">
                              <textarea id="review" name="review" class="input-xlarge" rows="6"></textarea>
                          </div>
                      </div>
                      <div class="form-actions">
                          <input class="btn btn-primary" type="submit" value="[% 'Enviar' | i18n %]" />
                      </div>
                      <input type="hidden" name="token" value="[% token %]" />
                      <input type="hidden" name="id2" value="[% HTML.escape(id2) %]" />
                </fieldset>
            </form>
        [% END %]
      <hr>
       
          [% PERL %]
                  print C4::AR::Filtros::action_link_button( 
                                              
                                                            button        => "btn click btn-success",
                                                            url           => "[% url_prefix %]/opac-detail.pl", 
                                                            title         => " [% ' Volver al detalle' | i18n %]",
                                                            params =>   ["id1=[% id1 %]"],
                                                            icon          => "icon-arrow-left icon-white",
                                                                                  
                                              );
          [% END %]

</fieldset>
                   
