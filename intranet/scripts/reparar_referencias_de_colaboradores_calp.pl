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
use lib qw(/usr/local/share/meran/dev/intranet/modules/ /usr/local/share/meran/main/intranet/modules/C4/Share/share/perl/5.10.1/ /usr/local/share/meran/main/intranet/modules/C4/Share/lib/perl/5.10.1/ /usr/local/share/meran/main/intranet/modules/C4/Share/share/perl/5.10/ /usr/local/share/meran/main/intranet/modules/C4/Share/share/perl/5.10.1/ /usr/local/share/meran/main/intranet/modules/C4/Share/lib/perl5/);

use C4::Modelo::CatRegistroMarcN1;
use C4::Modelo::CatRegistroMarcN1::Manager;
use C4::Modelo::RefColaborador;

use MARC::Record;
my $reparados =0;
my $n1s = C4::Modelo::CatRegistroMarcN1::Manager->get_cat_registro_marc_n1(); 

foreach my $n1 (@$n1s){

   my $marc_record_base    = MARC::Record->new_from_usmarc($n1->getMarcRecord());
   
   my @fields700    = $marc_record_base->field("700");
   foreach my $field700 (@fields700){
	   my $ref= $field700->subfield("e");

	   if ($ref){
		my @refCol = split('@', $ref);
		if(($refCol[0] == 'ref_colaborador')&&($refCol[1])){
			my $colab      = C4::Modelo::RefColaborador->getByPk($refCol[1]);
			if($colab && $colab->getCodigo()){
				#print "Encontrado desde código".$colab->getCodigo()."\n";
				$field700->update( e => 'ref_colaborador@'.$colab->getCodigo());
	        	$n1->setMarcRecord($marc_record_base->as_usmarc());
				#print $marc_record_base->as_formatted();
				$n1->save();
				$reparados++;
			}
		}else{
			#print "Buscamos desde texto ".$ref."\n";
			my $colab = C4::Modelo::RefColaborador->getByPk($refCol[1]);
			my ($ref_cantidad,$ref_valores) = C4::Modelo::RefColaborador->new()->getAll(1,0,0,$ref);
			if ($ref_cantidad){
				#print "Encontrado ".$ref_valores->[0]->get_key_value."\n";
				my $colab      = C4::Modelo::RefColaborador->getByPk($ref_valores->[0]->get_key_value);
				if($colab && $colab->getCodigo()){
					#print "Encontrado desde código".$colab->getCodigo()."\n";
					$field700->update( e => 'ref_colaborador@'.$colab->getCodigo());
		        	$n1->setMarcRecord($marc_record_base->as_usmarc());
					#print $marc_record_base->as_formatted();
					$n1->save();
					$reparados++;
				}
			}
		}
	   }
	}
}

print "REPARADOS: ".$reparados;
1;