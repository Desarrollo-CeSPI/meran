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

my ($template, $session, $t_params) = C4::AR::Auth::get_template_and_user({
                                    template_name   => "reports/circulacion.tmpl",
                                    query           => $query,
                                    type            => "intranet",
                                    authnotrequired => 0,
                                    flagsrequired   => {  ui            => 'ANY', 
                                                        tipo_documento  => 'ANY', 
                                                        accion          => 'CONSULTA', 
                                                        entorno         => 'undefined' },
});


my %hash;
$hash{'id'}                                 = 'categoriaSocioReservas'; 

$t_params->{'comboDeCategoriasReservas'}    = C4::AR::Utilidades::generarComboCategoriasDeSocio(\%hash);
$t_params->{'comboDeCategorias'}            = C4::AR::Utilidades::generarComboCategoriasDeSocio();
$t_params->{'comboDeTipoDoc'}               = C4::AR::Utilidades::generarComboTipoNivel3();
$t_params->{'comboDeTipoPrestamos'}         = C4::AR::Utilidades::generarComboTipoPrestamo();
my %params_combo;
$params_combo{'default'}            		= C4::AR::Preferencias::getValorPreferencia("defaultTipoNivel3");
my $comboTiposNivel3                		= &C4::AR::Utilidades::generarComboTipoNivel3(\%params_combo);
$t_params->{'comboTipoDocumento'}   		= $comboTiposNivel3;

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);