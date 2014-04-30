package C4::Modelo::RefLocalidad;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'ref_localidad',


    columns => [
        id                    => { type => 'serial', overflow => 'truncate', not_null => 1 },
        LOCALIDAD             => { type => 'varchar', overflow => 'truncate', length => 11, not_null => 1 },
        NOMBRE                => { type => 'varchar', overflow => 'truncate', length => 100 },
        NOMBRE_ABREVIADO      => { type => 'varchar', overflow => 'truncate', length => 40 },
        ref_dpto_partido_id   => { type => 'varchar', overflow => 'truncate', length => 11 },
        DDN                   => { type => 'varchar', overflow => 'truncate', length => 11 },
    ],

    primary_key_columns => [ 'id' ],
    unique_key => [ 'LOCALIDAD' ],
);

use C4::Modelo::CatPerfilOpac;
use C4::Modelo::RefLocalidad::Manager;
use Text::LevenshteinXS;

sub toString{
	my ($self) = shift;

    return ($self->getNombre);
}    

sub getObjeto{
	my ($self) = shift;
	my ($id) = @_;

	my $objecto= C4::Modelo::RefLocalidad->new(id => $id);
	$objecto->load();
	return $objecto;
}


sub getId{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->id));
}

sub getIdLocalidad{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->id));
}

sub setNombre{
    my ($self) = shift;
     my ($nombre)=@_;
     $self->NOMBRE($nombre);
}

sub getNombre{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->NOMBRE));
}

sub getNombre_abreviado{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->NOMBRE_ABREVIADO));
}


sub obtenerValoresCampo {
    my ($self)=shift;
    my ($campo,$orden)=@_;
	my $ref_valores = C4::Modelo::RefLocalidad::Manager->get_ref_localidad
						( select   => ['id' , $campo],
						  sort_by => ($orden) );
    my @array_valores;

    for(my $i=0; $i<scalar(@$ref_valores); $i++ ){
		my $valor;
		$valor->{"clave"}=$ref_valores->[$i]->getIdLocalidad;
		$valor->{"valor"}=$ref_valores->[$i]->getCampo($campo);
        push (@array_valores, $valor);
    }
	
    return (scalar(@array_valores), \@array_valores);
}

sub obtenerValorCampo {
	my ($self)=shift;
    my ($campo,$id)=@_;
 	my $ref_valores = C4::Modelo::RefLocalidad::Manager->get_ref_localidad
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
    
	if ($campo eq "LOCALIDAD") {return $self->getIdLocalidad;}
	if ($campo eq "NOMBRE") {return $self->getNombre;}
	if ($campo eq "NOMBRE_ABREVIADO") {return $self->getNombre_abreviado;}
	return (0);
}


sub nextMember{
    return(C4::Modelo::CatPerfilOpac->new());
}

sub getAll{

    my ($self) = shift;
    my ($limit,$offset,$matchig_or_not,$filtro)=@_;
    $matchig_or_not = $matchig_or_not || 0;
    my @filtros;

    if ($filtro){
        my @filtros_or;
        if ($matchig_or_not){
            push(@filtros_or, (NOMBRE => {like => '%'.$filtro.'%'}) );
            push(@filtros_or, (NOMBRE_ABREVIADO => {like => '%'.$filtro.'%'}) );
        }else{
            push(@filtros_or, (NOMBRE => {eq => $filtro}) );
            push(@filtros_or, (NOMBRE_ABREVIADO => {eq => $filtro}) );
        }
        push(@filtros, (or => \@filtros_or) );
    }
    my $ref_valores;
    if ($matchig_or_not){ #ESTOY BUSCANDO SIMILARES, POR LO TANTO NO TENGO QUE LIMITAR PARA PERDER RESULTADOS
        push(@filtros, ($self->getPk => {ne => $self->getPkValue}) );
        $ref_valores = C4::Modelo::RefLocalidad::Manager->get_ref_localidad(query => \@filtros,);
    }else{
        $ref_valores = C4::Modelo::RefLocalidad::Manager->get_ref_localidad(query => \@filtros,
                                                                    limit => $limit, 
                                                                    offset => $offset, 
                                                                    sort_by => ['nombre'] 
                                                                   );
    }
    my $ref_cant = C4::Modelo::RefLocalidad::Manager->get_ref_localidad_count(query => \@filtros,);
    my $self_nombre = $self->getNombre;
    my $self_nombre_abreviado = $self->getNombre_abreviado;

    my $match = 0;
    if ($matchig_or_not){
        my @matched_array;
        foreach my $each (@$ref_valores){
          $match = ((distance($self_nombre,$each->getNombre)<=2) || (distance($self_nombre_abreviado,$each->getNombre_abreviado)<=2));
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


sub getLocalidadByName{
    my ($self) = shift;
    my ($ciudad) = @_;

    my @filtros;
    my @filtros_or;
    push(@filtros_or, (NOMBRE => {eq => $ciudad}) );
    push(@filtros_or, (NOMBRE_ABREVIADO => {eq => $ciudad}) );
    push(@filtros, (or => \@filtros_or) );


    my $ciudades_array_ref = C4::Modelo::RefLocalidad::Manager->get_ref_pais(

        query   => \@filtros,
        select  => ['*'],
        sort_by => 'id ASC',
        limit   => 1,
        offset  => 0,
    );

    return (scalar(@$ciudades_array_ref), $ciudades_array_ref);


}

1;
