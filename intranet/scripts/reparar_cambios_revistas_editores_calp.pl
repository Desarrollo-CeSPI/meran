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
use CGI::Session;
use C4::Context;
use C4::AR::ImportacionIsoMARC;
use C4::Modelo::CatRegistroMarcN2::Manager;
use MARC::Record;
use C4::AR::Utilidades;

my $niveles2 = C4::Modelo::CatRegistroMarcN2::Manager->get_cat_registro_marc_n2( query => \@filtros );
my $campo = "260";
my $subcampo = "b";
my $creados=0;
my $modificados=0;
my $id1= $ARGV[0];
my $id_editor = $ARGV[1];

my $n2_array_ref = C4::AR::Nivel2::getNivel2FromId1($id1);
foreach my $n2 (@$n2_array_ref){
  my $marc_record = MARC::Record->new_from_usmarc($n2->getMarcRecord());
  $marc_record->field($campo)->update($subcampo => 'cat_editorial@'.$id_editor);
  $n2->setMarcRecord($marc_record->as_usmarc());
  $modificados++;
    print $marc_record->as_formatted();
  $n2->save()
}

print "MODIFICADOS => ".$modificados."\n";
1;