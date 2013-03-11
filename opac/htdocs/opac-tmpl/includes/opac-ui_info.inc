
      <!-- Content unit - One column -->
     <h1 class="block">[% ui.getNombre %]</h1>
<ul>
    <li>
        [% info_about.descripcion %]
    </li>
    <li>
        [% IF twitter_enabled %]
            [% IF twitter_follow_button %]
                [% twitter_follow_button %]
                    <hr class="clear-contentunit" />
                    <!-- Content unit - Two columns -->
            [% END %]
        [% END %]       
    
        [% IF google_map %]
            [% google_map %]
        [% END %]    
    </li>           
</ul>