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

my $file = $ARGV[0] or die "Necesito un fichero CSV como parámetro\n";
my $id = $ARGV[1] || 1;
 

open(my $data, '<', $file) or die "No puedo abrir el fichero '$file' $!\n";

#Armo hash
#campos 004 005 006

my %hash = ();
my $cant=0;
while (my $line = <$data>) {
  chomp $line;
 
  my @fields = split "," , $line;
  $hash{trim(uc($fields[0]))}{trim(uc($fields[1]))}{trim(uc($fields[2]))} = trim(uc($fields[3]));
  $cant ++;
}

my $importacion = C4::AR::ImportacionIsoMARC::getImportacionById($id);
my $encontrados =0;
my $no_encontrados=0;

#Leo Registros de importación y agrego un nuevo campo 666 (que no existe en el esquema) para poner el resultado.
foreach my $registro ($importacion->registros){
    my $marc = $registro->getRegistroMARCOriginal();

    my $dato004 = trim(uc(getDato($marc->field('004'))));
    my $dato005 = trim(uc(getDato($marc->field('005'))));
    my $dato006 = trim(uc(getDato($marc->field('006'))));
    
    if($hash{$dato004}{$dato005}{$dato006}){
    	$encontrados++;
       	my $ind1='#';
        my $ind2='#';
    	$field666= MARC::Field->new('666', $ind1, $ind2,'Z' => $hash{$dato004}{$dato005}{$dato006});
		$marc->append_fields($field666);
	#	print $marc->as_formatted()."\n";
		$registro->setMarcRecord($marc->as_usmarc());
		$registro->save();
	}else{
		$no_encontrados++;
	}
}

print "Registros encontrados: ".$encontrados."\n";
print "Registros NO encontrados: ".$no_encontrados."\n";

1;


sub trim{
    my ($string) = @_;

    $string =~ s/^\s+//;
    $string =~ s/\s+$//;

    return $string;
}

sub getDato {
    my($field) = @_;
  	if($field){
    	if($field->is_control_field()){
				return $field->data;
        }else{
        	foreach my $subfield ($field->subfields()) {
                return $subfield->[1];        
            }
        }
    }
}