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
use lib qw(/usr/local/share/meran/dev/intranet/modules/ /usr/local/share/meran/main/intranet/modules/C4/Share/share/perl/5.10.1/ /usr/local/share/meran/main/intranet/modules/C4/Share/lib/perl/5.10.1/ /usr/local/share/meran/main/intranet/modules/C4/Share/share/perl/5.10/ /usr/local/share/meran/main/intranet/modules/C4/Share/share/perl/5.10.1/ /usr/local/share/meran/main/intranet/modules/C4/Share/lib/perl5/);

use C4::AR::Nivel2;
use C4::Context;
use C4::Modelo::CatRegistroMarcN1;
use C4::Modelo::CatRegistroMarcN1::Manager;
use C4::Modelo::CatRegistroMarcN2;
use C4::Modelo::CatRegistroMarcN2::Manager;

# REPORTE
# Necesitamos un reporte de revistas en Excel que contenga los siguientes campos:
# 995$t Signatura topográfica
# 110$a Autor corporativo
# 110$b Entidad subordinada
# 245$a Título
# 245$b Resto del título
# 995$f Inventario
# 995$e Estado


my @head=('Signatura topográfica','Autor corporativo','Entidad subordinada','Título','Resto del título','Inventario','Estado');
print join('¬', @head);
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

    $revista[1] = "";
    $ref_autor      = $marc_record1->subfield("110","a");
    $ref            = C4::AR::Catalogacion::getRefFromStringConArrobas($ref_autor);
    if ($ref){
        $revista[1]    = C4::Modelo::CatAutor->getByPk($ref)->getCompleto();
    }
    
    $revista[2] = "";
    $ref_autor      = $marc_record1->subfield("110","b");
    $ref            = C4::AR::Catalogacion::getRefFromStringConArrobas($ref_autor);
    if ($ref){
        $revista[1]    = C4::Modelo::CatAutor->getByPk($ref)->getCompleto();
    }

    $revista[3] = $marc_record1->subfield('245','a');
    $revista[4] = $marc_record1->subfield('245','b');

    my $ejemplares = C4::AR::Nivel3::getNivel3FromId1($nivel1->getId1);
    
    foreach my $ej (@$ejemplares){
        my $marc_record3 = $ej->getMarcRecordObject();

        $revista[0] = $marc_record3->subfield('995','t');
        $revista[5] = $marc_record3->subfield('995','f');
        $revista[6] = $ej->getEstadoObject()->getNombre();
        print join('¬', @revista);
        print "\n";
    }

}


1;