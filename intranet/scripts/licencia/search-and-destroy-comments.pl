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

# Se eliminan los comentarios y se reemplazan las licencias de los *.pl y *.pm de un directorio.
# USO:
#  perl search-and-destroy-comments.pl PATH_COMPLETO_DIRECTORIO_A_ESCANEAR ARCHIVO_NUEVA_LICENCIA
# EJ:
# perl search-and-destroy-comments.pl /usr/local/koha/ licencia.txt

use File::Find;
use Tie::File;
use strict;

my $directory = $ARGV[0]; #Directorios a escanear
my $licenceFile = $ARGV[1]; #archivo con la licencia a reemplazar

my @licenceLines;

tie @licenceLines, 'Tie::File', $licenceFile or die "No se pudo abrir el archivo de licencia: $!\n";

#Procesamos
find (\&process, $directory);

sub process
{
    my @lines;      #Linea leida.

    if (( $File::Find::name =~ /\.pm$/)or( $File::Find::name =~ /\.pl$/)) {

   print "Procesando $File::Find::name\n";
   #Abrimos el archivo a modificar
   tie @lines, 'Tie::File', $File::Find::name or die "No se pudo abrir el archivo: $!\n";
   my $i=0; 
   #Sacamos los comentarios incluso la 1er linea si es un pl !!!  ----> #!/usr/bin/perl

   while ($i < scalar(@lines)) {

	if ( length ($lines[$i]) ne 0){ #Ya era blanco
		$lines[$i] =~ s/^\s*#.*//;

		if ( length ($lines[$i]) eq 0){ #Se puso en blanco
			splice(@lines,$i,1);
		}
		else{$i++;}
  	}
	else{$i++;}
    }

   # Agregamos  la nueva licencia al principio

   for (my $j = scalar(@licenceLines)-1; $j ge 0;$j--) {
   	unshift(@lines, $licenceLines[$j]);
   }
   # Tenemos que volver a agregar el  #!/usr/bin/perl si es un pl!!!
   if ( $File::Find::name =~ /\.pl$/) {
   	unshift(@lines, "#!/usr/bin/perl");
    }
    untie @lines;
   }
 }