package C4::Modelo::SysExternosMeran;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'sys_externos_meran',

    columns => [
        id              => { type => 'serial', overflow => 'truncate', length => 16 },
        id_ui           => { type => 'varchar', overflow => 'truncate', not_null => 1, length => 4 },
        url             => { type => 'varchar', overflow => 'truncate', not_null => 1, length => 255 },
    ],

    primary_key_columns => [ 'id' ],
     
    relationships =>
    [
      ui => 
      {
        class       => 'C4::Modelo::PrefUnidadInformacion',
        key_columns => { id_ui => 'id_ui' },
        type        => 'one to one',
      },
    ]
);


sub agregar{
    my ($self) = shift;
    my ($params) = @_;

    $self->setId_iu($params-{'id_ui'});
    $self->setUrl($params-{'url'});

    return($self->save());
}

sub add{
    my ($self) = shift;
    my ($url, $id_ui) = @_;

    $self->id_ui($id_ui);
    $self->url($url);
}

sub edit{
    my ($self) = shift;
    my ($url, $id_ui) = @_;

    $self->id_ui($id_ui);
    $self->url($url);
}

sub getId{
    my ($self) = shift;

    return ($self->id);
}

sub getId_ui{
    my ($self) = shift;

    return ($self->id_ui);
}

sub getUrl{
    my ($self) = shift;

    return ($self->url);
}

sub setId_ui{
    my ($self)  = shift;
    my ($id_ui) = @_;

    $self->id_ui($id_ui);
}

sub setUrl{
    my ($self)  = shift;
    my ($url) = @_;

    $self->url($url);
}
1;