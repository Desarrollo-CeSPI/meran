#!/usr/bin/perl
#
# Meran - MERAN UNLP is a ILS (Integrated Library System) wich provides Catalog,
# Circulation and User's Management. It's written in Perl, and uses Apache2
# Web-Server, MySQL database and Sphinx 2 indexing.
# Copyright (C) 2009-2013 Grupo de desarrollo de Meran CeSPI-UNLP
#
# This file is part of Meran.
#
# Meran is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Meran is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Meran.  If not, see <http://www.gnu.org/licenses/>.
#
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