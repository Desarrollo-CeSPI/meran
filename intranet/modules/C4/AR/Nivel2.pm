package C4::AR::Nivel2;

use strict;
require Exporter;
use C4::Context;
use C4::Modelo::CatRegistroMarcN2;
use C4::Modelo::CatRegistroMarcN2::Manager;
use C4::Modelo::CatRating::Manager;
use C4::Modelo::CatRating;
use HTML::Entities;
use C4::AR::Sphinx qw(generar_indice);

use POSIX qw(NULL ceil);


use vars qw(@EXPORT_OK @ISA);

@ISA    = qw(Exporter);

@EXPORT_OK = qw(
        getCantPrestados
        getNivel2FromId1
        getNivel2FromId2
        getFirstItemTypeFromN1
        getNivel2FromId2_asArray
        buildNavForGroups
        getAnaliticasFromNivel2
        getRevisionesPendientes
        getReview
        eliminarReview
        aprobarReview
        eliminarReviews
        checkReferenciaTipoDoc
        promoteGrupo
        unPromoteGrupo
        checkPromotion
        eliminarReviewsDeNivel2
        getDestacados
        
);

=head1 NAME

C4::AR::Nivel1 - Funciones que manipulan datos del catálogo de nivel 1

=head1 SYNOPSIS

  use C4::AR::Nivel1;

=head1 DESCRIPTION

  Descripción del modulo COMPLETAR

=head1 FUNCTIONS

=over 2

=cut

=cut



=item
    Checkea que el tipo de documento recibido por parametro no este referenciado en nivel2
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
 getNivel2FromId2t_guardarNivel2

    Esta funcion se invoca desde el template para guardar los datos de nivel2, se apoya en una funcion de Catalogacion.pm que lo que hace es transformar los datos que llegan en un objeto MARC::Record que luego va a insertarse en la base de datos a traves de un objeto CatRegistroMarcN2
=cut
sub t_guardarNivel2 {
    my ($params) = @_;

    my $msg_object = C4::AR::Mensajes::create();
    my $id2;
    if(!$msg_object->{'error'}){
    #No hay error
        my $marc_record     = C4::AR::Catalogacion::meran_nivel2_to_meran($params);
        ($msg_object,$id2)  = guardarRealmente($msg_object, $params, $marc_record);
    }
    return ($msg_object, $params->{'id1'}, $id2);
}



=head2
sub guardarRealmente

Esta funcion realmente guarda el elemento en la base
=cut
sub guardarRealmente{
    my ($msg_object, $params, $marc_record)=@_;
    my $id2;
    my $catRegistroMarcN2;
    if(!$msg_object->{'error'}){
        $catRegistroMarcN2 = C4::Modelo::CatRegistroMarcN2->new();  
        my $db = $catRegistroMarcN2->db;
        # enable transactions, if possible
        $db->{connect_options}->{AutoCommit} = 0;
        $db->begin_work;
    
        eval {
            $catRegistroMarcN2->agregar($params, $marc_record->as_usmarc, $db);
            $db->commit;
            #recupero el id1 recien agregado
            $id2 = $catRegistroMarcN2->getId2;

# TODO guardar en estantes, si es que se especifica en $params->{'estantes_array'}
            foreach my $estante_id (@{$params->{'estantes_array'}}){
                C4::AR::Debug::debug("Nivel2 => estante_id => " . $estante_id);
                C4::AR::Estantes::agregarContenidoAEstante($estante_id, $id2);                
            }

            eval {
                C4::AR::Sphinx::generar_indice($catRegistroMarcN2->getId1, 'R_PARTIAL', 'INSERT');
                #ahora el indice se encuentra DESACTUALIZADO
                C4::AR::Preferencias::setVariable('indexado', 0, $db);
            };    
            if ($@){
                C4::AR::Debug::debug("ERROR AL REINDEXAR EN EL REGISTRO: ".$catRegistroMarcN2->getId1()." !!! ( ".$@." )");
            }

            #se cambio el permiso con exito
            $msg_object->{'error'} = 0;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U369', 'params' => [$id2]} ) ;
        };

    
        if ($@){
            #Se loguea error de Base de Datos
            &C4::AR::Mensajes::printErrorDB($@, 'B428',"INTRA");
            eval {$db->rollback};
            #Se setea error para el usuario
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U372', 'params' => []} ) ;
        }

        $db->{connect_options}->{AutoCommit} = 1;

    }

    return ($msg_object, $id2);
}

=head2
sub guardarRealmente

Esta funcion realmente guarda el elemento en la base
=cut
sub t_guardarIndice{
    my ($params) = @_;

        my $catRegistroMarcN2   = getNivel2FromId2($params->{'id2'});
        my $msg_object          = C4::AR::Mensajes::create(); 
        my $db                  = $catRegistroMarcN2->db;
        # enable transactions, if possible
        $db->{connect_options}->{AutoCommit} = 0;
        $db->begin_work;
    
        eval {
            $catRegistroMarcN2->setIndice($params->{'indice'});
            $catRegistroMarcN2->save();
            $db->commit;
            eval {
                C4::AR::Sphinx::generar_indice($catRegistroMarcN2->getId1, 'R_PARTIAL', 'INSERT');
                #ahora el indice se encuentra DESACTUALIZADO
                C4::AR::Preferencias::setVariable('indexado', 0, $db);
            };    
            if ($@){
                C4::AR::Debug::debug("ERROR AL REINDEXAR EN EL REGISTRO: ".$catRegistroMarcN2->getId1()." !!! ( ".$@." )");
            }

            #se cambio el permiso con exito
            $msg_object->{'error'} = 0;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U610', 'params' => []} ) ;
        };

    
        if ($@){
            #Se loguea error de Base de Datos
            &C4::AR::Mensajes::printErrorDB($@, 'B428',"INTRA");
            eval {$db->rollback};
            #Se setea error para el usuario
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U611', 'params' => []} ) ;
        }

        $db->{connect_options}->{AutoCommit} = 1;

    return ($msg_object);
}

=head2 sub t_eliminarNivel2
    Elimina el nivel 2 pasado por parametro
=cut
sub t_eliminarNivel2{
    my($id2) = @_;
   
    my $msg_object = C4::AR::Mensajes::create();

    my $params;    
    my $cat_registro_marc_n2 = C4::Modelo::CatRegistroMarcN2->new();
    my $db = $cat_registro_marc_n2->db;
    my ($cat_registro_marc_n2) = getNivel2FromId2($id2, $db);
   
    if(!$cat_registro_marc_n2){
        #NO EXISTE EL OBJETO
        #Se setea error para el usuario
        $msg_object->{'error'} = 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U404', 'params' => []} ) ;
    }else{
        #EXISTE EL OBJETO
         $params->{'id2'} = $id2;
        #verifico condiciones necesarias antes de eliminar     
        _verificarDeleteNivel2($msg_object, $params, $cat_registro_marc_n2);
    }

    if(!$msg_object->{'error'}){
        #No hay error        
        # enable transactions, if possible
        $db->{connect_options}->{AutoCommit} = 0;
        $db->begin_work;
    
        eval {
            $cat_registro_marc_n2->eliminar($params);  
            eliminarReviewsDeNivel2($id2,$db);
            $db->commit;
            eval {
                C4::AR::Sphinx::generar_indice($cat_registro_marc_n2->getId1(), 'R_PARTIAL', 'UPDATE');
                #ahora el indice se encuentra DESACTUALIZADO
                C4::AR::Preferencias::setVariable('indexado', 0, $db);
            };    
            if ($@){
                C4::AR::Debug::debug("ERROR AL REINDEXAR EN EL REGISTRO: ".$cat_registro_marc_n2->getId1()." !!! ( ".$@." )");
            }
            #se cambio el permiso con exito
            $msg_object->{'error'} = 0;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U375', 'params' => [$id2]} ) ;
        };
    
        if ($@){
            #Se loguea error de Base de Datos
            &C4::AR::Mensajes::printErrorDB($@, 'B429',"INTRA");
            $db->rollback;
            #Se setea error para el usuario
            $msg_object->{'error'} = 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U378', 'params' => [$id2]} ) ;
        }

        $db->{connect_options}->{AutoCommit} = 1;

    }

    return ($msg_object);
}


=head2
sub getAllNivel2

    Recupero TODOS los catRegistroMarcN2 que existen 
=cut
sub getAllNivel2{
    my ($id1, $db) = @_;
    
    $db = $db || C4::Modelo::CatRegistroMarcN2->new()->db();

    my $nivel2_array_ref = C4::Modelo::CatRegistroMarcN2::Manager->get_cat_registro_marc_n2(
                                                                        db => $db,
                                                                        query => [
#                                                                                         id1 => { eq => $id1 },
                                                                                ],
                                                                );
                                                                
    return ($nivel2_array_ref);
}


sub getAllAnaliticas{
    my ($id1, $db) = @_;
    
    $db = $db || C4::Modelo::CatRegistroMarcN2->new()->db();

    my $nivel2_array_ref = C4::Modelo::CatRegistroMarcN2::Manager->get_cat_registro_marc_n2(
                                                                        db => $db,
                                                                        query => [
                                                                                        template => { eq => "ANA" },
                                                                                ],
                                                                );
                                                                
    return ($nivel2_array_ref);
}
=head2
sub getNivel2FromId1

    Recupero TODOS los catRegistroMarcN2 que existen relacionados a un CatRegistroMarcN1 a traves del id1
=cut
sub getNivel2FromId1{
    my ($id1, $db) = @_;
    
    $db = $db || C4::Modelo::CatRegistroMarcN2->new()->db();

    my $nivel2_array_ref = C4::Modelo::CatRegistroMarcN2::Manager->get_cat_registro_marc_n2(
                                                                        db => $db,
                                                                        query => [
                                                                                        id1 => { eq => $id1 },
                                                                                ],
                                                                );
                                                                
    return ($nivel2_array_ref);
}

sub getFirstItemTypeFromN1{
    my ($id1,$nivel2) = @_;
    
    if (!$nivel2){
        $nivel2 = getNivel2FromId1($id1);
    }
    
    if (scalar(@$nivel2)){
        return ($nivel2->[0]->getTipoDocumento);
    }
    
    return ('DEFAULT');
        
}

=head2 sub getNivel2FromId2
    Recupero un nivel 2 a partir de un id2
    retorna un objeto o 0 si no existe
=cut
sub getNivel2FromId2{
    my ($id2, $db) = @_;

    my $nivel2_array_ref = C4::Modelo::CatRegistroMarcN2::Manager->get_cat_registro_marc_n2(
                                                                        db => $db, 
                                                                        query => [ 
                                                                                    id => { eq => $id2 },
                                                                            ],
                                                                        require_objects => ['nivel1'],
#                                                                         select          => ['cat_registro_marc_n1.*']
                                                                        select          => ['*']    
                                                                );

    if (scalar(@$nivel2_array_ref) > 0){
        return ($nivel2_array_ref->[0]);
    }else{
        return (0);
    }
}

sub getNivel2FromId2_asArray{
    my ($id2, $db) = @_;
    my $nivel2 = getNivel2FromId2($id2,$db);
    
    my @array = ();
    
    push(@array,$nivel2);
    
    return \@array; 
}


sub getTipoEjemplarFromId2{
    my ($id2) = @_;

    my ($cat_registro_marc_n2) = getNivel2FromId2($id2);

    if($cat_registro_marc_n2){
        return $cat_registro_marc_n2->getTipoDocumento;
    }
}

sub _verificarDeleteNivel2 {
    my($msg_object, $params, $cat_registro_marc_n2)=@_;

    $msg_object->{'error'} = 0;#no hay error

    if( !($msg_object->{'error'}) && $cat_registro_marc_n2->tienePrestamos() ){
        C4::AR::Debug::debug("_verificarDeleteNivel2 => tiene al menos 1 ejemplar prestado ");
        #verifico que el nivel2 que quiero eliminar no tenga ningun ejemplar prestado
        $msg_object->{'error'} = 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P124', 'params' => [$params->{'id2'}]} ) ;

    }elsif( !($msg_object->{'error'}) && $cat_registro_marc_n2->tieneReservas() ){
        #verifico que el nivel2 que quiero eliminar no tenga ningun ejemplar reservado
        $msg_object->{'error'} = 1;
        C4::AR::Debug::debug("_verificarDeleteNivel2 => Se está intentando eliminar un ejemplar que tiene al menos un ejemplar reservado ");
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P123', 'params' => [$params->{'id2'}]} ) ;
    }
    elsif( !($msg_object->{'error'}) && $cat_registro_marc_n2->estaEnEstante() ){
        #verifico que el nivel2 que quiero eliminar no esté contenido en algún estante
        $msg_object->{'error'} = 1;
        C4::AR::Debug::debug("_verificarDeleteNivel2 => Se está intentando eliminar un grupo que esta contenido en un estante ");
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'E018', 'params' => [$params->{'id2'}]} ) ;
    }
    else{
         #FINALMENTE: verifico que puedan eliminarse todos sus ejemplares!! para evitar inconsistencias
            my $ejemplares = $cat_registro_marc_n2->getEjemplares();
            foreach my $nivel3 (@$ejemplares){
                #verifico condiciones necesarias antes de eliminar los ejemplares    
                $params->{'id3'} = $nivel3->getId3;
                C4::AR::Nivel3::_verificarDeleteItem($msg_object, $params);
            }
    }
}


=head2 sub getCantPrestados
    retorna la canitdad de items prestados para el grupo pasado por parametro
=cut
sub getCantPrestados{
    my ($id2,$db) = @_;
    
    $db = $db || C4::Modelo::CircPrestamo->new()->db;
# FIXME falta arreglar las ref
    my $cantPrestamos_count = C4::Modelo::CircPrestamo::Manager->get_circ_prestamo_count(
                                                                db      => $db,
                                                                query => [  't2.id2' => { eq => $id2 },
                                                                            fecha_devolucion => { eq => undef }  
                                                                         ],
                                                                require_objects     => ['nivel3.nivel2','tipo'],
                                                                with_objects        => ['nivel3'],
                                        );

    #C4::AR::Debug::debug("C4::AR::Nivel2::getCantPrestados ".$cantPrestamos_count);

    return $cantPrestamos_count;
}


=item
  sub getNivel2FromTipoDocumento

  devuelve un arreglo de niveles 2 filtrados por tipo de documento
=cut
sub getNivel2FromTipoDocumento {
    my ($tipo_doc) = @_;
    

# TODO Miguel ver si esto es eficiente, de todos modos no se si se puede hacer de otra manera!!!!!!!!!!
# 1) parece q no queda otra, hay q "abrir" el marc_record y sacar el barcode para todos los ejemplares e ir comparando cada uno GARRONNNN!!!!
# 2) se podria usar el indice??????????????

    my @filtros;
    my $cat_registro_marc_n2_array_ref;
    my @cat_registro_marc_n2_array_ref_result;

    
    my $cat_registro_marc_n2_array_ref = C4::Modelo::CatRegistroMarcN2::Manager->get_cat_registro_marc_n2( query => \@filtros ); 

    my $cant = scalar(@$cat_registro_marc_n2_array_ref);


    C4::AR::Debug::debug("CANTIDAD REGISTROS MARC N2: ".$cant." TIPO: ".  $tipo_doc);

    for(my $i=0; $i < $cant; $i++){

        C4::AR::Debug::debug($cat_registro_marc_n2_array_ref->[$i]->getTipoDocumentoObject());

        if($cat_registro_marc_n2_array_ref->[$i]->getTipoDocumentoObject() eq $tipo_doc){
            push(@cat_registro_marc_n2_array_ref_result, $cat_registro_marc_n2_array_ref->[$i]);
            last();
        }
    }

    if(scalar(@cat_registro_marc_n2_array_ref_result) > 0){
        return (\@cat_registro_marc_n2_array_ref_result);
    }else{
        return (0);
    }
}

=head2
    sub getISBNById1
    Retorna (SI EXISTE) el ISBN segun el Id1 pasado por parametro
=cut
sub getISBNById1{
    my ($id1) = @_;

    my @filtros;
    my @cat_registro_marc_n2_array_result;
    push(@filtros, ( id1    => { eq => $id1}));

    my $cat_registro_marc_n2_array_ref = C4::Modelo::CatRegistroMarcN2::Manager->get_cat_registro_marc_n2( query => \@filtros );

    if(scalar(@$cat_registro_marc_n2_array_ref) > 0){
        return ($cat_registro_marc_n2_array_ref->[0]->getISBN());
    }else{
        return (0);
    }
}

=head2
    sub getISBNById1
    Retorna (SI EXISTE) el ISBN segun el Id1 pasado por parametro
=cut
sub getISBNById2{
    my ($id2) = @_;

    my @filtros;
    my @cat_registro_marc_n2_array_result;
    push(@filtros, ( id    => { eq => $id2}));

    my $cat_registro_marc_n2_array_ref = C4::Modelo::CatRegistroMarcN2::Manager->get_cat_registro_marc_n2( query => \@filtros );

    if(scalar(@$cat_registro_marc_n2_array_ref) > 0){
        return ($cat_registro_marc_n2_array_ref->[0]->getISBN());
    }else{
        return (0);
    }
}
#***********************************************ACA FINALIZA LA NUEVA ESTRUCTURA***************************************************************




=item sub t_modificarNivel2
    transaccion mofica el nivel 2 pasado por parametro
=cut
sub t_modificarNivel2 {
    my($params) = @_;

## FIXME ver si falta verificar algo!!!!!!!!!!
    my $msg_object                          = C4::AR::Mensajes::create();
    my $cat_registro_marc_n2                = C4::Modelo::CatRegistroMarcN2->new();
    my $db                                  = $cat_registro_marc_n2->db;
    my ($cat_registro_marc_n2)              = getNivel2FromId2($params->{'id2'}, $db);

    if(!$cat_registro_marc_n2){
        #Se setea error para el usuario
        $msg_object->{'error'} = 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U403', 'params' => []} ) ;
    }

    if(!$msg_object->{'error'}){
    #No hay error
        
        $params->{'modificado'} = 1;
#         my $db = $cat_registro_marc_n2->db;
        # enable transactions, if possible
        $db->{connect_options}->{AutoCommit} = 0;
         $db->begin_work;
    
        eval {
            my $marc_record = C4::AR::Catalogacion::meran_nivel2_to_meran($params);
            $cat_registro_marc_n2->modificar($params, $marc_record->as_usmarc, $db);  
            $db->commit;

# TODO guardar en estantes, si es que se especifica en $params->{'estantes_array'}
            foreach my $estante_id (@{$params->{'estantes_array'}}){
                C4::AR::Debug::debug("Nivel2 => estante_id => " . $estante_id);
                C4::AR::Estantes::agregarContenidoAEstante($estante_id, $cat_registro_marc_n2->getId2());                
            }


            eval {
                C4::AR::Sphinx::generar_indice($cat_registro_marc_n2->getId1, 'R_PARTIAL', 'UPDATE');
                #ahora el indice se encuentra DESACTUALIZADO
                C4::AR::Preferencias::setVariable('indexado', 0, $db);
            };    
            if ($@){
                C4::AR::Debug::debug("ERROR AL REINDEXAR EN EL REGISTRO: ".$cat_registro_marc_n2->getId1()." !!! ( ".$@." )");
            }

            #se cambio el permiso con exito
            $msg_object->{'error'}= 0;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U381', 'params' => [$cat_registro_marc_n2->getId2]} ) ;
        };
    
        if ($@){
            #Se loguea error de Base de Datos
            &C4::AR::Mensajes::printErrorDB($@, 'B431',"INTRA");
            $db->rollback;
            #Se setea error para el usuario
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U384', 'params' => [$cat_registro_marc_n2->getId2]} ) ;
        }

        $db->{connect_options}->{AutoCommit} = 1;

    }

    return ($msg_object, $cat_registro_marc_n2);
}


sub getAnaliticasFromNivel2{
    my ($id2, $db) = @_;


    $db                                     = $db || C4::Modelo::CircPrestamo->new()->db;
    my $nivel2_object                       = C4::AR::Nivel2::getNivel2FromId2($id2);
    my $cat_reg_marc_n2_analiticas          = ($nivel2_object)?$nivel2_object->getAnaliticas():0;
    my @analitica_array;
    my @nivel2_array;

    if($cat_reg_marc_n2_analiticas){

        foreach my $n2 (@$cat_reg_marc_n2_analiticas){
            my %hash_nivel1_aux;   
            my @nivel2_array; 
    
            my $n1_object                                           = C4::AR::Nivel1::getNivel1FromId1($n2->getId1());
            if($n1_object){
                    $hash_nivel1_aux{'nivel1_analitica'}            = $n1_object->toMARC_Intra;
                    $hash_nivel1_aux{'nivel1_analitica_titulo'}     = $n1_object->getTitulo();
                    $hash_nivel1_aux{'nivel1_analitica_autor'}      = $n1_object->getAutor();
                    $hash_nivel1_aux{'nivel1_analitica_id1'}        = $n1_object->getId1();
            }        

# TODO falta levantar los grupos del nivel 1 q estoy procedando!!!!!!!!!!!!!!!!!   
# es otro foreach         
            my $n2_array_ref                                = C4::AR::Nivel2::getNivel2FromId1($n2->getId1());
            foreach my $n2 (@$n2_array_ref){
                my %hash_nivel2_aux;  

                $hash_nivel2_aux{'nivel2_analitica'}        = $n2->toMARC_Intra;
                push(@nivel2_array, \%hash_nivel2_aux);
            }

            $hash_nivel1_aux{'nivel2_analitica_array'}      = \@nivel2_array;
        
            push(@analitica_array, \%hash_nivel1_aux);
        }
    }

    return \@analitica_array;
}


=item
    Retorna las analiticas que se encuentran relacionadas a una edicion
=cut
sub getAllAnaliticasById2{
    my($id2, $db) = @_;

    $db = $db || C4::Modelo::CatRegistroMarcN2Analitica->new()->db();

    my @filtros;
    push (@filtros, ('cat_registro_marc_n2_id'       => { eq => $id2 } ));

    my $nivel2_analiticas_array_ref = C4::Modelo::CatRegistroMarcN2Analitica::Manager->get_cat_registro_marc_n2_analitica(
                                                                        db      => $db,
                                                                        query   => \@filtros,
                                                                );


    if( scalar(@$nivel2_analiticas_array_ref) > 0){
        return ($nivel2_analiticas_array_ref);
    }else{
        return 0;
    }
}

=item
    Retorna la relacion analica entre un registro y un grupo
=cut
sub getAnaliticasFromRelacion{
    my($params, $db) = @_;

    $db = $db || C4::Modelo::CatRegistroMarcN2Analitica->new()->db();

    my @filtros;
    push (@filtros, ('cat_registro_marc_n2_id'       => { eq => $params->{'id2'} } ));
    push (@filtros, ('cat_registro_marc_n1_id'       => { eq => $params->{'id1'} } ));

    my $nivel2_analiticas_array_ref = C4::Modelo::CatRegistroMarcN2Analitica::Manager->get_cat_registro_marc_n2_analitica(
                                                                        db      => $db,
                                                                        query   => \@filtros,
                                                                );


    if( scalar(@$nivel2_analiticas_array_ref) > 0){
        return ($nivel2_analiticas_array_ref->[0]);
    }else{
        return 0;
    }
}

sub getAllAnaliticasById1{
    my($id1, $db) = @_;

    $db = $db || C4::Modelo::CatRegistroMarcN2Analitica->new()->db();
    my $nivel1_analiticas_array_ref = ();

    my @filtros;
    push (@filtros, ('cat_registro_marc_n1_id'       => { eq => $id1 } ));

    $nivel1_analiticas_array_ref = C4::Modelo::CatRegistroMarcN2Analitica::Manager->get_cat_registro_marc_n2_analitica(
                                                                        db      => $db,
                                                                        query   => \@filtros,
                                                                );


    return $nivel1_analiticas_array_ref;
    # if( scalar(@$nivel1_analiticas_array_ref) > 0){
    #     return ($nivel1_analiticas_array_ref);
    # }else{
    #     return 0;
    # }
}

=item
    Retorna el registro fuente de una analitica a partir de un id1
=cut
sub getIdNivel2RegistroFuente {
    my($id1,$db) = @_;

    $db = $db || C4::Modelo::CatRegistroMarcN2->new()->db();

    my $nivel2_analiticas_array_ref = C4::Modelo::CatRegistroMarcN2Analitica::Manager->get_cat_registro_marc_n2_analitica(
                                                                        db => $db,
                                                                        query => [
                                                                                    cat_registro_marc_n1_id => { eq => $id1 },
                                                                            ]
                                                                );

    if( scalar(@$nivel2_analiticas_array_ref) > 0){
        return $nivel2_analiticas_array_ref->[0]->getId2Padre();
    }

    return 0; 
}

sub getRating{
    my($id2,$db) = @_;

    my @filtros;

    $db = $db || C4::Modelo::CatRating->new()->db;
    
    push (@filtros, (id2 => {eq => $id2}));
    my $rating = C4::Modelo::CatRating::Manager->get_cat_rating(query => \@filtros, db => $db,);
    my $rating_count = C4::Modelo::CatRating::Manager->get_cat_rating_count(query => \@filtros, db => $db,);
    my $count = 0;

    foreach my $rate (@$rating){
        $count+= $rate->getRate();
    }

    if($rating_count > 0){
        $rating_count = ($count/$rating_count);
    } 
    
    return $rating_count;
}


sub getDestacados{
    my($db) = @_;

    my @filtros;

    my $db = $db || C4::Modelo::CatRating->new()->db;
    
    my $rating = C4::Modelo::CatRating::Manager->get_cat_rating(query => \@filtros, db => $db,);
    my @array_n2;

    my %hash_n1;
    my $count_rating = 0;
    foreach my $r (@$rating){
        my $n1 = C4::AR::Nivel1::getNivel1FromId2($r->getId2);
        @array_n2= getNivel2FromId1($n1->id);
        $n1->{"rating"} = C4::AR::Nivel2::getRatingPromedio(@array_n2);

        # C4::AR::Debug::debug($n1->{"rating"});

        if ( $n1->{"rating"} != '0'){
            $hash_n1{$n1->id}= $n1;
            $count_rating++;
        }
    }

    $db = $db || C4::Modelo::CatRegistroMarcN2->new()->db;

    push (@filtros, (promoted => {eq => "1"}));

    my $promoted = C4::Modelo::CatRegistroMarcN2::Manager->get_cat_registro_marc_n2(query => \@filtros, db => $db,);
    my $promoted_count = C4::Modelo::CatRegistroMarcN2::Manager->get_cat_registro_marc_n2_count(query => \@filtros, db => $db,);

    foreach my $r (@$promoted){
        $r->{'portada_registro'}          = C4::AR::PortadasRegistros::getImageForId2($r->getId2,'S');

        $r->{'portada_registro_medium'}   = C4::AR::PortadasRegistros::getImageForId2($r->getId2,'M');
        $r->{'portada_registro_big'}      = C4::AR::PortadasRegistros::getImageForId2($r->getId2,'L');
        $r->{'portada_edicion_local'}     = C4::AR::PortadaNivel2::getPortadasEdicion($r->getId2);

    }

    return (\%hash_n1, $promoted, $promoted_count,$count_rating);

}


sub getRevisionesPendientes{
    my($db) = @_;

    my @filtros;

    $db = $db || C4::Modelo::CatRating->new()->db;
    
    push (@filtros, (review_aprobado => {eq => 0}));
    push (@filtros, (review => {ne => undef}));

    my $revisiones = C4::Modelo::CatRating::Manager->get_cat_rating(query => \@filtros, db => $db,require_objects=>['socio','nivel2']);

    return $revisiones;
}

sub getRatingPromedio{
    my($nivel2_array_ref) = @_;

    my $cant = scalar(@$nivel2_array_ref);

    if ($cant > 0){
        my $ratings = 0;
        foreach my $nivel2 (@$nivel2_array_ref){
            $ratings+= getRating($nivel2->getId2,$nivel2->db);
        }
        my $rating_count = POSIX::ceil($ratings/$cant);
        return $rating_count;
    }else{
        return (0);
    }
}

sub rate{
    my($rate,$id2,$nro_socio) = @_;

    my $rating_obj = C4::Modelo::CatRating->new();
    

    $rating_obj = $rating_obj->getObjeto($nro_socio, $id2);
    $rating_obj->setRate($rate);
    $rating_obj->save();

}


sub getCantReviews{
    my($id2,$db) = @_;

    my @filtros;
    
    $db = $db || C4::Modelo::CatRating->new()->db;
    
    push (@filtros, (id2 => {eq => $id2}));
    push (@filtros, (review => {ne => NULL}));
    push (@filtros, (review_aprobado => {eq => 1}));
    my $reviews = C4::Modelo::CatRating::Manager->get_cat_rating_count(query => \@filtros, db => $db,);

    return $reviews;
}

sub getReviews{
    my($id2,$db) = @_;
    my @filtros;
  
    $db = $db || C4::Modelo::CatRating->new()->db;
    
    push (@filtros, (id2 => {eq => $id2}));
    push (@filtros, (review => {ne => NULL}));
    push (@filtros, (review_aprobado => {eq => 1}));
    my $reviews = C4::Modelo::CatRating::Manager->get_cat_rating(   query => \@filtros,
                                                                    db => $db,
                                                                    include_objects => ['socio'],
                                                                    sort_by => 'date',
                                                                 );
    if (scalar(@$reviews) > 0){
        return $reviews
    }else{
        return 0;
    }
}

sub getReview{
    my($id_review, $db) = @_;
    my @filtros;
  
    $db = $db || C4::Modelo::CatRating->new()->db;
    
    push (@filtros, (id => {eq => $id_review}));

    my $reviews = C4::Modelo::CatRating::Manager->get_cat_rating(   query => \@filtros,
                                                                    db => $db,
                                                                    include_objects => ['socio'],
                                                                    sort_by => 'date',
                                                                 );
    if (scalar(@$reviews) > 0){
        return $reviews->[0];
    }else{
        return 0;
    }
}

sub eliminarReview{
    my($id_review, $db) = @_;

    my $review = getReview($id_review);

    if ($review){
        return $review->delete();
    }

    return 0;

}

sub eliminarReviews{
    my($id_array) = @_;

    my $msg_object      = C4::AR::Mensajes::create();

    
    eval {
         foreach my $revision_id (@$id_array){
            my $review = getReview($revision_id);
            $review->delete();
        }

       C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'REV000'});
    };

    if ($@){
        $msg_object->{'error'} = 1;
         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'REV001'});
    } 

    return $msg_object;

}


sub eliminarReviewsDeNivel2{
    my($id2,$db) = @_;

    my @filtros;
  
    push (@filtros, (id2 => {eq => $id2}));
    
    $db = $db || C4::Modelo::CatRegistroMarcN2->new()->db();

    my $reviews = C4::Modelo::CatRating::Manager->delete_cat_rating(   where    => \@filtros,
                                                                       db       => $db,

                                                                 );
    return $reviews;

}

sub aprobarReviews{
    my($id_array) = @_;

    my $msg_object      = C4::AR::Mensajes::create();

    
    eval {
         foreach my $revision_id (@$id_array){
            aprobarReview($revision_id);
        }

       C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'REV002'});
    };

    if ($@){
        $msg_object->{'error'} = 1;
         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'REV003'});
    } 


    return $msg_object;

}
sub aprobarReview{
    my($id_review, $db) = @_;

    my $review = getReview($id_review);

    if ($review){
        $review->setReviewAprobado(1);
        return $review->save();
    }

    return 0;

}
sub reviewNivel2{
    my ($id2,$review,$nro_socio) = @_;
    my $rating_obj = C4::Modelo::CatRating->new();

    $rating_obj = $rating_obj->getObjeto($nro_socio, $id2);
    
    $rating_obj->setReview($review);
    $rating_obj->save();
}

sub buildNavForGroups{
    my ($params) = @_;
    
    my @elem_array;
    
    my $nivel2 = $params->{'nivel2'};

        foreach my $n2 (@$nivel2){
            my %hash = {};
            $hash{'id'} = "detalle_grupo_".$n2->{'id2'};
            my $n2_temp = C4::AR::Nivel2::getNivel2FromId2($n2->{'id2'}); 
            $hash{'title'} = $n2_temp->getNavString();   
            push (@elem_array,\%hash);
        }
 
    return \@elem_array;
}

sub checkPromotion{
    my ($id2) = @_;

    my $nivel2 = C4::AR::Nivel2::getNivel2FromId2($id2);

    if ($nivel2){
        if ($nivel2->isPromoted()){
            return  C4::AR::Filtros::action_button( 
                                                                      button        => "btn btn-inverse disabled",
                                                                      action        => "unPromote(".$id2.",this)", 
                                                                      icon          => "icon-white icon-thumbs-down",
                                                                      title         => C4::AR::Filtros::i18n('No destacar'),
                                                                  ) ;

        }else{  C4::AR::Filtros::action_button( 
                                                                      button        => "btn btn-inverse",
                                                                      action        => "promote(".$id2.",this)", 
                                                                      icon          => "icon-white icon-thumbs-up",
                                                                      title         => C4::AR::Filtros::i18n('Destacar'),
                                                                  ) ;
        }
    }
}

sub promoteGrupo{
    my ($id2) = @_;

    my $nivel2 = C4::AR::Nivel2::getNivel2FromId2($id2);
    $nivel2->promote();
    $nivel2->save();

    #Actualizo indice para reflejar el destacado
    eval {
        C4::AR::Sphinx::generar_indice($nivel2->getId1, 'R_PARTIAL', 'UPDATE');
        #ahora el indice se encuentra DESACTUALIZADO
        C4::AR::Preferencias::setVariable('indexado', 0, $nivel2->db());
    };    
    if ($@){
        C4::AR::Debug::debug("ERROR AL REINDEXAR EN EL REGISTRO: ".$nivel2->getId1()." !!! ( ".$@." )");
    }

    return checkPromotion($id2);    
}

sub unPromoteGrupo{
    my ($id2) = @_;

    my $nivel2 = C4::AR::Nivel2::getNivel2FromId2($id2);
    $nivel2->unPromote();
    $nivel2->save();

    #Actualizo indice para reflejar el destacado
    eval {
        C4::AR::Sphinx::generar_indice($nivel2->getId1, 'R_PARTIAL', 'UPDATE');
        #ahora el indice se encuentra DESACTUALIZADO
        C4::AR::Preferencias::setVariable('indexado', 0, $nivel2->db());
    };    
    if ($@){
        C4::AR::Debug::debug("ERROR AL REINDEXAR EN EL REGISTRO: ".$nivel2->getId1()." !!! ( ".$@." )");
    }

    return checkPromotion($id2);    
}
END { }       # module clean-up code here (global destructor)

1;
__END__
