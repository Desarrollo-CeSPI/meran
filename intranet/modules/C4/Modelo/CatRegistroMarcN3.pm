package C4::Modelo::CatRegistroMarcN3;

use strict;

=head1 NAME

 C4::Modelo::CatRegistroMarcN3- Funciones que manipulan datos del catálogo a nivel 3

=head1 SYNOPSIS

  use C4::Modelo::CatRegistroMarcN3;

=head1 DESCRIPTION

Modulo para manejar objetos del ORM de los datos del nivel3 del catalogo

=head1 FUNCTIONS

=over 2
=cut

use base qw(C4::Modelo::DB::Object::AutoBase2);
use C4::AR::Utilidades qw(trim);

__PACKAGE__->meta->setup(
    table   => 'cat_registro_marc_n3',

    columns => [
        id                      => { type => 'serial', overflow => 'truncate', not_null => 1 },
        marc_record             => { type => 'text', overflow => 'truncate' },
        id1                     => { type => 'integer', overflow => 'truncate', not_null => 1 },
        id2                     => { type => 'integer', overflow => 'truncate', not_null => 1 },
        codigo_barra            => { type => 'varchar', overflow => 'truncate', not_null => 1 },
        signatura               => { type => 'varchar', overflow => 'truncate' },
        updated_at              => { type => 'timestamp', not_null => 1 },
        created_at              => { type => 'timestamp' },
        created_by              => { type => 'integer', overflow => 'truncate', not_null => 1 },
        agregacion_temp         => { type => 'varchar', overflow => 'truncate' },
        template                => { type => 'varchar', overflow => 'truncate', not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],

    relationships => [
        nivel1  => {
            class       => 'C4::Modelo::CatRegistroMarcN1',
            key_columns => { id1 => 'id' },
            type        => 'one to one',
        },

        nivel2  => {
            class       => 'C4::Modelo::CatRegistroMarcN2',
            key_columns => { id2 => 'id' },
            type        => 'one to one',
        },
    ],
);

=head2
    sub agregar
=cut
sub agregar {
    my ($self) = shift;
    my ($db, $params, $msg_object)   = @_;

    my $dateformat = C4::Date::get_date_format();

    $self->setId2($params->{'id2'});
    $self->setId1($params->{'id1'});
    my $marc_record = MARC::Record->new_from_usmarc($params->{'marc_record'});

    $self->setCodigoBarra($marc_record->subfield("995","f"));
    $self->setSignatura($marc_record->subfield("995","t"));
    $self->setCreatedAt(C4::Date::format_date_in_iso(Date::Manip::ParseDate("now"), $dateformat));
    if($params->{'responsable'}){
        C4::AR::Debug::debug("RESPONSABLE!!!!!!!!!! ". $params->{'responsable'});
        my ($socio)     = C4::AR::Usuarios::getSocioInfoPorNroSocio($params->{'responsable'});
        if ($socio) {
            $self->setCreatedBy($socio->getId_socio());
        }
    }

    $self->setMarcRecord($params->{'marc_record'});
    $self->setTemplate($params->{'id_tipo_doc'});

    C4::AR::Debug::debug("CatRegistroMarcN3 => agregar => tipo de ejemplar => ".$params->{'tipo_ejemplar'});
    my ($MARC_result_array) = C4::AR::Catalogacion::marc_record_to_meran($marc_record, $params->{'tipo_ejemplar'});

    $self->validar($msg_object, $MARC_result_array, $params, 'INSERT', $db);

    if(!$msg_object->{'error'}){
        if ( (($self->estadoCompartido) || (!C4::AR::Nivel3::existeBarcode($self->getCodigoBarra()))) && (C4::AR::Utilidades::validateString($self->getIdEstado)) ){
            $self->save();
            $params->{'id_ui'}                     = $self->getId_ui_poseedora();
            $params->{'id3'}                       = $self->getId3();
            $params->{'estado_nuevo'}              = $self->getIdEstado();          #(DISPONIBLE, "NO DISPONIBLES" => BAJA, COMPARTIDO, etc)
            $params->{'disponibilidad_nueva'}      = $self->getIdDisponibilidad(); #(DISPONIBLE, PRESTAMO, SALA LECTURA)

            # verificar_alta
            $self->verificar_alta($db, $params, $msg_object);
        }else{
            $msg_object->{'error'} = 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U386', 'params' => [$self->getCodigoBarra()]} );
        }
    }
}

sub validar {
    my ($self)           = shift;
    my ($msg_object, $MARC_array, $params, $action, $db)    = @_;

    C4::AR::Debug::debug("CatRegistroMarcN3 => validar => action => ".$action);

    $msg_object->{'error'} = 0;
    my $marc_record = MARC::Record->new_from_usmarc($params->{'marc_record'});

    foreach my $campo_hash_ref (@$MARC_array){

        my $subcampos_array = $campo_hash_ref->{'subcampos_array'};

        foreach my $subcampo_hash_ref (@{$subcampos_array}) {
#             C4::AR::Debug::debug("CatRegistroMarcN3 => validar => campo, subcampo ".$campo_hash_ref->{'campo'}.", ".$subcampo_hash_ref->{'subcampo'});


            if(($campo_hash_ref->{'campo'} eq '995')&&($subcampo_hash_ref->{'subcampo'} eq 'f')){
            #validaciones para el BARCODE
                $self->validarBarcode($msg_object, $subcampo_hash_ref, $action);
            } elsif(($campo_hash_ref->{'campo'} eq '995')&&($subcampo_hash_ref->{'subcampo'} eq 't')){
            #validaciones para la signatura topografica, la signatura es unica en el registro (no hay que chequear si el ejemplar es compartido)

                if ($self->seRepiteSignatura($subcampo_hash_ref->{'dato'}) && (! ESTADO_COMPARTIDO( C4::AR::Catalogacion::getRefFromStringConArrobas(C4::AR::Utilidades::trim($marc_record->subfield("995","e"))))) ) {
#                     C4::AR::Debug::debug("CatRegistroMarcN3 => validar => se repite la signatura");
                    $msg_object->{'error'} = 1;
                    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U417', 'params' => [$subcampo_hash_ref->{'dato'}]} ) ;
                }
            }
      }
    }# END foreach my $barcode (@$barcodes_array)

    my ($reservas_array_ref, $reservas_grupo) = C4::AR::Reservas::getReservasDeId2($self->getId2());
    $params->{'reservas_grupo'}               = $reservas_grupo;
    
    if (($action eq "UPDATE") && (!$self->se_puede_cambiar_disponibilidad($params, $db))) {
        C4::AR::Debug::debug("CatRegistroMarcN3 => validar => no se puede cambiar la disponibilidad ya que es el último ejemplar disponible y posee reservas");
        $msg_object->{'error'} = 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U428', 'params' => [$self->getCodigoBarra(),$reservas_grupo]}) ;
    }


    if($msg_object->{'error'}){
#         C4::AR::Debug::debug("CatRegistroMarcN3 => DATOS INVALIDOS!!!!");
    } else {
#         C4::AR::Debug::debug("CatRegistroMarcN3 => DATOS VALIDOS!!!!");
    }
}

sub validarBarcode {
    my ($self)                                      = shift;
    my ($msg_object, $subcampo_hash_ref, $action)   = @_;

    if ($action eq "INSERT") {

        if( !C4::AR::Utilidades::validateBarcode($subcampo_hash_ref->{'dato'}) ) {
            #el barcode ingresado no es valido
            C4::AR::Debug::debug("CatRegistroMarcN3 => validarBarcode => NO EXISTE EL BARCODE EN EL ARREGLO");
            $msg_object->{'error'} = 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U402', 'params' => [$subcampo_hash_ref->{'dato'}]} ) ;

        } elsif( !($msg_object->{'error'}) && (! $self->estadoCompartido) && C4::AR::Nivel3::existeBarcode($subcampo_hash_ref->{'dato'}) ){
            #verifico en el INSERT si el barcode existe en la base de datos (solo cuando el ejemplar no tiene estado COMPARTIDO)
            C4::AR::Debug::debug("CatRegistroMarcN3 => validarBarcode => el barcode ".$subcampo_hash_ref->{'dato'}." existe en la base");
            $msg_object->{'error'} = 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U386', 'params' => [$subcampo_hash_ref->{'dato'}]} );

        }

    } elsif ($action eq "UPDATE") {
        if ( !($msg_object->{'error'}) && (!C4::AR::Utilidades::validateString($subcampo_hash_ref->{'dato'})) ) {
            $msg_object->{'error'} = 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U387', 'params' => []} );
        }
        elsif( !($msg_object->{'error'}) && $self->seRepiteBarcode($subcampo_hash_ref->{'dato'}) ){
            #verifico en el UPDATE si el barcode existe en la base de datos
            C4::AR::Debug::debug("CatRegistroMarcN3 => validarBarcode => el barcode ".$subcampo_hash_ref->{'dato'}." existe en la base");
            $msg_object->{'error'} = 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U386', 'params' => [$subcampo_hash_ref->{'dato'}]} );

        } elsif( !($msg_object->{'error'}) && C4::AR::Prestamos::estaPrestado($self->getId3()) ){
            #verifico que el ejemplar no se encuentre reservado
            $msg_object->{'error'} = 1;
            C4::AR::Debug::debug("CatRegistroMarcN3 => validarBarcode => Se está intentando modificar un ejemplar que tiene un prestamo");
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'P125', 'params' => [$self->getId3()]} );
        }
    }
}


=item sub getTemplate

  retorna el esquema/template utilizado para la carga de datos
=cut
sub getTemplate{
    my ($self)  = shift;

#     return C4::AR::Referencias::obtenerEsquemaById($self->template);
    return $self->template;
}

sub setTemplate{
    my ($self)      = shift;
    my ($template)  = @_;

    $self->template($template);
}

sub getTemplateId{
    my ($self)  = shift;

    return $self->template;
}

=head2 sub seRepiteBarcode
Verifica si se repite el barcode, esto se usa cuandos se tiene q modificar
=cut
sub seRepiteBarcode {
    my ($self)      = shift;
    my($barcode)    = @_;

    my $nivel3 = C4::AR::Nivel3::getNivel3FromBarcode($barcode);

#     C4::AR::Debug::debug("CatRegistroMarcN3 => seRepiteBarcode => nivel_array_ref->getId3() => ".$nivel_array_ref->getId3()."  params->{'id3'} => ".$self->getId3());

    if ($nivel3 == 0){
    #no existe el barcode
        return 0;
    } else {
        if($nivel3->getId3() == $self->getId3()){
            #estoy modificando el mismo ejemplar
            C4::AR::Debug::debug("CatRegistroMarcN3 => seRepiteBarcode => estoy modificando el mismo ejemplar ");
            return 0;
        } else {
            #existe, hay que ver si estoy modificando el existente, si es asi esta bien
            C4::AR::Debug::debug("CatRegistroMarcN3 => seRepiteBarcode => estoy modificando otro ejemplar, SE REPITE ");
            return 1;
        }
    }
}

=item
    sub seRepiteSignatura

    Verifica si se repite la signatura topografica en otro registro, esto se usa cuando se tiene q modificar (aca hay que ignorar los que tienen estado compartido)
=cut
sub seRepiteSignatura {
    my ($self)      = shift;
    my ($signatura) = @_;

    my $sePermiteRepeticion = C4::AR::Preferencias::getValorPreferencia("se_permite_repetir_signatura");

    if (!$sePermiteRepeticion){
        my @filtros;
        my $existe = 0;

        push(@filtros, ( id1        => { ne => $self->getId1() }) ); #Saco los del mismo registro
        push(@filtros, ( id1        => { ne => C4::Modelo::RefEstado::estadoDisponibleValue()})); #Saco los compartidos
        push(@filtros, ( signatura  => { eq => $signatura }));

        my $nivel3_array_ref = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3( query => \@filtros );

        $existe = scalar (@$nivel3_array_ref);

        C4::AR::Debug::debug("CatRegistroMarcN3 => seRepiteSignatura => EXISTE la signatura? => ".$existe);

        return $existe;
    }else{
        return 0;
    }
}


=item
    sub se_puede_cambiar_disponibilidad
    Verifica si tiene reservas, se intenta cambiar la disponibilidad a no disponible y no hay otro ejemplar disponible 
=cut
sub se_puede_cambiar_disponibilidad {
    my ($self)      = shift;
    my ($params, $db)    = @_;

    my $estado_anterior             = $params->{'estado_anterior'};          #(DISPONIBLE, "NO DISPONIBLES" => BAJA, COMPARTIDO, etc)
    my $estado_nuevo                = $params->{'estado_nuevo'};
    my $disponibilidad_anterior     = $params->{'disponibilidad_anterior'};  #(DISPONIBLE, PRESTAMO, SALA LECTURA)
    my $disponibilidad_nueva        = $params->{'disponibilidad_nueva'};
    my $reservas_grupo              = $params->{'reservas_grupo'};
    
    C4::AR::Debug::debug("se_puede_cambiar_disponibilidad => estado_anterior: ".$params->{'estado_anterior'});
    C4::AR::Debug::debug("se_puede_cambiar_disponibilidad => estado_nuevo: ".$params->{'estado_nuevo'});
    C4::AR::Debug::debug("se_puede_cambiar_disponibilidad => disponibilidad_anterior: ".$params->{'disponibilidad_anterior'});
    C4::AR::Debug::debug("se_puede_cambiar_disponibilidad => disponibilidad_nueva: ".$params->{'disponibilidad_nueva'});
    
    if (ESTADO_DISPONIBLE($estado_anterior) && DISPONIBILIDAD_PRESTAMO($disponibilidad_anterior)){
        #Si estado_anterior es DISPONIBLE  y  su disponibilidad_anterior era PRESTAMO estaba disponible para préstamo
        C4::AR::Debug::debug("se_puede_cambiar_disponibilidad => Si estado_anterior es DISPONIBLE  y  su disponibilidad_anterior era PRESTAMO estaba disponible para préstamo");
        
        if (! ESTADO_DISPONIBLE($estado_nuevo) || DISPONIBILIDAD_PARA_SALA($disponibilidad_nueva)){
            #Si estado_nuevo es NO DISPONIBLE o su disponibilidad_nueva es PARA SALA dejó de estar disponible para préstamo
            C4::AR::Debug::debug("se_puede_cambiar_disponibilidad => Si estado_nuevo es NO DISPONIBLE o su disponibilidad_nueva es PARA SALA dejó de estar disponible para préstamo");
            
            my ($ejemplares_disponibles) = C4::AR::Reservas::getDisponibilidadDeGrupoParaPrestamoDomiciliario($db, $self->getId2());
            #Si es el único ejemplar para domicilio y hay reservas no se puede modificar y perder esa disponibilidad.
            if( ($ejemplares_disponibles == 1) && ($reservas_grupo != 0)){
                C4::AR::Debug::debug("se_puede_cambiar_disponibilidad => Es el único ejemplar para domicilio y hay reservas no se puede modificar y perder esa disponibilidad.");
                    return 0;
                }
            }
    }
    
    return 1;
}

sub modificar {
    my ($self)                      = shift;
    my ($db, $params, $msg_object)  = @_;

    my $MARC_result_array;
    my $edicion_grupal;
# FIXME no esta funcionando el currenttime de mysql
    $self->setUpdatedAt(Date::Manip::ParseDate("now"));
    my $marc_record_cliente = MARC::Record->new_from_usmarc($params->{'marc_record'}); #marc_record que viene del cliente
    my $marc_record_base    = MARC::Record->new_from_usmarc($self->getMarcRecord());

    # verificar_cambio
    $params->{'id_ui'}                      = $self->getId_ui_poseedora();
    $params->{'id3'}                        = $self->getId3();
    $params->{'estado_anterior'}            = $self->getIdEstado();         #(DISPONIBLE, "NO DISPONIBLES" => BAJA, COMPARTIDO, etc)
    $params->{'estado_nuevo'}               = C4::AR::Catalogacion::getRefFromStringConArrobas(C4::AR::Utilidades::trim($marc_record_cliente->subfield("995","e")));
    $params->{'disponibilidad_anterior'}    = $self->getIdDisponibilidad(); #(DISPONIBLE, PRESTAMO, SALA LECTURA)
    $params->{'disponibilidad_nueva'}       = C4::AR::Catalogacion::getRefFromStringConArrobas(C4::AR::Utilidades::trim($marc_record_cliente->subfield("995","o")));


    my $cat_estructura_catalogacion         = C4::AR::Catalogacion::getCamposNoEditablesEnGrupo(3);

    if($params->{'EDICION_N3_GRUPAL'}){
    #si es una edicion grupal no se permite editar el barcode 995,f
        foreach my $field ($marc_record_cliente->fields) {
                if(! $field->is_control_field){
                    #se verifica si el campo esta autorizado para el nivel que se estra procesando
                        foreach my $subfield ($field->subfields()){
                            my $dato        = $subfield->[1];
                            my $sub_campo   = $subfield->[0];

#                             C4::AR::Debug::debug("CatRegistroMarcN3 => modificar => campo     => ".$field->tag);
#                             C4::AR::Debug::debug("CatRegistroMarcN3 => modificar => subcampo  => ".$sub_campo);
#                             C4::AR::Debug::debug("CatRegistroMarcN3 => modificar => dato      => ".$dato);

                              if(permiteEdicionGrupal($field->tag, $sub_campo, $cat_estructura_catalogacion)){

                                if(($dato eq "")||($dato eq "-1")||($dato eq "NULL")||($dato =~ m/NULL/)){
#                                         C4::AR::Debug::debug("CatRegistroMarcN3 => modificar => el dato ".$dato." no fue modificado");
#                                     C4::AR::Debug::debug("CatRegistroMarcN3 => modificar => se mantiene el dato ".$marc_record_base->subfield($field->tag, $sub_campo)." de la base");
                                } else {
                                    #ahora se obtienen las referencias
                                    $dato = C4::AR::Catalogacion::_procesar_referencia($field->tag, $sub_campo, $dato, $self->nivel2->getTipoDocumento);
                                    $marc_record_base->field($field->tag)->update( $sub_campo => $dato );
                                }
                            }
                        }

                }
        }

        $self->setMarcRecord($marc_record_base->as_usmarc);
#         C4::AR::Debug::debug("CatRegistroMarcN3 => modificar => marc_record as_usmarc para la base ".$marc_record_base->as_usmarc);
        ($MARC_result_array) = C4::AR::Catalogacion::marc_record_to_meran(MARC::Record->new_from_usmarc($marc_record_base->as_usmarc), $params->{'tipo_ejemplar'});

    } else {
        $self->setMarcRecord($params->{'marc_record'});
        ($MARC_result_array) = C4::AR::Catalogacion::marc_record_to_meran(MARC::Record->new_from_usmarc($params->{'marc_record'}), $params->{'tipo_ejemplar'});
    }

    $self->setCodigoBarra($marc_record_cliente->subfield("995","f"));
    $self->setSignatura($marc_record_cliente->subfield("995","t"));

#    C4::AR::Debug::debug("CatRegistroMarcN3 => modificar => self->getId3() => ANTES ".$self->getId3());

    $self->validar($msg_object, $MARC_result_array, $params, 'UPDATE', $db);

    if(!$msg_object->{'error'}){
        $self->save();

        $self->verificar_cambio($db, $params, $msg_object);
        $self->verificar_historico_disponibilidad($db, $params);
    }

#     C4::AR::Debug::debug("CatRegistroMarcN3 => modificar => self->getId3() DESPUES => ".$self->getId3());
}

sub permiteEdicionGrupal {
    my ($campo, $subcampo, $cat_estructura_catalogacion) = @_;

    my $edicion_grupal = 1;
    foreach my $cat (@$cat_estructura_catalogacion){
          if ( ($campo eq $cat->{'campo'}) && ($subcampo eq $cat->{'subcampo'}) ){
              $edicion_grupal = 0;
            C4::AR::Debug::debug("CatRegistroMarcN3 => permiteEdicionGrupal => el campo, subcampo ".$campo.", ".$subcampo." NO PERMITE EDICION_GRUPAL");
              last;
          }
    }

    return $edicion_grupal;
}

=head2
    sub eliminar
=cut
sub eliminar{
    my ($self)      = shift;
    my ($params)    = @_;

    #HACER ALGO SI ES NECESARIO

    $self->delete();
}

=head2
sub getId3

Obteniendo el id del elemento
=cut


sub getId{
    my ($self)  = shift;

    return $self->id;
}

# Se ponen 2 por compatibilidad

sub getId3{
    my ($self)  = shift;

    return $self->id;
}

=head2
sub getId2

Obteniendo el id2 al que pertenece el elemento de nivel3
=cut


sub getId2{
    my ($self)  = shift;

    return $self->id2;
}


sub getCreatedAt{
    my ($self)  = shift;

    return $self->created_at;
}

sub setCreatedAt{
    my ($self)  = shift;
    my ($now)   = @_;

    $self->created_at($now);
}

sub getCreatedBy{
    my ($self)  = shift;

    return $self->created_by;
}

sub getCreatedByToString {
    my ($self)  = shift;

    my ($socio) = C4::AR::Usuarios::getSocioInfo($self->getCreatedBy());

    if ($socio){
        return $socio->getNro_socio();
    } else {
        return "---";
    }
}

sub setCreatedBy{
    my ($self)  = shift;
    my ($user)   = @_;

    $self->created_by($user);
}

sub getUpdatedAt{
    my ($self)  = shift;

    return $self->updated_at;
}

sub getCreatedAt_format{
    my ($self)  = shift;

    use DateTime::Format::MySQL;
    my $dateformat = C4::Date::get_date_format();
    my $date = $self->getCreatedAt;

    eval{
        $date = DateTime::Format::MySQL->format_datetime($date);
        my @time_array = split(/ /,$date);
        my $time = @time_array[1];
        $date = C4::Date::format_date($date,$dateformat);
        $date = $date." ".$time;
    };

    if (@$){
        $date = undef;
    }

    return ($date);
}

sub getUpdatedAt_format{
    my ($self)  = shift;

    use DateTime::Format::MySQL;
    my $dateformat = C4::Date::get_date_format();
    my $date = $self->getUpdatedAt;

    eval{
        $date = DateTime::Format::MySQL->format_datetime($date);
        my @time_array = split(/ /,$date);
        my $time = @time_array[1];
        $date = C4::Date::format_date($date,$dateformat);
        $date = $date." ".$time;
    };

    if (@$){
        $date = undef;
    }

    return ($date);
}


sub setUpdatedAt{
    my ($self)  = shift;
    my ($now)   = @_;

    $self->updated_at($now);
}

=head2
sub getId1

Obteniendo el id1 al que pertenece el elemento de nivel3
=cut


sub getId1{
    my ($self)  = shift;

    return $self->id1;
}

=head2
sub getId1

Setea el id1 al que pertenece el elemento de nivel3
=cut

sub setId1{
    my ($self)  = shift;
    my ($id1)   = @_;

    $self->id1($id1);
}

=head2
sub setId2

Setea el id2 al que pertenece el elemento de nivel3
=cut

sub setId2{
    my ($self)  = shift;
    my ($id2)   = @_;

    $self->id2($id2);
}


sub setCodigoBarra{
    my ($self)  = shift;
    my ($codigo_barra)   = @_;

    $codigo_barra = C4::AR::Utilidades::trim($codigo_barra);

    if (C4::AR::Utilidades::validateString($codigo_barra)){
        $self->codigo_barra($codigo_barra);
    }
}

sub setSignatura{
    my ($self)  = shift;
    my ($signatura)   = @_;

    $self->signatura($signatura);
}

sub getCodigoBarra{
    my ($self) = shift;
    return $self->codigo_barra;
}

sub getSignatura{
    my ($self) = shift;
    return $self->signatura;
}

sub getMarcRecord{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->marc_record));
}

sub getMarcRecordObject{
    my ($self) = shift;
    return (MARC::Record->new_from_usmarc($self->getMarcRecord()));
}


sub setMarcRecord{
    my ($self)          = shift;
    my ($marc_record)   = @_;

    $self->marc_record($marc_record);
}

sub getBarcode{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

    return C4::AR::Utilidades::trim($marc_record->subfield("995","f"));
}

sub getSignatura_topografica{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

    return C4::AR::Utilidades::trim($marc_record->subfield("995","t"));
}

sub getSignatura_topograficaEscaped {
    my ($self)      = shift;
    my $signatura = $self->getSignatura_topografica();
    return C4::AR::Utilidades::escapeData($signatura);
}

sub getId_ui_origen{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());
    my $ref         = C4::AR::Catalogacion::getRefFromStringConArrobas($marc_record->subfield("995","d"));

    return C4::AR::Utilidades::trim($ref);
}

sub getId_ui_poseedora{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());
    my $ref         = C4::AR::Catalogacion::getRefFromStringConArrobas(C4::AR::Utilidades::trim($marc_record->subfield("995","c")));

    return C4::AR::Utilidades::trim($ref);
}

sub getId_ui {
    my ($self)      = shift;

    my $id_ui =  C4::AR::Utilidades::trim($self->getId_ui_poseedora());
    if ($id_ui){
        return  $id_ui;
    }
    $id_ui =  C4::AR::Utilidades::trim($self->getId_ui_origen());
    if ($id_ui){
        return $id_ui;
    }
    return C4::AR::Preferencias::getValorPreferencia("defaultUI");
}



=head2 sub getIdEstado
=cut
sub getIdEstado{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

    return C4::AR::Catalogacion::getRefFromStringConArrobas(C4::AR::Utilidades::trim($marc_record->subfield("995","e")));
}


=head2 sub getEstadoObject
=cut
sub getEstadoObject{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());
    my $ref         = $self->getIdEstado();

    my $estado      = C4::Modelo::RefEstado->getByPk($self->getIdEstado());

    if(!$estado){
            C4::AR::Debug::debug("CatRegistroMarcN3 => getEstadoObject()=> EL OBJECTO (ID) RefEstado NO EXISTE");
            $estado = C4::Modelo::RefEstado->new();
    }

    return $estado;
}

sub getNota{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

    return C4::AR::Utilidades::escapeData(C4::AR::Utilidades::trim($marc_record->subfield("995","u")));
}

sub getEstadoFromMarcrecord{

}

=head2 sub getIdDisponibilidad
=cut
sub getIdDisponibilidad{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

    return C4::AR::Catalogacion::getRefFromStringConArrobas(C4::AR::Utilidades::trim($marc_record->subfield("995","o")));
}


=head2 sub getDisponibilidadObject
=cut
sub getDisponibilidadObject{
    my ($self)              = shift;

    my $marc_record         = MARC::Record->new_from_usmarc($self->getMarcRecord());
#     my $ref                 = C4::AR::Catalogacion::getRefFromStringConArrobas($self->getIdDisponibilidad());


    my $disponibilidad      = C4::Modelo::RefDisponibilidad->getByPk($self->getIdDisponibilidad());

    if(!$disponibilidad){
            C4::AR::Debug::debug("CatRegistroMarcN3 => getDisponibilidadObject()=> EL OBJECTO (ID) RefDisponibilidad NO EXISTE");
            $disponibilidad = C4::Modelo::RefDisponibilidad->new();
    }

    return $disponibilidad;
}


=head2 sub estaReservado
    Verifica si el ejemplar se encuentra reservado o no
=cut
sub estaReservado {
    my ($self) = shift;

    return C4::AR::Reservas::estaReservado($self->getId3);
}


=head2  sub estaPrestado
=cut
sub estaPrestado {
    my ($self) = shift;

    return (C4::AR::Prestamos::estaPrestado($self->getId3));
}

=head2  sub getEstado
=cut
sub getEstado{
    my ($self) = shift;

    my $estado_object = C4::Modelo::RefEstado->getByPk($self->getIdEstado());

    if($estado_object){
        return C4::AR::Utilidades::trim($estado_object->getNombre());
    }

    C4::AR::Debug::debug("CatRegistroMarcN3 => getEstado => NO EXISTE EL ID ESTADO QUE SE INTENTA RECUPERAR ".$self->getIdEstado);
    return ('');
}


=head2 sub estadoCompartido

=cut
sub estadoCompartido{
    my ($self) = shift;

    return (ESTADO_COMPARTIDO($self->getIdEstado()));
}

=head2 sub estadoDisponible

=cut
sub estadoDisponible{
    my ($self) = shift;

#     return (C4::Modelo::RefEstado->getByPk($self->getIdEstado())->getNombre() eq "Disponible");
    # C4::AR::Debug::debug("CatRegistroMarcN3 => getIdEstado => ".$self->getIdEstado());
    return (ESTADO_DISPONIBLE($self->getIdEstado()));
}

=head2 sub esParaSala
=cut
sub esParaSala{
    my ($self) = shift;

#     return (C4::Modelo::RefDisponibilidad->getByPk($self->getIdDisponibilidad)->getNombre() eq "Sala de Lectura");
    return (DISPONIBILIDAD_PARA_SALA($self->getIdDisponibilidad));
}

=head2 sub esParaPrestamo
=cut
sub esParaPrestamo{
    my ($self) = shift;

    return (DISPONIBILIDAD_PRESTAMO($self->getIdDisponibilidad));
}

=head2 sub toMARC

=cut
sub toMARC{
    my ($self) = shift;

    #obtengo el marc_record del NIVEL 3
    my $marc_record             = MARC::Record->new_from_usmarc($self->getMarcRecord());

    my $params;
    $params->{'nivel'}          = '3';
    $params->{'id_tipo_doc'}    = $self->getTemplate()||'ALL';
    my $MARC_result_array       = &C4::AR::Catalogacion::marc_record_to_meran_por_nivel($marc_record, $params);

    return ($MARC_result_array);
}



=head2 sub toMARC_Opac
    se utiliza para la visualizacion del detalle en el OPAC
=cut
sub toMARC_Opac{
    my ($self) = shift;

    #obtengo el marc_record del NIVEL 3
    my $marc_record             = MARC::Record->new_from_usmarc($self->getMarcRecord());


    my $params;
    $params->{'nivel'}          = '3';
    $params->{'id_tipo_doc'}    = $self->getTemplate()||'ALL';
    my $MARC_result_array       = &C4::AR::Catalogacion::marc_record_to_opac_view($marc_record, $params);

    return ($MARC_result_array);
}


=head2 sub toMARC_Intra
    se utiliza para la visualizacion del detalle en la INTRA
=cut
sub toMARC_Intra{
    my ($self) = shift;

    #obtengo el marc_record del NIVEL 3
    my $marc_record             = MARC::Record->new_from_usmarc($self->getMarcRecord());


    my $params;
    $params->{'nivel'}          = '3';
    $params->{'id_tipo_doc'}    = $self->getTemplate()||'ALL';
    my $MARC_result_array       = C4::AR::Catalogacion::marc_record_to_intra_view($marc_record, $params,$self->db);

    return ($MARC_result_array);
}

########## CODIGOS DE DISPONIBILIDAD #############
# Baja = STATE000
# Compartido = STATE001
# Disponible = STATE002
# Ejemplar deteriorado = STATE003
# En Encuadernación = STATE004
# Perdido = STATE005
# En etiquetado = STATE0006
# En impresiones = STATE007
# En procesos técnicos = STATE008
##################################################

sub ESTADO_DISPONIBLE{
   my ($estado) = @_;

    # C4::AR::Debug::debug("CatRegistroMarcN3 => ESTADO_DISPONIBLE => ==".C4::Modelo::RefEstado::estadoDisponibleValue()."==> ".($estado eq C4::Modelo::RefEstado::estadoDisponibleValue()));
   return ($estado eq C4::Modelo::RefEstado::estadoDisponibleValue());
}

sub ESTADO_COMPARTIDO {

    my ($estado) = @_;
    return ($estado eq C4::Modelo::RefEstado::estadoCompartidoValue());
}

=item
DISPONIBILIDAD

    CIRC0000   Prestamo
    CIRC0001   Sala de Lectura
=cut

sub DISPONIBILIDAD_PRESTAMO{
    my ($disponibilidad) = @_;

    return ($disponibilidad eq C4::Modelo::RefDisponibilidad::paraPrestamoValue());
}

sub DISPONIBILIDAD_PARA_SALA{
    my ($disponibilidad) = @_;

    return ($disponibilidad eq C4::Modelo::RefDisponibilidad::paraSalaValue());
}

sub verificar_cambio {
    my ($self) = shift;

    my ($db, $params,$msg_object) = @_;

    my $estado_anterior             = $params->{'estado_anterior'};          #(DISPONIBLE, "NO DISPONIBLES" => BAJA, COMPARTIDO, etc)
    my $estado_nuevo                = $params->{'estado_nuevo'};
    my $disponibilidad_anterior     = $params->{'disponibilidad_anterior'};  #(DISPONIBLE, PRESTAMO, SALA LECTURA)
    my $disponibilidad_nueva        = $params->{'disponibilidad_nueva'};
    C4::AR::Debug::debug("verificar_cambio => estado_anterior: ".$params->{'estado_anterior'});
    C4::AR::Debug::debug("verificar_cambio => estado_nuevo: ".$params->{'estado_nuevo'});
    C4::AR::Debug::debug("verificar_cambio => disponibilidad_anterior: ".$params->{'disponibilidad_anterior'});
    C4::AR::Debug::debug("verificar_cambio => disponibilidad_nueva: ".$params->{'disponibilidad_nueva'});

    #  ESTADOS
    #  Disponible  = STATE002 => DISPONIBLE
    #  Disponible != STATE002 => NO DISPONIBLE

    #  DISPONIBILIDADES
    # CIRC0000   Prestamo
    # CIRC0001   Sala de Lectura

    if( ESTADO_DISPONIBLE($estado_anterior) && (!ESTADO_DISPONIBLE($estado_nuevo)) && DISPONIBILIDAD_PRESTAMO($disponibilidad_anterior) ){
    #pasa de NO DISPONIBLE a DISPONIBLE con disponibilidad_anterior PRESTAMO
    #Si estado_anterior es DISPONIBLE y estado_nuevo es NO DISPONIBLE y disponibilidad_anterior es PARA PRESTAMO
    #hay que reasignar las reservas que existen para el ejemplar, si no se puede reasignar se eliminan las reservas y sanciones
        C4::AR::Debug::debug("verificar_cambio => DISPONIBLE a NO DISPONIBLE con disponibilidad anterior PRESTAMO ==> reasignarNuevoEjemplarAReserva");
        C4::AR::Reservas::reasignarNuevoEjemplarAReserva($db, $params, $msg_object);

    }elsif ( (!ESTADO_DISPONIBLE($estado_anterior)) && ESTADO_DISPONIBLE($estado_nuevo) && DISPONIBILIDAD_PRESTAMO($disponibilidad_nueva) ){
    #pasa de DISPONIBLE a NO DISPONIBLE con disponibilidad_nueva PRESTAMO
    #Si estado_anterior es NO DISPONIBLE  y  estado_nuevo es DISPONIBLE  y  disponibilidad_nueva es PRESTAMO
    #hay que verificar si hay reservas en espera, si hay se reasignan al nuevo ejemplar
        C4::AR::Debug::debug("verificar_cambio => NO DISPONIBLE a DISPONIBLE con disponibilidad nueva PRESTAMO ==> asignarEjemplarASiguienteReservaEnEspera");
        C4::AR::Reservas::asignarEjemplarASiguienteReservaEnEspera($params, $db);

    }elsif ( ESTADO_DISPONIBLE($estado_anterior) && DISPONIBILIDAD_PRESTAMO($disponibilidad_anterior) &&
             DISPONIBILIDAD_PARA_SALA($disponibilidad_nueva) ){
    #Si estaba DISPONIBLE y pasa de disponibilidad_anterior PRESTAMO a disponibilidad_nueva SALA
    #hay que verificar si tiene reservas, si tiene se reasignan si no se puden reasignar se cancelan
        C4::AR::Debug::debug("verificar_cambio => DISPONIBLE de disponibilidad anterior PRESTAMO a disponibilidad nueva PARA SALA ==> reasignarNuevoEjemplarAReserva");
        C4::AR::Reservas::reasignarNuevoEjemplarAReserva($db, $params, $msg_object);

    }elsif ( ESTADO_DISPONIBLE($estado_anterior) && DISPONIBILIDAD_PARA_SALA($disponibilidad_anterior) &&
             DISPONIBILIDAD_PRESTAMO($disponibilidad_nueva) ){
    #Si estaba DISPONIBLE y pasa de disponibilidad_anterior PARA SALA a disponibilidad_nueva PRESTAMO
    #Se verifica si hay reservas en espera, si hay se reasignan al nuevo ejemplar
        C4::AR::Debug::debug("verificar_cambio => DISPONIBLE de disponibilidad anterior PARA SALA a disponibilidad nueva PRESTAMO => asignarEjemplarASiguienteReservaEnEspera");
        C4::AR::Reservas::asignarEjemplarASiguienteReservaEnEspera($params, $db);
    }


    #verifico la disponibilidad del grupo, se deben cancelar las reservas si no existe ejemplar disponible para prestamo domiciliario
    C4::AR::Reservas::manejoDeDisponibilidadDomiciliaria($db, $params);

}

sub verificar_alta {
    my ($self) = shift;

    my ($db, $params, $msg_object) = @_;

    my $estado_nuevo                = $params->{'estado_nuevo'};
    my $disponibilidad_nueva        = $params->{'disponibilidad_nueva'};
    C4::AR::Debug::debug("verificar_alta => estado_nuevo: ".$params->{'estado_nuevo'});
    C4::AR::Debug::debug("verificar_alta => disponibilidad_nueva: ".$params->{'disponibilidad_nueva'});

    #  ESTADOS
    #   wthdrawn = 0 => DISPONIBLE
    #   wthdrawn > => NO DISPONIBLE

    #  DISPONIBILIDADES
    #   notforloan = 1 => PARA SALA
    #   notforload = 0 => PARA PRESTAMO

    if ( ESTADO_DISPONIBLE($estado_nuevo) && DISPONIBILIDAD_PRESTAMO($disponibilidad_nueva) ){
    #se agrega un ejemplar NUEVO con estado_nuevo es DISPONIBLE  y  disponibilidad_nueva es PRESTAMO
    #hay que verificar si hay reservas en espera, si hay se reasignan al nuevo ejemplar
        C4::AR::Debug::debug("verificar_alta => nuevo ejemplar con estado DISPONIBLE y disponibilidad PRESTAMO ==> asignarEjemplarASiguienteReservaEnEspera");
        C4::AR::Reservas::asignarEjemplarASiguienteReservaEnEspera($params, $db);

    }
}

sub getUiPoseedoraName{
    my ($self) = shift;

    use C4::AR::Referencias;


    return C4::AR::Referencias::obtenerUIByIdUi($self->getId_ui_poseedora)->getNombre;
}

sub getUiOrigenName{
    my ($self) = shift;

    use C4::AR::Referencias;


    return C4::AR::Referencias::obtenerUIByIdUi($self->getId_ui_origen)->getNombre;
}

sub verificar_historico_disponibilidad {
    my ($self) = shift;

    my ($db, $params) = @_;

    my $estado_anterior             = $params->{'estado_anterior'};          #(DISPONIBLE, "NO DISPONIBLES" => BAJA, COMPARTIDO, etc)
    my $estado_nuevo                = $params->{'estado_nuevo'};
    my $disponibilidad_anterior     = $params->{'disponibilidad_anterior'};  #(DISPONIBLE, PRESTAMO, SALA LECTURA)
    my $disponibilidad_nueva        = $params->{'disponibilidad_nueva'};

    #  ESTADOS
    #   wthdrawn = 0 => DISPONIBLE
    #   wthdrawn > => NO DISPONIBLE

    #  DISPONIBILIDADES
    #   notforloan = 1 => PARA SALA
    #   notforload = 0 => PARA PRESTAMO

    if(($estado_anterior ne $estado_nuevo) || ($disponibilidad_anterior ne $disponibilidad_nueva)){
        #cambió algo, hay que guardar en el histórico de disponibilidad el cambio de estado
        C4::AR::Debug::debug("verificar_historico_disponibilidad => CAMBIO");
        my $catHistoricoDisponibilidad      = C4::Modelo::CatHistoricoDisponibilidad->new(db => $db);

        my $estado      = C4::Modelo::RefEstado->getByPk($estado_nuevo);
        $params->{'detalle'} = $estado->getNombre();

        my $disponibilidad      = C4::Modelo::RefDisponibilidad->getByPk($disponibilidad_nueva);
        $params->{'tipo_prestamo'} = $disponibilidad->getNombre();
        $params->{'id3'} = $self->getId3();
        $catHistoricoDisponibilidad->agregar($params);
    }
}

sub getInvolvedCount{

    my ($self) = shift;
    my ($tabla, $value)= @_;

    my ($filter_string,$filtros) = $self->getInvolvedFilterString($tabla, $value);

    my $cat_registro_marc_n3_count = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3_count( query => $filtros, );

    return ($cat_registro_marc_n3_count);
}

sub getFechaUltimoCambioDisp{
    
    my ($self) = shift;
    
    my $fecha=C4::AR::Nivel3::getFechaUltimoCambioDisp($self->getId);

    return ($fecha->[0]->getTimestamp);
}

sub getReferenced{

    my ($self) = shift;
    my ($tabla, $value)= @_;

    my ($filter_string,$filtros) = $self->getInvolvedFilterString($tabla, $value);

    my $cat_registro_marc_n3 = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3( query => $filtros );

    return ($cat_registro_marc_n3);
}


=head2 sub getMarcRecordConDatos
    Construye un registro MARC con datos referenciados
=cut
sub getMarcRecordConDatos{
    my ($self) = shift;

    #obtengo el marc_record del NIVEL 3
    my $marc_record             = MARC::Record->new_from_usmarc($self->getMarcRecord());

    my $params;
    $params->{'nivel'}          = '3';
    $params->{'id_tipo_doc'}    = $self->getTemplate()||'ALL';

    my $MARC_record       = C4::AR::Catalogacion::marc_record_with_data($marc_record, $params->{'id_tipo_doc'}, $params->{'tipo'}, $params->{'nivel'});
    return ($MARC_record);
}


=head2 sub getMarcRecordConDatosForRobleExport
   Devuelve el registro con datos y los campos cambiados según el formato pedido por ROBLE 
   
   Inventario: 920^a  <<< 995f
   Ubicación topográfica: 920^b <<< 995t
   
=cut
sub getMarcRecordConDatosForRobleExport {
    my ($self) = shift;
    
    my $marc_record_n3 = MARC::Record->new();
    my $field_920  = MARC::Field->new("920","","","a" => $self->getCodigoBarra() );
       $field_920->add_subfields("b" => $self->getSignatura_topografica());
       $marc_record_n3->append_fields($field_920);
       return $marc_record_n3;
}

1;
