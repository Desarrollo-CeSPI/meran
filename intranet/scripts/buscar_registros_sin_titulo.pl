#!/usr/bin/perl

use C4::Modelo::CatRegistroMarcN1;
use C4::Modelo::CatRegistroMarcN1::Manager;
use MARC::Record;

my $n1s = C4::Modelo::CatRegistroMarcN1::Manager->get_cat_registro_marc_n1(); 
my $cant=0;

foreach my $n1 (@$n1s){
   
   my $registro_erroneo=0;
   if(!$n1->getTitulo){
      $cant =$cant+1;
      print "REGISTRO id1=".$n1->getId1." SIN TITULO \n";
   }
}

print "Errores en ".$cant." registros";
1;
