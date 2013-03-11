package C4::Modelo::CatEstructuraCatalogacion;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'cat_estructura_catalogacion',

    columns => [
        id                  => { type => 'serial', overflow => 'truncate', not_null => 1 },
        campo               => { type => 'character', overflow => 'truncate', length => 3, not_null => 1 },
        subcampo            => { type => 'character', overflow => 'truncate', length => 1, not_null => 1 },
        itemtype            => { type => 'varchar', overflow => 'truncate', length => 8, not_null => 1 },
        liblibrarian        => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1 },
        rules               => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 0 },
        tipo                => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1 },
        referencia          => { type => 'integer', overflow => 'truncate', default => '0', not_null => 1 },
        nivel               => { type => 'integer', overflow => 'truncate', not_null => 1 },
        obligatorio         => { type => 'integer', overflow => 'truncate', default => '0', not_null => 1 },
        intranet_habilitado => { type => 'integer', overflow => 'truncate', default => '1' },
        visible             => { type => 'integer', overflow => 'truncate', default => 1, not_null => 1 },
        edicion_grupal      => { type => 'integer', overflow => 'truncate', default => 1, not_null => 1 },
#         repetible           => { type => 'integer', overflow => 'truncate', default => 1},
        idinforef           => { type => 'integer', overflow => 'truncate', length => 11, not_null => 0 },
# NO SE USA MAS, AL USAR MARC_RECORD
#         grupo               => { type => 'integer', overflow => 'truncate', length => 11, not_null => 0 },
        idCompCliente       => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1 },
        fijo                => { type => 'integer', overflow => 'truncate', length => 1, not_null => 1 },  #modificable = 0 / no modificable = 1
    ],

    
    primary_key_columns => [ 'id' ],

    relationships =>
    [
        tipoItem => 
        {
            class       => 'C4::Modelo::CatRefTipoNivel3',
            key_columns => { itemtype => 'id_tipo_doc' },
            type        => 'one to one',
        },
    
        infoReferencia => 
        {
            class       => 'C4::Modelo::PrefInformacionReferencia',
            key_columns => { idinforef=> 'idinforef' },
            type        => 'one to one',
        },

        camposBase      => 
        {
            class       => 'C4::Modelo::PrefEstructuraCampoMarc',
            key_columns => { campo => 'campo' },
            type        => 'one to one',
        },

        subCamposBase => 
        {
            class       => 'C4::Modelo::PrefEstructuraSubcampoMarc',
            key_columns => { campo => 'campo',
                             subcampo => 'subcampo' },
            type        => 'one to one',
        },
    ]

);
use Switch;
use utf8;
use Digest::MD5 qw(md5_hex);
use C4::Modelo::PrefInformacionReferencia;



sub agregar{
    my ($self)      = shift;
    my ($data_hash) = @_;

    #recupero la configuracion de la estructura de catalogacion para verificar si ya existe una configuracion anterior 
    #que se encuentre NO VISIBLE

#     my $estructura_array = C4::AR::Catalogacion::_getEstructuraFromCampoSubCampo(
#                                                                                     $data_hash->{'campo'},
#                                                                                     $data_hash->{'subcampo'},
#                                                                                     $data_hash->{'itemtype'}||'ALL',
#                                                                                     $data_hash->{'nivel'},
#                                                                                     $self->db,
#                                                                             );

    my $estructura_array = C4::AR::Catalogacion::_existeConfiguracionEnCatalogo(
                                                                                    $data_hash->{'campo'},
                                                                                    $data_hash->{'subcampo'},
                                                                                    $data_hash->{'itemtype'}||'ALL',
                                                                                    $data_hash->{'nivel'},
                                                                                    $self->db,
                                                                            );


#     if($estructura_array) {
#         #EXISTE configuracion para campo, subcampo, itemtype
#         $estructura_array->setVisible(1); #se setea como VISIBLE
#         $estructura_array->save();
#         C4::AR::Debug::debug("El campo, subcampo, itemtype ".$data_hash->{'campo'}.", ".$data_hash->{'subcampo'}.", ".$data_hash->{'itemtype'}." EXISTE");
#     } else {
        #NO EXISTE configuracion para campo, subcampo, itemtype
        $self->setCampo($data_hash->{'campo'});
        $self->setSubcampo($data_hash->{'subcampo'});
        $self->setItemType($data_hash->{'itemtype'}||'ALL');
        $self->setLiblibrarian($data_hash->{'liblibrarian'});
        $self->setRule($data_hash->{'combo_validate'});
        $self->setTipo($data_hash->{'tipoInput'});
        $self->setReferencia($data_hash->{'referencia'});
        $self->setNivel($data_hash->{'nivel'});
        $self->setObligatorio($data_hash->{'obligatorio'});
        # FIXME el grupo ya no seria necesario al usar marc_record
#         $self->setGrupo($self->getNextGroup);
        $self->setIntranet_habilitado($self->getUltimoIntranetHabilitado($self->getItemType)+1 );
        $self->setVisible($data_hash->{'visible'});
        # FIXME ya no sería necesario, el id se genera en el cliente
        $self->setIdCompCliente(md5_hex(time()));
        $self->setFijo(0); #por defecto, todo lo que se ingresa como estructura del catalogo NO ES FIJO
        $self->save();
   

        if ($data_hash->{'referencia'}) {
            #es necesario informacion de referencia se crea una nueva
            $data_hash->{'id_est_cat'}  = $self->id;
            my $pref_temp = C4::Modelo::PrefInformacionReferencia->new(db => $self->db);
            $pref_temp->agregar($data_hash);
            $pref_temp->save();

            $self->setIdInfoRef($pref_temp->getIdInfoRef);
        }

        $self->save();

#     }

} 

sub getNextGroup{
    my $dbh = C4::Context->dbh;

    my $sth = $dbh->prepare(" SELECT MAX(grupo) AS grupo
                              FROM cat_estructura_catalogacion ");

    $sth->execute();
    my $data = $sth->fetchrow_hashref;

    return $data->{'grupo'} + 1;
}

sub modificar{

    my ($self)=shift;
    my ($data_hash)=@_;

    if (!$self->soyFijo){
        $self->setItemType($data_hash->{'itemtype'});
        $self->setObligatorio($data_hash->{'obligatorio'});
        $self->setLiblibrarian($data_hash->{'liblibrarian'});
        $self->setRule($data_hash->{'combo_validate'});
        $self->setTipo($data_hash->{'tipoInput'});
        $self->setReferencia($data_hash->{'referencia'});
        $self->setNivel($data_hash->{'nivel'});

        #verifico si tiene informacion de referencia, si la tiene la elimino
        my $pref_info_ref = C4::AR::Referencias::getInformacionReferenciaFromId($self->db, $self->getIdInfoRef);

        if ($pref_info_ref) {
            #tiene informacion de referencia, se modifican los datos
            $pref_info_ref->delete();
            $self->setIdInfoRef(0);                
        }

        if ($data_hash->{'referencia'}) {
            #es necesario informacion de referencia se crea una nueva
            $data_hash->{'id_est_cat'}  = $self->id;
            my $pref_temp = C4::Modelo::PrefInformacionReferencia->new(db => $self->db);
            $pref_temp->agregar($data_hash);
            $pref_temp->save();

            $self->setIdInfoRef($pref_temp->getIdInfoRef);
        }
    
        $self->save();
    }
}

sub delete{
    my $self = $_[0]; # Copy, not shift

    if ($self->soyFijo){
    #NO ESTA PERMITIDO ELIMINAR UNA TUPLA QUE SEA FIJA
    }else{
        $self->borrarYOrdenar();
    }
}



sub borrarYOrdenar{

    my ($self)=shift;

    my $siguientes_catalogaciones = C4::Modelo::CatEstructuraCatalogacion::Manager->update_cat_estructura_catalogacion( 
                                                            set => [
                                                                    intranet_habilitado=> { sql => 'intranet_habilitado -1'},
                                                            ],
                                                            where => [
                                                                    intranet_habilitado => { gt => $self->getIntranet_habilitado },
                                                                            nivel=> { eq => $self->getNivel},
                                                                            fijo => { eq => 1},
                                                            ],
                                                         );

    $self->realDelete();
}

sub realDelete{

    my ($self)=shift;

    $self->SUPER::delete();

}


=item
indica si la estructura de catalogacion tiene (=1) o no (=0) informacion de referencia
=cut
sub tieneReferencia{
    my ($self) = shift;

    return $self->getReferencia;
}

sub bajarAnterior{
        
    my ($self)=shift;
    my ($itemtype) = @_;
    my $catalogaciones = C4::Modelo::CatEstructuraCatalogacion::Manager->update_cat_estructura_catalogacion( 
                                                            set => [
                                                                    intranet_habilitado=> $self->getIntranet_habilitado,
                                                            ],
                                                            where => [
                                                                    intranet_habilitado => { eq => $self->getIntranet_habilitado-1 },
                                                                    nivel=> { eq => $self->getNivel},
                                                            ],
                                                         );
}

sub subirSiguiente{
        
    my ($self)=shift;
    my ($itemtype) = @_;
    my $catalogaciones = C4::Modelo::CatEstructuraCatalogacion::Manager->update_cat_estructura_catalogacion( 
                                                            set => [
                                                                    intranet_habilitado=> $self->getIntranet_habilitado,
                                                            ],
                                                            where => [
                                                                    intranet_habilitado => { eq => $self->getIntranet_habilitado+1 },
                                                                     nivel=> { eq => $self->getNivel},

                                                            ],
                                                         );
}


=item
subirOrden
Sube el orden en la vista, del campo seleccionado.
=cut

# FIXME esto no se va a usar mas, lo dejo para reusar en la visualizacion de la INTRA
sub subirOrden{
    my ($self)=shift;
    my ($itemtype) = @_;
    if (!($self->soyElPrimero)){
        $self->bajarAnterior();
        $self->setIntranet_habilitado($self->getIntranet_habilitado - 1);
        $self->save();
    }
}

=item
bajarOrden
Baja el orden en la vista, del campo seleccionado.
=cut
# FIXME esto no se va a usar mas, lo dejo para reusar en la visualizacion de la INTRA
sub bajarOrden{

    my ($self)=shift;
    my ($itemtype) = @_;
    if (!($self->soyElUltimo($itemtype))){
        $self->subirSiguiente($itemtype);
        $self->setIntranet_habilitado($self->getIntranet_habilitado + 1);
        $self->save();
    }
}

sub getUltimoIntranetHabilitado{

    my ($self)=shift;
    my ($itemtype) = @_;
    my $catalogaciones_count = C4::Modelo::CatEstructuraCatalogacion::Manager->get_cat_estructura_catalogacion_count( 
                                                            query => [
                                                                    or => [
                                                                            itemtype=> { eq => $itemtype},
                                                                            itemtype=> { eq => 'ALL'},
                                                                    ],
                                                                    nivel=> { eq => $self->getNivel},
                                                                ],
                                                        );

    return ($catalogaciones_count);
}



sub ultimoDelTipo{

    my ($self)=shift;
    my ($itemType)=@_;
       my $mismo_tipo = C4::Modelo::CatEstructuraCatalogacion::Manager->get_cat_estructura_catalogacion( 
                                                            query => [
                                                                    or => [
                                                                            itemtype=> { eq => $itemType},
                                                                            itemtype=> { eq => 'ALL'},
                                                                    ],
                                                                    nivel=> { eq => $self->getNivel},
                                                                   ],
                                                            sort_by => ['intranet_habilitado DESC'],
                                                            );

    return ($self->getIntranet_habilitado == $mismo_tipo->[0]->getIntranet_habilitado);
}


sub primeroDelTipo{

    my ($self)=shift;
    my ($itemType)=@_;
       my $mismo_tipo = C4::Modelo::CatEstructuraCatalogacion::Manager->get_cat_estructura_catalogacion( 
                                                            query => [or => [
                                                                            itemtype=> { eq => $itemType},
                                                                            itemtype=> { eq => 'ALL'},
                                                                    ],
                                                                           
                                                                            nivel=> { eq => $self->getNivel},
                                                                     ],
                                                            sort_by => ['intranet_habilitado ASC'],
                                                            );

    return ($self->getIntranet_habilitado == $mismo_tipo->[0]->getIntranet_habilitado);
}
=item
Esta funcion retorna 1 si es el ultimo en el orden a mostrar segun intranet_habilitado
=cut
sub soyElUltimo{
    my ($self)=shift;
    my ($itemtype) = @_;
    return ( ($self->intranet_habilitado == $self->getUltimoIntranetHabilitado($self->getItemType)) 
                                                        && 
                                            ($self->ultimoDelTipo)
            );
}


sub soyElPrimero{
    my ($self)=shift;
    return (($self->intranet_habilitado == 1));
}
=item
Esta funcion retorna 1 si la tupla es fija (no se puede modificar) 0  si no es fijo (se puede modificar)
=cut
sub soyFijo{
    my ($self)=shift;

    return ($self->getFijo);
}

sub getFijo{
    my ($self)=shift;

    return $self->fijo;
}

sub setFijo{
    my ($self) = shift;
    my ($fijo) = @_;
    $self->fijo($fijo);
}

sub getGrupo{
    my ($self)=shift;

    return $self->grupo;
}

sub setGrupo{
    my ($self) = shift;
    my ($grupo) = @_;
    $self->grupo($grupo);
}

sub getEdicionGrupal{
    my ($self) = shift;

    return $self->edicion_grupal;
}

sub setEdicionGrupal{
    my ($self) = shift;
    my ($flag) = @_;

    $self->edicion_grupal($flag);
}


sub cambiarVisibilidad{
    my ($self) = shift;

    $self->setVisible(!$self->getVisible);
    $self->save();
}

sub cambiarEdicionGrupal{
    my ($self) = shift;

    $self->setEdicionGrupal(!$self->getEdicionGrupal);
    $self->save();
}

sub cambiarHabilitado{
    my ($self) = shift;

    $self->setIntranet_habilitado(!$self->getHabilitado);
    $self->save();
}

sub defaultSort{
    return ("intranet_habilitado");
}

sub getId{
    my ($self) = shift;
    return ($self->id);
}

sub getCampo{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->campo));
}

sub setCampo{
    my ($self) = shift;
    my ($campo) = @_;
    $self->campo($campo);
}

sub getIdCompCliente{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->idCompCliente));
}

sub setIdCompCliente{
    my ($self) = shift;
    my ($IdCompCliente) = @_;
    $self->idCompCliente($IdCompCliente);
}

# FIXME hace falta esto?
sub setIdInfoRef{
    my ($self) = shift;
    my ($id_info_ref) = @_;
    
    $self->idinforef($id_info_ref);
}

sub getIdInfoRef{
    my ($self) = shift;
    return ($self->idinforef);
}

sub getSubcampo{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->subcampo));
}

sub setSubcampo{
    my ($self) = shift;
    my ($subcampo) = @_;
    $self->subcampo($subcampo);
}

sub getTipo{
    my ($self) = shift;

    return (C4::AR::Utilidades::trim($self->tipo));
}

sub getTipoString{
    my ($self) = shift;

    return (C4::AR::Utilidades::getStringFor(C4::AR::Utilidades::trim($self->tipo)));
}
      

sub setTipo{
    my ($self) = shift;
    my ($tipo) = @_;
    $self->tipo($tipo);
}
 
sub getItemType{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->itemtype));
}

sub setItemType{
    my ($self) = shift;
    my ($itemtype) = @_;
    $self->itemtype($itemtype);
}
      
sub getLiblibrarian{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->liblibrarian));
}

sub setLiblibrarian{
    my ($self) = shift;

    my ($liblibrarian) = @_;
	utf8::encode($liblibrarian);
    $self->liblibrarian($liblibrarian);
}

sub getRules{
    my ($self) = shift;
#     return ("'".C4::AR::Utilidades::trim($self->rules)."'");
    return (C4::AR::Utilidades::trim($self->rules));
}

sub getRulesToString{
    my ($self) = shift;

    my $rules = C4::AR::Utilidades::trim($self->rules);
    my @rules_array = split("|", $rules);
    my $validadores_hash_ref = C4::AR::Referencias::getValidadores();

    return ($rules);
}

sub setRules{
    my ($self) = shift;

    my ($rules) = @_;
    utf8::encode($rules);
    $self->rules($rules);
}

sub setRule{
    my ($self) = shift;
    my ($tipo) = @_;

    my $rule;

#     C4::AR::Debug::debug("tipo: ".$tipo);

    switch ($tipo) {

        case "combo"                { $rule = " digits:true " } # Combo
        case "calendar"             { $rule = " dateITA:true " } # Calendario
        case "anio"                 { $rule = " digits:true | maxlength: 4 | minlength: 4 " } # Año
        case "rango_anio"           { $rule = " rango_anio " } # Rango Años (1979 - 2000)
        case "solo_texto"           { $rule = " alphanumeric_total:true " } # Solo Texto
        case "digits"               { $rule = " digits:true " } # Solo Dígitos
#         case "alphanumeric"         { $rule = " alphanumeric:true " } # Alfanumérico
        case "alphanumeric"         { $rule = "  " } # Alfanumérico
        case "alphanumeric_total"   { $rule = " alphanumeric_total:true " } # Alfanumérico
        case "auto"                 { $rule = " digits:true " } # Autocompletable
        case "texto_area"           { $rule = " alphanumeric:true " } #Text Area
#         case "texta2"       { $rule = $lettersonly." true " }

    }  

#     C4::AR::Debug::debug("rule: ".$rule);
    $self->rules($rule);
}
        
sub getReferencia{
    my ($self) = shift;
    return ($self->referencia);
}

sub setReferencia{
    my ($self) = shift;
    my ($referencia) = @_;
    $self->referencia($referencia);
}
       
sub getNivel{
    my ($self) = shift;
    return ($self->nivel);
}

sub setNivel{
    my ($self) = shift;
    my ($nivel) = @_;
    $self->nivel($nivel);
}
        
sub getObligatorio{
    my ($self) = shift;
    return ($self->obligatorio);
}

sub setObligatorio{
    my ($self) = shift;
    my ($obligatorio) = @_;
    $self->obligatorio($obligatorio);
}
       
sub getIntranet_habilitado{
    my ($self) = shift;
    return ($self->intranet_habilitado);
}

sub setIntranet_habilitado{
    my ($self) = shift;
    my ($intranet_habilitado) = @_;
    $self->intranet_habilitado($intranet_habilitado);
}

sub getHabilitado{
    my ($self) = shift;
    return ($self->intranet_habilitado);
}


sub getVisible{
    my ($self) = shift;
    return ($self->visible);
}

sub setVisible{
    my ($self) = shift;
    my ($visible) = @_;
    $self->visible($visible);
}

=head2
sub getCamposConReferencia

Funcion que devuelve un arreglo asociativo con el campo como clave y con un arreglo de subcampos como valor de cada clave
=cut
sub getCamposConReferencia{
    my @filtros;

    push(@filtros, ( referencia => { eq => 1 } ) );

    my $db_estructura_catalogacion = C4::Modelo::CatEstructuraCatalogacion::Manager->get_cat_estructura_catalogacion(
                                                                query => \@filtros,
                                                            );
    return($db_estructura_catalogacion);
}

=head2
sub getTablaFromReferencia

Devuelve el nombre de la tabla de referencia si es que la configuracion tiene referencia
=cut
sub getTablaFromReferencia{
    my ($self) = shift;

    if($self->tieneReferencia()){

        if($self->infoReferencia){
            return $self->infoReferencia->getReferencia();
        } 
    }

    return undef;
}



1;

