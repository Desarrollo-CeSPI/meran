package C4::Modelo::CatRegistroMarcN2Analitica;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'cat_registro_marc_n2_analitica',

    columns => [
        cat_registro_marc_n2_id             => { type => 'integer', overflow => 'truncate', not_null => 1 },
        cat_registro_marc_n1_id             => { type => 'integer', overflow => 'truncate', not_null => 1 }
    ],

    primary_key_columns => [ 'cat_registro_marc_n2_id' , 'cat_registro_marc_n1_id' ],  

    relationships => [
        nivel2  => {
            class       => 'C4::Modelo::CatRegistroMarcN2',
            key_columns => { cat_registro_marc_n2_id => 'id' },
            type        => 'one to one',
        },
        nivel1  => {
            class       => 'C4::Modelo::CatRegistroMarcN1',
            key_columns => { cat_registro_marc_n1_id => 'id' },
            type        => 'one to one',
        },

    ],
);


sub getId2Padre{
    my ($self)  = shift;

    return $self->cat_registro_marc_n2_id;
}

sub getId1 {
    my ($self)  = shift;
    
    return $self->cat_registro_marc_n1_id;
}

sub setId2Padre{
    my ($self)  = shift;
    my ($id2)   = @_;

    $self->cat_registro_marc_n2_id($id2);
}

sub setId1{
    my ($self)  = shift;
    my ($id1)   = @_;

    $self->cat_registro_marc_n1_id($id1);
}

sub agregar{
    my ($self)          = shift;
    my ($params, $db)   = @_;

    my $analitica = C4::Modelo::CatRegistroMarcN2Analitica->new( db => $db );
    $analitica->setId1($params->{'id1'});
    $analitica->setId2Padre($params->{'id2'});

    $analitica->save();
}

sub modificar{
    my ($self)      = shift;
    my ($params)    = @_;

    $self->setId1($params->{'id1'});
    $self->setId2Padre($params->{'id2'});

    $self->save();
}

=item
    Asocia un registro a una edición del registro fuente
    SOLO mantiene una asociación, si existe una asociación vieja, la elimina, luego crea la nueva
=cut
sub asociarARegistroFuente{
    my ($self)      = shift;
    my ($params, $db)    = @_;


    # my $nivel2_analiticas_array_ref = C4::AR::Nivel2::getAnaliticasFromRelacion($params);

    # if($nivel2_analiticas_array_ref != 0){
    #     $nivel2_analiticas_array_ref->delete();
    # }

    my $nivel2_analiticas_array_ref = C4::AR::Nivel2::getAllAnaliticasById1($params->{'id1'}, $db);

    foreach $a (@$nivel2_analiticas_array_ref){
        $a->delete();
    }

    my $analitica = C4::Modelo::CatRegistroMarcN2Analitica->new( db => $db );
    $analitica->setId1($params->{'id1'});
    $analitica->setId2Padre($params->{'id2'});
    $analitica->save();
}

sub eliminar{
    my ($self)      = shift;
    my ($params)    = @_;

    $self->delete();    
}


1;

