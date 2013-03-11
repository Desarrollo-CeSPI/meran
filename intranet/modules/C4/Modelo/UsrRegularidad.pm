package C4::Modelo::UsrRegularidad;

# this class IS a "Usr_persona::DB::Object" 
# and contains all the methodes that 
# Usr_persona::DB::Object does
use base qw(C4::Modelo::DB::Object::AutoBase2);

# call the methode My::DB::Object->meta->setup() to 
# announce the layout of our database table;

__PACKAGE__->meta->setup
  (
    table   => 'usr_regularidad',
    columns => [
        id                      => { type => 'serial', overflow => 'truncate', not_null => 1, length => 11 },
        usr_estado_id           => { type => 'integer', overflow => 'truncate', not_null => 1, length => 1 },
        usr_ref_categoria_id    => { type => 'integer', overflow => 'truncate', length => 2, not_null => 1 },
        condicion                 => { type => 'integer', overflow => 'truncate', not_null => 1, length => 1 },
    ],

     relationships =>
    [
      estado => 
      {
        class       => 'C4::Modelo::UsrEstado',
        key_columns => { usr_estado_id => 'id_estado' },
        type        => 'one to one',
      },

      categoria => 
      {
        class       => 'C4::Modelo::UsrRefCategoriaSocio',
        key_columns => { usr_ref_categoria_id => 'id' },
        type        => 'one to one',
      },

    ],
    
    primary_key_columns => [ 'id' ],
    unique_key => [ 'usr_estado_id','usr_ref_categoria_id' ],
);

sub agregar{
    my ($self)=shift;
    my ($data_hash)=@_;
    #Asignando data...
    $self->setUsrEstadoId($data_hash->{'usr_estado_id'});
    $self->setUsrRefCategoriaId($data_hash->{'usr_ref_categoria_id'});
    $self->setCondicion($data_hash->{'Condicion'});
    $self->save();
}

sub getId{
    my ($self) = shift;
    return ($self->id);
}

sub getUsrEstadoId{
    my ($self) = shift;
    return ($self->usr_estado_id);
}

sub setUsrEstadoId{
    my ($self) = shift;
    my ($id) = @_;
    $self->usr_estado_id($id);
}

sub getUsrRefCategoriaId{
    my ($self) = shift;
    return ($self->usr_ref_categoria_id);
}

sub setUsrRefCategoriaId{
    my ($self) = shift;
    my ($id) = @_;
    $self->usr_ref_categoria_id($id);
}

sub getCondicion{
    my ($self) = shift;
    return ($self->condicion);
}

sub setCondicion{
    my ($self) = shift;
    my ($condicion) = @_;
    $self->condicion($condicion);
}

sub getRegularidad{
    my ($self) = shift;

    my $cond = $self->getCondicion;
    
    return $cond?C4::AR::Filtros::i18n("REGULAR"):C4::AR::Filtros::i18n("NO REGULAR");	
}

1;
