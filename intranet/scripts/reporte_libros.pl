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

#Reporte de LIBROS, ordenado por SIG. TOP (si se puede, sino lo hacemos desde Excel)

#Campos requeridos:
#080$a CDU
#100$a Autor
#110$a Autor corporativo
#110$b Entidad subordinada
#111$a Nombre de la reunión
#111$c Lugar de la reunión
#111$d Fecha de la reunión
#245$a Título
#245$b Resto del título
#700$a Autor secundario 700$e Función
#856$u URL
#250$a Edición
#260$a Lugar/edit/fecha
#505$g volumen
#505$t Título
#995$f Inventario
#995$t Signatura
#995$o Disponibilidad
#995$e Estado
#900$g Responsable carga



my @head=(
    'Signatura',
    'CDU',
    'Autor',
    'Autor corporativo',
    'Entidad subordinada',
    'Nombre de la reunión',
    'Lugar de la reunión',
    'Fecha de la reunión',
    'Título',
    'Resto del título',
    'Autor secundario/Función',
    'URL',
    'Edición',
    'Lugar/edit/fecha',
    'Volumen',
    'Descripción',
    'Inventario',
    'Disponibilidad',
    'Estado',
    'Responsable de Carga');

print join('#', @head);
print "\n";

my $ejemplares = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(
                                                                        query => [ 
                                                                                    template => { eq => 'LIB' },
                                                                            ],
                                                                        sort_by => 'signatura ASC'
                                                                );


foreach my $nivel3 (@$ejemplares){

    my @ejemplar=();
    #URL
    my $marc_record1 = $nivel3->nivel1->getMarcRecordObject();
    my $marc_record2 = $nivel3->nivel2->getMarcRecordObject();
    my $marc_record3 = $nivel3->getMarcRecordObject();

    $ejemplar[0] = $nivel3->getSignatura();
    $ejemplar[1] = $marc_record1->subfield('080','a');

    my $ref_autor= $marc_record1->subfield("100","a");
    my $ref      = C4::AR::Catalogacion::getRefFromStringConArrobas($ref_autor);
    my $autor    = C4::Modelo::CatAutor->getByPk($ref);
    if($autor){
        $ejemplar[2] = $autor->getCompleto();
    }

    my $ref_autor= $marc_record1->subfield("110","a");
    my $ref      = C4::AR::Catalogacion::getRefFromStringConArrobas($ref_autor);

    $ejemplar[3] = $marc_record1->subfield('110','a');
    $ejemplar[4] = $marc_record1->subfield('110','b');

    $ejemplar[5] = $marc_record1->subfield('111','a');
    $ejemplar[6] = $marc_record1->subfield('111','b');
    $ejemplar[7] = $marc_record1->subfield('111','c');
    
    $ejemplar[8] = $marc_record1->subfield('245','a');
    $ejemplar[9] = $marc_record1->subfield('245','b');

    my @as       = $nivel3->nivel1->getAutoresSecundarios();
    $ejemplar[10] = join(' - ', @as);

    $ejemplar[11] = $marc_record1->subfield('856','u');

    $ejemplar[12] = $marc_record2->subfield('250','a');
    
    my $ciudad = $nivel3->nivel2->getCiudadObject();
    if ($ciudad){
         $ejemplar[13] = $ciudad->getNombre();
    }

    if ($marc_record2->subfield('260','b')) {
        if ($ejemplar[13]) {
            $ejemplar[13] = $ejemplar[13]." / ";
        }
        $ejemplar[13] = $ejemplar[13].$marc_record2->subfield('260','b');
    }
    
    if ($marc_record2->subfield('260','c')) {
        if ($ejemplar[13]) {
            $ejemplar[13] = $ejemplar[13]." / ";
        }
        $ejemplar[13] = $ejemplar[13].$marc_record2->subfield('260','c');
    }

    $ejemplar[14] = $marc_record2->subfield('505','g');
    $ejemplar[15] = $marc_record2->subfield('505','t');

    $ejemplar[16] = $nivel3->getCodigoBarra();


    if($nivel3->getDisponibilidadObject()){
        $ejemplar[17] = $nivel3->getDisponibilidadObject()->getNombre();
    }

    $ejemplar[18] = $nivel3->getEstado();
    $ejemplar[19] = $marc_record3->subfield('900','g');

    print join('#', @ejemplar);
    print "\n";
}


1;