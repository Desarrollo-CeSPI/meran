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
# small script that rebuilds the non-MARC DB

use strict;

# Koha modules used
# use MARC::File::USMARC;
use MARC::Record;
use MARC::Batch;
use C4::Context;
use C4::Biblio;

use Getopt::Long;
my ( $input_marc_file, $number) = ('',0);
my ($version, $confirm,$test_parameter);
GetOptions(
	'c' => \$confirm,
	'h' => \$version,
	't' => \$test_parameter,
);

if ($version || (!$confirm)) {
	print <<EOF
This script rebuilds the non-MARC DB from the MARC values.
You can/must use it when you change your mapping.
For example : you decide to map biblio.title to 200$a (it was previously mapped to 610$a) : run this script or you will have strange
results in OPAC !
syntax :
\t./rebuildnonmarc.pl -h (or without arguments => shows this screen)
\t./rebuildnonmarc.pl -c (c like confirm => rebuild non marc DB (may be long)
\t-t => test only, change nothing in DB
EOF
;
die;
}

my $dbh = C4::Context->dbh;
my $i=0;
my $starttime = time();
#1st of all, find item MARC tag.
my ($tagfield,$tagsubfield) = &MARCfind_marc_from_kohafield($dbh,"items.itemnumber");
# $dbh->do("lock tables biblio write, biblioitems write, items write, marc_biblio write, marc_subfield_table write, marc_blob_subfield write, marc_word write, marc_subfield_structure write, stopwords write");
my $sth = $dbh->prepare("select bibid from marc_biblio");
$sth->execute;
# my ($bibidmax) =  $sth->fetchrow;
# warn "$bibidmax <<==";
while (my ($bibid)= $sth->fetchrow) {
	#now, parse the record, extract the item fields, and store them in somewhere else.
	my $record = MARCgetbiblio($dbh,$bibid);
	my @fields = $record->field($tagfield);
	my @items;
	my $nbitems=0;
	$i++;
	foreach my $field (@fields) {
		my $item = MARC::Record->new();
		$item->append_fields($field);
		push @items,$item;
		$record->delete_field($field);
		$nbitems++;
	}
	print "$bibid\n";
	# now, create biblio and items with NEWnewXX call.
	NEWmodbiblio($dbh,$record,$bibid) unless $test_parameter;
# 	print "biblio done\n";
	for (my $i=0;$i<=$#items;$i++) {
		my $tmp = MARCmarc2koha($dbh,$items[$i]) unless $test_parameter; # finds the itemnumber
# 		warn "==> ".$items[$i]->as_formatted;
		NEWmoditem($dbh,$items[$i],$bibid,$tmp->{itemnumber}) unless $test_parameter;
# 		print "1 item done\n";
	}
}
# $dbh->do("unlock tables");
my $timeneeded = time() - $starttime;
print "$i MARC record done in $timeneeded seconds\n";