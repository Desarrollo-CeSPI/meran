#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;

use CGI;
use C4::AR::VisualizacionOpac;

my $input = new CGI;

my %params_combo;

my ($template, $session, $t_params)= get_template_and_user({
							template_name => "catalogacion/visualizacionOPAC/visualizacionOpac.tmpl",
							query => $input,
							type => "intranet",
							authnotrequired => 0,
							flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'CONSULTA', 
                                                entorno => 'undefined'},
							debug => 1,
			     });


#$t_params->{'combo_perfiles'}   = C4::AR::Utilidades::generarComboDePerfilesOPAC($t_params);
$params_combo{'onChange'}                       = 'eleccionDeEjemplar()';
$params_combo{'default'}                        = 'SIN SELECCIONAR';
$t_params->{'combo_perfiles'}                   = C4::AR::Utilidades::generarComboTipoNivel3(\%params_combo);
$t_params->{'page_sub_title'}                   = C4::AR::Filtros::i18n("Catalogaci&oacute;n - Visualizaci&oacute;n del OPAC");

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
