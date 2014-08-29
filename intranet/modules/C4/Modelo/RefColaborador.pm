package C4::Modelo::RefColaborador;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'ref_colaborador',

    columns => [
        id              => { type => 'serial', overflow => 'truncate', not_null => 1 },
        codigo          => { type => 'character', overflow => 'truncate',length => 10 ,not_null => 1 },
        descripcion     => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1 },
        abreviatura     => { type => 'character', overflow => 'truncate',length => 10 ,not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],
    unique_key => [ 'codigo' ],

);
use C4::Modelo::RefColaborador::Manager;
use C4::Modelo::PrefValorAutorizado;
use C4::Modelo::RefIdioma::Manager;
use Text::LevenshteinXS;


sub toString{
	my ($self) = shift;

    return ($self->getDescripcion);
}    

sub getObjeto{
	my ($self) = shift;
	my ($id) = @_;

	my $objecto= C4::Modelo::RefLocalidad->new(id => $id);
	$objecto->load();
	return $objecto;
}

    
sub getCodigo{
    my ($self) = shift;

    return (C4::AR::Utilidades::trim($self->codigo));
}
    
sub setCodigo{
    my ($self) = shift;
    my ($codigo) = @_;

    $self->codigo($codigo);
}
    
sub getAbreviatura{
    my ($self) = shift;

    return (C4::AR::Utilidades::trim($self->abreviatura));
}
    
sub setCodigo{
    my ($self) = shift;
    my ($abreviatura) = @_;

    $self->abreviatura($abreviatura);
}

    
sub getDescripcion{
    my ($self) = shift;

    return (C4::AR::Utilidades::trim($self->descripcion));
}
    
sub setDescripcion{
    my ($self) = shift;
    my ($descripcion) = @_;

    $self->descripcion($descripcion);
}

sub obtenerValoresCampo {
    my ($self)=shift;
    my ($campo,$orden)=@_;
	my $ref_valores = C4::Modelo::RefColaborador::Manager->get_ref_colaborador
						( select   => ['codigo', $campo],
						  sort_by => ($orden) );
    my @array_valores;

    for(my $i=0; $i<scalar(@$ref_valores); $i++ ){
		my $valor;
		$valor->{"clave"}=$ref_valores->[$i]->getCodigo;
		$valor->{"valor"}=$ref_valores->[$i]->getCampo($campo);
        push (@array_valores, $valor);
    }
	
    return (scalar(@array_valores), \@array_valores);
}

sub obtenerValorCampo {
	my ($self)=shift;
   	my ($campo,$id)=@_;
 	my $ref_valores = C4::Modelo::RefColaborador::Manager->get_ref_colaborador
						( select   => [$campo],
						  query =>[ codigo => { eq => $id} ]);
    	
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
    
	if ($campo eq "codigo") {return $self->getCodigo;}
	if ($campo eq "descripcion") {return $self->getDescripcion;}

	return (0);
}



sub nextMember{
    return(C4::Modelo::PrefValorAutorizado->new());
}


sub getAll{

    my ($self) = shift;
    my ($limit,$offset,$matchig_or_not,$filtro)=@_;
    $matchig_or_not = $matchig_or_not || 0;
    my @filtros;
    if ($filtro){
        my @filtros_or;
        push(@filtros_or, (descripcion => {like => '%'.$filtro.'%'}) );
        push(@filtros, (or => \@filtros_or) );
    }
    my $ref_valores;
    if ($matchig_or_not){ #ESTOY BUSCANDO SIMILARES, POR LO TANTO NO TENGO QUE LIMITAR PARA PERDER RESULTADOS
        push(@filtros, ($self->getPk => {ne => $self->getPkValue}) );
        $ref_valores = C4::Modelo::RefColaborador::Manager->get_ref_colaborador(query => \@filtros,);
    }else{
        $ref_valores = C4::Modelo::RefColaborador::Manager->get_ref_colaborador(query => \@filtros,
                                                                    limit => $limit, 
                                                                    offset => $offset, 
                                                                    sort_by => ['descripcion'] 
                                                                   );
    }
    my $ref_cant = C4::Modelo::RefColaborador::Manager->get_ref_colaborador_count(query => \@filtros,);
    my $self_descripcion = $self->getDescripcion;

    my $match = 0;
    if ($matchig_or_not){
        my @matched_array;
        foreach my $each (@$ref_valores){
          $match = ((distance($self_descripcion,$each->getDescripcion)<=1));
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

