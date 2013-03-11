[% INCLUDE  'AutocompleteHelper.inc'  %]

<div class="permisos">
  <section class="center-section-form">
    <form class="form-horizontal" onsubmit="return false;">
        <fieldset>
            
                <div class="control-group">
                    <label class="control-label" for="usuario"> Usuario: </label>
                    <div class="controls">
                        <input type="text" name="usuario" id="usuario" />
                        <input type="hidden" name="nro_socio_hidden" id="nro_socio_hidden" />
                    </div>
                </div>
                
                <div class="control-group">
                    <label class="control-label" for="id_ui"> Unid. Info.: </label>
                    <div class="controls">
                        [% combo_UI %]
                    </div>
                </div>
                
                <div class="control-group">
                    <label class="control-label" for="perfiles"> Perfil: </label>
                    <div class="controls">
                        [% combo_perfiles %]
                    </div>
                </div>
                
                <div class="control-group">
                    <label class="control-label" for="tipo_permisos"> Tipo de Permiso: </label>
                    <div class="controls">
                        [% combo_tipo_permisos %]
                    </div>
                </div>
                
                <div class="form-actions">
                
                    [% PERL %]
                        print C4::AR::Filtros::action_button(   
                                                            button   => "btn btn-primary",
                                                            action => "obtenerPermisos();",
                                                            icon    => "icon-white icon-ok",
                                                            title   => " [% 'Obtener Permisos' | i18n %]",
                                ) ;
                    [% END %]
                    
                </div>
        </fieldset>
    </form>
    </section>
    <div class="permisos_assign_chk" id="permisos_assign_chk"> </div>
</div>
