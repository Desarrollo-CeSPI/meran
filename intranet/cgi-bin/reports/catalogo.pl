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

my $comboEstados= C4::AR::Utilidades::generarComboEstadoEjemplares();
$t_params->{'estados_combo'} = $comboEstados;

$t_params->{'item_type_combo'} = C4::AR::Utilidades::generarComboTipoNivel3(\%params_for_combo);
$t_params->{'ui_combo'} = C4::AR::Utilidades::generarComboUI();

my $comboNivelBibliografico = C4::AR::Utilidades::generarComboNivelBibliografico();
$t_params->{'comboNivelBibliografico'} = $comboNivelBibliografico;

my $comboEstantesVirtuales = C4::AR::Utilidades::generarComboEstantes();
$t_params->{'comboEstantesVirtuales'} = $comboEstantesVirtuales;


C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);