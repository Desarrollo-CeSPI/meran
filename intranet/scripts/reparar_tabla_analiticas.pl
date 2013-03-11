#!/usr/bin/perl

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
