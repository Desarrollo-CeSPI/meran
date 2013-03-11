<div class="form-actions">
        [% IF nuevoPermiso != 1%]
                        [% PERL %]
                                    print C4::AR::Filtros::action_button(   
                                                                        button  => "btn btn-primary",
                                                                        action  => "actualizarPermisos();",
                                                                        icon    => "icon-white icon-ok",
                                                                        title   => " [% 'Guardar Permisos' | i18n %]",
                                            );
                        [% END %]
        [% ELSE %]
                        [% PERL %]
                                    print C4::AR::Filtros::action_button(   
                                                                        button  => "btn btn-primary",
                                                                        action  => "nuevoPermiso();",
                                                                        icon    => "icon-white icon-ok",
                                                                        title   => " [% 'Guardar Permisos' | i18n %]",
                                            );
                        [% END %]
        [% END %]
</div>
