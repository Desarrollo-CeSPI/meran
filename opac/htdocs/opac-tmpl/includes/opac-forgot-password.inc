[% USE HTML %]

[%  IF re_captcha_public_key  %]
    <script src='https://www.google.com/recaptcha/api.js'></script>
[% END %]

<div>
    [% IF message %]
        <div class="alert alert-error"><strong>Error! </strong>[% message %]</div>
    [% END %]
        <form id="datosAEnviar" class="form-horizontal" method="post" action="[% url_prefix %]/opac-forgot-password.pl" onsubmit="javascript:startOverlay();" autocomplete="off">
            <fieldset>
                <legend>[% 'Ingrese sus datos de autenticaci&oacute;n' | i18n %]</legend>
               
                    <div class="control-group">
                        <label class="control-label" for="user-id">[% 'E-mail , Usuario &oacute; DNI' | i18n %]:</label>
                        <div class="controls">
                            <input type="user-id" name="user-id" id="user-id" tabindex="1" class="field" value="" />
                        </div>
                    </div>
             
             [%  IF re_captcha_public_key  %]
                    <div id="captcha"> 
                        <div class="g-recaptcha" data-sitekey="[% re_captcha_public_key %]"></div>
                    </div>
             [% END %]

                    <div class="form-actions">
                        <button class="btn btn-large btn-primary" type="submit">[% 'Enviar' | i18n %]</button>
                    </div> 
                    
            </fieldset>            
        </form>
</div>
