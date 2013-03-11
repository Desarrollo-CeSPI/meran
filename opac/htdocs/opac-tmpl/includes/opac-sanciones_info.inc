[% IF sancionado %]
        <div class="subcontent-unit-border-warning">
          <div class="round-border-topleft"></div><div class="round-border-topright"></div>
          <h1 class="warning">[% 'Sanciones' | i18n %]</h1>
          <p>[% 'Ud. ha sido sancionado' | i18n %], 
              <a href="[% url_prefix %]/opac-detalle_sanciones.pl?token=[% token %]">[% 'presione aqui para ver el detalle' | i18n %]</a>
          </p>
        </div>
[% END %]