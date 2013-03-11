package C4::AR::PortadasRegistros;


use strict;
require Exporter;

use C4::Context;
use HTTP::Request;
use LWP::UserAgent;
use C4::AR::Busquedas;
use Image::Size;

use vars qw(@EXPORT @ISA);
@ISA=qw(Exporter);
@EXPORT=qw(	
	        &getImageByIsbn 
		&getImageForId1 
		&getImageForId2 
		&getLargeImage 
		&insertCover
		&getAllImages
		);


sub getPortadaByIsbn {
    my ($isbn) = @_;

    use C4::Modelo::CatPortadaRegistro;
    use C4::Modelo::CatPortadaRegistro::Manager;

    my @filtros;
    push(@filtros, ( isbn    => { eq => $isbn}));

   my $portada_array_ref = C4::Modelo::CatPortadaRegistro::Manager->get_cat_portada_registro( query => \@filtros);

    if (scalar(@$portada_array_ref)){
        return $portada_array_ref->[0];
    }else{
        return 0;
    }
}

sub insertCover {
    my ($isbn,$url,$size)=@_;

    my $portada = C4::AR::PortadasRegistros::getPortadaByIsbn($isbn);

    if (!$portada) {#NO existe, hay que agregarlo
        $portada = C4::Modelo::CatPortadaRegistro->new();
        $portada->setIsbn($isbn);
    }

	if ($size eq 'S') {$portada->setSmall($url);}
	    elsif ($size eq 'M'){$portada->setMedium($url);}	
            else {$portada->setLarge($url);}

    $portada->save;
}

sub getAllImagesByIsbn {
    my ($isbn)=@_;
    C4::AR::PortadasRegistros::getImageByIsbn($isbn,'S');
    C4::AR::PortadasRegistros::getImageByIsbn($isbn,'M');
    C4::AR::PortadasRegistros::getImageByIsbn($isbn,'L');
}

sub getImageByIsbn {
    my ($isbn,$size)=@_;
    my $url = "";
    my $path = C4::Context->config("covers"); #Donde se guardan las imagenes
    my $file = "";
    my $msg = '';
# FIXME MONOOOOOOOOO esto esta matando la maquina!!!!!!!!!! Se hace 1 vez por dia o semana chee!!

    my $portada = C4::AR::PortadasRegistros::getPortadaByIsbn($isbn);

    if (($portada)&&($size eq 'S')) {$url=$portada->getSmall;}
    elsif (($portada)&&($size eq 'M')) {$url=$portada->getMedium;}
        elsif (($portada)&&($size eq 'L')) {$url=$portada->getLarge;}


	if (-d $path) {
	#Existe el path de las portadas?
	
    if ($url eq ''){
	#Si no existe en la base la busco.
	
        my $isbnaux=$isbn;
        #Realiza la Busqueda
        $isbnaux =~ s/-//g; # Quito los - para buscar
        $isbnaux =~ s/ //g; # Quito los blancos para buscar        
		#Archivo a guardar
        $file= $isbnaux."-".$size.".jpg";

		my @urls=();
		
		#PRIMERO SE BUSCA EN: http://openlibrary.org/
        #Armo la URL --> http://covers.openlibrary.org/b/$key/$value-$size.jpg
        $url= "http://covers.openlibrary.org/b/isbn/".$file."?default=false";
		push (@urls, $url);
		
		#SEGUNDO SE BUSCA EN: http://www.librarything.com/
        #Armo la URL --> http://covers.librarything.com/devkey/KEY/$size/isbn/$isbnaux
        
        if (C4::AR::Preferencias::getValorPreferencia('library_thing_key')){
			#Esta la KEY configurada?
			my $cover_size='medium';
			if 	($size eq 'S') {$cover_size='small';}
			elsif ($size eq 'M') {$cover_size='medium';}
			elsif ($size eq 'L') {$cover_size='large';}
			
			my $key = C4::AR::Preferencias::getValorPreferencia('library_thing_key');
			$url= "http://covers.librarything.com/devkey/".$key."/".$cover_size."/isbn/".$isbnaux;
			push (@urls, $url);
		}
		
		foreach my $url (@urls){
			
			C4::AR::Debug::debug( "Obteniendo : ".$url);
			my $request = HTTP::Request->new(GET => $url);
			my $ua = LWP::UserAgent->new;
			my $response = $ua->request($request);
			if ($response->is_success) {
				my $buffer = $response->content;
		
	 		    my ($width, $height) = imgsize(\$buffer);
	 		     
	 		    C4::AR::Debug::debug($width." X ".$height);
	 		    
				if ((length($buffer) != 0) && !($width <= 32 && $height <= 32)) { 
					#Devuelve algo vacío?
					if (!open(WFD,">$path/$file")) {
						C4::AR::Debug::debug( "Hay un error y el archivo no puede escribirse en el servidor.");
					}
					else {
						binmode WFD;
						print WFD $buffer;
						close(WFD);
						C4::AR::PortadasRegistros::insertCover ($isbn,$file,$size);
						return $file;
					}
				}
				else{
					C4::AR::Debug::debug("Devolvió una imagen vacía");
					}
			}
			else{
			C4::AR::Debug::debug( $response->status_line);
        }
		}
	}
}else{
	C4::AR::Debug::debug( "No existe el directorio de portadas:".$path );
	}
return $url;
}

sub getImageForId1 {
  my ($id1,$size) = @_;
  my $url='';
  
  my $isbn = C4::AR::Nivel2::getISBNById1($id1);
  
  if ($isbn) {
    my $portada = getPortadaByIsbn($isbn);
    
        if (($portada)&&($size eq 'S')) {$url=$portada->getSmall;}
        elsif (($portada)&&($size eq 'M')) {$url=$portada->getMedium;}
            elsif (($portada)&&($size eq 'L')) {$url=$portada->getLarge;}
  }

  return $url;
}

sub getAllImageForId1 {
    my ($id1)           = @_;
    
    my %result;
    my $isbn            = C4::AR::Nivel2::getISBNById1($id1);
    
    if ($isbn) {
        my $portada     = getPortadaByIsbn($isbn);
    
        if($portada){    
            $result{'S'}    = $portada->getSmall();
            $result{'M'}    = $portada->getMedium();
            $result{'L'}    = $portada->getLarge();
        } else {
            $result{'S'}    = '';
            $result{'M'}    = '';
            $result{'L'}    = '';
        }
    }
    
    return \%result;
}

sub getImageForId2 {
    my ($id2,$size)     = @_;

    my $url             = '';
    my $isbn            = C4::AR::Nivel2::getISBNById2($id2);

        if ($isbn ne ''){
            my $portada = getPortadaByIsbn($isbn);
    
            if (($portada)&&($size eq 'S')) {$url=$portada->getSmall;}
            elsif (($portada)&&($size eq 'M')) {$url=$portada->getMedium;}
                elsif (($portada)&&($size eq 'L')) {$url=$portada->getLarge;}
        }

    return $url;
}

sub getAllImageForId2 {
    my ($id2,$size)     = @_;
    
    my %result;
    my $isbn            = C4::AR::Nivel2::getISBNById2($id2);

    if ($isbn) {
        my $portada     = getPortadaByIsbn($isbn);

        if($portada){    
            $result{'S'}    = $portada->getSmall();
            $result{'M'}    = $portada->getMedium();
            $result{'L'}    = $portada->getLarge();
        } else {
            $result{'S'}    = '';
            $result{'M'}    = '';
            $result{'L'}    = '';
        }
    }
    
    return \%result;
}


#esto tarda hay que hacerlo cada cierto tiempo!!!
sub getAllImages {

#Busco solo los que tienen ISBN

    open (L,">>/tmp/covers");

    my $repetibles_array_ref = C4::AR::Busquedas::buscarTodosLosDatosFromNivel2ByCampoSubcampo("020","a");

    foreach my $dato (@$repetibles_array_ref)
	{
	printf L "Bajando  ISBN: ".$dato."  \n";

	my $urlsmall= getImageByIsbn($dato,'S');
	printf L "Url Small: ".$urlsmall."  \n";

	my $urlmedium= getImageByIsbn($dato,'M');
	printf L "Url Medium: ".$urlmedium."  \n";

	my $urllarge= getImageByIsbn($dato,'L');
	printf L "Url Large: ".$urllarge."  \n";
	}

close L;
}

END { }       # module clean-up code here (global destructor)

1;
__END__
