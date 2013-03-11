package C4::Modelo::PrefTablaReferenciaRelCatalogo;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'pref_tabla_referencia_rel_catalogo',

    columns => [
        id              => { type => 'serial', overflow => 'truncate'},
        alias_tabla     => { type => 'varchar', overflow => 'truncate', length => 32, not_null => 1 },
        tabla_referente => { type => 'varchar', overflow => 'truncate', length => 32, not_null => 1 },
        campo_referente => { type => 'varchar', overflow => 'truncate', length => 32, not_null => 1 },
        sub_campo_referente => { type => 'varchar', overflow => 'truncate', length => 32, not_null => 0, default => 'NULL' },
    ],

    primary_key_columns => [ 'id' ],
);

use C4::Modelo::PrefTablaReferenciaRelCatalogo::Manager;

sub getAll{

    my ($self) = shift;
    my ($limit,$offset)=@_;
    my $ref_valores = C4::Modelo::RefPais::Manager->get_pref_tabla_referencia_rel_catalogo( limit => $limit, offset => $offset);
    return ($ref_valores);
}


sub getAlias_tabla{

    my ($self) = shift;
        
    return ($self->alias_tabla);
}

sub getTabla_referente{

    my ($self) = shift;
        
    return ($self->tabla_referente);
}

sub getCampo_referente{

    my ($self) = shift;
    return ($self->campo_referente);
}

sub getSub_campo_referente{

    my ($self) = shift;
    return ($self->sub_campo_referente);
}

sub getReferente{

    my ($self) = shift;
    my $campo = $self->getCampo_referente;
#     my $sub_campo = $self->getSub_campo_referente;

#     return ($campo,$sub_campo);
    return ($campo);
}

1;

