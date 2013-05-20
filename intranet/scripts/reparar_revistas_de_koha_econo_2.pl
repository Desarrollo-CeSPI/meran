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
use C4::Modelo::CatRegistroMarcN2;
use C4::Modelo::CatRegistroMarcN2::Manager;

#Ticket #4488
#Script para reparar los campos `biblioitemnumber` , `volume` , `publicationyear` , `fasc` 
# de las revistas de Económicas. 
#Van a los campos:
#863    _i1960
#       _a1
#       _b361

 open (FILE, '../scripts/revistas.csv');
 my @lineas = <FILE>;
 
 foreach my $linea (@lineas) {
  chomp($linea);
  
  my ($id2,$volume,$publicationyear,$fasc) = split(/,/,$linea);
  
  #Buscamos el nivel2
  my $nivel2 = C4::AR::Nivel2::getNivel2FromId2($id2);
  
  if($nivel2) {
    my $marc_record = $nivel2->getMarcRecordObject();
    my $campoRevista = $marc_record->field('863');
    
    if(!$campoRevista){
        #Si existe no lo toco!! Si no existe lo agrego
        my @subcampos_array;
        
        if ($volume) {
           push(@subcampos_array, ('a' => $volume ));
        }
        if ($publicationyear) {
           push(@subcampos_array, ('i' => $publicationyear ));
        }
        if ($fasc) {
           push(@subcampos_array, ('b' => $fasc ));
        }
        
        my $new_field = new MARC::Field('863','#','#', @subcampos_array);
        $marc_record->append_fields($new_field);
        
        $nivel2->setMarcRecord($marc_record->as_usmarc);
        $nivel2->save();
    }
  }
 }
 
 close (FILE); 


1;