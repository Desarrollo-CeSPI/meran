package C4::Modelo::SysNovedadIntraNoMostrar;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'sys_novedad_intra_no_mostrar',

    columns => [
        id_novedad      => { type => 'integer', overflow => 'truncate', not_null => 1, length => 16 },
        usuario_novedad => { type => 'varchar', overflow => 'truncate', not_null => 1, length => 16 },
    ],

    primary_key_columns => [ 'id_novedad', 'usuario_novedad' ],

);

sub agregar{

    my ($self) = shift;
    my (%params) = @_;
    my $usuario = C4::AR::Auth::getSessionNroSocio();
    $self->setIdNovedad($params{'id_novedad'});
    $self->setUsuarioNovedad($usuario);

    return($self->save());
}

sub getIdNovedad{
    my ($self) = shift;

    return ($self->id_novedad);
}

sub setIdNovedad{
    my ($self) = shift;
    my ($id_novedad) = @_;

    $self->id_novedad($id_novedad);
}

sub getUsuarioNovedad{
    my ($self) = shift;

    return (C4::AR::Utilidades::trim($self->usuario_novedad));
}

sub setUsuarioNovedad{
    my ($self) = shift;
    my ($usuario_novedad) = @_;

    $self->usuario_novedad($usuario_novedad);
}

1;
