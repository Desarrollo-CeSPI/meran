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
my $db_name   = 'calp_paradox';
my $db_host   = 'localhost';
my $db_user   = 'root';
my $db_passwd = 'dev';


open (ERROR, '>/var/log/meran/errores_migracion_'.$op.'.txt');


my $db_calp= DBI->connect("DBI:mysql:$db_name:$db_host",$db_user, $db_passwd);
$db_calp->do('SET NAMES utf8');

my $dbh = C4::Context->dbh;

sub migrarAutores {
	#Leemos los Autores
	my $autores_calp=$db_calp->prepare("SELECT AUTORES.Nombre as nombre ,AUTORES.Apellido as apellido,TC_PAIS.Descripcion as pais FROM AUTORES left join TC_PAIS on AUTORES.CodPais=TC_PAIS.CodPais;");
	$autores_calp->execute();

	while (my $autor=$autores_calp->fetchrow_hashref) {
		my $completo = $autor->{'apellido'};
		if ($autor->{'nombre'}){
			$completo.=", ".$autor->{'nombre'};
		}
		
		#YA EXISTE EL AUTOR?
		my @filtros=();
        push(@filtros, (completo => {eq => $completo}) );
        my $existe = C4::Modelo::CatAutor::Manager->get_cat_autor_count(query => \@filtros,);

        if (!$existe){
			my $nacionalidad = '';
			if ($autor->{'pais'}){
				$nacionalidad= $autor->{'pais'};
	            my ($cantidad, $objetos) = (C4::Modelo::RefPais->new())->getPaisByName($autor->{'pais'});
	            if($cantidad){
	                C4::AR::Debug::debug("encontro pais =>".$objetos->[0]->getNombre());
	                $nacionalidad= $objetos->[0]->getIso3();
	            }
	    	}

			my $nuevo_autor=$dbh->prepare("INSERT into cat_autor (nombre,apellido,completo,nacionalidad) values (?,?,?,?);");
	        $nuevo_autor->execute($autor->{'nombre'},$autor->{'apellido'},$completo, $nacionalidad);
		}
	}
	
	$autores_calp->finish();
}


sub migrarTemas {
	#Leemos los Autores
	my $temas_calp=$db_calp->prepare("SELECT Materia as tema FROM MATERIAS;");
	$temas_calp->execute();

	while (my $tema=$temas_calp->fetchrow_hashref) {
	
		#YA EXISTE EL TEMA?
		my @filtros=();
        push(@filtros, (nombre => {eq => $tema->{'tema'}}) );
        my $existe = C4::Modelo::CatTema::Manager->get_cat_tema_count(query => \@filtros,);

        if (!$existe){
			my $nuevo_tema =$dbh->prepare("INSERT into cat_tema (nombre) values (?);");
	        $nuevo_tema->execute($tema->{'tema'});
		}
	}
	
	$temas_calp->finish();
}

sub migrarReferenciasColaboradores {
	#Leemos las Referencias
	my $ref_autores_calp=$db_calp->prepare("SELECT * FROM TC_TRESP;");
	$ref_autores_calp->execute();

	while (my $ref_colaborador=$ref_autores_calp->fetchrow_hashref) {
		
		#YA EXISTE EL AUTOR?
		my @filtros=();
        push(@filtros, (codigo => {eq => $ref_colaborador->{'CodTResponsabilidad'}}) );
        my $existe = C4::Modelo::RefColaborador::Manager->get_ref_colaborador_count(query => \@filtros,);

        if (!$existe){
			my $nueva_ref_colaborador=$dbh->prepare("INSERT into ref_colaborador (codigo,descripcion) values (?,?);");
	        $nueva_ref_colaborador->execute(lc($ref_colaborador->{'CodTResponsabilidad'}),$ref_colaborador->{'Descripcion'});
		}
	}
	
	$ref_autores_calp->finish();
}


sub migrar {

	my ($template)=@_;
	
	my ($registros_creados, $grupos_creados, $ejemplares_creados, $analiticas_creadas) = (0,0,0,0);

	my $sql= "SELECT * FROM  MATERIAL ";
	my $where ="";
	my $nivel = "Monografico";
	if($template eq 'LIB'){
		$where = " WHERE NivelBibliografico = 'M' OR NivelBibliografico = 'C'; ";
		$nivel = "Monografico";
	}
	elsif($template eq 'REV'){
		$where = " WHERE NivelBibliografico = 'S' OR NivelBibliografico = 'X'; ";
		$nivel = "Serie";
	}
	elsif($template eq 'ANA'){
		$where = " WHERE NivelBibliografico = 'A'; ";
		$nivel = "Analitico";	
	}
	#Leemos de la tabla de Materiales los que tienen nivel bibliográfico M
	my $material_calp=$db_calp->prepare($sql.$where);
	$material_calp->execute();
	
	my $cant =  $material_calp->rows;
	my $count=0;
	print "Migramos $cant registros \n";
	
	while (my $material=$material_calp->fetchrow_hashref) {

		my ($marc_record_n1,$marc_record_n2,$marc_record_n3_base,$ejemplares) = prepararRegistroParaMigrar($material,$template,$nivel);

		#IMPORTAMOS!!!!!!
		#print "N1\n".$marc_record_n1->as_formatted()."\n";
		my ($msg_object,$id1);
		
		#Si ya existe? 
		my $n1 = buscarRegistroDuplicado($marc_record_n1,$template);
		if ($n1){
			#Ya existe!!!
		#	print "Nivel 1 ya existe \n";
			$id1 = $n1->getId1();
		} else {
			($msg_object,$id1) =  guardarNivel1DeImportacion($marc_record_n1,$template);
        #	print "Nivel 1 creado ?? ".$msg_object->{'error'}."\n";
        	if(!$msg_object->{'error'}){
        		$registros_creados++;
        	}
        	else{
        		#Logueo error
        		my $codMsg  = C4::AR::Mensajes::getFirstCodeError($msg_object);
                my $mensaje = C4::AR::Mensajes::getMensaje($codMsg,'INTRA');
				print ERROR "Error REGISTRO: Agregando Nivel 1: ".$material->{'Titulo'}." registro número: ".$material->{'RecNo'}." (ERROR: $mensaje )\n";
        	}
        }

        if ($id1){

        	#Si es una Revista hay que generar el estado de colección
        	if($template eq 'REV'){
        		#Revistas

        		if (!scalar(@$ejemplares)){
        			#Revisar si tiene ejemplar, sino crear uno
					my @nuevo_ejemplar=();
					#UI
					push(@nuevo_ejemplar, ['995','c', 'BLGL']);
					push(@nuevo_ejemplar, ['995','d', 'BLGL']);
					# Las revistas van con disponiblidad de sala de lectura ticket #10078
					push(@nuevo_ejemplar, ['995','o', 'CIRC0001']);
					push(@nuevo_ejemplar, ['995','e', 'STATE002']);
					# La signatura en las revistas se encuentra en el CODEN. Ticket #9642
					push(@nuevo_ejemplar, ['995','t', $material->{'CODEN'}]); 
					$ejemplares->[0] = \@nuevo_ejemplar;
				}

        		#print  "REVISTAS v $volumen n $fasciculos \n";

        		my $fasciculos = $material->{'Serie_NumDesde'};
		    	if($material->{'Serie_NumHasta'}){
		    		my $fasciculos .= "-".$material->{'Serie_NumHasta'};
		    	}
		    	my $volumen = $material->{'Serie_Volumen'};

        		my @estadoDeColeccion = _generarNumerosDeVolumen($volumen,$fasciculos);
        	
            	foreach my $rev (@estadoDeColeccion){
                    my $marc_revista =  $marc_record_n2->clone();
                    my $field863 = $marc_revista->field('863');
                    if($field863){
                    	if ($field863->subfield('b')) {
                    		$field863->update( 'b' => $rev->{'numero'}.' '.$field863->subfield( 'b' ) );
                    	}else{
                    		$field863->add_subfields('b' => $rev->{'numero'}); 
                    	}
                    } else {
                    	$field863 = MARC::Field->new('863', '', '' ,'b' => $rev->{'numero'});
                    	$marc_revista->add_fields($field863);
                    }

                	my ($msg_object2,$id1,$id2) =  guardarNivel2DeImportacion($id1,$marc_revista,$template);

	            	if (!$msg_object2->{'error'}){
	            		$grupos_creados ++;

	            		#Analíticas
	            		my $cant_analiticas = agregarAnaliticas($id1,$id2,$material->{'RecNo'});
	            		$analiticas_creadas += $cant_analiticas;

	            	#	print "Se crearon $cant_analiticas analíticas \n";

	                	#Ejemplares
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

			                my ($msg_object3) = guardarNivel3DeImportacion($id1,$id2,$marc_record_n3,$template,'BLGL');
							if (!$msg_object3->{'error'}){
	            				$ejemplares_creados ++;
							}else{
								my $codMsg  = C4::AR::Mensajes::getFirstCodeError($msg_object3);
                				my $mensaje = C4::AR::Mensajes::getMensaje($codMsg,'INTRA');
                				print ERROR "Error Revista: Agregando Nivel 3: ".$material->{'Titulo'}." registro número: ".$material->{'RecNo'}." número: ".$rev->{'numero'}." (ERROR: $mensaje ) \n";
							}
						}
	                }else{
	                	#Logueo error
	                	my $codMsg  = C4::AR::Mensajes::getFirstCodeError($msg_object2);
                		my $mensaje = C4::AR::Mensajes::getMensaje($codMsg,'INTRA');
						print ERROR "Error Revista: Agregando Nivel 2: ".$material->{'Titulo'}." registro número: ".$material->{'RecNo'}." número: ".$rev->{'numero'}." (ERROR: $mensaje ) \n";
	                }
                }
        	}
        	elsif($template eq 'LIB'){
        		#Libros
	        	my ($msg_object2,$id1,$id2) =  guardarNivel2DeImportacion($id1,$marc_record_n2,$template);
		    #    print "Nivel 2 creado ?? ".$msg_object2->{'error'}."\n";
	            if (!$msg_object2->{'error'}){
	            	$grupos_creados ++;

	            	#Analíticas
	            	my $cant_analiticas = agregarAnaliticas($id1,$id2,$material->{'RecNo'});
	            	$analiticas_creadas += $cant_analiticas;
	        #   	print "Analiticas creadas? ".$cant_analiticas."\n";
	        #    	print "Ejemplaress";
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
					print ERROR "Error LIBRO: Agregando Nivel 2: ".$material->{'Titulo'}." registro número: ".$material->{'RecNo'}." (ERROR: $mensaje) \n";

				}
			}
		}
	

		$count ++;
		my $perc = ($count * 100) / $cant;
		my $rounded = sprintf "%.2f", $perc;

		print "Registro $count de $cant ( $rounded %)  \r\n";
	}
	
	$material_calp->finish();

	print "FIN MIGRACION: \n";
	print "Registros creados: $registros_creados \n";
	print "Grupos creados: $grupos_creados \n";
	print "Ejemplares Creados: $ejemplares_creados \n";
	print "Analíticas Creadas: $analiticas_creadas \n";

}


sub getIdioma{
	my ($idioma)=@_;
	#CodIdioma	idLanguage
	#PRTG	pt
	#LAT	la
	#IT	it
	#ING	en
	#FRA	fr
	#ES	es
    switch ($idioma) {
        case "PRTG"  {return 'Portugués';}
        case "LAT"  {return 'Latín';}
        case "IT"   {return 'Italiano';}
        case "ING"  {return 'Inglés';}
        case "FRA"  {return 'Francés';}
        case "ES"  {return 'Español';}
        case "HEB"  {return 'Hebreo';}
    }
    return '';
}



sub getDisponibilidad{
	my ($codigo)=@_;

	#CodEstDisponibilidad	Descripcion
	#Ex	Extraviado
	#PE	Préstamo Especial
	#PRS	Préstamo
	#SL	Sala de Lectura

    switch (uc($codigo)) {
        case "EX"  {return 'CIRC0000';}
        case "PE"  {return 'CIRC0000';}
        case "PRS"   {return 'CIRC0000';}
        case "SL"  {return 'CIRC0001';}
    }
    return 'CIRC0000';
}

sub getEstado{
	my ($codigo,$disponible)=@_;

	if ($codigo eq 'Ex'){
		#Perdido
		return 'STATE005';
	}

	if ($disponible){
		return 'STATE002';
	}else{
		return 'STATE009';
	}

}

sub getPais{
	my ($pais)=@_;

	my $pais_calp=$db_calp->prepare("SELECT TC_PAIS.Descripcion as pais FROM TC_PAIS WHERE TC_PAIS.CodPais = ?;");
	$pais_calp->execute($pais);
	my $pais = $pais_calp->fetchrow_hashref;
	my ($cantidad, $objetos) = (C4::Modelo::RefPais->new())->getPaisByName($pais_calp->{'pais'});

    if($cantidad){
        return $objetos->[0];
    }
    return '';
}

sub getAutor{
	my ($completo)=@_;

		my @filtros=();
        push(@filtros, (completo => {eq => $completo}) );
        my $ref_autor = C4::Modelo::CatAutor::Manager->get_cat_autor(query => \@filtros,);
       
	  if(scalar(@$ref_autor) > 0){
	    return ($ref_autor->[0]);
	  }else{
	    #no se pudo recuperar el objeto por el id pasado por parametro
	    return undef;
	  }
}



sub getTema{
	my ($tema)=@_;

		my @filtros=();
        push(@filtros, (nombre => {eq => $tema}) );
        my $ref_tema = C4::Modelo::CatTema::Manager->get_cat_tema(query => \@filtros,);
       
	  if(scalar(@$ref_tema) > 0){
	    return ($ref_tema->[0]);
	  }else{
	    #no se pudo recuperar el objeto por el id pasado por parametro
	    return undef;
	  }
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
    $barcodes_array[0]=generaCodigoBarraFromMarcRecord($marc_record,$template);
    
    if ($barcodes_array[0] eq 'AUTOGENERADO'){
    	#Se autogenera el barcode antes    
        my %parametros;
        $parametros{'UI'}               = $ui;
        $parametros{'tipo_ejemplar'}    = $template;
        @barcodes_array = C4::AR::Nivel3::generaCodigoBarra(\%parametros, $params_n3->{'cantEjemplares'});
    }

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

sub generaCodigoBarraFromMarcRecord{
    my($marc_record_n3,$tipo_ejemplar) = @_;

   my $barcode; 
   my @estructurabarcode = split(',', C4::AR::Preferencias::getValorPreferencia("barcodeFormat"));
    
    my $like = '';

    for (my $i=0; $i<@estructurabarcode; $i++) {
        if (($i % 2) == 0) {
            my $pattern_string ='';
            use Switch;
            switch ($estructurabarcode[$i]) {
                case 'UI' { 
                    $pattern_string= C4::AR::ImportacionIsoMARC::getUIFromMarcRecord($marc_record_n3);
                    }
                case 'tipo_ejemplar' {
                    $pattern_string= C4::AR::ImportacionIsoMARC::getTipoDocumentoFromMarcRecord($marc_record_n3);
                    }
            }
            if ($pattern_string){
                $like.= $pattern_string;
            }else{
                $like.= $estructurabarcode[$i];
            }
        } else {
            $like.= $estructurabarcode[$i];
        }
    }
    
    my $nro_inventario = $marc_record_n3->subfield('995','f');
    if ($nro_inventario){
     #viene con nro de inventario
        $barcode  = $like.C4::AR::Nivel3::completarConCeros($nro_inventario);
     }
    
    if ((C4::AR::Nivel3::existeBarcode($barcode))||(!$barcode)){
        # Si no viene el códifo en el campo 995, f  o ya existe se busca el máximo de su tipo
        $barcode  = 'AUTOGENERADO';
     }
     
    return ($barcode);
}

    sub _generarNumerosDeVolumen {
            my ($volumen,$numeros) = @_;
            my @estadoDeColeccion= (); 

            if ($numeros) {

 	#       C4::AR::Debug::debug("COLECCION  ==>  PROCESO : $numeros \n");
                
                my @numeros_separados = split(',', $numeros );

                foreach my $n (@numeros_separados){
                    if (index($n , '-') != -1) {
                        #son muchos
                        my @secuencia = split('-', $n);
                        #Agarro únicamente los 2 primeros valores, el resto lo considero erroneo. Por ej: debe venir a-b y debe ser a>b, no puede ser a-b-c y desordenado
                        if (@secuencia gt 1){
                            my $ini = C4::AR::Utilidades::trim($secuencia[0]);
                            my $fin = C4::AR::Utilidades::trim($secuencia[1]);
                            # Errores en las secuencias, secuencia inicial mayor ala final o que la diferencia sea de más de un nro por día. Hay registros erroneos y hay que evitarlos.
                            if (($ini < $fin)&&( ($fin - $ini) <= 365 )) {
                                
                                foreach my $ns ($ini..$fin) {
  #                                  C4::AR::Debug::debug("COLECCION  ==>  AGREGA UNO DE SECUENCIA: $ns \n");
                                    my $numero_limpio =C4::AR::Utilidades::trim($ns);
                                    my %fasciculo=();
                                    $fasciculo{'volumen'} = $volumen;
                                    $fasciculo{'numero'} = $numero_limpio;
                                    push(@estadoDeColeccion,\%fasciculo);
                                }
                            }
                            else{
                                # error en orden de secuencia, lo agrego igual
   #                             C4::AR::Debug::debug("COLECCION  ==>  ERROR EN ORDEN DE SECUENCIA $n => $ini <= $fin \n");
                                my $numero_limpio =C4::AR::Utilidades::trim($n);
                                     my %fasciculo=();
                                    $fasciculo{'volumen'} = $volumen;
                                    $fasciculo{'numero'} = $numero_limpio;
                                    push(@estadoDeColeccion,\%fasciculo);
                            }

                        }
                        else{
                            #uno solo, es un error, lo agrego igual
    #                        C4::AR::Debug::debug("COLECCION  ==>  ERROR: posee un - y existe un solo valor $n \n");
                            my $numero_limpio =C4::AR::Utilidades::trim($n);
                            my %fasciculo=();
                            $fasciculo{'volumen'} = $volumen;
                            $fasciculo{'numero'} = $numero_limpio;
                            push(@estadoDeColeccion,\%fasciculo);
                        }

                    }else{
                        #uno solo
    #                     C4::AR::Debug::debug("COLECCION  ==>  AGREGA UNO: $n \n");
                        my $numero_limpio =C4::AR::Utilidades::trim($n);
                        my %fasciculo=();
                        $fasciculo{'volumen'} = $volumen;
                        $fasciculo{'numero'} = $numero_limpio;
                        push(@estadoDeColeccion,\%fasciculo);
                    }

                    } #foreach
                } #if 

            else {
                        #no tiene número
                        my %fasciculo=();
                        $fasciculo{'volumen'} = $volumen;
                        $fasciculo{'numero'} = '';
                        push(@estadoDeColeccion,\%fasciculo);
            }

        return  @estadoDeColeccion;           
    }
    sub agregarAnaliticas {
        my ($id1_padre,$id2_padre, $recno) = @_;
		
		my $ana_sql= "SELECT * FROM  MATERIAL WHERE NivelBibliografico = 'A' AND Parent_RecNo = ? ; ";
		my $ana_calp=$db_calp->prepare($ana_sql);
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
		#Soporte
    	my $soporte;
		if ($material->{'CodTSoporte'} eq 'IMP'){
			$soporte=1;
		}elsif($material->{'CodTSoporte'} eq 'CD'){
			$soporte=2;
		}

		#Pais
		my $pais_obj = getPais($material->{'CodPais'});
    	my $pais='';
		if($pais_obj){
    		$pais = 'ref_pais@'.($pais_obj->getIso());
		}
		#Idioma
    	my $idioma=getIdioma($material->{'CodIdioma'});

		#Dimension
    	my $dimension = $material->{'DimAlto'};
    	if($material->{'DimAncho'}){
    		my $dimension .= "x".$material->{'DimAncho'};
    	}
    	if($material->{'DimProfundidad'}){
    		$dimension .= "x".$material->{'DimProfundidad'};
    	}

    	if($dimension  && $material->{'UnidadDim'}){
    		$dimension .= " ".$material->{'UnidadDim'};
    	}

		#Edicion Desde Hasta
    	my $fecha_edicion = $material->{'Edicion_FechaDesde'};
    	if($material->{'Edicion_FechaHasta'}){
    		my $fecha_edicion .= "-".$material->{'Edicion_FechaHasta'};
    	}

		#Fascículos
    	my $fasciculos = $material->{'Serie_NumDesde'};
    	if($material->{'Serie_NumHasta'}){
    		my $fasciculos .= "-".$material->{'Serie_NumHasta'};
    	}
    	my $volumen = $material->{'Serie_Volumen'};


 		my $nota = $material->{'Notas'};
		# Se limpian los <>
		$nota =~ s/(<|>|&lt;|&gt;)//gi;

    	if($material->{'Serie_AnioInterno'}){
    		my $anio_interno = "Año Int.: ".$material->{'Serie_AnioInterno'};
    
    		if($nota){
    			$nota .= " ".$anio_interno;
    		}
    		else{
    			$nota = $anio_interno;
    		}
    	}
		#Lista de campos
		#Tenemos Niveles 1 y 2, si ya existe el título, se agrega un nuevo 2, 
		#sino se agregan los 2 niveles
		my @campos_n1=(
			['245','h',$soporte],
			['210','a',$material->{'ShortTitulo'}],
			['245','a',$material->{'Titulo'}],
			['245','b',$material->{'TituloUniforme'}],
			['310','a',$material->{'Frecuencia'}],
			['520','a',$material->{'Resumen'}],	
			['246','a',$material->{'TituloOriginal'}],	
			['030','a',$material->{'CODEN'}],
			);

		my @campos_n2=(

			['900','b',$nivel], 
			['910','a',$template],
			['250','a',$material->{'Edicion'}],	
			['043','c',$pais],	
			['041','a',$idioma],	
			['260','a',$material->{'Lugar'}],	
			['260','c',$fecha_edicion],
			['300','c',$dimension],
      ['500','a',$nota],
			['020','a',$material->{'ISBN'}],
			
			#Revista
			['863','i',$material->{'Serie_AnioReal'}],
			['863','a',$material->{'Serie_Volumen'}],
			['863','b',$material->{'Serie_Fecha'}]
			);

		if($template eq "ANA"){
			my $extension ="";

			my $cant_paginas = C4::AR::Utilidades::trim($material->{'Extension'});
			my $desde = C4::AR::Utilidades::trim($material->{'ExtensionSecundaria'});

			if (($desde != '') && ($cant_paginas != '')){
				my $hasta = $desde + $cant_paginas - 1;
				$extension =$desde."-".$hasta;
			}
			elsif($desde != ''){
				$extension =$desde;
			}
	    	
	    	#Unidad de Extensión
	    	if($extension && $material->{'UnidadExtension'}){
	    		$extension .= " ".$material->{'UnidadExtension'};
	    	}
			push (@campos_n2,['300','a',$extension]);
		}else{
			#Extension
	    	my $extension = $material->{'Extension'};

	    	#Prelimiar de extrensión
	    	if ($extension && $material->{'Preliminares'}){
	    	   	$extension = $material->{'Preliminares'}.", ".$extension;
	    	}
	    	
	    	#Unidad de Extensión
	    	if($extension && $material->{'UnidadExtension'}){
	    		$extension .= " ".$material->{'UnidadExtension'};
	    	}

			#Extension 2
	    	my $extension2 = $material->{'ExtensionSecundaria'};
	    	if($material->{'ExtensionSecundaria'} && $material->{'UnidadExtSecundaria'}){
	    		$extension2 .= " ".$material->{'UnidadExtSecundaria'};
	    	}

			push (@campos_n2,['300','a',$extension]);
			push (@campos_n2,['300','b',$extension2]);
		}


		my @campos_n3=(	
			#Ejemplar
			['900','i',$material->{'Observaciones'}],
			['900','g',$material->{'FechaAlta'}],
			['900','h',$material->{'FechaUltModificacion'}],
			);
		
		#Buscamos Editores

		my @editores = ($material->{'CodEditor'}, $material->{'CodEditor2'}, $material->{'CodEditor3'});
		foreach $cod_ed (@editores) {

			if ($cod_ed){
				my $editor_calp=$db_calp->prepare("SELECT AUTORES.Nombre as nombre ,AUTORES.Apellido as apellido FROM AUTORES 
					WHERE AUTORES.RecNo = ? ;");
				$editor_calp->execute($cod_ed);


				if (my $editor=$editor_calp->fetchrow_hashref) {
					my $ed_completo = $editor->{'apellido'};
					if ($editor->{'nombre'}){
						$ed_completo.=", ".$editor->{'nombre'};
					}
					push (@campos_n2,['260','b',$ed_completo]);
				}
			}
		}

		#Buscamos Autores/Colaboradores
		#Autor Principal RESPMAT..AutorPrincipal = A 100a
		#Autor Secundario o Colab RESPMAT.AutorPrincipal = N 700a 700e

		my $responsables_calp=$db_calp->prepare("SELECT RESPMAT.AutorPrincipal, RESPMAT.CodTResponsabilidad, AUTORES.Nombre, AUTORES.Apellido, AUTORES.TipoResponsabilidad
				FROM RESPMAT
				LEFT JOIN AUTORES ON RESPMAT.RecNoResponsable = AUTORES.RecNo
				WHERE RESPMAT.Material_Recno = ? ;");
		$responsables_calp->execute($material->{'RecNo'});


		my $principal='';
		my $tipo_principal='';
		my $responsabilidad_principal='';
		my @secundarios=();
		
		while (my $autor=$responsables_calp->fetchrow_hashref) {
			my $completo = $autor->{'Apellido'};
			if ($autor->{'Nombre'}){
				$completo.=", ".$autor->{'Nombre'};
			}

			my $cat_autor = getAutor($completo); 

			if ($cat_autor){
				if($autor->{'AutorPrincipal'} eq 'A'){
					if($principal){ #Habia un blanco antes?
						#Colaborador
						push (@secundarios,[$principal,$responsabilidad_principal])
					}
					#Principal
					$principal = $cat_autor;
					$tipo_principal = $autor->{'TipoResponsabilidad'};
					$responsabilidad_principal = $autor->{'CodTResponsabilidad'};

				}elsif($autor->{'AutorPrincipal'} eq 'N'){
					#Colaborador
					push (@secundarios,[$cat_autor,$autor->{'CodTResponsabilidad'}])
				} else {
					#En Blanco, si hay principal va a secundario sino a principal
					if ($principal){
						push (@secundarios,[$cat_autor,$autor->{'CodTResponsabilidad'}]);
					}else{
						$principal = $cat_autor;
						$tipo_principal = $autor->{'TipoResponsabilidad'};
						$responsabilidad_principal = $autor->{'CodTResponsabilidad'};
					}
				}
			}
		}
		
		if($principal){
			my $c = '100';
			if(($tipo_principal eq 'I')||($tipo_principal eq 'T')){ 
				#Institucion
				$c='110';
			}elsif($tipo_principal eq 'E'){ 
				#Congreso
				$c='111';
			}
			push(@campos_n1, [$c,'a',$principal->getCompleto()]);
		}

		foreach my $aut_sec (@secundarios){
			push(@campos_n1, ['700','a',$aut_sec->[0]->getCompleto()]);
			if($aut_sec->[1]){
				#funcion
				push(@campos_n1, ['700','e',$aut_sec->[1]]);
			}
		}
		
		#Buscamos Temas

		my $temas_calp=$db_calp->prepare("SELECT MATERIAS.Materia,TEM_MAT.Nivel,TEM_MAT.Orden
				FROM TEM_MAT LEFT JOIN MATERIAS ON TEM_MAT.RecNoMateria =  MATERIAS.RecNo
				WHERE TEM_MAT.Material_RecNo = ? ORDER BY TEM_MAT.Orden ;");
		$temas_calp->execute($material->{'RecNo'});

		while (my $tema=$temas_calp->fetchrow_hashref) {
				my $cat_tema= getTema($tema->{'Materia'});
				if($cat_tema){
					push(@campos_n1, ['650','a',$cat_tema->getNombre()]);
				}
		}

		#Buscamos Ejemplares
		my @ejemplares=();
		my $cant_ejemplares=0;
		my $ejemplares_calp=$db_calp->prepare("SELECT * FROM MATSTOCK WHERE MATSTOCK.Material_RecNo = ?;");
		$ejemplares_calp->execute($material->{'RecNo'});

		while (my $ejemplar=$ejemplares_calp->fetchrow_hashref) {
				my @nuevo_ejemplar=();
				#UI
				push(@nuevo_ejemplar, ['995','c', 'BLGL']);
				push(@nuevo_ejemplar, ['995','d', 'BLGL']);

				push(@nuevo_ejemplar, ['995','f', $ejemplar->{'Inventario'}]);
				push(@nuevo_ejemplar, ['995','t', $ejemplar->{'SignaturaTopografica'}]);
				push(@nuevo_ejemplar, ['995','o', getDisponibilidad($ejemplar->{'CodEstDisponibilidad'})]);
				push(@nuevo_ejemplar, ['995','e', getEstado($ejemplar->{'CodEstDisponibilidad'},$ejemplar->{'Disponible'})]);
				push(@nuevo_ejemplar, ['995','p', $ejemplar->{'Precio'}]);
				push(@nuevo_ejemplar, ['995','u', $ejemplar->{'Observaciones'}]);
				push(@nuevo_ejemplar, ['900','p', $ejemplar->{'FechaAlta'}]);

				my $fecha=$ejemplar->{'FechaUltModificacion'};
				if ($ejemplar->{'FechaBaja'}){
					$fecha = $ejemplar->{'FechaBaja'};
				}
				push(@nuevo_ejemplar, ['900','h', $fecha]);

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
	 		migrarReferenciasColaboradores ();
        }
        case 2  {
        	print "Migrando Libros... \n";
        	migrar('LIB');
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
				my $ana_calp=$db_calp->prepare($ana);
				$ana_calp->execute();
				
				my $cant_ana =  $ana_calp->rows;
        		print "Las analíticas son $cant_ana \n";
        		
        		my ($ana_lib,$ana_rev)=(0,0);

				#Leemo	s de la tabla de Materiales los que tienen nivel bibliográfico M
				my $material_calp=$db_calp->prepare($lib);
				$material_calp->execute();
				
				my $cant_lib =  $material_calp->rows;
				print "Hay $cant_lib libros \n";
		
				my $recno1 ='';
				while (my $material=$material_calp->fetchrow_hashref) {
					if ( $recno1 ) { $recno1 .=",";}
					 $recno1 .= $material->{'RecNo'};
				 }

				my $ana_rel= "SELECT * FROM  MATERIAL WHERE NivelBibliografico = 'A' AND Parent_RecNo IN ($recno1 ); ";
			    my $ana_rel_calp=$db_calp->prepare($ana_rel);
				$ana_rel_calp->execute();
				$ana_lib +=  $ana_rel_calp->rows;
				
				print "Poseen $ana_lib analíticas \n";

				#Leemo	s de la tabla de Materiales los que tienen nivel bibliográfico M
				my $material_calp=$db_calp->prepare($rev);
				$material_calp->execute();
				
				my $cant_rev =  $material_calp->rows;
				print "Hay $cant_rev revistas \n";
				
				my $recno2 ='';
				while (my $material=$material_calp->fetchrow_hashref) {
					if ( $recno2 ) { $recno2 .=",";}
					 $recno2 .= $material->{'RecNo'};
				 }

				my $ana_rel= "SELECT * FROM  MATERIAL WHERE NivelBibliografico = 'A' AND Parent_RecNo IN ($recno2) ; ";
			    my $ana_rel_calp=$db_calp->prepare($ana_rel);
				$ana_rel_calp->execute();
				$ana_rev +=  $ana_rel_calp->rows;

				print "Poseen $ana_rev analíticas \n";

				my $analiticas_rel = $ana_rev + $ana_lib; 
				my $ana_hue = $cant_ana - $analiticas_rel;
				print "Analiticas Relacionadas = $analiticas_rel \n";
				print "Analiticas Huerfanas = $ana_hue \n";
        
				my $ana_hue = "SELECT * FROM  MATERIAL WHERE NivelBibliografico = 'A' AND Parent_RecNo NOT IN ($recno1 , $recno2) ; ";
			    my $ana_rel_calp=$db_calp->prepare($ana_hue);
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