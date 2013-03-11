package C4::Modelo::PermGeneral;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'perm_general',

    columns => [
        nro_socio       => { type => 'varchar', overflow => 'truncate', length => 16, not_null => },
        ui              => { type => 'varchar', overflow => 'truncate', length => 4, not_null => 1 },
        tipo_documento  => { type => 'varchar', overflow => 'truncate', length => 4, not_null => 1 }, 
        preferencias    => { type => 'varchar', overflow => 'truncate', length => 8, not_null => 1 },
        reportes        => { type => 'varchar', overflow => 'truncate', length => 8, not_null => 1 },
        permisos        => { type => 'varchar', overflow => 'truncate', length => 8, not_null => 1 },
        adq_opac        => { type => 'varchar', overflow => 'truncate', length => 8, not_null => 1 },
        adq_intra       => { type => 'varchar', overflow => 'truncate', length => 8, not_null => 1 },
    ],

    primary_key_columns => [ 'nro_socio','ui','tipo_documento' ],

);

sub agregar{

    my ($self) = shift;
    my ($permisos_hash) = @_;

    $self->setNro_socio($permisos_hash->{'nro_socio'});
    $self->setUI($permisos_hash->{'id_ui'});
    $self->setTipo_documento($permisos_hash->{'tipo_documento'});
    $self->setReportes($permisos_hash->{'reportes'});
    $self->setPreferencias($permisos_hash->{'preferencias'});
    $self->setPermisos($permisos_hash->{'permisos'});
    $self->setAdqOpac($permisos_hash->{'adq_opac'});
    $self->setAdqIntra($permisos_hash->{'adq_intra'});
    $self->save();
}

sub setAll{

    my ($self) = shift;
    my ($permisosByte) = @_;
    $self->setReportes($permisosByte);
    $self->setPreferencias($permisosByte);
    $self->setPermisos($permisosByte);
    $self->setAdqOpac($permisosByte);
    $self->setAdqIntra($permisosByte);
}

sub modificar{

    my ($self) = shift;
    my ($permisos_hash) = @_;

    $self->save();
}

sub getNro_socio{

    my ($self) = shift;

    return ($self->nro_socio);
}

sub setNro_socio{

    my ($self) = shift;
    my ($nro_socio) = @_;
    
    $self->nro_socio($nro_socio);
}

sub getUI{

    my ($self) = shift;
    
    return ($self->ui);
}

sub setUI{

    my ($self) = shift;
    my ($ui) = @_;
    
    $self->ui($ui);
}

sub getTipo_documento{

    my ($self) = shift;
    
    return ($self->tipo_documento);
}

sub setTipo_documento{

    my ($self) = shift;
    my ($tipo_documento) = @_;
    
    $self->tipo_documento($tipo_documento);
}


sub getPreferencias{

    my ($self) = shift;
    
    return ($self->preferencias);
}

sub setPreferencias{

    my ($self) = shift;
    my ($preferencias) = @_;
    
    $self->preferencias($preferencias);
}

sub getReportes{

    my ($self) = shift;
    
    return ($self->reportes);
}

sub setReportes{

    my ($self) = shift;
    my ($reportes) = @_;
    
    $self->reportes($reportes);
}

sub getPermisos{

    my ($self) = shift;
    
    return ($self->permisos);
}

sub setPermisos{

    my ($self) = shift;
    my ($permisos) = @_;
    
    $self->permisos($permisos);
}

sub getAdqOpac{

    my ($self) = shift;
    
    return ($self->adq_opac);
}

sub setAdqOpac{

    my ($self) = shift;
    my ($permisos) = @_;
    
    $self->adq_opac($permisos);
}

sub getAdqIntra{

    my ($self) = shift;
    
    return ($self->adq_intra);
}

sub setAdqIntra{

    my ($self) = shift;
    my ($permisos) = @_;
    
    $self->adq_intra($permisos);
}

sub convertirEnEstudiante{

    my ($self) = shift;
    my ($socio) = @_;
    $self->setAll(C4::AR::Permisos::getConsultaByte());
    $self->setNro_socio($socio->getNro_socio);
    $self->setUI($socio->getId_ui);
    $self->setTipo_documento('ALL');
    $self->save();

}

sub convertirEnLibrarian{

    my ($self) = shift;
    my ($socio) = @_;

    $self->setAll(C4::AR::Permisos::getConsultaByte() | C4::AR::Permisos::getAltaByte() | C4::AR::Permisos::getModificacionByte() );
    $self->setNro_socio($socio->getNro_socio);
    $self->setUI($socio->getId_ui);
    $self->setTipo_documento('ALL');

    $self->save();

}

sub convertirEnSuperLibrarian{

    my ($self) = shift;
    my ($socio) = @_;

    $self->setAll(C4::AR::Permisos::getTodosByte());
    $self->setNro_socio($socio->getNro_socio);
    $self->setUI($socio->getId_ui);
    $self->setTipo_documento('ALL');

    $self->save();

}

1;

