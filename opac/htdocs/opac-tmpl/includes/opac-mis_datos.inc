[% IF !foto_name %] 
    <style type="text/css">
        #footerDatosUsuario{   margin-top:125px;     }
    </style>
[% END %]

<link rel="stylesheet" type="text/css" href="[% temas %]/[% user_theme_intra %]/includes/fileuploader.css">
<script>
    var user_picture_name = "[% foto_name %]";
</script>
<script type="text/javascript" src="/includes/jquery/fileuploader.js"></script>
<script type="text/javascript" language="javascript">
 
    $(document).ready(function(){

        $('.fancylink').fancybox();

        [% IF !foto_name %] 
            $('#footerDatosUsuario').show();
        [% END %]

        $('.fancylink').fancybox();

        //Inicializacion del FileUploader
            $('#label-file-uploader').show();
	        var uploader = new qq.FileUploader({
	            element: document.getElementById('file-uploader'),
	            action: '[% url_prefix %]/uploadPicture.pl',
	            params: {
	            	nro_socio: '[% nro_socio %]',
	            },
	            allowedExtensions: ["bmp","jpg","gif","png","jpeg"],
	            onComplete: function(id, fileName){location.href='[% url_prefix %]/misDatos.pl?token=[% token %]';},
	            showMessage: function(message){  },
	            debug: true,
	            multiple: false,
	        });
    });
</script>
<section class="center-section-form">
	<fieldset>
	    <legend>
	        [% 'Detalle de ' | i18n %] <strong >[% socio_data.usr_apellido %], [% socio_data.usr_nombre %] </strong>
	    </legend>
	    
	    <dl class="">
		        [% IF socio.tieneFoto('opac') %]  
				    <dt class="inline left rightMargin" id="fotoUsuario">
				        <a class="fancylink" rel="group" href="/uploads/pictures-opac/[% socio.tieneFoto('opac') %]">
				                <img border="0" src="/uploads/pictures-opac/[% socio.tieneFoto('opac') %]"
				                      style="width: 60%; max-width: 120px;" 
				                      alt="[% socio.persona.getApellido %], [% socio.persona.getNombre %] ([% socio.getNro_socio %])"
				                      title="[% socio.persona.getApellido %], [% socio.persona.getNombre %] ([% socio.getNro_socio %])"
				                >
				            </a>
				    </dt>
	            [% END %]
	        <dt class="inline left rightMargin">[% 'Nombre/s' |  i18n %] :</dt>
	            <dd>[% socio_data.usr_nombre %]</dd>
	        <dt class="inline left rightMargin">[% 'Apellido/s' |  i18n %] :</dt>
	            <dd>[% socio_data.usr_apellido %]</dd>
	        <dt class="inline left rightMargin">[% "DNI" | i18n %] :</dt>
	            <dd>[% socio.persona.getNro_documento %]</dd>
	        <dt class="inline left rightMargin">[% "N&uacute;mero de Socio" | i18n %] :</dt>
	            <dd>[%  socio.nro_socio %]</dd>
	        <dt class="inline left rightMargin">[% "Legajo" | i18n %] :</dt>
	            <dd>[%  socio.persona.getLegajo %]</dd>
	        <dt class="inline left rightMargin">[% "Fecha de nacimiento" | i18n %] :</dt>
	            <dd>[% socio.persona.getNacimiento %]</dd>
	        <dt class="inline left rightMargin">[% 'Ciudad' |  i18n %] :</dt>
	            <dd>[% socio_data.usr_ciudad_nombre %]</dd>
	        <dt class="inline left rightMargin">[% 'Direcci&oacute;n' |  i18n %] :</dt>
	            <dd>[% socio_data.usr_calle %]</dd>
	        <dt class="inline left rightMargin">[% 'Tel&eacute;fono' |  i18n %] :</dt>
	            <dd>[% socio_data.usr_telefono %]</dd>
	        <dt class="inline left rightMargin">[% 'E-mail' |  i18n %] :</dt>
	            <dd>[% socio_data.usr_email %]</dd>
	    </dl>
	      
	    [% IF uploadPictureFromOpac %]
		    <div id="footerDatosUsuario">
		        <dl>
		            <dt>
		                <div id="file-uploader">
		                    <noscript>          
		                        <p>[% 'Please enable JavaScript to use file uploader.' | i18n %]</p>
		                        <!-- or put a simple form for upload here -->
		                    </noscript>                          
		                </div>
		            </dt>
		        </dl>
		    </div>
	    [% END %]
	    
	    <div class="form-actions">
	        [% PERL %]
	              print C4::AR::Filtros::action_link_button( 
	                                              button    => "btn btn-primary",
	                                              url       => "[% url_prefix %]/modificarDatos.pl?token=[% token %]", 
	                                              title     => "[% 'Modificar Datos' |  i18n %]",
	                                          ) ;
	
	        [% END %]
	    </div>
	
	</fieldset>
</section>
