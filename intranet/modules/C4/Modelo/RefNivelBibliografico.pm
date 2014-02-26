package C4::Modelo::RefNivelBibliografico;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'ref_nivel_bibliografico',

    columns => [
        id          => { type => 'serial', overflow => 'truncate', not_null => 1 },
        code        => { type => 'varchar', overflow => 'truncate', length => 4, not_null => 1 },
        description => { type => 'varchar', overflow => 'truncate', default => '', length => 255, not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],
    unique_key => [ 'code' ],

);
use C4::Modelo::RefNivelBibliografico::Manager;
use C4::Modelo::CatTema;
use Text::LevenshteinXS;
    


sub toString{
	my ($self) = shift;

    return ($self->getDescription);
}    

sub getObjeto{
	my ($self) = shift;
	my ($id) = @_;

	my $objecto= C4::Modelo::RefNivelBibliografico->new(code => $id);
	$objecto->load();
	return $objecto;
}

sub getObjetoById{
    my ($self) = shift;
    my ($id) = @_;

    my $objecto= C4::Modelo::RefNivelBibliografico->new(id => $id);
    $objecto->load();
    return $objecto;
}


sub getId{
    my ($self) = shift;

    return (C4::AR::Utilidades::trim($self->id));
}

sub get_key_value{
    my ($self) = shift;
    return ($self->getCode);
}

sub getCode{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->code));
}
    
sub setCode{
    my ($self) = shift;
    my ($code) = @_;

    $self->code($code);
}

    
sub getDescription{
    my ($self) = shift;

    return (C4::AR::Utilidades::trim($self->description));
}
    
sub setDescription{
    my ($self) = shift;
    my ($description) = @_;

    $self->description($description);
}

sub obtenerValoresCampo {
    my ($self)              = shift;
    my ($campo,$orden)      = @_;

    my @array_valores;
    my @fields  = ($campo, $orden);
    my $v       = $self->validate_fields(\@fields);

    if($v){

        my $ref_valores = C4::Modelo::RefNivelBibliografico::Manager->get_ref_nivel_bibliografico
                            ( select   => ['code' , $campo],
                              sort_by => ($orden) );

        for(my $i=0; $i<scalar(@$ref_valores); $i++ ){
            my $valor;
            $valor->{"clave"}=$ref_valores->[$i]->getCode;
            $valor->{"valor"}=$ref_valores->[$i]->getCampo($campo);
            push (@array_valores, $valor);
        }
    }
	
    return (scalar(@array_valores), \@array_valores);
}

sub obtenerValorCampo {
	my ($self)=shift;
    my ($campo,$id)=@_;
    my $ref_valores = C4::Modelo::RefNivelBibliografico::Manager->get_ref_nivel_bibliografico
						( select   => [$campo],
						  query =>[ code => { eq => $id} ]);
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
    
	if ($campo eq "code") {return $self->getCode;}
	if ($campo eq "description") {return $self->getDescription;}

	return (0);
}


sub nextMember{
    return(C4::Modelo::CatTema->new());
}

sub getAll{

    my ($self) = shift;
    my ($limit,$offset,$matchig_or_not,$filtro)=@_;
    $matchig_or_not = $matchig_or_not || 0;
    my @filtros;
    if ($filtro){
        my @filtros_or;
        push(@filtros_or, (code => {like => '%'.$filtro.'%'}) );
        push(@filtros_or, (description => {like => '%'.$filtro.'%'}) );
        push(@filtros, (or => \@filtros_or) );
    }
    my $ref_valores;
    if ($matchig_or_not){ #ESTOY BUSCANDO SIMILARES, POR LO TANTO NO TENGO QUE LIMITAR PARA PERDER RESULTADOS
        push(@filtros, ($self->getPk => {ne => $self->getPkValue}) );
        $ref_valores = C4::Modelo::RefNivelBibliografico::Manager->get_ref_nivel_bibliografico(query => \@filtros,);
    }else{
        $ref_valores = C4::Modelo::RefNivelBibliografico::Manager->get_ref_nivel_bibliografico(query => \@filtros,
                                                                    limit => $limit, 
                                                                    offset => $offset, 
                                                                    sort_by => ['description'] 
                                                                   );
    }
    my $ref_cant = C4::Modelo::RefNivelBibliografico::Manager->get_ref_nivel_bibliografico_count(query => \@filtros,);
    return($ref_cant,$ref_valores);
}

1;

