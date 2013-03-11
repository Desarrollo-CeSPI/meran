#!/usr/bin/perl
use C4::Modelo::CatRegistroMarcN1::Manager;
use MARC::Record;
use C4::AR::Utilidades;

my $niveles1 = C4::Modelo::CatRegistroMarcN1::Manager->get_cat_registro_marc_n1( query => \@filtros );
my $campo = $ARGV[0];
my $subcampo = $ARGV[1];


open (FILE, '>/usr/share/meran/campo_'.$campo.'$'.$subcampo.'txt');
foreach my $nivel1 (@$niveles1 ){
    my $flag = 0;
    my $marc_record = MARC::Record->new_from_usmarc($nivel1->getMarcRecord());
    my @values = $marc_record->subfield($campo, $subcampo);
    foreach my $value (@values){

       if (C4::AR::Utilidades::validateString($value)){
         if (!$flag){
            print FILE $marc_record->subfield("245","a").":\n";
            $flag = 1;
         }
           print FILE "         ".$value."\n";
       }
    }
}
close (FILE);
1;