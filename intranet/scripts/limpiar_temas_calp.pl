#!/usr/bin/perl

use MARC::Record;
use C4::Modelo::CatRegistroMarcN1;
use C4::Modelo::CatRegistroMarcN1::Manager;
use C4::Modelo::CatTema;
use C4::AR::Utilidades; 

my $nivel1_array_ref = C4::AR::Nivel1::getNivel1Completo();
my @temas_limpiar = ('cat_tema@20','cat_tema@36','cat_tema@220');
my $cambios = 0;
foreach my $nivel1 (@$nivel1_array_ref){
    my @borrar_campos = ();
    my $marc_record = MARC::Record->new_from_usmarc($nivel1->getMarcRecord());
    #Temas
    @f650s = $marc_record->field('650');
    my $borrar = 0;
    foreach my $f650 (@f650s){
        my @temas = $f650->subfield('a');
        my $cant_temas_campo = 0;
        foreach my $ref (@temas){
            $cant_temas_campo++;
            foreach my $tl (@temas_limpiar){
                if (C4::AR::Utilidades::trim($ref) eq C4::AR::Utilidades::trim($tl)){
                    $cambios++;
                    $borrar++;
                }
            }
        }
        if (($cant_temas_campo == 1)&&($borrar == 1)) {
            push (@borrar_campos,$f650);
            $borrar = 0;
        }
    }
    if (scalar(@borrar_campos) ge 1){
            print "BORRAR TEMAS DE REGISTRO\n";
            print "ANTES \n";
            print $marc_record->as_formatted()."\n";
            $marc_record->delete_fields(@borrar_campos);
            print "DESPUES \n";
            print $marc_record->as_formatted()."\n";

            $nivel1->setMarcRecord($marc_record->as_usmarc());
            $nivel1->save();
    }
}

print "\n Se cambiaron ".$cambios." registros. \n";
1;