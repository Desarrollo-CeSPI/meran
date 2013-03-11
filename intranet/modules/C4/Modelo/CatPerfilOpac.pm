package C4::Modelo::CatPerfilOpac;

use strict;
use base qw(C4::Modelo::DB::Object::AutoBase2);
use utf8;

__PACKAGE__->meta->setup(
    table   => 'cat_perfil_opac',

    columns => [
        id           => { type => 'serial', overflow => 'truncate', not_null => 1 },
        nombre        => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],
);

use C4::Modelo::CatPerfilOpac::Manager;
use Text::LevenshteinXS;

sub getNombre{
    my ($self)=shift;

    return $self->nombre;
}

sub setNombre{
    my ($self) = shift;
    my ($string) = @_;
    utf8::encode($string);
    $self->nombre($string);
}

sub nextMember{
}


sub getAll{

    my ($self) = shift;
    my ($limit,$offset,$matchig_or_not,$filtro)=@_;
    $matchig_or_not = $matchig_or_not || 0;
    my @filtros;

    if ($filtro){
        my @filtros_or;
        push(@filtros_or, (NOMBRE => {like => '%'.$filtro.'%'}) );
        push(@filtros, (or => \@filtros_or) );
    }
    my $ref_valores;
    if ($matchig_or_not){ #ESTOY BUSCANDO SIMILARES, POR LO TANTO NO TENGO QUE LIMITAR PARA PERDER RESULTADOS
        push(@filtros, ($self->getPk => {ne => $self->getPkValue}) );
        $ref_valores = C4::Modelo::CatPerfilOpac::Manager->get_cat_perfil_opac(query => \@filtros,);
    }else{
        $ref_valores = C4::Modelo::CatPerfilOpac::Manager->get_cat_perfil_opac(query => \@filtros,
                                                                    limit => $limit, 
                                                                    offset => $offset, 
                                                                    sort_by => ['nombre'] 
                                                                   );
    }
    my $ref_cant = C4::Modelo::CatPerfilOpac::Manager->get_cat_perfil_opac_count(query => \@filtros,);
    my $self_nombre = $self->getNombre;

    my $match = 0;
    if ($matchig_or_not){
        my @matched_array;
        foreach my $each (@$ref_valores){
          $match = ( (distance($self_nombre,$each->getNombre)<=1) );
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

