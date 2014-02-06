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
package C4::AR::Logos;
use strict;
use C4::Modelo::LogoEtiquetas;
use C4::Modelo::LogoEtiquetas::Manager;
use C4::Modelo::LogoUI;
use C4::Modelo::LogoUI::Manager;
use vars qw(@EXPORT @ISA);
@ISA=qw(Exporter);
@EXPORT=qw( 
    listar
    listarUI
    agregarLogo
    agregarLogoUI
    getLogoById
    eliminarLogo
    getPathLogoUI
    getPathLogoEtiquetas
    deleteLogos
);
=item
    Devuelve el nombre del archivo del logo UI
=cut
sub getNombreLogoUI{
    my $logosArrayRef = C4::Modelo::LogoUI::Manager->get_logoUI( limit => 1 );
    if(scalar(@$logosArrayRef) > 0){
        return $logosArrayRef->[0]->getImagenPath;
    }else{
        return ('logo_ui_opac_menu.png');
    }
}
=item
    Devuelve el path del archivo del logo UI
=cut
sub getPathLogoUI{
    my $logosArrayRef = C4::Modelo::LogoUI::Manager->get_logoUI( limit => 1 );
    if(scalar(@$logosArrayRef) > 0){
        return "https://" . $ENV{'SERVER_NAME'} . C4::Context->config('logosIntraPath') . $logosArrayRef->[0]->getImagenPath;
    }else{
        return "http://" . $ENV{'SERVER_NAME'} . "/images/logo_horizontal.png";
    }
}
=item
    Devuelve el path del archivo del logo de etiquetas
=cut
sub getPathLogoEtiquetas{
    my $logosArrayRef = C4::Modelo::LogoEtiquetas::Manager->get_logoEtiquetas( limit => 1 );
    if(scalar(@$logosArrayRef) > 0){
        return C4::Context->config('logosIntraPath') . "/" . $logosArrayRef->[0]->getImagenPath;
    }else{
        return (0);
    }
}

=item
    Devuelve el path del archivo del logo de etiquetas, el anterior devuelve el nombre del archivo
=cut
sub getOnlyPathLogoEtiquetas {
    return C4::Context->config('logosIntraPath') . "/";
}
=item
    Devuelve el tamaño del archivo del logo de etiquetas
=cut
sub getSizeLogoEtiquetas{
    my $logosArrayRef = C4::Modelo::LogoEtiquetas::Manager->get_logoEtiquetas( limit => 1 );
    if(scalar(@$logosArrayRef) > 0){
        return ($logosArrayRef->[0]->getAncho, $logosArrayRef->[0]->getAlto);
    }else{
        return (0,0);
    }
}
sub eliminarLogo{
    my ($params)    = @_;
    
    my $msg_object  = C4::AR::Mensajes::create();
    eval {
        my $logo        = getLogoById($params->{'idLogo'});
        
        my $uploaddir;
        if($params->{'context'} eq "opac"){
            $uploaddir       = C4::Context->config('logosOpacPath');
        }else{
            $uploaddir       = C4::Context->config('logosIntraPath');
        }
        
        if ($logo){
        
            my $image_name = $logo->getImagenPath();
            unlink($uploaddir."/".$image_name);
            $logo->delete();
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP15',} ) ;
        }
    };
 
     if ($@){
         #Se loguea error de Base de Datos
         &C4::AR::Mensajes::printErrorDB($@, 'B462','INTRA');
         #Se setea error para el usuario
         $msg_object->{'error'}= 1;
         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP14', 'params' => []} ) ;
     }
            
    return ($msg_object);
    
}
sub eliminarLogoUI{
    my ($params)    = @_;
    my $msg_object  = C4::AR::Mensajes::create();
    eval {
        my $logo        = getLogoByIdUI($params->{'idLogo'});
        
        my $uploaddir   = C4::Context->config('opachtdocs') . '/temas/' 
                        . C4::AR::Preferencias::getValorPreferencia('tema_opac_default') 
                        . '/imagenes';
        
        if ($logo){
        
            my $image_name = $logo->getImagenPath();
            unlink($uploaddir."/".$image_name);
            $logo->delete();
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP15',} ) ;
        }
    };
 
     if ($@){
         #Se loguea error de Base de Datos
         &C4::AR::Mensajes::printErrorDB($@, 'B462','INTRA');
         #Se setea error para el usuario
         $msg_object->{'error'}= 1;
         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP14', 'params' => []} ) ;
     }
            
    return ($msg_object);
    
}

sub deleteLogos{
    my ($db)        = @_;
    
    my $logos       = C4::Modelo::LogoEtiquetas::Manager->get_logoEtiquetas(db => $db);
    my $uploaddir   = C4::Context->config('logosIntraPath');
    foreach my $logo (@$logos){
        my $image_name = $logo->getImagenPath();
        unlink($uploaddir."/".$image_name);
        C4::AR::Debug::debug("vamos a borrar un logo " . $logo->getNombre);
        $logo->delete();
    }
}
sub modificarLogo{
    my ($params)    = @_;
    my $msg_object  = C4::AR::Mensajes::create();
    my $logo = getLogoById($params->{'idLogo'});
    if (C4::AR::Utilidades::validateString($params->{'alto'})){
        $logo->setAlto($params->{'alto'});
    }
    
    if (C4::AR::Utilidades::validateString($params->{'ancho'})){
        $logo->setAncho($params->{'ancho'});
    }
    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP08', 'params' => ['512 KB']} ) ;
    $logo->save();
    return ($msg_object);
    
}
sub agregarLogoUI{
    my ($params,$postdata) = @_;
    my $logo        = C4::Modelo::LogoUI->new();
    my $msg_object  = C4::AR::Mensajes::create();
    my $db          = $logo->db;
    $db->{connect_options}->{AutoCommit} = 0;
    $db->begin_work;
    eval{
        my $code = C4::AR::Preferencias::getValorPreferencia('defaultUI').'-UI';
        
        $logo->setNombre( $code);
        
        
        my ($image,$msg_object) = uploadLogoUI($postdata, $code, $params->{'context'},$msg_object);
        
        $logo->setImagenPath($image);
        
        if (!$msg_object->{'error'}){
            $logo->save();
            $msg_object->{'error'} = 0;
            $db->commit;
        }
    
    };
    if ($@){
        # TODO falta definir el mensaje "amigable" para el usuario informando que no se pudo agregar el proveedor
       &C4::AR::Mensajes::printErrorDB($@, 'B461',"INTRA");
       $msg_object->{'error'}= 1;
       C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP16', 'params' => []} ) ;
       $db->rollback;
    }
    $db->{connect_options}->{AutoCommit} = 1;
    
    return ($msg_object);
    
}
sub agregarLogo{
    my ($params,$postdata) = @_;
    my $logo        = C4::Modelo::LogoEtiquetas->new();
    my $msg_object  = C4::AR::Mensajes::create();
    my $db          = $logo->db;
    $db->{connect_options}->{AutoCommit} = 0;
    $db->begin_work;
    eval{
        #borramos algun logo que este, para pisarlo con este nuevo
        deleteLogos($db);
        $logo->setNombre('logo_ui_opac_menu');
        
        # if (C4::AR::Utilidades::validateString($params->{'alto'})){
            # $logo->setAlto($params->{'alto'});
            $logo->setAlto('1');
        # }
        
        # if (C4::AR::Utilidades::validateString($params->{'ancho'})){
            # $logo->setAncho($params->{'ancho'});
            $logo->setAlto('1');
        # }
        
        my ($image,$msg_object) = uploadLogo($postdata,'logo_ui_opac_menu', $params->{'context'},$msg_object);
        
        $logo->setImagenPath($image);
        
        if (!$msg_object->{'error'}){
            $logo->save();
            $msg_object->{'error'} = 0;
            $db->commit;
        }
    };
    if ($@){
        # TODO falta definir el mensaje "amigable" para el usuario informando que no se pudo agregar el proveedor
       &C4::AR::Mensajes::printErrorDB($@, 'B461',"INTRA");
       $msg_object->{'error'}= 1;
       C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP16', 'params' => []} ) ;
       $db->rollback;
    }
    $db->{connect_options}->{AutoCommit} = 1;
    
    return ($msg_object);
    
}
sub uploadLogo{
    my ($query,$name,$context,$msg_object) = @_;
    
    my @filesAllowed    = qw(
                                jpeg
                                gif
                                png
                                jpg
                            );
    my $uploaddir       = C4::Context->config('logosIntraPath');
    
    my $maxFileSize     = 2048 * 2048; # 1/2mb max file size...
    
    #checkeamos con libmagic el tipo del archivo
    my ($type,$notBinary) = C4::AR::Utilidades::checkFileMagic($query, @filesAllowed);
      
    if (!$type) {
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP00', 'params' => ['jpg','png','gif','jpeg']} ) ;
    }
    
    if (!$msg_object->{'error'}){
        
            C4::AR::Debug::debug("UploadFile => uploadAdjuntoNovedadOpac => vamos a escribirla CON binmode");
            open ( WRITEIT, ">$uploaddir/$name.$type" ) or die "Cant write to $uploaddir/$name.$type. Reason: $!"; 
            binmode WRITEIT; 
            while ( <$query> ) { 
                print WRITEIT; 
            }
            close(WRITEIT);
    }
    
    if (!$msg_object->{'error'}){
        my $check_size = -s "$uploaddir/$name.$type";
    
        if ($check_size > $maxFileSize) {
             $msg_object->{'error'}= 1;
             C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP07', 'params' => ['512 KB']} ) ;
        } 
    }    
    
    if (!$msg_object->{'error'}){
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP08', 'params' => ['512 KB']} ) ;
    }
    
    return ($name.".".$type,$msg_object);
}
sub uploadLogoUI{
    my ($query,$name,$context,$msg_object) = @_;
    
    my @filesAllowed    = qw(
                                jpeg
                                gif
                                png
                                jpg
                            );
   # my $uploaddir;
   # if($context eq "opac"){
    #    $uploaddir       = C4::Context->config('logosOpacPath');
   #  }else{

    my     $uploaddir       = C4::Context->config('logosIntraPath');
    # }
    
    my $maxFileSize     = 2048 * 2048; # 1/2mb max file size...
    
    #checkeamos con libmagic el tipo del archivo
    my ($type,$notBinary) = C4::AR::Utilidades::checkFileMagic($query, @filesAllowed);
      
    if (!$type) {
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP00', 'params' => ['jpg','png','gif','jpeg']} ) ;
    }
    
    if (!$msg_object->{'error'}){
        if($notBinary){
        
            #no hay que escribirlo con binmode
            C4::AR::Debug::debug("UploadFile => uploadAdjuntoNovedadOpac => vamos a escribirla sin binmode");
            open(WRITEIT, ">$uploaddir/$name.$type") or die "Cant write to $uploaddir/$name.$type. Reason: $!";
            print WRITEIT $query;
            close(WRITEIT);
   
        }else{
        
            C4::AR::Debug::debug("UploadFile => uploadAdjuntoNovedadOpac => vamos a escribirla CON binmode");
            open ( WRITEIT, ">$uploaddir/$name.$type" ) or die "Cant write to $uploaddir/$name.$type. Reason: $!"; 
            binmode WRITEIT; 
            while ( <$query> ) { 
                print WRITEIT; 
            }
            close(WRITEIT);
        
        }
    }
    
    if (!$msg_object->{'error'}){
        my $check_size = -s "$uploaddir/$name.$type";
    
        if ($check_size > $maxFileSize) {
             $msg_object->{'error'}= 1;
             C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP07', 'params' => ['512 KB']} ) ;
        } 
    }    
    
    if (!$msg_object->{'error'}){
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP08', 'params' => ['512 KB']} ) ;
    }
    
    return ($name.".".$type,$msg_object);
}
sub getLogoById{
    
    my ($id) = @_;
    
    use C4::Modelo::LogoEtiquetas::Manager;
    
    my @filtros;
    
    push (@filtros, (id => {eq => $id}) );
    
    my $logo = C4::Modelo::LogoEtiquetas::Manager->get_logoEtiquetas( query => \@filtros,);
    
    return $logo->[0];
}
sub getLogoByIdUI{
    
    my ($id) = @_;
    
    use C4::Modelo::LogoUI::Manager;
    
    my @filtros;
    
    push (@filtros, (id => {eq => $id}) );
    
    my $logo = C4::Modelo::LogoUI::Manager->get_logoUI( query => \@filtros,);
    
    return $logo->[0];
}
sub listar{
    my $logos_array_ref = C4::Modelo::LogoEtiquetas::Manager->get_logoEtiquetas( limit   => 1,);
    my $logos_array_ref_count = C4::Modelo::LogoEtiquetas::Manager->get_logoEtiquetas_count();
    if(scalar(@$logos_array_ref) > 0){
        return ($logos_array_ref_count, $logos_array_ref);
    }else{
        return (0,0);
    }
}
sub listarUI{
    my $logos_array_ref = C4::Modelo::LogoUI::Manager->get_logoUI( limit   => 1,);
    my $logos_array_ref_count = C4::Modelo::LogoUI::Manager->get_logoUI_count();
    if(scalar(@$logos_array_ref) > 0){
        return ($logos_array_ref_count, $logos_array_ref);
    }else{
        return (0,0);
    }
}
1;
