[% USE HTML %]

<script type="text/javascript">
	var RecaptchaOptions = {
	   lang : 'es',
	};
</script>

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

             
                    <script src="http://www.google.com/recaptcha/api/challenge?k=[% re_captcha_public_key %]" type="text/javascript"></script>
                    <noscript><iframeframeborder="0" height="300" src="http://www.google.com/recaptcha/api/noscript?k=[% re_captcha_public_key %]" width="500"></iframe><textarea cols="40" name="recaptcha_challenge_field" rows="3"></textarea><input name="recaptcha_response_field" type="hidden" value="manual_challenge" /></noscript>
          
                    <div class="form-actions">
                        <button class="btn btn-large btn-primary" type="submit">[% 'Enviar' | i18n %]</button>
                    </div> 
                    
            </fieldset>            
        </form>
</div>
