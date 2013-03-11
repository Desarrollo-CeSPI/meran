<legend>[% 'Datos de la biblioteca' | i18n %]</legend>
 
<div class="well">
    <dl>
    [% info_about.descripcion %]
    </dl>   
      [% IF twitter_enabled %]
          [% IF twitter_follow_button %]
              [% twitter_follow_button %]
          [% END %]
      [% END %]       
    
    
      [% IF google_map %]
          [% google_map %]
      [% END %]    
</div>

<legend>[% 'Equipo de desarrollo de MERAN' | i18n %]</legend>
    <div class="well">
        <a href="http://www.cespi.unlp.edu.ar" target="_blank">CESPI</a><br><br>	 
        <ul class="unstyled"> 
            <li>Javier D&iacute;az</li>
            <li>Einar Lanfranco</li>
            <li>Mat&iacute;as Pagano</li>
            <li>Augusto Perez</li>
            <li>Miguel Carbone</li>
            <li>Gaspar Rajoy</li>
            <li>Magal&iacute; Defalco</li>
            <li>J. Francisco Raposeiras</li>
            <li>Mar&iacute;a Fernanda Pietroboni</li>
            <li>Mar&iacute;a Laura Asenjo</li>
            <li>Paula Gabriela Gonzalez</li>
        </ul>
    </div>
</div>