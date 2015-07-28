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

use C4::Modelo::IoImportacionIsoRegistro;
use MARC::Moose::Record;
use MARC::Moose::Reader::File::Isis;
use MARC::Moose::Formater::Iso2709;
my $outfile= "badrecords.iso";
my $badRecords=0;
my $records=0;
my $exit=0;
open (OUT,">", $outfile);


my $reader = MARC::Moose::Reader::File::Isis->new(
    file   =>  $ARGV[0] || 'biblio.iso');

    while ( my $record = $reader->read() ) {
      $records++;
        print $record->as('Text');
     }
print "TOTAL RECORDS!!!---> ".$records."\n";

close OUT;
