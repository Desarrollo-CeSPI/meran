#!/usr/bin/perl


use MARC::Moose::Record;
use MARC::Moose::Reader::File::Isis;
use MARC::Moose::Formater::Iso2709;
my $outfile= "badrecords.iso";
my $badRecords=0;
my $records=0;
my $exit=0;
open (OUT,">", $outfile); 


my $reader = MARC::Moose::Reader::File::Isis->new(
    file   => 'biblio.iso', );

while ( my $record = $reader->read() ) {
  $records++;
     for my $field ( @{$record->fields} ) {
         if($field->tag < '010'){
             #CONTROL FIELD
               #  print "CAMPO CONTROL > ".$field->tag;
                # print "\n";
             }
             else {
         for my $subfield ( @{$field->subf} ) {
              print "CAMPO > ".$field->tag." SUBCAMPO > ". $subfield->[0]." ==> ".$subfield->[1]."\n";
              
              if($subfield->[1] =~ m/\x1e/g){
                #Encuentro un delimitador en un campo de texto, algo está mal
                $badRecords++;
                print "BAD RECORD!!!---> ".$badRecords."\n";
                print "CAMPO > ".$field->tag." SUBCAMPO > ". $subfield->[0]." ==> ".$subfield->[1]."\n";
                
                my $formater = MARC::Moose::Formater::Iso2709->new();
                print OUT $record->as("iso2709") ."\n";
                
                $exit=1;
                last;
                }
            } #for subs
        } #else
        
    if ($exit){
      $exit=0; 
      last;
      }
     } # for fields
}

print "TOTAL RECORDS!!!---> ".$records."\n";

close OUT;
