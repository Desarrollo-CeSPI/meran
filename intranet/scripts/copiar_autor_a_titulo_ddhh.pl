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

use C4::AR::Nivel1;
#Sí, Nivel2:

#100^a => 245^a


sub trim{
    my ($string) = @_;

    $string =~ s/^\s+//;
    $string =~ s/\s+$//;

    return $string;
}



my $registros_array_ref = C4::AR::Nivel1::getNivel1Completo();

 print "Copiando Autores en Titulos DDHH \n";
 my $st1 = time();
 #Procesamos los registros
 my $cantidad = scalar(@$registros_array_ref);
 my $registro=1;
 my $registro_modificados=0;
   foreach my $nivel (@$registros_array_ref){
         my $marc_record = MARC::Record->new_from_usmarc($nivel->getMarcRecord());
         my $porcentaje= int (($registro * 100) / $cantidad );
         print "Procesando registro: $registro de $cantidad ($porcentaje%) \r";

        my $autor = $nivel->getAutor();

            my $field_dest = $marc_record->field('245');
            
            if ($field_dest){
                #existe el campo 505
                    if(($field_dest->subfield('a')) &&(!trim($field_dest->subfield('a')))){
                        #existe el subcampo pero esta vacío!!!
                        $field_dest->update( 'a' => $autor );
                    }
                    else{
                        $field_dest->add_subfields( 'a' => $autor );
                        }
                }
            else {
                my @subcampos_array;
                push(@subcampos_array, ('a' => $autor));
                my $new_field = MARC::Field->new('245','','',@subcampos_array);
                $marc_record->append_fields($new_field);
                }
            
            $nivel->setMarcRecord($marc_record->as_usmarc);
            $nivel->save();
            $registro_modificados++;
        
     $registro++;
    }

 #Fin Proceso
 my $end1 = time();
 my $tardo1=($end1 - $st1);
 my $min= $tardo1/60;
 print "Tardo $min minutos !!!\n";
 print "Se modificaron $registro_modificados registros !!!\n";

1;
