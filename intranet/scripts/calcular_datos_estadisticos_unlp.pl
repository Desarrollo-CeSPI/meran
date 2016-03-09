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


use strict;
require Exporter;
use C4::Context;
use C4::AR::Utilidades;

my $year = $ARGV[0] || die 'Debe porveer un año para calcular!!! ';

my $result_hash = C4::AR::Utilidades::datosEstadisticosUNLP($year);
print "================================================================= AÑO  ".$year." ================================================================= \n";
print "CATÁLOGO: \n\n Cantidad total de documentos (todo tipo) IMPRESOS! ('LIB', 'TES', 'SER', 'REV', 'FOT') \n";
print "- TOTAL: ".$result_hash->{'cantidad_impreso_total'}." \n";
print "- DISPONIBLES: ".$result_hash->{'cantidad_impreso_disponible'}." \n";
print "- NO DISPONIBLES: ".$result_hash->{'cantidad_impreso_no_disponible'}." \n\n";

print "Cantidad de LIBROS: \n Volúmenes: ".$result_hash->{'cantidad_libros_grupos'}." \n Ejemplares: ".$result_hash->{'cantidad_libros_ejemplares'}." \n\n";
print "Cantidad de TESIS: \n Volúmenes: ".$result_hash->{'cantidad_tesis_grupos'}." \n Ejemplares: ".$result_hash->{'cantidad_tesis_ejemplares'}." \n\n";
print "Cantidad de OTRAS MONOGRAFÍAS (FOT): \n Volúmenes: ".$result_hash->{'cantidad_otros_grupos'}." \n Ejemplares: ".$result_hash->{'cantidad_otros_ejemplares'}." \n\n";
print "Cantidad de Volúmenes NO disponibles: ".$result_hash->{'cantidad_no_disponibles_grupos'}." \n\n";
print "Cantidad de REVISTAS: \n Registros: ".$result_hash->{'cantidad_revistas_registros'}." \n Volúmenes: ".$result_hash->{'cantidad_revistas_grupos'}." \n Ejemplares: ".$result_hash->{'cantidad_revistas_ejemplares'}." \n\n";

print "SERVICIOS: \n\n";
print "PRESTAMOS: \n";
print "- CANTIDAD DE PRESTAMOS TOTALES: ".$result_hash->{'cantidad_prestamos_totales'}." \n";
print "- CANTIDAD DE PRESTAMOS DOMICILIO: ".$result_hash->{'cantidad_prestamos_domicilio'}." \n";
print "- CANTIDAD DE PRESTAMOS SALA: ".$result_hash->{'cantidad_prestamos_sala'}." \n\n";
print "- CANTIDAD DE PRESTAMOS MONOGRAFIAS: \n DOMICILIO: ".$result_hash->{'cantidad_prestamos_domicilio_monografia'}." \n SALA: ".$result_hash->{'cantidad_prestamos_sala_monografia'}."  \n\n";
print "- CANTIDAD DE PRESTAMOS REVISTA: \n DOMICILIO: ".$result_hash->{'cantidad_prestamos_domicilio_revista'}." \n SALA: ".$result_hash->{'cantidad_prestamos_sala_revista'}."  \n\n";
print "- CANTIDAD DE PRESTAMOS OTROS: \n DOMICILIO: ".$result_hash->{'cantidad_prestamos_domicilio_otros'}." \n SALA: ".$result_hash->{'cantidad_prestamos_sala_otros'}."  \n\n";

print "BUSQUEDAS: \n";
print "- CANTIDAD DE BUSQUEDAS SOCIOS: ".$result_hash->{'cantidad_busquedas_socios'}." \n";
print "- CANTIDAD DE BUSQUEDAS NO SOCIOS: ".$result_hash->{'cantidad_busquedas_no_socios'}." \n";

print "============================================================================================================================================= \n";
