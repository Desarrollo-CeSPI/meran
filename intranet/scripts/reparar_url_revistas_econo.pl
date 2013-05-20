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

#Ticket #3462
# Pasar url de revistas de los niveles 2 al 1.

  my $revistas = C4::Modelo::CatRegistroMarcN1::Manager->get_cat_registro_marc_n1(
                                                                        query => [ 
                                                                                    template => { eq => 'REV' },
                                                                            ],  
                                                                );


foreach my $nivel1 (@$revistas){

    #URL
    my $marc_record1 = $nivel1->getMarcRecordObject();
    
        #No hay url, busco la nueva en los niveles 2
        my $grupos = C4::AR::Nivel2::getNivel2FromId1($nivel1->getId1);
        
        my $urlNueva="";
        
        foreach my $nivel2 (@$grupos){
            
            my $marc_record2 = $nivel2->getMarcRecordObject();
            my $campo = $marc_record2->field('856');

            
            if($campo){
                my $urlGrupo = $campo->subfield('u');
                    
                if($urlGrupo){
                    #Existe la url, la eliminamos del nivel2
                    $campo->delete_subfield(code => 'u');
                    
                    if (!$campo->subfields()){
                        #si no hay mas subcampos en el campo, lo elimino
                        print "delete field\n\n";
                        $marc_record2->delete_field($campo);
                    }
                    
                    if(!$urlNueva){
                        $urlNueva= $urlGrupo;
                    }
                    
                    print "#################### NIVEL 2 SIN URLS ################## \n";
                    print $marc_record2->as_formatted."\n\n";
                    print "#################### NIVEL 2 SIN URLS FIN ################## \n";
                    $nivel2->setMarcRecord($marc_record2->as_usmarc);
                    $nivel2->save();
                }
            }
        }
        
        
        if($urlNueva){
            #Hay url nueva?
            
            my $field856 = $marc_record1->field('856');
            if ($field856){
                #Existe el campo 856
                 #Agrego el subcampo
                $field856->update( 'u' => $urlNueva );
            }
            else{
              #No existe el campo
               my @subcampos_array;
               push(@subcampos_array, ('u' => $urlNueva ));
               my $new_field = new MARC::Field('856','#','#', @subcampos_array);
               $marc_record1->append_fields($new_field);
            }
            print "#################### NIVEL 1 CON URLS ################## \n";
            print "#################### NIVEL 1 CON URLS ################## \n";
            print "#################### NIVEL 1 CON URLS ################## \n";
            print "URL NUEVA = ".$urlNueva."\n";
            print $marc_record1->as_formatted."\n\n";
            print "#################### NIVEL 1 CON URLS FIN################## \n";
            $nivel1->setMarcRecord($marc_record1->as_usmarc);
            $nivel1->save();
        
        }

}



1;