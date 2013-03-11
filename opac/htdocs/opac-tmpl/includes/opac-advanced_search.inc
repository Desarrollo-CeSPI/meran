<section class="center-section-form"> 
		<form id="form_circulacion_rapida" class="classform form-horizontal" action="[% url_prefix %]/opac-busquedasDB.pl" method="get" onsubmit="startOverlay();">
                    <fieldset>
                    	<legend >[% 'B&uacute;squeda avanzada' | i18n %]</legend>
                        <div class="control-group">
                                          <label for="titulo" class="control-label">[% 'T&iacute;tulo' | i18n %]</label>
                                          <div class="controls">
                                              <input type="text" name="titulo" id="titulo" tabindex="1" />
                                          </div>
                        </div>
                        <div class="control-group">
                                          <label for="autor" class="control-label">[% 'Autor' | i18n %]</label>
                                          <div class="controls">
                                              <input type="text" name="autor" id="autor" tabindex="2" />
                                          </div>
                        </div>
                        <div class="control-group">
                                          <label for="isbn" class="control-label">[% 'ISBN' | i18n %]</label>
                                          <div class="controls">
                                              <input type="text" name="isbn" id="isbn" tabindex="3" />
                                          </div>
                        </div>
                        <div class="control-group">
                                          <label for="contact_title" class="control-label">[% 'Tipo de documento' | i18n %]</label>
                                          <div class="controls">
                                             [% combo_tipo_documento %]
                                          </div>
                        </div>
                        <div class="control-group">
                                          <label for="tema" class="control-label">[% 'Tema' | i18n %]</label>
                                          <div class="controls">
                                              <input type="text" name="tema" id="tema" tabindex="4" />
                                          </div>
                        </div>
                        <div class="control-group">
                                          <label for="estantes" class="control-label">[% 'Estantes Virtuales' | i18n %]</label>
                                          <div class="controls">
                                              <input type="text" name="estantes" id="estantes" tabindex="5" />
                                          </div>
                        </div>
                        <div class="control-group">
                                        
                                          <div class="controls">
                                          <label class="checkbox">
                                              <input type="checkbox" name="only_available" id="only_available" tabindex="6">[% ' S&oacute;lo Disponibles para Pr&eacute;stamo' | i18n %]
                                          </label>
                                          </div>
                        </div>
                       
                        <div class="form-actions" id="acciones">
                              <button type="submit" name="submit" id="submit" class="btn btn-primary" tabindex="6" /> <i class="icon-white icon-search"></i> [% 'Buscar' | i18n %]
                        </div>                        
                </fieldset>
                <input type="hidden" name="tipoAccion" value="BUSQUEDA_AVANZADA" />
                <input type="hidden" name="tipo" value="normal" />
                <input type="hidden" name="token" value="[% token %]" />
		</form>
</section>
