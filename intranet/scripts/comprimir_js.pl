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
use JavaScript::Minifier qw(minify);

#procesa el archivo archivos_a_comprimir.txt y comprime los js
my $path="/usr/share/meran/dev";


#procesa el archivo archivos_a_comprimir_individuales.txt y comprime los js en archivos -min
open (FILE, $path."/intranet/scripts/archivos_a_comprimir_individuales.txt" ) or die "No se pudo abrir el archivo: $!";
while ( <FILE> ) {
    my($line) = $_;
    chomp($line);
    open(INFILE, $path.$line.'.js') or die $line;
    open(OUTFILE, '>'.$path.$line.'-min.js') or die $line ;
    minify(input => *INFILE, outfile => *OUTFILE);
    close(INFILE);
    close(OUTFILE);
}
#open(INFILE, 'myScript.js') or die;
#open(OUTFILE, '>myScript-min.js') or die;

close(FILE);
