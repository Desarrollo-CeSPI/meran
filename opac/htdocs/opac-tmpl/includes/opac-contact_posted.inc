[% IF mensaje_error %]

    <div class="alert alert-error">
        <a class="close" data-dismiss="alert">×</a>
        <strong>[% 'Por favor complete todos los campos requeridos' | i18n %]</strong>
    </div>
    
[% ELSE %]

    <div class="alert alert-info">
        <a class="close" data-dismiss="alert">×</a>
        [% 'Su mensaje ha sido enviado, el equipo de ' | i18n %][% ui.getNombre %] [% 'le responder&aacute; lo antes posible' | i18n %]. [% 'Muchas gracias' | i18n %]
    </div>
[% END %]
