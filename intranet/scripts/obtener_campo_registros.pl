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
use C4::Modelo::CatRegistroMarcN1::Manager;
use MARC::Record;
use C4::AR::Utilidades;

my $niveles1 = C4::Modelo::CatRegistroMarcN1::Manager->get_cat_registro_marc_n1( query => \@filtros );
my $campo = $ARGV[0];
my $subcampo = $ARGV[1];


open (FILE, '>/usr/share/meran/campo_'.$campo.'$'.$subcampo.'txt');
foreach my $nivel1 (@$niveles1 ){
    my $flag = 0;
    my $marc_record = MARC::Record->new_from_usmarc($nivel1->getMarcRecord());
    my @values = $marc_record->subfield($campo, $subcampo);
    foreach my $value (@values){

       if (C4::AR::Utilidades::validateString($value)){
         if (!$flag){
            print FILE $marc_record->subfield("245","a").":\n";
            $flag = 1;
         }
           print FILE "         ".$value."\n";
       }
    }
}
close (FILE);
1;