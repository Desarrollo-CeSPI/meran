package C4::AR::TipoDocumento;

use strict;
use C4::Modelo::CatRefTipoNivel3;
use C4::Modelo::CatRefTipoNivel3::Manager;

use vars qw(@EXPORT @ISA);
@ISA    = qw(Exporter);
@EXPORT = qw( 
    getTipoDocumento
    getTipoDocumentoByTipo
    getTipoDocumentoById
    modTipoDocumento
    deleteTipoDocumento
    agregarTipoDocumento
);


=item
    Agrega un tipo de documento nuevo
=cut
sub agregarTipoDocumento{
    my ($params, $postdata) = @_;

    my $tipoDoc             = C4::Modelo::CatRefTipoNivel3->new();
    my $db                  = $tipoDoc->db;
    my $msg_object          = C4::AR::Mensajes::create();

    $db->{connect_options}->{AutoCommit} = 0;
    $db->begin_work;

    eval{
        $tipoDoc->agregar($params);

        #subir imagen
        if ($postdata) {
            $msg_object = uploadCoverImage($postdata, $params->{'tipoDocumento'}, $msg_object);
        } else {
            #no subio imagen, clonamos la default
            $msg_object = uploadCoverImageDefault($params->{'tipoDocumento'}, $msg_object);
        }

        # hubo error subiendo la imagen
        if($msg_object->{'error'}){
            die();
        }

        $msg_object->{'error'} = 0;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'TD001', 'params' => []});
        $db->commit;

    };

    if($@){
        cancelUploadCoverImage($params->{'tipoDocumento'});

        # C4::AR::Mensajes::printErrorDB($@, 'AM01',"INTRA");
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'TD002', 'params' => [$params->{'campo'}, $params->{'subcampo'}]} ) ;

        $db->rollback;
   }
   $db->{connect_options}->{AutoCommit} = 1;

   return ($msg_object);
}

=item
    Devuelve los tipos de documentos y la cantidad
    Sino, 0,0
=cut
sub getTipoDocumento{

    my $tiposDocumentoRef       = C4::Modelo::CatRefTipoNivel3::Manager->get_cat_ref_tipo_nivel3();

    my $tiposDocumentoRefCount  = C4::Modelo::CatRefTipoNivel3::Manager->get_cat_ref_tipo_nivel3_count();

    if(scalar(@$tiposDocumentoRef) > 0){
        return ($tiposDocumentoRef, $tiposDocumentoRefCount);
    }else{
        return (0,0);
    }
}

=item
    Devuelve el tipo de documento, buscandolo por el tipo recibido por parametro
    Sino, 0,0
=cut
sub getTipoDocumentoByTipo{

    my ($tipoDoc) = @_;

    my @filtros;
    
    push (@filtros, (id_tipo_doc => {eq => $tipoDoc}) );

    my $tiposDocumentoRef       = C4::Modelo::CatRefTipoNivel3::Manager->get_cat_ref_tipo_nivel3(query => \@filtros,);

    if(scalar(@$tiposDocumentoRef) > 0){
        return ($tiposDocumentoRef->[0]);
    }else{
        return (0);
    }
}

=item
    Devuelve el tipo de documento, buscandolo por el id recibido por parametro
    Sino, 0,0
=cut
sub getTipoDocumentoById{

    my ($id) = @_;

    my @filtros;
    
    push (@filtros, (id => {eq => $id}) );

    my $tiposDocumentoRef = C4::Modelo::CatRefTipoNivel3::Manager->get_cat_ref_tipo_nivel3(query => \@filtros,);

    if(scalar(@$tiposDocumentoRef) > 0){
        return ($tiposDocumentoRef->[0]);
    }else{
        return (0);
    }
}

=item
    Modifica el tipo de documento
=cut
sub modTipoDocumento{

    my ($params, $postdata)    = @_;

    my $tipoDoc     = getTipoDocumentoById($params->{'id'});
    my $db          = $tipoDoc->db;
    my $msg_object  = C4::AR::Mensajes::create();


    $db->{connect_options}->{AutoCommit} = 0;
    $db->begin_work;

    eval{

        $tipoDoc->modTipoDocumento($params);

        if($postdata){
            $msg_object = uploadCoverImage($postdata, $params->{'tipoDoc'}, $msg_object);
        }      

        if($msg_object->{'error'}){

            $db->rollback;

        }else{

            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'TD001', 'params' => []});
            $db->commit;

        }

    };

    if($@){

        C4::AR::Mensajes::printErrorDB($@, 'AM01',"INTRA");

        $msg_object->{'error'}= 1;

        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'TD002', 'params' => [$params->{'campo'}, $params->{'subcampo'}]} ) ;

        $db->rollback;
   }

   return ($msg_object);
}


=item
    Sube la imagen del tipo de doc
=cut
sub uploadCoverImage{
    my ($image, $file_name, $msg_object) = @_;

    use C4::AR::UploadFile;

    my $file = C4::AR::UploadFile::uploadTipoDeDocImage($image, $file_name);

    if($file){
        $msg_object->{'error'} = 0;
    }else{
        #no lo guardo
        $msg_object->{'error'} = 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'TD006', 'params' => []} ) ;
    }

    return $msg_object;
}

=item
    Esto se ejecuta cuando ocurre un error (rollback), elimina la imagen del sistema de 
    archivos
=cut
sub cancelUploadCoverImage{
    
    my ($file_name) = @_;

    my $uploaddir   = C4::Context->config("tipoDocumentoPath");

    unlink($uploaddir ."/" . $file_name . ".png");
}

=item
    Sube la imagen default al tipo de doc
=cut
sub uploadCoverImageDefault{
    
    my ($file_name, $msg_object) = @_;

    my $uploaddir = C4::Context->config("tipoDocumentoPath");

    use File::Copy;

    copy($uploaddir . "/DEFAULT.png", $uploaddir . "/" . $file_name . ".png") or die "Copy failed: $!";

    $msg_object->{'error'} = 0;

    return $msg_object;
}


=item
    Elimina el tipo de documento
    Solo si éste no esta referenciado en nivel_1 y nivel_2. Tambien que no sea el tipo
    por default.
=cut
sub deleteTipoDocumento{

    my ($tipoDoc)       = @_;

    use C4::AR::Nivel1;
    use C4::AR::Nivel2;
    use C4::AR::Nivel3;

    my $msg_object      = C4::AR::Mensajes::create();

    my $defaultTipoDoc  = C4::AR::Preferencias::getValorPreferencia('defaultTipoNivel3');

    my $cantReferencias;

    # si es el tipo de doc por defecto no lo dejamos borrar
    if($defaultTipoDoc ne $tipoDoc){
    
        $cantReferencias = C4::AR::Nivel1::checkReferenciaTipoDoc($tipoDoc);

        $cantReferencias = C4::AR::Nivel1::checkReferenciaTipoDoc($tipoDoc, $cantReferencias);

        $cantReferencias = C4::AR::Nivel1::checkReferenciaTipoDoc($tipoDoc, $cantReferencias);

    }else{
        $cantReferencias = 1;
    }


    if( $cantReferencias ne 0 ) {

        $msg_object->{'error'} = 1;

        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'TD003', 'params' => []} ) ;
    
    }else{

        my $tipoDocumento   = getTipoDocumentoByTipo($tipoDoc);
        my $db              = $tipoDocumento->db;

        eval{

            $tipoDocumento->delete();

            _eliminarFotoTipoDoc($tipoDoc);

            $msg_object->{'error'} = 0;

            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'TD004', 'params' => []} ) ;

            $db->commit;

        };

        if($@){

            $msg_object->{'error'} = 1;

            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'TD005', 'params' => []} ) ;

            $db->rollback;

        }   
    
    }

    return $msg_object;
}

sub _eliminarFotoTipoDoc{

    my ($tipoDoc) = @_;

    my $uploaddir = C4::Context->config("tipoDocumentoPath");

    unlink($uploaddir . "/" . $tipoDoc . ".png");
}

1;