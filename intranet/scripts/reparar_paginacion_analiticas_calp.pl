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

use C4::Context;
use C4::Modelo::CatRegistroMarcN2;
use C4::Modelo::CatRegistroMarcN2::Manager;

my $nivel2_array_ref = C4::AR::Nivel2::getAllNivel2();
my $cant=0;
foreach my $nivel2 (@$nivel2_array_ref){

    my $tipo_doc = $nivel2->getTipoDocumento();

	if($tipo_doc eq 'ANA'){
        my $marc_record = MARC::Record->new_from_usmarc($nivel2->getMarcRecord());
        my $field300    = $marc_record->field("300");
        if($field300){
	        my $pag= $field300->subfield("a");

		   if ($pag){
			   	if($pag=~ s/páginas//g){

			   	#print "p. ".$pag."\n";
		        $field300->update( a => "p. ".$pag);
		        $nivel2->setMarcRecord($marc_record->as_usmarc());
				$nivel2->save();
				#print $marc_record->as_usmarc()."\n";
				$cant++;
				}
			}
		}
	}
}

print "Cantidad ".$cant."\n";
1;