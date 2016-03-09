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

use strict;
use C4::AR::Auth;
use CGI;
use C4::AR::Novedades;
my $input = new CGI;
my $year = $input->param('year');

my $result_hash = C4::AR::Utilidades::datosEstadisticosUNLP($year);


my $query = new CGI;
print $query->header( -type=>'text/html', 
							 charset => C4::Context->config("charset")||'UTF-8', 
							 "Cache-control: public",
					);
print "<h1> AÑO  ".$year."</h1>";
print "<h2>CATÁLOGO: </h2><br> Cantidad total de documentos (todo tipo) IMPRESOS! ('LIB', 'TES', 'SER', 'REV', 'FOT') <br>";
print "- TOTAL: ".$result_hash->{'cantidad_impreso_total'}." <br>";
print "- DISPONIBLES: ".$result_hash->{'cantidad_impreso_disponible'}." <br>";
print "- NO DISPONIBLES: ".$result_hash->{'cantidad_impreso_no_disponible'}." <br><br>";

print "Cantidad de LIBROS: <br> Volúmenes: ".$result_hash->{'cantidad_libros_grupos'}." <br> Ejemplares: ".$result_hash->{'cantidad_libros_ejemplares'}." <br><br>";
print "Cantidad de TESIS: <br> Volúmenes: ".$result_hash->{'cantidad_tesis_grupos'}." <br> Ejemplares: ".$result_hash->{'cantidad_tesis_ejemplares'}." <br><br>";
print "Cantidad de OTRAS MONOGRAFÍAS (FOT): <br> Volúmenes: ".$result_hash->{'cantidad_otros_grupos'}." <br> Ejemplares: ".$result_hash->{'cantidad_otros_ejemplares'}." <br><br>";
print "Cantidad de Volúmenes NO disponibles: ".$result_hash->{'cantidad_no_disponibles_grupos'}." <br><br>";
print "Cantidad de REVISTAS: <br> Registros: ".$result_hash->{'cantidad_revistas_registros'}." <br> Volúmenes: ".$result_hash->{'cantidad_revistas_grupos'}." <br> Ejemplares: ".$result_hash->{'cantidad_revistas_ejemplares'}." <br><br>";

print "<h2>	SERVICIOS: </h2><br>";
print "PRESTAMOS: <br>";
print "- CANTIDAD DE PRESTAMOS TOTALES: ".$result_hash->{'cantidad_prestamos_totales'}." <br>";
print "- CANTIDAD DE PRESTAMOS DOMICILIO: ".$result_hash->{'cantidad_prestamos_domicilio'}." <br>";
print "- CANTIDAD DE PRESTAMOS SALA: ".$result_hash->{'cantidad_prestamos_sala'}." <br><br>";
print "- CANTIDAD DE PRESTAMOS MONOGRAFIAS: <br> DOMICILIO: ".$result_hash->{'cantidad_prestamos_domicilio_monografia'}." <br> SALA: ".$result_hash->{'cantidad_prestamos_sala_monografia'}."  <br><br>";
print "- CANTIDAD DE PRESTAMOS REVISTA: <br> DOMICILIO: ".$result_hash->{'cantidad_prestamos_domicilio_revista'}." <br> SALA: ".$result_hash->{'cantidad_prestamos_sala_revista'}."  <br><br>";
print "- CANTIDAD DE PRESTAMOS OTROS: <br> DOMICILIO: ".$result_hash->{'cantidad_prestamos_domicilio_otros'}." <br> SALA: ".$result_hash->{'cantidad_prestamos_sala_otros'}."  <br><br>";

print "BUSQUEDAS: <br>";
print "- CANTIDAD DE BUSQUEDAS SOCIOS: ".$result_hash->{'cantidad_busquedas_socios'}." <br>";
print "- CANTIDAD DE BUSQUEDAS NO SOCIOS: ".$result_hash->{'cantidad_busquedas_no_socios'}." <br>";
