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
use C4::AR::Auth;
use CGI;

my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user({
                    template_name   => "usuarios/reales/agregarUsuario.tmpl",
                    query           => $input,
                    type            => "intranet",
                    authnotrequired => 0,
                    flagsrequired   => {    ui => 'ANY', 
                                            tipo_documento => 'ANY', 
                                            accion => 'ALTA', 
                                            entorno => 'usuarios',
                                            tipo_permiso => 'catalogo'
                                            
                    },
                    debug           => 1,
                });

my $comboDeCategorias           = C4::AR::Utilidades::generarComboCategoriasDeSocio();
my $comboDeTipoDeDoc            = C4::AR::Utilidades::generarComboTipoDeDocConValuesIds();
my $comboDeUI                   = C4::AR::Utilidades::generarComboUI();
my $comboDeCredentials          = C4::AR::Utilidades::generarComboDeCredentials();
my $comboDeEstados              = C4::AR::Utilidades::generarComboDeEstados();

$t_params->{'combo_tipo_documento'} = $comboDeTipoDeDoc;
$t_params->{'comboDeCategorias'}    = $comboDeCategorias;
$t_params->{'comboDeCredentials'}   = $comboDeCredentials;
$t_params->{'comboDeEstados'}       = $comboDeEstados;
$t_params->{'comboDeUI'}            = $comboDeUI;
$t_params->{'addBorrower'}          = 1;
$t_params->{'cumple_requisito_on'}  = C4::AR::Preferencias::getValorPreferencia("requisito_necesario")||0;


$t_params->{'page_sub_title'}   = C4::AR::Filtros::i18n("Agregar Usuario");
C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);