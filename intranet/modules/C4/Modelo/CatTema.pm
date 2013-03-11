package C4::Modelo::CatTema;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'cat_tema',

    columns => [
        id     => { type => 'serial', overflow => 'truncate', not_null => 1 },
        nombre => { type => 'text', overflow => 'truncate', length => 65535, not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],
    unique_key => [ 'nombre' ],

);

use C4::Modelo::UsrRefCategoriaSocio;
use C4::Modelo::CatTema::Manager;
use Text::LevenshteinXS;
    
sub toString{
	my ($self) = shift;

    return ($self->getNombre);
}    

sub getObjeto{
	my ($self) = shift;
	my ($id) = @_;

	my $objecto= C4::Modelo::CatTema->new(id => $id);
	$objecto->load();
	return $objecto;
}


sub getId{
    my ($self) = shift;

    return ($self->id);
}
    
sub setId{
    my ($self) = shift;
    my ($id) = @_;

    $self->id($id);
}

    
sub getNombre{
    my ($self) = shift;

    return (C4::AR::Utilidades::trim($self->nombre));
}
    
sub setNombre{
    my ($self) = shift;
    my ($nombre) = @_;

    $self->nombre($nombre);
}

sub obtenerValoresCampo {
	my ($self)          = shift;
    my ($campo,$orden)  = @_;

    my @array_valores;
    my @fields  = ($campo, $orden);
    my $v       = $self->validate_fields(\@fields);

    if($v){

        my $ref_valores = C4::Modelo::CatTema::Manager->get_cat_tema
                            ( select  => [ $self->meta->primary_key ,$campo ],
                              sort_by => ($orden) );

        for(my $i=0; $i<scalar(@$ref_valores); $i++ ){
            my $valor;
            $valor->{"clave"}=$ref_valores->[$i]->getId;
            $valor->{"valor"}=$ref_valores->[$i]->getCampo($campo);
            push (@array_valores, $valor);
        }
    }
	
    return (scalar(@array_valores), \@array_valores);
}

sub obtenerValorCampo {
	my ($self)=shift;
    my ($campo,$id)=@_;
    my $ref_valores = C4::Modelo::CatTema::Manager->get_cat_tema
						( select   => [$campo],
						  query =>[ id => { eq => $id} ]);
    	
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
    
	if ($campo eq "id") {return $self->getId;}
	if ($campo eq "nombre") {return $self->getNombre;}

	return (0);
}


sub nextMember{
    return(C4::Modelo::UsrRefCategoriaSocio->new());
}

sub getAll{

    my ($self) = shift;
    my ($limit,$offset,$matchig_or_not,$filtro, $like_doble)=@_;
    $matchig_or_not = $matchig_or_not || 0;
    my @filtros;
    if ($filtro){
        my @filtros_or;
        if ( ($matchig_or_not) || ($like_doble) ){
            push(@filtros_or, (nombre => {like => '%'.$filtro.'%'}) );
        }
        else{
            push(@filtros_or, (nombre => {eq => $filtro }) );
            }
        push(@filtros, (or => \@filtros_or) );
    }
    my $ref_valores;
    if ($matchig_or_not){ #ESTOY BUSCANDO SIMILARES, POR LO TANTO NO TENGO QUE LIMITAR PARA PERDER RESULTADOS
        push(@filtros, ($self->getPk => {ne => $self->getPkValue}));
        $ref_valores = C4::Modelo::CatTema::Manager->get_cat_tema(query => \@filtros,);
    }else{
        $ref_valores = C4::Modelo::CatTema::Manager->get_cat_tema(query => \@filtros,
                                                                    limit => $limit, 
                                                                    offset => $offset, 
                                                                    sort_by => ['nombre'] 
                                                                   );
    }
    my $ref_cant = C4::Modelo::CatTema::Manager->get_cat_tema_count(query => \@filtros,);
    my $self_nombre = $self->getNombre;

    my $match = 0;
    if ($matchig_or_not){
        my @matched_array;
        foreach my $each (@$ref_valores){
          $match = ((distance($self_nombre,$each->getNombre)<=1));
          if ($match){
            push (@matched_array,$each);
          }
        }
        return (scalar(@matched_array),\@matched_array);
    }
    else{
      return($ref_cant,$ref_valores);
    }
}

1;

