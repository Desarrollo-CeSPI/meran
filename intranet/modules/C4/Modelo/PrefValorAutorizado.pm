package C4::Modelo::PrefValorAutorizado;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'pref_valor_autorizado',

    columns => [
        id               => { type => 'serial', overflow => 'truncate', not_null => 1 },
        category         => { type => 'character', overflow => 'truncate', default => '', length => 40, not_null => 1 },
        authorised_value => { type => 'character', overflow => 'truncate', default => '', length => 80, not_null => 1 },
        lib              => { type => 'character', overflow => 'truncate', length => 80 },
    ],

    primary_key_columns => [ 'id' ],
);

use C4::Modelo::RefIdioma::Manager;
use Text::LevenshteinXS;

sub lastTable{
    return(1);
}


sub getId{
    my ($self) = shift;
    return ($self->id);
}

sub getCategory{
    my ($self) = shift;
    return ($self->category);
}

sub setCategory{
    my ($self) = shift;
    my ($category) = @_;
    $self->category($category);
}

sub getAuthorisedValue{
    my ($self) = shift;
    return ($self->authorised_value);
}

sub setAuthorisedValue{
    my ($self) = shift;
    my ($authorised_value) = @_;
    $self->authorised_value($authorised_value);
}

sub getLib{
    my ($self) = shift;
    return ($self->lib);
}

sub setLib{
    my ($self) = shift;
    my ($lib) = @_;
    $self->lib($lib);
}

sub agregar{
    my ($self)=shift;
    my ($data_hash)=@_;
    #Asignando data...
    $self->setCategory($data_hash->{'category'});
    $self->setAuthorisedValue($data_hash->{'authorised_value'});
    $self->setLib($data_hash->{'lib'});
    $self->save();
}



sub getAll{

    my ($self) = shift;
    my ($limit,$offset,$matchig_or_not,$filtro)=@_;
    $matchig_or_not = $matchig_or_not || 0;
    my @filtros;
    if ($filtro){
        my @filtros_or;
        push(@filtros_or, (category => {like => '%'.$filtro.'%'}) );
        push(@filtros, (or => \@filtros_or) );
    }
    my $ref_valores;
    if ($matchig_or_not){ #ESTOY BUSCANDO SIMILARES, POR LO TANTO NO TENGO QUE LIMITAR PARA PERDER RESULTADOS
        push(@filtros, ($self->getPk => {ne => $self->getPkValue}) );
        $ref_valores = C4::Modelo::PrefValorAutorizado::Manager->get_pref_valor_autorizado(query => \@filtros,);
    }else{
        $ref_valores = C4::Modelo::PrefValorAutorizado::Manager->get_pref_valor_autorizado(query => \@filtros,
                                                                    limit => $limit, 
                                                                    offset => $offset, 
                                                                    sort_by => ['category'] 
                                                                   );
    }
    my $ref_cant = C4::Modelo::PrefValorAutorizado::Manager->get_pref_valor_autorizado_count(query => \@filtros,);
    my $self_category = $self->getCategory;

    my $match = 0;
    if ($matchig_or_not){
        my @matched_array;
        foreach my $each (@$ref_valores){
          $match = ((distance($self_category,$each->getCategory)<=1));
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

