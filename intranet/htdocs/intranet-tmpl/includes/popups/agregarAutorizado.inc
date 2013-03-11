<!-- *********************************Window Help********************************************* -->
<script>
    /*
    @params
    se le debe asigna el nro de socio a nro_socio_auth
    */
    var objAH;//Objeto AjaxHelper.

    function verificarDatos(){
        if($('#nombreAutorizado').val() == ''){
            $('#nombreAutorizado').focus();
            jAlert(FALTA_INGRESAR_EL_NOMBRE_DEL_AUTORIZADO);
            return 0;
        }
        if($('#dniAutorizado').val() == ''){
            $('#dniAutorizado').focus();
            jAlert(FALTA_INGRESAR_EL_DNI_DEL_AUTORIZADO);
            return 0;
        }
        if($('#telefonoAutorizado').val() == ''){
            $('#telefonoAutorizado').focus();
            jAlert(FALTA_INGRESAR_EL_TELEFONO_DEL_AUTORIZADO);
            return 0;
        }
        return 1;
    }

    /*
    * object_usuario
    * Representa al objeto que contendra la informacion del usuario seleccionado del autocomplete.
    */
    function object_usuario(){
        this.text;
        this.ID;
    }

</script>



<div class="modal">
              <div class="modal-header">
                <a href="#" class="close" data-dismiss="modal">×</a>
                <h3>[% ' Agregar Usuario Adicional' | i18n %]</h3>
              </div>
              <div class="modal-body">
		            <div class="form-horizontal">
		                   <div class="control-group">
		                           <label class="control-label" for="nombreAutorizado">[% "Apellido y Nombres" | i18n %]</label>
		                           <div class="controls">
		                                    <input type="text" class="input focused" id="nombreAutorizado" name="nombreAutorizado" tabindex="1">
		                            </div>
		                   </div>
		
		                   <div class="control-group">
		                           <label class="control-label" for="dniAutorizado">[% "DNI" | i18n %]</label>
		                           <div class="controls">
		                                    <input type="text" class="input focused" id="dniAutorizado" name="dniAutorizado" tabindex="2">
		                            </div>
		                   </div>
		
		                   <div class="control-group">
		                           <label class="control-label" for="telefonoAutorizado">[% "Tel&eacute;fono (contacto seguro)" | i18n %]</label>
		                           <div class="controls">
		                                    <input type="text" class="input focused" id="telefonoAutorizado" name="telefonoAutorizado" tabindex="3">
		                            </div>
		                   </div>
		           </div>
              </div>
              <div class="modal-footer">
                              [% PERL %]
                                  print C4::AR::Filtros::to_Button(      text    => "[% 'Aceptar' | i18n %]",
                                                                        boton   => "btn btn-primary",
                                                                        onClick => "confirmarAgregarAutorizado();",
                                                                        title   => "[% 'Agregar Autorizado' | i18n %]",
                                                                        inline=> "1",
                                          ) ;
                              [% END %]                
              </div>
</div>






