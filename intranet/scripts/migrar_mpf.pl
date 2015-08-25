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
use Switch;
use C4::AR::Utilidades;
use C4::Modelo::RefPais;
use C4::Modelo::CatAutor;
use MARC::Record;
use C4::AR::ImportacionIsoMARC;
use C4::AR::Catalogacion;
use C4::Modelo::CatRegistroMarcN2Analitica;

my $op = $ARGV[0] || 0;

my $db_driver =  "mysql";
my $db_name   = 'base_mpf';
my $db_host   = 'localhost';
my $db_user   = 'root';
my $db_passwd = 'dev';


open (ERROR, '>/var/log/meran/errores_migracion_mpf_'.$op.'.txt');


my $db_mpf= DBI->connect("DBI:mysql:$db_name:$db_host",$db_user, $db_passwd);
$db_mpf->do('SET NAMES utf8');

my $dbh = C4::Context->dbh;

sub migrarAutores {
	#Leemos los Autores
	my $autores=$db_mpf->prepare("SELECT * FROM tb_autor;");
	$autores->execute();

	while (my $autor=$autores->fetchrow_hashref) {
		my $completo = $autor->{'autor_nya'};
		my $id_autor = $autor->{'autor_id'};

		if(($completo ne '') && ($completo ne '--')){
			#YA EXISTE EL AUTOR?
			my @filtros=();
	    push(@filtros, (completo => {eq => $completo}) );
	    my $existe = C4::Modelo::CatAutor::Manager->get_cat_autor_count(query => \@filtros,);

	    if (!$existe){
				my $nuevo_autor=$dbh->prepare("INSERT into cat_autor (id,completo) values (?,?);");
		        $nuevo_autor->execute($id_autor,$completo);
			}
		}
	}

	$autores->finish();
}

sub migrarTemas {
	my $temas=$db_mpf->prepare("SELECT * FROM tb_categoria;");
	$temas->execute();

	while (my $tema=$temas->fetchrow_hashref) {

		#YA EXISTE EL TEMA?
		my @filtros=();
        push(@filtros, (nombre => {eq => $tema->{'categoria_descrip'}}) );
        my $existe = C4::Modelo::CatTema::Manager->get_cat_tema_count(query => \@filtros,);

        if (!$existe){
					my $nuevo_tema =$dbh->prepare("INSERT into cat_tema (id,nombre) values (?,?);");
	        $nuevo_tema->execute($tema->{'categoria_id'},$tema->{'categoria_descrip'});
		}
	}

	$temas->finish();
}

sub migrarLibros {

	my ($registros_creados, $grupos_creados, $ejemplares_creados, $analiticas_creadas) = (0,0,0,0);

	my $template = 'LIB';
	my $nivel = "Monografico";

	my $sql= "SELECT *
			FROM tb_titulo
			LEFT JOIN tb_editorial ON tb_titulo.editorial_id = tb_editorial.editorial_id
			LEFT JOIN tb_serie ON tb_serie.serie_id = tb_titulo.serie_id
			LEFT JOIN tb_categoria ON tb_categoria.categoria_id = tb_titulo.categoria_id ;";

	#Leemos de la tabla de Materiales los que tienen nivel bibliográfico M
	my $material=$db_mpf->prepare($sql);
	$material->execute();

	my $cant =  $material->rows;
	my $count=0;
	print "Migramos $cant libros \n";

	while (my $libro=$material->fetchrow_hashref) {

		my ($marc_record_n1,$marc_record_n2,$marc_record_n3_base,$ejemplares) = prepararRegistroParaMigrar($libro,$template,$nivel);

		#IMPORTAMOS!!!!!!
		#print "N1\n".$marc_record_n1->as_formatted()."\n";
		my ($msg_object,$id1);

		#Si ya existe?
		my $n1 = buscarRegistroDuplicado($marc_record_n1,$template);
		if ($n1){
			#Ya existe!!!
		print "Nivel 1 ya existe \n";
			$id1 = $n1->getId1();
		} else {
			($msg_object,$id1) =  guardarNivel1DeImportacion($marc_record_n1,$template);
        print "Nivel 1 creado ?? ".$msg_object->{'error'}."\n";
        	if(!$msg_object->{'error'}){
        		$registros_creados++;
        	}
        	else{
        		#Logueo error
        		my $codMsg  = C4::AR::Mensajes::getFirstCodeError($msg_object);
                my $mensaje = C4::AR::Mensajes::getMensaje($codMsg,'INTRA');
				print ERROR "Error REGISTRO: Agregando Nivel 1: ".$libro->{'libro_nombre'}." registro número: ".$libro->{'titulo_id'}." (ERROR: $mensaje )\n";
        	}
        }

        if ($id1){
        		#Libros
	        	my ($msg_object2,$id1,$id2) =  guardarNivel2DeImportacion($id1,$marc_record_n2,$template);
		        print "Nivel 2 creado ?? ".$msg_object2->{'error'}."\n";
	            if (!$msg_object2->{'error'}){
	            	$grupos_creados ++;

	            	#Analíticas
	            	#my $cant_analiticas = agregarAnaliticas($id1,$id2,$material->{'RecNo'});
	            	#$analiticas_creadas += $cant_analiticas;
	        #   	print "Analiticas creadas? ".$cant_analiticas."\n";
	            	print "Ejemplaress";
					foreach my $ejemplar (@$ejemplares){
						my $marc_record_n3 = $marc_record_n3_base->clone();
						foreach my $campo (@$ejemplar){

							if($campo->[2]){
								  if ($marc_record_n3->field($campo->[0])){
								  	#Existe el campo agrego subcampo
								  	$marc_record_n3->field($campo->[0])->add_subfields($campo->[1] => $campo->[2]);
								  }
								  else{
								  	#No existe el campo
									my $field= MARC::Field->new($campo->[0], '', '', $campo->[1] => $campo->[2]);
				    				$marc_record_n3->append_fields($field);
								  }
							}
						}

						#print $marc_record_n3->as_formatted;

		                my ($msg_object3) = guardarNivel3DeImportacion($id1,$id2,$marc_record_n3,$template,'BLGL');
		     #           print "Nivel 3 creado ?? ".$msg_object3->{'error'}."\n";
		     			if (!$msg_object3->{'error'}){
	            				$ejemplares_creados ++;
						}
					}
				}
				else{
				#Logueo error
        		my $codMsg  = C4::AR::Mensajes::getFirstCodeError($msg_object2);
            my $mensaje = C4::AR::Mensajes::getMensaje($codMsg,'INTRA');
						print ERROR "Error LIBRO: Agregando Nivel 2: ".$libro->{'libro_nombre'}." registro número: ".$libro->{'libro_id'}." (ERROR: $mensaje) \n";
				}
			}


		$count ++;
		my $perc = ($count * 100) / $cant;
		my $rounded = sprintf "%.2f", $perc;

		print "Registro $count de $cant ( $rounded %)  \r\n";
	}

	$material->finish();

	print "FIN MIGRACION: \n";
	print "Registros creados: $registros_creados \n";
	print "Grupos creados: $grupos_creados \n";
	print "Ejemplares Creados: $ejemplares_creados \n";
	print "Analíticas Creadas: $analiticas_creadas \n";

}

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
    my ($marc_record, $template,$id2_padre) = @_;

    my $infoArrayNivel1 =  prepararNivelParaImportar($marc_record,$template,1);

   my $params_n1;
    $params_n1->{'id_tipo_doc'} = $template;
    $params_n1->{'infoArrayNivel1'} = $infoArrayNivel1;

   if(($template eq 'ANA')&&($id2_padre)){
    	$params_n1->{'id2_padre'} = $id2_padre;
   }

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

sub guardarNivel3DeImportacion{
    my ($id1, $id2, $marc_record, $template, $ui) = @_;


    my @infoArrayNivel = ();

    my $params_n3;
    $params_n3->{'id_tipo_doc'} = $template;
    $params_n3->{'tipo_ejemplar'} = $template;
    $params_n3->{'id1'}=$id1;
    $params_n3->{'id2'}=$id2;
    $params_n3->{'ui_origen'}=$ui;
    $params_n3->{'ui_duenio'}=$ui;
    $params_n3->{'cantEjemplares'} = 1;
    $params_n3->{'responsable'} = 'meranadmin'; #No puede no tener un responsable

    #Hay que autogenerar el barcode o no???
    $params_n3->{'esPorBarcode'} = 'true';

    my @barcodes_array=();
    $barcodes_array[0]=$marc_record->subfield('995','f');

    $params_n3->{'BARCODES_ARRAY'} = \@barcodes_array;

    my %hash_temp1 = {};
    $hash_temp1{'indicador_primario'}  = '#';
    $hash_temp1{'indicador_secundario'}  = '#';
    $hash_temp1{'campo'}   = '995';
    $hash_temp1{'subcampos_array'}   =();
    $hash_temp1{'cant_subcampos'}   = 0;

    my %hash_sub_temp1 = {};
    my $field_995 = $marc_record->field('995');
    if ($field_995){
        foreach my $subfield ($field_995->subfields()) {
            my $subcampo          = $subfield->[0];
            my $dato              = $subfield->[1];

            my $hash;
            $hash->{$subcampo}= $dato;
            $hash_sub_temp1{$hash_temp1{'cant_subcampos'}} = $hash;
            $hash_temp1{'cant_subcampos'}++;
        }
    }
    $hash_temp1{'subcampos_hash'} =\%hash_sub_temp1;
    if ($hash_temp1{'cant_subcampos'}){
      push (@infoArrayNivel,\%hash_temp1)
    }

    # Ahora TODOS los 900!
    my %hash_temp2 = {};
    $hash_temp2{'indicador_primario'}  = '#';
    $hash_temp2{'indicador_secundario'}  = '#';
    $hash_temp2{'campo'}   = '900';
    $hash_temp2{'subcampos_array'}   =();
    $hash_temp2{'cant_subcampos'}   = 0;

    my %hash_sub_temp2 = {};
    my $field_900 = $marc_record->field('900');
    if ($field_900){
        foreach my $subfield ($field_900->subfields()) {
            my $subcampo          = $subfield->[0];
            my $dato              = $subfield->[1];

            my $hash;
            $hash->{$subcampo}= $dato;
            $hash_sub_temp2{$hash_temp2{'cant_subcampos'}} = $hash;
            $hash_temp2{'cant_subcampos'}++;
        }
    }
    $hash_temp2{'subcampos_hash'} =\%hash_sub_temp2;
    if ($hash_temp2{'cant_subcampos'}){
      push (@infoArrayNivel,\%hash_temp2)
    }

    #my $infoArrayNivel3 =  prepararNivelParaImportar($marc_record,$template,3);

	###########################################################################


    $params_n3->{'infoArrayNivel3'} = \@infoArrayNivel;
    my ($msg_object3) = C4::AR::Nivel3::t_guardarNivel3($params_n3);

    return $msg_object3;
}



sub buscarRegistroDuplicado{
    my ($marc_record,$template) = @_;

    my $infoArrayNivel1 =  prepararNivelParaImportar($marc_record,$template,1);

    my $params_n1;
    $params_n1->{'id_tipo_doc'} = $template;
    $params_n1->{'infoArrayNivel1'} = $infoArrayNivel1;

     my $marc_record            = C4::AR::Catalogacion::meran_nivel1_to_meran($params_n1);
     my $catRegistroMarcN1       = C4::Modelo::CatRegistroMarcN1->new();
     my $clave_unicidad_alta    = $catRegistroMarcN1->generar_clave_unicidad($marc_record);
     my $n1 = C4::AR::Nivel1::getNivel1ByClaveUnicidad($clave_unicidad_alta);

    return $n1;
}

sub agregarAnaliticas {
        my ($id1_padre,$id2_padre, $recno) = @_;

		my $ana_sql= "SELECT * FROM  MATERIAL WHERE NivelBibliografico = 'A' AND Parent_RecNo = ? ; ";
		my $ana_calp=$db_mpf->prepare($ana_sql);
		   $ana_calp->execute($recno);

		my $analiticas_creadas=0;
		while (my $material=$ana_calp->fetchrow_hashref) {
			my ($marc_record_n1,$marc_record_n2,$marc_record_n3_base,$ejemplares) = prepararRegistroParaMigrar($material,"ANA", "Analitico");
			#N1
			my ($msg_object,$id1_analitica) =  guardarNivel1DeImportacion($marc_record_n1,"ANA",$id2_padre);
	        if(!$msg_object->{'error'}){
	        	$analiticas_creadas++;
		        #N2
	        	my ($msg_object2,$id1_analitica,$id2_analitica) =  guardarNivel2DeImportacion($id1_analitica,$marc_record_n2,"ANA");

				#Logueo error
				if ($msg_object2->{'error'}){
					my $codMsg  = C4::AR::Mensajes::getFirstCodeError($msg_object2);
                	my $mensaje = C4::AR::Mensajes::getMensaje($codMsg,'INTRA');
					print ERROR "Error Analítica: Agregando Nivel 2: ".$material->{'Titulo'}." registro número: ".$material->{'RecNo'}." registro padre número: ".$recno." (ERROR: $mensaje)\n";
				}
    		}else{
    			#Logueo error
    			my $codMsg  = C4::AR::Mensajes::getFirstCodeError($msg_object);
                my $mensaje = C4::AR::Mensajes::getMensaje($codMsg,'INTRA');
				print ERROR "Error Analítica: Agregando Nivel 1: ".$material->{'Titulo'}." registro número: ".$material->{'RecNo'}." registro padre número: ".$recno." (ERROR: $mensaje)\n";
    		}

        }
       	return $analiticas_creadas;
	}


	sub prepararRegistroParaMigrar {
		my ($material, $template, $nivel) = @_;
				#Calculamos algunos campos

		#Lista de campos
		#Tenemos Niveles 1 y 2, si ya existe el título, se agrega un nuevo 2,
		#sino se agregan los 2 niveles
		my @campos_n1=(
			['245','a',$material->{'libro_nombre'}],
			);

		my @campos_n2=(
			['900','b',$nivel],
			['910','a',$template],
			['250','a',$material->{'libro_edicion'}],
			['260','a',$material->{'editorial_ciudad'}],
			['260','b',$material->{'editorial_descrip'}],
            ['520','a',$material->{'libro_contenido'}],
			['020','a',$material->{'libro_ISBN'}],
			['300','a',$material->{'libro_paginas'}],
			);

            if($material->{'libro_fecha_publicacion'} != ""){
                push(@campos_n2, ['260','c',$material->{'libro_fecha_publicacion'}]);
            }

			if($material->{'id_serie'} > 3){
				push(@campos_n2, ['490','a',$material->{'serie_descrip'}]);
			}

		my @campos_n3=(
			);

		#Buscamos Autores
		my $autor_db = $db_mpf->prepare("SELECT autor_nya FROM tb_autor WHERE autor_id = ? ;");

		#Autor Principal
		if($material->{'autor_id'} > 2){
			$autor_db->execute($material->{'autor_id'});
			 if (my $aut=$autor_db->fetchrow_hashref){
					push(@campos_n1, ['100','a',$aut->{'autor_nya'}]);
			}
		}

		#Autor Institucional
		if($material->{'autor_inst_id'} > 2){
			$autor_db->execute($material->{'autor_inst_id'});
			 if (my $aut=$autor_db->fetchrow_hashref){
					push(@campos_n1, ['110','a',$aut->{'autor_nya'}]);
			}
		}

		#Buscamos Temas
		if($material->{'categoria_id'} > 2){
			push(@campos_n1, ['650','a',$material->{'categoria_descrip'}]);
		}

		if ($material->{'libro_descriptor'} != ''){
		  # Los descriptores están separados en algunos casos por . y en otros  por //
			my $descriptores = $material->{'libro_descriptor'};

	  	my @values = split('. ', $descriptores);
			if (scalar(@values) > 1 ){
				foreach my $val (@values) {
					push(@campos_n1, ['650','a',$val]);
				}
			}else{
				  my @values = split(' // ', $descriptores);

					if (scalar(@values) > 1 ){
						foreach my $val (@values) {
							push(@campos_n1, ['650','a',$val]);
						}
					}else{
						 push(@campos_n1, ['650','a',$descriptores])
					}
			}
		}

		#Buscamos Ejemplares
		my @ejemplares=();
		my $cant_ejemplares=0;
		my $ejemplares_mpf=$db_mpf->prepare("SELECT * FROM tb_ejemplar WHERE titulo_id = ?;");
		$ejemplares_mpf->execute($material->{'titulo_id'});
        my $cdu = 0;
		while (my $ejemplar=$ejemplares_mpf->fetchrow_hashref) {
				my @nuevo_ejemplar=();
				#UI
				push(@nuevo_ejemplar, ['995','c', 'MPF']);
				push(@nuevo_ejemplar, ['995','d', 'MPF']);

				push(@nuevo_ejemplar, ['995','f', 'MPF-'.$template."-".$ejemplar->{'ejemplar_codigo_barra'}]);
				push(@nuevo_ejemplar, ['995','t', $ejemplar->{'ejemplar_topografico'}]);
				push(@nuevo_ejemplar, ['995','o', 'CIRC0000']);
				push(@nuevo_ejemplar, ['995','e', 'STATE002']);
				push(@nuevo_ejemplar, ['995','u', $ejemplar->{'ejemplar_observaciones'}]);
				push(@nuevo_ejemplar, ['900','p', $ejemplar->{'ejemplar_fecha_ingreso'}]);

				#TOMO?
				if($ejemplar->{'ejemplar_tomo'} != ''){
					push(@campos_n2, ['505','g',$ejemplar->{'ejemplar_tomo'}]);
				}

                #CDU?
                if(($ejemplar->{'ejemplar_CDU'} != '')&&(!$cdu)){
                    $cdu = 1;
                    push(@campos_n1, ['080','a',$ejemplar->{'ejemplar_CDU'}]);
                }

                if($ejemplar->{'ejemplar_anio'} != ""){
                    push(@campos_n2, ['260','c',$ejemplar->{'ejemplar_anio'}]);
                }

				$ejemplares[$cant_ejemplares] = \@nuevo_ejemplar;
				$cant_ejemplares++;
		}


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
		my $marc_record_n3_base = MARC::Record->new();
		foreach my $campo (@campos_n3){
			if($campo->[2]){
				my @campos_registro = $marc_record_n3_base->field($campo->[0]);
				if (($campos_registro[-1])&&(!$campos_registro[-1]->subfield($campo->[1]))){
					#No existe el subcampo en el campo, lo agrego
				  	$campos_registro[-1]->add_subfields($campo->[1] => $campo->[2]);
				}
				else{
				  	#No existe el campo o ya existe el subcampo, se crea uno nuevo.
					my $field= MARC::Field->new($campo->[0], '', '', $campo->[1] => $campo->[2]);
    				$marc_record_n3_base->append_fields($field);
				}
			}
		}

		return ($marc_record_n1,$marc_record_n2,$marc_record_n3_base,\@ejemplares);
	}
################################################################################################################
################################################################################################################


    switch ($op) {
        case 0  {
        	print "NADA? Opciones: \n1: Migrar Referencias \n2: Migrar Libros \n3: Migrar Revistas \n4: Contar Analíticas\n";
        }
        case 1  {
        	print "Migrando Referencias... \n";
		 		migrarAutores ();
				migrarTemas ();
        }
        case 2  {
        	print "Migrando Libros... \n";
        	migrarLibros();
        }
        case 3  {
        	print "Migrando Revistas... \n";
        	migrar('REV');
        }
        case 4  {
        	print "Calculando Analíticas... \n";
        	#migrar('ANA')


        	#contar analiticas
        		my $lib= "SELECT * FROM  MATERIAL WHERE NivelBibliografico = 'M' OR NivelBibliografico = 'C'; ";
        		my $rev= "SELECT * FROM  MATERIAL WHERE NivelBibliografico = 'S' OR NivelBibliografico = 'X'; ";
        		my $ana= "SELECT * FROM  MATERIAL WHERE NivelBibliografico = 'A'; ";
				my $ana_calp=$db_mpf->prepare($ana);
				$ana_calp->execute();

				my $cant_ana =  $ana_calp->rows;
        		print "Las analíticas son $cant_ana \n";

        		my ($ana_lib,$ana_rev)=(0,0);

				#Leemo	s de la tabla de Materiales los que tienen nivel bibliográfico M
				my $material_calp=$db_mpf->prepare($lib);
				$material_calp->execute();

				my $cant_lib =  $material_calp->rows;
				print "Hay $cant_lib libros \n";

				my $recno1 ='';
				while (my $material=$material_calp->fetchrow_hashref) {
					if ( $recno1 ) { $recno1 .=",";}
					 $recno1 .= $material->{'RecNo'};
				 }

				my $ana_rel= "SELECT * FROM  MATERIAL WHERE NivelBibliografico = 'A' AND Parent_RecNo IN ($recno1 ); ";
			    my $ana_rel_calp=$db_mpf->prepare($ana_rel);
				$ana_rel_calp->execute();
				$ana_lib +=  $ana_rel_calp->rows;

				print "Poseen $ana_lib analíticas \n";

				#Leemo	s de la tabla de Materiales los que tienen nivel bibliográfico M
				my $material_calp=$db_mpf->prepare($rev);
				$material_calp->execute();

				my $cant_rev =  $material_calp->rows;
				print "Hay $cant_rev revistas \n";

				my $recno2 ='';
				while (my $material=$material_calp->fetchrow_hashref) {
					if ( $recno2 ) { $recno2 .=",";}
					 $recno2 .= $material->{'RecNo'};
				 }

				my $ana_rel= "SELECT * FROM  MATERIAL WHERE NivelBibliografico = 'A' AND Parent_RecNo IN ($recno2) ; ";
			    my $ana_rel_calp=$db_mpf->prepare($ana_rel);
				$ana_rel_calp->execute();
				$ana_rev +=  $ana_rel_calp->rows;

				print "Poseen $ana_rev analíticas \n";

				my $analiticas_rel = $ana_rev + $ana_lib;
				my $ana_hue = $cant_ana - $analiticas_rel;
				print "Analiticas Relacionadas = $analiticas_rel \n";
				print "Analiticas Huerfanas = $ana_hue \n";

				my $ana_hue = "SELECT * FROM  MATERIAL WHERE NivelBibliografico = 'A' AND Parent_RecNo NOT IN ($recno1 , $recno2) ; ";
			    my $ana_rel_calp=$db_mpf->prepare($ana_hue);
				$ana_rel_calp->execute();
				while (my $material=$ana_rel_calp->fetchrow_hashref) {
					print "Huefano ". $material->{'RecNo'}." \n";
				 }
        }

        case 5  {
        	print "Migrando Libros y Revistas con sus analíticas... \n";
          migrar('LIB');
        	migrar('REV');
        }
    }
