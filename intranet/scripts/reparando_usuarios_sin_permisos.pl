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

        my @filtros;
        push (@filtros, ( activo => 1 ) );
        my  $socios_activos = C4::Modelo::UsrSocio::Manager->get_usr_socio( query => \@filtros );
    my $cant=0;
    foreach my $socio (@$socios_activos){
                if (!$socio->tieneSeteadosPermisos){
                        C4::AR::Debug::debug("USUARIO ACTIVO SIN PERMISOS!!!  ".$socio->persona->getApeYNom()." (".$socio->getNro_socio.")");
                        $socio->activar();
                        $cant++;
                }
    }

 C4::AR::Debug::debug("CANT. USUARIOS SIN PERMISOS: ".$cant);