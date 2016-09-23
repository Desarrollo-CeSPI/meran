#!/usr/bin/perl
# Meran - MERAN UNLP is a ILS (Integrated Library System) wich provides Catalog,
# Circulation and User's Management. It's written in Perl, and uses Apache2
# Web-Server, MySQL database and Sphinx 2 indexing.
# Copyright (C) 2009-2015 Grupo de desarrollo de Meran CeSPI-UNLP
# <desarrollo@cespi.unlp.edu.ar>
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

use C4::AR::Usuarios;
use C4::AR::Authldap;
 
my $today = Date::Manip::ParseDate("today"); 
my $socios_array_ref = C4::AR::Usuarios::getSociosByLastAuthMethod("ldap");

C4::AR::Debug::debug("Sincronizando socios con Matriculas");

# recorro la lista de usuarios que autentican con LDAP
foreach my $socio (@$socios_array_ref){
  C4::AR::Debug::debug("Procesando socio " . $socio->getNro_socio());
  # verifico si son miembros del grupo MERAN
  # si no son miembros, se desactivan

  my $s = C4::AR::Authldap::memberOf($socio, "no-meran");

  if($s){
    C4::AR::Debug::debug("Socio " . $socio->getNro_socio() . " NO PERTENECE AL GRUPO MERAN!!!");
    $socio->setCumple_requisito("0000000000:00:00");  
    $socio->save();
  } else {
    C4::AR::Debug::debug("Socio " . $socio->getNro_socio() . " PERTENECE AL GRUPO MERAN!!!");
    $socio->setCumple_requisito($today);  
    $socio->save();  	
  }
  
}

1;