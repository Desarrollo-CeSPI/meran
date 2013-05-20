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
use MARC::File::USMARC;
use MARC::Record;
use MARC::Batch;

use Getopt::Long;
my ( $input_marc_file,$number) = ('',0);
my $version;
GetOptions(
    'file:s'    => \$input_marc_file,
    'n:s' => \$number,
    'v' => \$version
);

warn "NUM : $number\n";
if ($version || ($input_marc_file eq '')) {
	print <<EOF
small script to dump an iso2709 file.
parameters :
\tv : this version/help screen
\tfile /path/to/file/to/dump : the file to dump
\tn : the number of the record to dump. If missing, all the file is dumped
SAMPLE : ./dumpmarc.pl -file /home/paul/koha.dev/local/npl -n 1
EOF
;
die;
}

my $batch = MARC::Batch->new( 'USMARC', $input_marc_file );
#$batch->warnings_off();
#$batch->strict_off();
my $i=1;
while ( my $record = $batch->next() ) {
	print "\nNUMBER $i =>\n".$record->as_formatted() if ($i eq $number || $number eq 0);
	$i++;
}
print "\n==================\n$i record parsed\n";