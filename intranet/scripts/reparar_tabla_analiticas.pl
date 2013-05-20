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

    my $analiticas_array_ref = C4::AR::Nivel2::getAllAnaliticas();

    foreach my $analitica_object (@$analiticas_array_ref){

        my $registro_padre = $analitica_object->getAnalitica();
  
        if($registro_padre ne ""){

            C4::AR::Debug::debug("ANALITICA id1".$analitica_object->getId1()." ============= de PADRE id2".$registro_padre);

            my $cat_registro_n2_analitica = C4::Modelo::CatRegistroMarcN2Analitica->new();
            $cat_registro_n2_analitica->setId2Padre($registro_padre);
            $cat_registro_n2_analitica->setId1($analitica_object->getId1());
            $cat_registro_n2_analitica->save();
        }
    }
    

1;