#!/usr/bin/perl
use strict;
require Exporter;
use CGI;
use C4::AR::Auth;


my $input = new CGI;
my $ajax  = $input->param('ajax') || 0;
my ($template, $session, $t_params) = get_template_and_user({
								template_name   => ($ajax?"includes/opac-detail.inc":"opac-main.tmpl"),
								query           => $input,
								type            => "opac",
								authnotrequired => 1,
								flagsrequired   => {  ui            => 'ANY', 
                                                    tipo_documento  => 'ANY', 
                                                    accion          => 'CONSULTA', 
                                                    entorno         => 'undefined',
							                        tipo_permiso    => 'catalogo'},
			     });

my $idNivel1 = $input->param('id1');

$t_params->{'id2'} = $input->param('id2') || 0;
my $cant_total      = 0;

#eval{ 
    ($cant_total)                   =   C4::AR::Nivel3::detalleCompletoOPAC($idNivel1, $t_params);
    $t_params->{'cant_total'}       = $cant_total;
#};

#if ($@){

#    $t_params->{'mensaje'}          = "Ha ocurrido un error al intentar mostrar el detalle del registro";

#}

$t_params->{'partial_template'}             = "opac-detail.inc";
$t_params->{'preferencias'}                 = C4::AR::Preferencias::getConfigVisualizacionOPAC();
$t_params->{'per_page'}                     = C4::Context->config("cant_grupos_per_query") || 5;
$t_params->{'ajax'}                         = $ajax;
$t_params->{'pref_e_documents'}             = C4::AR::Preferencias::getValorPreferencia("e_documents");
$t_params->{'mostrar_ui_opac'}              = C4::AR::Preferencias::getValorPreferencia("mostrar_ui_opac");
$t_params->{'mostrarDetalleDisponibilidad'} = C4::AR::Preferencias::getValorPreferencia("mostrarDetalleDisponibilidad");
$t_params->{'mostrarSignaturaEnDetalleOPAC'}= C4::AR::Preferencias::getValorPreferencia("mostrarSignaturaEnDetalleOPAC");
$t_params->{'informar_error'}               = C4::AR::Preferencias::getValorPreferencia("problem_catalog_opac");
$t_params->{'nav_elements'}                 = C4::AR::Nivel2::buildNavForGroups($t_params);

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
