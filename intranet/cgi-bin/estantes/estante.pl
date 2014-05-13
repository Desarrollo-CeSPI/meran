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
use CGI;
use C4::Output;
use C4::AR::Auth;

use C4::AR::Estantes;

my $input = new CGI;

my $subestante_actual;
my $padre_actual;

 
my ($template, $session, $t_params) = get_template_and_user ({
                                        template_name   => 'estantes/estante.tmpl',
                                        query       => $input,
                                        type        => "intranet",
                                        authnotrequired => 0,
                                        flagsrequired => {  ui => 'ANY', 
                                                            tipo_documento => 'ANY', 
                                                            accion => 'CONSULTA', 
                                                            entorno => 'undefined'},
                                        debug => 1,
                 });



if ($input->param('id_estante')){
  $subestante_actual  = $input->param('id_estante');
  $padre_actual       = $input->param('id_padre');
  #C4::AR::Debug::debug($padre_actual);
}


my %params_combo;
$params_combo{'default'}          = C4::AR::Preferencias::getValorPreferencia("defaultTipoNivel3");
$t_params->{'comboTipoDocumento'} = &C4::AR::Utilidades::generarComboTipoNivel3(\%params_combo);
my $estantes_publicos             = C4::AR::Estantes::getListaEstantesPublicos();
$t_params->{'subestante_actual'}  = $subestante_actual;
$t_params->{'padre_actual'}       = $padre_actual;
$t_params->{'cant_estantes'}      = @$estantes_publicos;
$t_params->{'ESTANTES'}           = $estantes_publicos;
$t_params->{'id_registro'}        = ($input->param('id_registro'))?$input->param('id_registro'):0;


C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);