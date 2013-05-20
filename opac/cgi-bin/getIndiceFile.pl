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
use C4::Output;
use CGI;
use C4::AR::Catalogacion;
use C4::Context;
my $input = new CGI;

#SE PONE CUALQUIER TEMPLATE PARA EL CHEQUEO DE PERMISOS, PERO EL TEMPLATE NO SE USA
my ($template, $session, $t_params)     = get_template_and_user({  
                        template_name   => "main.tmpl",
                        query           => $input,
                        type            => "opac",
                        authnotrequired => 1,
                        flagsrequired   => {  ui            => 'ANY', 
                                            tipo_documento  => 'ANY', 
                                            accion          => 'CONSULTA', 
                                            entorno         => 'CONSULTA', 
                                            tipo_permiso    => 'undefined'},
                        debug => 1,
                    });

# por si meten por URL un id no valido
eval{

    my $file_id         = $input->param('id2');
    my $eDocsDir        = C4::Context->config('edocsdir');
    my ($nivel2,$file)  = C4::AR::Catalogacion::getIndiceFile($file_id);
    my $tmpFileName     = $eDocsDir.'/'.$file;

    open INF, $tmpFileName or die "\nCan't open $tmpFileName for reading: $!\n";

    print $input->header(       -type           => $nivel2->getIndiceFileType,
                                -attachment     => C4::AR::Filtros::i18n("Indice")." - #".$nivel2->id." - ".$nivel2->nivel1->getTitulo,
                                -expires        => '0',
                        );
    my $buffer;

    #SE ESCRIBE EL ARCHIVO EN EL CLIENTE
    while (read (INF, $buffer, 65536) and print $buffer ) {};

};

# redirigimos
if($@){

    C4::AR::Auth::redirectTo(C4::AR::Utilidades::getUrlPrefix() . '/auth.pl')
  
}