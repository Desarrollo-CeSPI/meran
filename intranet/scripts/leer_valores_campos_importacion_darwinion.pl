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

#campos 004 005 006

    my $hash = ();
    my $importacion = C4::AR::ImportacionIsoMARC::getImportacionById($id);

    #Limpio el detalle del Esquema
    foreach my $registro ($importacion->registros){
            my $marc = $registro->getRegistroMARCOriginal();

            my $dato004 = getDato($marc->field('004'));
            my $dato005 = getDato($marc->field('005'));
            my $dato006 = getDato($marc->field('006'));

            if($hash->{$dato004}{$dato005}{$dato006}){
                $hash->{$dato004}{$dato005}{$dato006}++;
            }else{
                $hash->{$dato004}{$dato005}{$dato006}=1;
            }
    }





	print "Campo 004, Campo 005, Campo 006, Cantidad de ocurrencias, Nivel Bibliográfico Asignado \n";

	for $c4 ( keys %$hash ) {
	    for $c5 ( keys %{$hash->{$c4} } ) {
		    for $c6 ( keys %{$hash->{$c4}{$c5} } ) {
		        print "$c4, $c5, $c6,".$hash->{$c4}{$c5}{$c6}.", \n";
		    }
	    }
	}

1;



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