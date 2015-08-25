#!/usr/bin/perl

use C4::Modelo::CatRegistroMarcN1;
use C4::Modelo::CatRegistroMarcN1::Manager;
use MARC::Record;

my $n1s = C4::Modelo::CatRegistroMarcN1::Manager->get_cat_registro_marc_n1(); 
my $cant=0;

foreach my $n1 (@$n1s){

   my $marc_record_base    = MARC::Record->new_from_usmarc($n1->getMarcRecord());
   print $marc_record_base->as_formatted();
   print "\n\n";
}
1;
