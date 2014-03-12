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
    my $conCampo773=0;
    my $registroPadreEncontrado=0;
    my $registroSinTitulo=0;
    my $registroTotales=0;


    #Limpio el detalle del Esquema
    foreach my $registro ($importacion->registros){
            my $marc = $registro->getRegistroMARCOriginal();
            $registroTotales++;
            if($marc->field('773')){
                $conCampo773++;
                my $campo = getDato($marc->field('773'));
                my $titulo = $marc->field('773')->subfield('t');

                if ($titulo){
                    my ($resultados) = buscar_titulo($titulo);
                    
                    $hash->{$titulo}{$campo}{'encontrados'}=scalar(@$resultados);
                    if(scalar(@$resultados) > 0 ){
                        $registroPadreEncontrado++;
                        $hash->{$titulo}{$campo}{'id_registro_padre'}=$resultados->[0]->getId();

                    }

                    if($hash->{$titulo}{$campo}){
                        $hash->{$titulo}{$campo}{'ocurrencias'}++;
                    }else{
                        $hash->{$titulo}{$campo}{'ocurrencias'}=1;
                    }
                    
                    $hash->{$titulo}{$campo}{'id_registro_importacion'}=$registro->getId();

                }else{
                    $registroSinTitulo++;
                    if($hash->{'SIN TITULO'}{$campo}){
                        $hash->{'SIN TITULO'}{$campo}{'ocurrencias'}++;
                    }else{
                        $hash->{'SIN TITULO'}{$campo}{'ocurrencias'}=1;
                    }
                    $hash->{'SIN TITULO'}{$campo}{'encontrados'}='NO BUSCADO';
                    $hash->{'SIN TITULO'}{$campo}{'id_registro_importacion'}=$registro->getId();

                }


            }
    }





	print "ID Registro Importado ## Titulo ## Campo 773 ## Ocurrencias ## Padre Encontrado? ## ID1 Registro padre \n";

	for $c4 ( keys %$hash ) {
	    for $c5 ( keys %{$hash->{$c4} } ) {
		        print $hash->{$c4}{$c5}{'id_registro_importacion'}." ## $c4 ## $c5 ## ".$hash->{$c4}{$c5}{'ocurrencias'}." ## ".$hash->{$c4}{$c5}{'encontrados'}."## ".$hash->{$c4}{$c5}{'id_registro_padre'}." ##\n";
	    }
	}

print "REGISTROS TOTALES = $registroTotales \n";
print "REGISTROS CON 773 = $conCampo773 \n";
print "REGISTROS CON 773 pero sin titulo (subcampo t) = $registroSinTitulo \n";
print "REGISTROS CON PADRES ENCONTRADOS = $registroPadreEncontrado \n";

1;



sub getDato {
    my($field) = @_;
  	if($field){
    	if($field->is_control_field()){
				return $field->data;
        }else{
        	foreach my $subfield ($field->subfields()) {
                return join (' || ',@$subfield);        
            }
        }
    }
}   

sub buscar_titulo{
    my ($titulo) = @_;

    my $db = C4::Modelo::IndiceBusqueda->new()->db();

    my $indice_array_ref = C4::Modelo::IndiceBusqueda::Manager->get_indice_busqueda (
                                                                        db => $db,
                                                                        query => [
                                                                                    titulo => { eq => $titulo },
                                                                            ]
                                                                );


        return $indice_array_ref;

}