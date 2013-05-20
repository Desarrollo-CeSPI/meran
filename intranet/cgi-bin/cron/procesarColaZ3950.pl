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
use C4::AR::Z3950;

my $session = CGI::Session->new();
$session->param("type","intranet");


#Eliminar entradas viejas de la cola y los resultaods
#C4::AR::Z3950::limpiarBusquedas();
C4::AR::Debug::debug( "Chequeo cola de busqueda z3950 (".C4::Date::getCurrentTimestamp.")");

my $cola =C4::AR::Z3950::busquedasEncoladas();

if  ($cola) {
#si hay algo que buscar agarro el primero
        C4::AR::Debug::debug( "Buscando por ".$cola->[0]->getBusqueda);
        C4::AR::Z3950::efectuarBusquedaZ3950($cola->[0]);
        C4::AR::Debug::debug( "Busqueda ".$cola->[0]->getBusqueda." Finalizada");
}