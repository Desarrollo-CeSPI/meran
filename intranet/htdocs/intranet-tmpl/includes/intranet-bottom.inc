                            <div id="resultBusqueda"></div>
                            <div id="result"></div>
                        </div><!-- marco_datos -->
                  </div>

            <div id="loading_items" class="loading_items"></div>
        
        </div> <!-- container_test -->

        [% IF !registrado_meran %]
            <a target="_blank" href="[% url_prefix %]/register.pl" onclick="setTimeout(function(){refreshMeranPage();}, 5000);" class="btn btn-large btn-success right" style="margin-right: 10px;">
                    [% 'Registrar' | i18n %]
            </a>  
            
        [% END %]

    </body>
</html>