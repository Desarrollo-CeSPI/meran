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
# small script that list all items in the DB, ordered by location

use strict;

# Koha modules used
use MARC::Record;
use MARC::Batch;
use C4::Context;
use C4::Biblio;
use Time::HiRes qw(gettimeofday);

use Getopt::Long;
my ( $input_marc_file, $number) = ('',0);
my ($version, $delete, $test_parameter,$char_encoding, $verbose);
GetOptions(
    'file:s'    => \$input_marc_file,
    'n' => \$number,
    'h' => \$version,
    'd' => \$delete,
    't' => \$test_parameter,
    'c:s' => \$char_encoding,
    'v:s' => \$verbose,
);

if ($version) {
	print <<EOF
small script to list items in the DB
parameters :
\th : this version/help screen
EOF
;
die;
}

my $dbh = C4::Context->dbh;
my $starttime = gettimeofday;
#1st of all, find item MARC tag.
my $sth = $dbh->prepare("select bulk,title,author from items,biblio where items.biblionumber=biblio.biblionumber order by bulk");
$sth->execute;
while ( (my $bulk,my $title,my $author) = $sth->fetchrow) {
	my @s = split(/ /,$bulk);
	print "$s[0]\t$s[1]\t$title\t$author\n";
}
my $timeneeded = gettimeofday - $starttime;
print "Dump done in $timeneeded seconds\n";