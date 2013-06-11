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
# small script that dumps an iso2709 file.


use strict;

# Koha modules used
use C4::Context;
use MARC::File::USMARC;
use MARC::Record;
use MARC::Batch;

use Getopt::Long;
my ( $input_marc_file,$number,$nowarning,$frameworkcode) = ('',0);
my $version;
GetOptions(
    'file:s'    => \$input_marc_file,
    'n:s' => \$number,
    'v' => \$version,
    'w' => \$nowarning,
	'c' => \$frameworkcode,
);

$frameworkcode="" unless $frameworkcode;

if ($version || ($input_marc_file eq '')) {
	print <<EOF
This script compare an iso2709 file and the MARC parameters
It will show the marc fields/subfields used in Koha, and that are not anywhere in the iso2709 file and which fields/subfields that are used in the iso2709 file and not in Koha.
to solve this, just modify Koha parameters (change TAB)
parameters :
\tv : this version/help screen
\tfile /path/to/file/to/dump : the file to dump
\tw : warning and strict off. If your dump fail, try -w option. It it works, then, the file is iso2709, but a buggy one !
\tc : the frameworkcode. If omitted, set to ""
SAMPLE : ./compare_iso_and_marc_parameters.pl -file /home/paul/koha.dev/local/npl -n 1 
EOF
;
die;
}#/

my $batch = MARC::Batch->new( 'USMARC', $input_marc_file );
$batch->warnings_off() unless $nowarning;
$batch->strict_off() unless $nowarning;
my $dbh=C4::Context->dbh;
my $sth = $dbh->prepare("select tagfield,tagsubfield,tab from marc_subfield_structure where frameworkcode=?");
$sth->execute($frameworkcode);

my %hash_unused;
my %hash_used;
while (my ($tagfield,$tagsubfield,$tab) = $sth->fetchrow) {
	$hash_unused{"$tagfield$tagsubfield"} = 1 if ($tab eq -1);
	$hash_used{"$tagfield$tagsubfield"} = 1 if ($tab ne -1);
}
my $i=0;
while ( my $record = $batch->next() ) {
	$i++;
	foreach my $MARCfield ($record->fields()) {
	next if $MARCfield->tag()<=010;
		if ($MARCfield) {
			foreach my $fields ($MARCfield->subfields()) {
				if ($fields) {
					if ($hash_unused{$MARCfield->tag().@$fields[0]}>=1) {
						$hash_unused{$MARCfield->tag().@$fields[0]}++;
					}
					if ($hash_used{$MARCfield->tag().@$fields[0]}>=1) {
						$hash_used{$MARCfield->tag().@$fields[0]}++;
					}
				}
	# 			foreach my $field (@$fields) {
	# 				warn "==>".$MARCfield->tag().@$fields[0];
	# 			}
			}
		}
	}
}
print "Undeclared tag/subfields that exists in the file\n";
print "================================================\n";
foreach my $key (sort keys %hash_unused) {
	print "$key => ".($hash_unused{$key}-1)."\n" unless ($hash_unused{$key}==1);
}

print "Declared tag/subfields unused in the iso2709 file\n";
print "=================================================\n";
foreach my $key (sort keys %hash_used) {
	print "$key => ".($hash_used{$key}-1)."\n" if ($hash_used{$key}==1);
}

# foreach my $x (sort keys %resB) {
# 	print "$x => ".$resB{$x}."\n";
# }
print "\n==================\n$i record parsed\n";