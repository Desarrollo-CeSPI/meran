#!/usr/bin/perl
#
# Meran - MERAN UNLP is a ILS (Integrated Library System) wich provides Catalog,
# Circulation and User's Management. It's written in Perl, and uses Apache2
# Web-Server, MySQL database and Sphinx 2 indexing.
# Copyright (C) 2009-2013 Grupo de desarrollo de Meran CeSPI-UNLP
#
# This file is part of Meran.
#
# Meran is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Meran is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Meran.  If not, see <http://www.gnu.org/licenses/>.
#
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

eval{ 
    ($cant_total)                   =   C4::AR::Nivel3::detalleCompletoOPAC($idNivel1, $t_params);
    $t_params->{'cant_total'}       = $cant_total;
};

if ($@){
   $t_params->{'mensaje'}          = "Ha ocurrido un error al intentar mostrar el detalle del registro";
}

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