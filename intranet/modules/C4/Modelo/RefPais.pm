package C4::Modelo::RefPais;

use strict;
   

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'ref_pais',

    columns => [
        id           => { type => 'serial', overflow => 'truncate', not_null => 1 },
        iso          => { type => 'character', overflow => 'truncate', length => 2, not_null => 1 },
        iso3         => { type => 'character', overflow => 'truncate', default => '', length => 3, not_null => 1 },
        nombre       => { type => 'varchar', overflow => 'truncate', length => 80, not_null => 1 },
        nombre_largo => { type => 'varchar', overflow => 'truncate', length => 80, not_null => 1 },
        codigo       => { type => 'varchar', overflow => 'truncate', length => 11, not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],
    unique_key => [ 'iso' ],

);
use C4::Modelo::RefDisponibilidad;
use C4::Modelo::RefPais::Manager;
use Text::LevenshteinXS;

sub get_key_value{
    my ($self) = shift;
    
    return ($self->getIso);
}

sub toString{
	my ($self) = shift;

    return ($self->getIso);
}    

sub getObjeto{
	my ($self) = shift;
	my ($id) = @_;

	my $objecto= C4::Modelo::RefPais->new(codigo => $id);
	$objecto->load();
	return $objecto;
}


sub getIso{
    my ($self) = shift;

    return (C4::AR::Utilidades::trim($self->iso));
}
    
sub setIso{
    my ($self) = shift;
    my ($iso) = @_;
    $self->iso($iso);
}

sub getIso3{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->iso3));
}
    
sub setIso3{
    my ($self) = shift;
    my ($iso3) = @_;
    $self->iso3($iso3);
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

sub getNombre_largo{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->nombre_largo));
}
    
sub setNombre_largo{
    my ($self) = shift;
    my ($nombre) = @_;
    $self->nombre_largo($nombre);
}

sub getCodigo{
    my ($self) = shift;
    return C4::AR::Utilidades::trim(($self->codigo));
}
    
sub setCodigo{
    my ($self) = shift;
    my ($codigo) = @_;
    $self->codigo($codigo);
}

sub obtenerValoresCampo {
    my ($self)              = shift;
    my ($campo,$orden)      = @_;

    my @array_valores;
    my @fields  = ($campo, $orden);
    my $v       = $self->validate_fields(\@fields);

    if($v){

        my $ref_valores = C4::Modelo::RefPais::Manager->get_ref_pais
                              ( select   => ['iso' , $campo],
                                sort_by => ($orden) );

        for(my $i=0; $i<scalar(@$ref_valores); $i++ ){
              my $valor;
              $valor->{"clave"}=$ref_valores->[$i]->getIso;
              $valor->{"valor"}=$ref_valores->[$i]->getCampo($campo);
          push (@array_valores, $valor);
        }
    }
	
    return (scalar(@array_valores), \@array_valores);
}

sub obtenerValorCampo {
	my ($self)=shift;
   	my ($campo,$id)=@_;
 	my $ref_valores = C4::Modelo::RefPais::Manager->get_ref_pais
						( select   => [$campo],
						  query =>[ iso => { eq => $id} ]);
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
    
	if ($campo eq "iso") {return $self->getIso;}
	if ($campo eq "iso3") {return $self->getIso3;}
	if ($campo eq "nombre") {return $self->getNombre;}
	if ($campo eq "nombre_largo") {return $self->getNombre_largo;}
	if ($campo eq "codigo") {return $self->getCodigo;}
	return (0);
}


sub nextMember{
    return(C4::Modelo::RefDisponibilidad->new());
}

sub getAll{

    my ($self) = shift;
    my ($limit,$offset,$matchig_or_not,$filtro)=@_;
    $matchig_or_not = $matchig_or_not || 0;
    my @filtros;
    if ($filtro){
        my @filtros_or;
        push(@filtros_or, (iso => {eq => $filtro}) );
        push(@filtros_or, (iso3 => {eq => $filtro}) );
        
        if ($matchig_or_not){
            push(@filtros_or, (nombre => {like => '%'.$filtro.'%'}) );
            push(@filtros_or, (nombre_largo => {like => '%'.$filtro.'%'}) );
        }else{
            push(@filtros_or, (nombre => {eq => $filtro}) );
            push(@filtros_or, (nombre_largo => {eq => $filtro}) );
            }
        
        push(@filtros, (or => \@filtros_or) );
    }
    my $ref_valores;
    if ($matchig_or_not){ #ESTOY BUSCANDO SIMILARES, POR LO TANTO NO TENGO QUE LIMITAR PARA PERDER RESULTADOS
        push(@filtros, ($self->getPk => {ne => $self->getPkValue}) );
        $ref_valores = C4::Modelo::RefPais::Manager->get_ref_pais(query => \@filtros,);
    }else{
        $ref_valores = C4::Modelo::RefPais::Manager->get_ref_pais(query => \@filtros,
                                                                    limit => $limit, 
                                                                    offset => $offset, 
                                                                    sort_by => ['nombre','nombre_largo'] 
                                                                   );
    }
    my $ref_cant = C4::Modelo::RefPais::Manager->get_ref_pais_count(query => \@filtros,);
    my $self_nombre = $self->getNombre;
    my $self_nombre_largo = $self->getNombre_largo;

    my $match = 0;
    if ($matchig_or_not){
        my @matched_array;
        foreach my $each (@$ref_valores){
          $match = ((distance($self_nombre,$each->getNombre)<=1) or (distance($self_nombre_largo,$each->getNombre_largo)<=1));
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


=head2
    sub getPaisByIso
=cut
sub getPaisByIso{
    my ($self) = shift;
    my ($pais) = @_;

    my @filtros;
    my @filtros_or;
    push(@filtros_or, (iso => {eq => $pais}) );
    push(@filtros_or, (iso3 => {eq => $pais}) );
    push(@filtros, (or => \@filtros_or) );


    my $paises_array_ref = C4::Modelo::RefPais::Manager->get_ref_pais(

        query   => \@filtros,
        select  => ['*'],
        sort_by => 'nombre_largo ASC',
        limit   => 1,
        offset  => 0,
    );

    return (scalar(@$paises_array_ref), $paises_array_ref);


}

=head2
    sub getPaisByName
=cut
sub getPaisByName{
    my ($self) = shift;
    my ($pais) = @_;

    my @filtros;
    my @filtros_or;
    push(@filtros_or, (nombre => {eq => $pais}) );
    push(@filtros_or, (nombre_largo => {eq => $pais}) );
    push(@filtros, (or => \@filtros_or) );


    my $paises_array_ref = C4::Modelo::RefPais::Manager->get_ref_pais(

        query   => \@filtros,
        select  => ['*'],
        sort_by => 'nombre_largo ASC',
        limit   => 1,
        offset  => 0,
    );

    return (scalar(@$paises_array_ref), $paises_array_ref);


}

1;
