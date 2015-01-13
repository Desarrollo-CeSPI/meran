package C4::AR::Novedades;

use strict;
use HTML::Entities;
require Exporter;
use C4::Modelo::SysNovedad;
use C4::Modelo::SysNovedad::Manager;
use C4::Modelo::SysNovedadNoMostrar;
use C4::Modelo::SysNovedadNoMostrar::Manager;

use vars qw(@EXPORT @ISA);
@ISA=qw(Exporter);
@EXPORT=qw( 
    getNovedadesNoMostrar
    getUltimasNovedades
    getNovedad
    listar
    agregar
    getNovedadesByFecha
    getPortadaOpac
    addPortadaOpac
    modPortadaOpac
    ordenPortadaOpac
);


sub agregar{

    my ($parametros)= @_;
    my $novedad     = C4::Modelo::SysNovedad->new();
    my $msg_object  = C4::AR::Mensajes::create();
    my $db          = $novedad->db;
    my $image_name;
    
    my $datosNovedad = $parametros->{'datosNovedad'};
    my $paramAdjunto = $parametros->{'adjunto'};
    my $arrFiles     = $parametros->{'arrayFiles'};
    
    use C4::AR::UploadFile;
    use C4::Modelo::ImagenesNovedadesOpac;
   
    my $imagenes_novedades_opac;   
    
    eval{


        #agregamos primero la novedad
        #para sacarle el id despues
        $novedad->agregar($datosNovedad);
        
        my $adjuntoName = 0;
        
        if($paramAdjunto){
            $adjuntoName = C4::AR::UploadFile::uploadAdjuntoNovedadOpac($paramAdjunto);
        
            if(!$adjuntoName){
                $msg_object->{'error'}= 1;
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP13', 'intra'} );
            }else{
                $novedad->setAdjunto($adjuntoName);
                
            }
        }

        $novedad->save();
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'NOV00', 'intra'} );
        
        #recorremos todas las imagenes y las guardamos      
        foreach my  $value (@$arrFiles) {
        
            $image_name = C4::AR::UploadFile::uploadFotoNovedadOpac($value);
            
            if(!$image_name){
                $msg_object->{'error'}= 1;
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP13', 'intra'} );
            }else{
                $imagenes_novedades_opac = C4::Modelo::ImagenesNovedadesOpac->new(db => $db);                 
                $imagenes_novedades_opac->saveImagenNovedad($image_name, $novedad->getId());    
                $msg_object->{'error'}= 0;
            }

        }
        
    };

    if ($@){
    C4::AR::Debug::debug("ERROR  : " . $@);
       $msg_object->{'error'}= 1;
       C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP12', 'intra'} ) ;
       
    }
     
    return ($msg_object, $novedad);

}


sub editar{

    my ($input, $arrayNewFiles, $arrayDeleteImages) = @_;
    
    my $msg_object  = C4::AR::Mensajes::create();

    #novedad
    my $novedad     = getNovedad($input->param('novedad_id'));

    $novedad->setTitulo($input->param('titulo'));  
    $novedad->setContenido($input->param('contenido'));
    $novedad->setCategoria($input->param('categoria'));
    $novedad->setLinks($input->param('links'));
    $novedad->setNombreAdjunto($input->param('nombreAdjunto'));

    my $paramAdjunto = $input->upload('adjunto');

    if($paramAdjunto){
        my $adjuntoName = C4::AR::UploadFile::uploadAdjuntoNovedadOpac($paramAdjunto);
    
        if(!$adjuntoName){
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP13', 'intra'} );
        }else{
            $novedad->setAdjunto($adjuntoName);
        }
    }
    
    $novedad->save();
    #fin novedad
    

    #imagenes a borrar
    eval{
    
        my $dirPath = C4::Context->config("novedadesOpacPath");
        
        if(scalar(@$arrayDeleteImages)){   

            foreach my $file ( @$arrayDeleteImages ){
            
                C4::AR::Debug::debug("imagen a eliminar : " . $file);
                
                _eliminarImageneNovedadByNombre($file);
                unlink($dirPath."/".$file);
            }
            
        }
    };
    if ($@){
        
           $msg_object->{'error'}= 1;
           C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP14', 'intra'} ) ;
           
    }
    #fin imagenes a borrar
    
    #nuevas imagenes
    eval{
    
        my $image_name;
        my $imagenes_novedades_opac;
        #recorremos todas las imagenes a agregar y las guardamos   
        
        if(scalar(@$arrayNewFiles)){      
        
            foreach my  $value ( @$arrayNewFiles ) {
                     
                #pasarle la data necesaria
                $image_name = C4::AR::UploadFile::uploadFotoNovedadOpac($value);
                
                if(!$image_name){
                    $msg_object->{'error'}= 1;
                    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP13', 'intra'} );

                }else{
                    $imagenes_novedades_opac = C4::Modelo::ImagenesNovedadesOpac->new();                 
                    $imagenes_novedades_opac->saveImagenNovedad($image_name, $input->param('novedad_id'));     
                    $msg_object->{'error'}= 0;
                }
            } 
        }
    };
    if ($@){
        
           $msg_object->{'error'}= 1;
           C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP12', 'intra'} ) ;
           
    }
    #fin nuevas imagenes

    return ($msg_object);
}


sub listar{
    my ($ini,$cantR) = @_;
    my $novedades_array_ref = C4::Modelo::SysNovedad::Manager->get_sys_novedad( 
                                                                                sort_by => ['id DESC'],
                                                                                limit   => $cantR,
                                                                                offset  => $ini,
                                                                              );

    my $novedades_array_ref_count = C4::Modelo::SysNovedad::Manager->get_sys_novedad_count();
    if(scalar(@$novedades_array_ref) > 0){
        return ($novedades_array_ref_count, $novedades_array_ref);
    }else{
        return (0,0);
    }
}

=item
    Esta funcion obtiene las novedades que no hay que mostrarle al socio recibido como parametro
=cut
sub getNovedadesNoMostrar{

    my ($nro_socio) = @_;
    
    my @filtros;
    
    push (@filtros, (usuario_novedad => {eq => $nro_socio}) );

    my $novedades_array_ref = C4::Modelo::SysNovedadNoMostrar::Manager->get_sys_novedad_no_mostrar( query => \@filtros,
                                                                              );
    if(scalar(@$novedades_array_ref) > 0){
        return (scalar(@$novedades_array_ref),$novedades_array_ref);
    }else{
        return (0,0);
    }
}

=item
    Esta funcion "elimina" la novedad recibida como parametro, la agrega a la tabla para no motrarla mas al user
=cut
sub noMostrarNovedad{

    my ($id_novedad) = @_;
    my %params;
    $params{'id_novedad'} = $id_novedad;
    
    my $novedad_no_borrar = C4::Modelo::SysNovedadNoMostrar->new();
    
    $novedad_no_borrar->agregar(%params);
    
    return "ok";
}

sub getUltimasNovedades{
    my ($limit) = @_;
    
    my $pref_limite = $limit || C4::AR::Preferencias::getValorPreferencia('limite_novedades');

    my $novedades_array_ref = C4::Modelo::SysNovedad::Manager->get_sys_novedad( 
                                                                                sort_by => ['id DESC'],
                                                                                limit   => $pref_limite,
                                                                              );

    #Obtengo la cant total de sys_novedads para el paginador
    my $novedades_array_ref_count = C4::Modelo::SysNovedad::Manager->get_sys_novedad_count();
    if(scalar(@$novedades_array_ref) > 0){
    	if ($limit == 1){
            return ($novedades_array_ref_count, $novedades_array_ref->[0]);
    	}else{
            return ($novedades_array_ref_count, $novedades_array_ref);
    	}
    }else{
        return (0,0);
    }
}

sub getNovedad{

    my ($id_novedad) = @_;
    my @filtros;

    push (@filtros, (id => {eq => $id_novedad}) );
    
    my $novedades_array_ref = C4::Modelo::SysNovedad::Manager->get_sys_novedad( query => \@filtros,
                                                                              );

    if(scalar(@$novedades_array_ref) > 0){
        return ($novedades_array_ref->[0]);
    }else{
        return (0);
    }
}


=item
    Trae las imagenes (si las hay) apartir de un id_novedad
=cut
sub getImagenesNovedad{

    my ($id_novedad) = @_;
    my @filtros;

    use C4::Modelo::ImagenesNovedadesOpac;
    use C4::Modelo::ImagenesNovedadesOpac::Manager;
    
    push (@filtros, (id_novedad => {eq => $id_novedad}) );
    
    my $novedades_array_ref = C4::Modelo::ImagenesNovedadesOpac::Manager->get_imagenes_novedades_opac( query => \@filtros,
                                                                              );

    if(scalar(@$novedades_array_ref) > 0){
        return ($novedades_array_ref, scalar(@$novedades_array_ref));
    }else{
        return (0,0);
    }
    
}

=item
    Elimina la imagen recibida como parametro (nombre)
=cut
sub _eliminarImageneNovedadByNombre{

    my ($image_name) = @_;
    my @filtros;
    #viene vacio aveces, por la hash que pasamos desde editar_novedad.pl
    if($image_name){

        use C4::Modelo::ImagenesNovedadesOpac;
        use C4::Modelo::ImagenesNovedadesOpac::Manager;
        
        push (@filtros, (image_name => {eq => $image_name}) );
        
        my $novedades_array_ref = C4::Modelo::ImagenesNovedadesOpac::Manager->get_imagenes_novedades_opac( query => \@filtros,
                                                                                  );

        if(scalar(@$novedades_array_ref) > 0){
        
            $novedades_array_ref->[0]->delete();
            
        }else{
            return (0);
        }
    
    }
    
}

=item
    Elimina las imagenes (si las hay) apartir de un id_novedad de la base
=cut
sub _eliminarImagenesNovedad{

    my ($id_novedad) = @_;
    my @filtros;

    use C4::Modelo::ImagenesNovedadesOpac;
    use C4::Modelo::ImagenesNovedadesOpac::Manager;
    
    push (@filtros, (id_novedad => {eq => $id_novedad}) );
    
    my $novedades_array_ref = C4::Modelo::ImagenesNovedadesOpac::Manager->get_imagenes_novedades_opac( query => \@filtros,
                                                                              );

    if(scalar(@$novedades_array_ref) > 0){
    
        foreach my $imagen (@$novedades_array_ref){
            _eliminarArchivoImagenNovedad($imagen->getImageName());
            $imagen->delete();
        }
        
    }else{
        return (0);
    }
    
}

=item
    Elimina los archivos imagen de las novedades 
=cut
sub _eliminarArchivoImagenNovedad{

    my ($file_name) = @_;
    
    my $dirPath     = C4::Context->config("novedadesOpacPath");

    unlink($dirPath."/".$file_name);
    
}

=item
    Elimina una novedad completa
=cut
sub eliminar{

    my ($id_novedad) = @_;
    my @filtros;

    push (@filtros, (id => {eq => $id_novedad}) );
    
    my $novedades_array_ref = C4::Modelo::SysNovedad::Manager->get_sys_novedad( query => \@filtros,
                                                                              );

    if(scalar(@$novedades_array_ref) > 0){
        $novedades_array_ref->[0]->delete();
        _eliminarImagenesNovedad($id_novedad);
        
    }else{
        return (0);
    }
}

=item
    Trae las novedades ordenadas por fecha
=cut
sub getNovedadesByFecha{
    my ($ini,$cantR) = @_;

    my $novedades_array_ref = C4::Modelo::SysNovedad::Manager->get_sys_novedad( 
                                                                                sort_by => ['fecha DESC'],
                                                                                limit   => $cantR,
#                                                                                offset  => $ini,
                                                                              );

    #Obtengo la cant total de sys_novedads para el paginador
    my $novedades_array_ref_count = C4::Modelo::SysNovedad::Manager->get_sys_novedad_count();
    if(scalar(@$novedades_array_ref) > 0){
        return ($novedades_array_ref_count, $novedades_array_ref);
    }else{
        return (0,0);
    }
}


sub getPortadaOpac{
	
	use C4::Modelo::PortadaOpac::Manager;
	
	my @filtros;
	
	my $portada = C4::Modelo::PortadaOpac::Manager->get_portada_opac( sort_by => ['orden ASC']);
	
	return $portada;
}

sub getCantPortadaOpac{
    
    use C4::Modelo::PortadaOpac::Manager;
    
    my @filtros;
    
    my $portada = C4::Modelo::PortadaOpac::Manager->get_portada_opac_count();
    
    return $portada;
}

sub addPortadaOpac{
	my ($params,$postdata) = @_;
	
	my $portada = C4::Modelo::PortadaOpac->new();
	
	if (C4::AR::Utilidades::validateString($params->{'footer'})){
		$portada->setFooter($params->{'footer'});
		$portada->setFooterTitle($params->{'footer_title'});
	}
	
	my ($image,$msg) = uploadCoverImage($postdata);
	
	$portada->setImagePath($image);
	
	if (!$msg->{'error'}){
	   $portada->save();
	}
	
	return ($msg);
	
}

sub modPortadaOpac{
    my ($params) = @_;
    
    my $msg_object  = C4::AR::Mensajes::create();
    
    
    
    eval{
	    my $portada = getPortadaOpacById($params->{'id_portada'});
	
	    if (C4::AR::Utilidades::validateString($params->{'footer'})){
	        $portada->setFooter($params->{'footer'});
	        $portada->setFooterTitle($params->{'footer_title'});
	    }
	    
	    $portada->save();
    };
    
    
    if ($@){
    	$msg_object->{'error'} = 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP11', 'params' => []} ) ;
    }else{
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP10', 'params' => []} ) ;
    }
      
    return ($msg_object);
    
}



sub getPortadaOpacById{
    
    my ($id) = @_;
    
    use C4::Modelo::PortadaOpac::Manager;
    
    my @filtros;
    
    push (@filtros, (id => {eq => $id}) );
    
    my $portada = C4::Modelo::PortadaOpac::Manager->get_portada_opac( query => \@filtros,);
    
    return $portada->[0];
}


sub delPortadaOpac{
    my ($id) = @_;
    
    my $msg_object  = C4::AR::Mensajes::create();

    my $portada = getPortadaOpacById($id);
    
    my $uploaddir       = C4::Context->config("opac_path")."/portada";
    
    if ($portada){
	    my $image_name = $portada->getImagePath();
	    unlink($uploaddir."/".$image_name);
	    $portada->delete();
	    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP09', 'params' => ['jpg','png','gif']} ) ;
    }
            
    return ($msg_object);
    
}

sub ordenPortadaOpac{
    my ($params) = @_;
    
    use C4::Modelo::PortadaOpac::Manager;
    
    my $order_array = $params->{'newOrderArray'};
    
    my $orden = 1;
    foreach my $p (@$order_array){

    	 my $portada = getPortadaOpacById($p);
    	 $portada->setOrden($orden++);
    	 
    	 $portada->save();
    }
    return ();
	
}

sub uploadCoverImage{
    my ($postdata) = @_;

    use Digest::MD5;
    
    my $uploaddir       = C4::Context->config("opac_path")."/uploads/portada";
    my $maxFileSize     = 1024 * 1024; # 1/2mb max file size...
    my $file            = $postdata;
    my $type            = "";
    my $msg_object  = C4::AR::Mensajes::create();

    my $new_name        = Digest::MD5::md5_hex(localtime());
    
    if ($file =~ /^GIF/i) {
        $type = "gif";
    } elsif ($file =~ /PNG/i) {
        $type = "png";
    } elsif ($file =~ /JFIF/i) {
        $type = "jpg";
    } else {
        $type = "jpg";
    }


    if (!$type) {
         $msg_object->{'error'}= 1;
         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP00', 'params' => ['jpg','png','gif']} ) ;
    }

    
    if (!$msg_object->{'error'}){
    	eval{
		    open ( WRITEIT, ">$uploaddir/$new_name.$type" ) or die "$!"; 
		    binmode WRITEIT; 
		    while ( <$postdata> ) { 
		    	print WRITEIT; 
		    }
		    close(WRITEIT);
    	};
    	if ($@){
	         $msg_object->{'error'}= 1;
	         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP01',} ) ;
    	}
    }
    
    if (!$msg_object->{'error'}){
	    my $check_size = -s "$uploaddir/$new_name.$type";
	
	    if ($check_size > $maxFileSize) {
	         $msg_object->{'error'}= 1;
             C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP07', 'params' => ["512KB"]} ) ;
	    } 
    }    
    
    if (!$msg_object->{'error'}){
    	C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'UP08', 'params' => ['512KB']} ) ;
    }
    
    return ($new_name.".".$type,$msg_object);

}


1;
