package C4::Modelo::CatControlSeudonimoEditorial;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'cat_control_seudonimo_editorial',

    columns => [
        id_editorial             => { type => 'integer', overflow => 'truncate', not_null => 1 },
        id_editorial_seudonimo   => { type => 'integer', overflow => 'truncate', not_null => 1 },
    ],

    primary_key_columns => [ 'id_editorial', 'id_editorial_seudonimo' ],


    relationships =>
        [
        editorial => 
        {
            class       => 'C4::Modelo::CatEditorial',
            key_columns => { id_editorial => 'id' },
            type        => 'one to one',
        },
        seudonimo => 
        {
            class       => 'C4::Modelo::CatEditorial',
            key_columns => { id_editorial_seudonimo => 'id' },
            type        => 'one to one',
        },
        ],
    );

sub agregar{
    my ($self)=shift;
    my ($id_editorial,$id_editorial_seudonimo)=@_;

    $self->setIdEditorial($id_editorial);
    $self->setIdEditorialSeudonimo($id_editorial_seudonimo);

    $self->save();
}

sub getIdEditorial{
    my ($self)=shift;
    return ($self->id_editorial);
}

sub setIdEditorial{
    my ($self)=shift;
    my ($id_editorial) = @_;
    return ($self->id_editorial($id_editorial));
}

sub getIdEditorialSeudonimo{
    my ($self)=shift;
    return ($self->id_editorial_seudonimo);
}

sub setIdEditorialSeudonimo{
    my ($self)=shift;
    my ($id_editorial_seudonimo) = @_;
    return ($self->id_editorial_seudonimo($id_editorial_seudonimo));
}

1;

