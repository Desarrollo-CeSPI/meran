
<script type="text/javascript">
    $(document).ready(function() {
        CrearAutocompleteCiudades({IdInput: 'ciudad', IdInputHidden: 'id_ciudad'});
        $('.fancylink').fancybox();       
    });
</script>

        [% IF needsDataValidation %]
        <div class="alert alert-block">
            <a class="close" data-dismiss="alert">×</a>
            <h4 class="alert-heading" >[% "Atenci&oacute;n" | i18n %]!</h4>
            <p>[% "Sus datos necesitan ser validados." | i18n %]</p>
            <p>[% "La &uacute;ltima actualización fue el " | i18n %] [% socio.getLastValidation_formateada %] ([% socio.daysFromLastValidation %] [% "d&iacute;as" | i18n %]) </p>         
        </div>
        [% END %]

        [% IF mensaje %]
            <div class="[% mensaje_class %]">
                <a class="close" data-dismiss="alert">×</a>
                [% mensaje %]
            </div>
        [% END %]
<div>
    <form method="post" action="[% url_prefix %]/opac-actualizar_datos_censalesDB.pl" onSubmit="return (startOverlay())" class="form-horizontal">
    
    <fieldset>
        <section class="center-section-form">
        <br />
        <div class="control-group">
            <label class="control-label" for="nombre">[% 'Nombres' |  i18n %]* :</label>
            <div class="controls">
                <input type="text" name="nombre" id="nombre" required value="" tabindex="6" />
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label" for="apellido">[% 'Apellido/s' |  i18n %]* :</label>
            <div class="controls">
                <input type="text" name="apellido" id="apellido" required value="" tabindex="7" />
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label" for="ciudad">[% 'Ciudad' |  i18n %]* :</label>
            <div class="controls">
                <input type="text" name="ciudad" id="ciudad" required value="" tabindex="8" />
                <input type="hidden" name="id_ciudad" id="id_ciudad" value=""/>
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label" for="direccion">[% 'Direcci&oacute;n' |  i18n %]* :</label>
            <div class="controls">
                <input type="text" name="direccion" id="direccion" required value="" tabindex="9" />
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label" for="telefono">[% 'Tel&eacute;fono' |  i18n %]* :</label>
            <div class="controls">
                <input type="text" name="telefono" id="telefono" required value="" tabindex="10" />
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label" for="email">[% 'E-mail' |  i18n %]* :</label>
            <div class="controls">
                <input type="email" name="email" required id="email" value="" tabindex="11" />
            </div>
        </div>
    </section>
        </fieldset>
        <div class="form-actions">  
            <button class="btn btn-primary" type="submit">[% 'Actualizar datos' |  i18n %]</button>
        </div>
    </form>
  </div>
