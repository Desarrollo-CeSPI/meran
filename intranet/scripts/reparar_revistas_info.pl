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

	if($tipo_doc eq 'SER'){
        my $marc_record = MARC::Record->new_from_usmarc($nivel2->getMarcRecord());
        my $field910    = $marc_record->field("910");
        $field910->update( a => 'cat_ref_tipo_nivel3@REV');
        $nivel2->setMarcRecord($marc_record->as_usmarc());
		$nivel2->save();
	}
}

1;