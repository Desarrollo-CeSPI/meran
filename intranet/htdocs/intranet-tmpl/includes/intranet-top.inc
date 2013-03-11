<!doctype html>
<html>
	<head>
	[% INCLUDE "message_INTRA.inc" %]
	<script type="text/javascript">
	//     <!-- variables de entorno sacadas de las preferencias del sistema -->
	    token       = '[% token %]';
	    imagesForJS = '[% temas %]/[% tema %]/imagenes';
	    M_LIMITE_RESULTADOS = [% limite_resultados_autocompletables %] + 0;
	    var URL_PREFIX  = '[% url_prefix %]';
	    var UNLOAD		= '[% unload_alert %]';
	    var mensajes_interval_id;
	    var loaderPath = '<img src="'+imagesForJS+'/loaders/loader_facebook.gif"'+'>';
	    var reading_dm = false;
    	var es_avanzada = [% IF advanced %] true [% ELSE %] false [% END %];
	    
	</script>
	
	[% IF page_sub_title %]
	    <title>Meran::UNLP::[% page_sub_title %]</title>
	[% ELSE %]
	    <title>Meran::UNLP</title>
	[% END %]
	
	<meta charset="utf-8" />
	<meta http-equiv="cache-control" content="public">

	<meta name="viewport" content="width=device-width, initial-scale=1.0">

	<script type="text/javascript" src="/includes/json/jsonStringify.js"></script>
	<script type="text/javascript" src="/includes/completo-intranet-top.js"></script>
	[% INCLUDE "BootstrapToolkit.inc" %]

    <link rel="shortcut icon" href="/includes/css/favicon.ico">
	<link rel="stylesheet" href="/includes/jquery/fancybox/fancybox.css" type="text/css" media="screen" />
    
	<link rel="stylesheet" type="text/css" href="[% temas %]/default/includes/intranet.css">
	<link rel='stylesheet' media='screen and (max-width: 900px)' href="[% temas %]/default/includes/intra-FF_fix.css" />

  <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
  <!--[if lt IE 9]>
    <script src="//html5shim.googlecode.com/svn/trunk/html5.js"></script>
  <![endif]-->

	<script type="text/javascript" src="/includes/jquery/jquery-ui-1.8.9.custom.min.js"></script>
	<script type="text/javascript" src="/includes/jquery/jquery.expander.js"></script>
	<script type="text/javascript" src="/includes/jquery/jquery.nanoscroller.js"></script>

	<script type="text/javascript" src="/includes/jquery/fancybox/fancybox.js"></script>

	<script type="text/javascript" src="/includes/workers.js"></script>
	<script type="text/javascript" src="/includes/intranet-top.js"></script>
	<script type="text/javascript" src="/includes/jquery/jquery-ui-1.8.13.sortable.min.js"></script>
	
	<script type="text/javascript">

		var worker = new Worker('/includes/workers.js');
		var id_actual_dm = 0;
		var click_responder = 0;


	  function publicar_twitter(){
            objAH               = new AjaxHelper(updatePublicarTwitter);
            objAH.debug         = true;
            objAH.url           = URL_PREFIX+'/twitter.pl';
            
            objAH.tipoAccion    = "PUBLICAR_TWITTER";
            objAH.post          = $("#post_twitter").val();
            objAH.sendToServer();
	        $('#show_twitter').modal('hide');
            startOverlay();
    }

	   function updatePublicarTwitter(responseText){
	      if (!verificarRespuesta(responseText))
	                return(0);
	        var text=JSONstring.toObject(responseText).messages[0].message;
	        $("#twitter_result").html('<a class="close" data-dismiss="alert">×</a>'+text);
	        $("#twitter_result").alert();
	        $("#twitter_result").show();
	        closeModal();
	  }

	  function enableDisableButton(){
		  var chars = $('#post_twitter').val().length;
		  
		  if (chars > 140){
			  $('#publicar_twitter').attr('disabled','');
		      $('#publicar_twitter').removeClass("btn-primary");
		  }else{
	    	  $('#publicar_twitter').removeAttr('disabled');
	          $('#publicar_twitter').addClass("btn-primary");
		  }
	  }

	    function showNovedad(id){

			var objAH_novedadIntra	 		= new AjaxHelper(updateShowNovedadIntra);
			objAH_novedadIntra.showOverlay  = true;
			objAH_novedadIntra.debug        = true;
			objAH_novedadIntra.url          = '[% url_prefix %]/admin/global/ver_novedad_intra.pl';
			objAH_novedadIntra.id			= id;
			objAH_novedadIntra.sendToServer();
		}

		function updateShowNovedadIntra(responseText){
		    if (!verificarRespuesta(responseText))
		        return(0);

		    $('#mostrar_novedad').html(responseText);
		    $('#mostrar_novedad').modal();
		}
				
		function enableAlert(){
		    $(window).bind('beforeunload', function(){ 
		    	return("[% 'ATENCION: Se perderan los elementos que no haya guardado' | i18n %]");
		    });
		}

		function disableAlert(){
		    $(window).unbind('beforeunload');
		}


		function swap(id,src){
			   document.getElementById(id).src=src;
		}

		function cambiarIdioma() {
			$('#lang_server').val($('#language').val());
			$('#url').val(location.pathname);
			$('#formLang').submit();
		}
			
		function searchesText(objectId){
			
			var text              = [% "'Que quiere buscar?'" | i18n %];
			var search            =  $('#'+objectId);
			
		    if ($.trim(search.val()) == ''){
		    	search.val(text);
		    	search.addClass("search-title");
		    }
		}

		function searchBoxFocus(object){	
		    object.value='';
		}


		function mostrarNovedades(){
		    var objAH_temp               = new AjaxHelper(updateActualizarTabla);
		    objAH_temp.debug         = false;
		    objAH_temp.showStatusIn  = '';
		    objAH_temp.url           = URL_PREFIX+'/novedadesIntra.pl';
		    objAH_temp.tipoAccion    = "MOSTRAR_NOVEDADES";
		    objAH_temp.sendToServer();
		}

		function mensajesContacto(){
			if (!reading_dm){
		        var objAH_temp               = new AjaxHelper(updateMensajesContacto);
		        objAH_temp.debug         = false;
		        this.showState      = false;
		        objAH_temp.url           = URL_PREFIX+'/mensajes_contacto.pl';
		        objAH_temp.sendToServer();
			}
		}

		function revisionesPendientes(){
	        var objAH_temp               = new AjaxHelper(updateRevisionesPendientes);
	        objAH_temp.debug         = false;
	        this.showState      = false;
	        objAH_temp.url           = URL_PREFIX+'/admin/catalogo/revisiones_pendientes_check.pl';
	        objAH_temp.sendToServer();
		}

		function updateRevisionesPendientes(responseText){
			$('#revisiones_pendientes_alert').html(responseText);
		}

		function updateMensajesContacto(responseText){
			$('#mensajes_contacto').html(responseText);
		}

		function updateActualizarTabla(responseText){
		    $("#resultNovedades").html(responseText);
		}

		function responder(){
			if (click_responder == 0){
				$("#respuesta").wysiwyg();
			    $(".responder").show(); 
                $("#btn_responder").hide();
                $("#btn_enviar").show();
			    $(".wysiwyg").css('width','388px');   
			    $("#fancybox-wrap").css('top','25px');
			    $("#respuestaIFrame").css('width','388px');
			    $("#responder").attr('onclick', ' ');
			    click_responder	= 1;
			} 
		}
				
		function checkTr(){
		    // click sobre los <tr>, para darle estilo
		    $('tr').click(function() {
		        var clase = $(this).attr('class');
		        // solo los <tr> que tengan en el primer <td> un input checkbox
		        if($(this).children(':first-child').children(':first-child').attr('type') == 'checkbox'){
		            // ahora los tr no tienen clase por defecto
		            // la primera vez 'clase' es null	                
		            if(clase == null || clase == ""){
		                $(this).addClass("marked");
		                //pintamos el <td> por el nuevo css bootstrap
		                $(this).children().addClass("marked")
		                $(this).children(':first-child').children(':first-child').attr('checked','true');
		            }else{
		                $(this).removeClass("marked"); 
		                //pintamos el <td> por el nuevo css bootstrap
		                $(this).children().removeClass("marked")
		                $(this).children(':first-child').children(':first-child').removeAttr('checked');
		            }
		        }
		    });     
		}

		function responderMail(){
		    closeDM();
		    objAH                     = new AjaxHelper(updateResponderMail);
		    objAH.url                 = URL_PREFIX+'/admin/rta_mensaje_contacto.pl';
		    objAH.showOverlay         = true;
		    objAH.debug               = true;
		    objAH.texto               = $('#respuesta').val();
		    objAH.asunto              = $('#asunto').val();
		    objAH.email               = $('#email').val();
		    objAH.dm_id			      = id_actual_dm; 
		    objAH.mensaje_contacto    = $('.modal-body :first-child').html();
        	objAH.sendToServer();
        
	  }
		  
		  function updateResponderMail(responseText){
		      if (!verificarRespuesta(responseText))
		              return(0);
		      var Messages=JSONstring.toObject(responseText);
		      setMessages(Messages);
		      
		  }
		  
		function showDirectMessage(id){

			var objAH_novedad      	 		= new AjaxHelper(updateShowDirectMessage);
			id_actual_dm					= id;
			objAH_novedad.showOverlay       = true;
			objAH_novedad.debug             = true;
			objAH_novedad.url               = '[% url_prefix %]/admin/ver_mensaje.pl';
			objAH_novedad.id				= id;
			objAH_novedad.sendToServer();
		}

		function updateShowDirectMessage(responseText){
		    if (!verificarRespuesta(responseText))
		        return(0);

			reading_dm = true;
		    $('#mostrar_mensaje').html(responseText);
		    $('#mostrar_mensaje').modal();
		    $('#mostrar_mensaje').on('hidden', function () {
		    	  closeDM();
		    	  click_responder = 0;
	    	 });
		}		

		  
		function showTwitter(responseText){
		    $('#show_twitter').modal('show');
	        $('#post_twitter').val('');
	        $('#post_twitter').focus();
		    		    
		}
				
		function closeDM(){
			reading_dm = false;
			$('#mostrar_mensaje').modal('hide');
		}
				
		$(document).ready(function(){
			checkTr();
			$('.tooltip_link').tooltip({delay: { show: 1000, hide: 100 },});
			$('.popover_button').popover({delay: {show: 200,  hide: 100 }, trigger: 'hover'});
			$(".alert").alert();
			$(".collapse").collapse({toggle: false,});
	        $('.dropdown-toggle').dropdown();
	        $('.fancy_link').fancybox();
	        
			if (UNLOAD == 1)
				enableAlert();
			else
		        disableAlert();


	    });
	</script>
	
	</head>
	<body data-spy="scroll" data-spy="scroll" data-target=".side_bar">
	  <noscript>
	      <div class='tableMsgUser'>
	          <font class='fontMsgUser'>
	                  <b>[% 'Su navegador no soporta o no tiene habilidato Javascript' | i18n %]</b>
	          </font>
	      </div>
	  </noscript>
	  
	  <div id="ajax-indicator" class="modal hide fade loading">
			<div class="circle"></div>
			<div class="circle1"></div>
  	  </div>

	  <header>
	  	[% INCLUDE  'menu.inc'  %]
	  </header>
	  <div id="navBarResult">
	    [% INCLUDE 'detalleSideBar.inc' %]
	  </div>
	     <div id="marco_principal" class="container">   
			  <div id="marco_contenido_datos" class="contenido">
				  <!--  usado como referencia por el MessageHelper -->
				  <div id="end_top">
				    [% IF mensaje %]
							<div class="alert [% mensaje_class %]">
							        <strong>[% 'Informaci&oacute;n' | i18n %]</strong> [% mensaje %]
							</div>
				    [% END %]
				  </div>
		
				<div id="confirmar_div" class="modal hide fade"></div>
			    <div id="basic-modal-content" class="modal hide fade"></div>
