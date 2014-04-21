package C4::Modelo::IoImportacionIso;

use strict;
use utf8;
use C4::AR::ImportacionIsoMARC;
use C4::AR::UploadFile;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'io_importacion_iso',

    columns => [
        id                      => { type => 'integer',     overflow => 'truncate', length => 11,   not_null => 1 },
        id_importacion_esquema  => { type => 'integer',     overflow => 'truncate', length => 11,   not_null => 1},
        nombre                  => { type => 'varchar',     overflow => 'truncate', length => 255,  not_null => 1},
        archivo                 => { type => 'varchar',     overflow => 'truncate', length => 255,  not_null => 1},
        comentario              => { type => 'varchar',     overflow => 'truncate', length => 255,  not_null => 1},
        formato                 => { type => 'varchar',     overflow => 'truncate', length => 255,  not_null => 1},
        estado                  => { type => 'character',   overflow => 'truncate', length => 1,    not_null => 1},
        fecha_upload            => { type => 'varchar',     overflow => 'truncate', not_null => 1},
        fecha_import            => { type => 'varchar',     overflow => 'truncate'},
        campo_identificacion    => { type => 'varchar',     overflow => 'truncate', length => 255},
        campo_relacion          => { type => 'varchar',     overflow => 'truncate', length => 255},
        cant_registros_n1       => { type => 'integer',     overflow => 'truncate', length => 11},
        cant_registros_n2       => { type => 'integer',     overflow => 'truncate', length => 11},
        cant_registros_n3       => { type => 'integer',     overflow => 'truncate', length => 11},
        accion_general          => { type => 'varchar',     overflow => 'truncate', length => 255},
        accion_sinmatcheo       => { type => 'varchar',     overflow => 'truncate', length => 255},
        accion_item             => { type => 'varchar',     overflow => 'truncate', length => 255},
        accion_barcode          => { type => 'varchar',     overflow => 'truncate', length => 255},
        reglas_matcheo          => { type => 'text',        overflow => 'truncate'},
        jobID                   => { type => 'varchar',      overflow => 'truncate', length => 255, not_null => 0,},

    ],


    relationships =>
    [
      esquema =>
      {
         class       => 'C4::Modelo::IoImportacionIsoEsquema',
         key_columns => {id_importacion_esquema => 'id' },
         type        => 'one to one',
       },

      registros =>
      {
        class       => 'C4::Modelo::IoImportacionIsoRegistro',
        key_columns => {id => 'id_importacion_iso' },
        type        => 'one to many',
      },

    ],

    primary_key_columns => [ 'id' ],
    unique_key          => ['id'],

);

#----------------------------------- FUNCIONES DEL MODELO ------------------------------------------------

sub agregar{
    my ($self)   = shift;
    my ($params) = @_;

    $self->setIdImportacionEsquema($params->{'esquemaImportacion'});
    $self->setNombre($params->{'showName'});
    $self->setArchivo($params->{'file_name'});
    $self->setFormato($params->{'formatoImportacion'});
    $self->setComentario($params->{'comentario'});
    $self->setEstado('I');

    my $dateformat = C4::Date::get_date_format();
    my $hoy        = C4::Date::format_date_in_iso(C4::Date::ParseDate("today"), $dateformat);
    $self->setFechaUpload($hoy);

    $self->save();
}


sub eliminar{
    my ($self)      = shift;
    my ($params)    = @_;

    #HACER ALGO SI ES NECESARIO
    my %parametros;
    $parametros{'id'}   = $self->getId();
    #Se eliminan el archivo
    my $msg_object =     C4::AR::UploadFile::deleteImport(\%parametros);
    if (!$msg_object->{'error'}){
            #Se eliminan los registros
            my ($registros_array_ref_count, $registros_array_ref) = C4::AR::ImportacionIsoMARC::getRegistrosFromImportacion($self->getId(),1,'ALL',$self->db);
            if($registros_array_ref){
                foreach my $rec (@$registros_array_ref){
                  $rec->eliminar();
                }
            }
            #Se elimina la importacion
            $self->delete();
    }
    return($msg_object);
}



sub obtenerCamposSubcamposDeRegistros{
    my ($self)      = shift;
    my ($params)    = @_;

    my %detalleCamposSubcampos=();

    foreach my $registro ($self->registros){

        my $marc_record = $registro->getRegistroMARCOriginal();

        foreach my $field ($marc_record->fields) {
            my $campo = $field->tag;
            if(! $field->is_control_field){
                #proceso todos los subcampos del campo
                foreach my $subfield ($field->subfields()) {
                     my $subcampo = $subfield->[0];
                    $detalleCamposSubcampos{$campo}{$subcampo} = 1;
                    #$self->debug("CAMPO ".$campo." SUBCAMPO".$subcampo);
                }
            }
            else{
                    $detalleCamposSubcampos{$campo}{''} = 1;
                    #$self->debug("CAMPO CONTROL ".$campo);
                }
        }
    }

    return(\%detalleCamposSubcampos);
}


sub setearIdentificacionRelacionRegistros{
    my ($self)      = shift;
    foreach my $registro ($self->registros){
         eval {
        $registro->setIdentificacion($registro->getIdentificacionFromRecord);
        $registro->setRelacion($registro->getRelacionFromRecord);
        $registro->save();
        };
    }
}


#----------------------------------- FIN - FUNCIONES DEL MODELO -------------------------------------------



#----------------------------------- GETTERS y SETTERS------------------------------------------------

sub setIdImportacionEsquema{
    my ($self) = shift;
    my ($esquema) = @_;
    $self->id_importacion_esquema($esquema);
}

sub setNombre{
    my ($self)  = shift;
    my ($nombre) = @_;
    $self->nombre($nombre);
}

sub setArchivo{
    my ($self)  = shift;
    my ($archivo) = @_;
    utf8::encode($archivo);
    $self->archivo($archivo);
}

sub setFormato{
    my ($self)  = shift;
    my ($formato) = @_;
    utf8::encode($formato);
    $self->formato($formato);
}

sub setComentario{
    my ($self)   = shift;
    my ($comentario) = @_;
    $self->comentario($comentario);
}

sub setEstado{
    my ($self)   = shift;
    my ($estado) = @_;
    utf8::encode($estado);
    $self->estado($estado);
}

sub setFechaUpload{
    my ($self)   = shift;
    my ($fecha) = @_;
    $self->fecha_upload($fecha);
}

sub setFechaImport{
    my ($self)   = shift;
    my ($fecha) = @_;
    $self->fecha_import($fecha);
}
sub setCampoIdentificacion{
    my ($self)   = shift;
    my ($campo,$subcampo) = @_;
    $self->campo_identificacion($campo."@".$subcampo);
}

sub getCampoFromCampoIdentificacion{
    my ($self)   = shift;
    return (split(/@/, $self->campo_identificacion()))[0];
}

sub getSubcampoFromCampoIdentificacion{
    my ($self)   = shift;
    return (split(/@/, $self->campo_identificacion()))[1];
}

sub setCampoRelacion{
    my ($self)   = shift;
    my ($campo,$subcampo,$pre) = @_;
    $self->campo_relacion($campo."@".$subcampo."@".$pre);
}

sub getCampoFromCampoRelacion{
    my ($self)   = shift;
    return (split(/@/, $self->campo_relacion()))[0];
}

sub getSubcampoFromCampoRelacion{
    my ($self)   = shift;
    return (split(/@/, $self->campo_relacion()))[1];
}

sub getPreambuloFromCampoRelacion{
    my ($self)   = shift;
    return (split(/@/, $self->campo_relacion()))[2];
}

sub setCantRegistrosN1{
    my ($self)   = shift;
    my ($cant) = @_;
    $self->cant_registros_n1($cant);
}

sub setCantRegistrosN2{
    my ($self)   = shift;
    my ($cant) = @_;
    $self->cant_registros_n2($cant);
}

sub setCantRegistrosN3{
    my ($self)   = shift;
    my ($cant) = @_;
    $self->cant_registros_n3($cant);
}

sub setAccionGeneral{
    my ($self)   = shift;
    my ($accion) = @_;
    $self->accion_general($accion);
}

sub setAccionSinmatcheol{
    my ($self)   = shift;
    my ($accion) = @_;
    $self->accion_sinmatcheo($accion);
}

sub setAccionItem{
    my ($self)   = shift;
    my ($accion) = @_;
    $self->accion_item($accion);
}

sub setAccionBarcode{
    my ($self)   = shift;
    my ($accion) = @_;
    $self->accion_barcode($accion);
}

sub setReglasMatcheo{
    my ($self)   = shift;
    my ($reglas) = @_;
    $self->reglas_matcheo($reglas);
}

sub getId{
    my ($self) = shift;
    return ($self->id);
}

sub getIdImportacionEsquema{
    my ($self) = shift;
    return $self->id_importacion_esquema;
}

sub getNombre{
    my ($self)  = shift;
    return $self->nombre;
}

sub getArchivo{
    my ($self)  = shift;
    return $self->archivo;
}

sub getFormato{
    my ($self)  = shift;
    return $self->formato;
}

sub getComentario{
    my ($self)   = shift;
    return $self->comentario;
}

sub getEstado{
    my ($self)   = shift;
    return $self->estado;
}

sub getEsquema{
    my ($self)   = shift;
    return $self->esquema;
}

sub getFechaUpload{
    my ($self)   = shift;
    return $self->fecha_upload;
}

sub getFechaUpload_formateada{
    my ($self)   = shift;
    my $dateformat = C4::Date::get_date_format();
    return C4::Date::format_date(C4::AR::Utilidades::trim($self->fecha_upload),$dateformat);
}

sub getFechaImport{
    my ($self)   = shift;
    return $self->fecha_import;
}


sub getFechaImport{
    my ($self)   = shift;
    my $dateformat = C4::Date::get_date_format();
    return C4::Date::format_date(C4::AR::Utilidades::trim($self->fecha_import),$dateformat);
}

sub getCantRegistrosN1{
    my ($self)   = shift;
    return $self->cant_registros_n1;
}

sub getCantRegistrosN2{
    my ($self)   = shift;
    return $self->cant_registros_n2;
}

sub getCantRegistrosN3{
    my ($self)   = shift;
    return $self->cant_registros_n3;
}

sub getAccionGeneral{
    my ($self)   = shift;
    return $self->accion_general;
}

sub getAccionSinmatcheol{
    my ($self)   = shift;
    return $self->accion_sinmatcheo;
}

sub getAccionItem{
    my ($self)   = shift;
    return $self->accion_item;
}

sub getAccionBarcode{
    my ($self)   = shift;
    return $self->accion_barcode;
}

sub getReglasMatcheo{
    my ($self)   = shift;
    return $self->reglas_matcheo;
}

sub getReglasMatcheoArray{
    my ($self)   = shift;

    my @reglas_matcheo= split(/#/, $self->reglas_matcheo);
    my @reglas_finales=();

    foreach my $regla (@reglas_matcheo){
        my @regla_splitted = split(/\$/, $regla);
        my %regla_final;
        $regla_final{'campo'}       = $regla_splitted[0];
        $regla_final{'subcampo'}    = $regla_splitted[1];
        $regla_final{'nombre'}      = $regla_splitted[2];
        push (@reglas_finales,\%regla_final);
    }
    return \@reglas_finales;
}

sub getRegistrosPadre{
    my ($self)   = shift;

    my ($cantidad, $registros) = C4::AR::ImportacionIsoMARC::getRegistrosFromImportacion($self->getId,'MAIN',0,'ALL');
    return $registros;
}

sub getRegistrosParaImportar{
    my ($self)   = shift;
   
    my @filtros;
    push (@filtros, ( id_importacion_iso => { eq => $self->getId }));
    #Solo registros padre por defecto
    push (@filtros, ( relacion => { eq => undef }));
    
    #Solo registros que matcheen
    push (@filtros, ( or => [matching => { ne => 1 }, matching => { eq => undef }]));
    
    #Solo registros no ignorados
    push (@filtros, or => [ estado => undef, ( estado => { ne => 'IGNORADO'}, estado =>  {ne => 'IMPORTADO' }, estado =>  {ne => 'ERROR' })]);
    
   require C4::Modelo::IoImportacionIsoRegistro;
   require C4::Modelo::IoImportacionIsoRegistro::Manager;
   my $registros_array_ref= C4::Modelo::IoImportacionIsoRegistro::Manager->get_io_importacion_iso_registro(query => \@filtros, sort_by => 'id1 ASC');
   return  $registros_array_ref;
}

sub getRegistrosParaActualizar{
	my ($self)   = shift;

    my @filtros;
    push (@filtros, ( id_importacion_iso => { eq => $self->getId }));
    #Solo registros padre por defecto
    push (@filtros, ( relacion => { eq => '' }));
    
    #Solo registros que matcheen
    push (@filtros, ( matching => { eq => 1 }));
    
    #Solo registros no ignorados
    push (@filtros, ( estado => { ne => 'IGNORADO' }));
    
   #Solo registros no importados anteriormente
    push (@filtros, ( estado => { ne => 'IMPORTADO' }));
    
   #Solo registros sin ERROR
    push (@filtros, ( estado => { ne => 'ERROR' }));
   
   require C4::Modelo::IoImportacionIsoRegistro;
   require C4::Modelo::IoImportacionIsoRegistro::Manager;
   my $registros_array_ref= C4::Modelo::IoImportacionIsoRegistro::Manager->get_io_importacion_iso_registro(query => \@filtros);
   return  $registros_array_ref;
}

sub getRegistros{
    my ($self)   = shift;

    my ($cantidad, $registros) = C4::AR::ImportacionIsoMARC::getRegistrosFromImportacion($self->getId,'ALL',0,'ALL');
    return $registros;
}

sub getCantRegistros{
    my ($self)   = shift;

    my ($cantidad, $registros) = C4::AR::ImportacionIsoMARC::getRegistrosFromImportacion($self->getId,'ALL',0,'ALL');
    return $cantidad;
}
