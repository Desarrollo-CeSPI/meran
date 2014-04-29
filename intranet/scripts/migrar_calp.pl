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

my $db_driver =  "mysql";
my $db_name   = 'calp_paradox';
my $db_host   = 'localhost';
my $db_user   = 'root';
my $db_passwd = 'dev';

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
			$completo.=", ".$autor->{'nombre'}
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


sub migrarLibros {
	#Leemos de la tabla de Materiales los que tienen nivel bibliográfico M
	my $material_calp=$db_calp->prepare("SELECT * FROM  MATERIAL where NivelBibliografico = 'M';");
	$material_calp->execute();

	while (my $material=$material_calp->fetchrow_hashref) {


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
    	my $idioma='ref_idioma@'.getIdioma($material->{'CodIdioma'});
		
		#Extension
    	my $extension = $material->{'Extension'};
    	if($material->{'UnidadExtension'}){
    		my $extension .= " ".$material->{'UnidadExtension'};
    	}

		#Extension
    	my $extension2 = $material->{'ExtensionSecundaria'};
    	if($material->{'UnidadExtSecundaria'}){
    		my $extension2 .= " ".$material->{'UnidadExtSecundaria'};
    	}

		#Dimension
    	my $dimension = $material->{'DimAlto'};
    	if($material->{'DimAncho'}){
    		my $dimension .= "x".$material->{'DimAncho'};
    	}
    	if($material->{'DimProfundidad'}){
    		$dimension .= "x".$material->{'DimProfundidad'};
    	}

    	if($material->{'UnidadDim'}){
    		$dimension .= " ".$material->{'UnidadDim'};
    	}


		#Fascículos
    	my $fasciculos = $material->{'Serie_NumDesde'};
    	if($material->{'Serie_NumHasta'}){
    		my $fasciculos .= "-".$material->{'Serie_NumHasta'};
    	}

		#Lista de campos
		#Tenemos Niveles 1 y 2, si ya existe el título, se agrega un nuevo 2, 
		#sino se agregan los 2 niveles
		my @campos_n1=(
			['245','h','ref_soporte@'.$soporte],
			['210','a',$material->{'ShortTitulo'}],
			['245','a',$material->{'Titulo'}],
			['245','b',$material->{'TituloUniforme'}],
			['310','a',$material->{'Frecuencia'}],
			['520','a',$material->{'Resumen'}],	
			['246','a',$material->{'TituloOriginal'}],	
			['030','a',$material->{'CODEN'}],
			);

		my @campos_n2=(

			['900','b','ref_nivel_bibliografico@m'],
			['910','a','cat_ref_tipo_nivel3@'.$material->{'CodTMaterial'}],
			['250','a',$material->{'Edicion'}],	
			['043','c',$pais],	
			['041','a',$idioma],	
			['260','a',$material->{'Lugar'}],	
			['260','b',$material->{'CodEditor'}],	 # mmmm responsable? CodEditor2 y CodEditor3
			['260','b',$material->{'CodEditor2'}],
			['260','b',$material->{'CodEditor3'}],
			['505','t',$material->{'Preliminares'}],	
			['300','a',$extension],
			['300','b',$extension2],	
			['300','c',$dimension],
			['505','a',$material->{'Notas'}],	
			['020','a',$material->{'ISBN'}],
			#Revista
			['863','b',$fasciculos],
			['863','i',$material->{'Serie_AnioReal'}],
			['863','a',$material->{'Serie_Volumen'}],
			['362','a',$material->{'Serie_Fecha'}]
			);


		my @campos_n3=(	
			#Ejemplar
			['900','i',$material->{'Observaciones'}],
			['900','g',$material->{'FechaAlta'}],
			['900','h',$material->{'FechaUltModificacion'}],
			);
		

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
			push(@campos_n1, [$c,'a','cat_autor@'.$principal->getId()]);
		}

		foreach my $aut_sec (@secundarios){
			push(@campos_n1, ['700','a','cat_autor@'.$aut_sec->[0]->getId()]);
			if($aut_sec->[1]){
				#funcion
				push(@campos_n1, ['700','e','ref_colaborador@'.$aut_sec->[1]]);
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
					push(@campos_n1, ['650','a','cat_tema@'.$cat_tema->getId()]);
				}
		}
		



		#Buscamos Ejemplares
		my @ejemplares=();
		my $cant_ejemplares=0;
		my $ejemplares_calp=$db_calp->prepare("SELECT * FROM MATSTOCK WHERE MATSTOCK.Material_RecNo = ?;");
		$ejemplares_calp->execute($material->{'RecNo'});

		while (my $ejemplar=$ejemplares_calp->fetchrow_hashref) {
				my @nuevo_ejemplar=();
				push(@nuevo_ejemplar, ['995','f', $ejemplar->{'Inventario'}]);
				push(@nuevo_ejemplar, ['995','t', $ejemplar->{'SignaturaTopografica'}]);
				push(@nuevo_ejemplar, ['995','o', 'ref_disponibilidad@'.getDisponibilidad($ejemplar->{'CodEstDisponibilidad'})]);
				push(@nuevo_ejemplar, ['995','o', 'ref_estado@'.getEstado($ejemplar->{'CodEstDisponibilidad'},$ejemplar->{'Disponible'})]);
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
				  if ($marc_record_n1->field($campo->[0])){
				  	#Existe el campo agrego subcampo
				  	$marc_record_n1->field($campo->[0])->add_subfields($campo->[1] => $campo->[2]);
				  }
				  else{
				  	#No existe el campo
					my $field= MARC::Field->new($campo->[0], '', '', $campo->[1] => $campo->[2]);
    				$marc_record_n1->append_fields($field);
				  }
			}
		}

		my $marc_record_n2 = MARC::Record->new();
		foreach my $campo (@campos_n2){
			if($campo->[2]){
				  if ($marc_record_n2->field($campo->[0])){
				  	#Existe el campo agrego subcampo
				  	$marc_record_n2->field($campo->[0])->add_subfields($campo->[1] => $campo->[2]);
				  }
				  else{
				  	#No existe el campo
					my $field= MARC::Field->new($campo->[0], '', '', $campo->[1] => $campo->[2]);
    				$marc_record_n2->append_fields($field);
				  }
			}
		}

		my $marc_record_n3_base = MARC::Record->new();
		foreach my $campo (@campos_n3){
			if($campo->[2]){
				  if ($marc_record_n3_base->field($campo->[0])){
				  	#Existe el campo agrego subcampo
				  	$marc_record_n3_base->field($campo->[0])->add_subfields($campo->[1] => $campo->[2]);
				  }
				  else{
				  	#No existe el campo
					my $field= MARC::Field->new($campo->[0], '', '', $campo->[1] => $campo->[2]);
    				$marc_record_n3_base->append_fields($field);
				  }
			}
		}

		#IMPORTAMOS!!!!!!
		print "N1\n".$marc_record_n1->as_formatted()."\n";

		  guardarNivel1DeImportacion($marc_record_n1,'LIB');


		#print "N2\n".$marc_record_n2->as_formatted()."\n";
		foreach my $ejemplar (@ejemplares){
			my $marc_record_n3 = $marc_record_n3_base->clone;
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
			print "EJEMPLAR\n".$marc_record_n3->as_formatted()."\n";
		}

	}
	
	$material_calp->finish();
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
        case "PRTG"  {return 'pt';}
        case "LAT"  {return 'la';}
        case "IT"   {return 'it';}
        case "ING"  {return 'en';}
        case "FRA"  {return 'fr';}
        case "ES"  {return 'es';}
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
    my ($marc_record, $template) = @_;
    
    my $infoArrayNivel1 =  prepararNivelParaImportar($marc_record,$template,1);
   
   my $params_n1;
    $params_n1->{'id_tipo_doc'} = $template;
    $params_n1->{'infoArrayNivel1'} = $infoArrayNivel1;
   my ($msg_object, $id1) = C4::AR::Nivel1::t_guardarNivel1($params_n1);

    return ($msg_object,$id1);
}



migrarLibros();