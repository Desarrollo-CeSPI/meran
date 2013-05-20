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

use C4::Modelo::CatRegistroMarcN2;
use C4::Modelo::CatRegistroMarcN2::Manager;
use MARC::Record;

my $n2s = C4::Modelo::CatRegistroMarcN2::Manager->get_cat_registro_marc_n2(); 

foreach my $n2 (@$n2s){

   my $marc_record_base    = MARC::Record->new_from_usmarc($n2->getMarcRecord());
   my $referencia= $marc_record_base->subfield('773',"a");

   if (($referencia)&&($referencia !~ /@/)){
      $marc_record_base->field('773')->update( "a" => 'cat_registo_marc_n2@'.$referencia );
      $n2->setMarcRecord($marc_record_base->as_usmarc());
      $n2->save();
   }
}

1;