[% INCLUDE 'ChangePasswordHelper.inc' %]

<script type="text/javascript">

    function checkPassword(){

        $('#new_password1').val(b64_md5($("#newpassword1").val()));
        $('#new_password2').val(b64_md5($("#newpassword2").val()));
        
        $("#newpassword1").val('');
        $("#newpassword2").val('');

        return true;
    }

</script>
    <!--    <h1 class="block">[% 'Modificar sus datos personales' | i18n%]</h1>-->
        [% IF message_info %]
            <div class="alert alert-error">[% 'Error en datos, por favor corrigalos.' | i18n%]</div>
        [% END %]
            <form method="post" class="form-horizontal" action="[% url_prefix %]/opac-recover-password.pl" onSubmit="return checkPassword()">
              <fieldset>
                <legend>[% 'Restablecimiento de clave ' | i18n %]</legend>
                   <!-- CAMPOS PARA CAMBIO DE PASSWORD -->
                   <div class="control-group">
                        <label class="control-label" for="newpassword1">[% 'Nueva Contrase&ntilde;a' | i18n %]:</label>
                        <div class="controls">
                            <input type="password" name="" id="newpassword1" class="field" autocomplete="off" />
                        </div>
                    </div>
                    
                    <div class="control-group">
                        <label class="control-label" for="newpassword2">[% 'Repetir Contrase&ntilde;a' | i18n %]:</label>
                        <div class="controls">
                            <input type="password" name="" id="newpassword2" class="field" autocomplete="off" />
                        </div>
                    </div>
                    
                   <input type="hidden" name="new_password1" id="new_password1" />
                   <input type="hidden" name="new_password2" id="new_password2" />
                   <input type="hidden" name="key" id="key" value="[% key %]"/>
                   
                    <div class="form-actions">
                        <button class="btn btn-primary" type="submit">[% 'Confirme contrase&ntilde;a' |  i18n %]</button>
                    </div> 

              </fieldset>
            </form>
