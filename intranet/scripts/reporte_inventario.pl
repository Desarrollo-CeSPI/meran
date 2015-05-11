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

use C4::AR::Nivel3;
use C4::Context;
use C4::Modelo::CatRegistroMarcN1;
use C4::Modelo::CatRegistroMarcN1::Manager;
use C4::Modelo::CatRegistroMarcN2;
use C4::Modelo::CatRegistroMarcN2::Manager;
use C4::Modelo::CatRegistroMarcN3;
use C4::Modelo::CatRegistroMarcN3::Manager;

# REPORTE
#A los efectos de revisar el catálogo y responder a la auditoría de UNLP, necesitamos un reporte en Excel con los siguientes datos:
#FECHA - INVENTARIO - AUTOR - TÍTULO - EDICIÓN - EDITOR - AÑO.

my $ui = $ARGV[0] || "DEO";
my $tipo = $ARGV[1] || "LIB";
my $desde = $ARGV[2] || "00001";

my @head=(
    'FECHA',
    'INVENTARIO',
    'AUTOR',
    'TÍTULO',
    'EDICIÓN',
    'EDITOR',
    'AÑO');

print join('#', @head);
print "\n";

my $ejemplares = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(
                                                                        query => [ 
                                                                            codigo_barra => { ge => $ui."-".$tipo."-".$desde },
                                                                            codigo_barra => { like => $ui."-".$tipo."-%"},
                                                                            ],
                                                                        sort_by => 'codigo_barra ASC'
                                                                );


foreach my $nivel3 (@$ejemplares){

    my @ejemplar=();

    $ejemplar[0] = $nivel3->getCreatedAt_format();
    $ejemplar[1] = $nivel3->getCodigoBarra();
    $ejemplar[2] = $nivel3->nivel1->getAutor();
    $ejemplar[3] = $nivel3->nivel1->getTitulo();

    $ejemplar[4] = $nivel3->nivel2->getEdicion();
    $ejemplar[5] = $nivel3->nivel2->getEditor();
    $ejemplar[6] = $nivel3->nivel2->getAnio_publicacion();

    print join('#', @ejemplar);
    print "\n";
}


1;