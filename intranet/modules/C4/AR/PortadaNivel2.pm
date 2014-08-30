package C4::AR::PortadaNivel2;

use strict;
use C4::AR::UploadFile;
use C4::Modelo::CatRegistroMarcN2Cover;

use vars qw(@EXPORT_OK @ISA);

@ISA        = qw(Exporter);

@EXPORT_OK  = qw(
          agregar
          getPortadasEdicion
          getCountPortadasEdicion
);


=item
    Agrega portadas a un nivel2
=cut
# FIXME mensajes!!!
sub agregar{

    my ($parametros)  = @_;

    my $portadaNivel2       = C4::Modelo::CatRegistroMarcN2Cover->new();
    my $msg_object          = C4::AR::Mensajes::create();
    my $db                  = $portadaNivel2->db;

    my $id2                 = $parametros->{'id2'};
    my $arrFiles            = $parametros->{'arrayFiles'};
    my $arrayFilesDelete    = $parametros->{'arrayFilesDelete'};

    my $portadaNivel2;  
    my $image_name;

    #hardcodeado
    my $path                = C4::Context->config("portadasNivel2Path");
    my $path_covers         = C4::Context->config("covers");

    my @arrayImagenesSaved;

    $db->{connect_options}->{AutoCommit} = 0;
    $db->begin_work;

    eval{

        # C4::AR::Debug::debug("cantidad a eliminar :_ " . scalar(@$arrayFilesDelete));
        if(scalar(@$arrayFilesDelete)){   

            foreach my $file ( @$arrayFilesDelete ){
            
                _eliminarPortadaEdicionByNombre($file, $db);
                unlink($path."/".$file);
            }
            
        }

        if ($parametros->{'borrar_imagenes_registro'}){
            my $isbn                                = C4::AR::Nivel2::getISBNById2($parametros->{'id2'});

            C4::AR::Debug::debug("PortadaNivel2 => agregar => Se eliminan las tapas del registro");

            if ($isbn) {
            # Elimino las portadas del Registro
                my $portada                         = C4::AR::PortadasRegistros::getPortadaByIsbn($isbn);
                $portada->delete();
                unlink($path_covers."/".$portada->getSmall());
                unlink($path_covers."/".$portada->getMedium());
                unlink($path_covers."/".$portada->getLarge());
            }
        }

        #recorremos todas las imagenes y las guardamos      
        foreach my  $value (@$arrFiles) {
        
            $image_name = C4::AR::UploadFile::uploadPortadaNivel2($value);
            
            if(!$image_name){

                $msg_object->{'error'} = 1;
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'POR00', 'intra'} );
                die;

            }else{

                push(@arrayImagenesSaved, $image_name);
                $portadaNivel2 = C4::Modelo::CatRegistroMarcN2Cover->new(db => $db);                 
                $portadaNivel2->agregar($image_name, $id2);  

            }
        }

        $msg_object->{'error'} = 0;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'POR01', 'params' => []});
        $db->commit;

        1;
    }or do{

        #borramos las imagenes que ya se hayan guardado en disco
        my $arrayRef    = \@arrayImagenesSaved;

        foreach my  $value (@$arrayRef) {
            unlink($path . "/" . $value);
        }

        $msg_object->{'error'} = 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'POR00', 'intra'} ) ;
        C4::AR::Debug::debug("PortadaNivel2 => agregar => ERROR al cargar la tapa");
        $db->rollback;
    };

    $db->{connect_options}->{AutoCommit} = 1;
     
    return ($msg_object);

}

=item
    Elimina la imagen de la portada edicion recibida como parametro (nombre)
=cut
sub _eliminarPortadaEdicionByNombre{

    my ($image_name ,$db) = @_;
    my @filtros;
    #viene vacio aveces, por la hash que pasamos desde editar_novedad.pl
    if($image_name){

        use C4::Modelo::CatRegistroMarcN2Cover::Manager;
        
        push (@filtros, (image_name => {eq => $image_name}) );
        
        my $portadas_edicion_array_ref = C4::Modelo::CatRegistroMarcN2Cover::Manager->get_cat_registro_marc_n2_cover( 
                                                                                        query => \@filtros,
                                                                                        db => $db,
                                                                                  );

        if(scalar(@$portadas_edicion_array_ref) > 0){
        
            $portadas_edicion_array_ref->[0]->delete();
            
        }else{
            return (0);
        }
    }
}


=item
    Devuelve las portadas que tenga el id2 recibido por parametro
=cut
sub getPortadasEdicion{

    my ($id2) = @_;

    my @filtros;

    use C4::Modelo::CatRegistroMarcN2Cover::Manager;
        
    push (@filtros, (id2 => {eq => $id2}) );
    
    my $portadas_edicion_array_ref = C4::Modelo::CatRegistroMarcN2Cover::Manager->get_cat_registro_marc_n2_cover( query => \@filtros );

    if(scalar(@$portadas_edicion_array_ref) > 0){
    
        return $portadas_edicion_array_ref;
        
    }else{
        return (0);
    }
}


sub getCountPortadasEdicion{

    my ($id2) = @_;

    my @filtros;

    use C4::Modelo::CatRegistroMarcN2Cover::Manager;
        
    push (@filtros, (id2 => {eq => $id2}) );
    
    my $portadas_edicion_array_ref_count = C4::Modelo::CatRegistroMarcN2Cover::Manager->get_cat_registro_marc_n2_cover_count( query => \@filtros,
                                                                              );
    return $portadas_edicion_array_ref_count;
}

1;