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
#Sí, Nivel2:

#440^v => 505^g

#Pero hay que tener en cuenta que solo se deben migrar los 440^v cuando el 440^a y b estén vacíos, para asegurarnos que no se esté cambiando un número que sí pertenezca a una serie. 
#Hasta ahora es el único error de migración real que apareció.

my $campo_origen = '440'; 
my $subcampo_origen = 'v'; 
my $campo_destino = '550';
my $subcampo_destino = 'g';

my $registros_array_ref = C4::AR::Nivel2::getAllNivel2();

 print "Modificando el campo 440v al 550g del nivel 2 \n";
 my $st1 = time();
 #Procesamos los registros
 my $cantidad = scalar(@$registros_array_ref);
 my $registro=1;
   foreach my $nivel (@$registros_array_ref){
         my $marc_record = MARC::Record->new_from_usmarc($nivel->getMarcRecord());
         my $porcentaje= int (($registro * 100) / $cantidad );
         print "Procesando registro: $registro de $cantidad ($porcentaje%) \r";

        my $field = $marc_record->field('440');
        if(($field)&&($field->subfield('v'))&&(!$field->subfield('a'))&&(!$field->subfield('b'))){
            #Es para migrar
            my $dato = $field->subfield('v');
            $field->delete_subfield(code => 'v');
            
            my $field_dest = $marc_record->field('550');
            
            if ($field_dest){
                #existe el campo 550
                $field_dest->add_subfields( 'g' => $dato );
                }
            else {
                my $new_field = MARC::Field->new('550','','','g' => $dato);
                $marc_record->append_fields($new_field);
                }
              print  $marc_record->as_formatted."\n";
              
            $nivel->setMarcRecord($marc_record->as_usmarc);
            $nivel->save();
        }
     $registro++;
    }

 #Fin Proceso
 my $end1 = time();
 my $tardo1=($end1 - $st1);
 my $min= $tardo1/60;
 print "Tardo $min minutos !!!\n";


1;
