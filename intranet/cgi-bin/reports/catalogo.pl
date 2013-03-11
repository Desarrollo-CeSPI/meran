#!/usr/bin/perl
use strict;
require Exporter;
use C4::AR::Auth;
use CGI;

my $query = new CGI;

my ($template, $session, $t_params)= C4::AR::Auth::get_template_and_user({
                                    template_name   => "reports/catalogo.tmpl",
                                    query           => $query,
                                    type            => "intranet",
                                    authnotrequired => 0,
                                    flagsrequired   => {  ui            => 'ANY', 
                                                        tipo_documento  => 'ANY', 
                                                        accion          => 'CONSULTA', 
                                                        entorno         => 'undefined'},
});

my $comboDeCategorias           = C4::AR::Utilidades::generarComboCategoriasDeSocio();
$t_params->{'comboDeCategorias'} =$comboDeCategorias;

my %params_for_combo = {};
$params_for_combo{'default'} = 'ALL';

my $comboDisponibilidad= C4::AR::Utilidades::generarComboDeDisponibilidad();
$t_params->{'disp_combo'} = $comboDisponibilidad;

$t_params->{'item_type_combo'} = C4::AR::Utilidades::generarComboTipoNivel3(\%params_for_combo);
$t_params->{'ui_combo'} = C4::AR::Utilidades::generarComboUI();

my $comboNivelBibliografico = C4::AR::Utilidades::generarComboNivelBibliografico();
$t_params->{'comboNivelBibliografico'} = $comboNivelBibliografico;

my $comboEstantesVirtuales = C4::AR::Utilidades::generarComboEstantes();
$t_params->{'comboEstantesVirtuales'} = $comboEstantesVirtuales;


C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);