package C4::Modelo::CatEditorial;

use strict;
use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'cat_editorial',

    columns => [
        id          => { type => 'serial', overflow => 'truncate', not_null => 1 },
        editorial   => { type => 'text', overflow => 'truncate', length => 255, not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],
);

use C4::Modelo::CatEditorial::Manager;
use Text::LevenshteinXS;

sub toString{
	my ($self) = shift;

    return ($self->getEditorial);
}    

sub getObjeto{
	my ($self) = shift;
	my ($id) = @_;

	my $objecto= C4::Modelo::CatEditorial->new(id => $id);
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

    
sub getEditorial{
    my ($self) = shift;

    return (C4::AR::Utilidades::trim($self->editorial));
}
    
sub setEditorial{
    my ($self) = shift;
    my ($editorial) = @_;

    $self->editorial($editorial);
}

sub obtenerValoresCampo {
    my ($self)              = shift;
    my ($campo,$orden)      = @_;

    my @array_valores;
    my @fields  = ($campo, $orden);
    my $v       = $self->validate_fields(\@fields);

    if($v){

        my $ref_valores = C4::Modelo::CatEditorial::Manager->get_cat_editorial
                            ( select   => [$self->meta->primary_key , $campo],
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
    my $ref_valores = C4::Modelo::CatEditorial::Manager->get_cat_editorial
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
	if ($campo eq "editorial") {return $self->getEditorial;}

	return (0);
}


sub nextMember{
    return(C4::Modelo::RefEstado->new());
}


sub getAll{

    my ($self) = shift;
    my ($limit,$offset,$matchig_or_not,$filtro)=@_;
    
    use C4::Modelo::CatEditorial::Manager;
    
    
    $matchig_or_not = $matchig_or_not || 0;
    my @filtros;
    if ($filtro){
        my @filtros_or;
        push(@filtros_or, (editorial => {like => $filtro.'%'}) );
        push(@filtros, (or => \@filtros_or) );
    }
    my $ref_valores;
    if ($matchig_or_not){ #ESTOY BUSCANDO SIMILARES, POR LO TANTO NO TENGO QUE LIMITAR PARA PERDER RESULTADOS
        push(@filtros, ($self->getPk => {ne => $self->getPkValue}) );
        $ref_valores = C4::Modelo::CatEditorial::Manager->get_cat_editorial(query => \@filtros,);
    }else{
        $ref_valores = C4::Modelo::CatEditorial::Manager->get_cat_editorial(query => \@filtros,
                                                                    limit => $limit, 
                                                                    offset => $offset, 
                                                                    sort_by => ['editorial'] 
                                                                   );
    }

    my $ref_cant = C4::Modelo::CatEditorial::Manager->get_cat_editorial_count(query => \@filtros,);
    my $self_editorial = $self->getEditorial;

    my $match = 0;
    if ($matchig_or_not){
        my @matched_array;
        foreach my $editorial (@$ref_valores){
          $match = ((distance($self_editorial,$editorial->getEditorial)<=1));
          if ($match){
            push (@matched_array,$editorial);
          }
        }
        return (scalar(@matched_array),\@matched_array);
    }
    else{
      return($ref_cant,$ref_valores);
    }
}

1;

