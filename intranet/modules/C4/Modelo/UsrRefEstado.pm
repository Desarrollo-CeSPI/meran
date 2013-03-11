package C4::Modelo::UsrRefEstado;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'usr_ref_estado',

    columns => [
        id_estado   => { type => 'serial', overflow => 'truncate', not_null => 1 },
        descripcion => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1 },
    ],

    primary_key_columns => [ 'id_estado' ],
);

sub toString{
    my ($self) = shift;

    return ($self->descripcion);
}

1;

