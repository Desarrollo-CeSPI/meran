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
# Pasar datos de edición de la analitica a su nivel 2 referente
my $cant_padres=0;
my $cant_analiticas=0;
my $analiticas = C4::Modelo::CatRegistroMarcN1::Manager->get_cat_registro_marc_n1(
                                                                        query => [ 
                                                                                    template => { eq => 'ANA' },
                                                                            ],  
                                                                );
foreach my $analitica (@$analiticas){
   my $n2_analitica = $analitica->getGrupos()->[0]; 
   my $marc_record_analitica_2    = MARC::Record->new_from_usmarc($n2_analitica->getMarcRecord());
   my $campo260= $marc_record_analitica_2->field('260');

   if ($campo260){
   	  #Buscar Nivel 2 de Referencia
   	my $id2_padre = C4::AR::Nivel2::getIdNivel2RegistroFuente($analitica->getId1());
   	print "ID PADRE: $id2_padre \n";
   	
      my $n2_padre = C4::AR::Nivel2::getNivel2FromId2($id2_padre);
      my $marc_record_padre_2    = MARC::Record->new_from_usmarc($n2_padre->getMarcRecord());

      if(!$marc_record_padre_2->field('260')) {
         #Solo si el padre no posee edición se agrega
         $marc_record_padre_2->append_fields($campo260);
         $n2_padre->setMarcRecord($marc_record_padre_2->as_usmarc());
         $n2_padre->save();
         print "Se agrega al padre la edición\n";
         $cant_padres++;
      }
      $marc_record_analitica_2->delete_fields($campo260);
      $n2_analitica->setMarcRecord($marc_record_analitica_2->as_usmarc());
      print $marc_record_analitica_2->as_formatted(); 
      $n2_analitica->save();
      print "Se borra de la analítica\n";
      $cant_analiticas++;
      }
}
      print "FIN:\n";
      print "Se acomodaron $cant_padres padres \n";
      print "Se acomodaron $cant_analiticas analíticas\n";
1;