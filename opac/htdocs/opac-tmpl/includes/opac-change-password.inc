[% INCLUDE   'ChangePasswordHelper.inc'  %]

<script type="text/javascript">

function objeto_usuario(){
    this.text;
    this.ID;
}

function guardarCambiarPassword(){

    var changed = $.trim($('#actualpassword').val());
    if (changed != ''){

        
        var nroRandom   = [% nroRandom %];
        var hash_actual = b64_sha256(b64_sha256(b64_md5($("#actualpassword").val()))+nroRandom);
        var key         = b64_sha256(b64_md5($("#actualpassword").val()));
        var hash_new1   = encriptar($("#newpassword1").val(),key);
        var hash_new2   = encriptar($("#newpassword2").val(),key);
        
        
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

function updateGuardarCambiarPassword(responseText){
    var Messages= JSONstring.toObject(responseText);
    setMessages(Messages);
}

$(document).ready(function() {
    
    usuario= new objeto_usuario();
    usuario.text= "[% completo %]";
    usuario.ID= "[% nro_socio %]";

});

</script>
<form action='[% url_prefix %]/change_passwordDB.pl?token=[% token %]' method="post" name="datosAEnviar" id="datosAEnviar">
        <input type="hidden" name="new_password1" id="new_password1">
        <input type="hidden" name="new_password2" id="new_password2">
        <input type="hidden" value="[% nro_socio %]" name="usuario" id="usuario">
        <input type="hidden" name="changePassword" id="changePassword">
        <input type="hidden" name="key" id="key" />
        <input type="hidden" name="actual_password" id="actual_password">
        <input type="hidden" name="token" value="[% token %]">
</form>


<div class='tableMsgUser'>
    <font class='fontMsgUser'>
        <b>
            <div id='mensajes'>
                [% mensaje %]
            </div>
        </b>
    </font>
</div>

<section class="center-section-form">
<form onsubmit="return false" class="form-horizontal">
<fieldset>
    <legend>[% 'Cambio de contrase&ntilde;a obligatorio' | i18n %]</legend>
        <div class="control-group">
            <label class="control-label" for="password">[% 'Contrase&ntilde;a Actual' | i18n %] :</label>
            <div class="controls">
                <input type="password" required name="" id="actualpassword">
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label" for="newpassword1">[% 'Nueva Contrase&ntilde;a' | i18n %] :</label>
            <div class="controls">
                <input type="password" required name="" id="newpassword1">
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label" for="newpassword2">[% 'Repetir Contrase&ntilde;a' | i18n %] :</label>
            <div class="controls">
                <input type="password" required name="" id="newpassword2">
            </div>
        </div>
        
        <div class="form-actions">
        [% PERL %]
              print C4::AR::Filtros::action_button( 
                                              button    => "btn btn-primary click",
                                              action    => "guardarCambiarPassword()", 
                                              title     => "Aceptar",
                                          ) ;


        [% END %]
        </div>
</fieldset>
</form>
</section>
