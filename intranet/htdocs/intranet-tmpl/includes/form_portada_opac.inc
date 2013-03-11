  <div class="modal-header">
    <a href="#" class="close" data-dismiss="modal">×</a>
    [% IF editing %]
        <h3>[% 'Modificar portada de OPAC ' | i18n %]</h3>
    [% ELSE %]
        <h3>[% 'Agregar portada de OPAC ' | i18n %]</h3>
    [% END %]
  </div>
  
  <div class="modal-body">
    <form class="form-horizontal" id="post_novedad_form" method="post" action="[% url_prefix %]/admin/portada_opac.pl" 
          enctype="multipart/form-data">
          <div class="control-group">
            <label class="control-label" for="titulo_footer">[% 'T&iacute;tulo del pie' | i18n %]</label>
            <div class="controls">
              <input type="text" class="input-xlarge" id="footer_title" name="footer_title" value="[% portada.getFooterTitle %]">
            </div>
          </div>
          
          <div class="control-group">
            <label class="control-label" for="footer">[% 'Pie de nota' | i18n %]</label>
            <div class="controls">
                <textarea class="input-xlarge" id="footer" name="footer">[% portada.getFooter %]</textarea>
            </div>
          </div>
            
          [% IF !editing %]
	          <div class="control-group">
	            <label class="control-label" for="fileInput">[% 'Im&aacute;gen de portada' | i18n %]</label>
	            <div class="controls">
	              <input class="input-file" id="imagen" name="imagen" type="file" required>
	            </div>
	          </div>
	          <input type="hidden" id="tipoAccion" name="tipoAccion" value="ADD">
	      [% ELSE %]
              <input type="hidden" id="tipoAccion" name="tipoAccion" value="MOD">
              <input type="hidden" id="id_portada" name="id_portada" value="[% portada.id %]">
	      [% END %]
    </form>
  </div>
  <div class="modal-footer">
      <button onclick="submitForm([% editing %]);" class="btn btn-primary" >[% 'Enviar' | i18n %]</button>
  </div>
