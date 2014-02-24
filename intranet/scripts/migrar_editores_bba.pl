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

use CGI::Session;
use C4::Context;
use  C4::AR::ImportacionIsoMARC;

my $id = $ARGV[0] || 1;
my $notfound=0;
my $witheditor=0;
my $fixed=0;

my $importacion = C4::AR::ImportacionIsoMARC::getImportacionById($id);

foreach my $registro ($importacion->registros){
    
    my $marc = $registro->getRegistroMARCOriginal();
    my $barcode = $marc->subfield('102','a'); 
    my $completo = 'DBA-LIB-'.completarConCeros($barcode);
    my $editor = $marc->subfield('108','a');
	my $n3 = C4::AR::Nivel3::getNivel3FromBarcode($completo);
	if ($n3){
		my $marc_record = MARC::Record->new_from_usmarc($n3->nivel2->getMarcRecord());
		if (!$marc_record->subfield("260","b")) {
			if($editor){

        	my $field = $marc_record->field('260');
        	if($field){
                    $field->add_subfields( 'b' => $editor );
			}else{
	                my @subcampos_array;
	                push(@subcampos_array, ('b' => $editor));
	                my $new_field = MARC::Field->new('260','','',@subcampos_array);
	                $marc_record->append_fields($new_field);
			}

			$n3->nivel2->setMarcRecord($marc_record->as_usmarc);
            $n3->nivel2->save();
			$fixed++;
			}
		}
		else{
			$witheditor++;
		}
	}
	else{
		$notfound++;
	}
}

print "NO ENCONTRADOS: ".$notfound."\n";
print "CON EDITOR : ".$witheditor."\n";
print "ARREGLADOS : ".$fixed."\n";


sub completarConCeros {
    my ($numero) = @_;
    my $ceros = '';
    my $longitud = 5;
    for(my $j=0;(($j + length($numero)) < $longitud) ;$j++){
        $ceros.= "0";
    }
    return $ceros.$numero;
}

1;
