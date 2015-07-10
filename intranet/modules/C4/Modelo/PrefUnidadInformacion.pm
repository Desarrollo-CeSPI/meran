package C4::Modelo::PrefUnidadInformacion;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'pref_unidad_informacion',

    columns => [
        id                  => { type => 'serial', overflow => 'truncate'},
        id_ui               => { type => 'varchar', overflow => 'truncate', not_null => 1 , length => 4},
        nombre              => { type => 'varchar', overflow => 'truncate', not_null => 1 , length => 255},
        nombre_largo        => { type => 'varchar', overflow => 'truncate', not_null => 1 , length => 255},
        ciudad              => { type => 'varchar', overflow => 'truncate', not_null => 1 , length => 255, default => "La Plata"},
        titulo_formal       => { type => 'varchar', overflow => 'truncate', not_null => 1 , length => 255, default => "Universidad Nacional de La Plata"},
        direccion           => { type => 'varchar', overflow => 'truncate', not_null => 1 , length => 255},
        alt_direccion       => { type => 'varchar', overflow => 'truncate', not_null => 1 , length => 255},
        telefono            => { type => 'varchar', overflow => 'truncate', not_null => 1 , length => 255},
        url_servidor        => { type => 'varchar', overflow => 'truncate', not_null => 1 , length => 255},
        fax                 => { type => 'varchar', overflow => 'truncate', not_null => 1 , length => 255},
        email               => { type => 'varchar', overflow => 'truncate', not_null => 1 , length => 255},
    ],

    primary_key_columns => [ 'id' ],

    unique_key => [ 'id_ui' ],
); 

use C4::Modelo::RefIdioma;
use C4::Modelo::PrefUnidadInformacion::Manager;
use Text::LevenshteinXS;
    
sub toString{
    my ($self) = shift;

    return ($self->getNombre);
}

sub get_key_value{
    my ($self) = shift;
    
    return ($self->getId_ui);
}

sub getId_ui{
    my ($self) = shift;

    return ($self->id_ui);
} 

sub getId{
    my ($self) = shift;

    return ($self->id);
}  

sub setId_ui{
    my ($self) = shift;
    my ($id_ui) = @_;
    return ($self->id_ui($id_ui));
}  

sub getCiudad{
    my ($self) = shift;

    return ($self->ciudad);
}  


sub setCiudad{
    my ($self) = shift;
    my ($ciudad_name) = @_;
    return ($self->ciudad($ciudad_name));
}  

sub getTituloFormal{
    my ($self) = shift;

    return ($self->titulo_formal);
}  

sub getTituloFormalPDF{
    my ($self) = shift;

    return (C4::AR::Utilidades::trim(Encode::decode_utf8($self->getTituloFormal)));
}

sub setTituloFormal{
    my ($self) = shift;
    my ($titulo_formal) = @_;
    return ($self->titulo_formal($titulo_formal));
} 

sub getNombrePDF{
    my ($self) = shift;

    return (C4::AR::Utilidades::trim(Encode::decode_utf8($self->nombre)));
}

sub getNombre{
    my ($self) = shift;

    return (C4::AR::Utilidades::trim($self->nombre));
}
    
sub setNombre{
    my ($self) = shift;
    my ($nombre) = @_;
    $nombre = Encode::encode_utf8($nombre);
    $self->nombre($nombre);
}

sub getNombreLargo{
    my ($self) = shift;

    return (C4::AR::Utilidades::trim($self->nombre_largo));
}

sub getNombreLargoPDF{
    my ($self) = shift;

    return (C4::AR::Utilidades::trim(Encode::decode_utf8($self->nombre_largo)));
} 

sub setNombreLargo{
    my ($self) = shift;
    my ($nombre) = @_;
    $nombre = Encode::encode_utf8($nombre);
    $self->nombre_largo($nombre);
} 

sub getDireccionPDF{
    my ($self) = shift;

    return (C4::AR::Utilidades::trim(Encode::decode_utf8($self->getDireccion)));
}


sub getDireccion{
    my ($self) = shift;

    return (C4::AR::Utilidades::trim($self->direccion));
} 
    
sub setDireccion{
    my ($self) = shift;
    my ($direccion) = @_;

    $self->direccion($direccion);
}
    
sub getAlt_direccion{
    my ($self) = shift;

    return (C4::AR::Utilidades::trim($self->alt_direccion));
}
    
sub setAlt_direccion{
    my ($self) = shift;
    my ($alt_direccion) = @_;

    $self->alt_direccion($alt_direccion);
}
    
sub getTelefono{
    my ($self) = shift;

    return (C4::AR::Utilidades::trim($self->telefono));
}
    
sub setTelefono{
    my ($self) = shift;
    my ($telefono) = @_;

    $self->telefono($telefono);
}
   
sub getFax{
    my ($self) = shift;

    return (C4::AR::Utilidades::trim($self->fax));
}
      

sub setFax{
    my ($self) = shift;
    my ($fax) = @_;

    $self->fax($fax);
}

   
sub getUrlServidor{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->url_servidor));
}

sub setUrlServidor{
    my ($self) = shift;
    my ($url_servidor) = @_;

    $self->url_servidor($url_servidor);
}
    
sub getEmail{
    my ($self) = shift;

    return (C4::AR::Utilidades::trim($self->email));
}
    
sub setEmail{
    my ($self) = shift;
    my ($email) = @_;

    $self->email($email);
}

sub getByCode {
    my ($self)      = shift;
    my ($ui_code)   = @_;

    my @filtros;
    push(@filtros, (id_ui => {eq => $ui_code}) );
    
    my $ui = C4::Modelo::PrefUnidadInformacion::Manager->get_pref_unidad_informacion(query => \@filtros);

    if(scalar($ui) > 0){
        return $ui->[0];
    } else {
        return 0;
    }
}

sub agregar{

    my ($self)=shift;
    my ($data_hash)=@_;
    
    $self->setNombre($data_hash->{'nombre'});
    $self->setNombreLargo($data_hash->{'nombre_largo'});
    $self->setDireccion($data_hash->{'direccion'});
    $self->setAlt_direccion($data_hash->{'alt_direccion'});
    $self->setTelefono($data_hash->{'telefono'});
    $self->setFax($data_hash->{'fax'});
    $self->setEmail($data_hash->{'email'});

    $self->save();
}

sub getSiglasTituloFormal{
    my ($self)=shift;

    my @titulo_formal_array = split(/ /,$self->getTituloFormal());
    my $siglas = "";
    
    foreach my $word (@titulo_formal_array){
        $word = uc $word;
        $siglas .= substr ($word,0,1);	
    }
    
    return ($siglas);
}

sub nextMember{
    return(C4::Modelo::RefIdioma->new());
}

sub obtenerValoresCampo {
    my ($self)              = shift;
    my ($campo,$orden)      = @_;

    my @array_valores;
    my @fields  = ($campo, $orden);
    my $v       = $self->validate_fields(\@fields);

    if($v){

        my $ref_valores = C4::Modelo::PrefUnidadInformacion::Manager->get_pref_unidad_informacion
                            ( select   => ['id_ui' , $campo],
                              sort_by => ($orden) );

        for(my $i=0; $i<scalar(@$ref_valores); $i++ ){
            my $valor;
            $valor->{"clave"}=$ref_valores->[$i]->getId_ui;
            $valor->{"valor"}=$ref_valores->[$i]->getCampo($campo);
            push (@array_valores, $valor);
        }
    }
	
    return (scalar(@array_valores), \@array_valores);
}


sub obtenerValorCampo {
	my ($self) = shift;
    my ($campo,$id) = @_;
 	my $ref_valores = C4::Modelo::PrefUnidadInformacion::Manager->get_pref_unidad_informacion
						( select   => [$campo],
						  query =>[ id_ui => { eq => $id} ]);
    	
# 	return ($ref_valores->[0]->getCampo($campo));
  if(scalar(@$ref_valores) > 0){
    return ($ref_valores->[0]->getCampo($campo));
  }else{
    #no se pudo recuperar el objeto por el id pasado por parametro
    return undef;
  }
}


sub getCampo{
    my ($self) = shift;
	my ($campo)=@_;
    
	if ($campo eq "id_ui") {return $self->getId_ui;}
	if ($campo eq "nombre") {return $self->getNombre;}
  if ($campo eq "nombre_largo") {return $self->getNombreLargo;}
	if ($campo eq "direccion") {return $self->getDireccion;}
	if ($campo eq "alt_direccion") {return $self->getAlt_direccion;}
	if ($campo eq "telefono") {return $self->getTelefono;}
	if ($campo eq "fax") {return $self->getFax;}
	if ($campo eq "email") {return $self->getEmail;}

	return (0);
}

sub tieneLogoOpacMenu{
	my ($self) = shift;

    use C4::AR::Logos;
	
	my $tema_opac   = C4::AR::Preferencias::getValorPreferencia('tema_opac_default') || $self->getId_ui;
    my $logo = C4::Context->config('logosIntraPath') . '/' . C4::AR::Logos::getNombreLogoUI();

    if ( -e $logo ){
    	return 1;
    }else{
    	return 0;
    }
}

sub getAll{

    my ($self) = shift;
    my ($limit,$offset,$matchig_or_not,$filtro)=@_;
    $matchig_or_not = $matchig_or_not || 0;
    my @filtros;

    if ($filtro){
        my @filtros_or;
        push(@filtros_or, (nombre => {like => '%'.$filtro.'%'}) );
        push(@filtros, (or => \@filtros_or) );
    }
    my $ref_valores;
    if ($matchig_or_not){ #ESTOY BUSCANDO SIMILARES, POR LO TANTO NO TENGO QUE LIMITAR PARA PERDER RESULTADOS
        push(@filtros, ($self->getPk => {ne => $self->getPkValue}) );
        $ref_valores = C4::Modelo::PrefUnidadInformacion::Manager->get_pref_unidad_informacion(query => \@filtros,);
    }else{
        $ref_valores = C4::Modelo::PrefUnidadInformacion::Manager->get_pref_unidad_informacion(query => \@filtros,
                                                                    limit => $limit, 
                                                                    offset => $offset, 
                                                                    sort_by => ['nombre'] 
                                                                   );
    }
    my $ref_cant = C4::Modelo::PrefUnidadInformacion::Manager->get_pref_unidad_informacion_count(query => \@filtros,);
    my $self_nombre = $self->getNombre;
    my $self_id_ui = $self->getId_ui;

    my $match = 0;
    if ($matchig_or_not){
        my @matched_array;
        foreach my $autor (@$ref_valores){
          $match = ((distance($self_nombre,$autor->getNombre)<=1) or (distance($self_id_ui,$autor->getId_ui)<=1));
          if ($match){
            push (@matched_array,$autor);
          }
        }
        return (scalar(@matched_array),\@matched_array);
    }
    else{
      return($ref_cant,$ref_valores);
    }
}

1;

