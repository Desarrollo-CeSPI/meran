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

use DBI;

use CGI::Session;
use C4::Context;
use C4::AR::Utilidades;
use C4::Modelo::RefPais;
use C4::Modelo::CatAutor;
use C4::AR::ImportacionIsoMARC;

use File::Fetch;


my $op = $ARGV[0] || 0;

my $db_driver =  "mysql";
my $db_name   = 'ant_mpf';
my $db_host   = 'db';
my $db_user   = 'root';
my $db_passwd = 'dev';

my $template = 'LEG';
my $nivel = "Monografico";

my $db_mpf= DBI->connect("DBI:mysql:$db_name:$db_host",$db_user, $db_passwd);
$db_mpf->do('SET NAMES utf8');

my $dbh = C4::Context->dbh;

#Leemos los antecedentes
my $antecedentes=$db_mpf->prepare("SELECT * FROM Antecedente left join AntecedenteEn on Antecedente.IdUbicacion = AntecedenteEn.IdAntecedenteEn;");
$antecedentes->execute();


my $cant_ant=0;

while (my $antecedente=$antecedentes->fetchrow_hashref) {

	my @campos_n1=(
		['245','a',$antecedente->{'NumeroLey'}],
		['245','b',$antecedente->{'Descriptores'}],
		['856','u',$antecedente->{'Archivo'}],
		['650','a',$antecedente->{'Voces'}],	
		['500','a',$antecedente->{'En'}],	
		);

	my $marc_record_n1 = MARC::Record->new();
	foreach my $campo (@campos_n1){
		if($campo->[2]){
			my @campos_registro = $marc_record_n1->field($campo->[0]);
			if (($campos_registro[-1])&&(!$campos_registro[-1]->subfield($campo->[1]))){
				#No existe el subcampo en el campo, lo agrego
			  	$campos_registro[-1]->add_subfields($campo->[1] => $campo->[2]);
			}
			else{
			  	#No existe el campo o ya existe el subcampo, se crea uno nuevo.
				my $field= MARC::Field->new($campo->[0], '', '', $campo->[1] => $campo->[2]);
				$marc_record_n1->append_fields($field);
			}
		}
	}
  print $marc_record_n1->as_formatted()."\n";
	my ($msg_object,$id1) = guardarNivel1DeImportacion($marc_record_n1,$template);

  if ($id1){

    my @campos_n2=(
      ['900','b',$nivel], 
      ['910','a',$template],
      );

      my $marc_record_n2 = MARC::Record->new();
      foreach my $campo (@campos_n2){
        if($campo->[2]){
          my @campos_registro = $marc_record_n2->field($campo->[0]);
          if (($campos_registro[-1])&&(!$campos_registro[-1]->subfield($campo->[1]))){
            #No existe el subcampo en el campo, lo agrego
              $campos_registro[-1]->add_subfields($campo->[1] => $campo->[2]);
          }
          else{
              #No existe el campo o ya existe el subcampo, se crea uno nuevo.
            my $field= MARC::Field->new($campo->[0], '', '', $campo->[1] => $campo->[2]);
              $marc_record_n2->append_fields($field);
          }
        }
      }

    my ($msg_object2,$id1,$id2) =  guardarNivel2DeImportacion($id1,$marc_record_n2,$template);
  }
  
  $cant_ant++;
}

$antecedentes->finish();

print "Antecedentes ".$cant_ant."\n";


sub prepararNivelParaImportar{
     my ($marc_record, $itemtype, $nivel) = @_;

   	   my @infoArrayNivel=();
       foreach my $field ($marc_record->fields) {
        if(! $field->is_control_field){

            my %hash_temp                       = {};
            $hash_temp{'campo'}                 = $field->tag;
            $hash_temp{'indicador_primario'}    = $field->indicator(1);
            $hash_temp{'indicador_secundario'}  = $field->indicator(2);
            $hash_temp{'subcampos_array'}       = ();
            $hash_temp{'subcampos_hash'}        = ();
            $hash_temp{'cant_subcampos'}        = 0;

            my %hash_sub_temp = {};
            my @subcampos_array;
            #proceso todos los subcampos del campo
            foreach my $subfield ($field->subfields()) {
                my $subcampo          = $subfield->[0];
                my $dato              = $subfield->[1];


                C4::AR::Debug::debug("REFERENCIA!!!  ".$hash_temp{'campo'}."  ". $subcampo);

                my $estructura = C4::AR::Catalogacion::_getEstructuraFromCampoSubCampo($hash_temp{'campo'} , $subcampo , $itemtype , $nivel);

                if(($estructura)&&($estructura->getReferencia)&&($estructura->infoReferencia)){

                    C4::AR::Debug::debug("REFERENCIA!!!  ".$estructura->infoReferencia);
                    #es una referencia, yo tengo el dato nomás (luego se verá si hay que crear una nueva o ya existe en la base)
                    my $tabla = $estructura->infoReferencia->getReferencia;
                    my ($clave_tabla_referer_involved,$tabla_referer_involved) =  C4::AR::Referencias::getTablaInstanceByAlias($tabla);
                    my ($ref_cantidad,$ref_valores) = $tabla_referer_involved->getAll(1,0,0,$dato);

                    if ($ref_cantidad){
                      #REFERENCIA ENCONTRADA
                        $dato =  $ref_valores->[0]->get_key_value;
                    }
                    else { #no existe la referencia, hay que crearla
                      $dato = C4::AR::ImportacionIsoMARC::procesarReferencia($dato,$tabla,$clave_tabla_referer_involved,$tabla_referer_involved);
                    }
                 }
                #ahora guardo el dato para importar
                if ($dato){
                  C4::AR::Debug::debug("CAMPO: ". $hash_temp{'campo'}." SUBCAMPO: ".$subcampo." => ".$dato);
                  my $hash;
                  $hash->{$subcampo}= $dato;

                  $hash_sub_temp{$hash_temp{'cant_subcampos'}} = $hash;
                  push(@subcampos_array, ($subcampo => $dato));

                  $hash_temp{'cant_subcampos'}++;
                }

              }

          if ($hash_temp{'cant_subcampos'}){
            $hash_temp{'subcampos_hash'} =\%hash_sub_temp;
            $hash_temp{'subcampos_array'} =\@subcampos_array;
            push (@infoArrayNivel,\%hash_temp)
          }
        }
      }

    	return  \@infoArrayNivel;
}


sub guardarNivel1DeImportacion{
    my ($marc_record, $template) = @_;
    
    my $infoArrayNivel1 =  prepararNivelParaImportar($marc_record,$template,1);
   
   my $params_n1;
    $params_n1->{'id_tipo_doc'} = $template;
    $params_n1->{'infoArrayNivel1'} = $infoArrayNivel1;

   my ($msg_object, $id1) = C4::AR::Nivel1::t_guardarNivel1($params_n1);

    return ($msg_object,$id1);
}

sub guardarNivel2DeImportacion{
    my ($id1,$marc_record,$template) = @_;
    
    my $infoArrayNivel2 =  prepararNivelParaImportar($marc_record,$template,2);   
    my $params_n2;
    $params_n2->{'id_tipo_doc'} = $template;
    $params_n2->{'tipo_ejemplar'} = $template;
    $params_n2->{'infoArrayNivel2'} = $infoArrayNivel2;
    $params_n2->{'id1'}=$id1;

    my ($msg_object2,$id1,$id2) = C4::AR::Nivel2::t_guardarNivel2($params_n2);
    return ($msg_object2,$id1,$id2);
}