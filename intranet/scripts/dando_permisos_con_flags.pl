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
#Le da permisos a los usuarios segun su campo flags

use C4::Modelo::UsrSocio::Manager;
use C4::Modelo::UsrSocio;
my  $socios = C4::Modelo::UsrSocio::Manager->get_usr_socio();
    foreach my $socio (@$socios){
      my $flag = $socio->getFlags;
      if ($flag){
	#Si tiene flags seteados NO es un estudiante
	  if($flag % 2){
	    #Da 1 entonces era IMPAR => tenia el 1er bit en 1 => es SUPERLIBRARIAN
	    $socio->setCredentials('superLibrarian');
	  }else{
	    #Da 0 entonces era PAR => tenia el 1er bit en 0 => NO es SUPERLIBRARIAN
        $socio->setCredentials('librarian');
	  }
      }else{
	#Si NO tiene flags seteados es un estudiante
        $socio->setCredentials('estudiante');
      }
    }