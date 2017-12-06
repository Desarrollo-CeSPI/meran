package C4::AR::Nivel3;


use strict;
require Exporter;
use C4::Context;
use C4::Date;
use C4::AR::Preferencias;
use C4::Modelo::CatRegistroMarcN3;
use C4::Modelo::CatRegistroMarcN3::Manager;
use C4::Modelo::CircPrestamo;
use C4::Modelo::CircPrestamo::Manager;
use C4::Modelo::CatHistoricoDisponibilidad;
use C4::Modelo::CatHistoricoDisponibilidad::Manager;
use C4::Modelo::RepHistorialCirculacion;
use C4::Modelo::RepHistorialCirculacion::Manager;
use C4::AR::Nivel1 qw(getNivel1FromId1); 
use C4::AR::Nivel2 qw(getNivel2FromId1 getNivel2FromId2);
use C4::AR::Reservas qw(cantReservasPorGrupo);
use C4::AR::Estantes;
use C4::AR::Sphinx qw(generar_indice);

use vars qw(@EXPORT_OK @ISA);

@ISA=qw(Exporter);

@EXPORT_OK=qw(
    &detalleCompletoINTRA
    &detalleNivel3
    &getBarcode
    &modificarEstadoItem
    &getNivel3FromId3
    &cantNiveles3FromId1
    checkReferenciaTipoDoc
);


=item
    Checkea que el tipo de documento recibido por parametro no este referenciado en nivel3
    Si ya recibio que esta referenciado, no hace la consulta
=cut
sub checkReferenciaTipoDoc{

    my ($tipoDoc, $cantReferencias) = @_;

    if($cantReferencias ne 0){

        my @filtros;

        push (@filtros, (template       => {eq      => $tipoDoc}) );
        push (@filtros, (marc_record    => { like   => '%@'.$tipoDoc.'%'}));

        my $countReferences = C4::Modelo::CatRegistroMarcN1::Manager->get_cat_registro_marc_n1_count( 
                                                                                    query => \@filtros,
                                                                    );

        return ($countReferences);

    }else{

        return $cantReferencias;

    }
}

=head2
    sub t_guardarNivel3
=cut
sub t_guardarNivel3 {
    my($params) = @_;

    my $msg_object  = C4::AR::Mensajes::create();
    my $id3         = undef;
    my $catRegistroMarcN3;

    my $catRegistroMarcN3_tmp   = C4::Modelo::CatRegistroMarcN3->new();  
    my $db = $catRegistroMarcN3_tmp->db;
    
    use Apache::Session::Lock::Semaphore;
    my $locker = new Apache::Session::Lock::Semaphore;
    
    # enable transactions, if possible
    $db->{connect_options}->{AutoCommit} = 0;
    $db->begin_work;

    #Semaphore para acceso exclusivo al bloque entre procesos
    $locker->acquire_write_lock();

    eval {
        #obtengo el tipo de ejemplar a partir del id2 del nivel 2
        $params->{'tipo_ejemplar'} = $params->{'id_tipo_doc'} || C4::AR::Nivel2::getTipoEjemplarFromId2($params->{'id2'});
        #se genera el arreglo de barcodes validos para agregar a la base y se setean los mensajes para el usuario (mensajes de ERROR)
        my ($barcodes_para_agregar) = _generarArreglo($params, $msg_object);
        C4::AR::Debug::debug("\n\n\n ENTRANDO A FOR DE BARCODES \n\n\n");
        
        foreach my $barcode (@$barcodes_para_agregar){
            
            C4::AR::Debug::debug("\n\n\n PROCESANDO BARCODE ".$barcode."\n\n\n");
        
            #se procesa un barcode por vez junto con la info del nivel 3 y nivel3 repetible
            my $marc_record         = C4::AR::Catalogacion::meran_nivel3_to_meran($params);
            $catRegistroMarcN3      = C4::Modelo::CatRegistroMarcN3->new(db => $db);  
        
            #genero el subcampo para el barcode
            my $field = $marc_record->field('995'); 
            $field->update('f' => uc($barcode));
            $params->{'marc_record'} = $marc_record->as_usmarc;
            $catRegistroMarcN3->agregar($db, $params, $msg_object);
             
            C4::AR::Debug::debug("\n\n\n SE GUARDO!!! NIVEL 3 ".$marc_record->as_formatted."\n\n\n");
            
            #recupero el id3 recien agregado
            $id3 = $catRegistroMarcN3->getId3;
            C4::AR::Debug::debug("t_guardarNivel3 => ID 3 => ".$id3);
            
            ###Guardamos en registro de modificación###
            use C4::Modelo::RepRegistroModificacion;
            my ($registro_modificacion) = C4::Modelo::RepRegistroModificacion->new(db=>$db);
            my $data_hash;
            $data_hash->{'responsable'}= $params->{'responsable'}; #Usuario logueado
            $data_hash->{'nota'}    = '';
            $data_hash->{'tipo'}    = 'CATALOGO';
            $data_hash->{'operacion'} = 'ALTA';
            $data_hash->{'id_rec'}    = $id3;
            $data_hash->{'nivel_rec'} = '3';
            $data_hash->{'prev_rec'} = '';
            $data_hash->{'final_rec'} = $catRegistroMarcN3->getMarcRecordConDatos()->as_usmarc();
            my $dateformat = C4::Date::get_date_format();
            my $hoy = C4::Date::format_date_in_iso(Date::Manip::ParseDate("today"),$dateformat);
            $data_hash->{'fecha'}    = $hoy;
            $registro_modificacion->agregar($data_hash);
            ###Guardamos en registro de modificación###

            #se agregaron los barcodes con exito
            if(!$msg_object->{'error'}){
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U370', 'params' => [$catRegistroMarcN3->getBarcode]} );
            }
            
        }

        if(defined $id3){
            unless($params->{'no_index'}){
                eval {
                    C4::AR::Sphinx::generar_indice($catRegistroMarcN3->getId1, 'R_PARTIAL', 'INSERT');
                    #ahora el indice se encuentra DESACTUALIZADO
                    C4::AR::Preferencias::setVariable('indexado', 0, $db);
                };    
                if ($@){
                    C4::AR::Debug::debug("ERROR AL REINDEXAR EN EL REGISTRO: ".$catRegistroMarcN3->getId1()." !!! ( ".$@." )");
                }
            }
        }

        $db->commit;
    };

    if ($@){
        #Se loguea error de Base de Datos
        &C4::AR::Mensajes::printErrorDB($@, 'B429',"INTRA");
        $db->rollback;
        #Se setea error para el usuario
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U373', 'params' => []} ) ;
    }

    $db->{connect_options}->{AutoCommit} = 1;

    $locker->release_write_lock();
    return ($msg_object);
}


=head2 sub t_modificarNivel3
    Modifica los ejemplares del nivel 3 pasados por parametro
    @parametros:
        $params->{'ID3_ARRAY'}: arreglo de ID3
=cut
sub t_modificarNivel3 {
    my ($params) = @_;

    my $msg_object              = C4::AR::Mensajes::create();
    my $cat_registro_marc_n3    = C4::Modelo::CatRegistroMarcN3->new();
    my $marc_record             = C4::AR::Catalogacion::meran_nivel3_to_meran($params);
    my $db                      = $cat_registro_marc_n3->db;
    $params->{'modificado'}     = 1;

    # enable transactions, if possible
    $db->{connect_options}->{AutoCommit} = 0;
    
    eval {

        my $id3_array   = $params->{'ID3_ARRAY'}; 
        my $cant        = scalar(@$id3_array);

        for(my $i=0;$i<$cant;$i++){
            C4::AR::Debug::debug("t_modificarNivel3 => ID3 a modificar: ".$params->{'ID3_ARRAY'}->[$i]);

            $params->{'id3'}        = $params->{'ID3_ARRAY'}->[$i];
            ($cat_registro_marc_n3) = getNivel3FromId3($params->{'ID3_ARRAY'}->[$i], $db);

            my $old_marc_record = "";
            if ($cat_registro_marc_n3){
                $old_marc_record = $cat_registro_marc_n3->getMarcRecordConDatos()->as_usmarc();
            }

            $params->{'barcode'}    = $cat_registro_marc_n3->getBarcode();
            #verifico las condiciones para actualizar los datos            
            $params->{'marc_record'}    = $marc_record->as_usmarc;
            $cat_registro_marc_n3->modificar($db, $params, $msg_object);  #si es mas de un ejemplar, a todos les setea la misma info
            
            ###Guardamos en registro de modificación###
            use C4::Modelo::RepRegistroModificacion;
            my ($registro_modificacion) = C4::Modelo::RepRegistroModificacion->new(db=>$db);
            my $data_hash;
            $data_hash->{'responsable'}= $params->{'responsable'}; #Usuario logueado
            $data_hash->{'nota'}    = '';
            $data_hash->{'tipo'}    = 'CATALOGO';
            $data_hash->{'operacion'} = 'MODIFICACION';
            $data_hash->{'id_rec'}    = $params->{'id3'};
            $data_hash->{'nivel_rec'} = '3';
            $data_hash->{'prev_rec'} = $old_marc_record;
            $data_hash->{'final_rec'} = $cat_registro_marc_n3->getMarcRecordConDatos()->as_usmarc();
            my $dateformat = C4::Date::get_date_format();
            my $hoy = C4::Date::format_date_in_iso(Date::Manip::ParseDate("today"),$dateformat);
            $data_hash->{'fecha'}    = $hoy;
            $registro_modificacion->agregar($data_hash);
            ###Guardamos en registro de modificación###

            if(!$msg_object->{'error'}){
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U382', 'params' => [$cat_registro_marc_n3->getBarcode]} ) ;
            }
        }#END for(my $i=0;$i<$cant;$i++)

        $db->commit;
        eval {
            C4::AR::Sphinx::generar_indice($cat_registro_marc_n3->getId1, 'R_PARTIAL', 'UPDATE');
            #ahora el indice se encuentra DESACTUALIZADO
            C4::AR::Preferencias::setVariable('indexado', 0, $db);
        };    
        if ($@){
            C4::AR::Debug::debug("ERROR AL REINDEXAR EN EL REGISTRO: ".$cat_registro_marc_n3->getId1()." !!! ( ".$@." )");
        }
    };

    if ($@){
        #Se loguea error de Base de Datos
        &C4::AR::Mensajes::printErrorDB($@, 'B432',"INTRA");
        $db->rollback;
        #Se setea error para el usuario
        $msg_object->{'error'} = 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U385', 'params' => []} ) ;
    }

    $db->{connect_options}->{AutoCommit} = 1;

    return ($msg_object);
}


=head2 sub getNivel3FromId2
Recupero todos los nivel 3 a partir de un id2
=cut
sub getNivel3FromId2{
    my ($id2, $db) = @_;

    $db = $db || C4::Modelo::CatRegistroMarcN3->new()->db();

    my $nivel3_array_ref = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(   
                                                                        db  => $db,
                                                                        query => [  
                                                                                    id2 => { eq => $id2 },
                                                                            ], 
                                                                        with_objects => ['nivel1', 'nivel2'],
                                        );
    my $nivel3_array_ref_count = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3_count(   
                                                                        db  => $db,
                                                                        query => [  
                                                                                    id2 => { eq => $id2 },
                                                                            ], 
                                        );
    return ($nivel3_array_ref);
}

=head2 sub getNivel3Completo
Recupero todos los nivel 3 
=cut
sub getNivel3Completo{
    my ($db) = @_;

    $db = $db || C4::Modelo::CatRegistroMarcN3->new()->db();


# FIXME  (no existe el campo created at en la tabla cat_registro_marc_n3 por eso se rompe)

    my $nivel3_array_ref = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(   
                                                                        db  => $db,
#                                                                         query => [  
#                                                                                     id2 => { eq => $id2 },
#                                                                             ], 
                                        );

    return $nivel3_array_ref;
}



=head2 sub t_eliminarNivel3
    Elimina los ejemplares de nivel 3 pasados por parametro
    @parametros:
        $params->{'id3_array'}: arreglo de ID3
=cut
sub t_eliminarNivel3{
    my ($params) = @_;

    my $barcode;

    my $msg_object = C4::AR::Mensajes::create();
    
    my $cat_registro_marc_n3 = C4::Modelo::CatRegistroMarcN3->new();
    my $db = $cat_registro_marc_n3->db;
    my $id1 = 0;
    # enable transactions, if possible
    $db->{connect_options}->{AutoCommit} = 0;
    $db->begin_work;
    my $id3_array = $params->{'id3_array'};

    eval {
        for(my $i=0;$i<scalar(@$id3_array);$i++){
            $params->{'id3'} = $id3_array->[$i];
            _verificarDeleteItem($msg_object, $params);
            
            if(!$msg_object->{'error'}){

                $cat_registro_marc_n3 = getNivel3FromId3($id3_array->[$i], $db);
                if ($cat_registro_marc_n3){
                    
                    my $old_marc_record = $cat_registro_marc_n3->getMarcRecordConDatos()->as_usmarc();

                    $id1 = $cat_registro_marc_n3->getId1();
                    my $barcode = $cat_registro_marc_n3->getBarcode;   
                    $cat_registro_marc_n3->eliminar();
                    #se eliminó con exito

                    ###Guardamos en registro de modificación###
                    use C4::Modelo::RepRegistroModificacion;
                    my ($registro_modificacion) = C4::Modelo::RepRegistroModificacion->new(db=>$db);
                    my $data_hash;
                    $data_hash->{'responsable'}= $params->{'responsable'}; #Usuario logueado
                    $data_hash->{'nota'}    = '';
                    $data_hash->{'tipo'}    = 'CATALOGO';
                    $data_hash->{'operacion'} = 'BAJA';
                    $data_hash->{'id_rec'}    = $id3_array->[$i];
                    $data_hash->{'nivel_rec'} = '3';
                    $data_hash->{'prev_rec'} = $old_marc_record;
                    $data_hash->{'final_rec'} = '';
                    my $dateformat = C4::Date::get_date_format();
                    my $hoy = C4::Date::format_date_in_iso(Date::Manip::ParseDate("today"),$dateformat);
                    $data_hash->{'fecha'}    = $hoy;
                    $registro_modificacion->agregar($data_hash);
                    ###Guardamos en registro de modificación###

                    $msg_object->{'error'} = 0;
                    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U376', 'params' => [$barcode]} ) ;
                }else{
                    #se esta intentando recuperar un ejemplar con un id3 inexistente
                    C4::AR::Debug::debug("Nivel3 => t_eliminarNivel3 => se esta intentando recuperar un ejemplar con ID3 inexistente ".$id3_array->[$i]);
                }
            }
        }

        $db->commit;

        if ($id1) {
            eval {
                C4::AR::Sphinx::generar_indice($id1, 'R_PARTIAL', 'UPDATE');
                #ahora el indice se encuentra DESACTUALIZADO
                C4::AR::Preferencias::setVariable('indexado', 0, $db);
            };    
            if ($@){
                C4::AR::Debug::debug("ERROR AL REINDEXAR EN EL REGISTRO: ".$cat_registro_marc_n3->getId1()." !!! ( ".$@." )");
            }
        }
    };

    if ($@){
        #Se loguea error de Base de Datos
        &C4::AR::Mensajes::printErrorDB($@, 'B435',"INTRA");
        $db->rollback;
        #Se setea error para el usuario
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U379', 'params' => [$barcode]} ) ;
    }

    $db->{connect_options}->{AutoCommit} = 1;

    return ($msg_object);
}


=head2 sub getNivel3FromId3
Recupero un nivel 3 a partir de un id3
retorna un objeto o 0 si no existe
=cut
sub getNivel3FromId3{
    my ($id3, $db) = @_;

    $db = $db || C4::Modelo::PermCatalogo->new()->db;
    my $nivel3_array_ref = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(   
                                                                    db => $db,
                                                                    query   => [ id => { eq => $id3} ], 
                                                                    require_objects => ['nivel1'],
#                                                                     select          => ['cat_registro_marc_n1.*']    
#                                                                     require_objects => ['ref_disponibilidad', 'ref_estado']
                                                                );
    C4::AR::Debug::debug(scalar(@$nivel3_array_ref));

    if( scalar(@$nivel3_array_ref) > 0){
        return ($nivel3_array_ref->[0]);
    }else{
        return 0;
    }
}

=item
    sub getNivel3FromBarcode

    Esta funcion recupera (si existe) nivel3 segun el barcode pasado por parametro, sin tener en cuenta los ejemplares COMPARTIDOS
    Se utiliza para prestar o para verificar que no exista el barcode ingresado
=cut

sub getNivel3FromBarcode {
    my ($barcode, $all) = @_;
    
    my @filtros;
    
    push(@filtros, ( codigo_barra => { eq => $barcode }) );

    my $nivel3 = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3( query => \@filtros ); 

    foreach my $n3 (@$nivel3){
        if ((!$n3->estadoCompartido) || ($all)) { #Sin compartidos a menos que se indique lo contrario
          return $n3;
        }
    }
    return (0);
}

sub getBarcodesLike {
    my ($barcode) = @_;
    my  $barcodes_array_ref;
    my @filtros;
    
    my $limit = C4::AR::Preferencias::getValorPreferencia('limite_resultados_autocompletables') || 20;
     
    push(@filtros, ( codigo_barra => { like => '%'.$barcode.'%' }) );
    
    $barcodes_array_ref = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3( 
                                                        query => \@filtros, 
                                                        select => ['*'], 
                                                        non_lazy => 1, 
                                                        limit => $limit, 
                                                        offset => 0, ); 
    my $cant= scalar(@$barcodes_array_ref);

    if($cant > 0){
        return ($cant, $barcodes_array_ref);
    }else{
        return ($cant, 0);
    }
}

=head2
busca un barcode segun barcode, sobre el conjunto de barcodes prestados
=cut
sub getBarcodesPrestadoLike {
    my ($barcode) = @_;

    my  $barcodes_array_ref;
    my @filtros;
 
    push(@filtros, ( codigo_barra => { like => '%'.$barcode.'%' } ) ); #Con este barcode, FIXME: si agregan el barcode en otro lugar?? 
    push(@filtros, ( fecha_devolucion => { eq => undef }) );
    
    $barcodes_array_ref = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo(   query => \@filtros, 
                                                                                  require_objects => [ 'nivel3','tipo' ], #INNER JOIN
                                                                                  select => ['*'],
                                        ); 
    my $cant= scalar(@$barcodes_array_ref);

    if($cant > 0){
        return ($cant, $barcodes_array_ref);
    }else{
        return ($cant, 0);
    }
}

=head2
    detalleNivel3
    Trae todos los datos del nivel 3, para poder verlos en el template.
    @params 
    $id2, id de nivel2
=cut
sub detalleNivel3{
    my ($id2,$db) = @_;

    C4::AR::Debug::debug("Nivel3 => detalleNivel3 => id2 => ".$id2);

    my %hash_nivel2;    
    #recupero el nivel1 segun el id1 pasado por parametro
    if (!$db){
        my $n3_temp = C4::Modelo::CatRegistroMarcN3->new();
        $db      = $n3_temp->db;
    }

    my $nivel2_object = undef;    
    my $nivel2_object = C4::AR::Nivel2::getNivel2FromId2($id2,$db);

    if($nivel2_object){

        $hash_nivel2{'id2'}                     = $id2;
        
        eval{
            $hash_nivel2{'tipo_documento'}          = $nivel2_object->getTipoDocumentoObject->getNombre();
        };
        if (@$){
            $hash_nivel2{'tipo_documento'}          = C4::AR::Filtros::i18n("SIN DEFINIR");
        }
        
        $hash_nivel2{'nivel2_array'}            = $nivel2_object->toMARC_Intra; #arreglo de los campos fijos de Nivel 2 mapeado a MARC

        $hash_nivel2{'nivel2_template'}         = $nivel2_object->getTemplate();
        $hash_nivel2{'tiene_indice'}            = $nivel2_object->tiene_indice || $nivel2_object->tieneArchivoIndice;
        $hash_nivel2{'hay_indice_file'}         = $nivel2_object->tieneArchivoIndice;
        $hash_nivel2{'indice'}                  = $hash_nivel2{'tiene_indice'}?$nivel2_object->getIndice:"";
        $hash_nivel2{'esta_en_estante_virtual'} = C4::AR::Estantes::estaEnEstanteVirtual($id2);
        my ($totales_nivel3, @result)           = detalleDisponibilidadNivel3($id2,$nivel2_object->db);
        $hash_nivel2{'nivel3'}                  = \@result;
        $hash_nivel2{'cant_ejemplares'}         = $totales_nivel3->{'cant_ejemplares'};
        $hash_nivel2{'cant_nivel3'}             = scalar(@result);
        $hash_nivel2{'cantPrestados'}           = $totales_nivel3->{'cantPrestados'};
        $hash_nivel2{'cantReservas'}            = $totales_nivel3->{'cantReservas'};
        $hash_nivel2{'cantReservasEnEspera'}    = $totales_nivel3->{'cantReservasEnEspera'};
        $hash_nivel2{'cantReservasAsignadas'}   = $totales_nivel3->{'cantReservasAsignadas'};
        $hash_nivel2{'disponibles'}             = $totales_nivel3->{'disponibles'};
        $hash_nivel2{'cantParaSala'}            = $totales_nivel3->{'cantParaSala'};
        $hash_nivel2{'cantParaPrestamo'}        = $totales_nivel3->{'cantParaPrestamo'};
        $hash_nivel2{'cantParaSalaActual'}      = $totales_nivel3->{'cantParaSalaActual'};
        $hash_nivel2{'cantParaPrestamoActual'}  = $totales_nivel3->{'cantParaPrestamoActual'};
        
        my ($cant_docs,$e_docs)                 = getListaDeDocs($id2);  
    
        $hash_nivel2{'lista_docs'}              = $e_docs;
        $hash_nivel2{'cant_docs'}               = $cant_docs;
        $hash_nivel2{'enable_nivel3'}           = $nivel2_object->getTipoDocumentoObject->enableNivel3();

        #otengo las analiticas
        my $cat_reg_marc_n2_analiticas          = $nivel2_object->getAnaliticas();
        my $tiene_analiticas                    = scalar(@$cat_reg_marc_n2_analiticas);
        $hash_nivel2{'tiene_analiticas'}        = $tiene_analiticas;
        $hash_nivel2{'show_action'}             = 1; #muestra la accion agregar analitica
        $hash_nivel2{'show_analiticas'}         = $tiene_analiticas; #muestra la accion "Ver analíticas" si el grupo tiene analíticas
        $hash_nivel2{'cant_analiticas'}         = $tiene_analiticas;
        $hash_nivel2{'cat_ref_tipo_nivel3'}     = $nivel2_object->getTipoDocumentoObject()->getId_tipo_doc();

        if ( ($nivel2_object->getTemplate() eq "ANA") && ($hash_nivel2{'cat_ref_tipo_nivel3'}  eq "ANA") ){
            #recupero las analiticas por el id1    
            my $cat_reg_analiticas_array_ref    = C4::AR::Nivel2::getAllAnaliticasById1($nivel2_object->getId1());

            if( ($cat_reg_analiticas_array_ref) && (scalar(@$cat_reg_analiticas_array_ref) > 0) ){
                my $n2 = C4::AR::Nivel2::getNivel2FromId2($cat_reg_analiticas_array_ref->[0]->getId2Padre());

                if($n2){
                    $hash_nivel2{'nivel1_padre'}                = $n2->getId1();
                    $hash_nivel2{'nivel2_padre'}                = $n2->getId2();
                    $hash_nivel2{'tipo_documento_padre'}        = $n2->getTipoDocumentoObject->getNombre;
                    $hash_nivel2{'titulo_registro_padre'}       = $n2->nivel1->getTituloStringEscaped();
                    $hash_nivel2{'autor_registro_padre'}        = $n2->nivel1->getAutorStringEscaped();
                    $hash_nivel2{'detalle_grupo_registro_padre'}= $n2->getDetalleGrupo();
                    $hash_nivel2{'primer_signatura'}            = $n2->getSignaturas->[0];
                }
            }

            $hash_nivel2{'show_action'}             = 0;
        }
    }

    return (\%hash_nivel2);
}


# TODO Miguel estoy probando sería SOLO para la migracion
sub migrarAnaliticas{

    my $nivel2_array_ref = C4::AR::Nivel2::getAllNivel2();

    foreach my $nivel2_object (@$nivel2_array_ref){

        my $cat_reg_marc_n2_analitica_id = $nivel2_object->getAnalitica();
  
        if($cat_reg_marc_n2_analitica_id ne ""){

#             C4::AR::Debug::debug("ANALITICA? ============= ".$cat_reg_marc_n2_analitica_id);


            my $cat_registro_n2_analitica = C4::Modelo::CatRegistroMarcN2Analitica->new();
            $cat_registro_n2_analitica->setId2Padre($cat_reg_marc_n2_analitica_id);
            $cat_registro_n2_analitica->setId2Hijo($nivel2_object->getId2());

#             $cat_registro_n2_analitica->save();
        }
    }
}

=head2
sub getListaDeDocs
Trae todos los objectos EDocument para un nivel 2 dado
@params
$id2, id de CatRegistroMarcN2
=cut

sub getListaDeDocs{
    my ($id2) = @_;
    my @filtros;
    
    use C4::Modelo::EDocument::Manager;
    
    push(@filtros, ( id2 => { eq => $id2 }) );
    
    my $e_docs = C4::Modelo::EDocument::Manager->get_e_document(query => \@filtros,);
    
    return (scalar(@$e_docs), $e_docs);
    
    
}

=head2 sub detalleCompletoINTRA
    Genera el detalle 
=cut
sub detalleCompletoINTRA {
    my ($id1, $t_params) = @_;
    
    #recupero el nivel1 segun el id1 pasado por parametro
    my $nivel1              = C4::AR::Nivel1::getNivel1FromId1($id1);
    my $page_number         = $t_params->{'page'} || 0;
    my $cant_grupos         = C4::Context->config("cant_grupos_per_query") || 5;
    #recupero todos los nivel2 segun el id1 pasado por parametro

    # para traer las portadas locales
    use C4::AR::PortadaNivel2;

    my $id2 =  $t_params->{'id2'} || 0;
    my $nivel2_array_ref;

    if ($id2){
       ($nivel2_array_ref) = C4::AR::Nivel2::getNivel2FromId2_asArray($id2);
    }else{
       ($nivel2_array_ref) = C4::AR::Nivel2::getNivel2FromId1($nivel1->getId1,$nivel1->db);
    }

    my @nivel2;

#    FIXME: esto es cuando pagina con el plugin, que no esta andando
#    my $cantidad_total = scalar(@$nivel2_array_ref);
#    my $inicio = (($page_number) * $cant_grupos);
#    my $cantidad = $inicio + $cant_grupos;  
    
    my $cantidad_total = scalar(@$nivel2_array_ref);
    my $inicio = 0;
    my $cantidad = $cantidad_total;  
    
    if($cantidad_total != 0){
        for(my $i=$inicio;$i<$cantidad;$i++){

            my $new_id2 = 0;
            eval {
                $new_id2 = $nivel2_array_ref->[$i]->getId2;
            };
   C4::AR::Debug::debug("\n detalleNivel3 \n");


        #eval{
            my ($hash_nivel2) = detalleNivel3($new_id2,$nivel1->db);

            #Para ver la portada en el detalle
            $hash_nivel2->{'portada_registro'}          = C4::AR::PortadasRegistros::getImageForId2($hash_nivel2->{'id2'},'S');
            $hash_nivel2->{'portada_registro_medium'}   = C4::AR::PortadasRegistros::getImageForId2($hash_nivel2->{'id2'},'M');
            $hash_nivel2->{'portada_registro_big'}      = C4::AR::PortadasRegistros::getImageForId2($hash_nivel2->{'id2'},'L');
            $hash_nivel2->{'portada_edicion_local'}     = C4::AR::PortadaNivel2::getPortadasEdicion($hash_nivel2->{'id2'});
            $hash_nivel2->{'edicion'}                   = $nivel2_array_ref->[$i]->getEdicion();
            $hash_nivel2->{'nivel2_object'}              = $nivel2_array_ref->[$i];
            #para los nav-tabs
            
            #Para el google book preview
            $hash_nivel2->{'isbn'}        		        = C4::AR::Utilidades::trim($nivel2_array_ref->[$i]->getISBN);
            if(($nivel2_array_ref->[$i]->getISSN)&&(!$t_params->{'issn'})){
            #Se supone que no cambian dentro de la misma publicación seriada, se toma solo el primero
                $t_params->{'issn'}        				= C4::AR::Utilidades::trim($nivel2_array_ref->[$i]->getISSN);
            }
                
            push(@nivel2, $hash_nivel2);
        #};
            
            if ($i >= ($cantidad_total-1)){
                last;
            }
        
        }
    }
    
    #Es una Revista? Armo el estado de colección
    if($nivel1->getTemplate() eq "REV"){
        my ($cant_revistas ,$estadoDeColeccion) = C4::AR::Busquedas::obtenerEstadoDeColeccion($id1, $nivel1->getTemplate(), "INTRA");
        if($cant_revistas > 0){
            $t_params->{'estadoDeColeccion'}  = $estadoDeColeccion;
        }
    }

    $t_params->{'nivel1'}                           = $nivel1->toMARC_Intra;
    $t_params->{'nivel1_template'}                  = $nivel1->getTemplate();
    $t_params->{'show_asociar_registro_fuente'}     = ($nivel1->getTemplate() eq "ANA")?1:0;
    $t_params->{'show_desasociar_registro_fuente'}  = $nivel1->tengoRegistroFuente();
    $t_params->{'tipo_documento'}                   = $nivel1->getNombreTipoDoc();
    $t_params->{'id1'}                              = $id1;
    $t_params->{'indexado'}                         = $nivel1->estaEnIndice;
    $t_params->{'titulo'}                           = C4::AR::Utilidades::escapeData($nivel1->getTitulo());    
    $t_params->{'autor'}                            = C4::AR::Utilidades::escapeData($nivel1->getAutor());
    $t_params->{'cantItemN1'}                       = C4::AR::Nivel3::cantNiveles3FromId1($id1,$nivel1->db);
    $t_params->{'nivel2'}                           = \@nivel2;
    #se ferifica si la preferencia "circularDesdeDetalleDelRegistro" esta seteada
    $t_params->{'circularDesdeDetalleDelRegistro'}  = C4::AR::Preferencias::getValorPreferencia('circularDesdeDetalleDelRegistro');

    return ($cantidad_total);
}

=head2 sub detalleDisponibilidadNivel3
    detalleDisponibilidadNivel3
    Busca los datos del nivel 3 a partir de un id2 correspondiente a nivel 2.
=cut
sub detalleDisponibilidadNivel3{
    my ($id2,$db) = @_;
    
    $db = $db || C4::Modelo::CatRegistroMarcN3->new->db;
    
    #recupero todos los nivel3 segun el id2 pasado por parametro
    my ($nivel3_array_ref) = C4::AR::Nivel3::getNivel3FromId2($id2,$db);
    
    my @result;
    my %hash_nivel2;
    my $i                                       = 0;
    my $cantDisponibles                         = 0;
    my %infoNivel3;
    my $esParaSala;
    $infoNivel3{'cantParaSala'}                 = 0;
    $infoNivel3{'cantParaPrestamo'}             = 0;
    $infoNivel3{'cantParaSalaActual'}           = 0;
    $infoNivel3{'cantParaPrestamoActual'}       = 0;
    $infoNivel3{'disponibles'}                  = 0;
    $infoNivel3{'cantPrestados'}                = C4::AR::Nivel2::getCantPrestados($id2,$db);
    $infoNivel3{'cantReservas'}                 = C4::AR::Reservas::cantReservasPorGrupo($id2,$db);
    $infoNivel3{'cantReservasEnEspera'}         = C4::AR::Reservas::cantReservasPorGrupoEnEspera($id2,$db);
    $infoNivel3{'cantReservasAsignadas'}        = C4::AR::Reservas::cantReservasPorGrupoAsignadas($id2,$db);
    $infoNivel3{'cant_ejemplares'}              = scalar(@$nivel3_array_ref);

    for(my $i=0;$i<scalar(@$nivel3_array_ref);$i++){
        my %hash_nivel3;

        # FIXME si no se setea undef, muestra al usuario de un grupo tantas veces como ejemplares tenga, si este tiene un prestamo sobre 
        # un ejemplar del grupo.
        # con el debug no veo el nro_socio luego de my $socio, o sea lo que se esta mamando es el template, va haber q inicializar los flags
        # que van hacia el template.
        $hash_nivel3{'nivel3_array'}        = ($nivel3_array_ref->[$i])->toMARC_Opac; #arreglo de los campos fijos de Nivel 3 mapeado a MARC
        $hash_nivel3{'nro_socio'}           = undef;
        $hash_nivel3{'nivel3_obj'}          = $nivel3_array_ref->[$i]; 
        $hash_nivel3{'id3'}                 = $nivel3_array_ref->[$i]->getId3;
        $hash_nivel3{'estaPrestado'}        = $nivel3_array_ref->[$i]->estaPrestado;
        $hash_nivel3{'estaReservado'}       = $nivel3_array_ref->[$i]->estaReservado;
        $hash_nivel3{'id_ui_poseedora'}     = $nivel3_array_ref->[$i]->getId_ui_poseedora();
        $hash_nivel3{'id_ui_origen'}        = $nivel3_array_ref->[$i]->getId_ui_origen();
        $esParaSala                         = $nivel3_array_ref->[$i]->esParaSala();

        my $UI_poseedora_object             = C4::Modelo::PrefUnidadInformacion->getByPk($hash_nivel3{'id_ui_poseedora'});#C4::AR::Referencias::getUI_infoObject($hash_nivel3{'id_ui_poseedora'});

        if($UI_poseedora_object){
            $hash_nivel3{'UI_poseedora'}    = $UI_poseedora_object->getNombre();
        }

        my $UI_origen_object                = C4::Modelo::PrefUnidadInformacion->getByPk($hash_nivel3{'id_ui_origen'});#C4::AR::Referencias::getUI_infoObject($hash_nivel3{'id_ui_origen'});

        if($UI_origen_object){
            $hash_nivel3{'UI_origen'}       = $UI_origen_object->getNombre();
        }

        #ESTADO
        $hash_nivel3{'estado'} = $nivel3_array_ref->[$i]->getEstado;
        if($nivel3_array_ref->[$i]->estadoDisponible) {
            #ESTADO DISPONIBLE
            $hash_nivel3{'claseEstado'} = "disponible";
            $cantDisponibles++;
            $hash_nivel3{'disponible'} = 1; # lo marco como disponible
    
                if(!$esParaSala){
                    #esta DISPONIBLE y es PARA PRESTAMO
                    $infoNivel3{'cantParaPrestamo'}++;

            unless($hash_nivel3{'estaPrestado'}||$hash_nivel3{'estaReservado'}){
                $infoNivel3{'cantParaPrestamoActual'}++;
            }
                }elsif($esParaSala){
                    #es PARA SALA
                    $infoNivel3{'cantParaSala'}++;

            unless($hash_nivel3{'estaPrestado'}||$hash_nivel3{'estaReservado'}){
            $infoNivel3{'cantParaSalaActual'}++;
            }
                }

        } else {
            #ESTADO NO DISPONIBLE
            $hash_nivel3{'claseEstado'}         = "nodisponible";
            $hash_nivel3{'disponible'} = 0; # lo marco como no disponible
        }
    
        #DISPONIBILIDAD
        if(!$esParaSala){
            #PARA PRESTAMO
            $hash_nivel3{'disponibilidad'}      = "Prestamo";
            $hash_nivel3{'claseDisponibilidad'} = "prestamo";
        }elsif($esParaSala){
            #es PARA SALA
            $hash_nivel3{'disponibilidad'}      = "Sala de Lectura";
            $hash_nivel3{'claseDisponibilidad'} = "salaLectura";
        }
        
#          C4::AR::Debug::debug("nro_socio: ".$hash_nivel3{'nro_socio'}." id3=".$hash_nivel3{'id3'});
        my $socio = C4::AR::Prestamos::getSocioFromPrestamo($hash_nivel3{'id3'});

        #se inicializa la hash
        $hash_nivel3{'vencimiento'}         = undef;
        $hash_nivel3{'socio_prestamo'}      = undef;
        $hash_nivel3{'prestamo'}            = undef;
        $hash_nivel3{'claseFecha'}          = undef;
    

        if ($socio) { 
            my $prestamo                    = C4::AR::Prestamos::getPrestamoActivo($hash_nivel3{'id3'});
            
            if($prestamo){
                $hash_nivel3{'prestamo'}        = $prestamo;
                $hash_nivel3{'socio_prestamo'}  = $socio;

                if ($prestamo->estaVencido) {
                    $hash_nivel3{'claseFecha'}  = "fecha_vencida";
                }else {
                    $hash_nivel3{'claseFecha'}  = "fecha_cumple";
                }
            }
        
        }
        
#        RESERVAS:
        $hash_nivel3{'socio_reserva'}       = undef;
        $hash_nivel3{'reserva'}             = undef;
        
        my $socio_reserva_object = C4::AR::Reservas::getSocioFromReserva($hash_nivel3{'id3'});
        
        if($socio_reserva_object){
            my $reserva                     = C4::AR::Reservas::getReservaActiva($hash_nivel3{'id3'});
        
            if($reserva){
                $hash_nivel3{'reserva'}        = $reserva;
                $hash_nivel3{'socio_reserva'}  = $socio_reserva_object;
            }
        
        }

        $result[$i]= \%hash_nivel3;
    }
    $infoNivel3{'disponibles'} = $infoNivel3{'cantParaPrestamo'} + $infoNivel3{'cantParaSala'};
    
    return(\%infoNivel3,@result);
}

=head2
Genera el detalle 
=cut
sub detalleCompletoOPAC{
    my ($id1, $t_params) = @_;
    #recupero el nivel1 segun el id1 pasado por parametro
    my $nivel1= C4::AR::Nivel1::getNivel1FromId1OPAC($id1);
    #recupero todos los nivel2 segun el id1 pasado por parametro

# YA NO SE USA MAS LA PAGINACION ON-DEMAND POR LOS ANCLAS
#    my $page_number = $t_params->{'page'} || 0;
#    my $cant_grupos = C4::Context->config("cant_grupos_per_query") || 5;

    # para traer las portadas locales
    use C4::AR::PortadaNivel2;

    my $id2 =  $t_params->{'id2'} || 0;
    my $nivel2_array_ref;
    
    if ($id2){
       ($nivel2_array_ref) = C4::AR::Nivel2::getNivel2FromId2_asArray($id2);
    }else{
       ($nivel2_array_ref) = C4::AR::Nivel2::getNivel2FromId1($nivel1->getId1,$nivel1->db);
    }

    my @nivel2;

    my $cantidad_total = scalar(@$nivel2_array_ref);
    my $inicio = 0;
    my $cantidad = $cantidad_total;  
    
    
    for(my $i=$inicio;$i<$cantidad;$i++){
       # eval{
            my $hash_nivel2;
            $nivel2_array_ref->[$i]->load();
            $hash_nivel2->{'id2'}                       = $nivel2_array_ref->[$i]->getId2;
            $hash_nivel2->{'edicion'}                   = $nivel2_array_ref->[$i]->getEdicion;
            $hash_nivel2->{'tipo_documento'}            = $nivel2_array_ref->[$i]->getTipoDocumentoObject()->getNombre();
            $hash_nivel2->{'disponible'}                = $nivel2_array_ref->[$i]->getTipoDocumentoObject()->getDisponible();
            $hash_nivel2->{'isbn'}        		        = C4::AR::Utilidades::trim($nivel2_array_ref->[$i]->getISBN);

            if(($nivel2_array_ref->[$i]->getISSN)&&(!$t_params->{'issn'})){
			#Se supone que no cambian dentro de la misma publicación seriada, se toma solo el primero
				$t_params->{'issn'}        				= C4::AR::Utilidades::trim($nivel2_array_ref->[$i]->getISSN);
			}
            $hash_nivel2->{'tiene_indice'}              = $nivel2_array_ref->[$i]->tiene_indice || $nivel2_array_ref->[$i]->tieneArchivoIndice;
            $hash_nivel2->{'esta_en_estante_virtual'}   = C4::AR::Estantes::estaEnEstanteVirtual($hash_nivel2->{'id2'});
            $hash_nivel2->{'indice'}                    = $hash_nivel2->{'tiene_indice'}?$nivel2_array_ref->[$i]->getIndice:"";
            $hash_nivel2->{'hay_indice_file'}           = $nivel2_array_ref->[$i]->tieneArchivoIndice;

            $hash_nivel2->{'nivel2_array'}              = ($nivel2_array_ref->[$i])->toMARC_Opac; #arreglo de los campos fijos de Nivel 2 mapeado a MARC
            my ($totales_nivel3,@result)                = detalleDisponibilidadNivel3($hash_nivel2->{'id2'},$nivel1->db);
            $hash_nivel2->{'nivel3'}                    = \@result;
            $hash_nivel2->{'cant_nivel3'}               = scalar(@result);
            $hash_nivel2->{'cantPrestados'}             = $totales_nivel3->{'cantPrestados'};
            $hash_nivel2->{'cantReservas'}              = $totales_nivel3->{'cantReservas'};
            $hash_nivel2->{'portada_registro'}          = C4::AR::PortadasRegistros::getImageForId2($hash_nivel2->{'id2'},'S');
            $hash_nivel2->{'portada_registro_medium'}   = C4::AR::PortadasRegistros::getImageForId2($hash_nivel2->{'id2'},'M');
            $hash_nivel2->{'primer_signatura'}          = $nivel2_array_ref->[$i]->getSignaturas->[0];
            $hash_nivel2->{'portada_registro_big'}      = C4::AR::PortadasRegistros::getImageForId2($hash_nivel2->{'id2'},'L');
            $hash_nivel2->{'portada_edicion_local'}     = C4::AR::PortadaNivel2::getPortadasEdicion($hash_nivel2->{'id2'});
            $hash_nivel2->{'cantReservasEnEspera'}      = $totales_nivel3->{'cantReservasEnEspera'};
            $hash_nivel2->{'disponibles'}               = $totales_nivel3->{'disponibles'};
            $hash_nivel2->{'cantParaSala'}              = $totales_nivel3->{'cantParaSala'};
            $hash_nivel2->{'cant_ejemplares'}           = $totales_nivel3->{'cant_ejemplares'};
            
            $hash_nivel2->{'cantParaPrestamo'}          = $totales_nivel3->{'cantParaPrestamo'};
            $hash_nivel2->{'cantParaSalaActual'}        = $totales_nivel3->{'cantParaSalaActual'};
            $hash_nivel2->{'cantParaPrestamoActual'}    = $totales_nivel3->{'cantParaPrestamoActual'};
            $hash_nivel2->{'DivMARC'}                   = "MARCDetail".$i;
            $hash_nivel2->{'DivDetalle'}                = "Detalle".$i;
            $hash_nivel2->{'cat_ref_tipo_nivel3'}       = $nivel2_array_ref->[$i]->getTipoDocumentoObject()->getId_tipo_doc();
            $hash_nivel2->{'cat_ref_tipo_nivel3_name'}  = C4::AR::Referencias::translateTipoNivel3($hash_nivel2->{'cat_ref_tipo_nivel3'});
            $hash_nivel2->{'rating'}                    = C4::AR::Nivel2::getRating($hash_nivel2->{'id2'},$nivel1->db);
            $hash_nivel2->{'cant_reviews'}              = C4::AR::Nivel2::getCantReviews($hash_nivel2->{'id2'}, $nivel1->db);
            $hash_nivel2->{'nivel1_obj'}                = $nivel1;
            $hash_nivel2->{'nivel2_obj'}                = $nivel2_array_ref;

            my ($cant_docs,$e_docs)                     = getListaDeDocs($hash_nivel2->{'id2'});  
            
            $hash_nivel2->{'lista_docs'}                = $e_docs;
            $hash_nivel2->{'cant_docs'}                 = $cant_docs;

            #cosas si es revista
            $hash_nivel2->{'anio_revista'}              = $nivel2_array_ref->[$i]->getAnioRevista ? $nivel2_array_ref->[$i]->getAnioRevista : '#';
            $hash_nivel2->{'volumen_revista'}           = $nivel2_array_ref->[$i]->getVolumenRevista ? $nivel2_array_ref->[$i]->getVolumenRevista : '#';
            $hash_nivel2->{'numero_revista'}            = $nivel2_array_ref->[$i]->getNumeroRevista ? $nivel2_array_ref->[$i]->getNumeroRevista : '#';
           
            #otengo las analiticas
            my $cat_reg_marc_n2_analiticas              = $hash_nivel2->{'nivel2_obj'}->[0]->getAnaliticas;

            my $tiene_analiticas                        = scalar(@$cat_reg_marc_n2_analiticas);
            $hash_nivel2->{'tiene_analiticas'}          = $tiene_analiticas;
            $hash_nivel2->{'show_action'}               = 1; #muestra la accion agregar analitica
            $hash_nivel2->{'show_analiticas'}           = $tiene_analiticas; #muestra la accion "Ver analíticas" si el grupo tiene analíticas
            $hash_nivel2->{'cant_analiticas'}           = $tiene_analiticas;

            if ( ($nivel2_array_ref->[$i]->getTemplate() eq "ANA") && ($hash_nivel2->{'cat_ref_tipo_nivel3'}  eq "ANA") ){

                #recupero las analiticas por el id1    
                my $cat_reg_analiticas_array_ref    = C4::AR::Nivel2::getAllAnaliticasById1($nivel2_array_ref->[0]->getId1());

                if( ($cat_reg_analiticas_array_ref) && (scalar(@$cat_reg_analiticas_array_ref) > 0) ){
                    my $n2 = C4::AR::Nivel2::getNivel2FromId2($cat_reg_analiticas_array_ref->[0]->getId2Padre());

                    if($n2){
                        $hash_nivel2->{'nivel1_padre'}                = $n2->getId1();
                        $hash_nivel2->{'nivel2_padre'}                = $n2->getId2();
                        $hash_nivel2->{'tipo_documento_padre'}        = $n2->getTipoDocumentoObject->getNombre;
                        $hash_nivel2->{'titulo_registro_padre'}       = $n2->nivel1->getTituloStringEscaped();
                        $hash_nivel2->{'autor_registro_padre'}        = $n2->nivel1->getAutorStringEscaped();
                        $hash_nivel2->{'detalle_grupo_registro_padre'}= $n2->getDetalleGrupo();                        
                        $hash_nivel2->{'primer_signatura'}            = $n2->getSignaturas->[0];
                    }
                }
            }

            push(@nivel2, $hash_nivel2);
       # };
    }

    #Es una Revista? Armo el estado de colección
    if($nivel1->getTemplate() eq "REV"){
        my ($cant_revistas ,$estadoDeColeccion) = C4::AR::Busquedas::obtenerEstadoDeColeccion($id1, $nivel1->getTemplate(), "INTRA");
        if($cant_revistas > 0){
            $t_params->{'estadoDeColeccion'}  = $estadoDeColeccion;
        }else{
        	$t_params->{'estadoDeColeccion'}  = 0;
        }
        
    }
    
    $t_params->{'nivel1'}     = $nivel1->toMARC_Opac;
    $t_params->{'nivel1_obj'} = $nivel1;
    $t_params->{'id1'}        = $id1;
    $t_params->{'nivel2'}     = \@nivel2;

    # C4::AR::Utilidades::printHASH(@nivel2[0]);
    return ($cantidad_total);
}


=head2
generaCodigoBarra
Funcion interna al pm
Genera el codigo de barras del item automanticamente por medio de una consulta a la base de datos, esta funcion es llamada desde una transaccion.
Los parametros son el manejador de la base de datos y los parametros que necesita para generar el codigo de barra.
=cut

sub generaCodigoBarra{
    my($parametros, $cant) = @_;

   my $barcode;
   my $tipo_ejemplar = $parametros->{'id_tipo_doc'} || $parametros->{'tipo_ejemplar'}; 
   
   C4::AR::Debug::debug("\n\n\n GENERANDO BARCODE PARA TIPO DE EJEMPLAR: ".$tipo_ejemplar."  ".$parametros->{'id_tipo_doc'}."\n\n\n");
   
   my ($format,$new_long) = C4::AR::Catalogacion::getBarcodeFormat($tipo_ejemplar);
   my @estructurabarcode = split(',',$format);
    
    my $like = '';

    for (my $i=0; $i<@estructurabarcode; $i++) {
        if (($i % 2) == 0) {
            my $pattern_string = $parametros->{$estructurabarcode[$i]};
            if ($pattern_string){
                $like.= $pattern_string;
            }else{
                $like.= $estructurabarcode[$i];
            }
        } else {
            $like.= $estructurabarcode[$i];
        }
    }

    # Puede venir el db tambien!!
    my $max_codigo = C4::Modelo::CatRegistroMarcN3::Manager->get_maximum_codigo_barra(like => $like.'%') || 0;
       C4::AR::Debug::debug("Nivel3 => generaCodigoBarra => barcode máximo => ".$max_codigo);

    my @barcodes_array_ref;
    for(my $i=1;$i<=$cant;$i++){
    C4::AR::Debug::debug("Nivel3 => generaCodigoBarra => completarConCeros => ".completarConCeros($max_codigo + $i,$tipo_ejemplar));
        $barcode  = $like.completarConCeros($max_codigo + $i,$tipo_ejemplar);
        C4::AR::Debug::debug("Nivel3 => generaCodigoBarra => barcode => ".$barcode);
        push(@barcodes_array_ref, $barcode);
    }
    return (@barcodes_array_ref);
}

sub completarConCeros {
    my ($numero,$tipo_ejemplar) = @_;

    my $ceros = '';
    
    my ($format,$long) = C4::AR::Catalogacion::getBarcodeFormat($tipo_ejemplar,"NO");
    
    my $longitud = $long;
    
    for(my $j=0;(($j + length($numero)) < $longitud) ;$j++){
        $ceros.= "0";
    }

    return $ceros.$numero;
}

=head2 sub getNivel3FromId1
    Recupero un nivel 3 a partir de un id1
    retorna un objeto o 0 si no existe
=cut
sub getNivel3FromId1{
    my ($id1, $db) = @_;

    $db = $db || C4::Modelo::PermCatalogo->new()->db;
    my $nivel3_array_ref = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(   
                                                                    db => $db,
                                                                    query   => [ id1 => { eq => $id1} ], 
                                                                );


    return $nivel3_array_ref;
}

=head2 sub cantNiveles3FromId1
    Recupero la cantidad de ejemplares a partir de un id1
=cut
sub cantNiveles3FromId1{
    my ($id1, $db) = @_;

    $db = $db || C4::Modelo::PermCatalogo->new()->db;

    my $cantnivel3_count = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3_count(   
                                                                    db => $db,
                                                                    query   => [ id1 => { eq => $id1} ], 
                                                                );


    return $cantnivel3_count;
}

=head2 sub buscarNiveles3PorDisponibilidad
Busca los datos del nivel 3 a partir de un id3, respetando su disponibilidad
=cut
sub buscarNivel3PorDisponibilidad{
    my ($nivel3aPrestar) = @_;
    
    my ($nivel3_array_ref) = getNivel3FromId2($nivel3aPrestar->getId2);
    my @items;
    my $j=0;
    foreach my $n3 (@$nivel3_array_ref){
        my $item;

        if((!$n3->estaPrestado)&&($n3->estadoDisponible)&&($nivel3aPrestar->getIdDisponibilidad eq $n3->getIdDisponibilidad)){
        #Si no esta prestado, esta en estado disponmible y tiene la misma disponibilidad que el novel 3 que intento prestar se agrega al combo
                $item->{'label'} = $n3->getBarcode;
                $item->{'value'} = $n3->getId3;
                push (@items,$item);
            }
    }

    return(\@items);
}

sub _verificarDeleteItem {
    my($msg_object, $params)=@_;

    $msg_object->{'error'} = 0;#no hay error

    if( !($msg_object->{'error'}) && C4::AR::Reservas::estaReservado($params->{'id3'}) ){
        #verifico que el ejemplar que quiero eliminar no esté prestado
        $msg_object->{'error'} = 1;
        C4::AR::Debug::debug("_verificarDeleteItem => Se está intentando eliminar un ejemplar que tiene una reserva");
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P122', 'params' => [$params->{'id3'}]} ) ;

    }elsif( !($msg_object->{'error'}) && C4::AR::Prestamos::estaPrestado($params->{'id3'}) ){
        #verifico que el ejemplar no se encuentre reservado
        $msg_object->{'error'} = 1;
        C4::AR::Debug::debug("_verificarDeleteItem => Se está intentando eliminar un ejemplar que tiene un prestamo");
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P121', 'params' => [$params->{'id3'}]} ) ;
    }

}


=item sub getAllNivel3FromId2

  retorna todos los ejemplares de un nivel 2
=cut
sub getAllNivel3FromId2 {
    my ($id2) = @_;
    
    my @filtros;

    push(@filtros, ( id2 => { eq => $id2 }) );
    
    my $nivel3_array_ref = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3( query => \@filtros ); 


    if(scalar(@$nivel3_array_ref) > 0){
        return ($nivel3_array_ref);
    }else{
        return (0);
    }
}



=head2 sub existeBarcode
Verifica si existe el barcode en la base
=cut
sub existeBarcode {
    my($barcode) = @_;

    my $nivel_array_ref = C4::AR::Nivel3::getNivel3FromBarcode($barcode);
    
#     C4::AR::Debug::debug("Nivel3 => existeBarcode => ".$nivel_array_ref);

    if ($nivel_array_ref == 0){
        return $nivel_array_ref;
    } else {
        return 1;
    }
#   return ( $nivel_array_ref != 0);
}

#=======================================================================ABM Nivel 3======================================================


=head2
Lo que hace la funcion es verificar cada barcode y devolver un arreglo de barcodes permitidos para agregar junto con sus
respectivos mensajes, ya sea que se AGREGO con EXITO o NO se pudo AGREGAR (por algun motivo)

Tiene PRIORIDAD la carga multiple de varios barcodes sobre la carga multiple de varios ejemplares

Si el barcode ES obligatorio:

    - No puede ser blanco
    - No puede Existir

Si el barcode NO es obligatorio:
    
    - Se permite barcode en blanco
    - Si se ingresa un barcode, NO PUEDE EXISTIR

=cut

sub _generateBarcode{
  return (time());
}

=head2 sub _generarArreglo

    Esta funcion hace de "distribuidor", chequea q tipo de alta de ejemplares se va hacer, 
    por cant de ejemplares (llama a _generarArregloDeBarcodesPorCantidad) o 
    un conjunto de barcodes agregados por el usuario (llama a _generarArregloDeBarcodesPorBarcodes()).
    Devuelve un arreglo de barcodes validos (autogenerados o ingresados por el usuario)
=cut
sub _generarArreglo{    
    my ($params, $msg_object) = @_;
 
    my $cant                        = $params->{'cantEjemplares'}; #recupero la cantidad de ejemplares a agregar, 1 o mas
    my $barcodes_array              = $params->{'BARCODES_ARRAY'}; #se esta agregando por barcodes 
    my @barcodes_para_agregar;
    $params->{'agregarPorBarcodes'} = 0;
    my $esPorBarcode                = 0;
    $esPorBarcode                   = $params->{'esPorBarcode'};#defined $barcodes_array;

    C4::AR::Debug::debug("Nivel 3 => _generarArreglo => esPorBarcode => ".$esPorBarcode);
    #se setea la cantidad de ejemplares a agregar
    if($esPorBarcode eq 'true'){
        $params->{'agregarPorBarcodes'} = 1;
#         _generarArregloDeBarcodesPorBarcodes($msg_object, $barcodes_array, \@barcodes_para_agregar);
#         @barcodes_para_agregar = _generarArregloDeBarcodesPorBarcodes($msg_object, $barcodes_array);
        @barcodes_para_agregar = @$barcodes_array;
    }else{
        @barcodes_para_agregar = _generarArregloDeBarcodesPorCantidad($cant, $params, $msg_object);
    }

    return (\@barcodes_para_agregar);
}

=head2 sub _generarArregloDeBarcodesPorBarcodes
Esta funcion genera un arreglo de barcodes VALIDOS para agregar en la base de datos, ademas setea los mensajes de ERROR para los usuarios
=cut
sub _generarArregloDeBarcodesPorBarcodes{   
    my ($msg_object, $barcodes_array) = @_;
    C4::AR::Debug::debug("Nivel3 => _generarArregloDeBarcodesPorBarcodes !!!!!!!!!!");
    my @barcodes_para_agregar;
 
    C4::AR::Debug::debug("Nivel3 => _generarArregloDeBarcodesPorBarcodes !!!!!!!!!! barcodes_array => ".scalar(@$barcodes_array));
    foreach my $barcode (@$barcodes_array){

            push (@barcodes_para_agregar, $barcode);
#         }
    }# END foreach my $barcode (@$barcodes_array)

    return @barcodes_para_agregar;
}

sub _selectBarcodeFormat{
    my ($params) = @_;
    
    my $default_ui = C4::AR::Preferencias::getValorPreferencia("defaultUI");
    my $UI_origen_object = $params->{'ui_origen'};
    my $UI_duenio_object = $params->{'ui_duenio'};
    
    return ($UI_duenio_object || $default_ui || $UI_origen_object);
    
        
}

=head2 sub _generarArregloDeBarcodesPorCantidad
Esta funcion genera un arreglo de barcodes VALIDOS para agregar en la base de datos
=cut
sub _generarArregloDeBarcodesPorCantidad {   
    my($cant, $params, $msg_object) = @_;

    C4::AR::Debug::debug("Nivel3 => _generarArregloDeBarcodesPorCantidad !!!!!!!!!!");
    my $barcode;
    my $numero;
    my $tope = 1000; #puede ser preferencia

    $msg_object->{'error'} = 0;#no hay error

    if( !($msg_object->{'error'}) && $cant > $tope ){
        #se esta intentando agregar mas de $tope ejemplares
        $msg_object->{'error'} = 1;
        C4::AR::Debug::debug("_verificarGuardarNivel3 => Se está intentando agregar mas de ".$tope." ejemplares");
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U405', 'params' => [$tope]} ) ;

    }
 

    my @barcodes_para_agregar;
    if( !$msg_object->{'error'} ){

        my %parametros;
        $parametros{'UI'}               = _selectBarcodeFormat($params);
        $parametros{'tipo_ejemplar'}    = $params->{'tipo_ejemplar'};

        (@barcodes_para_agregar) = generaCodigoBarra(\%parametros, $cant);
        

    }
    
    return (@barcodes_para_agregar); 
}


sub _existeBarcodeEnArray {
    my ($barcode, @barcodes_array)= @_;

    return C4::AR::Utilidades::existeInArray($barcode, @barcodes_array);
}

sub getHistoricoDisponibilidad {

    my ($id3,$ini,$cantR) = @_;
    my $historico_array_ref = C4::Modelo::CatHistoricoDisponibilidad::Manager->get_cat_historico_disponibilidad (
                                                                        query => [
                                                                                        id3 => { eq => $id3 },
                                                                                ],
                                                                            limit   => $cantR,
                                                                            offset  => $ini,
                                                                            sort_by => ['timestamp DESC']
     );

    #Obtengo la cant total en el histórico para el paginador
    my $historico_array_ref_count = C4::Modelo::CatHistoricoDisponibilidad::Manager->get_cat_historico_disponibilidad_count( query => [id3 => { eq => $id3 }]);
    if(scalar(@$historico_array_ref) > 0){
        return ($historico_array_ref_count, $historico_array_ref);
    }else{
        return (0,0);
    }
}



# Devuelve la fecha del utlimo cambio de disponibilidad

sub getFechaUltimoCambioDisp{
    my ($id3) = @_;

    my $fecha          = C4::Modelo::CatHistoricoDisponibilidad::Manager->get_cat_historico_disponibilidad(   
                                                                                                            select => [ 'MAX(timestamp) AS timestamp'],
                                                                                                    
                                                                                                            query =>  [id3 => { eq => $id3 }
                                                                                                                   ]

                                                                                                        );

    return ($fecha);
    
}



sub getHistoricoCirculacion {

    my ($id3,$ini,$cantR,$fecha_inicial,$fecha_final,$orden) = @_;

    my @filtros;
    my $dateformat = C4::Date::get_date_format();

    push(@filtros, ( id3 => { eq => $id3 } ) );

    if($fecha_inicial){
        push(@filtros, ( fecha => { ge => C4::Date::format_date_in_iso($fecha_inicial, $dateformat) }) );
    }

    if($fecha_final){
        push(@filtros, ( fecha => { le => C4::Date::format_date_in_iso($fecha_final, $dateformat) }) );
    }

    my $historico_array_ref = C4::Modelo::RepHistorialCirculacion::Manager->get_rep_historial_circulacion (
                                                                            query => \@filtros, 
                                                                            limit   => $cantR,
                                                                            # estos objetos para poder ordenar por AJAX
                                                                            with_objects => ['socio.persona','responsable_ref','responsable_ref.persona'],
                                                                            offset  => $ini,
                                                                            sort_by => $orden
     );

    #Obtengo la cant total en el histórico para el paginador
    my $historico_array_ref_count = C4::Modelo::RepHistorialCirculacion::Manager->get_rep_historial_circulacion_count(query => \@filtros);
    if(scalar(@$historico_array_ref) > 0){
        return ($historico_array_ref_count, $historico_array_ref);
    }else{
        return (0,0);
    }
}

END { }       # module clean-up code here (global destructor)

1;
__END__
