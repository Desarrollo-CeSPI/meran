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

use CGI::Session;
use C4::Context;
use  C4::AR::ImportacionIsoMARC;

my $tt1 = time();
my $id = $ARGV[0] || 1;


    
    my $importacion = C4::AR::ImportacionIsoMARC::getImportacionById($id);

    my $registros_importar = $importacion->getRegistros();

    foreach my $io_rec (@$registros_importar){
		contarEjemplares($io_rec);
    }

sub contarEjemplares {
    my ($registro) = @_;
   
    my $detalle = C4::AR::ImportacionIsoMARC::getNivelesFromRegistro($registro->getId());

    #Son revistas?
    if ( C4::AR::ImportacionIsoMARC::getTipoDocumentoFromMarcRecord_Object($detalle->{'grupos'}->[0]->{'grupo'})->getId_tipo_doc() eq 'REV') {
        my ($cantidad_ejemplares, $nuevos_grupos ) =  C4::AR::ImportacionIsoMARC::procesarRevistas($detalle->{'grupos'});
        $detalle->{'grupos'} = $nuevos_grupos;
        $detalle->{'total_ejemplares'} = $cantidad_ejemplares;
    }
    $registro->setDetalle($detalle->{'total_ejemplares'});
    $registro->save();
}