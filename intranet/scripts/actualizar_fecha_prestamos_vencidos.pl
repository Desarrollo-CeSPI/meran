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

#actualiza la fecha de vencimiento del prestamo en la base

use strict;
use CGI;
use C4::Modelo::CircPrestamo::Manager;

my $prestamos_array_ref = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo();
my $cant_total          = scalar(@$prestamos_array_ref);
my $i                   = 1;

foreach my $prestamo (@$prestamos_array_ref){
    $prestamo->setFecha_vencimiento_reporte($prestamo->getFecha_vencimiento());    
    print "Actualizando prestamo $i de $cant_total \n";   
    $i++;
    $prestamo->save();
}  