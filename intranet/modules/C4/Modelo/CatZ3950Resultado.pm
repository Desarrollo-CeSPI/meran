package C4::Modelo::CatZ3950Resultado;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'cat_z3950_resultado',

    columns => [
        id              => { type => 'serial', overflow => 'truncate', not_null => 1 },
        servidor_id     => { type => 'serial', overflow => 'truncate', not_null => 1 },
        registro       => { type => 'text', overflow => 'truncate', default => 0},
        cola_id         => { type => 'serial', overflow => 'truncate', not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],

    relationships => [
        cola => {
            class       => 'C4::Modelo::CatZ3950Cola',
            key_columns => { cola_id => 'id' },
            type        => 'one to one',
        },
        servidor => {
            class       => 'C4::Modelo::PrefServidorZ3950',
            key_columns => { servidor_id => 'id' },
        type        => 'one to one',
        },
    ],
);

sub getId{
    my ($self) = shift;
    return ($self->id);
}

sub setId{
    my ($self) = shift;
    my ($id) = @_;
    $self->id($id);
}

sub getServidorId {
    my ($self) = shift;
    return ($self->servidor_id);
}

sub setServidorId {
    my ($self) = shift;
    my ($servidor_id) = @_;
    $self->servidor_id($servidor_id);
}

sub getColaId{
    my ($self) = shift;
    return ($self->cola_id);
}

sub setColaId{
    my ($self) = shift;
    my ($cola_id) = @_;
    $self->cola_id($cola_id);
}


sub getRegistro{
    my ($self) = shift;
    return ($self->registro);
}

sub setRegistro{
    my ($self) = shift;
    my ($registro) = @_;
    $self->registro($registro);
}

sub getRegistroMARC {
    my ($self) = shift;

    my $raw=$self->registro;
    my $marc  = new_from_usmarc MARC::Record($raw);
    $marc->encoding( 'UTF-8' );
    return $marc;
}

sub getPortada {
    my ($self) = shift;
        my $portada="";
        my $marc = $self->getRegistroMARC;
        my $isbn = $marc->subfield('020','a');
        if($isbn){
            my @isbns=split(/\s+/,$isbn);
         $portada= C4::AR::PortadasRegistros::getPortadaByIsbn($isbns[0]);
        }

    return $portada;
}
1;

