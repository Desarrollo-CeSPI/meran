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

use File::Find;
use Locale::PO;
use strict;

my $directory = $ARGV[0]; #Directorios a escanear
my $output_po = $ARGV[1]; #Archivo PO resultado 
my @outLines;  #Arreglo de POs

#Levantamos el archivo
my $ot = Locale::PO->load_file_asarray($output_po);
 @outLines=@$ot;
# my $i=0;
#     while ($i<@outLines)
#     {  print $outLines[$i]->msgid()." \n";
#         $i++;
#     }

#Procesamos
find (\&process, $directory);

#Salvamos el po
Locale::PO->save_file_fromarray($output_po,\@outLines);

# open( OUT, ">>$output_po" ) or return undef;
# foreach (@outLines)  { print OUT $_->dump();}
# close OUT;

undef( @outLines );

sub trim
{
 my ($string)=@_;
$string =~ s/^\s+//;
$string =~ s/\s+$//;
return $string;
}

sub process
{
    my $line;      #Linea leida.
    my @matches;
    #Buscamos solo los  .tmpl
    if (( $File::Find::name =~ /\.tmpl$/ ) or( $File::Find::name =~ /\.inc$/)) {
	print "Procesando $File::Find::name\n";
        open (FILE, $File::Find::name ) or die "No se pudo abrir el archivo: $!";

        while ( $line = <FILE> ) {
	@matches = ($line =~ /\[%\s*['"]*\s*([^{",\|,'}]*)\s*['"]*\s*\|\s*i18n\s*%]/g);
	foreach my $m (@matches)
	{
	my $str=&trim($m);
	my $exists=0;
 	my $po = new Locale::PO();
 	$po->msgid($str);
       	$po->msgstr("");
       	$po->comment("$File::Find::name");
	
	#Reviso si no existe!!!
	my $i=0;
	while ($i<@outLines)
  	{	if ($outLines[$i]->msgid() eq $po->msgid()) {
			$exists=1; 
 			print $outLines[$i]->msgid()." ya existe \n";
		}
		$i++;
	}
	 if($exists == 0){ push(@outLines, $po);}
	}
        }
        close FILE;
    }
    elsif ( $File::Find::name =~ /\.pm$/) {

     print "Procesando PM $File::Find::name\n";
     open (FILE, $File::Find::name ) or die "No se pudo abrir el archivo: $!";

        while ( $line = <FILE> ) {
    @matches = ($line =~ /i18n\(['"]*\s*([^{",\|,'}]*)\s*['"]\)/g);
    foreach my $m (@matches)
    {
    my $str=&trim($m);
    my $exists=0;
    my $po = new Locale::PO();
        $po->msgid($str);
        $po->msgstr("");
        $po->comment("$File::Find::name");

    print "MATCH PM $str\n";

    #Reviso si no existe!!!
    my $i=0;
    while ($i<@outLines)
    {   if ($outLines[$i]->msgid() eq $po->msgid()) {
            $exists=1; 
            print $outLines[$i]->msgid()." ya existe PM\n";
        }
        $i++;
    }
     if($exists == 0){ push(@outLines, $po);}
    }
    }
        close FILE;
    }
}