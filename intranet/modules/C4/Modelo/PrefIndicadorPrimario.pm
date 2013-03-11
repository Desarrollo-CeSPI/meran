package C4::Modelo::PrefIndicadorPrimario;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'pref_indicador_primario',

    columns => [
        id              => { type => 'serial', overflow => 'truncate', not_null => 1 },
        indicador       => { type => 'character', overflow => 'truncate', default => '', length => 255, not_null => 1 },
        dato            => { type => 'character', overflow => 'truncate', default => '', length => 255, not_null => 1 },
        campo_marc      => { type => 'character', overflow => 'truncate', default => '', length => 3, not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],

	relationships => [
	    ref_pref_estructura_campo_marc => {
            class      => 'C4::Modelo::PrefEstructuraCampoMarc',
            column_map => { campo_marc => 'campo' },
            type       => 'one to one',
        },
    ],

);

use C4::Modelo::RefSoporte::Manager;


sub getCampo{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->campo_marc));
}

sub setCampo{
    my ($self) = shift;
    my ($campo_marc) = @_;
    $self->campo_marc(C4::AR::Utilidades::trim($campo_marc));
}

sub getId{
    my ($self) = shift;
    return ($self->id);
}

sub getIndicador{
    my ($self) = shift;

    return (C4::AR::Utilidades::trim($self->indicador));
}

sub setIndicador{
    my ($self) = shift;
    my ($indicador) = @_;

    $self->indicador(C4::AR::Utilidades::trim($indicador));
}

sub getDato{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->dato));
}

sub setDato{
    my ($self) = shift;
    my ($dato) = @_;
    $self->dato(C4::AR::Utilidades::trim($dato));
}

# sub obtenerValoresCampo {
#     my ($self) = shift;
#     my ($campo,$orden)=@_;
#     my $ref_valores = C4::Modelo::RefSoporte::Manager->get_ref_soporte
#                                                 ( select      => ['idSupport' , $campo],
#                                                             sort_by => ($orden) );
#     my @array_valores;
# 
#     for(my $i=0; $i<scalar(@$ref_valores); $i++ ){
#         my $valor;
#         $valor->{"clave"}=$ref_valores->[$i]->getIdSupport;
#         $valor->{"valor"}=$ref_valores->[$i]->getCampo($campo);
#         push (@array_valores, $valor);
#     }
#     
#     return (scalar(@array_valores), \@array_valores);
# }


=head2 sub getIndicadoresByCampo
=cut
sub getIndicadoresByCampo{
    my ($self) = shift;

    my ($campo) = @_;
    my @filtros;

    push(@filtros, ( campo_marc      => { eq => $campo } ) );

    my $indicadores_array_ref = C4::Modelo::PrefIndicadorPrimario::Manager->get_pref_indicador_primario(
                                                                                        query    => \@filtros,
                                                                       );

    return $indicadores_array_ref;
}

=head2
    sub getIndicadoresByCampoToARRAY
=cut
sub getIndicadoresByCampoToARRAY {
    my ($self) = shift;

    my ($campo) = @_;
    my $indicadores_array_ref = $self->getIndicadoresByCampo($campo);

    my @array_valores;

    for(my $i=0; $i<scalar(@$indicadores_array_ref); $i++ ){
        my $valor;
        $valor->{"clave"} = $indicadores_array_ref->[$i]->getIndicador;
        $valor->{"valor"} = $indicadores_array_ref->[$i]->getDato;

        push (@array_valores, $valor);
    }
    
    return (scalar(@array_valores), \@array_valores);
}


1;

