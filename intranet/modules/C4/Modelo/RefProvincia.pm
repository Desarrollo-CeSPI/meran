package C4::Modelo::RefProvincia;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'ref_provincia',

    columns => [
        PROVINCIA        => { type => 'varchar', overflow => 'truncate', length => 11, not_null => 1 },
        NOMBRE           => { type => 'varchar', overflow => 'truncate', length => 60 },
        ref_pais_id      => { type => 'varchar', overflow => 'truncate', default => '0', length => 11 },
    ],

    primary_key_columns => [ 'PROVINCIA' ],
);

1;

