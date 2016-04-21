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

use JSON::XS;
use MARC::Record;
use MARC::File::JSON;
use C4::AR::Nivel1;
use C4::Modelo::CatRegistroMarcN1;
use Data::Dumper;

my $dato;
my $dato_ref;
my $campo;
my $subcampo;


my $nivel1_array_ref = C4::AR::Nivel1::getNivel1Completo();

my @n1_json=();

foreach my $n1 (@$nivel1_array_ref){
  eval{
    #obtengo el marc_record
    my $marc_record_n1  = $n1->getMarcRecordObject();

    #obtengo los grupos
    my $grupos = $n1->getGrupos();
    my @n2_json=();

    #de los grupos saco su marc record con los ejemplares
    foreach my $n2 (@$grupos){

      #obtengo el marc_record del NIVEL 2
      my $marc_record_n2 = $n2->getMarcRecordObject();

      my $ejemplares = $n2->getEjemplares();
      my @n3_json=();

      foreach my $n3 (@$ejemplares){
          my $marc_record_n3  =$n3->getMarcRecordObject();
          #my $marc_record_n3_datos = getMarcRecordConDatos($marc_record_n3,$n3->getTemplate);
          my $json_n3 = $marc_record_n3->as_json;
          push @n3_json, JSON::XS->new->utf8->decode($json_n3);
      }

      #my $marc_record_n2_datos = getMarcRecordConDatos($marc_record_n2,$n2->getTemplate);
      my $json_n2 = $marc_record_n2->as_json;
      my $n2_json = JSON::XS->new->utf8->decode($json_n2);
      $n2_json->{'items'} = \@n3_json;
      push @n2_json, $n2_json;
    }

    #my $marc_record_n1_datos = getMarcRecordConDatos($marc_record_n1,$n1->getTemplate);
    my $json_n1 = $marc_record_n1->as_json;
    my $n1_json = JSON::XS->new->utf8->decode($json_n1);
    $n1_json->{'editions'} = \@n2_json;
    push @n1_json, $n1_json;

    print JSON::XS->new->utf8->encode($n1_json);
    print "\n";
  }
} #END foreach my $n1 ($nivel1_array_ref)



sub getMarcRecordConDatos(){
  my ($marc_record,$template) = @_;

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
          $dato_ref     = C4::AR::Catalogacion::getRefFromStringConArrobasByCampoSubcampo($campo, $subcampo, $dato ,$template,$nivel);
          $dato         = C4::AR::Catalogacion::getDatoFromReferencia($campo, $subcampo, $dato_ref, $template,$nivel);
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
  return $marc_record_datos;
}

1;