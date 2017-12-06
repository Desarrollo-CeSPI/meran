package C4::Modelo::RepRegistroModificacion;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'rep_registro_modificacion',

    columns => [
        idModificacion  => { type => 'serial', overflow => 'truncate', not_null => 1 },
        operacion       => { type => 'varchar', overflow => 'truncate', length => 15 },
        fecha           => { type => 'date' },
        responsable     => { type => 'varchar', overflow => 'truncate', length => 16, not_null => 1 },
        nota            => { type => 'text', overflow => 'truncate' },
        tipo            => { type => 'varchar', overflow => 'truncate', length => 15 },
        timestamp       => { type => 'timestamp', not_null => 1 },
        id_rec          => { type => 'integer', overflow => 'truncate' },
        nivel_rec       => { type => 'integer', overflow => 'truncate' },
        prev_rec        => { type => 'text', overflow => 'truncate' },
        final_rec       => { type => 'text', overflow => 'truncate' },
        agregacion_temp => { type => 'varchar', overflow => 'truncate', length => 255 },
    ],

    primary_key_columns => [ 'idModificacion' ],


   relationships => [
    socio_responsable => {
            class       => 'C4::Modelo::UsrSocio',
            key_columns => { responsable => 'nro_socio' },
            type        => 'one to one',
    },
   ]
);

# Operacion = ALTA,BAJA,MODIFICACION
# Tipo = CATALOGO, GLOBAL,...etc
# id_rec = id del catalogo
# nivel_rec = 1, 2 o 3 
# prev_rec = registro antes de modificar
# final_rec = registro final

sub getIdRec{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->id_rec));
}

sub getNivelRec{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->nivel_rec));
}

sub getPrevRec{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->prev_rec));
}


sub getFinalRec{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->final_rec));
}

sub getIdModificacion{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->idModificacion));
}

sub getResponsable{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->responsable));
}

sub getNota{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->nota));
}


sub getTipo{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->tipo));
}

sub getOperacion{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->operacion));
}


sub getFecha{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->fecha));
}

sub setIdModificacion{
    my ($self) = shift;
    my ($id) = @_;
    $self->idModificacion($id);
}

sub setResponsable{
    my ($self) = shift;
    my ($responsable) = @_;
    $self->responsable($responsable);
}

sub setNota{
    my ($self) = shift;
    my ($nota) = @_;
    $self->nota($nota);
}

sub setTipo{
    my ($self) = shift;
    my ($tipo) = @_;
    $self->tipo($tipo);
}


sub setOperacion{
    my ($self) = shift;
    my ($operacion) = @_;
    $self->operacion($operacion);
}


sub setFecha{
    my ($self) = shift;
    my ($fecha) = @_;
    $self->fecha($fecha);
}


sub setIdRec{
    my ($self) = shift;
    my ($id_rec) = @_;
    $self->id_rec($id_rec);
}

sub setNivelRec{
    my ($self) = shift;
    my ($nivel_rec) = @_;
    $self->nivel_rec($nivel_rec);
}

sub setPrevRec{
    my ($self) = shift;
    my ($prev_rec) = @_;
    $self->prev_rec($prev_rec);
}


sub setFinalRec{
    my ($self) = shift;
    my ($final_rec) = @_;
    $self->final_rec($final_rec);
}

sub agregar{
    my ($self)   = shift;
    my ($params) = @_;

    $self->setResponsable($params->{'responsable'});
    $self->setNota($params->{'nota'});
    $self->setTipo($params->{'tipo'});
    $self->setOperacion($params->{'operacion'});
    $self->setFecha($params->{'fecha'});  
    $self->setIdRec($params->{'id_rec'});
    $self->setNivelRec($params->{'nivel_rec'});
    $self->setPrevRec($params->{'prev_rec'});
    $self->setFinalRec($params->{'final_rec'});  
    $self->save();

}


        #**********************************Se registra la modificación ***************************
        # my ($registro_modificacion) = C4::Modelo::RepRegistroModificacion->new(db=>$self->db);
        # $data_hash->{'responsable'}= ''; #Usuario logueado
        # $data_hash->{'nota'}    = '';
        # $data_hash->{'tipo'}    = '';
        # $data_hash->{'operacion'}  = '';
        # my $dateformat = C4::Date::get_date_format();
        # my $hoy = C4::Date::format_date_in_iso(Date::Manip::ParseDate("today"),$dateformat);
        # $data_hash->{'fecha'}    = $hoy;
        # $registro_modificacion->agregar($data_hash);
        #*******************************Fin***Se registra la modificación*************************
1;

