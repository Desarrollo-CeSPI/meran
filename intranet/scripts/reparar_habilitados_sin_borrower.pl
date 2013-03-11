#!/usr/bin/perl
# Personas con borrowernumber sin estar en la tabla borrowers

use strict;
require Exporter;
use C4::Context;
use C4::AR::Persons_Members;

 my $dbh = C4::Context->dbh;
 my @results;
 my $cant=0;
open (L,">/tmp/habilitar_persons");


my $personas = " SELECT *  FROM persons where borrowernumber <> '' ";
 my $sth3=$dbh->prepare($personas);
  $sth3->execute();
  
  while (my $per=$sth3->fetchrow_hashref){
  
  my $borrower = " SELECT *  FROM borrowers  WHERE cardnumber = ? ";
  my $sth4=$dbh->prepare($borrower);
  $sth4->execute($per->{'cardnumber'});

  if (my $error= $sth4->fetchrow_hashref){}
  else {
   $cant ++;

   push (@results,$per->{'personnumber'});
   printf L $per->{'surname'}."  ".$per->{'cardnumber'}."  \n";
  }

$sth4->finish();
  }

close L;
$sth3->finish();
print "Cantidad:  ".$cant." \n";

#
#

addmembers(@results);

#
#


print " Reparados \n";
