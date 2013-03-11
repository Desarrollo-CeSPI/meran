#!/usr/bin/perl

use C4::Modelo::CatRegistroMarcN2;
use C4::Modelo::CatRegistroMarcN2::Manager;
use MARC::Record;

my $n2s = C4::Modelo::CatRegistroMarcN2::Manager->get_cat_registro_marc_n2(); 

foreach my $n2 (@$n2s){

   my $marc_record_base    = MARC::Record->new_from_usmarc($n2->getMarcRecord());
   my $referencia= $marc_record_base->subfield('773',"a");

   if (($referencia)&&($referencia !~ /@/)){
      $marc_record_base->field('773')->update( "a" => 'cat_registo_marc_n2@'.$referencia );
      $n2->setMarcRecord($marc_record_base->as_usmarc());
      $n2->save();
   }
}

1;
