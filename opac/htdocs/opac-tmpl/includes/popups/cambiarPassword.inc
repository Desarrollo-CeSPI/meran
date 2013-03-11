<script>
    function clearInput(){
        $('#newpassword').val('');
        $('#newpassword1').val('');
    }
   $.getScript("/includes/md5.js");
</script>

<!-- ************************************Window Cambiar Password***************************************** -->
<div id="contentWindow" class="formElemets">
<center>
    <ul>
        <li>
            <b>Contrase&ntilde;a actual:</b>
        </li>
        <li>
            <input id="actualPassword" size=20 type=password>
        </li>
	    <li>
		    <b>Nueva Contrase&ntilde;a:</b>
	    </li>
	    <li>
		    <input id="newpassword" size=20 type=password>
	    </li>
	    <li>
		    <b>Repetir Contrase&ntilde;a: </b>
	    <li>
	    </li>
		    <input id="newpassword1"  size=20 type=password>
	    </li>	
	    <li>
		    <input type=button onClick="verificarClaveUsuario();" 
		    value="Confirme contrase&ntilde;a" class="button">
	    </li>
	</ul>
</center>
</div> <!--end div id="contentWindow"-->

<!-- *******************************Fin**Window Cambiar Password***************************************** -->