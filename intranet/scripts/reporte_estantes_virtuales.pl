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

use C4::AR::Reportes;
use C4::Context;

my $reporte = C4::AR::Reportes::reporteContenidoEstantesVirtuales();


# REPORTE
#Materia y Materia (anexo)
#Título
#Autor
#Edición (o año)
#Cantidad de ejemplares: SALA DE LECTURA
#Cantidad de ejemplares: DOMICILIARIO


my @head=('Estante Padre','Estante','Título','Autor','Edición','Ejemplares Domicilio','Ejemplares Sala');
print join('#', @head);
print "\n";

foreach my $contenido (@$reporte){

    my @estante=();
    $estante[0] = $contenido->{"padre"};
    $estante[1] = $contenido->{"estante"};
    $estante[2] = $contenido->{"titulo"};
    $estante[3] = $contenido->{"autor"};
    $estante[4] = $contenido->{"edicion"}; 
    $estante[5] = $contenido->{"cantPrestamo"}; 
    $estante[6] = $contenido->{"cantSala"};

    print join('#', @estante);
    print "\n";
}


1;