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

use C4::Context;
use C4::Modelo::CatRegistroMarcN2;
use C4::Modelo::CatRegistroMarcN2::Manager;

my $nivel2_array_ref = C4::AR::Nivel2::getAllNivel2();

foreach my $nivel2 (@$nivel2_array_ref){

    my $tipo_doc = $nivel2->getTipoDocumento();

	if(($nivel2->nivel1->getTemplate eq 'ALL')||($tipo_doc eq 'REV')||($tipo_doc eq 'ANA')||($tipo_doc eq 'ACT')||($tipo_doc eq 'MON')||($tipo_doc eq 'TES')){
		C4::AR::Debug::debug("============== seteando tipo_doc: ".$tipo_doc." al registro: ".$nivel2->nivel1->getId1()." ==============");
		$nivel2->nivel1->setTemplate($tipo_doc);
		$nivel2->nivel1->save();
	}
	
    C4::AR::Debug::debug("seteando tipo_doc: ".$tipo_doc." al grupo: ".$nivel2->getId2());
    $nivel2->setTemplate($tipo_doc);
    $nivel2->save();

    my $nivel3_array_ref = C4::AR::Nivel3::getNivel3FromId2($nivel2->getId2());
    
    foreach my $nivel3 (@$nivel3_array_ref){

        C4::AR::Debug::debug("seteando tipo_doc: ".$tipo_doc." al ejemplar: ".$nivel3->getId());
        $nivel3->setTemplate($tipo_doc);
        $nivel3->save();
    }
}

1;