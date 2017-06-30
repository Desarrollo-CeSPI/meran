package C4::AR::Catalogacion;

use strict;
require Exporter;
use C4::Context;
use C4::AR::Busquedas;
use C4::Date;
use C4::AR::Utilidades qw(ASCIItoHEX existeInArray);
use MARC::Record;
use C4::AR::EstructuraCatalogacionBase;
use C4::Modelo::CatRegistroMarcN2::Manager qw(get_cat_registro_marc_n2_count);
use C4::AR::VisualizacionOpac;
use C4::AR::VisualizacionIntra;
use C4::Modelo::PrefEstructuraSubcampoMarc;
use C4::Modelo::PrefEstructuraSubcampoMarc::Manager;
use C4::Modelo::CatEstructuraCatalogacion::Manager;
use C4::AR::CacheMeran;
use HTML::Entities;

use vars qw(@EXPORT_OK @ISA );

@ISA=qw(Exporter);

@EXPORT_OK=qw(
  crearCatalogo
  buscarCamposObligatorios
  buscarCampo
  guardarCamposModificados
  guardarCampoTemporal
  getRefFromStringConArrobas
  getDocumentById
  saveEDocument
  saveIndice
  headerDCXML
  footerDCXML
  existeNivel1
  getBarcodeFormat
);

=head1 NAME

C4::AR::Catalogacion - Funciones que manipulan datos del catálogo

=head1 SYNOPSIS

  use C4::AR::Catalogacion;

=head1 DESCRIPTION

  Este modulo sera el encargado del manejo de la carga de datos en las tablas MARC, también en la carga de los items en los distintos niveles y de la creacion del catálogo.

=head1 FUNCTIONS

=over 2
=cut
=head2
sub meran_to_marc

Funcion auxiliar que toma datos desde json con formato de entrada de la interfaz web de meran y devuelve un marc_record, se utiliza en los tres niveles de catalogacion de MARC.
El formato es el siguiente [dato], cada dato es un hash con los siguientes campos (campo->'950',identificador_1->'1', indentificador2->'2',[subcampo]) y cada subcampo es un hash con ('subcampo'->'contenido, ej 'a'->'Mikaela es del rojo')
=cut
sub _meran_to_marc{
    my ($infoArrayNivel, $campos_autorizados, $itemtype, $with_references, $nivel) = @_;

    my $marc_record = MARC::Record->new();

    my $cant_campos = scalar(@$infoArrayNivel);
    my %autorizados;

    #armo el arreglo de campo => [subcampos] autorizados
    foreach my $autorizado (@$campos_autorizados){
       push(@{$autorizados{$autorizado->getCampo()}},$autorizado->getSubcampo());
    }

      C4::AR::Debug::debug("Cant ".$cant_campos." ?????????????????????????");

    my $field;
    for (my $i=0;$i<$cant_campos;$i++){
        my %hash_campos             = $infoArrayNivel->[$i];
        my $indentificador_1        = C4::AR::Utilidades::ASCIItoHEX($infoArrayNivel->[$i]->{'indicador_primario'});
        my $indentificador_2        = C4::AR::Utilidades::ASCIItoHEX($infoArrayNivel->[$i]->{'indicador_secundario'});
        my $campo                   = $infoArrayNivel->[$i]->{'campo'};
        my $subcampos_hash          = $infoArrayNivel->[$i]->{'subcampos_hash'};
        my $subcampos_array         = $infoArrayNivel->[$i]->{'subcampos_array'};
        my $cant_subcampos          = $infoArrayNivel->[$i]->{'cant_subcampos'};


        C4::AR::Debug::debug("_meran_to_marc => campo => ".$infoArrayNivel->[$i]->{'campo'});
        C4::AR::Debug::debug("_meran_to_marc => cant_subcampos => ".$infoArrayNivel->[$i]->{'cant_subcampos'});
        C4::AR::Debug::debug("_meran_to_marc => subcampos_hash => ".$infoArrayNivel->[$i]->{'subcampos_hash'});
         
        my @subcampos_array;
        #se verifica si el campo esta autorizado para el nivel que se estra procesando
        for(my $j=0;$j<$cant_subcampos;$j++) {
            my $subcampo_hash_ref = $subcampos_hash->{$j};
             # C4::AR::Debug::debug("_meran_to_marc => subcampo_hash_ref => ".$subcampo_hash_ref);
            while ( my ($key, $value) = each(%$subcampo_hash_ref) ) {
                 
                 C4::AR::Debug::debug("_meran_to_marc => hash key value => ".$key.", ".$value);

                if($with_references){
                    $value = _procesar_referencia($campo, $key, $value, $itemtype, $nivel);
                }

                if ( ($value ne '')&&(C4::AR::Utilidades::existeInArray($key, @{$autorizados{$campo}} ) )) {
                #el subcampo $key, esta autorizado para el campo $campo
                    push(@subcampos_array, ($key => $value));
                     # C4::AR::Debug::debug("_meran_to_marc => campo ".$campo." ACEPTADO clave = ".$key." valor: ".$value);
                } else {
#                     C4::AR::Debug::debug("_meran_to_marc => campo ".$campo." NO ACEPTADO clave = ".$key." valor: ".$value);
                }

#                 C4::AR::Debug::debug("_meran_to_marc => value de campo, subcampo => ".$key.", ".$campo." => ".$value);
            }
        }# END for(my $j=0;$j<$cant_subcampos;$j++)

        if(scalar(@subcampos_array) > 0) {
            #el indicador undefined # (numeral) debe ser reemplazado por blanco el asci correspondiente
            $field = MARC::Field->new($campo, $indentificador_1, $indentificador_2, @subcampos_array);
            $marc_record->append_fields($field);
        }
    }

    C4::AR::Debug::debug("_meran_to_marc => SALIDA => as_formatted ".$marc_record->as_formatted());

    return($marc_record);
}

=head2
sub meran_nivel1_to_meran

Toma una estructura que proviene de la interface de catalogación de meran con un formato establecido y genera un Marc:Record que se va a enviar para guardar teniendo en cuenta los campos que estan habilitados para este nivel.
Se apoya en la funcion _meran_to_marc que entiende el formato.
=cut
sub meran_nivel1_to_meran{
    my ($data_hash) = @_;

    my $campos_autorizados          = C4::AR::EstructuraCatalogacionBase::getSubCamposByNivel(1);
    $data_hash->{'tipo_ejemplar'}   = $data_hash->{'id_tipo_doc'}||'ALL';
#     C4::AR::Debug::debug("Catalogacion => meran_nivel1_to_meran => tipo_ejemplar => ".$data_hash->{'id_tipo_doc'});
    my $nivel                       = 1;
    my $marc_record                 = _meran_to_marc($data_hash->{'infoArrayNivel1'}, $campos_autorizados, $data_hash->{'id_tipo_doc'}, 1, $nivel);

    return($marc_record);
}

=head2
sub meran_nivel2_to_meran

Funciona de manera similar a meran_nivel2_to_meran pero para el nivel 2

=cut
sub meran_nivel2_to_meran{
    my ($data_hash) = @_;

    my $campos_autorizados          = C4::AR::EstructuraCatalogacionBase::getSubCamposByNivel(2);
    my $nivel                       = 2;
    my $marc_record                 = _meran_to_marc($data_hash->{'infoArrayNivel2'},$campos_autorizados,$data_hash->{'tipo_ejemplar'}, 1, $nivel);

    return($marc_record);
}



=head2
sub meran_nivel3_to_meran

Funciona de manera similar a meran_nivel3_to_meran pero para el nivel 3

=cut
sub meran_nivel3_to_meran{
    my ($data_hash) = @_;

    my $campos_autorizados  = C4::AR::EstructuraCatalogacionBase::getSubCamposByNivel(3);
    #si es una edicion grupa del nivel3 no se traen las referencias, se procesan luego
# FIXME esto no se pq estaba asi, si lo dejo como antes no funciona la edicion grupal
#     my $with_references     = $data_hash->{'EDICION_N3_GRUPAL'}?0:1;
    my $with_references     = 1;
    my $nivel               = 3;
    my $marc_record         = _meran_to_marc($data_hash->{'infoArrayNivel3'},$campos_autorizados,$data_hash->{'tipo_ejemplar'}, $with_references, $nivel);

    return($marc_record);
}


=head2
sub Z3950_to_meran

Recibe los datos de la importacion z3950 y los guarda en la base de meran, teniendo en cuenta tablas de referencia
=cut
sub Z3950_to_meran{
    my($marc_record) = @_;

    my ($msg_object) = C4::AR::Mensajes::create();
    my $id1;
    my $id2;
    my $id3;

# FIXME QUE ES ESTO???
#     $msg_object->{'tipo'}="INTRA";

    my ($marc_record_limpio1,$marc_record_limpio2,$marc_record_limpio3,$marc_record_campos_sin_definir)=_procesar_referencias($marc_record);
    if (scalar($marc_record_limpio1->fields())>0){
        C4::AR::Debug::debug("Z3950 marc_nivel1 => SALIDA => as_formatted ".$marc_record_limpio1->as_formatted());
        ($msg_object,$id1)=C4::AR::Nivel1::guardarRealmente($msg_object,$marc_record_limpio1); }
    if (scalar($marc_record_limpio2->fields())>0){
        C4::AR::Debug::debug("Z3950 marc_nivel2 => SALIDA => as_formatted ".$marc_record_limpio2->as_formatted());
        ($msg_object,$id1,$id2)=C4::AR::Nivel2::guardarRealmente($msg_object,$id1,$marc_record_limpio2); }
    if (scalar($marc_record_limpio3->fields())>0){
        C4::AR::Debug::debug("Z3950 marc_nivel3 => ERROR en la estrcutura => as_formatted ".$marc_record_limpio3->as_formatted());
    }
    if (scalar($marc_record_campos_sin_definir->fields())>0){
        C4::AR::Debug::debug("Z3950 WARNING campos no definidos en la biblia!!  => SALIDA => as_formatted ".$marc_record_campos_sin_definir->as_formatted());
    }
    return($msg_object);

}



=head2
    sub getCamposNoEditablesEnGrupo

    retorna un arreglo de campos, subcampo de los cuales no se permite la edicion grupal, esto es para campos como 995, f Barcode, 995, t Signatura Topográfica
=cut

sub getCamposNoEditablesEnGrupo {
    my ($nivel) = @_;

    my @filtros;

    push(@filtros, ( nivel          => { eq => $nivel } ) );
    push(@filtros, ( edicion_grupal => { eq => 0 } ) );
    push(@filtros, ( itemtype       => { eq => 'ALL' } ) );

    my $cat_estruct_array = C4::Modelo::CatEstructuraCatalogacion::Manager->get_cat_estructura_catalogacion(
                                                                query => \@filtros,
                                                            );

    my @result;
    foreach my $cat (@$cat_estruct_array){
        my %hash_info;

        $hash_info{'campo'}     = $cat->{'campo'};
        $hash_info{'subcampo'}  = $cat->{'subcampo'};

        push(@result, \%hash_info);
    }

    return(\@result);
}

=head2
sub _procesar_referencias

lo que hace esta funcion es recibir un objeto marc y procesarlo para procesar aquellos campos que son referencia, lo que hace es recorrer todos los campos del objeto y
aquellos que estan configurados como referencia en la tabla CatEstructuraCatalogacion los modifica, cambiando el dato por su referencia en el marc_record y agregando la
referencia a la tabla correspondiente en caso de no estar en ella
=cut
sub _procesar_referencias{
    my($marc_record) = @_;

    my $campos_referenciados = C4::Modelo::CatEstructuraCatalogacion::getCamposConReferencia();
    my %referenciados;
    my @subcampos1_array;
    my @subcampos2_array;
    my @subcampos3_array;
    my $marc_record_limpio1=MARC::Record->new();
    my $marc_record_limpio2=MARC::Record->new();
    my $marc_record_limpio3=MARC::Record->new();
    my $marc_record_campos_sin_definir=MARC::Record->new();
    my $ref_campos_nivel1 = C4::AR::EstructuraCatalogacionBase::getSubCamposByNivel(1);
    my %campos_nivel1;
    foreach my $campo_nivel1 (@$ref_campos_nivel1){
       push(@{$campos_nivel1{$campo_nivel1->getCampo()}},$campo_nivel1->getSubcampo());
    }
    my $ref_campos_nivel2 = C4::AR::EstructuraCatalogacionBase::getSubCamposByNivel(2);
    my %campos_nivel2;
    foreach my $campo_nivel2 (@$ref_campos_nivel2){
       push(@{$campos_nivel2{$campo_nivel2->getCampo()}},$campo_nivel2->getSubcampo());
    }
    my $ref_campos_nivel3 = C4::AR::EstructuraCatalogacionBase::getSubCamposByNivel(3);
    my %campos_nivel3;
    foreach my $campo_nivel3 (@$ref_campos_nivel3){
       push(@{$campos_nivel3{$campo_nivel3->getCampo()}},$campo_nivel3->getSubcampo());
    }
    foreach my $referenciado (@$campos_referenciados){
       push(@{$referenciados{$referenciado->getCampo()}},$referenciado->getSubcampo());
    }
    foreach my $field ($marc_record->fields) {
        if(! $field->is_control_field){
            my $campo = $field->tag;
            my @subcampos1_array;
            my @subcampos2_array;
            my @subcampos3_array;
            my @subcampos_sin_definir_array;
            foreach my $subfield ($field->subfields()) {
                my $subcampo                = $subfield->[0];
                my $dato                    = $subfield->[1];
                if (($referenciados{$campo})&&(C4::AR::Utilidades::existeInArray($subcampo, @{$referenciados{$campo}}))){
                    #si entre aca quiere decir q el campo esta referenciado;
#                    C4::AR::Debug::debug("ACA ESTAMOS".$campo.$subcampo.$dato);
                   $dato=_procesar_referencia($campo,$subcampo,$dato);
#                    C4::AR::Debug::debug("ACA ESTAMOS".$campo.$subcampo."NUEVO DATO".$dato);
                }

                if ( ($dato ne '')&&(C4::AR::Utilidades::existeInArray($subcampo, @{$campos_nivel1{$campo}} ) )) {
                    push(@subcampos1_array, ($subcampo => $dato));
                } elsif ( ($dato ne '')&&(C4::AR::Utilidades::existeInArray($subcampo, @{$campos_nivel2{$campo}} ) )) {
                    push(@subcampos2_array, ($subcampo => $dato));
                } elsif ( ($dato ne '')&&(C4::AR::Utilidades::existeInArray($subcampo, @{$campos_nivel3{$campo}} ) )) {
                    push(@subcampos3_array, ($subcampo => $dato));
                } elsif ($dato ne '') {
                    push(@subcampos_sin_definir_array, ($subcampo => $dato));
                }
            }

            if (scalar(@subcampos1_array)>0){
                my $field_limpio1 = MARC::Field->new($campo, $field->indicator(1), $field->indicator(2), @subcampos1_array);
                $marc_record_limpio1->add_fields($field_limpio1);
            }

            if (scalar(@subcampos2_array)>0){
                my $field_limpio2 = MARC::Field->new($campo, $field->indicator(1), $field->indicator(2), @subcampos2_array);
                $marc_record_limpio2->add_fields($field_limpio2);
            }

            if (scalar(@subcampos3_array)>0){
                my $field_limpio3 = MARC::Field->new($campo, $field->indicator(1), $field->indicator(2), @subcampos3_array);
                $marc_record_limpio3->add_fields($field_limpio3);
            }

            if (scalar(@subcampos_sin_definir_array)>0){
                my $field_sin_definir = MARC::Field->new($campo, $field->indicator(1), $field->indicator(2), @subcampos_sin_definir_array);
                $marc_record_campos_sin_definir->add_fields($field_sin_definir);
            }
        }
    }
#     C4::AR::Debug::debug("meran_nivel_to_meran => COMPLETO => as_formatted ".$marc_record_limpio1->as_formatted());
    return($marc_record_limpio1,$marc_record_limpio2,$marc_record_limpio3,$marc_record_campos_sin_definir);
}



=head2
sub importacion_to_meran
    Esta funcion la idea es que sea llamada desde las distintas fuentes de ingreso de datos que existen, ej: aguapey, bibun, biblo, etc
=cut
sub importacion_to_meran{

}


=head2
sub koha2_to_meran

 Esta funcion la idea es que sea llamada desde las distintas fuentes de ingreso de datos que existen, ej: aguapey, bibun, biblo, etc
=cut
sub koha2_to_meran{

}

sub detalleMARC {
    my ($marc_record) = @_;

    my ($MARC_result_array) = marc_record_to_meran($marc_record);

    return ($MARC_result_array);
}


=head2
    sub marc_record_to_meran_por_nivel

    @params
    $params->{'nivel'}
    $params->{'id_tipo_doc'}
    $marc_record datos del nivel del registro
=cut
sub marc_record_to_meran_por_nivel {
    my ($marc_record, $params) = @_;

    #obtengo la estructura y se verifica si falta agregar un campo, subcampo a la estructura de los datos
    my ($cant, $catalogaciones_array_ref) = getEstructuraSinDatos($params);
    agregarCamposVacios($marc_record, $catalogaciones_array_ref);

    my ($MARC_result_array) = marc_record_to_meran($marc_record, $params->{'id_tipo_doc'}, $params->{'type'}, $params->{'nivel'});

    return $MARC_result_array;
}

=head2
    sub marc_record_to_opac_view
=cut
sub marc_record_to_opac_view {
    my ($marc_record, $params,$db) = @_;

    $params->{'tipo'}       = 'OPAC';
    my $MARC_result_array;
    #obtengo los campo, subcampo que se pueden mostrar
    my ($marc_record_salida) = filtrarVisualizacion($marc_record, $params,$db);


    if(!C4::AR::Preferencias::getValorPreferencia("detalle_OPAC_extendido")){
    #se procesa el marc_record filtrado
    ($MARC_result_array)     = marc_record_to_meran_to_detail_view_as_not_extended($marc_record_salida, $params, 'OPAC',$db);
    } else {
    #se procesa el marc_record filtrado
    ($MARC_result_array) = marc_record_to_meran_to_detail_view($marc_record_salida, $params, 'OPAC', $db);
    }

    return $MARC_result_array;
}

=head2
    sub marc_record_to_intra_view
=cut

sub marc_record_to_intra_view {
    my ($marc_record, $params,$db) = @_;

    $db = $db || C4::Modelo::CatVisualizacionIntra->new()->db;

    $params->{'tipo'}           = 'INTRA';
    #obtengo los campo, subcampo que se pueden mostrar
    my $MARC_result_array;
    my $marc_record_salida;


    if(!C4::AR::Preferencias::getValorPreferencia("detalle_INTRA_extendido")){
        #se procesa el marc_record filtrado
        my ($cant, $catalogaciones_array_ref) = getEstructuraSinDatos($params);
        agregarCamposVacios($marc_record, $catalogaciones_array_ref);
        ($marc_record_salida)    = filtrarVisualizacion($marc_record, $params,$db);
        ($MARC_result_array)     = marc_record_to_meran_to_detail_view_as_not_extended($marc_record_salida, $params, 'INTRA',$db);
    } else {
        #se procesa el marc_record filtrado
        ($MARC_result_array) = marc_record_to_meran_to_detail_view($marc_record_salida, $params->{'id_tipo_doc'}, 'INTRA', $db);
    }

    return $MARC_result_array;
} 

=head2
    sub filtrarVisualizacion
    filtra la visualizacion del opac, se muestra lo indicado en cat_visualizacion_opac
=cut
sub filtrarVisualizacion{
    my ($marc_record, $params,$db) = @_;

    $db = $db || C4::Modelo::CatEstructuraCatalogacion->new()->db;

    my $visulizacion_array_ref;

    if($params->{'tipo'} eq 'OPAC'){
        ($visulizacion_array_ref) = C4::AR::VisualizacionOpac::getConfiguracion($params->{'nivel'}, $params->{'id_tipo_doc'},$db);
    } else {
        ($visulizacion_array_ref) = C4::AR::VisualizacionIntra::getConfiguracion($params->{'nivel'}, $params->{'id_tipo_doc'},$db);
    }

    my %autorizados;
    my $marc_record_salida = MARC::Record->new();
    #se genera el arreglo de campo, subcampos autorizados para mostrar
    foreach my $autorizado (@$visulizacion_array_ref){
       push(@{$autorizados{$autorizado->getCampo()}},$autorizado->getSubCampo());
    }

    foreach my $field ($marc_record->fields) {
        if(! $field->is_control_field){
            #se verifica si el campo esta autorizado para el nivel que se estra procesando
                my @subcampos_array = ();
                foreach my $subfield ($field->subfields()){
                    my $dato = $subfield->[1];
                    my $sub_campo = $subfield->[0];
                    if ( ($sub_campo ne '')&&(C4::AR::Utilidades::existeInArray($sub_campo, @{$autorizados{$field->tag}} ) )) {
                        #el subcampo $sub_campo, esta autorizado para el campo $field
                        push(@subcampos_array, ($sub_campo => $dato));
#                         C4::AR::Debug::debug("C4::AR::Catalogacion::filtrarVisualizacion => ACEPTADO campo,subcampo => dato ".$field->tag.",".$sub_campo." => ".$dato);
                    }else{
    #                     $msg_object->{'error'} = 1;
    #                     C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U412', 'params' => [$campo.", ".$key." valor: ".$value]} ) ;
#           C4::AR::Debug::debug("C4::AR::Catalogacion::filtrarVisualizacion => NO ACEPTADO campo,subcampo => dato ".$field->tag.",".$sub_campo." => ".$dato);
                    }
                }
                if (scalar(@subcampos_array)){
                    my $marc_record_salida_temp = MARC::Field->new($field->tag, $field->indicator(1), $field->indicator(2), @subcampos_array);
                    $marc_record_salida->append_fields($marc_record_salida_temp);
                }
        }
    }

    return $marc_record_salida;
}

sub filtrarVisualizacionOAI{
    my ($marc_record, $params,$db) = @_;

    $db = $db || C4::Modelo::CatEstructuraCatalogacion->new()->db;

    my $visulizacion_array_ref;

    ($visulizacion_array_ref) = C4::AR::VisualizacionOpac::getConfiguracionOAI($db);


    C4::AR::Debug::debug("CANTIDAD DE AUTORIZADOS: ".scalar(@$visulizacion_array_ref));


    my %autorizados;
    my $marc_record_salida = MARC::Record->new();
    #se genera el arreglo de campos, subcampos autorizados para mostrar
    foreach my $autorizado (@$visulizacion_array_ref){
       push(@{$autorizados{$autorizado->getCampo()}},$autorizado->getSubCampo());
    }


    foreach my $field ($marc_record->fields) {
        if(! $field->is_control_field){
            #se verifica si el campo esta autorizado para el nivel que se estra procesando
                my @subcampos_array = ();
                foreach my $subfield ($field->subfields()){
                    my $dato = $subfield->[1];
                    my $sub_campo = $subfield->[0];
                    if ( ($sub_campo ne '')&&(C4::AR::Utilidades::existeInArray($sub_campo, @{$autorizados{$field->tag}} ) )) {
                        #el subcampo $sub_campo, esta autorizado para el campo $field
                        push(@subcampos_array, ($sub_campo => $dato));
#                         C4::AR::Debug::debug("C4::AR::Catalogacion::filtrarVisualizacion => ACEPTADO campo,subcampo => dato ".$field->tag.",".$sub_campo." => ".$dato);
                    }else{
    #                     $msg_object->{'error'} = 1;
    #                     C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U412', 'params' => [$campo.", ".$key." valor: ".$value]} ) ;
#           C4::AR::Debug::debug("C4::AR::Catalogacion::filtrarVisualizacion => NO ACEPTADO campo,subcampo => dato ".$field->tag.",".$sub_campo." => ".$dato);
                    }
                }
                if (scalar(@subcampos_array)){
                    my $marc_record_salida_temp = MARC::Field->new($field->tag, $field->indicator(1), $field->indicator(2), @subcampos_array);
                    $marc_record_salida->append_fields($marc_record_salida_temp);
                }
        }
    }

    return $marc_record_salida;
}

=head2
    sub marc_record_to_meran_to_detail_view

    pasa la informacion de un marc_record a una estructura para utilizar en el cliente
    ESTO ES PARA LA VISTA DEL DETALLE

    campo => "campo"
    indicador_primario =>
    indicador_secundario =>
    subcampos_array => [ {subcampo => 'a', dato => 'dato'}, {subcampo => 'b', dato => 'dato'}, ...]
=cut
sub marc_record_to_meran_to_detail_view {
    my ($marc_record, $params, $type, $nivel, $db) = @_;

    my @MARC_result_array;
    my $itemtype    = $params->{'id_tipo_doc'};
    $type           = $type || "__NO_TYPE";

    foreach my $field ($marc_record->fields) {
        if(! $field->is_control_field){
            my %hash;
            my $campo                       = $field->tag;
            my $indicador_primario_dato     = $field->indicator(1);
            my $indicador_secundario_dato   = $field->indicator(2);
            #proceso todos los subcampos del campo
            foreach my $subfield ($field->subfields()) {
                my %hash_temp;

                my $subcampo                        = $subfield->[0];
                my $dato                            = $subfield->[1];
                $hash_temp{'campo'}                 = $campo;
                $hash_temp{'subcampo'}              = $subcampo;
                $hash_temp{'liblibrarian'}          = C4::AR::Catalogacion::getLiblibrarian($campo, $subcampo, $itemtype, $type, $nivel, $db);
                $hash_temp{'orden'}                 = getOrdenFromCampoSubcampo($campo, $subcampo, $itemtype, $type, $nivel ,$db);
                #C4::AR::Debug::debug("Catalogacion => marc_record_to_meran_to_detail_view => orden: ".$hash_temp{'orden'});
                $dato                               = getRefFromStringConArrobasByCampoSubcampo($campo, $subcampo, $dato, $itemtype, $db);
                $hash_temp{'datoReferencia'}        = $dato;

                my $valor_referencia                = getDatoFromReferencia($campo, $subcampo, $dato, $itemtype, $params->{'nivel'}, $db);

                $hash_temp{'dato'}                  = $dato;

#                 $hash_temp{'dato'}                  = C4::AR::Filtros::show_componente(
#                                                                         campo       => $hash_temp{'campo'},
#                                                                         subcampo    => $hash_temp{'subcampo'},
#                                                                         dato        => $valor_referencia,
#                                                                         itemtype    => $itemtype,
#                                                                         type        => $type
#                                                                   );

                $hash_temp{'id1'}                   = $params->{'id1'};
                $hash_temp{'id2'}                   = $params->{'id2'};
                $hash_temp{'dato_link'}             = C4::AR::Filtros::show_componente( ('campo' => $campo, 'subcampo' => $subcampo, 'dato' => $dato , 'id1' => $params->{'id1'}) );

                if($hash_temp{'dato_link'} ne "NO_LINK"){
                    $hash_temp{'dato'} = $hash_temp{'dato_link'};
                }

#                 if($type eq "INTRA"){
#                     #muestro el label configurado, si no existe muestro el label de la BIBLIA
#                     $hash_temp{'liblibrarian'}      = C4::AR::VisualizacionIntra::getVistaIntra($campo, $params->{'id_tipo_doc'}, $params->{'nivel'})||C4::AR::EstructuraCatalogacionBase::getLabelByCampo($campo);
#                 } else {
#                     $hash_temp{'liblibrarian'}      = C4::AR::VisualizacionOpac::getVistaOpac($campo, $params->{'id_tipo_doc'}, $params->{'nivel'})||C4::AR::EstructuraCatalogacionBase::getLabelByCampo($campo);
#                 }


                push(@MARC_result_array, \%hash_temp);
            }

        }
    }

    @MARC_result_array = sort{$a->{'orden'} <=> $b->{'orden'}} @MARC_result_array;

    foreach my $hash (@MARC_result_array){
        C4::AR::Debug::debug("hash?????????? ".$hash->{'campo'});
    }

    return (\@MARC_result_array);
}

sub marc_record_to_oai {
    my ($marc_record, $itemtype, $type, $nivel, $db) = @_;

    my @MARC_result_array;

    $type = $type || "__NO_TYPE";

    my $new_marc_record =   MARC::Record->new();

    foreach my $field ($marc_record->fields) {
        if(! $field->is_control_field){
            my %hash;
            my $campo                       = $field->tag;
            my $indicador_primario_dato     = $field->indicator(1);
            my $indicador_secundario_dato   = $field->indicator(2);
            #proceso todos los subcampos del campo
            foreach my $subfield ($field->subfields()) {
                my %hash_temp;

                my $subcampo                        = $subfield->[0];
                my $dato                            = $subfield->[1];
                $dato                               = getRefFromStringConArrobasByCampoSubcampo($campo, $subcampo, $dato, $itemtype, $nivel, $db);
                my $valor_referencia                = getDatoFromReferencia($campo, $subcampo, $dato, $itemtype, $nivel, $db);


                # C4::AR::Debug::debug("PASANDO A MARC OAI EL CAMPO $campo , $subcampo CON VALOR $valor_referencia");

                my $field = MARC::Field->new($campo,'','',$subcampo => $valor_referencia);

                $new_marc_record->append_fields($field);
            }

        }
    }

    return ($new_marc_record);
}



sub marc_record_with_data {
    my ($marc_record, $itemtype, $type, $nivel, $db) = @_;

    my @MARC_result_array;

    $type = $type || "__NO_TYPE";

    my $new_marc_record =   MARC::Record->new();

    foreach my $field ($marc_record->fields) {
        if(! $field->is_control_field){
            my %hash;
            my $campo                       = $field->tag;
            my $indicador_primario_dato     = $field->indicator(1);
            my $indicador_secundario_dato   = $field->indicator(2);
            #proceso todos los subcampos del campo
            foreach my $subfield ($field->subfields()) {
                my %hash_temp;

                my $subcampo                        = $subfield->[0];
                my $dato                            = $subfield->[1];
                $dato                               = getRefFromStringConArrobasByCampoSubcampo($campo, $subcampo, $dato, $itemtype, $nivel, $db);
                my $valor_referencia                = getDatoFromReferencia($campo, $subcampo, $dato, $itemtype, $nivel, $db);
                my $field = MARC::Field->new($campo,'','',$subcampo => $valor_referencia);
                $new_marc_record->append_fields($field);
            }

        }
    }

    return ($new_marc_record);
}


# TODO ver tema de performance, habria q llamar a getVisualizacionFromCampo y levantar toda la conf una vez
sub as_stringReloaded {
    my ($field, $itemtype, $params) = @_;

   
    my $db      = undef;
    my $campo   = $field->tag;
    my $nivel   = $params->{'nivel'};

    my %subcampos;
    my $cat_estruct_info_array;
    foreach my $subfield ($field->subfields()) {
        my %hash_temp;
        my $subcampo                        = $subfield->[0];
        my $dato                            = $subfield->[1];
        $dato                               = getRefFromStringConArrobasByCampoSubcampo($campo, $subcampo, $dato, $itemtype, $nivel);
        $dato                               = getDatoFromReferencia($campo, $subcampo, $dato, $itemtype, $nivel);
        $dato                               = C4::AR::Utilidades::escapeData($dato);

        # C4::AR::Debug::debug("Catalogacion => as_stringReloaded => campo => ".$campo." subcampo => ".$subcampo." dato => ".$dato);
        $hash_temp{'dato_link'}             = C4::AR::Filtros::show_componente( ('campo' => $campo, 'subcampo' => $subcampo, 'dato' => $dato , 'id1' => $params->{'id1'}, 'id2' => $params->{'id2'}, 'template' => $itemtype ) );

        if($hash_temp{'dato_link'} ne "NO_LINK"){
            $dato                           = $hash_temp{'dato_link'};
        }
        if($params->{'tipo'} eq 'OPAC'){
            $cat_estruct_info_array          = C4::AR::VisualizacionOpac::getVisualizacionFromCampoSubCampo($field->tag, $subcampo, $itemtype, $nivel, $db);
            }
        else{
            $cat_estruct_info_array       = C4::AR::VisualizacionIntra::getVisualizacionFromCampoSubCampo($field->tag, $subcampo, $itemtype, $nivel, $db);
            }
        my $text                            = "";
        if($cat_estruct_info_array){

            #$text                           = $cat_estruct_info_array->getPre().$dato.$cat_estruct_info_array->getPost();
        #    $hash_temp{'dato'}              = $dato;
        #    $hash_temp{'orden_subcampo'}    = $cat_estruct_info_array->getOrdenSubCampo();
        #}
          if(($dato)&&( C4::AR::Utilidades::trim($dato) ne '')){
            if (!$subcampos{$subcampo}){
                $subcampos{$subcampo}{'orden'}    = $cat_estruct_info_array->getOrdenSubCampo();
                $subcampos{$subcampo}{'pre'}      = $cat_estruct_info_array->getPre();
                $subcampos{$subcampo}{'inter'}    = $cat_estruct_info_array->getInter();
                $subcampos{$subcampo}{'post'}     = $cat_estruct_info_array->getPost();
                $subcampos{$subcampo}{'datos'}    = [$dato];
            }
            else{
               my $tmp = $subcampos{$subcampo}{'datos'};
               # C4::AR::Debug::debug("Catalogacion => as_stringReloaded =>".$tmp);
               push @$tmp, $dato;
               $subcampos{$subcampo}{'datos'}=$tmp;
            }
         }
        }
        #push (@array_subcampos, \%hash_temp);
    } # foreach


    #my %subcampos = sort {$a->{'orden'} <=> $b->{'orden'}} values %subcampos;


    # TODO es una grasada pero anda!!!!!!!
    #@array_subcampos = sort{$a->{'orden_subcampo'} <=> $b->{'orden_subcampo'}} @array_subcampos;

    my $texto='';
    
    #Se unen las ocurrencias con el separador intermedio!!
    foreach my $subcampo (sort {$subcampos{$a}{'orden'} <=> $subcampos{$b}{'orden'}} keys %subcampos) {     
        my $ocurrencias = $subcampos{$subcampo}{'datos'};
        my $inter = $subcampos{$subcampo}{'inter'};
        my $subsJoined= join( $inter, @$ocurrencias);
        # C4::AR::Debug::debug("Catalogacion => JOINED!!! => ".$subsJoined." campo, subcampo => ".$campo.", ".$subcampo);
        $texto.=$subcampos{$subcampo}{'pre'}.$subsJoined.$subcampos{$subcampo}{'post'};
    }
    return $texto;
}

sub guardarEsquema{
    my ($params) = @_;

# TODO ver si es necesario informar que se cambio el esquema

    my $msg_object = C4::AR::Mensajes::create();

    if ($params->{'nivel'} eq 1) {
        my $nivel1 = C4::AR::Nivel1::getNivel1FromId1($params->{'id1'});

        if($nivel1){
            $nivel1->setTemplate($params->{'template'});
            $nivel1->save();
        }

        $msg_object->{'error'} = 0;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U612', 'params' => []} ) ;
    } elsif ($params->{'nivel'} eq 2) {
        my $nivel2 = C4::AR::Nivel2::getNivel2FromId2($params->{'id2'});

        if($nivel2){
            $nivel2->setTemplate($params->{'template'});
            $nivel2->save();
        }

        $msg_object->{'error'} = 0;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U612', 'params' => []} ) ;
    } elsif ($params->{'nivel'} eq 3) {
        my $nivel3 = C4::AR::Nivel3::getNivel3FromId3($params->{'id3'});

        if($nivel3){
            $nivel3->setTemplate($params->{'template'});
            $nivel3->save();
        }

        $msg_object->{'error'} = 0;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U612', 'params' => []} ) ;
    }

    return ($msg_object);
}

sub marc_record_to_meran_to_detail_view_as_not_extended {
    my ($marc_record, $params, $type, $db) = @_;

    my @MARC_result_array;
    my %hash_temp_aux;
    my $index;
    $type           = $type || "__NO_TYPE";
    my $itemtype    = $params->{'id_tipo_doc'};

    # C4::AR::Debug::debug("Catalogacion => marc_record_to_meran_to_detail_view_as_not_extended => marc_record->as_usmarc => ".$marc_record->as_formatted);

    foreach my $field ($marc_record->fields) {
        my %hash_temp_aux;
        if(! $field->is_control_field){
    #             C4::AR::Debub::debug("C4::AR::Catalocagion::marc_record_to_detail_viw2 => field->as_string => ".$field->as_string);
            my %hash;
            my $campo                       = $field->tag;
            my $campo_ant                   = $field->tag;
            my $indicador_primario_dato     = $field->indicator(1);
            my $indicador_secundario_dato   = $field->indicator(2);

            #verifico si el campo que estoy procesando esta en el arreglo de campos
            $index = C4::AR::Utilidades::getIndexFromArrayByString($campo,\@MARC_result_array);

            # veo que separador lleva cada subcampo para el $field dependiendo del campo y subcampo que se este procesando
            my $field_as_string                 = as_stringReloaded($field, $itemtype, $params);

# C4::AR::Debug::debug("Catalogacion => field_as_string => ".$field_as_string);
            $hash_temp_aux{'dato'}              = ($hash_temp_aux{'dato'} ne "")?$hash_temp_aux{'dato'}.";".$field_as_string:($type eq "INTRA")?$field_as_string." ":$field_as_string;
            $hash_temp_aux{'campo'}             = $campo;
            $hash_temp_aux{'orden'}             = getOrdenFromCampo($campo, $params->{'nivel'}, $itemtype, $type, $db);

            if($type eq "INTRA"){
                #muestro el label configurado, si no existe muestro el label de la BIBLIA
                $hash_temp_aux{'liblibrarian'}      = C4::AR::VisualizacionIntra::getVistaCampo($campo, $itemtype, $params->{'nivel'})||C4::AR::EstructuraCatalogacionBase::getLabelByCampo($campo);

            } else {
                #en el OPAC no se permiten datos blancos ni nulos
                if((C4::AR::Utilidades::trim($hash_temp_aux{'dato'}) eq "")||($hash_temp_aux{'dato'} eq 'NO_TIENE')){
                    next;
                }

                $hash_temp_aux{'liblibrarian'}      = C4::AR::VisualizacionOpac::getVistaCampo($campo, $itemtype, $params->{'nivel'})||C4::AR::EstructuraCatalogacionBase::getLabelByCampo($campo);
            }

            # $index = C4::AR::Utilidades::getIndexFromArrayByString($campo,\@MARC_result_array);

            if($index == -1){
            #NO EXISTE EL CAMPO
                push(@MARC_result_array, \%hash_temp_aux);
            } else {
            #EXISTE EL CAMPO => campo, subcampo REPETIBLE
                @MARC_result_array[$index]->{'dato'} = (@MARC_result_array[$index]->{'dato'} ne "")?@MARC_result_array[$index]->{'dato'}.$field_as_string:$field_as_string;
            }

        } #END if(! $field->is_control_field)
    } #END foreach my $field ($marc_record->fields)

    @MARC_result_array = sort{$a->{'orden'} <=> $b->{'orden'}} @MARC_result_array;

    return (\@MARC_result_array);
}

=head2
    sub marc_record_to_meran

    pasa la informacion de un marc_record a una estructura para utilizar en el cliente
    ESTO SE USA PARA MOSTRAR LOS CAMPOS EN EL FORMULARIO DINAMICO

    campo => "campo"
    indicador_primario =>
    indicador_secundario =>
    subcampos_array => [ {subcampo => 'a', dato => 'dato'}, {subcampo => 'b', dato => 'dato'}, ...]
=cut
sub marc_record_to_meran {
    my ($marc_record, $itemtype, $type, $nivel,$db) = @_;

#     C4::AR::Debug::debug("Catalogacion => marc_record_to_meran ");
#     C4::AR::Debug::debug("Catalogacion => marc_record_to_meran => itemtype: ".$itemtype);
    my @MARC_result_array;

    $type = $type || "__NO_TYPE";

    foreach my $field ($marc_record->fields) {
     if(! $field->is_control_field){
        my %hash;
        my $campo                       = $field->tag;
        my $indicador_primario_dato     = $field->indicator(1);
        my $indicador_secundario_dato   = $field->indicator(2);
        my @subcampos_array;
        #proceso todos los subcampos del campo
        foreach my $subfield ($field->subfields()) {
            my %hash_temp;

            my $subcampo                        = $subfield->[0];
            my $dato                            = $subfield->[1];
            $hash_temp{'campo'}                 = $campo;
            $hash_temp{'subcampo'}              = $subcampo;
            $hash_temp{'liblibrarian'}          = C4::AR::Catalogacion::getLiblibrarian($campo, $subcampo, $itemtype, $type, $nivel,$db);
            $hash_temp{'orden'}                 = getOrdenFromCampoSubcampo($campo, $subcampo, $itemtype, $type, $nivel,$db);
            $dato                               = getRefFromStringConArrobasByCampoSubcampo($campo, $subcampo, $dato, $itemtype, $nivel);
            $hash_temp{'datoReferencia'}        = $dato;
            my $valor_referencia                = getDatoFromReferencia($campo, $subcampo, $dato, $itemtype, $nivel);
            $hash_temp{'dato'}                  = $valor_referencia;

            push(@subcampos_array, \%hash_temp);
        }
            $hash{'campo'}                      = $campo;
            $hash{'indicador_primario_dato'}    = $indicador_primario_dato;
            $hash{'indicador_secundario_dato'}  = $indicador_secundario_dato;
            $hash{'header'}                     = C4::AR::Catalogacion::getHeader($campo);

            $hash{'subcampos_array'}            = \@subcampos_array;

            push(@MARC_result_array, \%hash);
        }

    }

    return (\@MARC_result_array);
}


=head2
    sub getDatoFromReferencia

    Esta funcion recibe campo, subcampo y dato, donde dato puede ser el dato en si mismo, un string o la referencia a un dato.
    Si es la referencia a un dato, se obtiene el dato de la referencia, y dato era un "dato" (string) se retorna y no se hace nada.
    Siempre devuelve el dato.
=cut
sub getDatoFromReferencia{
    my ($campo, $subcampo, $dato, $itemtype, $nivel, $db) = @_;

    my $valor_referencia = 'NULL';
#     C4::AR::Debug::debug("Catalogacion => getDatoFromReferencia ============================ ");
#     C4::AR::Debug::debug("Catalogacion => getDatoFromReferencia => campo:                    ".$campo);
#     C4::AR::Debug::debug("Catalogacion => getDatoFromReferencia => subcampo:                 ".$subcampo);
#     C4::AR::Debug::debug("Catalogacion => getDatoFromReferencia => dato:                     ".$dato);

#     if(($dato ne '')&&($campo ne '')&&($subcampo ne '')&&($dato ne '')&&($dato ne '0')){
    if(($dato ne '')&&($campo ne '')&&($subcampo ne '')&&($dato ne '')&&($dato ne "NULL")){

        my ($estructura) = C4::AR::Catalogacion::_getEstructuraFromCampoSubCampo($campo, $subcampo, $itemtype, $nivel, $db);

        if($estructura){

            if($estructura->getReferencia){
                #tiene referencia

                if($estructura->infoReferencia){

                  eval{

#                         C4::AR::Debug::debug("Catalogacion => getDatoFromReferencia => getReferencia:       ".$estructura->infoReferencia->getReferencia);
#                         C4::AR::Debug::debug("Catalogacion => getDatoFromReferencia => dato entrada:        ".$dato);



                        my $pref_tabla_referencia = C4::Modelo::PrefTablaReferencia->new();
                        my $obj_generico    = $pref_tabla_referencia->getObjeto($estructura->infoReferencia->getReferencia);
                        # C4::AR::Debug::debug("Catalogacion => getDatoFromReferencia => campo tabla:                 ".$estructura->infoReferencia->getCampos);
                        # C4::AR::Debug::debug("Catalogacion => getDatoFromReferencia => id tabla:                    ".$dato);
#                                                                                         campo_tabla,                id_tabla
                        $valor_referencia   = $obj_generico->obtenerValorCampo($estructura->infoReferencia->getCampos, $dato);

                        # C4::AR::Debug::debug("Catalogacion => getDatoFromReferencia => Tabla:               ".$obj_generico->getTableName);
                        # C4::AR::Debug::debug("Catalogacion => getDatoFromReferencia => Modulo:              ".$obj_generico->toString);
                        # C4::AR::Debug::debug("Catalogacion => getDatoFromReferencia => Valor referencia:    ".$valor_referencia);

                        $dato = $valor_referencia;

                    };

                    if ($@){
# TODO cuando se guarden los errores en la sesion, este error hay q guardarlo ahi
                        C4::AR::Debug::debug("Catalogacion => getDatoFromReferencia, ERROR en campo, subcampo, dato => ".$campo.", ".$subcampo." => ".$dato);
                        C4::AR::Mensajes::printErrorDB($@, 'B451',"INTRA");
#                         $dato = "error en configuracion del catalogo";
                    }
                } else {
#                     C4::AR::Debug::debug("Catalogacion => getDatoFromReferencia => ERROR EN REFERENCIA campo, subcampo => ".$campo.", ".$subcampo);
                }
            }
        }

    }#END if(($dato ne '')&&($campo ne '')&&($subcampo ne '')&&($dato != 0)&&($dato ne ''))

    return getNullValue($dato);
#     return $dato;
}


sub getNullValue {
    my ($dato) = @_;

#     return ($dato eq "NULL")?"[SIN VALOR]":$dato;
    return ($dato eq "NULL")?"":$dato;
}

=head2
    sub getRefFromStringConArrobas
    esta funcion devuelve el dato (referencia) a partir de un string
    @tabla@dato
=cut
sub getRefFromStringConArrobas{
    my ($dato) = @_;

    my @datos_array = split(/@/,$dato);
=item
    @datos_array[0]; #nada
    @datos_array[1]; #tabla
    @datos_array[2]; #dato
=cut

     #C4::AR::Debug::debug("Catalogacion => getRefFromStringConArrobas => dato: ".$dato);
     #C4::AR::Debug::debug("Catalogacion => getRefFromStringConArrobas => dato despues del split 1: ".@datos_array[1]);
     #C4::AR::Debug::debug("Catalogacion => getRefFromStringConArrobas => dato despues del split 2: ".@datos_array[2]);

    return @datos_array[1];
}

=head2
    sub getRefFromStringConArrobasByCampoSubcampo
    Esta funcion llama getRefFromStringConArrobas, solo q antes verifica si el dato es una referencia
    Si es una referencia, devuelve el dato (referencia) sin las @
    Si no es una referencia, se devuelve el dato pasado por parametro
=cut
sub getRefFromStringConArrobasByCampoSubcampo{
    my ($campo, $subcampo, $dato, $itemtype, $nivel, $db) = @_;

    my $estructura = C4::AR::Catalogacion::_getEstructuraFromCampoSubCampo($campo, $subcampo, $itemtype, $nivel, $db);
    # C4::AR::Debug::error("Catalogacion => getRefFromStringConArrobasByCampoSubcampo => campo ".$campo." subcampo ".$subcampo." itemtype ".$itemtype." nivel ".$nivel);

    if($estructura){
        if($estructura->getReferencia){
        #tiene referencia
            return getRefFromStringConArrobas($dato);
        }
    }

    return $dato;
}


=head2
sub _procesar_referencia

Esta funcion recibe un campo, un subcampo y un dato y busca en la tabla de referencia correspondinte en valor que se corresponde con el dato, en el caso de no encontrarlo lo agrega en la tabla de referencia correspondiente y devuelve el id del nuevo elemento
=cut
sub _procesar_referencia {
    my ($campo, $subcampo, $dato, $itemtype, $nivel) = @_;

     #C4::AR::Debug::debug("Catalogacion => _procesar_referencia");
     #C4::AR::Debug::debug("Catalogacion => _procesar_referencia => campo => ".$campo);
     #C4::AR::Debug::debug("Catalogacion => _procesar_referencia => subcampo => ".$subcampo);
     #C4::AR::Debug::debug("Catalogacion => _procesar_referencia => itemype => ".$itemtype);
     #C4::AR::Debug::debug("Catalogacion => _procesar_referencia => nivel => ".$nivel);

    my $estructura = C4::AR::Catalogacion::_getEstructuraFromCampoSubCampo($campo, $subcampo, $itemtype, $nivel);
     C4::AR::Debug::debug("Catalogacion => _procesar_referencia => DESPUES _getEstructuraFromCampoSubCampo");
     
    if($estructura) {
       if($estructura->getReferencia){
            #tiene referencia
            my $pref_tabla_referencia   = C4::Modelo::PrefTablaReferencia->new();

            eval{
                
                #C4::AR::Debug::debug("Catalogacion => _procesar_referencia => ESTRUCTURA 1 = ". $estructura->getReferencia);
                #C4::AR::Debug::debug("Catalogacion => _procesar_referencia => ESTRUCTURA 2 = ". $estructura->infoReferencia);
                #C4::AR::Debug::debug("Catalogacion => _procesar_referencia => ESTRUCTURA 3 = ". $estructura->infoReferencia->getReferencia);  
                
                my $obj_generico            = $pref_tabla_referencia->getObjeto($estructura->infoReferencia->getReferencia);

                #C4::AR::Debug::debug("Catalogacion => _procesar_referencia => OBJETO TABLA REF".$obj_generico->getTableName);

                #se genera el nuevo dato => tabla@dato para poder obtener el dato de la referencia luego
                my $string_result           = $obj_generico->getTableName.'@'.$dato;

                 #C4::AR::Debug::debug("Catalogacion => _procesar_referencia => getReferencia:    ".$estructura->infoReferencia->getReferencia);
                 #C4::AR::Debug::debug("Catalogacion => _procesar_referencia => dato entrada:     ".$dato);
                 #C4::AR::Debug::debug("Catalogacion => _procesar_referencia => Tabla:            ".$obj_generico->getTableName);
                 #C4::AR::Debug::debug("Catalogacion => _procesar_referencia => Modulo:           ".$obj_generico->toString);
                 #C4::AR::Debug::debug("Catalogacion => _procesar_referencia => string_result:    ".$string_result);

                $dato = $string_result;
            };

            if ($@){
                &C4::AR::Mensajes::printErrorDB($@, 'B450',"INTRA");
                C4::AR::Debug::debug("Catalogacion => _procesar_referencia, ERROR en campo, subcampo => ".$campo.", ".$subcampo);
            }

        }#END if($estructura->getReferencia){


    }#END if($estructura){

#     C4::AR::Debug::debug("Catalogacion => _procesar_referencia => salida =>     ".$dato);
    #si no tiene la estructura o no tiene referencia, se devuelve el dato como viene
    return $dato;
}


=head2
sub _setDatos_de_estructura


Esta funcion setea

    @Parametros
    $cat: es un objeto de cat_estructura_catalogacion que contiene toda la estructura que se va a setear a la HASH
=cut
sub _setDatos_de_estructura {
    my ($cat, $datos_hash_ref) = @_;

    my %hash_ref_result;


    $hash_ref_result{'dato'}                    = $datos_hash_ref->{'dato'};
    $hash_ref_result{'datoReferencia'}          = $datos_hash_ref->{'datoReferencia'};
    $hash_ref_result{'tiene_estructura'}        = $datos_hash_ref->{'tiene_estructura'};
    $hash_ref_result{'ayuda_subcampo'}          = $datos_hash_ref->{'ayuda_subcampo'};
    $hash_ref_result{'descripcion_subcampo'}    = $datos_hash_ref->{'descripcion_subcampo'};

    $hash_ref_result{'subcampo'}                = $cat->getSubcampo;
    $hash_ref_result{'campo'}                   = $cat->getCampo;
    $hash_ref_result{'nivel'}                   = $cat->getNivel;
    $hash_ref_result{'visible'}                 = $cat->getVisible;
    $hash_ref_result{'edicion_grupal'}          = $cat->getEdicionGrupal;
    $hash_ref_result{'liblibrarian'}            = $cat->getLiblibrarian;
    $hash_ref_result{'itemtype'}                = $cat->getItemType;
    $hash_ref_result{'repetible'}               = $cat->subCamposBase->getRepetible;
    $hash_ref_result{'tipo'}                    = $cat->getTipo;
    $hash_ref_result{'referencia'}              = $cat->getReferencia;
    $hash_ref_result{'obligatorio'}             = $cat->getObligatorio;
    $hash_ref_result{'idCompCliente'}           = $cat->getIdCompCliente;
    $hash_ref_result{'intranet_habilitado'}     = $cat->getIntranet_habilitado;
    $hash_ref_result{'rules'}                   = $cat->getRules;
    $hash_ref_result{'fijo'}                    = $cat->getFijo;

#     C4::AR::Debug::debug("_setDatos_de_estructura => campo, subcampo: ".$cat->getCampo.", ".$cat->getSubcampo);
#     C4::AR::Debug::debug("_setDatos_de_estructura => dato: ".$datos_hash_ref->{'dato'});
#     C4::AR::Debug::debug("_setDatos_de_estructura => datoReferencia: ".$datos_hash_ref->{'datoReferencia'});
    if( ($cat->getReferencia) && ($cat->getTipo eq 'combo') && defined($cat->infoReferencia) ){
        #tiene una referencia, y es un COMBO
#         C4::AR::Debug::debug("_setDatos_de_estructura => ======== COMBO ======== ");
        $hash_ref_result{'referenciaTabla'} = $cat->infoReferencia->getReferencia;
        _obtenerOpciones ($cat, \%hash_ref_result);
#         $hash_ref_result{'default_value'}       =

    }elsif( ($cat->getReferencia) && ($cat->getTipo eq 'auto') && defined($cat->infoReferencia) ){

        #es un autocomplete
        $hash_ref_result{'referenciaTabla'} = $cat->infoReferencia->getReferencia;

        #si es un autocomplete y no tengo el dato de la referencia, muestro un blanco
#         if ( ($hash_ref_result{'datoReferencia'} eq 0) || ($hash_ref_result{'dato'} eq 0) || not defined($hash_ref_result{'datoReferencia'}) ) {
        if ( ($hash_ref_result{'datoReferencia'} eq "NULL") || ($hash_ref_result{'dato'} eq "NULL") || not defined($hash_ref_result{'datoReferencia'}) ) {
          $hash_ref_result{'dato'} = '';#'NO TIENE';
        }

        if ($hash_ref_result{'datoReferencia'} eq -1){
#             C4::AR::Debug::debug("_setDatos_de_estructura => datoReferencia = -1 => el autor no existe se agrega ".$hash_ref_result{'dato'});
        }

#         C4::AR::Debug::debug("_setDatos_de_estructura => ======== AUTOCOMPLETE ======== ");
#         C4::AR::Debug::debug("_setDatos_de_estructura => datoReferencia: ".$hash_ref_result{'datoReferencia'});
#         C4::AR::Debug::debug("_setDatos_de_estructura => referenciaTabla: ".$hash_ref_result{'referenciaTabla'});
    }else{
        #cualquier otra componete
#         C4::AR::Debug::debug("_setDatos_de_estructura => ======== ".$cat->getTipo." ======== ");
    }

    return (\%hash_ref_result);
}

#para los datos q no tienen estructura
sub _setDatos_de_estructura_base {
    my ($cat, $datos_hash_ref) = @_;

    my %hash_ref_result;

    $hash_ref_result{'campo'}                   = $cat->getCampo;
    $hash_ref_result{'subcampo'}                = $cat->getSubcampo;
    $hash_ref_result{'Id_rep'}                  = $datos_hash_ref->{'Id_rep'};
    $hash_ref_result{'tiene_estructura'}        = $datos_hash_ref->{'tiene_estructura'};
    $hash_ref_result{'dato'}                    = $datos_hash_ref->{'dato'};
    $hash_ref_result{'nivel'}                   = '';#$cat->getNivel;
    $hash_ref_result{'visible'}                 = '';#$cat->getVisible;
    $hash_ref_result{'liblibrarian'}            = $cat->getLiblibrarian;
    $hash_ref_result{'itemtype'}                = '';#$cat->getItemType;
    $hash_ref_result{'repetible'}               = '';#$cat->subCamposBase->getRepetible;
    $hash_ref_result{'tipo'}                    = '';#$cat->getTipo;
    $hash_ref_result{'referencia'}              = '';#$cat->getReferencia;
    $hash_ref_result{'obligatorio'}             = $cat->getObligatorio;
    $hash_ref_result{'idCompCliente'}           = '';#$cat->getIdCompCliente;
    $hash_ref_result{'intranet_habilitado'}     = '';#$cat->getIntranet_habilitado;
    $hash_ref_result{'rules'}                   = '';#$cat->getRules;

#     C4::AR::Debug::debug("_setDatos_de_estructura_base => campo, subcampo: ".$cat->getCampo.", ".$cat->getSubcampo);
#     C4::AR::Debug::debug("_setDatos_de_estructura_base => dato: ".$datos_hash_ref->{'dato'});

    return (\%hash_ref_result);
}

=head2
Esta funcion retorna la estructura de catalogacion con los datos de un Nivel (NO REPETIBLES).
Ademas mapea las campos fijos de nivel 1, 2 y 3 a MARC
=cut
sub getEstructuraYDatosDeNivel{
    my ($params) = @_;

    my @result;
    my $nivel;
    my $tipo_ejemplar;

    if( $params->{'nivel'} eq '1'){
        $nivel          = C4::AR::Nivel1::getNivel1FromId1($params->{'id'});
        $tipo_ejemplar  = ($nivel)?$nivel->getTemplate()||'ALL':'ALL';
    }
    elsif( $params->{'nivel'} eq '2'){
        $nivel          = C4::AR::Nivel2::getNivel2FromId2($params->{'id'});
        $tipo_ejemplar  = ($nivel)?$nivel->getTemplate()||'ALL':'ALL';
    }
    elsif( $params->{'nivel'} eq '3'){
        $nivel          = C4::AR::Nivel3::getNivel3FromId3($params->{'id3'});
        $tipo_ejemplar  = ($nivel)?$nivel->getTemplate()||'ALL':'ALL';
    }

    #paso todo a MARC
    my $nivel_info_marc_array = undef;

    eval{
      $nivel_info_marc_array = $nivel->toMARC; #mapea los campos de la tabla nivel 1, 2, o 3 a MARC
    };

    my $campo;
    my $repetible;
    my $liblibrarian;
    my $indicador_primario;
    my $indicador_secundario;
    my $descripcion_campo;
    my @result_total;

# TODO falta mostrar los campos de la estructura que estan vacios
# SOLO TRAE LOS CAMPOS QUE TIENEN ESTRUCTURA Y TIENEN DATOS

    #se genera la estructura de catalogacion para enviar al cliente
    if ($nivel_info_marc_array ){

C4::AR::Debug::debug("Catalogacion => scalar(nivel_info_marc_array => ?????????????????? ".scalar(@$nivel_info_marc_array));

        for(my $i=0;$i<scalar(@$nivel_info_marc_array);$i++){
                my @result;
                my $campo                       = $nivel_info_marc_array->[$i]->{'campo'};
                my $indicador_primario_dato     = C4::AR::Utilidades::HEXtoASCII($nivel_info_marc_array->[$i]->{'indicador_primario_dato'});
                my $indicador_secundario_dato   = C4::AR::Utilidades::HEXtoASCII($nivel_info_marc_array->[$i]->{'indicador_secundario_dato'});

                foreach my $subcampo (@{$nivel_info_marc_array->[$i]->{'subcampos_array'}}){

                    my %hash_temp;
                    #RECUPERO LA INFO DE LA ESTRUCTURA DE CATALOGACION CONFIGURADA
                    my $cat_estruct_array = _getEstructuraFromCampoSubCampo(
                                                                                $nivel_info_marc_array->[$i]->{'campo'},
                                                                                $subcampo->{'subcampo'},
                                                                                $tipo_ejemplar,
                                                                                $params->{'nivel'}
                                                        );

                    C4::AR::Debug::debug("Catalocagion => getEstructuraYDatosDeNivel => campo => ".$nivel_info_marc_array->[$i]->{'campo'});
                    C4::AR::Debug::debug("Catalocagion => getEstructuraYDatosDeNivel => subcampo => ".$subcampo->{'subcampo'});
                    C4::AR::Debug::debug("Catalocagion => getEstructuraYDatosDeNivel => dato => ".$subcampo->{'dato'});


                    if($cat_estruct_array){
#                         C4::AR::Debug::debug("Catalogacion::getEstructuraYDatosDeNivel() --> EL CAMPO ".$campo." SUBCAMPO ".$subcampo->{'subcampo'}." NIVEL ".$params->{'nivel'}." TIPO_EJEMPLAR ".$tipo_ejemplar." TIENE ESTRUCTURA CONFIGURADA");
#                         C4::AR::Debug::debug("Catalogacion::getEstructuraYDatosDeNivel() --> datoReferencia ".$subcampo->{'datoReferencia'});

                        my ($campos_base_array_ref) = C4::AR::EstructuraCatalogacionBase::getEstructuraBaseFromCampo($campo);

                        #se verifica que exista el campo en la BIBLIA
                        if($campos_base_array_ref){

                            $liblibrarian           = $campos_base_array_ref->getLiblibrarian;
                            $repetible              = $campos_base_array_ref->getRepeatable;
                            $indicador_primario     = $campos_base_array_ref->getIndicadorPrimario;
                            $indicador_secundario   = $campos_base_array_ref->getIndicadorSecundario;
                            $descripcion_campo      = $campos_base_array_ref->getDescripcion.' - '.$cat_estruct_array->getCampo;

                        } else {
                            #simplemente se avisa, esto no debería pasar
                            C4::AR::Debug::debug("Catalogacion::getEstructuraYDatosDeNivel() --> EL CAMPO ".$campo." NO EXISTE EN LA BIBLIA");
                        }

                        $hash_temp{'tiene_estructura'}  = '1';
                        $hash_temp{'dato'}              = $subcampo->{'dato'};
                        $hash_temp{'datoReferencia'}    = $subcampo->{'datoReferencia'};

                        my $hash_result = _setDatos_de_estructura($cat_estruct_array, \%hash_temp);


                        push(@result, $hash_result);
                    }else{
                        #EL CAMPO, SUBCAMPO, TIPO_EJEMPLAR y NIVEL NO TIENE UNA ESTRUCTURA CONFIGURADA
                        C4::AR::Debug::debug("Catalogacion::getEstructuraYDatosDeNivel() --> EL CAMPO ".$campo." SUBCAMPO ".$subcampo->{'subcampo'}." NIVEL ".$params->{'nivel'}." TIPO_EJEMPLAR ".$tipo_ejemplar." NO TIENE ESTRUCTURA CONFIGURADA");
                        my $hash_result;

                        #RECUPERO LA INFO DE LA ESTRUCTURA BASE
                        my $cat_estruct_base_array = C4::AR::EstructuraCatalogacionBase::getEstructuraBaseFromCampoSubCampo(
                                                                                                    $nivel_info_marc_array->[$i]->{'campo'},
                                                                                                    $subcampo->{'subcampo'}
                                                                                );

                        if($cat_estruct_base_array){
                            $liblibrarian           = $cat_estruct_base_array->camposBase->getLiblibrarian;
                            $repetible              = $cat_estruct_base_array->camposBase->getRepeatable;
                            $indicador_primario     = $cat_estruct_base_array->camposBase->getIndicadorPrimario;
                            $indicador_secundario   = $cat_estruct_base_array->camposBase->getIndicadorSecundario;
                            $descripcion_campo      = $cat_estruct_base_array->camposBase->getDescripcion.' - '.$cat_estruct_base_array->getCampo;
                        }



                        $hash_result->{'tiene_estructura'}  = '0';
                        $hash_result->{'campo'}             = $campo;
                        $hash_result->{'subcampo'}          = $subcampo->{'subcampo'};
                        $hash_result->{'dato'}              = $subcampo->{'dato'};
                        my $hash_result                     = _setDatos_de_estructura_base($cat_estruct_base_array, $hash_result);


                        push(@result, $hash_result);
                    }

                    @result = sort { $a->{subcampo} cmp $b->{subcampo} } @result;
                }# END foreach my $s (@{$m->{'subcampos_array'}})

                my %hash_campos;

                $hash_campos{'campo'}                       = $campo;
                $hash_campos{'repetible'}                   = $repetible;
                $hash_campos{'nombre'}                      = $liblibrarian;
                $hash_campos{'indicador_primario'}          = $indicador_primario;
                $hash_campos{'indicador_primario_dato'}     = $indicador_primario_dato;
                $hash_campos{'indicadores_primarios'}       = C4::AR::EstructuraCatalogacionBase::getIndicadorPrimarioFromEstructuraBaseByCampo($campo);
                $hash_campos{'indicador_secundario'}        = $indicador_secundario;
                $hash_campos{'indicador_secundario_dato'}   = $indicador_secundario_dato;
                $hash_campos{'indicadores_secundarios'}     = C4::AR::EstructuraCatalogacionBase::getIndicadorSecundarioFromEstructuraBaseByCampo($campo);
                $hash_campos{'descripcion_campo'}           = $descripcion_campo.' - '.$campo;
                $hash_campos{'ayuda_campo'}                 = 'esta es la ayuda del campo '.$campo;
                $hash_campos{'subcampos_array'}             = \@result;

                push (@result_total, \%hash_campos);

        }# END for(my $i=0;$i<scalar(@$nivel_info_marc_array);$i++)

    }# END if ($nivel_info_marc_array )

    return @result_total;
}

=head2
    sub agregarCamposVacios

    modifica el marc_record, le agrega los campos vacios configurados en la estructura de catalogacion
=cut
sub agregarCamposVacios {
    my ($marc_record, $estructura_array_ref) = @_;


    #recorro la estructura de catalogacion en busca de campos vacios que debe tener el marc_record
    for(my $j=0;$j<scalar(@$estructura_array_ref);$j++){

        my %hash_campos;
        my @subcampos_array;
        my $campo = $estructura_array_ref->[$j]->{'campo'};

#         C4::AR::Debug::debug("Catalogacion => agregarCamposVacios => proceso el campo => ===========================".$campo."==================================");
#         C4::AR::Debug::debug("Catalogacion => agregarCamposVacios => proceso el marc_record->field($campo) => ===========================".scalar($marc_record->field($campo))."==================================");

        my @campos_array = $marc_record->field($campo);

        #si el registro TIENE datos
        if(scalar(@campos_array) > 0){

            foreach my $c (@campos_array){
                foreach my $subcampo (@{$estructura_array_ref->[$j]->{'subcampos_array'}}){
                    if ( !$c->subfield( $subcampo->{'subcampo'} ) ) {
#                         C4::AR::Debug::debug("NO EXISTE el subcampo ".$subcampo->{'subcampo'}." => dato => ".$marc_record->field($campo)->subfield( $subcampo->{'subcampo'}));
                        $c->add_subfields( $subcampo->{'subcampo'} => " " );
                    }
                }
            }
        } else {
        #si el registro NO TIENE datos

            my $campo_subcampo;

            foreach my $subcampo (@{$estructura_array_ref->[$j]->{'subcampos_array'}}){
#                 C4::AR::Debug::debug("Catalogacion => agregarCamposVacios => cant subcampos => ".scalar(@{$estructura_array_ref->[$j]->{'subcampos_array'}}));

                if (!$campo_subcampo){
                #no existe el campo, lo creo!!!
                    $campo_subcampo = MARC::Field->new(
                                        $campo, " ", " ", $subcampo->{'subcampo'} => " "
                            );
                } else {
                    $campo_subcampo->add_subfields( $subcampo->{'subcampo'} => " " );
                }

#                 $marc_record->append_fields( $campo_subcampo );
            }

            $marc_record->append_fields( $campo_subcampo );
        }
    }# END for(my $j=0;$j<scalar(@$catalogaciones_array_ref);$j++)

#     C4::AR::Debug::debug("Catalogacion => agregarCamposVacios => as_formatted => ".$marc_record->as_formatted);
}

sub getEstructuraSinDatos {
    my ($params) = @_;

    my $nivel       = $params->{'nivel'};
    my $itemType    = $params->{'id_tipo_doc'};
    my $orden       = $params->{'orden'};

    #obtengo todos los campos <> de la estructura de catalogacion del Nivel 1, 2 o 3
    my ($cant, $campos_array_ref) = getCamposFromEstructura($nivel, $itemType);

    my @result_total;

    foreach my $c  (@$campos_array_ref){
        my %hash_campos;
        my @result;
        #obtengo todos los subcampos de la estructura de catalogacion segun el campo
        my ($cant, $subcampos_array_ref) = getSubCamposFromEstructuraByCampo($c->getCampo, $nivel, $itemType);

        foreach my $sc  (@$subcampos_array_ref){
            my %hash;

            $hash{'tiene_estructura'}  = '1';
            $hash{'dato'}              = '';
            $hash{'datoReferencia'}    = "NULL";

            my ($hash_temp) = _setDatos_de_estructura($sc, \%hash);

            push (@result, $hash_temp);
        }

        my %hash_campos;

        $hash_campos{'campo'}                   = $c->getCampo;
        $hash_campos{'repetible'}               = $c->camposBase->getRepeatable;
        $hash_campos{'nombre'}                  = $c->camposBase->getLiblibrarian;
        $hash_campos{'indicador_primario'}      = $c->camposBase->getIndicadorPrimario;
        $hash_campos{'indicadores_primarios'}   = C4::AR::EstructuraCatalogacionBase::getIndicadorPrimarioFromEstructuraBaseByCampo( $c->getCampo );
        $hash_campos{'indicador_secundario'}    = $c->camposBase->getIndicadorSecundario;
        $hash_campos{'indicadores_secundarios'} = C4::AR::EstructuraCatalogacionBase::getIndicadorSecundarioFromEstructuraBaseByCampo( $c->getCampo );
        $hash_campos{'descripcion_campo'}       = $c->camposBase->getDescripcion.' - '.$c->getCampo;
        $hash_campos{'ayuda_campo'}             = 'esta es la ayuda del campo '.$c->getCampo;
        $hash_campos{'subcampos_array'}         = \@result;

        push (@result_total, \%hash_campos);

    }

    # devuelve scalar(@result_total) que es la cantidad de campos distintos con sus respectivos subcampos
    return (scalar(@result_total), \@result_total);
}


=head2
    sub getIndicadorPrimarioByCampo
    Trae todos los inficadores primarios segun el campo pasado por parametro
=cut
sub getIndicadorPrimarioByCampo {
    my ($campo) = @_;

    use C4::Modelo::PrefIndicadorPrimario::Manager;

    my $indicadores_array_ref = C4::Modelo::PrefIndicadorPrimario::Manager->get_pref_indicador_primario(
                                                                query => [
                                                                                campo_marc => { eq => $campo },

                                                                        ],

                                                                sort_by => ( 'dato' ),
                                                             );

    return ($indicadores_array_ref);
}

=head2
    sub getIndicadorSecundarioByCampo
    Trae todos los inficadores primarios segun el campo pasado por parametro
=cut
sub getIndicadorSecundarioByCampo{
    my ($campo) = @_;

    use C4::Modelo::PrefIndicadorSecundario::Manager;

    my $indicadores_array_ref = C4::Modelo::PrefIndicadorSecundario::Manager->get_pref_indicador_secundario(
                                                                query => [
                                                                                campo_marc => { eq => $campo },

                                                                        ],

                                                                sort_by => ( 'dato' ),
                                                             );

    return ($indicadores_array_ref);
}

sub getOpcionesFromIdicadorPrimarioByCampo{
    my ($campo, $subcampo) = @_;

    my ($indicadores_array_ref) = getIndicadorPrimarioByCampo($campo);
    my @array_valores;

    for(my $i=0; $i<scalar(@$indicadores_array_ref); $i++ ){
        my $valor;
        $valor->{"clave"}= $indicadores_array_ref->[$i]->getId;
        $valor->{"valor"}= $indicadores_array_ref->[$i]->getDato;

        push (@array_valores, $valor);
    }

    return (\@array_valores);
}

sub getOpcionesFromIdicadorSecundarioByCampo{
    my ($campo, $subcampo) = @_;

    my ($indicadores_array_ref) = getIndicadorSecundarioByCampo($campo);
    my @array_valores;

    for(my $i=0; $i<scalar(@$indicadores_array_ref); $i++ ){
        my $valor;
        $valor->{"clave"}= $indicadores_array_ref->[$i]->getId;
        $valor->{"valor"}= $indicadores_array_ref->[$i]->getDato;

        push (@array_valores, $valor);
    }

    return (\@array_valores);
}


sub _obtenerOpciones{
    my ($cat_estruct_object, $hash_ref) = @_;

#     C4::AR::Debug::debug("_obtenerOpciones => es un combo, se setean las opciones para => ".$cat_estruct_object->infoReferencia->getReferencia);
#     C4::AR::Debug::debug("_obtenerOpciones => getCampos => ".$cat_estruct_object->infoReferencia->getCampos);
    if ($cat_estruct_object->infoReferencia) {
        my $orden = $cat_estruct_object->infoReferencia->getCampos;
        my ($cantidad, $valores, $default_value) = &C4::AR::Referencias::obtenerValoresTablaRef(
                                                                $cat_estruct_object->infoReferencia->getReferencia,  #tabla
                                                                $cat_estruct_object->infoReferencia->getCampos,  #campo
                                                                $orden
                                                );
        $hash_ref->{'opciones'}         = $valores;
        $hash_ref->{'default_value'}    = $default_value;
    }
#     C4::AR::Debug::debug("_obtenerOpciones => opciones => ".$valores);
}


=head2 t_guardarEnEstructuraCatalogacion
Esta transaccion guarda una estructura de catalogacion configurada por el bibliotecario
=cut
sub t_guardarEnEstructuraCatalogacion {
    my ($params) = @_;

## FIXME ver si falta verificar algo!!!!!!!!!!
    my $msg_object          = C4::AR::Mensajes::create();

    _verificar_campo_subcampo_to_estructura($msg_object, $params->{'campo'}, $params->{'subcampo'}, $params->{'nivel'}, $params->{'itemtype'});

    if(!$msg_object->{'error'}){
    #No hay error
        my  $estrCatalogacion = C4::Modelo::CatEstructuraCatalogacion->new();
        my $db = $estrCatalogacion->db;
        # enable transactions, if possible
        $db->{connect_options}->{AutoCommit} = 0;

#        eval {
            $estrCatalogacion->agregar($params);
            $db->commit;
            $msg_object->{'error'} = 0;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U364', 'params' => []} ) ;
#        };

        if ($@){
            $msg_object          = C4::AR::Mensajes::create();
            #Se loguea error de Base de Datos
            &C4::AR::Mensajes::printErrorDB($@, 'B426',"INTRA");
            $db->rollback;
            #Se setea error para el usuario
            $msg_object->{'error'} = 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U365', 'params' => []} ) ;
        }

        $db->{connect_options}->{AutoCommit} = 1;

    }

    return ($msg_object);
}


sub t_guardarAsociarRegistroFuente {
    my ($params) = @_;

    my $msg_object          = C4::AR::Mensajes::create();

    if(!$msg_object->{'error'}){
    #No hay error

        my $analitica   = C4::Modelo::CatRegistroMarcN2Analitica->new();
        my $db          = $analitica->db;
        # enable transactions, if possible
        $db->{connect_options}->{AutoCommit} = 0;

        # eval {
            $analitica->asociarARegistroFuente($params, $db);
            $db->commit;
            $msg_object->{'error'} = 0;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U617', 'params' => []} ) ;
        # };

        # if ($@){
        #     $msg_object = C4::AR::Mensajes::create();
        #     #Se loguea error de Base de Datos
        #     &C4::AR::Mensajes::printErrorDB($@, 'B426',"INTRA");
        #     $db->rollback;
        #     #Se setea error para el usuario
        #     $msg_object->{'error'} = 1;
        #     C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U618', 'params' => []} ) ;
        # }

        $db->{connect_options}->{AutoCommit} = 1;

    }

    return ($msg_object);
}


sub t_guardarDesAsociarRegistroFuente {
    my ($params) = @_;

    my $msg_object          = C4::AR::Mensajes::create();

    if(!$msg_object->{'error'}){
    #No hay error
        my $db   = C4::Modelo::CatRegistroMarcN2Analitica->new()->db;

        eval {
            # enable transactions, if possible
            $db->{connect_options}->{AutoCommit} = 0;
            my $nivel2_analiticas_array_ref = C4::AR::Nivel2::getAllAnaliticasById1($params->{'id1'}, $db);

            foreach $a (@$nivel2_analiticas_array_ref){
                $a->delete();
            };

            $db->commit;
            $msg_object->{'error'} = 0;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U619', 'params' => []} ) ;
        };

        if ($@){
            $msg_object = C4::AR::Mensajes::create();
            #Se loguea error de Base de Datos
            &C4::AR::Mensajes::printErrorDB($@, 'B426',"INTRA");
            $db->rollback;
            #Se setea error para el usuario
            $msg_object->{'error'} = 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U618', 'params' => []} ) ;
        }

        $db->{connect_options}->{AutoCommit} = 1;

    }

    return ($msg_object);
}

sub t_eliminarRelacion {
    my ($params) = @_;

    my $msg_object                          = C4::AR::Mensajes::create();
    my  $cat_registro_marc_n2_analitica     = C4::Modelo::CatRegistroMarcN2Analitica->new();
    my $db                                  = $cat_registro_marc_n2_analitica->db;

    if(!$msg_object->{'error'}){
    #No hay error

        my $cat_registro_marc_n2_analitica  = C4::AR::Nivel2::getAnaliticasFromRelacion($params);

        if(!$cat_registro_marc_n2_analitica){
            #no existe la analitica
            $msg_object = C4::AR::Mensajes::create();
            #Se setea error para el usuario
            $msg_object->{'error'} = 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U616', 'params' => [$params->{'id1'}]} ) ;
        } else {

            # enable transactions, if possible
            $db->{connect_options}->{AutoCommit} = 0;

            eval {
                $cat_registro_marc_n2_analitica->eliminar($params);
                $db->commit;
                $msg_object->{'error'} = 0;
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U619', 'params' => []} ) ;
            };

            if ($@){
                $msg_object = C4::AR::Mensajes::create();
                #Se loguea error de Base de Datos
                &C4::AR::Mensajes::printErrorDB($@, 'B426',"INTRA");
                $db->rollback;
                #Se setea error para el usuario
                $msg_object->{'error'} = 1;
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U618', 'params' => []} ) ;
            }

            $db->{connect_options}->{AutoCommit} = 1;

        }

    }

    return ($msg_object);
}

=head2 sub _verificar_campo_subcampo_to_estructura
=cut
sub _verificar_campo_subcampo_to_estructura{
    my ($msg_object, $campo, $subcampo, $nivel, $itemtype) = @_;

    my $campos_autorizados  = C4::AR::EstructuraCatalogacionBase::getSubCamposByNivel($nivel);
    my %autorizados;
    my $campo_subcampo_array; #campo y subcampo que se va agregar
    $msg_object->{'error'}  = 0;

    #armo el arreglo de campo => [subcampos] autorizados
    foreach my $autorizado (@$campos_autorizados){
       push(@{$autorizados{$autorizado->getCampo()}},$autorizado->getSubcampo());
    }

    #recupero el campo y subcampo de la BIBLIA para verificar la existencia
    my ($cat_estructura_base) = C4::AR::EstructuraCatalogacionBase::getEstructuraBaseFromCampoSubCampo($campo, $subcampo);

    if(!$cat_estructura_base){
        #NO EXISTE el campo, subcampo
        $msg_object->{'error'} = 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U412', 'params' => [" el campo ".$campo.", ".$subcampo." NO EXISTE"]} ) ;
        C4::AR::Debug::debug("_verificar_campo_subcampo_to_estructura => NO EXISTE el campo, subcampo".$campo.", ".$subcampo);
    }elsif (!C4::AR::Utilidades::existeInArray($subcampo, @{$autorizados{$campo}})) {
        #el campo, subcampo NO ESTA AUTORIZADO
        $msg_object->{'error'} = 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U412', 'params' => [" NO ESTA AUTORIZADO ".$campo.", ".$subcampo]} ) ;
        C4::AR::Debug::debug("_verificar_campo_subcampo_to_estructura => NO ESTA AUTORIZADO el campo, subcampo".$campo.", ".$subcampo);
    }elsif (_existeConfiguracionEnCatalogo($campo, $subcampo, $itemtype, $nivel)) {
        #el subcampo NO ES REPETIBLE y ya EXISTE en la ESTRUCTURA
# FIXME WF
        $msg_object->{'error'} = 1;#NO ES ERROR SE INFORMA AL USUARIO Y SE CAMBIA LA VISIBILIDAD CONFIGURADA (campo, subcampo, itemtype)
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U412', 'params' => ["ya se encuentra configurado el campo ".$campo.", ".$subcampo.", ".$itemtype." para el nivel ".$nivel]} ) ;
        C4::AR::Debug::debug("_verificar_campo_subcampo_to_estructura => NO SE PUEDE REPETIR el campo, subcampo".$campo.", ".$subcampo.", ".$itemtype." para el nivel ".$nivel);
    }

}
###############################################################A PARTIR DE ESTE PUNTO ES LO VIEJO########################################


=item sub cambiarVisibilidad
Esta funcion cambia la visibilidad de la estructura de catalogacion que se indica segun parametro ID
=cut
sub cambiarVisibilidad{
    my ($id) = @_;

    my $catalogacion = getEstructuraCatalogacionById($id);

    if($catalogacion){
        $catalogacion->cambiarVisibilidad();
     }else{
        C4::AR::Debug::debug("Catalogacion => cambiarVisibilidad => NO EXISTE EL ID DE LA ESTRUCTURA QUE SE INTENTA MODIFICAR");
    }
}

=item sub cambiarEdicionGrupal
Esta funcion cambia la visibilidad de la estructura de catalogacion que se indica segun parametro ID
=cut
sub cambiarEdicionGrupal{
    my ($id) = @_;

    my $catalogacion = getEstructuraCatalogacionById($id);

    if($catalogacion){
        $catalogacion->cambiarEdicionGrupal();
     }else{
        C4::AR::Debug::debug("Catalogacion => cambiarEdicionGrupal => NO EXISTE EL ID DE LA ESTRUCTURA QUE SE INTENTA MODIFICAR");
    }
}

sub cambiarHabilitado{
    my ($id) = @_;

    my $catalogacion = getEstructuraCatalogacionById($id);

    if($catalogacion){
        $catalogacion->cambiarHabilitado();
     }else{
        C4::AR::Debug::debug("Catalogacion => cambiarVisibilidad => NO EXISTE EL ID DE LA ESTRUCTURA QUE SE INTENTA MODIFICAR");
    }
}
=item sub eliminarCampo
Esta funcion elimina un "campo", estructura de catalogacion, segun parametro ID
=cut
sub eliminarCampo{
    my ($params) = @_;

    my $id      = $params->{'id'};
    my $nivel   = $params->{'nivel'};

    #verifica que el campo q se esta intentando eliminar no se este utilizando en el nivel correspondiente
    my $catalogacion = getEstructuraCatalogacionById($id);
# TODO falta modularizar
#     if($catalogacion){
#         $params->{'campo'} = $catalogacion->getCampo;
#
#         if(campoEnUsoFromNivel($params)){
#             C4::AR::Debug::debug("EL CAMPO se esta  USANDOOOOOOOOOOOOOOOO ");
#         } else {
#             $catalogacion->delete();
#         }
#
#     }else{
#         C4::AR::Debug::debug("Catalogacion => eliminarCampo => NO EXISTE EL ID DE LA ESTRUCTURA QUE SE INTENTA MODIFICAR");
#     }

    if($catalogacion){
        $catalogacion->delete();
     }else{
        C4::AR::Debug::debug("Catalogacion => eliminarCampo => NO EXISTE EL ID DE LA ESTRUCTURA QUE SE INTENTA MODIFICAR");
    }
}


# TODO Miguel, parece q esto esta al pedo estoy probando
sub campoEnUsoFromNivel {
    my ($params)    = @_;

    my $existe      = 0;
# TODO falta modularizar

    if( $params->{'nivel'} eq '1'){
        my $nivel_array_ref = C4::AR::Nivel1::getNivel1Completo();

        foreach my $nivel (@$nivel_array_ref){
           my  $nivel_info_marc_array = $nivel->toMARC;

            for(my $i=0;$i<scalar(@$nivel_info_marc_array);$i++){
                if($nivel_info_marc_array->[$i]->{'campo'}){
                    C4::AR::Debug::debug("EL CAMPO se esta  USANDOOOOOOOOOOOOOOOO ");
                    $existe = 1;
                }

                last if ($existe);
            }

            last if ($existe);
        }

        C4::AR::Debug::debug("Catalogacion => campoEnUsoFromNivel=> verifico existencia de campo en nivel 1");
    }
    elsif( $params->{'nivel'} eq '2'){
        C4::AR::Debug::debug("Catalogacion => campoEnUsoFromNivel=> verifico existencia de campo en nivel 2");
    }
    elsif( $params->{'nivel'} eq '3'){
#         $existe = C4::AR::Nivel3::seUsaCampo($params->{'campo'});
        C4::AR::Debug::debug("Catalogacion => campoEnUsoFromNivel=> verifico existencia de campo en nivel 3");

        my $nivel_array_ref = C4::AR::Nivel3::getNivel3Completo();

        foreach my $nivel (@$nivel_array_ref){
           my  $nivel_info_marc_array = $nivel->toMARC;

            for(my $i=0;$i<scalar(@$nivel_info_marc_array);$i++){
                if($nivel_info_marc_array->[$i]->{'campo'}){
                    C4::AR::Debug::debug("EL CAMPO se esta  USANDOOOOOOOOOOOOOOOO ");
                    $existe = 1;
                }

                last if ($existe);
            }

            last if ($existe);
        }

    }

    return $existe;

}


sub verificarModificarEnEstructuraCatalogacion {
    my($params, $msg_object) = @_;

#     if( !($msg_object->{'error'}) && ( $params->{'newpassword'} ne $params->{'newpassword1'} ) ){
    #verifico si se cambia el validador, que no tenga referencia
#         $msg_object->{'error'}= 1;
#         C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U315', 'params' => [$params->{'cardnumber'}]} ) ;
#     }

}

=item sub t_modificarEnEstructuraCatalogacion
Esta transaccion guarda una estructura de catalogacion configurada por el bibliotecario
=cut
sub t_modificarEnEstructuraCatalogacion {
    my($params) = @_;

## FIXME ver si falta verificar algo!!!!!!!!!!
    my $msg_object = C4::AR::Mensajes::create();

    my $estrCatalogacion = getEstructuraCatalogacionById($params->{'id'});

    if(!$estrCatalogacion){
        #Se setea error para el usuario
        $msg_object->{'error'} = 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U405', 'params' => []} ) ;
    }

    if(!$msg_object->{'error'}){
    #No hay error
        my $db = $estrCatalogacion->db;
        # enable transactions, if possible
        $db->{connect_options}->{AutoCommit} = 0;

        eval {
            $estrCatalogacion->modificar($params);
            $db->commit;
            #se cambio el permiso con exito
            $msg_object->{'error'}= 0;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U366', 'params' => []} ) ;
        };

        if ($@){
            #Se loguea error de Base de Datos
            &C4::AR::Mensajes::printErrorDB($@, 'B426',"INTRA");
            $db->rollback;
            #Se setea error para el usuario
            $msg_object->{'error'}= 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U367', 'params' => []} ) ;
        }

        $db->{connect_options}->{AutoCommit} = 1;

    }

    return ($msg_object);
}


#======================================================SOPORTE PARA ESTRUCTURA CATALOGACION====================================================


=head2
sub getSubCamposFromEstructuraByCampo

=cut

sub getSubCamposFromEstructuraByCampo{
    my ($campo, $nivel, $itemType) = @_;

    my $catalogaciones_array_ref = C4::Modelo::CatEstructuraCatalogacion::Manager->get_cat_estructura_catalogacion(
                                                                query => [
                                                                                nivel => { eq => $nivel },
                                                                                campo => { eq => $campo },

                                                                    or   => [
                                                                                itemtype => { eq => $itemType },
                                                                                itemtype => { eq => 'ALL' },
                                                                            ],

                                                                                intranet_habilitado => { gt => 0 },
                                                                        ],

                                                                with_objects    => [ 'infoReferencia' ],  #LEFT OUTER JOIN
                                                                require_objects => [ 'camposBase', 'subCamposBase' ], #INNER JOIN
                                                                sort_by => ( 'subcampo' ),
                                                             );

    return (scalar(@$catalogaciones_array_ref), $catalogaciones_array_ref);
}


=item sub getCamposFromEstructura

Esta funcion trae todos los campos segun nivel e itemtype
ademas trae los indicadores Primero y Segundo (SI ES QUE EXISTE)

=cut
sub getCamposFromEstructura{
    my ($nivel, $itemType) = @_;

    my $catalogaciones_array_ref = C4::Modelo::CatEstructuraCatalogacion::Manager->get_cat_estructura_catalogacion(
                                                                distinct => 1,
                                                                select   => [ 'campo' ],

                                                                query => [
                                                                                nivel => { eq => $nivel },

                                                                    or   => [
                                                                                itemtype => { eq => $itemType },
                                                                                itemtype => { eq => 'ALL' },
                                                                            ],

                                                                                intranet_habilitado => { gt => 0 },
                                                                        ],

                                                                with_objects    => [ 'infoReferencia' ],  #LEFT OUTER JOIN
                                                                require_objects => [ 'camposBase', 'subCamposBase' ],
#                                                                 sort_by => ( 'intranet_habilitado' ),
                                                                sort_by => ( 'campo' ),
                                                             );

    return (scalar(@$catalogaciones_array_ref), $catalogaciones_array_ref);
}



=item sub cantNivel2
     devuelve la cantidad de Niveles 2 que tiene  relacionados el Nivel 1 con id1 pasado por parameto
=cut
sub cantNivel2 {
    my ($id1) = @_;

    my $count = C4::Modelo::CatRegistroMarcN2::Manager->get_cat_registro_marc_n2_count( query => [ id => { eq => $id1 } ]);

    return $count;
}

=head2
=cut
sub getDatosFromNivel{
    my ($params) = @_;

#     C4::AR::Debug::debug("Catalogacion => getDatosFromNivel => ======================================================================");
    my $nivel       = $params->{'nivel'};
    my $itemType    = $params->{'id_tipo_doc'};

#     C4::AR::Debug::debug("Catalogacion => getDatosFromNivel => tipo de documento: ".$itemType);

    #obtengo los datos de nivel 1, 2 y 3 mapeados a MARC, con su informacion de estructura de catalogacion
    my @resultEstYDatos = getEstructuraYDatosDeNivel($params);

    my @sorted = sort { $a->{campo} cmp $b->{campo} } @resultEstYDatos; # alphabtical sort

    return (scalar(@resultEstYDatos), \@sorted);
}



# ESTO NO ANDA AUN!!!!!!!!
sub setear_campos_en_blanco {
    my ($params, $campos_array_ref) = @_;
#     C4::AR::Debug::debug("getEstructuraSinDatos ============================================================================INI");

    my $nivel       =  $params->{'nivel'};
    my $itemType    =  $params->{'id_tipo_doc'};
    my $orden       =  $params->{'orden'};

    #obtengo todos los campos <> de la estructura de catalogacion del Nivel 1, 2 o 3
    my ($cant, $campos_array_ref) = getCamposFromEstructura($nivel, $itemType);

#     C4::AR::Debug::debug("getEstructuraSinDatos => cant campos distintos: ".$cant);
        my @result_total;

    foreach my $campo (@$campos_array_ref){



#         my $campo       = '';
#         my $campo_ant   = '';
        foreach my $c  (@$campos_array_ref){
    #         C4::AR::Debug::debug("campo => ".$c->getCampo);
            foreach my $subcampo (@{$c->{'subcampos_array'}}){

                my %hash_campos;
                my @result;
                #obtengo todos los subcampos de la estructura de catalogacion segun el campo
                my ($cant, $subcampos_array_ref) = getSubCamposFromEstructuraByCampo($c->getCampo, $nivel, $itemType);

                foreach my $sc  (@$subcampos_array_ref){
                    my %hash;
        #             C4::AR::Debug::debug("subcampo => ".$sc);

                    $hash{'tiene_estructura'}  = '1';
                    $hash{'dato'}              = '';
        #             $hash{'datoReferencia'}    = 0;
                    $hash{'datoReferencia'}    = "NULL";

                    my ($hash_temp) = _setDatos_de_estructura($sc, \%hash);
        #             C4::AR::Debug::debug("getEstructuraSinDatos => campo, subcampo: ".$c->getCampo.", ".$sc->getSubcampo);

                    push (@result, $hash_temp);
                }

                my %hash_campos;

                $hash_campos{'campo'}                   = $c->getCampo;
                $hash_campos{'repetible'}               = $c->camposBase->getRepeatable;
                $hash_campos{'nombre'}                  = $c->camposBase->getLiblibrarian;
                $hash_campos{'indicador_primario'}      = $c->camposBase->getIndicadorPrimario;
                $hash_campos{'indicadores_primarios'}   = C4::AR::EstructuraCatalogacionBase::getIndicadorPrimarioFromEstructuraBaseByCampo( $c->getCampo );
                $hash_campos{'indicador_secundario'}    = $c->camposBase->getIndicadorSecundario;
                $hash_campos{'indicadores_secundarios'} = C4::AR::EstructuraCatalogacionBase::getIndicadorSecundarioFromEstructuraBaseByCampo( $c->getCampo );
                $hash_campos{'descripcion_campo'}       = $c->camposBase->getDescripcion.' - '.$c->getCampo;
                $hash_campos{'ayuda_campo'}             = 'esta es la ayuda del campo '.$c->getCampo;
                $hash_campos{'subcampos_array'}         = \@result;

                push (@result_total, \%hash_campos);

            }

        }


    }

#     C4::AR::Debug::debug("getEstructuraSinDatos ============================================================================FIN");

    # devuelve scalar(@result_total) que es la cantidad de campos distintos con sus respectivos subcampos
    return (\@result_total);
}

=item sub getEstructuraCatalogacionFromDBCompleta
    Retorna la estructura de catalogacion del Nivel 1, 2 o 3 que se encuentra configurada en la BD
=cut
sub getEstructuraCatalogacionFromDBCompleta{
    my ($nivel, $itemType) = @_;
# C4::AR::Debug::debug("getEstructuraCatalogacionFromDBCompleta => itemType => ".$itemType);

    my $catalogaciones_array_ref = C4::Modelo::CatEstructuraCatalogacion::Manager->get_cat_estructura_catalogacion(
                                                                query => [
                                                                                nivel => { eq => $nivel },

                                                                    or   => [
                                                                                itemtype => { eq => $itemType },
                                                                                itemtype => { eq => 'ALL' },
                                                                            ],

                                                                        ],

                                                                sort_by => ( 'campo, subcampo' ),
                                                             );


    return (scalar(@$catalogaciones_array_ref), $catalogaciones_array_ref);
}


=head2 sub _getEstructuraFromCampoSubCampo
    Este funcion devuelve la configuracion de la estructura de catalogacion de un campo, subcampo, realizada por el usuario
=cut
sub _existeConfiguracionEnCatalogo{
    my ($campo, $subcampo, $itemtype, $nivel, $db) = @_;

    $db = $db || C4::Modelo::CatEstructuraCatalogacion->new()->db;
    my @filtros;

    push ( @filtros, ( campo      => { eq => $campo } ) );
    push ( @filtros, ( subcampo   => { eq => $subcampo } ) );
    push ( @filtros, ( nivel      => { eq => $nivel } ) );
    push ( @filtros, ( or   => [   itemtype   => { eq => $itemtype } ]));

    my $cat_estruct_info_array = C4::Modelo::CatEstructuraCatalogacion::Manager->get_cat_estructura_catalogacion(
                                                                                db              => $db,
                                                                                query           =>  \@filtros,
#                                                                 FIXME es necesario????????????
                                                                                with_objects    => ['infoReferencia'],#LEFT JOIN
                                                                                require_objects => [ 'subCamposBase' ] #INNER JOIN

                                        );


    if(scalar(@$cat_estruct_info_array) > 0){
        return 1;
    } else {
        return 0;
    }
}

=head2 sub _getEstructuraFromCampoSubCampo
    Este funcion devuelve la configuracion de la estructura de catalogacion de un campo, subcampo, realizada por el usuario
=cut
sub _getEstructuraFromCampoSubCampo{
	my ($campo, $subcampo, $itemtype, $nivel, $db) = @_;
	#TESTING CACHE MERAN
	my $cacheKey = $campo.$subcampo.$nivel.$itemtype;
	if (! defined C4::AR::CacheMeran::obtener($cacheKey)){
		#Si no esta en la cache entonces lo busco en la base y lo cacheo
		$db = $db || C4::Modelo::CatEstructuraCatalogacion->new()->db;
		my @filtros;
		push(@filtros, ( campo      => { eq => $campo } ) );
		push(@filtros, ( subcampo   => { eq => $subcampo } ) );

		if ($nivel != 0){
			push(@filtros, ( nivel      => { eq => $nivel } ) );
		}

		push (  @filtros, ( or   => [   itemtype   => { eq => $itemtype },
					itemtype   => { eq => 'ALL'     }
					])
		     );

		my $cat_estruct_info_array= C4::Modelo::CatEstructuraCatalogacion::Manager->get_cat_estructura_catalogacion(
				db              => $db,
				query           =>  \@filtros,
#                                                                 FIXME es necesario????????????
				with_objects    => ['infoReferencia'],#LEFT JOIN
				require_objects => [ 'subCamposBase' ] #INNER JOIN
				);
		#elimino configuraciones duplicadas (configuracion para un mismo campo, subcampo, nivel pero para dos itemtypes distintos como puede ser ALL y LIB) si es que existen, dejando la configuracion mas especifica
		if(scalar(@$cat_estruct_info_array) > 1){
        		#hay dos configuraciones para campo, subcampo, nivel, tipo_ejemplar
			for (my $i=0;$i < scalar(@$cat_estruct_info_array);$i++){
				if($cat_estruct_info_array->[$i]->getItemType() eq $itemtype){
					C4::AR::CacheMeran::setear($cacheKey, $cat_estruct_info_array->[$i]);
					return C4::AR::CacheMeran::obtener($cacheKey);
				} elsif ($cat_estruct_info_array->[$i]->getItemType() eq "ALL") {
					C4::AR::CacheMeran::setear($cacheKey, $cat_estruct_info_array->[$i]);
				} 

			}
		} else {
			if(scalar(@$cat_estruct_info_array) > 0){
				#Hay solo un resultado
                C4::AR::CacheMeran::setear($cacheKey, $cat_estruct_info_array->[0]);
                }
                else {
				C4::AR::CacheMeran::setear($cacheKey, 0);
			}
		}
	}

	return C4::AR::CacheMeran::obtener($cacheKey)
}

=item sub getEstructuraCatalogacionById
Este funcion devuelve la configuracion de la estructura de catalogacion segun id pasado por parametro
=cut
sub getEstructuraCatalogacionById{
    my ($id, $db) = @_;

    $db = $db || C4::Modelo::PermCatalogo->new()->db;

    my $cat_estructura_catalogacion_array_ref = C4::Modelo::CatEstructuraCatalogacion::Manager->get_cat_estructura_catalogacion(
                                                                                db      => $db,
                                                                                query   => [
                                                                                            id => { eq => $id },
                                                                                    ],

                                        );

    if(scalar(@$cat_estructura_catalogacion_array_ref) > 0){
        return $cat_estructura_catalogacion_array_ref->[0];
    }else{
        return 0;
    }
}


sub getOrdenFromCampoSubcampo{
    my ($campo, $subcampo, $itemtype, $type, $nivel, $db) = @_;

    $db = $db || C4::Modelo::CatEstructuraCatalogacion->new()->db;

    if($type eq "INTRA"){

        my $conf_visualizacion = C4::AR::VisualizacionIntra::getVisualizacionFromCampoSubCampo($campo, $subcampo, $itemtype, $nivel, $db);

#         C4::AR::Debug::debug("C4::AR::Catalogacion::getOrdenFromCampoSubcampo => campo ".$campo." subcampo ".$subcampo." itemtype!!!!!!!!!!!!!!!!!!! ".$itemtype);
        if($conf_visualizacion){
            return $conf_visualizacion->getOrden();
        }

    } else {
#         C4::AR::Debug::debug("C4::AR::Catalogacion::getOrdenFromCampoSubcampo => campo ".$campo." subcampo ".$subcampo." itemtype ".$itemtype);
        my $conf_visualizacion = C4::AR::VisualizacionOpac::getVisualizacionFromCampoSubCampo($campo, $subcampo, $itemtype, $nivel, $db);

#         my $conf_visualizacion = C4::AR::VisualizacionOpac::getVisualizacionFromCampoSubCampo($campo, $subcampo, C4::AR::Preferencias::getValorPreferencia("perfil_opac"),$db);

        if($conf_visualizacion){
            return $conf_visualizacion->getOrden();
        }
    }
}

sub getOrdenFromCampo{
    my ($campo, $nivel, $itemtype, $type, $db) = @_;

    $db = $db || C4::Modelo::CatEstructuraCatalogacion->new()->db;

    if($type eq "INTRA"){

        my $conf_visualizacion = C4::AR::VisualizacionIntra::getVisualizacionFromCampoAndNivel($campo, $nivel, $itemtype, $db);

        if($conf_visualizacion){
            return $conf_visualizacion->getOrden();
        }

    } else {

        my $conf_visualizacion = C4::AR::VisualizacionOpac::getVisualizacionFromCampoAndNivel($campo, $nivel, $itemtype, $db);

        if($conf_visualizacion){
            return $conf_visualizacion->getOrden();
        }
    }
}


sub getLiblibrarian{
    my ($campo, $subcampo, $itemtype, $type, $nivel, $db) = @_;

    $db = $db || C4::Modelo::CatEstructuraCatalogacion->new()->db;

    if($type eq "INTRA"){

        my $conf_visualizacion = C4::AR::VisualizacionIntra::getVisualizacionFromCampoSubCampo($campo, $subcampo, $itemtype, $nivel, $db);

        if($conf_visualizacion){
            return $conf_visualizacion->getVistaIntra();
        }

    } else {
        # TODO falta ver lo del perfil por ahora lo deje FIXEEEEEEEEDD
        my $conf_visualizacion = C4::AR::VisualizacionOpac::getVisualizacionFromCampoSubCampo($campo, $subcampo, $itemtype, $nivel, $db);

        if($conf_visualizacion){
            return $conf_visualizacion->getVistaOpac();
        }
    }

    #primero busca en estructura_catalogacion
    my $estructura_array = C4::AR::Catalogacion::_getEstructuraFromCampoSubCampo($campo, $subcampo, $itemtype, $nivel, $db);


    if($estructura_array){
        return $estructura_array->getLiblibrarian;
    }else{
        my ($pref_estructura_sub_campo_marc_array) = C4::Modelo::PrefEstructuraSubcampoMarc::Manager->get_pref_estructura_subcampo_marc(
                                                                                    query   => [  campo       => { eq => $campo },
                                                                                                subcampo    => { eq => $subcampo }
                                                                                                ],
                                                                                    db      => $db,
                                                                    );
        #si no lo encuentra en estructura_catalogacion, lo busca en estructura_sub_campo_marc
        if(scalar(@$pref_estructura_sub_campo_marc_array) > 0){
            return  $pref_estructura_sub_campo_marc_array->[0]->getLiblibrarian
        }else{
            return 0;
        }
    }
}



sub getDocumentById{
    my ($file_id) = @_;
    use C4::Modelo::EDocument::Manager;

    my ($file) = C4::Modelo::EDocument::Manager->get_e_document( query => [ id => { eq => $file_id } ] );

    if (scalar(@$file)){
        return ($file->[0]);
    }

    return (undef);

}

sub getIndiceFile{
    my ($id2) = @_;
    use C4::Modelo::EDocument::Manager;

    my ($nivel2) = C4::AR::Nivel2::getNivel2FromId2($id2);

    if ($nivel2){
        return ($nivel2,$nivel2->getIndiceFilePath);
    }else{
    	return ($nivel2,undef);
    }

}

sub saveEDocument{
    my ($id2,$filepath,$file_type,$name) = @_;

    my $e_doc = C4::Modelo::EDocument->new();
    $e_doc->agregar($id2,$filepath,$file_type,$name);

}

sub saveIndice{
    my ($id2,$filepath) = @_;

    my $nivel2 = C4::AR::Nivel2::getNivel2FromId2($id2);
    
    $nivel2->setIndiceFilePath($filepath);
    $nivel2->save();

}

sub getHeader{
    my ($campo) = @_;
    use C4::Modelo::PrefEstructuraCampoMarc;
    use C4::Modelo::PrefEstructuraCampoMarc::Manager;

    my ($pref_estructura_campo_marc_array) = C4::Modelo::PrefEstructuraCampoMarc::Manager->get_pref_estructura_campo_marc(
                                                                                    query => [ campo => { eq => $campo } ]
                                                                    );

    if(scalar(@$pref_estructura_campo_marc_array) > 0){
        return $pref_estructura_campo_marc_array->[0]->getLiblibrarian;
    }else{
        return 0;
    }
}

sub toOAIXML{
    my ($dc,$id1) = @_;

    my $server      = $ENV{'SERVER_NAME'};
    my $proto       = ($ENV{'SERVER_PORT'} eq 443)?"https://":"http://";
    my $prefix   = $proto.$server.C4::AR::Utilidades::getUrlPrefix();
    my $url = $prefix."/opac-detail.pl?id1=".$id1;

    my $xml = "\n <rdf:Description rdf:about='$url'> \n";

    while ( my ($key, $value) = each(%$dc) ) {

            foreach my $campo (@$value){
                my $campo_name = $key;
                    $campo_name = C4::AR::Utilidades::str_replace("_",":",$campo_name);
                    my $xml_field_name= lc($campo_name);
                    $xml .= "<$xml_field_name>".$campo->content."</$xml_field_name>\n";
            }
    }

    $xml .= "</rdf:Description> \n";

    return ($xml);
}

sub headerDCXML{

    my $headerDCXML ='
    <?xml version="1.0"?>
    <!DOCTYPE rdf:RDF PUBLIC "-//DUBLIN CORE//DCMES DTD 2002/07/31//EN"
        "http://dublincore.org/documents/2002/07/31/dcmes-xml/dcmes-xml-dtd.dtd">
    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dc="http://purl.org/dc/elements/1.1/">';

    return $headerDCXML;
}

sub footerDCXML{

    my $footerDCXML = '</rdf:RDF>';

    return $footerDCXML;
}

sub existeNivel1{
    my ($titulo, $autor) = @_;

# TODO validar 100,a; 110,a; 245,a; 700, a

    use Sphinx::Search;
    use Text::Unaccent;

    my $sphinx      = Sphinx::Search->new();
    $titulo         = unac_string('utf8',$titulo);
    $autor          = unac_string('utf8',$autor);
    my $query       = '@titulo "'.$titulo.'"';
       $query      .= ' @autor "'.$autor.'"';
    my $tipo        = 'SPH_MATCH_PHRASE';
    my $tipo_match  = C4::AR::Utilidades::getSphinxMatchMode($tipo);

    $sphinx->SetMatchMode($tipo_match);
    $sphinx->SetSortMode(SPH_SORT_RELEVANCE);
    $sphinx->SetEncoders(\&Encode::encode_utf8, \&Encode::decode_utf8);
    # NOTA: sphinx necesita el string decode_utf8
    my $results = $sphinx->Query($query);
#     C4::AR::Debug::debug("C4::AR::Busqueda::existeNivel1 => query: ".$query);
#     C4::AR::Debug::debug("C4::AR::Busqueda::existeNivel1 => matchmode: ".$tipo);

    my @id1_array;
    my $matches                 = $results->{'matches'};
    my $total_found             = $results->{'total_found'};

#     C4::AR::Debug::debug("C4::AR::Busqueda::existeNivel1 => total_found: ".$total_found);

    foreach my $hash (@$matches){
      my %hash_temp         = {};
      $hash_temp{'id1'}     = $hash->{'doc'};
      $hash_temp{'hits'}    = $hash->{'weight'};

      push (@id1_array, \%hash_temp);
    }

    return (scalar(@id1_array), \@id1_array);
}


sub updateBarcodeFormat{
    my ($tipo_documento,$format,$long) = @_;
    use C4::Modelo::BarcodeFormat::Manager;

    my $msg_object  = C4::AR::Mensajes::create();

    my $format_n3      = C4::Modelo::BarcodeFormat::Manager->get_barcode_format(query=> [id_tipo_doc => $tipo_documento],);

    if (!scalar(@$format_n3)){
        $format_n3 = C4::Modelo::BarcodeFormat->new();
    }else{
        $format_n3 = $format_n3->[0];
    }

    if ($format ne ""){
        eval{
            if (C4::AR::Utilidades::validateString($format)){
               $format = $format_n3->setFormat($format);
               $format_n3->setLong($long);
               $format_n3->setId_tipo_doc($tipo_documento);
               $format_n3->save();
               C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'CB001', 'params' => [$tipo_documento]} ) ;
            }
        };
    } else {
            $format = $format_n3->setFormat($format);
            $format_n3->setLong($long);
            $format_n3->setId_tipo_doc($tipo_documento);
            $format_n3->save();
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'CB003', 'params' => [$tipo_documento]} ) ;
    }

    if ($@){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'CB002', 'params' => [$tipo_documento]} ) ;
    }

    return ($msg_object);

}

sub getBarcodeFormat{
    my ($tipo_documento,$for_catalogue) = @_;
    use C4::Modelo::BarcodeFormat::Manager;

    $for_catalogue = $for_catalogue || 1;
    my $format = undef;
    my $default_format = C4::AR::Preferencias::getValorPreferencia("barcodeFormat");
    my $default_long   = C4::AR::Preferencias::getValorPreferencia("longitud_barcode");

    my $format_n3      = C4::Modelo::BarcodeFormat::Manager->get_barcode_format(query=> [id_tipo_doc => $tipo_documento],);

    if (!scalar(@$format_n3)){
        $format_n3 = C4::Modelo::BarcodeFormat->new();
    }else{
        $format_n3 = $format_n3->[0];
    }
    
    if (C4::AR::Utilidades::validateString($format_n3->getFormat())){
       $format = $format_n3->getFormat();
       $default_long = $format_n3->getLong()?$format_n3->getLong():$default_long;
    }else{
        if ($for_catalogue ne "NO"){
            $format = $default_format;
        }
    }

    return ($format,$default_long);

}



sub moverCampoMarcRecord {
    my ($marc_record,$old_field_tag,$new_field_tag) = @_;
    
    #Muevo el old_field_tag al new_field_tag
    my $old_field = $marc_record->field($old_field_tag);
    if($old_field){
        my @subcampos_array=();
        foreach my $subfield ($old_field->subfields()) {
            my $subcampo                = $subfield->[0];
            my $dato                    = $subfield->[1];
             push(@subcampos_array, ($subcampo => $dato));
        }
        
        #Agregamos el nuevo
        my $new_field = MARC::Field->new($new_field_tag, $old_field->indicator(1), $old_field->indicator(2), @subcampos_array);
        $marc_record->add_fields($new_field);
        
        #Borramos el viejo
        $marc_record->delete_fields($old_field);
    }
}

END { }       # module clean-up code here (global destructor)

1;
__END__
