#!/usr/bin/perl

use C4::AR::Nivel2;
use C4::Context;
use C4::Modelo::CatRegistroMarcN2;
use C4::Modelo::CatRegistroMarcN2::Manager;

#Ticket #3462
#Script para reparar los campos procedencia (biblioitems.source) y url de las revistas de Económicas. Van a los campos 859 e:source y 856 u: url.

 open (FILE, '../scripts/revistas.csv');
 my @lineas = <FILE>;
 
 foreach my $linea (@lineas) {
  chomp($linea);
  
  my ($id2,$source,$url) = split(/,/,$linea);
 	
  #Buscamos el nivel2
  my $nivel2 = C4::AR::Nivel2::getNivel2FromId2($id2);
  
  if($nivel2) {
    my $marc_record = $nivel2->getMarcRecordObject();
    
    #PROCEDENCIA
    if ($source) {
        my $field859 = $marc_record->field('859');
        if ($field859){
        #Existe el campo 859
            if ($source) {
                #NO ES REPETIBLE, LO PISO!!
             $field859->update( 'e' => $source );
            }
        }
        else{
          #No existe el campo
           my @subcampos_array;
           if ($source) {
             push(@subcampos_array, ('e' => $source ));
           }
           my $new_field = new MARC::Field('859','#','#', @subcampos_array);
           $marc_record->append_fields($new_field);
        }
    }
    
    #URL
    if ($url) {
        my $field856 = $marc_record->field('856');
        if ($field856){
            #Existe el campo 856        
             #Agrego el subcampo
            $field856->update( 'u' => $url );
        }
        else{
          #No existe el campo
           my @subcampos_array;
           push(@subcampos_array, ('u' => $url ));
           my $new_field = new MARC::Field('856','#','#', @subcampos_array);
           $marc_record->append_fields($new_field);
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
