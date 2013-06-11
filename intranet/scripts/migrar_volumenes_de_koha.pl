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

#Ticket #3462
#Script para reparar los volumenes y descripcion de volumenes de Económicas. Van a los campos 505 g:(volumen) y 505 t: (descripción del volumen).

 open (FILE, '../scripts/volumenes.csv');
 my @lineas = <FILE>;
 
 foreach my $linea (@lineas) {
  chomp($linea);
  
  my ($id2,$volumen,$descripcion) = split(/,/,$linea);
 	
  #Buscamos el nivel2
  my $nivel2 = C4::AR::Nivel2::getNivel2FromId2($id2);
  
  if($nivel2) {
    my $marc_record = $nivel2->getMarcRecordObject();
    my $field = $marc_record->field('505');
    
    if ($field){
    #Existe el campo
        if ($volumen) {
         $field->update( 'g' => $volumen );
        }
        if ($descripcion){
         $field->update( 't' => $descripcion );
        }
    }
    else{
      #No existe el campo
       my @subcampos_array;
       if ($volumen) {
         push(@subcampos_array, ('g' => $volumen ));
       }
      
       if ($descripcion){
         push(@subcampos_array, ('t' => $descripcion ));
       }
       my $new_field = new MARC::Field('505','#','#', @subcampos_array);
       $marc_record->append_fields($new_field);
      }
    
    #AHORA LIMPIAMOS!!
    
    my $field_440 = $marc_record->field('440');
    
    if ($field_440){
      if($field_440->subfield('v') == $marc_record->subfield('505','g')){
        #Se borra el 440a
          $field_440->delete_subfield(code => 'v');
        }
      
      if($field_440->subfield('p') == $marc_record->subfield('505','t')){
        #Se borra el 440p
          $field_440->delete_subfield(code => 'p');
        }
       if( ! $field_440->subfields() ){
        #Si el campo 440 quedo sin subcampos lo eliminamos.
          $marc_record->delete_field($field_440);
         }
    }

    print "ID2 = ".$id2."\n";
    print $marc_record->as_formatted."\n\n";
        
    $nivel2->setMarcRecord($marc_record->as_usmarc);
    $nivel2->save();
  }
 }
 close (FILE); 


1;