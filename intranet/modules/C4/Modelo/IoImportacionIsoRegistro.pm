package C4::Modelo::IoImportacionIsoRegistro;

use strict;

use C4::Modelo::IoImportacionIsoRegistro;
use C4::AR::EstructuraCatalogacionBase;
use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'io_importacion_iso_registro',

    columns => [
        id                             => { type => 'serial', overflow => 'truncate', not_null => 1 },
        id_importacion_iso             => { type => 'integer', overflow => 'truncate', not_null => 1},
        type                           => { type => 'varchar', overflow => 'truncate', length => 25},
        estado                         => { type => 'varchar', overflow => 'truncate', length => 25},
        detalle                        => { type => 'text', overflow => 'truncate'},
        matching                       => { type => 'integer', overflow => 'truncate'},
        id_matching                    => { type => 'integer', overflow => 'truncate'},
        identificacion                 => { type => 'varchar', overflow => 'truncate', length => 255},
        relacion                       => { type => 'varchar', overflow => 'truncate', length => 255},
        id1                            => { type => 'integer', overflow => 'truncate'},
        id2                            => { type => 'integer', overflow => 'truncate'},
        id3                            => { type => 'integer', overflow => 'truncate'},
        marc_record                    => { type => 'text', overflow => 'truncate', not_null => 1},
    ],


    relationships =>
    [
      ref_importacion =>
      {
         class       => 'C4::Modelo::IoImportacionIso',
         key_columns => {id_importacion_iso => 'id' },
         type        => 'one to one',
       },
    ],

    primary_key_columns => [ 'id' ],
    unique_key          => ['id'],

);

#----------------------------------- FUNCIONES DEL MODELO ------------------------------------------------


sub agregar{
    my ($self)   = shift;
    my ($params) = @_;

    $self->setIdImportacionIso($params->{'id_importacion_iso'});
    $self->setMarcRecord($params->{'marc_record'});
    if ($params->{'estado'}){
          $self->setEstado($params->{'estado'});
      }

    $self->save();
}


sub eliminar{
    my ($self)      = shift;
    my ($params)    = @_;

    #HACER ALGO SI ES NECESARIO

    $self->delete();
}


sub getRegistroMARCOriginal{
    my ($self)      = shift;
    my ($params) = @_;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());
    return $marc_record;
    }

sub getRegistroMARCResultado{
    my ($self)      = shift;
    my ($params) = @_;

    my $marc_record = MARC::Record->new();
    my $marc_record_original = $self->getRegistroMARCOriginal();

    my $importacion = C4::AR::ImportacionIsoMARC::getImportacionById($self->getIdImportacionIso());
    my $detalle_destino = $importacion->esquema->getDetalleDestino();
    my $detalle_destino_campo;

     #   C4::AR::Debug::debug($marc_record_original->as_formatted);

    foreach my $field ( $marc_record_original->fields ) {
        my $campo_original = $field->tag;

        if ($campo_original < '010'){
            my $detalle =  $importacion->esquema->getDetalleByCampoSubcampoOrigen($campo_original,'');
            if (($detalle)&&($detalle->getCampoDestino)&&( C4::AR::Utilidades::trim($detalle->getCampoDestino) != '' )){
                    $self->agregarDatoAMarcRecord($marc_record,$detalle,$field->data);
            }
        }
        else{
            foreach my $subfield ( $field->subfields() ) {
                my $subcampo_original = $subfield->[0];
                my $dato = $subfield->[1];

                my $detalle =  $importacion->esquema->getDetalleByCampoSubcampoOrigen($campo_original,$subcampo_original);

                if (($detalle)&&($detalle->getCampoDestino)&&( C4::AR::Utilidades::trim($detalle->getCampoDestino) != '' )){
                    $self->agregarDatoAMarcRecord($marc_record,$detalle,$dato);
                }

              }
            }
          #PArche revistas mal formadas TSocial
          if ($campo_original == '901'){
            foreach my $subfield ( $field->subfields() ) {
                my $subcampo_original = $subfield->[0];
                my $dato = $subfield->[1];
                if ($subcampo_original ne 's'){
                  my $detalle =  $importacion->esquema->getDetalleByCampoSubcampoOrigen('901','a');
                  if (($detalle)&&($detalle->getCampoDestino)&&( C4::AR::Utilidades::trim($detalle->getCampoDestino) != '' )){
                      $self->agregarDatoAMarcRecord($marc_record,$detalle,$dato);
                  }
                }
              }
            }

            if ($campo_original == '904'){
              foreach my $subfield ( $field->subfields() ) {
                  my $subcampo_original = $subfield->[0];
                  my $dato = $subfield->[1];
                  if (($subcampo_original ne 'n')&&($subcampo_original ne 'v')){
                    my $detalle =  $importacion->esquema->getDetalleByCampoSubcampoOrigen('904','i');
                    if (($detalle)&&($detalle->getCampoDestino)&&( C4::AR::Utilidades::trim($detalle->getCampoDestino) != '' )){
                        $self->agregarDatoAMarcRecord($marc_record,$detalle,$dato);
                    }
                  }
                }
              }


        }
    #Ahora agregamos los registros hijo
    my $registros_hijo = $self->getRegistrosHijo();
    if($registros_hijo){
        foreach my $registro (@$registros_hijo){
            my $mc=$registro->getRegistroMARCResultado();
             $marc_record->append_fields($mc->fields());
        }
    }

    return $marc_record;

}


#----------------------------------- FIN - FUNCIONES DEL MODELO -------------------------------------------

sub agregarDatoAMarcRecord {
    my ($self)      = shift;
    my ($marc_record, $detalle, $dato) = @_;

        my $ind1='#';
        my $ind2='#';

        my $estructura  = C4::AR::EstructuraCatalogacionBase::getEstructuraBaseFromCampoSubCampo($detalle->getCampoDestino, $detalle->getSubcampoDestino);
        #Lo mando a un campo por ahora
        my $new_field=0;
        if($detalle->getCampoDestino < '010'){
            #CONTROL FIELD
            $new_field = MARC::Field->new( $detalle->getCampoDestino, $dato );

           }else{
            my @fields = $marc_record->field($detalle->getCampoDestino);

            #Si es repetible o no existe el subcampo se agrega al final
            #Si no encuentro lugar se crea uno nuevo
            my $subf;
            my $done=0;

            if ($fields[-1]){
                $subf = $fields[-1]->subfield($detalle->getSubcampoDestino);
            #Hay que ver si es repetible
                if((!$subf) || (($subf)&&($estructura && $estructura->getRepetible))) {
                    #Existe el campo pero no el subcampo o existe el subcampo pero es repetible, agrego otro subcampo
                    $fields[-1]->add_subfields( $detalle->getSubcampoDestino() => $dato );
                    $done=1;
                }
            }

            if (!$done) {
                #No existe el campo o existe y no es repetible, se crea uno nuevo
                my $campo=$detalle->getCampoDestino;
                my $subcampo=$detalle->getSubcampoDestino;

                if($campo eq '650'){
                    #si hay varios temas?
                    my @temas_separados = split(',', $dato);
                    foreach my $tema (@temas_separados){
                           $marc_record->append_fields(MARC::Field->new($campo, $ind1, $ind2,$subcampo => C4::AR::Utilidades::trim($tema)));
                    }
                }else{

                    if ((@fields)&&(($campo eq '100')&&($subcampo eq 'a'))){
                       #Parche de AUTORES, si hay muchos 100 a => el resto va al 700 a
                            $campo='700';
                    }
                    if ((@fields)&&(($campo eq '110')&&($subcampo eq 'a'))) {
                       #Parche de AUTORES, si hay muchos 110 a => el resto va al 710 a
                            $campo='710';
                    }
                    $new_field= MARC::Field->new($campo, $ind1, $ind2,$subcampo => $dato);
                }
            }
        }

        if($new_field){
            $marc_record->append_fields($new_field);
        }

    }

#----------------------------------- GETTERS y SETTERS------------------------------------------------

sub setIdImportacionIso{
    my ($self) = shift;
    my ($id_imporatcion) = @_;
    utf8::encode($id_imporatcion);
    $self->id_importacion_iso($id_imporatcion);
}

sub setMarcRecord{
    my ($self)  = shift;
    my ($marc_record) = @_;
    $self->marc_record($marc_record);
}

sub getId{
    my ($self) = shift;
    return ($self->id);
}

sub getIdImportacionIso{
    my ($self) = shift;
    return ($self->id_importacion_iso);
}

sub getMarcRecord{
    my ($self) = shift;
    return ($self->marc_record);
}


sub getDetalle{
    my ($self) = shift;
    return ($self->detalle);
}


sub setDetalle{
    my ($self) = shift;
    my ($detalle) = @_;
    $self->detalle($detalle);
}



sub getEstado{
    my ($self) = shift;
    return ($self->estado);
}


sub setEstado{
    my ($self) = shift;
    my ($estado) = @_;
    $self->estado($estado);
}

sub getMatching{
    my ($self) = shift;
    return ($self->matching);
}

sub setMatching{
    my ($self) = shift;
    my ($matching) = @_;
    $self->matching($matching);
}


sub getIdMatching{
    my ($self) = shift;
    return ($self->id_matching);
}

sub setIdMatching{
    my ($self) = shift;
    my ($matching) = @_;
    $self->id_matching($matching);
}

sub getCampoDestinoJoined{
    my ($self) = shift;
    my ($campo) = @_;

    my $marc = $self->getRegistroMARCOriginal;
    my $importacion = C4::AR::ImportacionIsoMARC::getImportacionById($self->getIdImportacionIso());

    my $detalle_subcampos = $importacion->esquema->getDetalleSubcamposByCampoDestino($campo);

    my %campo={};
    my @fields = $marc->field($campo);
    foreach my $field (@fields) {
        foreach my $subcampo (@$detalle_subcampos){
            $campo{$subcampo->{'subcampo_destino'}} = $field->subfield($subcampo->{'subcampo_origen'});
        }
    }
    ########### FIXME!
    return (\%campo);
}



sub getCampoSubcampoJoined{
    my ($self) = shift;
    my ($campo,$subcampo) = @_;

    my $marc = $self->getRegistroMARCOriginal;

    my $importacion = C4::AR::ImportacionIsoMARC::getImportacionById($self->getIdImportacionIso());
    my $detalle_completo = $importacion->esquema->getDetalleByCampoSubcampoDestino($campo,$subcampo);

    my @resultado=();
    foreach my $detalle (@$detalle_completo){

        #C4::AR::Debug::debug("DETALLE ORIGEN ###".$detalle->getCampoOrigen."###".$detalle->getSubcampoOrigen );
        #Pueden venis muchos campos, se los agarra en orden para armar el resultado
        my @fields = $marc->field($detalle->getCampoOrigen);

        if (@fields){
          #indice que mantiene el orden
          my $indice_campos=0;
          #Para cada campo lo agrego al resultado
          foreach my $field (@fields){
            my $dato='';
            if($field->is_control_field()){
                    #Campo de Control
                   $dato = $field->data();
                }
                else {
                    $dato = $field->subfield($detalle->getSubcampoOrigen);
                }

            if ($dato){

              #Le agrego el separado
              if($detalle->getSeparador){
                          $dato=$detalle->getSeparador.$dato;
                          #C4::AR::Debug::debug("SEPARADOR  ###".$detalle->getSeparador."###" );
              }

              #AHORA HAY QUE AGREGARLO A LOS RESULTADOS
              if($resultado[$indice_campos]){
                  #Ya hay resultado en esa posición? concateno el dato
                  $resultado[$indice_campos].=$dato;
                }
              else{
                  #no existe, agrego
                  push(@resultado,$dato);
                }
              #avanzo el índice
              $indice_campos++;
             }

           }

        }

     }

    return (\@resultado);
}

sub getIdentificacion{
    my ($self)   = shift;
    return ($self->identificacion);
}

sub getTitulo{
    my ($self) = shift;
    my $titulo= $self->getCampoSubcampoJoined('245','a');
    if(!$titulo){
        my $padre=$self->getRegistroPadre;
        if ($padre){
            $titulo=$padre->getTitulo;
            }
        }
    return $titulo;
}

sub getAutor{
    my ($self) = shift;

    my $autor = $self->getCampoSubcampoJoined('100','a');
    if(!$autor){
        $autor = $self->getCampoSubcampoJoined('110','a');
    }

    if(!$autor){
        my $padre=$self->getRegistroPadre;
        if ($padre){
            $autor=$padre->getAutor;
            }
    }

    if(!$autor){
        $autor = $self->getCampoSubcampoJoined('111','a');
    }

    #Responsable
    if(!$autor){
        $autor = $self->getCampoSubcampoJoined('250','b');
    }

    return $autor;
}


sub setIdentificacion{
    my ($self)   = shift;
    my ($ident) = @_;
    $self->identificacion($ident);
}

sub getIdentificacionFromRecord{
    my ($self)   = shift;

    my $identificacion='';
    my $marc = $self->getRegistroMARCOriginal();

    my $campo =$self->ref_importacion->getCampoFromCampoIdentificacion;
    if(!$campo){
            $campo='001';
                }
    if ($campo){
        my $field = $marc->field($campo);
        if ($field){
            if ($field->is_control_field()){
                #Si es de control devuelvo el dato;
                $identificacion = $field->data();
                }
            else{
                #Si no es de control tiene subcampo
                my $subcampo =$self->ref_importacion->getSubcampoFromCampoIdentificacion;
                if ($subcampo){
                    $identificacion = $field->subfield($subcampo);
                    }
            }
        }
    }

    return $identificacion;
}


sub setRelacion{
    my ($self)   = shift;
    my ($rel) = @_;
    $self->relacion($rel);
}

sub getRelacionFromRecord{
    my ($self)   = shift;

    my $relacion='';
    my $marc = $self->getRegistroMARCOriginal();

    my $campo =$self->ref_importacion->getCampoFromCampoRelacion;

        if(!$campo){
            $campo='005';
                }

    if ($campo){
        my $field = $marc->field($campo);
        if ($field->is_control_field()){
            #Si es de control devuelvo el dato;
            $relacion = $field->data();
            }
        else{
            #Si no es de control tiene subcampo
            my $subcampo =$self->ref_importacion->getSubcampoFromCampoRelacion;
            if ($subcampo){
                $relacion = $field->subfield($subcampo);
                }
        }


        if ($relacion){
            #Para identificar si es un campo de realcion debe comenzar con este string
            my $pre =$self->ref_importacion->getPreambuloFromCampoRelacion;

            if(!$pre){
                    $pre='x';
                }

            if($pre){
                #todo a  minuscula
                $relacion=lc($relacion);
                $pre=lc($pre);
                if($relacion =~ m/^$pre/){
                    $relacion =~ s/^$pre//;
                }
                else{
                    $relacion ='';
                    }
            }
        }
    }

    return $relacion;
}


sub getRelacion{
    my ($self)   = shift;
    return ($self->relacion);
}


sub getCantidadDeRegistrosHijo{
     my ($self)   = shift;

     my ($cantidad,$registros) = C4::AR::ImportacionIsoMARC::getRegistrosHijoFromRegistroDeImportacionById($self->getId);

    return $cantidad;
}

sub getRegistrosHijo{
     my ($self)   = shift;

     my ($cantidad,$registros) = C4::AR::ImportacionIsoMARC::getRegistrosHijoFromRegistroDeImportacionById($self->getId);

    return $registros;
}

sub getRegistroPadre{
     my ($self)   = shift;

     my $registro_padre = C4::AR::ImportacionIsoMARC::getRegistroPadreFromRegistroDeImportacionById($self->getId);

    return $registro_padre;
}

sub getTipo{
     my ($self)   = shift;

    if($self->getIdentificacion){
        if(($self->getRelacion)&&($self->getRegistroPadre)) {
             return "Registro Hijo";
            }
        else{
        return "Registro";
        }
    }
    return "Desconocido";
}


sub getDatosFromReglasMatcheo{
     my ($self)   = shift;
     my ($reglas) = @_;

    my @reglas_datos=();

    foreach my $regla (@$reglas){

        my $dato = join('',$self->getCampoSubcampoJoined($regla->{'campo'},$regla->{'subcampo'}));

        if ($dato){
            $regla->{'dato'}=$dato;
            push (@reglas_datos,$regla);
            }
        }
    return  \@reglas_datos;
}


sub getNiveles {
     my ($self)   = shift;

    my $niveles = C4::AR::ImportacionIsoMARC::getNivelesFromRegistro($self->getId);
    return  $niveles;
}


sub getDetalleCompleto{
     my ($self)   = shift;

     my $detalle_completo = C4::AR::ImportacionIsoMARC::detalleCompletoRegistro($self->getId);

    return $detalle_completo;
}

sub aplicarImportacion {
     my ($self)   = shift;

     my $detalle = $self->getDetalleCompleto();

=begin DETALLE_REGISTRO
	$detalle->{'nivel1'} 		   => MARC Array_
												 |=> {'campo'}           		= CAMPO
												 |=> {'subcampo'}        		= SUBCAMPO
												 |=> {'liblibrarian'}			= NOMBRE
												 |=> {'orden'}					= ORDEN
												 |=> {'dato'}					= DATO
												 |=> {'referencia'}				= ES UNA REFERENCIA?
												 |=> {'referencia_encontrada'}	= SE ENCONTRO EN LA BASE? (SI SE ENCUENTRA TIENE EL id)
												 |=> {'referencia_tabla'}		= TABLA DE LA REFERENCIA
												 |_
    $detalle->{'marc_record'}      => MARC Record del Nivel 1
    $detalle->{'nivel1_template'}  => Template a usar por el Nivel 1
    $detalle->{'cantItemN1'}       => Cantidad de Ejemplares (lo usa la vista previa)
    $detalle->{'nivel2'}           => Arreglo de Niveles 2 =>
												 |=> {'nivel2_array'}           	= MARC Array_
												 |												 |=> {'campo'}           		= CAMPO
												 |												 |=> {'subcampo'}        		= SUBCAMPO
												 |												 |=> {'liblibrarian'}			= NOMBRE
												 |												 |=> {'orden'}					= ORDEN
												 |												 |=> {'dato'}					= DATO
											 	 |												 |=> {'referencia'}				= ES UNA REFERENCIA?
												 |												 |=> {'referencia_encontrada'}	= SE ENCONTRO EN LA BASE? (SI SE ENCUENTRA TIENE EL id)
												 |												 |=> {'referencia_tabla'}		= TABLA DE LA REFERENCIA
												 |												 |_
												 |=> {'marc_record'}           		= MARC Record del Nivel 2
												 |=> {'nivel2_template'}       		= Template a usar por el Nivel 2
												 |=> {'tipo_documento'}       		= Objeto Tipo de Documento (CatRefTipoNivel3)
												 |=> {'nivel_bibliografico'}       	= Objeto Nivel Bibliográfico (RefNivelBibliografico)
												 |=> {'tiene_indice'}       		= Indice del Nivel 2 (865&a)
												 |=> {'disponibles'}       			= Cant. ejemplares disponibles
												 |=> {'no_disponibles'}       		= Cant. ejemplares NO disponibles
												 |=> {'disponibles_sala'}       	= Cant. ejemplares disponibles para Sala
												 |=> {'disponibles_domiciliario'}   = Cant. ejemplares disponibles para Domicilio
												 |=> {'cant_nivel3'}   				= Cant. Niveles 3
												 |=> {'nivel3'}   					= ARREGLO DE NIVELES 3
												 |												 |=> {'marc_record'}           	= MARC Record del Nivel 3
												 |												 |=> {'tipo_documento'}        	= Tipo de Documento (CatRefTipoNivel3->id_tipo_doc)
												 |												 |=> {'barcode'}				= BARCODE
												 |												 |=> {'signatura_topografica'}	= SIGNATURA TOPOGRAFICA
												 |												 |=> {'disponibilidad'}			= OBJETO Disponibilidad (RefDisponibilidad)
											 	 |												 |=> {'estado'}					= OBJETO Estado (RefEstado)
												 |												 |_
												 |_

=cut


    $self->debug("IMPORTANDO");

    my ($msg_object, $id1);
   #SE CHEQUEA QUE NO EXISTA EL REGISTRO PRIMERO, SI EXISTE SE AGREGAN LOS EJEMPLARES
    my $n1 = $self->buscarRegistroDuplicado($detalle);

    if ($n1){
        #Encontré el registro duplicado
        #Nuevo id1
        $id1=$n1->getId1;

        $self->debug("DUPLICADO CON: ".$id1);
        my $grupos = $n1->getGrupos();
        #Se busca si ya existe el volumen o el grupo, si pasa eso se agrega solo el ejemplar, sino se agrega el nivel 2 completo

           # my $primer_grupo=$grupos->[0];
           # if($primer_grupo){
           #    $self->debug("DUPLICADO CON: ".$primer_grupo->getId2);
        my $niveles2 = $detalle->{'nivel2'};
        foreach my $nivel2 (@$niveles2){
            my $existe_grupo=0;
            foreach my $grupo (@$grupos){
                if ($grupo->getVolumen() && ($grupo->getVolumen() eq $nivel2->{'marc_record'}->subfield('505','g'))){
                    print "VOLUMEN ".$grupo->getVolumen()." EXISTE!!!\n";
                    #Existe: Agrego ejemplares únicamente
                    $existe_grupo=1;
                    my $niveles3 = $nivel2->{'nivel3'};
                    foreach my $nivel3 (@$niveles3){
                     my ($msg_object3) = $self->guardarNivel3DeImportacion($id1,$grupo->getId2,$nivel3);
                    }
                }
            }
            if(!$existe_grupo){
                #Se debe crear completo niveles 2 y 3
                my ($msg_object2,$id1,$id2) = $self->guardarNivel2DeImportacion($id1,$nivel2);
                C4::AR::Debug::debug("Nivel 2 creado ?? ".$msg_object2->{'error'}." id=".$id2);
                if (!$msg_object2->{'error'}){
                  my $niveles3 = $nivel2->{'nivel3'};
                  foreach my $nivel3 (@$niveles3){
                    my ($msg_object3) = $self->guardarNivel3DeImportacion($id1,$id2,$nivel3);
                    C4::AR::Debug::debug("Nivel 3 creado ?? ".$msg_object3->{'error'});
                  }
                }
            }
        }
    } else {
    #NO EXISTE SE IMPORTA TODO!!!

        $self->debug("NO EXISTE SE IMPORTA TODO!!! ");

       #Proceso el nivel 1 agregando las referencias que no existen!!
       ($msg_object, $id1) = $self->guardarNivel1DeImportacion($detalle);

       C4::AR::Debug::debug("Nivel 1 creado ?? ".$msg_object->{'error'}." id=".$id1);

       if (!$msg_object->{'error'}){

        my $niveles2 = $detalle->{'nivel2'};

        foreach my $nivel2 (@$niveles2){
          my ($msg_object2,$id1,$id2) = $self->guardarNivel2DeImportacion($id1,$nivel2);
           C4::AR::Debug::debug("Nivel 2 creado ?? ".$msg_object2->{'error'}." id=".$id2);
            if (!$msg_object2->{'error'}){

              my $niveles3 = $nivel2->{'nivel3'};

              foreach my $nivel3 (@$niveles3){
                my ($msg_object3) = $self->guardarNivel3DeImportacion($id1,$id2,$nivel3);
                C4::AR::Debug::debug("Nivel 3 creado ?? ".$msg_object3->{'error'});
              }
             }
          }
        }
    }

    my $mensajes=$msg_object->{'messages'};

    if ($msg_object->{'error'}){
                my $detalle = $mensajes->[0]->{'message'}." (".$mensajes->[0]->{'codMsg'}.")";
                C4::AR::Debug::debug("ERROR : ". $detalle);
                $self->setEstado('ERROR');
                $self->setDetalle($detalle);
    }
    else{
        my $detalle = "Importado en el registro: ".$id1;

        if($mensajes->[0]->{'message'}){
            #Hay algún mensaje
            $detalle .="\n ".$mensajes->[0]->{'message'}." (".$mensajes->[0]->{'codMsg'}.")";
        }

        $self->setEstado('IMPORTADO');
        $self->setDetalle($detalle);
    }

    $self->save();

    return $msg_object;
}

sub buscarRegistroDuplicado{
    my ($self)   = shift;
    my ($nivel1) = @_;


    my $infoArrayNivel1 =  $self->prepararNivelParaImportar($nivel1->{'marc_record'},$nivel1->{'nivel1_template'},1);

    my $params_n1;
    $params_n1->{'id_tipo_doc'} = $nivel1->{'nivel1_template'};
    $params_n1->{'infoArrayNivel1'} = $infoArrayNivel1;

     my $marc_record            = C4::AR::Catalogacion::meran_nivel1_to_meran($params_n1);
     my $catRegistroMarcN1       = C4::Modelo::CatRegistroMarcN1->new();
     my $clave_unicidad_alta    = $catRegistroMarcN1->generar_clave_unicidad($marc_record);
     my $n1 = C4::AR::Nivel1::getNivel1ByClaveUnicidad($clave_unicidad_alta);

    return $n1;
}

sub guardarNivel1DeImportacion{
    my ($self)   = shift;
    my ($nivel1) = @_;

    my $infoArrayNivel1 =  $self->prepararNivelParaImportar($nivel1->{'marc_record'},$nivel1->{'nivel1_template'},1);

   my $params_n1;
    $params_n1->{'id_tipo_doc'} = $nivel1->{'nivel1_template'};
    $params_n1->{'infoArrayNivel1'} = $infoArrayNivel1;
   my ($msg_object, $id1) = C4::AR::Nivel1::t_guardarNivel1($params_n1);

    return ($msg_object,$id1);
}


sub guardarNivel2DeImportacion{
    my ($self)   = shift;
    my ($id1,$nivel2) = @_;

    my $infoArrayNivel2 =  $self->prepararNivelParaImportar($nivel2->{'marc_record'},$nivel2->{'nivel2_template'},2);
    my $params_n2;
    $params_n2->{'id_tipo_doc'} = $nivel2->{'nivel2_template'};
    $params_n2->{'tipo_ejemplar'} = $nivel2->{'nivel2_template'};
    $params_n2->{'infoArrayNivel2'} = $infoArrayNivel2;
    $params_n2->{'id1'}=$id1;
    my ($msg_object2,$id1,$id2) = C4::AR::Nivel2::t_guardarNivel2($params_n2);
     # Hay que agregar el indice aca
     #  $nivel2->{'tiene_indice'}

    return ($msg_object2,$id1,$id2);
}

sub guardarNivel3DeImportacion{
    my ($self)   = shift;
    my ($id1, $id2, $nivel3) = @_;

    my $params_n3;
    $params_n3->{'id_tipo_doc'} = $nivel3->{'tipo_documento'};
    $params_n3->{'tipo_ejemplar'} = $nivel3->{'tipo_documento'};
    $params_n3->{'id1'}=$id1;
    $params_n3->{'id2'}=$id2;
    $params_n3->{'ui_origen'}=$nivel3->{'ui_origen'};
    $params_n3->{'ui_duenio'}=$nivel3->{'ui_duenio'};

    $params_n3->{'ui_origen'}=$nivel3->{'ui_origen'};
    $params_n3->{'ui_duenio'}=$nivel3->{'ui_duenio'};

    $params_n3->{'responsable'} = 'meranadmin'; #No puede no tener un responsable

    $params_n3->{'cantEjemplares'} = 1;

    #Hay que autogenerar el barcode o no???
    if (!$nivel3->{'generar_barcode'}){
      $params_n3->{'esPorBarcode'} = 'true';
      my @barcodes_array=();
      $barcodes_array[0]=$nivel3->{'barcode'};
      $params_n3->{'BARCODES_ARRAY'} = \@barcodes_array;
    }

    my @infoArrayNivel=();

    my %hash_temp = {};
    $hash_temp{'indicador_primario'}  = '#';
    $hash_temp{'indicador_secundario'}  = '#';
    $hash_temp{'campo'}   = '995';
    $hash_temp{'subcampos_array'}   =();
    $hash_temp{'cant_subcampos'}   = 0;

    my %hash_sub_temp = {};

    #UI origen
    my $hash;
    $hash->{'d'}= $params_n3->{'ui_origen'};
    $hash_sub_temp{$hash_temp{'cant_subcampos'}} = $hash;
    $hash_temp{'cant_subcampos'}++;
    #UI duenio
    my $hash;
    $hash->{'c'}= $params_n3->{'ui_duenio'};
    $hash_sub_temp{$hash_temp{'cant_subcampos'}} = $hash;
    $hash_temp{'cant_subcampos'}++;

    #Estado
    my $hash;
    $hash->{'e'}= $nivel3->{'estado'}->getCodigo();
    $hash_sub_temp{$hash_temp{'cant_subcampos'}} = $hash;
    $hash_temp{'cant_subcampos'}++;

    #Disponibilidad
    my $hash;
    $hash->{'o'}= $nivel3->{'disponibilidad'}->getCodigo();
    $hash_sub_temp{$hash_temp{'cant_subcampos'}} = $hash;
    $hash_temp{'cant_subcampos'}++;

    #Inventario
    my $hash;
    $hash->{'s'}= $nivel3->{'inventario'};
    $hash_sub_temp{$hash_temp{'cant_subcampos'}} = $hash;
    $hash_temp{'cant_subcampos'}++;

    #Signatura
    my $hash;
    $hash->{'t'}= $nivel3->{'signatura_topografica'};
    $hash_sub_temp{$hash_temp{'cant_subcampos'}} = $hash;
    $hash_temp{'cant_subcampos'}++;

    #ABM
    my $hash;
    $hash->{'m'}= $nivel3->{'fecha_alta'};
    $hash_sub_temp{$hash_temp{'cant_subcampos'}} = $hash;
    $hash_temp{'cant_subcampos'}++;

    #Valor_doc
    my $hash;
    $hash->{'p'}= $nivel3->{'valor_doc'};
    $hash_sub_temp{$hash_temp{'cant_subcampos'}} = $hash;
    $hash_temp{'cant_subcampos'}++;



    $hash_temp{'subcampos_hash'} =\%hash_sub_temp;
    if ($hash_temp{'cant_subcampos'}){
      push (@infoArrayNivel,\%hash_temp)
    }

    # Ahora TODOS los 900!
    my %hash_temp2 = {};
    $hash_temp2{'indicador_primario'}  = '#';
    $hash_temp2{'indicador_secundario'}  = '#';
    $hash_temp2{'campo'}   = '900';
    $hash_temp2{'subcampos_array'}   =();
    $hash_temp2{'cant_subcampos'}   = 0;

    my %hash_sub_temp2 = {};

    my $marc_record_n3 = $nivel3->{'marc_record'};

    my $field_900 = $marc_record_n3->field('900');
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

    $params_n3->{'infoArrayNivel3'} = \@infoArrayNivel;
    my ($msg_object3) = C4::AR::Nivel3::t_guardarNivel3($params_n3);

    return $msg_object3;
}

sub prepararNivelParaImportar{
     my ($self)   = shift;
     my ($marc_record, $itemtype, $nivel) = @_;


   my @infoArrayNivel=();
      # $self->debug($marc_record->as_formatted);
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
