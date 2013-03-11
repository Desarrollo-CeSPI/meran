package C4::Modelo::PrefFeriado;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'pref_feriado',

    columns => [
        id               => { type => 'serial', overflow => 'truncate', not_null => 1 },
        fecha            => { type => 'varchar', overflow => 'truncate', default => '0000-00-00', length => 10, not_null => 1 },
        feriado          => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 0 },
    ],

    primary_key_columns => [ 'id' ],
);

sub agregar{
    my ($self) = shift;
    my ($fecha,$status,$feriado) = @_;

    $self->setFecha($fecha,$status,$feriado);

}

sub getFeriado{
    my ($self) = shift;

    return (C4::Utilidades::trim($self->feriado));
}

sub getFecha{
    my ($self) = shift;
    my $dateformat = C4::Date::get_date_format();

    return (C4::Date::format_date($self->fecha,$dateformat));
}

=item
    Devuelve la fecha en formato US, para el calendario
=cut
sub getFechaParaCalendario{
    my ($self) = shift;

    return (C4::Date::format_date($self->fecha,'us'));
}

sub getFeriado{
    my ($self) = shift;

    my $feriado = $self->feriado || C4::AR::Filtros::i18n('Sin Descripcion');
    
    return ($feriado);
}

sub setFecha{
    my ($self) = shift;
    my ($fecha,$status,$feriado) = @_;

    if ($status eq "true"){
        $self->fecha($fecha);
        $self->feriado($feriado);
        $self->save();
    }else {
        $self->delete();
    }
}

1;