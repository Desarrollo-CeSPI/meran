<!DOCTYPE html>
<html lang="es-ES">

<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="cache-control" content="no-cache" />
  <meta http-equiv="expires" content="3600" />
  <meta name="revisit-after" content="2 days" />
  <meta name="robots" content="index,follow" />
  <meta name="publisher" content="Grupo Meran" />
  <meta name="copyright" content="" />
  <meta name="author" content="Grupo Meran" />
  <meta name="distribution" content="global" />
  <meta name="description" content="OPAC" />
  <meta name="keywords" content="Your keywords, keywords, keywords, here ..." />
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  
  <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
  <!--[if lt IE 9]>
    <script src="//html5shim.googlecode.com/svn/trunk/html5.js"></script>
  <![endif]-->


    <!-- Le fav and touch icons -->
    <link rel="shortcut icon" href="/includes/css/favicon.ico">
    <link rel="apple-touch-icon" href="images/apple-touch-icon.png">
    <link rel="apple-touch-icon" sizes="72x72" href="images/apple-touch-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="114x114" href="images/apple-touch-icon-114x114.png">
       
  <link rel="stylesheet" href="[% temas %]/[% user_theme %]/includes/opac.css" />
  <link rel='stylesheet' media='screen and (max-width: 900px)' href="[% temas %]/[% user_theme %]/includes/opac-FF_fix.css" />  
  <link rel="stylesheet" href="/includes/jquery/fancybox/fancybox.css" type="text/css" media="screen" />
  <link rel="stylesheet" href="/includes/css/print-opac.css" type="text/css" media="print" />

  <script type="text/javascript">
    var token               = '[% token %]';
    var imagesForJS         = '[% temas %]/[% tema %]/imagenes';
    var M_LIMITE_RESULTADOS = [% limite_resultados_autocompletables %] + "";
    var URL_PREFIX          = '[% url_prefix %]';

  </script>

  [% INCLUDE 'message_OPAC.inc' %]
  [% INCLUDE 'BootstrapToolkit.inc' %]
  <script src="/includes/AjaxHelper.js" type="text/javascript"></script>
  <script src="/includes/jquery/ui/ui-min.js" type="text/javascript"></script>
  <script src="/includes/jquery/ui/core.js" type="text/javascript"></script>
  [% INCLUDE 'AutocompleteHelper.inc' %]
  <script src="/includes/jquery/jquery.wysiwyg.js" type="text/javascript"></script>
  <script src="/includes/json/jsonStringify.js" type="text/javascript"></script>
  <script src="/includes/MessageHelper.js" type="text/javascript"></script>
  <script src="/opac-tmpl/includes/circulacionOPAC.js" type="text/javascript"></script>
  <script src="/opac-tmpl/includes/favoritos.js" type="text/javascript"></script>
  <script type="text/javascript" src="/includes/jquery/jquery.expander.js"></script>
  <script type="text/javascript" src="/includes/jquery/jquery.nanoscroller.js"></script>
  <script src="/includes/util.js" type="text/javascript"></script>
  <script src="/includes/md5.js" type="text/javascript"></script>
  <script src="/includes/sha1.js" type="text/javascript"></script>
  <script src="/includes/jsthread.js" type="text/javascript"></script>
  <script type="text/javascript" src="/includes/opac.js"></script>	
  <script type="text/javascript" src="/includes/jquery/jquery.alerts.js"></script>	
  <script type="text/javascript" src="/includes/jquery/fancybox/fancybox.js"></script>
  <script type="text/javascript" src="/includes/jquery/jquery.raty.min.js"></script>
  <script type="text/javascript" src="/includes/jquery/jquery.tmpl.js"></script>
  <script type="text/javascript" src="/includes/modernizr.js"></script>
  

  [% INCLUDE 'localized_messages.inc' %]
  <title>
    [% IF titulo_nombre_ui %]
        [% titulo_nombre_ui %]
    [% ELSE %]
        Meran - OPAC
    [% END %]
  </title>

  [% IF socio_data.usr_permisos_opac %]
        [% IF !noAjaxRequests %]
        <script type="text/javascript">

          </script>
        [% END %]
    [% END %]

    <script type="text/javascript">    

      $(document).ready(function() {
  			$('.popover_button').popover({delay: { show: 600, hide: 100 }, trigger: 'hover'});
  			$(".alert").alert();
            
                      $(function () {
                          var $alert = $('#alert_msg_main');
                          if($alert.length)
                          {
                              $alert.animate({height: $alert.css('line-height') || '50px'}, 200)
                              .click(function () {
                                  window.close;
                                  $alert.animate({height: '0'}, 200);
                              });
                          }
                      });
               [% IF portada %]
               	$('#carousel_portada_opac').carousel({
               		pause: "hover",
               		interval: 5000,
                });
            	 [% END %]
        $('#input-bar-search-opac-main').focus();   	
        });
	</script>
	
	
	</head>
	
	<!-- Global IE fix to avoid layout crash when single word size wider than column width -->
	<!--[if IE]><style type="text/css"> body {word-wrap: break-word;}</style><![endif]-->
	    
	<body lang="es-Es" data-spy="scroll" data-target=".side_bar">
	<!-- POAR AHORA ES LA NAV -->

	  <div id="ajax-indicator" class="modal hide fade loading">
			<div class="circle"></div>
			<div class="circle1"></div>
  	  </div>
	
	   [% INCLUDE 'opac-top-header.inc' %]
	   [% INCLUDE 'opac-side_bar.inc' 	%]	   
		<div class="container main_content" id="principal">	
				  <div id="end_top">
					    [% IF mensaje %]
								<div class="alert [% mensaje_class %]">
								        <strong>Info</strong> [% mensaje %]
								</div>
					    [% END %]
		  			</div>	   
			        [% IF content_title %]
			        	<fieldset>
			        		<legend>[% content_title %]</legend>
			        	</fieldset>
			        [% END %]
			        [% IF partial_template %]
			              [% INCLUDE $partial_template %]
			        [% END %]
		        
