package C4::Modelo::RefEstado;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'ref_estado',

    columns => [
        nombre => { type => 'varchar', overflow => 'truncate', default => '', length => 255, not_null => 1 },
        codigo => { type => 'varchar', overflow => 'truncate', default => '', length => 8, not_null => 1 },
    ],

    primary_key_columns => [ 'codigo' ],
    unique_key => [ 'nombre' ],
);
use C4::Modelo::RefLocalidad;
use C4::Modelo::RefEstado::Manager;
use Text::LevenshteinXS;

########## CODIGOS DE DISPONIBILIDAD #############
# Baja = STATE000
# Compartido = STATE001 
# Disponible = STATE002
# Ejemplar deteriorado = STATE003 
# En Encuadernación = STATE004
# Perdido = STATE005
# En etiquetado = STATE0006
# En impresiones = STATE007
# En procesos técnicos = STATE008
##################################################

sub toString{
    my ($self) = shift;

    return ($self->getNombre);
}

sub paraBajaValue{
    
    return ('STATE000');
}

sub estadoCompartidoValue{
    
    return ('STATE001');
}

sub estadoDisponibleValue{
    
    return ('STATE002');
}

sub getRefEstadoByCodigo{
    my ($codigo) = @_;
    
     my $ref_estado = C4::Modelo::RefEstado::Manager->get_ref_estado( 
                                                 query => [ codigo => { eq => $codigo } ],
                                     );

     if($ref_estado){
         return ($ref_estado->[0]);
     }else{
         return 0;
     }
    
}
sub disponibleValueSearch{   
    
    my $ref_disponibilidad = getRefEstadoByCodigo(estadoDisponibleValue());
    
    return ($ref_disponibilidad->getNombre);
    	
}

sub estadoDisponibleReferencia{
  return ('ref_estado@'.C4::Modelo::RefEstado::estadoDisponibleValue());
}


sub getCodigo{
    my ($self) = shift;

    return ($self->codigo);
}
    
sub setCodigo{
    my ($self) = shift;
    my ($codigo) = @_;

    $self->codigo($codigo);
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
    my ($campo,$orden)      = @_;

    my @array_valores;
    my @fields  = ($campo, $orden);
    my $v       = $self->validate_fields(\@fields);

    if($v){

        my $ref_valores = C4::Modelo::RefEstado::Manager->get_ref_estado
                            ( select => [ $self->getPk  , $campo],
                              sort_by => ($orden) );

        for(my $i=0; $i<scalar(@$ref_valores); $i++ ){
            my $valor;
            $valor->{"clave"}=$ref_valores->[$i]->getPkValue;
            $valor->{"valor"}=$ref_valores->[$i]->getCampo($campo);
            push (@array_valores, $valor);
        }
    }
	
    return (scalar(@array_valores), \@array_valores);
}

sub obtenerValorCampo {
	my ($self)=shift;
    my ($campo,$id)=@_;
    my $ref_valores = C4::Modelo::RefEstado::Manager->get_ref_estado
						( select   => [$campo],
						  query =>[ $self->getPk => { eq => $id} ]);
    	
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
    
	if ($campo eq "id") {return $self->getPkValue;}
	if ($campo eq "nombre") {return $self->getNombre;}

	return (0);
}

sub nextMember{
    return(C4::Modelo::RefLocalidad->new());
}

sub get_key_value{
    my ($self) = shift;
    return ($self->getCodigo);
}

sub getAll{

    my ($self) = shift;
    my ($limit,$offset,$matchig_or_not,$filtro)=@_;
    $matchig_or_not = $matchig_or_not || 0;
    my @filtros;

    if ($filtro){
        my @filtros_or;
        push(@filtros_or, (nombre => {like => '%'.$filtro.'%'}) );
        push(@filtros_or, ($self->getPk => {like => '%'.$filtro.'%'}) );
        push(@filtros, (or => \@filtros_or) );
    }
    my $ref_valores;

    if ($matchig_or_not){ #ESTOY BUSCANDO SIMILARES, POR LO TANTO NO TENGO QUE LIMITAR PARA PERDER RESULTADOS
        push(@filtros, ($self->getPk => {ne => $self->getPkValue}) );
        $ref_valores = C4::Modelo::RefEstado::Manager->get_ref_estado(query => \@filtros,);
    }else{
        $ref_valores = C4::Modelo::RefEstado::Manager->get_ref_estado(query => \@filtros,
                                                                    limit => $limit, 
                                                                    offset => $offset, 
                                                                    sort_by => ['nombre'] 
                                                                   );
    }
    my $ref_cant = C4::Modelo::RefEstado::Manager->get_ref_estado_count(query => \@filtros,);
    my $self_nombre = $self->getNombre;

    my $match = 0;
    if ($matchig_or_not){
        my @matched_array;
        foreach my $each (@$ref_valores){
            #SE DEBEN MOSTRAR TODOS
          $match = 1;
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

