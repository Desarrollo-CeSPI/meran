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
foreach my $nivel2 (@$niveles2){
    my $flag = 0;
    my $marc_record = MARC::Record->new_from_usmarc($nivel2->getMarcRecord());
    my @values = $marc_record->subfield($campo, $subcampo);
    foreach my $dato (@values){
       if (C4::AR::Utilidades::validateString($dato) && !($dato =~ m/cat_editorial/)){
           
                    #es una referencia, yo tengo el dato nomás (luego se verá si hay que crear una nueva o ya existe en la base)
                    my $tabla = "editorial";
                    my ($clave_tabla_referer_involved,$tabla_referer_involved) =  C4::AR::Referencias::getTablaInstanceByAlias($tabla);
                    my ($ref_cantidad,$ref_valores) = $tabla_referer_involved->getAll(1,0,0,$dato);

                    if ($ref_cantidad){
                      #REFERENCIA ENCONTRADA
                        $dato =  $ref_valores->[0]->get_key_value;
                    }
                    else { #no existe la referencia, hay que crearla
                      $dato = C4::AR::ImportacionIsoMARC::procesarReferencia($dato,$tabla,$clave_tabla_referer_involved,$tabla_referer_involved);
                      $creados++;
                    }
        if($dato){
          $marc_record->field($campo)->update($subcampo => 'cat_editorial@'.$dato);
          $nivel2->setMarcRecord($marc_record->as_usmarc());
          $nivel2->save();
        }
       }
    }
}


print "CREADOS => ".$creados."\n";
print "MODIFICADOS => ".$modificados."\n";
1;