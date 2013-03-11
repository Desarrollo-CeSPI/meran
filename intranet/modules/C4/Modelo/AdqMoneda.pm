package C4::Modelo::RefAdqMoneda;

use strict;
use utf8;
use C4::AR::Utilidades;
use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'ref_adq_moneda',

    columns => [
        id      => { type => 'integer', overflow => 'truncate', length => 11, not_null => 1 },
        nombre  => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1},
    ],

    primary_key_columns => [ 'id' ],

);

#************************************************ FUNCIONES DEL MODELO | MONEDA *********************************************************

# Agrega una nueva moneda
sub agregarMoneda{

    my ($self) = shift;
    my ($params) = @_;

    $self->setNombre($params->{'nombre'});

    $self->save();
}

# ********************************************** FIN FUNCIONES DEL MODELO | MONEDA *****************************************************





# *********************************************************** Getter y Setter *********************************************************

sub setNombre{
    my ($self)   = shift;
    my ($nombre) = @_;
    utf8::encode($nombre);
    if (C4::AR::Utilidades::validateString($nombre)){
      $self->nombre($nombre);
    }
}

sub getNombre{
    my ($self) = shift;
    return ($self->nombre);  
}

# ******************************************************* FIN Getter y Setter ****************************************************

1;
