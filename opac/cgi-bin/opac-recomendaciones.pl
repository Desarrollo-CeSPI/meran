#!/usr/bin/perl
use strict;
require Exporter;
use CGI;
use C4::AR::Auth;


my $input=new CGI;

my $mensaje = $input->param('mensaje');

my ($template, $session, $t_params)= get_template_and_user({
                                template_name => "opac-main.tmpl",
                                query => $input,
                                type => "opac",
                                authnotrequired => 1,
                                flagsrequired => {  ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    tipo_permiso => 'general',
                                                    entorno => 'adq_opac'},
                 });

$t_params->{'combo_tipo_documento'} = &C4::AR::Utilidades::generarComboTipoNivel3();
$t_params->{'content_title'} = C4::AR::Filtros::i18n("Recomendaciones");
$t_params->{'user_id'} = $session->param('nro_socio');  
$t_params->{'partial_template'} = "opac-recomendaciones.inc";
$t_params->{'mensaje'} = $mensaje;
C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
