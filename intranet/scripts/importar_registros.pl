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

use CGI::Session;
use C4::Context;
use  C4::AR::ImportacionIsoMARC;

my $tt1 = time();
my $importacion = $ARGV[0] || 1;
C4::AR::ImportacionIsoMARC::procesarImportacion($importacion);

my $end1 = time();
my $tardo1=($end1 - $st1);
my $min= $tardo1/60;
my $hour= $min/60;
C4::AR::Debug::debug( "AL FIN TERMINO TODO!!! Tardo $tardo1 segundos !!! que son $min minutos !!! o mejor $hour horas !!!");

1;