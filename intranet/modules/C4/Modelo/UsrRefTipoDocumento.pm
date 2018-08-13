package C4::Modelo::UsrRefTipoDocumento;

use strict;
    
use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'usr_ref_tipo_documento',

    columns => [
        id                => { type => 'serial', overflow => 'truncate', not_null => 1 },
        nombre            => { type => 'varchar', overflow => 'truncate', length => 50, not_null => 1 },
        descripcion       => { type => 'varchar', overflow => 'truncate', length => 250, not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],
    unique_key => [ 'nombre' ],

);
use C4::Modelo::UsrRefTipoDocumento::Manager;
use C4::Modelo::RefEstado;
use String::Similarity;

sub toString{
    my ($self) = shift;

    return ($self->getDescripcion);
}

sub getId{
  my ($self) = shift;

  return ($self->id);
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
	my ($self)              = shift;
    my ($campo, $orden)     = @_;

    my @array_valores;
    my @fields  = ($campo, $orden);
    my $v       = $self->validate_fields(\@fields);

    if($v){

        my $ref_valores = C4::Modelo::UsrRefTipoDocumento::Manager->get_usr_ref_tipo_documento
                            ( select   => ['nombre',$campo],
                              sort_by => ($orden) );

        for(my $i=0; $i<scalar(@$ref_valores); $i++ ){
      
                my $valor;
                $valor->{"clave"}=$ref_valores->[$i]->getNombre;
                $valor->{"valor"}=$ref_valores->[$i]->getCampo($campo);
            push (@array_valores, $valor);
        }
    }
	
    return (scalar(@array_valores), \@array_valores);
}

sub obtenerValorCampo {
	my ($self)=shift;
    	my ($campo,$id)=@_;
 	my $ref_valores = C4::Modelo::UsrRefTipoDocumento::Manager->get_usr_ref_tipo_documento
						( select   => [$campo],
						  query =>[ descripcion => { eq => $id} ]);
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
    
	if ($campo eq "descripcion") {return $self->getDescripcion;}
	if ($campo eq "nombre") {return $self->getNombre;}

	return (0);
}


sub nextMember{
    return(C4::Modelo::RefEstado->new());
}

sub getAll{

    my ($self) = shift;
    my ($limit,$offset,$matchig_or_not,$filtro)=@_;
    $matchig_or_not = $matchig_or_not || 0;
    my @filtros;
    if ($filtro){
        my @filtros_or;
        push(@filtros_or, (nombre => {like => '%'.$filtro.'%'}) );
        push(@filtros_or, (descripcion => {like => '%'.$filtro.'%'}) );
        push(@filtros, (or => \@filtros_or) );
    }
    my $ref_valores;
    if ($matchig_or_not){ #ESTOY BUSCANDO SIMILARES, POR LO TANTO NO TENGO QUE LIMITAR PARA PERDER RESULTADOS
        push(@filtros, ($self->getPk => {ne => $self->getPkValue}) );
        $ref_valores = C4::Modelo::UsrRefTipoDocumento::Manager->get_usr_ref_tipo_documento(query => \@filtros,);
    }else{
        $ref_valores = C4::Modelo::UsrRefTipoDocumento::Manager->get_usr_ref_tipo_documento(query => \@filtros,
                                                                    limit => $limit, 
                                                                    offset => $offset, 
                                                                    sort_by => ['descripcion'] 
                                                                   );
    }
    my $ref_cant = C4::Modelo::UsrRefTipoDocumento::Manager->get_usr_ref_tipo_documento_count(query => \@filtros,);
    my $self_descripcion = $self->getDescripcion;

    if ($matchig_or_not){
        my @matched_array;
        my $similarity_level =  C4::AR::Preferencias::getValorPreferencia("similarity");
        if ($similarity_level){
            foreach my $each (@$ref_valores){
               my $similarity = similarity(lc($self_descripcion), lc($each->getDescripcion), $similarity_level);
              if ($similarity gt $similarity_level){
                my %table_data = {};
                $table_data{"similarity"} = $similarity;
                $table_data{"tabla_object"} = $each;
                push (@matched_array, \%table_data);
              }
            }
        }
        #Ordenampos por similaridad
        my @sorted_matched = sort { $b->{"similarity"} <=> $a->{"similarity"} } @matched_array;
        my @matched_array = map { $_->{"tabla_object"} } @sorted_matched;
        return (scalar(@matched_array),\@matched_array);
    }
    else{
      return($ref_cant,$ref_valores);
    }
}

1;

