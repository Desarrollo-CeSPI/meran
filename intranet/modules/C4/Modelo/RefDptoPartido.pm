package C4::Modelo::RefDptoPartido;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'ref_dpto_partido',

    columns => [
        id                  => { type => 'varchar', overflow => 'truncate', length => 11, not_null => 1 },
        NOMBRE              => { type => 'varchar', overflow => 'truncate', length => 60 },
        ref_provincia_id    => { type => 'varchar', overflow => 'truncate', length => 11 },
        ESTADO              => { type => 'character', overflow => 'truncate', length => 1 },
    ],

    primary_key_columns => [ 'DPTO_PARTIDO' ],
);

1;

