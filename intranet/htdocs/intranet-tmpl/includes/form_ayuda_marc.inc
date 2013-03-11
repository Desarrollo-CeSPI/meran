    <div class="modal-header">
         <a href="#" class="close" data-dismiss="modal">×</a>
        <h3>[% "Agregar Ayuda MARC:" | i18n %]</h3>
    </div>

     <div class="modal-body">
            <div class="form-horizontal">
            <div class="control-group">
                <label class="control-label" for="campoX"> [% "Selecci&oacute;n" | i18n %]: </label>
                <div class="controls">
                    [% selectCampoX %]
                </div>
            </div>
            
            <div class="control-group">
                <label class="control-label" for="campo"> [% "Campo" | i18n %]: </label>
                <div class="controls">
                    <select name="campo" id="campo" onChange="eleccionCampo()">
                            <option value="-1">[% 'Seleccionar CampoX' | i18n %]</option>
                        </select><br />[% 'Nombre' | i18n %]: <strong><span id="nombre_campo"></span></strong>
                </div>
            </div>
            
            <div class="control-group">
                <label class="control-label" for="subcampo"> [% "Subcampo" | i18n %]: </label>
                <div class="controls">
                    <select name="subcampo" id="subcampo" onChange="eleccionSubCampo()">
                            <option value="-1">[% 'Seleccionar SubCampo' | i18n %]</option>
                    </select>
                </div>
            </div>
            
            <div class="control-group">
                <label class="control-label" for="liblibrarian"> [% "Ayuda" | i18n %]: </label>
                <div class="controls">
                    <textarea id="ayuda" name="ayuda"  value="" size="90"></textarea>
                </div>
            </div>
    </div>
  </div>

    <div class="modal-footer">
        [% PERL %]
                print C4::AR::Filtros::to_Button(   text    => "[% 'Agregar Ayuda' | i18n %]",
                                                    boton   => "btn btn-primary",
                                                    onClick => "agregarAyudaMarc()",
                                                    title   => "[% 'Agregar Ayuda' | i18n %]",
                                                    width => "auto",
                                                    alternClass => "botonCentrado",
                                                    inline => "1"
                        ) ;
        [% END %]

  </div>