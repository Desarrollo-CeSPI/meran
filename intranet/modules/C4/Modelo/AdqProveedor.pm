package C4::Modelo::AdqProveedor;

use strict;
use utf8;
use C4::AR::Permisos;
use C4::AR::Utilidades;
use C4::Modelo::RefTipoDocumento;
use C4::Modelo::RefPais;
use C4::Modelo::RefProvincia;
use C4::Modelo::RefLocalidad;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'adq_proveedor',

    columns => [
        id                              => { type => 'integer', overflow => 'truncate', not_null => 1 },
        apellido                        => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1},
        nombre                          => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1},
        usr_ref_tipo_documento_id       => { type => 'integer', overflow => 'truncate', not_null => 1},
        nro_doc                         => { type => 'varchar', overflow => 'truncate', length => 12, not_null => 1 },
        razon_social                    => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1 },
        cuit_cuil                       => { type => 'varchar', overflow => 'truncate', length => 32, not_null => 1 },
        ref_localidad_id                => { type => 'integer', overflow => 'truncate', not_null => 1},
        domicilio                       => { type => 'varchar', overflow => 'truncate', length =>  255, not_null => 1 },
        telefono                        => { type => 'varchar', overflow => 'truncate', length => 32, not_null => 1 },
        fax                             => { type => 'varchar', overflow => 'truncate', length => 32},
        email                           => { type => 'varchar', overflow => 'truncate', length => 255},
        plazo_reclamo                   => { type => 'integer', overflow => 'truncate', length => 11},
        activo                          => { type => 'integer', overflow => 'truncate', default => 1, not_null => 1},
    ],


    relationships =>
    [
      ref_tipo_documento => 
      {
         class       => 'C4::Modelo::UsrRefTipoDocumento',
         key_columns => {usr_ref_tipo_documento_id => 'id' },
         type        => 'one to one',
       },
      
      ref_localidad => 
      {
        class       => 'C4::Modelo::RefLocalidad',
        key_columns => {ref_localidad_id => 'id' },
        type        => 'one to one',
      },

#     one to many asi trae monedas en un vector de objetos
      moneda_ref => 
      {
        class       => 'C4::Modelo::AdqProveedorMoneda',
        key_columns => { id => 'proveedor_id' },
        type        => 'one to many',
      },
      
      ref_tipo_material => 
      {
        class       => 'C4::Modelo::AdqProveedorTipoMaterial',
        key_columns => { id => 'proveedor_id' },
        type        => 'one to many',
      },

    ],
    
    primary_key_columns => [ 'id' ],
    unique_key          => ['nro_doc'],

);

# ********************************************FUNCIONES DEL MODELO | PROVEEDORES*****************************************************

sub desactivar{
    my ($self) = shift;
    $self->setActivo(0);
    $self->save();
}

sub agregarProveedor{
    my ($self)   = shift;
    my ($params) = @_;
    
    if($params->{'tipo_proveedor'} eq "persona_fisica"){
        $self->setTipoDoc($params->{'tipo_doc'});
        $self->setNroDoc($params->{'nro_doc'});
    }

    $self->setNombre($params->{'nombre'});
    $self->setApellido($params->{'apellido'});
    $self->setDomicilio($params->{'domicilio'});
    $self->setTelefono($params->{'telefono'});
    $self->setEmail($params->{'email'});
    $self->setRazonSocial($params->{'razon_social'});
    $self->setCuitCuil($params->{'cuit_cuil'});
    $self->setFax($params->{'fax'});
    $self->setCiudad($params->{'ciudad'});
    $self->setPlazoReclamo($params->{'plazo_reclamo'});
    $self->setActivo(1);

    $self->save();
}

sub editarProveedor{

    my ($self)   = shift;
    my ($params) = @_;
   
    $self->setNombre($params->{'nombre'});
    $self->setApellido($params->{'apellido'});
    $self->setDomicilio($params->{'domicilio'});
    $self->setTelefono($params->{'telefono'});
    $self->setEmail($params->{'email'});
    $self->setTipoDoc($params->{'tipo_documento'});
    $self->setNroDoc($params->{'nro_doc'});
    $self->setRazonSocial($params->{'razon_social'});
    $self->setCuitCuil($params->{'cuit_cuil'});
    $self->setFax($params->{'fax'});
    $self->setCiudad($params->{'ciudad'});
    $self->setPlazoReclamo($params->{'plazo_reclamo'});
    $self->setActivo($params->{'proveedor_activo'});

    $self->save();
}


# *********************************FIN FUNCIONES DEL MODELO | PROVEEDORES********************************************************




# *************************************************Getters y Setters**********************************************************

sub setApellido{
    my ($self)     = shift;
    my ($apellido) = @_;
    utf8::encode($apellido);
    if (C4::AR::Utilidades::validateString($apellido)){
      $self->apellido($apellido);
    }
}

sub setNombre{
    my ($self)   = shift;
    my ($nombre) = @_;
    utf8::encode($nombre);
    if (C4::AR::Utilidades::validateString($nombre)){
      $self->nombre($nombre);
    }
}

sub setTipoDoc{
    my ($self)    = shift;
    my ($tipoDoc) = @_;
    utf8::encode($tipoDoc);
    $self->usr_ref_tipo_documento_id($tipoDoc);
}

sub setNroDoc{
    my ($self)                = shift;
    my ($docNumber, $docType) = @_;
    utf8::encode($docNumber);
    utf8::encode($docType);
    if (C4::AR::Validator::isValidDocument($docType, $docNumber)){
      $self->nro_doc($docNumber);
    }
}

sub setRazonSocial{
    my ($self)        = shift;
    my ($razonSocial) = @_;
    utf8::encode($razonSocial);
    if (C4::AR::Utilidades::validateString($razonSocial)){
      $self->razon_social($razonSocial);
    }
}

# VER COMO VALIDARLO

sub setCuitCuil{
    my ($self)     = shift;
    my ($cuitCuil) = @_;
    utf8::encode($cuitCuil);
    if (C4::AR::Utilidades::validateString($cuitCuil)){
      $self->cuit_cuil($cuitCuil);
    }
}

sub setCiudad{
    my ($self) = shift;
    my ($ciu)  = @_;
    utf8::encode($ciu);
    $self->ref_localidad_id($ciu);
    
}

sub setDomicilio{
    my ($self)      = shift;
    my ($domicilio) = @_;
    utf8::encode($domicilio);
    if (C4::AR::Utilidades::validateString($domicilio)){
      $self->domicilio($domicilio);
    }
}

sub setEmail{
    my ($self)  = shift;
    my ($email) = @_;
    utf8::encode($email);
    if (C4::AR::Validator::isValidMail($email)){
      $self->email($email);
    }
}

sub setTelefono{
    my ($self)     = shift;
    my ($telefono) = @_;
    utf8::encode($telefono);
    $self->telefono($telefono);

}

sub setFax{
    my ($self) = shift;
    my ($fax)  = @_;
    utf8::encode($fax);
    $self->fax($fax);
}

sub setPlazoReclamo{
    my ($self)     = shift;
    my ($plazoRec) = @_;
    utf8::encode($plazoRec);
    $self->plazo_reclamo($plazoRec);
}

sub setActivo{
    my ($self)   = shift;
    my ($activo) = @_;
    $self->activo($activo);
}


# ------GETTERS--------------------

sub getId{
    my ($self) = shift;
    return ($self->id);
}

sub getApellido{
    my ($self) = shift;
    return ($self->apellido);
}

sub getNombre{
    my ($self) = shift;
    return ($self->nombre);
}

sub getTipoDoc{
    my ($self) = shift;
    return ($self->usr_ref_tipo_documento_id);
}

sub getNroDoc{
    my ($self) = shift;
    return ($self->nro_doc);
}

sub getRazonSocial{
    my ($self) = shift;
    return ($self->razon_social);
}

sub getCuitCuil{
    my ($self) = shift;
    return ($self->cuit_cuil);
}

sub getCiudad{
    my ($self) = shift;
    return ($self->ref_localidad_id);
}

sub getDomicilio{
    my ($self) = shift;
    return ($self->domicilio);
}

sub getTelefono{
    my ($self) = shift;
    return ($self->telefono);
}

sub getFax{
    my ($self) = shift;
    return ($self->fax);
}

sub getEmail{
    my ($self) = shift;
    return ($self->email);
}

sub getPlazoReclamo{
    my ($self) = shift;
    return ($self->plazo_reclamo);
}

sub getActivo{
    my ($self) = shift;
    return ($self->activo);
}
# ****************************************************FIN Getter y Setter**************************************************************

1;
