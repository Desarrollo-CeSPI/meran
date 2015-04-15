package C4::AR::UploadFile;

# module to upload/delete pictures of the borrowers
# written 03/2005
# by Luciano Iglesias - li@info.unlp.edu.ar - LINTI, Facultad de Informática, UNLP Argentina

# This file is part of Koha.
#
# Koha is free software; you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# Koha is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# Koha; if not, write to the Free Software Foundation, Inc., 59 Temple Place,
# Suite 330, Boston, MA  02111-1307 USA

use strict;
require Exporter;
use C4::Context;
use C4::AR::Mensajes;
use C4::AR::Utilidades;
use C4::AR::Preferencias;
use Image::Resize;
use File::LibMagic;
use vars qw(@EXPORT @ISA);
@ISA=qw(Exporter);
@EXPORT=qw(
        uploadFotoNovedadOpac
        uploadPhoto
        deletePhoto
        uploadFile
        deleteDocument
        uploadImport
        deleteImport
        uploadAdjuntoNovedadOpac
        deleteIndice
        uploadPortadaNivel2
    );

my $picturesDir = C4::Context->config("picturesdir");


=item
    Sube una portada a un nivel 2
=cut
sub uploadPortadaNivel2{

    my ($foto) = @_;

    use Digest::MD5;
    use C4::AR::Utilidades;
    
    my @whiteList            = qw(
                                        png
                                        jpg
                                        jpeg
                                        gif
                                    );

    my $uploaddir               = C4::Context->config("portadasNivel2Path");
    my $maxFileSize             = 2048 * 2048; # 1/2mb max file size...
    my $hash_unique             = Digest::MD5::md5_hex(localtime() + rand(10));
    my ($file_type,$notBinary)  = C4::AR::Utilidades::checkFileMagic($foto, @whiteList);

    #es un archivo valido
    if($file_type){
    
        if($notBinary){
        
            #no hay que escribirlo con binmode
            open(WRITEIT, ">$uploaddir/$hash_unique.$file_type") or die "Cant write to $uploaddir/$hash_unique.$file_type. Reason: $!";
            print WRITEIT $foto;
            close(WRITEIT);
   
        }else{
        
            open ( WRITEIT, ">$uploaddir/$hash_unique.$file_type" ) or die "Cant write to $uploaddir/$hash_unique.$file_type. Reason: $!"; 
            binmode WRITEIT; 
            while ( <$foto> ) { 
                print WRITEIT; 
            }
            close(WRITEIT);
        
        }

        #si es tamaño 0, lo escribimos del modo inverso
        if (_ceroSize("$uploaddir/$hash_unique.$file_type")) {

            # lo borramos primero
            unlink("$uploaddir/$hash_unique.$file_type");

            # es un if inverso al de arriba
            if ($notBinary) {

                open ( WRITEIT, ">$uploaddir/$hash_unique.$file_type" ) or die "Cant write to $uploaddir/$hash_unique.$file_type. Reason: $!"; 
                binmode WRITEIT; 
                while ( <$foto> ) { 
                    print WRITEIT; 
                }
                close(WRITEIT);

            } else {

                open(WRITEIT, ">$uploaddir/$hash_unique.$file_type") or die "Cant write to $uploaddir/$hash_unique.$file_type. Reason: $!";
                print WRITEIT $foto;
                close(WRITEIT);

            }
        }

        return ("$hash_unique.$file_type");
        
    }
    
    return 0;
}

=item
    Checkea el tamaño de un archivo recivido como parametro.
    Devuelve true si es 0 bytes, false en caso contrario 
=cut
sub _ceroSize{
    my ($filePath) = @_;

    if (-s $filePath) {
        return 0;
    } else {
        return 1;
    }
}

=item
    Sube la imagen del tipo de documento
=cut
sub uploadTipoDeDocImage{
    my ($foto, $file_name) = @_;

    use Digest::MD5;
    use C4::AR::Utilidades;
    
    my @whiteList            = qw(
                                    png
                                );

    my $uploaddir               = C4::Context->config("tipoDocumentoPath");
    my $maxFileSize             = 2048 * 2048; # 1/2mb max file size...
    my ($file_type,$notBinary)  = C4::AR::Utilidades::checkFileMagic($foto, @whiteList);
    
    #es un archivo valido
    if($file_type){
    
        if($notBinary){
        
            #no hay que escribirlo con binmode
            open(WRITEIT, ">$uploaddir/$file_name.$file_type") or die "Cant write to $uploaddir/$file_name.$file_type. Reason: $!";
            print WRITEIT $foto;
            close(WRITEIT);
   
        }else{
        
            open ( WRITEIT, ">$uploaddir/$file_name.$file_type" ) or die "Cant write to $uploaddir/$file_name.$file_type. Reason: $!"; 
            binmode WRITEIT; 
            while ( <$foto> ) { 
                print WRITEIT; 
            }
            close(WRITEIT);
        
        }
        return ("$file_name.$file_type");     
    }    
    return 0;
}

sub uploadAdjuntoNovedadOpac{

    my ($adjunto) = @_;

    use Digest::MD5;
    use C4::AR::Utilidades;
    
    my @whiteList            = qw(
                                        pdf
                                        xls
                                        doc
                                        docx
                                        xlsx
                                        zip
                                        rft
                                        odt
                                        ods
                                        msword
                                    );
    
    my @nombreYextension        = split('\.',$adjunto);
    my $uploaddir               = C4::Context->config("novedadesOpacPath");
    my $maxFileSize             = 2048 * 2048; # 1/2mb max file size...
    my $hash_unique             = Digest::MD5::md5_hex(localtime() + rand(10));
    my ($mime_type,$notBinary)  = C4::AR::Utilidades::checkFileMagic($adjunto, @whiteList);
    
  


    #es un archivo valido
    if($mime_type){

        #fix para archivos .doc. El mime es msword y lo guarda con esa extension sino
        if($mime_type eq 'msword'){ $mime_type = 'doc'; }

        # Parche para que no se interpreten como zip los archivos docx
        if ((@nombreYextension[1] eq "docx") && ($mime_type eq "zip")){
                $mime_type = 'docx';
        } 
    
        # Parche para que no se interpreten como zip los archivos docx
        if ((@nombreYextension[1] eq "xlsx") && ($mime_type eq "zip")){
                $mime_type = 'xlsx';
        } 
    

        if($notBinary){
        
            #no hay que escribirlo con binmode
            open(WRITEIT, ">$uploaddir/$hash_unique.$mime_type") or die "Cant write to $uploaddir/$hash_unique.$mime_type. Reason: $!";
            print WRITEIT $adjunto;
            close(WRITEIT);
   
        }else{
        
            open ( WRITEIT, ">$uploaddir/$hash_unique.$mime_type" ) or die "Cant write to $uploaddir/$hash_unique.$mime_type. Reason: $!"; 
            binmode WRITEIT; 
            while ( <$adjunto> ) { 
            	print WRITEIT; 
            }
            close(WRITEIT);
            
        }

        return ("$hash_unique.$mime_type");
        
    }
     
    
    return 0;

}



sub uploadFotoNovedadOpac{

    my ($imagen) = @_;

    use Digest::MD5;
    use C4::AR::Utilidades;
    
    my @filesAllowed            = qw(
                                        jpeg
                                        gif
                                        png
                                        jpg
                                    );

    my $uploaddir               = C4::Context->config("novedadesOpacPath");
    my $maxFileSize             = 2048 * 2048; # 1/2mb max file size...
    my $hash_unique             = Digest::MD5::md5_hex(localtime() + rand(10));
    my ($file_type,$notBinary)  = C4::AR::Utilidades::checkFileMagic($imagen, @filesAllowed);
    
    #es un archivo valido
    if($file_type){
    
        if($notBinary){
        
            #no hay que escribirlo con binmode
            open(WRITEIT, ">$uploaddir/$hash_unique.$file_type") or die "Cant write to $uploaddir/$hash_unique.$file_type. Reason: $!";
            print WRITEIT $imagen;
            close(WRITEIT);
   
        }else{
        
            open ( WRITEIT, ">$uploaddir/$hash_unique.$file_type" ) or die "Cant write to $uploaddir/$hash_unique.$file_type. Reason: $!"; 
            binmode WRITEIT; 
            while ( <$imagen> ) { 
            	print WRITEIT; 
            }
            close(WRITEIT);
        
        }

        if (_ceroSize("$uploaddir/$hash_unique.$file_type")) {

            # lo borramos primero
            unlink("$uploaddir/$hash_unique.$file_type");

            # es un if inverso al de arriba
            if ($notBinary) {

                open ( WRITEIT, ">$uploaddir/$hash_unique.$file_type" ) or die "Cant write to $uploaddir/$hash_unique.$file_type. Reason: $!"; 
                binmode WRITEIT; 
                while ( <$imagen> ) { 
                    print WRITEIT; 
                }
                close(WRITEIT);

            } else {

                open(WRITEIT, ">$uploaddir/$hash_unique.$file_type") or die "Cant write to $uploaddir/$hash_unique.$file_type. Reason: $!";
                print WRITEIT $imagen;
                close(WRITEIT);

            }
        }

        return ("$hash_unique.$file_type");
        
    }
    
    return 0;

}

sub uploadPhoto{
    my ($query) = @_;

    use C4::Modelo::UsrSocio;
    
    my @filesAllowed    = qw(
                                jpeg
                                gif
                                png
                                jpg
                            );

    my $uploaddir       = C4::Context->config("picturesdir");
    my $uploaddir_oapc  = C4::Context->config("picturesdir_opac");
    my $maxFileSize     = 2048 * 2048; # 1/2mb max file size...
    my $file            = $query->param('POSTDATA');
    my $nro_socio       = $query->url_param('nro_socio');
    my $socio           = C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);
    my $msg_object      = C4::AR::Mensajes::create();
    
    #checkeamos con libmagic el tipo del archivo
    my $type            = C4::AR::Utilidades::checkFileMagic($file, @filesAllowed);
    my $sessionType     = C4::AR::Auth::getSessionType();
    my $name            = $socio->fotoName($sessionType);
    
    if ($sessionType eq "opac"){
        $uploaddir = $uploaddir_oapc;
    }
    
    if($type){

        eval{
	        if ($name){
	            unlink($uploaddir . "/" . $name);
	        }
        };

        open(WRITEIT, ">$uploaddir/$name") or die "Cant write to $uploaddir/$name. Reason: $!";
            print WRITEIT $file;
        close(WRITEIT);


        my $check_size = -s "$uploaddir/$name";

        if ($check_size < 1) {
            $msg_object->{'error'} = 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP01', $sessionType} ) ;
        } elsif ($check_size > $maxFileSize) {
            $msg_object->{'error'} = 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP01', $sessionType} ) ;
        } else  {
            $msg_object->{'error'} = 0;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP08', $sessionType} ) ;
        }
        
    }else{
    
        $msg_object->{'error'} = 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP13', $sessionType} ) ;
    
    }
    
    return ($msg_object);

}

sub deletePhoto{
    my ($foto_name) = @_;
# TODO falta verificar permisos
    my $msg_object  = C4::AR::Mensajes::create();

#   if (open(PHOTO,">>".$picturesDir.'/'.$foto_name)){
    if (unlink(C4::AR::Utilidades::trim($picturesDir."/".$foto_name))) {
        $msg_object->{'error'}= 0;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U344', 'params' => []} ) ;
    }else{
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U345', 'params' => []} ) ;
    }

    return ($msg_object);
}

sub uploadFile{

    my ($prov,$write_file,$filepath, $presupuestos_dir) = @_;
    my $bytes_read;
    my $msg                     = '';
    my $size                    = 0;
    my $msg_object              = C4::AR::Mensajes::create();
    my @extensiones_permitidas  = ("doc","docx","odt","ods","pdf","xls","xlsx","zip");

    my @nombreYextension        = split('\.',$filepath);

    if (scalar(@nombreYextension)==2) {

    # verifica que el nombre del archivo tenga el punto (.)
            my $ext         = @nombreYextension[1];
            my $buff        = '';

            if ((open(WFD,">$write_file"))) {
                    while ($bytes_read=read($filepath,$buff,2096)) {
                        $size += $bytes_read;
                        binmode WFD;
                        print WFD $buff;
                    }
                    close(WFD);
              }
    }
}

sub uploadDocument {

    my ($file_name,$name,$id2,$file_data)=@_;

    my $eDocsDir= C4::Context->config("edocsdir");
    my $msg='';
    my $bytes_read;
    my $size= 0;

    my $showName = $name;

    if (!C4::AR::Utilidades::validateString($showName)){
        $showName = $file_name;
    }

    my @nombreYextension=split('\.',$file_name);

    use Digest::MD5;
#Para chequeos de tamaño
# my $maxFileSize = 2048 * 2048; # 1/2mb max file size...
# my $check_size = -s "$uploaddir/$name.$type";
#if ($check_size > $maxFileSize) { blabla }


    if (C4::AR::Preferencias::getPreferencia("e_documents")){

        my @extensiones_permitidas=("bmp","jpg","gif","png","jpeg","doc","docx","odt","ods","pdf","xls","xlsx","zip","rar","mp3");
        my $size = scalar(@nombreYextension) - 1;
        my $ext= @nombreYextension[$size];

        if (!grep(/$ext/i,@extensiones_permitidas)) {
                $msg= "Solo se permiten archivos del tipo (".join(", ",@extensiones_permitidas).") [Fallo de extension]";
        }elsif (scalar(@nombreYextension)>=2) { # verifica que el nombre del archivo tenga el punto (.)
            my $ext= @nombreYextension[$size];
            my $buff='';

            $name = @nombreYextension[0];
            my $file_type = $ext;
            my $hash_unique = Digest::MD5::md5_hex(localtime());
            my $file_name = $name.".".$ext."_".$hash_unique;
            my $write_file= $eDocsDir."/".$file_name;

            if (!open(WFD,">$write_file")) {
                    $msg="Hay un error y el archivo no puede escribirse en el servidor.";
            }else{
                my $size = 0;
                while ($bytes_read=read($file_data,$buff,2096,0)) {
                        $size += $bytes_read;
                        binmode WFD;
                        print WFD $buff;
                }
                close(WFD);

                my $isValidFileType = C4::AR::Utilidades::isValidFile($write_file);

                if ( !$isValidFileType )
                {
                    $msg= "Solo se permiten archivos (".join(", ",@extensiones_permitidas).") [Fallo de contenido]";
                    unlink($write_file);
                }else
                {
                    $msg= "El archivo ".$name.".$ext ($showName) se ha cargado correctamente";
                    C4::AR::Catalogacion::saveEDocument($id2,$file_name,$isValidFileType,$showName);
                }
            }
        }else{
            $msg= C4::AR::Filtros::i18n("El nombre del archivo no tiene un formato correcto.");
        }
    }else{
         $msg= C4::AR::Filtros::i18n("El manejo de archivos no esta habilitado.");
    }

    return($msg);
}

sub deleteDocument {

    my ($query,$params)=@_;

    my $eDocsDir= C4::Context->config("edocsdir");
    my $file_id = $params->{'id'};
    my $msg_object  = C4::AR::Mensajes::create();

    if (C4::AR::Preferencias::getPreferencia("e_documents")){
        my $file = C4::AR::Catalogacion::getDocumentById($file_id);

        my $write_file= $eDocsDir."/".$file->getFilename;

        if (!open(WFD,"$write_file")) {
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP05', 'params' => []} ) ;
                $msg_object->{'error'}= 1;
        }else{
            unlink($write_file);
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP06', 'params' => [$file->getTitle]} ) ;
            $file->delete();
        }
    }else{
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP14', 'params' => []} ) ;
                $msg_object->{'error'}= 1;
    }

    return($msg_object);
}


sub uploadImport {

    my ($params)=@_;

    my $importsDir  = C4::Context->config("importsdir");
    my $msg_object  = C4::AR::Mensajes::create();
    $msg_object->{'error'}= 0;
    #my $msg='';
    my $bytes_read;
    my $size= 0;

    my $showName = $params->{'titulo'};

    if (!C4::AR::Utilidades::validateString($showName)){
        $showName = $params->{'file_name'};
    }

    my @nombreYextension=split('\.',$params->{'file_name'});

    use Digest::MD5;
#Para chequeos de tamaño
# my $maxFileSize = 2048 * 2048; # 1/2mb max file size...
# my $check_size = -s "$uploaddir/$name.$type";
#if ($check_size > $maxFileSize) { blabla }


        my @extensiones_permitidas=("iso","xml","xls", "ods", "cvs");
        my $size = scalar(@nombreYextension) - 1;
        my $ext= @nombreYextension[$size];

        if (!grep(/$ext/i,@extensiones_permitidas)) {
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP00', 'params' => [join(", ",@extensiones_permitidas)]});
            #$msg= "Solo se permiten archivos del tipo (".join(", ",@extensiones_permitidas).") [Fallo de extension]";
        }elsif (scalar(@nombreYextension)>=2) { # verifica que el nombre del archivo tenga el punto (.)
            my $ext= @nombreYextension[$size];
            my $buff='';

            my $name = @nombreYextension[0];
            my $file_type = $ext;
            my $hash_unique = Digest::MD5::md5_hex(localtime());
            $params->{'file_name'} = $name.".".$ext."_".$hash_unique;
            $params->{'file_ext'}=$ext;
            my $write_file= $importsDir."/".$params->{'file_name'};

            if (!open(WFD,">$write_file")) {
                    #$msg="Hay un error y el archivo no puede escribirse en el servidor.";
                    $msg_object->{'error'}= 1;
                    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP01', 'params' => []});
            }else{
                my $size = 0;
                while ($bytes_read=read($params->{'file_data'},$buff,2096,0)) {
                        $size += $bytes_read;
                        binmode WFD;
                        print WFD $buff;
                }
                close(WFD);

                my $isValidFileType = C4::AR::Utilidades::isValidFile($write_file);

                if ( !$isValidFileType )
                {
                    $msg_object->{'error'}= 1;
                    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP00', 'params' => [join(", ",@extensiones_permitidas)]});
                    unlink($write_file);
                }else
                {
                    eval {
                        #$msg= "El archivo ".$name.".$ext ($showName) se ha cargado correctamente";
                        $params->{'showName'}=$showName;
                        $params->{'isValidFileType'}=$isValidFileType;
                        $params->{'write_file'}=$write_file;

                        C4::AR::ImportacionIsoMARC::guardarNuevaImportacion($params,$msg_object);
                        if ($msg_object->{'error'} eq 0){
                            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP02', 'params' => [$name.$ext,$showName]});
                        } else{
                            #Si no se pudo guardar la importacion, se borra el archivo.
                             unlink($write_file);
                            }
                    };
                    if ($@){
                        #Se loguea error de Base de Datos
                        &C4::AR::Mensajes::printErrorDB($@, 'B454',"INTRA");
                        #Si no se pudo guardar la importacion, se borra el archivo.
                        unlink($write_file);
                        #Se setea error para el usuario
                        $msg_object->{'error'}= 1;
                        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP03', 'params' => []} ) ;
                    }
                }
            }
        }else{
            #$msg= C4::AR::Filtros::i18n("El nombre del archivo no tiene un formato correcto.");
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP04', 'params' => []} ) ;
        }

    return($msg_object);
}

sub deleteImport {

    my ($params)=@_;
    my $importsDir= C4::Context->config("importsdir");
    my $msg_object  = C4::AR::Mensajes::create();
    $msg_object->{'error'}= 0;

    my $file_id = $params->{'id'};

    my $file = C4::AR::ImportacionIsoMARC::getImportacionById($file_id);
        my $write_file= $importsDir."/".$file->getArchivo;
        if (!open(WFD,"$write_file")) {
                #$msg=C4::AR::Filtros::i18n("Hay un error y el archivo no puede eliminarse del servidor.");
                $msg_object->{'error'}= 1;
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP05', 'params' => []} ) ;
        }else{
            unlink($write_file);
            #$msg= C4::AR::Filtros::i18n("El archivo ").$file->getTitle.C4::AR::Filtros::i18n(" se ha eliminado correctamente");
            $msg_object->{'error'}= 0;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP06', 'params' => [$file->getNombre]} ) ;
        }
    return($msg_object);
}


sub uploadIndiceFile{

    my ($file_name,$name,$id2,$file_data)=@_;

    my $eDocsDir= C4::Context->config("edocsdir");
    my $msg='';
    my $bytes_read;
    my $size= 0;
    my $showName = $name;

    if (!C4::AR::Utilidades::validateString($showName)){
        $showName = $file_name;
    }

    my @nombreYextension=split('\.',$file_name);

    use Digest::MD5;
#Para chequeos de tamaño
# my $maxFileSize = 2048 * 2048; # 1/2mb max file size...
# my $check_size = -s "$uploaddir/$name.$type";
#if ($check_size > $maxFileSize) { blabla }

    my @extensiones_permitidas    = qw(
                                        bmp
                                        jpg
                                        gif
                                        png
                                        jpeg
                                        doc
                                        docx
                                        odt
                                        ods
                                        pdf
                                        xls
                                        xlsx
                                    );

    # my @extensiones_permitidas=("bmp","jpg","gif","png","jpeg","doc","docx","odt","pdf","xls");
    my $size = scalar(@nombreYextension) - 1;
    my $ext  = @nombreYextension[$size];

    # if (!grep(/$ext/i,@extensiones_permitidas)) {
    if (!($ext ~~ @extensiones_permitidas)) {

            $msg = "Solo se permiten archivos del tipo (".join(", ",@extensiones_permitidas).") [Fallo de extension]";

    } elsif (scalar(@nombreYextension)>=2) { # verifica que el nombre del archivo tenga el punto (.)

        my $ext         = @nombreYextension[$size];
        my $buff        = '';

        $name           = @nombreYextension[0];
        my $file_type   = $ext;
        my $hash_unique = Digest::MD5::md5_hex(localtime());
        my $file_name   = $name.".".$ext."_".$hash_unique;
        my $write_file  = $eDocsDir."/".$file_name;

        if (!open(WFD,">$write_file")) {
                $msg = "Hay un error y el archivo no puede escribirse en el servidor.";
        }else{
            my $size = 0;
            while ($bytes_read=read($file_data,$buff,2096,0)) {
                    $size += $bytes_read;
                    binmode WFD;
                    print WFD $buff;
            }
            close(WFD);

            my $isValidFileType = C4::AR::Utilidades::isValidFile($write_file);

            if ( !$isValidFileType )
            {
                $msg= "Solo se permiten archivos (".join(", ",@extensiones_permitidas).") [Fallo de contenido]";
                unlink($write_file);
            }else
            {
                $msg= "El archivo ".$name.".$ext ($showName) se ha cargado correctamente. Refresque la p&aacute;gina para ver.";
                C4::AR::Catalogacion::saveIndice($id2,$file_name);
            }
        }
    }else{
        $msg= C4::AR::Filtros::i18n("El nombre del archivo no tiene un formato correcto.");
    }

    return($msg);
}

sub deleteIndice{

    my ($query,$params)=@_;

    my $eDocsDir= C4::Context->config("edocsdir");
    my $msg='';
    my $id2 = $params->{'id2'};
    my $nivel2 = C4::AR::Nivel2::getNivel2FromId2($id2);

        my $write_file= $eDocsDir."/".$nivel2->getIndiceFilePath;

        if (!open(WFD,"$write_file")) {
                $msg=C4::AR::Filtros::i18n("Hay un error y el archivo no puede eliminarse del servidor.");
        }else{
            unlink($write_file);
            $msg= C4::AR::Filtros::i18n("El archivo del indice ").C4::AR::Filtros::i18n(" se ha eliminado correctamente");
            $nivel2->getIndiceFilePath(undef);
            $nivel2->save();
        }

    return($msg);
}
