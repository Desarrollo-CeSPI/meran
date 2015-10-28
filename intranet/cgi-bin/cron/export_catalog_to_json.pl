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
use C4::AR::Sphinx;
use C4::Modelo::CatRegistroMarcN1;


my $id1   = $ARGV[0] || '0'; #id1 del registro
my $flag  = $ARGV[1] || 'R_FULL'; #id1 del registro
my $tt1   = time();

C4::AR::Debug::debug("Corriendo migración del catálogo a JSON");


my $dato;
my $dato_ref;
my $campo;
my $subcampo;


my $nivel1_array_ref = C4::AR::Nivel1::getNivel1Completo();

foreach my $n1 (@$nivel1_array_ref){

  my $marc_record       = $n1->getMarcRecordFull();
  my $marc_record_datos = MARC::Record->new();

  #recorro los campos
  foreach my $field ($marc_record->fields){
      $campo = $field->tag;
      my $new_field;
      #recorro los subcampos
      foreach my $subfield ($field->subfields()) {

          $subcampo     = $subfield->[0];
          $dato         = $subfield->[1];
          # C4::AR::Debug::debug("campo, subcampo, dato: " . $field->tag . ", ". $subfield->[0] . ": " . $dato);
          my $nivel     = C4::AR::EstructuraCatalogacionBase::getNivelFromEstructuraBaseByCampoSubcampo($campo, $subcampo);
          $dato_ref     = C4::AR::Catalogacion::getRefFromStringConArrobasByCampoSubcampo($campo, $subcampo, $dato,$n1->getTemplate,$nivel);
          $dato         = C4::AR::Catalogacion::getDatoFromReferencia($campo, $subcampo, $dato_ref, $n1->getTemplate,$nivel);
          if (($dato)&&($dato ne 'NULL')){
              #Guardo el dato en el marc record solamente
              if ($new_field){
                  $new_field->add_subfields( $subcampo  => $dato );
              } else {
                  $new_field = MARC::Field->new($campo,'','',$subcampo => $dato);
                  $marc_record_datos->append_fields($new_field);
              }
          }

      } #END foreach my $subfield ($field->subfields())
  } #END foreach my $field ($marc_record->fields)

  C4::AR::Debug::debug("NIVEL 1 => ID " . $n1->getId1(). " as_usmarc " . $marc_record_datos->as_usmarc);
} #END foreach my $n1 ($nivel1_array_ref)

my $end1    = time();
my $tardo1  = ($end1 - $tt1);
my $min     = $tardo1/60;
my $hour    = $min/60;

C4::AR::Debug::debug("Finalizó la migración del catálogo a JSON - Tiempo de ejecución: " . $hour . ":" . $min);
 
1;