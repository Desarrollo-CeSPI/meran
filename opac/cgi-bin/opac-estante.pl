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
                                        template_name   => 'opac-main.tmpl',
                                        query           => $input,
                                        type            => "opac",
                                        authnotrequired => 1,
                                        flagsrequired   => {  ui            => 'ANY', 
                                                            tipo_documento  => 'ANY', 
                                                            accion          => 'CONSULTA', 
                                                            entorno         => 'undefined'},
                                        debug           => 1,
                 });

my $id_estante = $input->param('id_estante');

C4::AR::Debug::debug("OPAC ESTANTE ==> ".$id_estante);

if(!$id_estante){
    #Si no viene estante se ven los Estantes Principales (Padre = 0)
    C4::AR::Debug::debug("OPAC ESTANTE ==> PUBLICOS");

    my $estantes_publicos             = C4::AR::Estantes::getListaEstantesPublicos();
    $t_params->{'cant_subestantes'}   = @$estantes_publicos || 0;
    $t_params->{'SUBESTANTES'}        = $estantes_publicos;
}
else{
    #Se ve un estante en particular con su contenido
    eval{
        
        my $estante                     = C4::AR::Estantes::getEstante($id_estante);

        if($estante){

            my $subEstantes                 = C4::AR::Estantes::getSubEstantes($id_estante);
            my $nombre                      = $estante->getEstante;

            # $t_params->{'estante'}          = $estante;
            $t_params->{'estante'}          = C4::AR::Estantes::getEstanteConContenido($id_estante);
            $t_params->{'SUBESTANTES'}      = $subEstantes ;
            $t_params->{'cant_subestantes'} = @$subEstantes || 0;  

        } else {
            $t_params->{'mensaje'}          = "No existe el estante";
        }   
    
    };
    if ($@){

        $t_params->{'mensaje'}              = "Ha ocurrido un error buscando los estantes";
    
    }

}

$t_params->{'content_title'}        = C4::AR::Filtros::i18n("Estantes Virtuales");
$t_params->{'partial_template'}     = "opac-estante.inc";

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
