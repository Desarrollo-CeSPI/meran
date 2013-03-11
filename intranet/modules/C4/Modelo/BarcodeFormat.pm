package C4::Modelo::BarcodeFormat;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'barcode_format',

    columns => [
        id              => { type => 'serial', overflow => 'truncate', length => 16 },
        id_tipo_doc     => { type => 'varchar', overflow => 'truncate', not_null => 1, length => 4 },
        format          => { type => 'varchar', overflow => 'truncate', not_null => 1, length => 255 },
        long            => { type => 'integer', overflow => 'truncate', not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],
    unique_key => [ 'id_tipo_doc' ],
     
    relationships =>
    [
      ui => 
      {
        class       => 'C4::Modelo::CatRefTipoNivel3',
        key_columns => { id_tipo_doc => 'id_tipo_doc' },
        type        => 'one to one',
      },
    ]
);


sub agregar{

    my ($self) = shift;
    my ($params) = @_;

    $self->setId_tipo_doc($params-{'id_tipo_doc'});
    $self->setFormat($params-{'format'});
    $self->setLong($params-{'long'});

    return($self->save());

}

sub getId{
    my ($self) = shift;

    return ($self->id);
}

sub getId_tipo_doc{
    my ($self) = shift;

    return ($self->id_tipo_doc);
}

sub getFormat{
    my ($self) = shift;

    return ($self->format);
}

sub getLong{
    my ($self) = shift;

    return ($self->long);
}

sub setId_tipo_doc{
    my ($self)  = shift;
    my ($Id_tipo_doc) = @_;

    $self->id_tipo_doc($Id_tipo_doc);
    
}

sub setFormat{
    my ($self)  = shift;
    my ($Format) = @_;

    $self->format($Format);
    
}

sub setLong{
    my ($self)  = shift;
    my ($long) = @_;

    $self->long($long);
    
}
1;

