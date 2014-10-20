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
use MARC::Record;
use C4::Modelo::CatRegistroMarcN1;
use C4::Modelo::CatRegistroMarcN1::Manager;

my $nivel1_array_ref = C4::AR::Nivel1::getNivel1Completo();
my $cambios = 0;
foreach my $nivel1 (@$nivel1_array_ref){

    my $marc_record = MARC::Record->new_from_usmarc($nivel1->getMarcRecord());
    my $nota = C4::AR::Utilidades::escapeData($marc_record->subfield("500","a"));


    if ($nota){
        #Quito <>
        my $nota_orig = $nota;
        $nota=~ s/(<|>|&lt;|&gt;)//gi;
        if($nota ne $nota_orig ){
                print $nota."\n";
                $marc_record->field('500')->update( "a" => $nota );
                $nivel1->setMarcRecord($marc_record->as_usmarc());
                $nivel1->save();
                $cambios++;
        }
    }
}

print "\n Se cambiaron ".$cambios." notas. \n";
1;