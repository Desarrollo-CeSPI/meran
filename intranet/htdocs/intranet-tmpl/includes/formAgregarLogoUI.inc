    <div class="modal-header">
        <a href="#" class="close" data-dismiss="modal">×</a>
        [% IF editing %]
            <h3>[% 'Modificar Logo ' | i18n %]</h3>
        [% ELSE %]
            <h3>[% 'Agregar Logo' | i18n %]</h3>
        [% END %]
    </div>
  
    <div class="modal-body">
        <form class="form-horizontal" id="agregarLogoUIForm" method="post" action="[% url_prefix %]/admin/logos.pl?token=[% token %]" enctype="multipart/form-data">
          <!-- 
          <div class="control-group">
            <label class="control-label" for="titulo_footer">[% 'Alto' | i18n %]</label>
            <div class="controls">
              <input type="text" id="alto" requiered name="alto" value="[% logo.getAlto %]">
              [% PERL %]
                print C4::AR::Filtros::setHelpInput(text => 'Introduzca un valor en pixeles.');
              [% END %]
            </div>
          </div> -->
          
          <!-- <div class="control-group">
            <label class="control-label" for="titulo_footer">[% 'Ancho' | i18n %]</label>
            <div class="controls">
              <input type="text" id="ancho" requiered name="ancho" value="[% logo.getAncho %]">
              [% PERL %]
                print C4::AR::Filtros::setHelpInput(text => 'Introduzca un valor en pixeles.');
              [% END %]
            </div>
          </div> -->
            
          [% IF !editing %]
	          <div class="control-group">
	            <label class="control-label" for="fileInput">[% 'Im&aacute;gen' | i18n %]</label>
	            <div class="controls">
	              <input class="input-file" id="imagen" name="imagen" required type="file">
	            </div>
	          </div>
	          <input type="hidden" id="tipoAccion" name="tipoAccion" value="ADD_UI">
	          <input type="hidden" id="context" name="context" value="intranet">
	      [% ELSE %]
              <input type="hidden" id="tipoAccion" name="tipoAccion" value="MOD_UI">
              <input type="hidden" id="idLogo" name="idLogo" value="[% logo.getId %]">
	      [% END %]
	 </form>
  </div>
  <div class="modal-footer">
      <button class="btn btn-primary" onclick="submitFormUI()">[% 'Aceptar' | i18n %]</button>
  </div>