package C4::Modelo::RefTipoDocumento;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'ref_tipo_documento',

    columns => [
        idTipoDoc   => { type => 'serial', overflow => 'truncate', not_null => 1 },
        nombre      => { type => 'varchar', overflow => 'truncate', length => 50, not_null => 1 },
        descripcion => { type => 'varchar', overflow => 'truncate', length => 250, not_null => 1 },
    ],

    primary_key_columns => [ 'idTipoDoc' ],
);

1;

