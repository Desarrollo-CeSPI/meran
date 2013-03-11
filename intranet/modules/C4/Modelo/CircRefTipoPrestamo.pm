package C4::Modelo::CircRefTipoPrestamo;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'circ_ref_tipo_prestamo',

    columns => [
        id     => { type => 'serial', overflow => 'truncate', not_null => 1 },
        id_tipo_prestamo    => { type => 'character', overflow => 'truncate', length => 4, not_null => 1 },
        descripcion  => { type => 'text', overflow => 'truncate', length => 65535 },
        codigo_disponibilidad   => { type => 'varchar', overflow => 'truncate', default => '', length => 8, not_null => 1 },
        prestamos    => { type => 'integer', overflow => 'truncate', default => '0', not_null => 1 },
        dias_prestamo   => { type => 'integer', overflow => 'truncate', default => '0', not_null => 1 },
        renovaciones        => { type => 'integer', overflow => 'truncate', default => '0', not_null => 1 },
        dias_renovacion    => { type => 'integer', overflow => 'truncate', default => '0', not_null => 1 },
        dias_antes_renovacion => { type => 'integer', overflow => 'truncate', default => '0', not_null => 1 },
        habilitado      => { type => 'integer', overflow => 'truncate', default => 1 },
    ],

    primary_key_columns => [ 'id' ],
    unique_key => [ 'id_tipo_prestamo' ],

	relationships => [
	    disponibilidad => {
            class      => 'C4::Modelo::RefDisponibilidad',
            column_map => { codigo_disponibilidad => 'codigo' },
            type       => 'one to one',
        },
    ],
);
use C4::Modelo::CircRefTipoPrestamo::Manager;
use C4::Modelo::RefSoporte;
use Text::LevenshteinXS;

sub toString{
    my ($self) = shift;

    return ($self->getDescripcion);
}

sub getId_tipo_prestamo{
    my ($self) = shift;
    return ($self->id_tipo_prestamo);
}
    
sub setId_tipo_prestamo{
    my ($self) = shift;
    my ($id_tipo_prestamo) = @_;
    $self->id_tipo_prestamo($id_tipo_prestamo);
}

sub getDescripcion{
    my ($self) = shift;

    return ($self->descripcion);
}
    
sub setDescripcion{
    my ($self) = shift;
    my ($descripcion) = @_;

    $self->descripcion($descripcion);
}

sub getCodigo_disponibilidad{
    my ($self) = shift;

    return ($self->codigo_disponibilidad);
}
    
sub setCodigo_disponibilidad{
    my ($self) = shift;
    my ($disponibilidad) = @_;

    $self->codigo_disponibilidad($disponibilidad);
}

sub getPrestamos{
    my ($self) = shift;
    return ($self->prestamos);
}
    
sub setPrestamos{
    my ($self) = shift;
    my ($prestamos) = @_;
    $self->prestamos($prestamos);
}

sub getDias_prestamo{
    my ($self) = shift;
    return ($self->dias_prestamo);
}
    
sub setDias_prestamo{
    my ($self) = shift;
    my ($dias_prestamo) = @_;
    $self->dias_prestamo($dias_prestamo);
}


sub getRenovaciones{
    my ($self) = shift;
    return ($self->renovaciones);
}
    
sub setRenovaciones{
    my ($self) = shift;
    my ($renovaciones) = @_;
    $self->renovaciones($renovaciones);
}


sub getDias_renovacion{
    my ($self) = shift;
    return ($self->dias_renovacion);
}
    
sub setDias_renovacion{
    my ($self) = shift;
    my ($dias_renovacion) = @_;
    $self->dias_renovacion($dias_renovacion);
}

sub getDias_antes_renovacion{
    my ($self) = shift;
    return ($self->dias_antes_renovacion);
}
    
sub setDias_antes_renovacion{
    my ($self) = shift;
    my ($dias_antes_renovacion) = @_;
    $self->dias_antes_renovacion($dias_antes_renovacion);
}

sub getHabilitado{
    my ($self) = shift;
    return ($self->habilitado);
}
    
sub setHabilitado{
    my ($self) = shift;
    my ($habilitado) = @_;
    $self->habilitado($habilitado);
}

sub obtenerValoresCampo {
    my ($self)              = shift;
    my ($campo,$orden)      = @_;

    my @array_valores;
    my @fields  = ($campo, $orden);
    my $v       = $self->validate_fields(\@fields);

    if($v){

        my $ref_valores = C4::Modelo::CircRefTipoPrestamo::Manager->get_circ_ref_tipo_prestamo
                            ( select  => ['id_tipo_prestamo' ,$campo],
                              sort_by => ($orden) );

        for(my $i=0; $i<scalar(@$ref_valores); $i++ ){
            my $valor;
            $valor->{"clave"}=$ref_valores->[$i]->getId_tipo_prestamo;
            $valor->{"valor"}=$ref_valores->[$i]->getCampo($campo);
            push (@array_valores, $valor);
        }
    }
	
    return (scalar(@array_valores), \@array_valores);
}

sub obtenerValorCampo {
	my ($self)=shift;
    my ($campo,$id)=@_;
 	my $ref_valores = C4::Modelo::CircRefTipoPrestamo::Manager->get_circ_ref_tipo_prestamo
						( select   => [$campo],
						  query =>[ id_tipo_prestamo => { eq => $id} ]);
    	
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

	if ($campo eq "id_tipo_prestamo") {return $self->getId_tipo_prestamo;}
	if ($campo eq "descripcion") {return $self->getDescripcion;}
	if ($campo eq "codigo_disponibilidad") {return $self->getCodigo_disponibilidad;}
	if ($campo eq "prestamos") {return $self->getPrestamos;}
	if ($campo eq "dias_prestamo") {return $self->getDias_prestamo;}
	if ($campo eq "renovaciones") {return $self->getRenovaciones;}
	if ($campo eq "dias_renovacion") {return $self->getDias_renovacion;}
	if ($campo eq "dias_antes_renovacion") {return $self->getDias_antes_renovacion;}
	if ($campo eq "habilitado") {return $self->getHabilitado;}

	return (0);
}

sub nextMember{
    return(C4::Modelo::RefSoporte->new());
}


=item
modificar
Funcion que modificar un tipo de prestamo
=cut

sub modificar {
    my ($self)=shift;
    my ($data_hash)=@_;
    #Asignando data...

    $self->setId_tipo_prestamo($data_hash->{'id_tipo_prestamo'});
    $self->setDescripcion($data_hash->{'descripcion'});

    if($data_hash->{'disponibilidad'} eq '0'){ $data_hash->{'disponibilidad'}='CIRC0000'; }
    elsif($data_hash->{'disponibilidad'} eq '1'){$data_hash->{'disponibilidad'}='CIRC0001';}

    $self->setCodigo_disponibilidad($data_hash->{'disponibilidad'});
    $self->setPrestamos($data_hash->{'prestamos'});
    $self->setDias_prestamo($data_hash->{'dias_prestamo'});
    $self->setRenovaciones($data_hash->{'renovaciones'});
    $self->setDias_renovacion($data_hash->{'dias_renovacion'});
    $self->setDias_antes_renovacion($data_hash->{'dias_antes_renovacion'});
    $self->setHabilitado($data_hash->{'habilitado'});
    $self->save();

}

sub getAll{

    my ($self) = shift;
    my ($limit,$offset,$matchig_or_not,$filtro)=@_;
    $matchig_or_not = $matchig_or_not || 0;
    my @filtros;
    if ($filtro){
        my @filtros_or;
        push(@filtros_or, (id_tipo_prestamo => {like => '%'.$filtro.'%'}) );
        push(@filtros_or, (descripcion => {like => '%'.$filtro.'%'}) );
        push(@filtros, (or => \@filtros_or) );
    }
    my $ref_valores;
    if ($matchig_or_not){ #ESTOY BUSCANDO SIMILARES, POR LO TANTO NO TENGO QUE LIMITAR PARA PERDER RESULTADOS
        push(@filtros, ($self->getPk => {ne => $self->getPkValue}) );
        $ref_valores = C4::Modelo::CircRefTipoPrestamo::Manager->get_circ_ref_tipo_prestamo(query => \@filtros,);
    }else{
        $ref_valores = C4::Modelo::CircRefTipoPrestamo::Manager->get_circ_ref_tipo_prestamo(query => \@filtros,
                                                                    limit => $limit, 
                                                                    offset => $offset, 
                                                                    sort_by => ['descripcion'] 
                                                                   );
    }
    my $ref_cant = C4::Modelo::CircRefTipoPrestamo::Manager->get_circ_ref_tipo_prestamo_count(query => \@filtros,);
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

