package C4::Modelo::PermCatalogo;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'perm_catalogo',

    columns => [
        nro_socio => { type => 'varchar', overflow => 'truncate', length => 16, not_null => 1 },
        ui  => { type => 'varchar', overflow => 'truncate', length => 4, not_null => 1 }, 
        tipo_documento => { type => 'varchar', overflow => 'truncate', length => 4, not_null => 1 }, 
        datos_nivel1 => { type => 'varchar', overflow => 'truncate', length => 8, not_null => 1 },
        datos_nivel2 => { type => 'varchar', overflow => 'truncate', length => 8, not_null => 1 },
        datos_nivel3 => { type => 'varchar', overflow => 'truncate', length => 8, not_null => 1 },
        estantes_virtuales => { type => 'varchar', overflow => 'truncate', length => 8, not_null => 1 },
        estructura_catalogacion_n1 => { type => 'varchar', overflow => 'truncate', length => 8, not_null => 1 },
        estructura_catalogacion_n2 => { type => 'varchar', overflow => 'truncate', length => 8, not_null => 1 },
        estructura_catalogacion_n3 => { type => 'varchar', overflow => 'truncate', length => 8, not_null => 1 },
        tablas_de_refencia => { type => 'varchar', overflow => 'truncate', length => 8, not_null => 1 },
        control_de_autoridades => { type => 'varchar', overflow => 'truncate', length => 8, not_null => 1 },
        usuarios => { type => 'varchar', overflow => 'truncate', length => 8, not_null => 1 },
        sistema => { type => 'varchar', overflow => 'truncate', length => 8, not_null => 1 },
        undefined => { type => 'varchar', overflow => 'truncate', length => 8, not_null => 1 },
        id => { type => 'integer', overflow => 'truncate', length => 11, not_null => 1 }
    ],

    primary_key_columns => [ 'nro_socio','ui','tipo_documento' ],

    unique_key => [ 'id' ],
);

sub agregar{
    my ($self) = shift;
    my ($permisos_hash) = @_;

    $self->setNro_socio($permisos_hash->{'nro_socio'});
    $self->setUI($permisos_hash->{'id_ui'});
    $self->setTipo_documento($permisos_hash->{'tipo_documento'});
    $self->setDatos_nivel1($permisos_hash->{'datos_nivel1'});
    $self->setDatos_nivel2($permisos_hash->{'datos_nivel2'});
    $self->setDatos_nivel3($permisos_hash->{'datos_nivel3'});
    $self->setEstantes_virtuales($permisos_hash->{'estantes_virtuales'});
    $self->setEstructura_catalogacion_n1($permisos_hash->{'estructura_catalogacion_n1'});
    $self->setEstructura_catalogacion_n2($permisos_hash->{'estructura_catalogacion_n2'});
    $self->setEstructura_catalogacion_n3($permisos_hash->{'estructura_catalogacion_n3'});
    $self->setTablas_de_referencia($permisos_hash->{'tablas_de_refencia'});
    $self->setControl_de_autoridades($permisos_hash->{'control_de_autoridades'});
    $self->setUsuarios($permisos_hash->{'usuarios'});
    $self->setSistema($permisos_hash->{'sistema'});
    $self->setUndefined($permisos_hash->{'undefined'});

    $self->save();
}

sub setAll{

    my ($self) = shift;
    my ($permisosByte) = @_;

    $self->setDatos_nivel1($permisosByte);
    $self->setDatos_nivel2($permisosByte);
    $self->setDatos_nivel3($permisosByte);
    $self->setEstantes_virtuales($permisosByte);
    $self->setEstructura_catalogacion_n1($permisosByte);
    $self->setEstructura_catalogacion_n2($permisosByte);
    $self->setEstructura_catalogacion_n3($permisosByte);
    $self->setTablas_de_referencia($permisosByte);
    $self->setControl_de_autoridades($permisosByte);
    $self->setUsuarios($permisosByte);
    $self->setSistema($permisosByte);
    $self->setUndefined($permisosByte);
}

sub modificar{
    my ($self) = shift;
    my ($permisos_hash) = @_;
# 
#     $self->setNro_socio($permisos_hash->{'nro_socio'});
#     $self->setUI($permisos_hash->{'id_ui'});
#     $self->setTipo_documento($permisos_hash->{'tipo_documento'});
    $self->setDatos_nivel1($permisos_hash->{'datos_nivel1'});
    $self->setDatos_nivel2($permisos_hash->{'datos_nivel2'});
    $self->setDatos_nivel3($permisos_hash->{'datos_nivel3'});
    $self->setEstantes_virtuales($permisos_hash->{'estantes_virtuales'});
    $self->setEstructura_catalogacion_n1($permisos_hash->{'estructura_catalogacion_n1'});
    $self->setEstructura_catalogacion_n2($permisos_hash->{'estructura_catalogacion_n2'});
    $self->setEstructura_catalogacion_n3($permisos_hash->{'estructura_catalogacion_n3'});
    $self->setTablas_de_referencia($permisos_hash->{'tablas_de_refencia'});
    $self->setControl_de_autoridades($permisos_hash->{'control_de_autoridades'});

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

sub getUsuarios{
    my ($self) = shift;
    return ($self->usuarios);
}

sub setUsuarios{
    my ($self) = shift;
    my ($usuarios) = @_;
    $self->usuarios($usuarios);
}

sub getSistema{
    my ($self) = shift;
    return ($self->sistema);
}

sub setSistema{
    my ($self) = shift;
    my ($sistema) = @_;
    $self->sistema($sistema);
}

sub getUndefined{
    my ($self) = shift;
    return ($self->undefined);
}

sub setUndefined{
    my ($self) = shift;
    my ($undefined) = @_;
    $self->undefined($undefined);
}

sub getId_persona{
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

sub getDatos_nivel1{
    my ($self) = shift;
    return ($self->datos_nivel1);
}

sub setDatos_nivel1{
    my ($self) = shift;
    my ($datos_nivel1) = @_;
    $self->datos_nivel1($datos_nivel1);
}

sub getDatos_nivel2{
    my ($self) = shift;
    return ($self->datos_nivel2);
}

sub setDatos_nivel2{
    my ($self) = shift;
    my ($datos_nivel2) = @_;
    $self->datos_nivel2($datos_nivel2);
}

sub getDatos_nivel3{
    my ($self) = shift;
    return ($self->datos_nivel3);
}

sub setDatos_nivel3{
    my ($self) = shift;
    my ($datos_nivel3) = @_;
    $self->datos_nivel3($datos_nivel3);
}
   
sub getEstantes_virtuales{
    my ($self) = shift;
    return ($self->estantes_virtuales);
}

sub setEstantes_virtuales{
    my ($self) = shift;
    my ($estantes_virtuales) = @_;
    $self->estantes_virtuales($estantes_virtuales);
}
  

sub getEstructura_catalogacion_n1{
    my ($self) = shift;
    return ($self->estructura_catalogacion_n1);
}

sub setEstructura_catalogacion_n1{
    my ($self) = shift;
    my ($estructura_catalogacion_n1) = @_;
    $self->estructura_catalogacion_n1($estructura_catalogacion_n1);
}

sub getEstructura_catalogacion_n2{
    my ($self) = shift;
    return ($self->estructura_catalogacion_n2);
}

sub setEstructura_catalogacion_n2{
    my ($self) = shift;
    my ($estructura_catalogacion_n2) = @_;
    $self->estructura_catalogacion_n2($estructura_catalogacion_n2);
}

sub getEstructura_catalogacion_n3{
    my ($self) = shift;
    return ($self->estructura_catalogacion_n3);
}

sub setEstructura_catalogacion_n3{
    my ($self) = shift;
    my ($estructura_catalogacion_n3) = @_;
    $self->estructura_catalogacion_n3($estructura_catalogacion_n3);
}
 
sub getTablas_de_referencia{
    my ($self) = shift;
    return ($self->tablas_de_refencia);
}

sub setTablas_de_referencia{
    my ($self) = shift;
    my ($tablas_de_refencia) = @_;
    $self->tablas_de_refencia($tablas_de_refencia);
}

sub getControl_de_autoridades{
    my ($self) = shift;
    return ($self->control_de_autoridades);
}

sub setControl_de_autoridades{
    my ($self) = shift;
    my ($control_de_autoridades) = @_;
    $self->control_de_autoridades($control_de_autoridades);
}

sub getId{
    my ($self) = shift;
    return ($self->id);
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



# sub setId{
#     my ($self) = shift;
#     my ($id) = @_;
#     $self->control_de_autoridades($control_de_autoridades);
# }




1;

