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

my ($template, $session, $t_params) = get_template_and_user ({
                                        template_name   => 'estantes/verDetalleEstante.tmpl',
                                        query       => $input,
                                        type        => "intranet",
                                        authnotrequired => 0,
                                        flagsrequired => {  ui => 'ANY', 
                                                            tipo_documento => 'ANY', 
                                                            accion => 'CONSULTA', 
                                                            entorno => 'undefined'},
                                        debug => 1,
                 });

my $estantes_publicos = C4::AR::Estantes::getListaEstantesPublicos();
$t_params->{'cant_estantes'}= @$estantes_publicos;
$t_params->{'ESTANTES'}= $estantes_publicos;

my $id_estantes=$input->param('id_estante');
my $estante = C4::AR::Estantes::getEstante($id_estantes);
if($estante){
  my $aux_estante = $estante;
  my @lista_estantes;
  while ($aux_estante){
    unshift(@lista_estantes,$aux_estante);
    if($aux_estante->getPadre){
      $aux_estante= $aux_estante->estante_padre;
    }else{
      $aux_estante=0;
    }
  }
  $t_params->{'LISTA_ESTANTES'}= \@lista_estantes;
}
C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);