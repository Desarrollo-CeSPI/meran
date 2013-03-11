<dl>
    [% FOREACH nivel1 %]
            [% IF liblibrarian %]
                [% IF dato %]
                <dt class="inline left rightMargin">[% liblibrarian %]:</dt><dd>[% dato %]</dd>
                [% END %]
            [% END %]
    [% END %]
</dl>
