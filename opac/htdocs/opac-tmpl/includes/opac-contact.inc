
<form id="contactform" name="contactform" method="POST" action="[% url_prefix %]/opac-contact.pl" class="form-horizontal">
    <section class="center-section-form">
    <fieldset>
        <legend>[% 'Sus datos' | i18n %]</legend>
 
        <div class="control-group">
            <label class="control-label" for="trato">[% 'Trato' | i18n %]:</label>
            <div class="controls">
                <select name="trato" id="trato" tabindex="5">
                     <option value="choose"> [% 'Elija una opci&oacute;n' | i18n %]... </option>
                     <option value="Sr"> [% 'Sr.' | i18n %] </option>
                     <option value="Sra"> [% 'Sra.' | i18n %] </option>
                     <option value="Dr"> [% 'Dr.' | i18n %] </option>
                </select>
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label" for="nombre">[% 'Nombre/s *' | i18n %]:</label>
            <div class="controls">
                <input type="text" name="nombre" id="nombre" required value="[% socio.persona.getNombre || params_form.nombre %]" tabindex="6" />
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label" for="apellido">[% 'Apellido/s *' | i18n %]:</label>
            <div class="controls">
                <input type="text" name="apellido" id="apellido" required value="[% socio.persona.getApellido || params_form.apellido %]" tabindex="7" />
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label" for="direccion">[% 'Direcci&oacute;n' | i18n %]:</label>
            <div class="controls">
                <input type="text" name="direccion" id="direccion"  value="[% socio.persona.getCalle || params_form.direccion %]" tabindex="8" />
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label" for="codigo_postal">[% 'C&oacute;digo Postal' | i18n %]:</label>
            <div class="controls">
                <input type="text" name="codigo_postal" id="codigo_postal" value="[% params_form.codigo_postal %]" tabindex="9" />
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label" for="ciudad">[% 'Ciudad' | i18n %]:</label>
            <div class="controls">
                <input type="text" name="ciudad" id="ciudad" value="[% socio.persona.ciudad_ref.NOMBRE  || params_form.ciudad %]" tabindex="10" />
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label" for="pais">[% 'Pa&iacute;s' | i18n %]:</label>
            <div class="controls">
                <input type="text" name="pais" id="pais"  tabindex="11" value="[% params_form.pais %]" />
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label" for="telefono">[% 'Tel&eacute;fono' | i18n %]:</label>
            <div class="controls">
                <input type="text" name="telefono" id="telefono" value="[% socio.persona.getTelefono || params_form.telefono %]" tabindex="12" />
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label" for="email">[% 'E-mail *' | i18n %]:</label>
            <div class="controls">
                <input type="email" name="email" id="email" required value="[% socio.persona.getEmail || params_form.email %]" tabindex="13" />
            </div>
        </div>
    </fieldset>
  
    <fieldset><legend>[% 'Motivo de la consulta' | i18n %]</legend>
        
        <div class="control-group">
            <label class="control-label" for="asunto">[% 'Asunto *' | i18n %]:</label>
            <div class="controls">
                <input type="text" name="asunto" id="asunto" required class="field" value="[% params_form.asunto %]" tabindex="14" />
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label" for="mensaje">[% 'Mensaje *' | i18n %]:</label>
            <div class="controls">
                <textarea name="mensaje" id="mensaje" cols="45" required rows="10" tabindex="15">[% params_form.mensaje %]</textarea>
            </div>
        </div>
        [% IF !no_submit %]
            <div class="form-actions" id="contact_submit_container">
                <button class="btn btn-primary" type="submit" tabindex="16">[% 'Enviar Mensaje' | i18n %]</button>
            </div>
        [% END %]        
       <input type="hidden" name="post_message" id="post_message" value="1"/>
  </fieldset>
  </section>
</form>
