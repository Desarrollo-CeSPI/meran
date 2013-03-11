[% INCLUDE 'ChangePasswordHelper.inc' %]

<script type="text/javascript">

function checkPassword(){

    var changed = $.trim($('#actualpassword').val());
    
    if (changed != ''){
        
        var nroRandom   = [% nroRandom %];
        var hash_actual = b64_sha256(b64_sha256(b64_md5($("#actualpassword").val()))+nroRandom);
        var key         = b64_sha256(b64_md5($("#actualpassword").val()));
        var hash_new1   = encriptar($("#newpassword1").val(),key);
        var hash_new2   = encriptar($("#newpassword2").val(),key);
        //encriptar(b64_md5($("#newpassword2").val()),key);
        
        //checkeo que las pass nuevas sean iguales
        if(desencriptar(hash_new1, key) != desencriptar(hash_new2, key))
        {
            jAlert('Por favor verifique que las nuevas passwords sean iguales');
            return false;
        }
        
        [% IF minPassLength %]
        if($("#newpassword1").val().length < [% minPassLength %])
        {
            jAlert('Por favor verifique que la nueva password contenga al menos [% minPassLength %] caracteres.');
            return false;
        }
        [% END %]
        
        [% IF minPassNumeric %]
        if (!$("#newpassword1").val().match(/([0-9]{[% minPassNumeric %],})/)) 
        {
            jAlert('Por favor verifique que la nueva password contenga al menos [% minPassNumeric %] numeros.');
            return false;
        }
        [% END %]
        
        [% IF minPassAlpha %]
        if (!$("#newpassword1").val().match(/([a-zA-Z]{[% minPassAlpha %],})/)) 
        {
            jAlert('Por favor verifique que la nueva password contenga al menos [% minPassAlpha %] letras.');
            return false;
        }
        [% END %]
        
        [% IF minPassSymbol %]
        if (!$("#newpassword1").val().match(/(\W{[% minPassSymbol %],})/)) 
        {
            jAlert('Por favor verifique que la nueva password contenga al menos [% minPassSymbol %] simbolos.');
            return false;
        }
        [% END %]
    
        $("#actual_password").val(hash_actual);
        $('#new_password1').val(hash_new1);
        $('#new_password2').val(hash_new1);
        $('#key').val(key);
        $("#datosAEnviar").submit();
        return true;
    }        	
  
}


    $(document).ready(function() {
        CrearAutocompleteCiudades({IdInput: 'ciudad', IdInputHidden: 'id_ciudad'});
        $('.fancylink').fancybox();       
    });
</script>
        [% IF mensaje %]
            <div class="[% mensaje_class %]">
                <a class="close" data-dismiss="alert">×</a>
                [% mensaje %]
            </div>
        [% END %]
<div>
    <form method="post" action="[% url_prefix %]/opac-userupdate.pl" onSubmit="return (checkPassword() && startOverlay())" class="form-horizontal">
    
    <fieldset>
        <section class="center-section-form">
        <br />
        <div class="control-group">
            <label class="control-label" for="nombre">[% 'Nombres' |  i18n %]* :</label>
            <div class="controls">
                <input type="text" name="nombre" id="nombre" required value="[% socio_data.usr_nombre %]" tabindex="6" />
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label" for="apellido">[% 'Apellido/s' |  i18n %]* :</label>
            <div class="controls">
                <input type="text" name="apellido" id="apellido" required value="[% socio_data.usr_apellido %]" tabindex="7" />
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label" for="ciudad">[% 'Ciudad' |  i18n %]* :</label>
            <div class="controls">
                <input type="text" name="ciudad" id="ciudad" required value="[% socio_data.usr_ciudad_nombre %]" tabindex="8" />
                <input type="hidden" name="id_ciudad" id="id_ciudad" value="[% socio_data.ciudad_ref.id %]"/>
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label" for="direccion">[% 'Direcci&oacute;n' |  i18n %]* :</label>
            <div class="controls">
                <input type="text" name="direccion" id="direccion" required value="[% socio_data.usr_calle %]" tabindex="9" />
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label" for="telefono">[% 'Tel&eacute;fono' |  i18n %]* :</label>
            <div class="controls">
                <input type="text" name="telefono" id="telefono" required value="[% socio_data.usr_telefono %]" tabindex="10" />
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label" for="email">[% 'E-mail' |  i18n %]* :</label>
            <div class="controls">
                <input type="email" name="email" required id="email" value="[% socio_data.usr_email %]" tabindex="11" />
            </div>
        </div>

        <input type="hidden" name="token" id="token" value="[% token %]" />
        
           <!-- CAMPOS PARA CAMBIO DE PASSWORD -->
           <input type="hidden" name="new_password1" id="new_password1" />
           <input type="hidden" name="new_password2" id="new_password2" />
           <input type="hidden" name="key" id="key" />
           <input type="hidden" name="changePassword" id="changePassword" />
           <input type="hidden" name="actual_password" id="actual_password" />
           </section>
        </fieldset>
          
        <fieldset>
            <legend>[% 'Cambio de contrase&ntilde;a' | i18n %] ([% 'Dejar en blanco para descartar' | i18n %])</legend>
            <section class="center-section-form">
        	<br />
            <div class="control-group">
                <label class="control-label" for="actualpassword">[% 'Contrase&ntilde;a Actual' |  i18n %] :</label>
                <div class="controls">
                    <input type="password" name="" id="actualpassword" autocomplete="off" tabindex="15"/>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="newpassword1">[% 'Nueva Contrase&ntilde;a ' |  i18n %] :</label>
                <div class="controls">
                    <input type="password" name="" id="newpassword1" autocomplete="off" tabindex="16"/>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="newpassword2">[% 'Repetir Contrase&ntilde;a ' |  i18n %] :</label>
                <div class="controls">
                    <input type="password" name="" id="newpassword2" autocomplete="off" tabindex="17"/>
                </div>
            </div>
            </section>
        </fieldset>
        <fieldset>
            <legend>[% 'Personalizaci&oacute;n de visualizaci&oacute;n' | i18n %]</legend>
            <section class="center-section-form">
        	<br />
            <div class="control-group">
                <label class="control-label" for="temas_opac">[% 'Tema' |  i18n %] :</label>
                <div class="controls">
                    [% combo_temas %]
                </div>
            </div>
            </section>
        </fieldset>
        <fieldset>
            <legend>[% 'Recordatorio de vencimiento de pr&eacute;stamos' | i18n %]</legend>
            <section class="center-section-form">
        	<br />
            <div class="control-group">
                    <label class="control-label" for="remindFlag">[% 'Recibir notificaci&oacute;nes' |  i18n %] :</label>
                    <div class="controls">
                        <input type="checkbox" name="remindFlag" id="remindFlag" [% IF socio_data.remindFlag %] checked="checked" [% END %]/> 
                    </div>
                </div>
            </section>
        </fieldset>
        <div class="form-actions">  
            <button class="btn btn-primary" type="submit">[% 'Modificar datos' |  i18n %]</button>
        </div>
    </form>
  </div>
