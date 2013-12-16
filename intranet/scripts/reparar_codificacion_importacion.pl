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
use C4::AR::ImportacionIsoMARC;
use MARC::Record;


sub sustituirCaracteres {
    my($texto) = @_;

	# Se intenta reparar la coficiación de los registros antes de importar
	my %hash = (
	'ß' => 'á', 
	'Ú' => 'é',
	'ÿ' => 'í',
	'¾' => 'ó',
	'·' => 'ú',
	'±' => 'ñ',
	'┴' => 'Á',
	'║' => 'º',
  	);

 	while ( my ($from, $to) = each(%hash) ) {
        $texto =~ s/$from/$to/g;
    }

	return $texto;
}


my $id = $ARGV[0] || 1;
my $importacion = C4::AR::ImportacionIsoMARC::getImportacionById($id);

my $registros_importacion = $importacion->getRegistros();
my $cant_registros_importacion = $importacion->getCantRegistros();
my $actual=1;
foreach my $registro (@$registros_importacion){

	my $marc_record = $registro->getRegistroMARCOriginal();

	       foreach my $field ($marc_record->fields) {
        		if($field->is_control_field){
        			$field->update( sustituirCaracteres($field->data) );

        		}
        		else {
		            my @subcampos_array;
		            #proceso todos los subcampos del campo
		            foreach my $subfield ($field->subfields()) {
		                my $subcampo          = $subfield->[0];
		                my $dato              = $subfield->[1];
		                push(@subcampos_array, ( $subcampo  => sustituirCaracteres($dato)));
		             }
            		$new_field = MARC::Field->new($field->tag(), $field->indicator(1),  $field->indicator(2), @subcampos_array);
            		$field->replace_with($new_field);
         		}
         	}

   #print $marc_record->as_usmarc;
    $registro->setMarcRecord($marc_record->as_usmarc);
    $registro->save();

    print "Registro ".$actual." de ".$cant_registros_importacion."\n";

    $actual++;
}

1;