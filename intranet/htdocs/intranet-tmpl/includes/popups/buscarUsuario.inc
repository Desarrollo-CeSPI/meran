
[% INCLUDE  'AutocompleteHelper.inc'  %]

<!-- *********************************Window Help********************************************* -->
<script>

function clearInput(){
	$('#campoUsuario').val("");
}

var objAH;//Objeto AjaxHelper.


function detalleDelUsuario(){
	var nro_socio= $('#nro_socio_hidden').val();
	USUARIO= new objeto_usuario();
	USUARIO.text= $('#campoUsuario').val();
	USUARIO.ID= nro_socio;
}

$(document).ready(function() {
	
	CrearAutocompleteUsuarios({	IdInput: 'campoUsuario', 
								IdInputHidden: 'nro_socio_hidden', 
								callBackFunction: detalleDelUsuario
						});
	$('#campoUsuario').focus();
});


</script>



<div id="contentWindow" class="form-horizontal">
	<div class="modal-header">
		<a class="close" data-dismiss="modal">×</a>
		<h3>[% 'Circular ejemplar' | i18n %]</h3>
	</div>
	
	<div class="modal-body">
	
		<div class="form-horizontal">
			<div class="control-group">
			            <label class="control-label" for="multiSelect">[% 'Usuario' | i18n %]</label>
			            <div class="controls">
							<input 	type="text" onClick="clearInput();" id="campoUsuario" name="campoUsuario" autofocus="autofocus">
		                    [% PERL %]
		                            print C4::AR::Filtros::setHelpInput( text        => "[% 'Apellido, nombre, DNI, Nro. de  socio ' | i18n %]",
		                                                                 class       => "info",
		                                                                 icon		 => "icon-info-sign",
		                                    ) ;
		                    [% END %]
							
			            </div>
          	</div>			
			<input id="nro_socio_hidden" type="hidden">
		</div>
		<div id="detalleUsuario"></div>

	</div>
	
    <div class="modal-footer">
            [% PERL %]
                     print C4::AR::Filtros::to_Button(      text    => "[% 'Aceptar' | i18n %]",
                                                            boton   => "boton_buscar",
                                                            onClick => "confirmarPrestamo();",
                                                            title   => "[% 'Aceptar' | i18n %]",
                             ) ;
            [% END %]
    </div>   
</div>


