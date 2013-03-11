#!/usr/bin/perl
use strict;
require Exporter;
use C4::AR::Auth;
use CGI;

my $input = new CGI;

my ($template, $session, $t_params)= C4::AR::Auth::get_template_and_user({
									template_name   => "reports/usuarios.tmpl",
									query           => $input,
									type            => "intranet",
									authnotrequired => 0,
                                    flagsrequired   => {  ui            => 'ANY', 
                                                        tipo_documento  => 'ANY', 
                                                        accion          => 'CONSULTA', 
                                                        entorno         => 'undefined'},
});


     my  $ui= $input->param('ui_name') || C4::AR::Preferencias::getValorPreferencia("defaultUI");
     my $ComboUI=C4::AR::Utilidades::generarComboUI();
     my %params;
 
     $params{'default'}= 'SIN SELECCIONAR';
     my $comboCategoriasDeSocio= C4::AR::Utilidades::generarComboCategoriasDeSocio(\%params);

  
     $t_params->{'unidades'}= $ComboUI;
     $t_params->{'categories'}= $comboCategoriasDeSocio;

     $t_params->{'regulares'} = C4::AR::Utilidades::generarComboDeEstados();


C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
