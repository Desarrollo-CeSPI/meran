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

use C4::AR::Nivel2;
use C4::Context;
use C4::Modelo::CatRegistroMarcN1;
use C4::Modelo::CatRegistroMarcN1::Manager;
use C4::Modelo::CatRegistroMarcN2;
use C4::Modelo::CatRegistroMarcN2::Manager;

# REPORTE
# Necesitamos un reporte de revistas en Excel que contenga los siguientes campos:
# Título(245,a)
# Título informativo(245,b)
# Título anterior(247,a - 247,b)
# Nota compleja sobre título anterior(547,a)
# Autor corporativo (110,a)
# ISSN(022,a)
# Frecuencia(310,b)
# Lugar(260,a)
# Editor(260,b)
# Procedencia(541,c también buscar en 859,e. Este campo puede contener: COM, CAN, DON)
# URL(856,u)


my @head=('Título','Título informativo','Título anterior','Nota compleja sobre título anterior','Autor corporativo','ISSN','Frecuencia','Lugar','Editor','Procedencia','URL');
print join('#', @head);
print "\n";

my $revistas = C4::Modelo::CatRegistroMarcN1::Manager->get_cat_registro_marc_n1(
                                                                        query => [ 
                                                                                    template => { eq => 'REV' },
                                                                            ],  
                                                                );


foreach my $nivel1 (@$revistas){

    my @revista=();
    #URL
    my $marc_record1 = $nivel1->getMarcRecordObject();
    
    $revista[0] = $marc_record1->subfield('245','a');
    $revista[1] = $marc_record1->subfield('245','b');
    $revista[2] = $marc_record1->subfield('247','a');

    if ($marc_record1->subfield('247','b') ) {
        $revista[2] .= " - ".$marc_record1->subfield('247','b');
    }

    $revista[3] = $marc_record1->subfield('547','a');
    $revista[4] =  $nivel1->getAutor(); #$marc_record1->subfield('110','a');

    my $grupos = C4::AR::Nivel2::getNivel2FromId1($nivel1->getId1);
    
    foreach my $grupo (@$grupos){
        my $marc_record2 = $grupo->getMarcRecordObject();
        if (($marc_record2->subfield('022','a')) && (!$revista[5])){
            $revista[5] = $marc_record2->subfield('022','a');
        }
        if (($marc_record2->subfield('260','a')) && (!$revista[7])){

            $revista[7] = $grupo->getCiudadObject()->getNombre;
        }
        if (($marc_record2->subfield('260','b')) && (!$revista[8])){
            $revista[8] = $marc_record2->subfield('260','b');
        }
        if (($marc_record2->subfield('541','c')) && (!$revista[9])){
            $revista[9] = $marc_record2->subfield('541','c');
        } 
        if((!$revista[9])&&($marc_record2->subfield('859','e'))) {
            $revista[9] = $marc_record2->subfield('859','e');
        }
    }

    $revista[6] = $marc_record1->subfield('310','a');
    $revista[10] = $marc_record1->subfield('856','u');

    print join('#', @revista);
    print "\n";
}


1;