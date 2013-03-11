#!/usr/bin/perl
#Repara el caso de las personas que estan habilitadas (estan en borrowers) pero con distinto borrowernumber
use strict;
require Exporter;
use C4::Context;

 my $dbh = C4::Context->dbh;
 my @results;
 my $query = " SELECT borrowers.surname, borrowers.firstname,borrowers.cardnumber as cardnumber, borrowers.borrowernumber as borrowernumber, persons.borrowernumber as pborrowernumber
FROM borrowers
INNER JOIN persons ON borrowers.cardnumber = persons.cardnumber
WHERE borrowers.borrowernumber <> persons.borrowernumber ";
 my $sth=$dbh->prepare($query);
 $sth->execute();

open (L,">/tmp/reparar_persons");

while (my $data=$sth->fetchrow_hashref){
printf L "UPDATE persons SET borrowernumber='".$data->{'borrowernumber'}."' WHERE cardnumber='".$data->{'cardnumber'}."';\n";
          }

close L;




