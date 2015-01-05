package C4::Modelo::CatRegistroMarcN1;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'cat_registro_marc_n1',

    columns => [
        id                  => { type => 'serial', overflow => 'truncate', not_null => 1 },
        marc_record         => { type => 'text', overflow => 'truncate' },
        template            => { type => 'varchar', overflow => 'truncate', not_null => 1 },
        clave_unicidad      => { type => 'text', overflow => 'truncate', length => 65535, not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],

    relationships => [
        IndiceBusqueda => {
            class       => 'C4::Modelo::IndiceBusqueda',
            key_columns => { id => 'id' },
            type        => 'one to one',
        },
    ],
);

sub getId1{
    my ($self)  = shift;

    return $self->id;
}

sub getMarcRecord{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->marc_record));
}

sub hit{
    my ($self)  = shift;

    $self->IndiceBusqueda->hit();
}

sub getClaveUnicidad{
    my ($self) = shift;
    return ($self->clave_unicidad);
}


sub setClaveUnicidad{
    my ($self)          = shift;
    my ($clave)   = @_;

    $self->clave_unicidad($clave);
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

sub getSignaturas{
    my ($self)          = shift;
    my ($array_nivel2)        = @_;

    use C4::Modelo::CatRegistroMarcN2;

    if (!$array_nivel2){
        $array_nivel2 = C4::AR::Nivel2::getNivel2FromId1($self->getId1,$self->db);
    }

    my @signaturas;

    foreach my $nivel2 (@$array_nivel2){
        my $signaturas_nivel2 = $nivel2->getSignaturas;
        push (@signaturas, @$signaturas_nivel2);
    }

    return (\@signaturas);
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

=item
  sub setearLeader

  setea el LEADER según lo indicado desde el cliente
=cut
# TODO getter y setter de cada bit
sub setearLeader {
    my ($self)      = shift;
    my ($params)    = @_;

    my $nivel_bibliografico = C4::Modelo::RefNivelBibliografico->getByPk($params->{'id_nivel_bibliografico'});
    my $marc_record         = MARC::Record->new_from_usmarc($self->getMarcRecord());

# FIXME no me funciona el substr con reemplazo
    my $leader = substr($marc_record->leader(), 0, 7).$nivel_bibliografico->getCode().substr($marc_record->leader(), 8, 24);
    #seteo el nuevo LEADER
    $marc_record->leader($leader);
    C4::AR::Debug::debug("CatRegistroMarcN1 => setearLeader !!!!!!!!!!!!! ".$marc_record->leader());
    $self->setMarcRecord($marc_record->as_usmarc);

    $self->save();
}

sub generar_clave_unicidad {
    my ($self)          = shift;
    my ($marc_record)   = @_;

    use Digest::SHA  qw(sha1 sha1_hex sha1_base64 sha256_base64 );

    # $marc_record    = MARC::Record->new_from_usmarc($marc_record);

    my $clave       = "";
    my $autor_100   = $marc_record->subfield("100","a");
    # C4::AR::Debug::debug("CatRegistroMarcN1 => generar_clave_unicidad => CLAVE UNICIDAD => 100,a => ".$autor_100);   
    my $autor_110   = $marc_record->subfield("110","a");
    my $titulo      = $marc_record->subfield("245","a");

    $clave = $clave.$autor_100;
    $clave = $clave.$autor_110;
    $clave = $clave.$titulo;

    my @campos_array = $marc_record->field("700");
    my @ids_700;

    foreach my $campo (@campos_array){
        # $clave = $clave.$campo->subfield("a");               
        push (@ids_700, $campo->subfield("a"));
    }

    #ordeno el arreglo de ids del campo 700 en orden descendente
    @ids_700 = sort(@ids_700);

    foreach my $id (@ids_700){
        $clave = $clave.$id;               
        # C4::AR::Debug::debug("CatRegistroMarcN1 => generar_clave_unicidad => CLAVE UNICIDAD => id => ".$id);   
        # push (@ids_700, $campo->subfield("a"));
    }

    
    my $titulo_b = $marc_record->subfield("245","b");
    my $titulo_c = $marc_record->subfield("245","c");
    my $titulo_f = $marc_record->subfield("245","f");
    my $titulo_g = $marc_record->subfield("245","g");
    my $titulo_h = $marc_record->subfield("245","h");
    my $titulo_k = $marc_record->subfield("245","k");
    my $titulo_n = $marc_record->subfield("245","n");
    my $titulo_p = $marc_record->subfield("245","p");


    $clave = $clave.$titulo_b.$titulo_c.$titulo_f.$titulo_g.$titulo_h.$titulo_k.$titulo_n.$titulo_p;



    # C4::AR::Debug::debug("CatRegistroMarcN1 => generar_clave_unicidad => CLAVE UNICIDAD => clave antes de hashear => ".$clave); 
    $clave = C4::AR::Auth::hashear_password($clave, C4::AR::Auth::getMetodoEncriptacion());
    # C4::AR::Debug::debug("CatRegistroMarcN1 => generar_clave_unicidad => CLAVE UNICIDAD => ".$clave);    

    return $clave;
}

sub agregar{
    my ($self)                          = shift;
    my ($marc_record, $params, $db)     = @_;

    $self->setMarcRecord($marc_record);
    $self->setTemplate($params->{'id_tipo_doc'});
    $self->setClaveUnicidad($self->generar_clave_unicidad(MARC::Record->new_from_usmarc($marc_record)));
    $self->save();

    #si estoy guardano una analica, guardo en la tabla cat_registro_marc_n2_analitica el id1 que estoy generando
    #y la referencia al nivel 2, grupo al que pertenece la analitica
    if($params->{'id_tipo_doc'} eq "ANA"){
        my $cat_registro_n2_analitica = C4::Modelo::CatRegistroMarcN2Analitica->new( db => $db );
        $cat_registro_n2_analitica->setId2Padre($params->{'id2_padre'});
        $cat_registro_n2_analitica->setId1($self->getId1());
        $cat_registro_n2_analitica->save();
    }

    #seteo datos del LEADER
    $self->setearLeader($params);
}

sub tengoRegistroFuente {
    my ($self)  = shift;
    my ($db)    = @_;

    my $nivel2_analiticas_array_ref = C4::AR::Nivel2::getAllAnaliticasById1($self->getId1, $db);

    return scalar(@$nivel2_analiticas_array_ref) > 0;
}

sub modificar{
    my ($self)                  = shift;
    my ($marc_record, $params)  = @_;

    $self->setMarcRecord($marc_record);
    $self->setClaveUnicidad($self->generar_clave_unicidad(MARC::Record->new_from_usmarc($marc_record)));
    $self->save();

    #seteo datos del LEADER
    $self->setearLeader($params);
}


sub eliminar{
    my ($self)      = shift;
    my ($params)    = @_;

    #HACER ALGO SI ES NECESARIO

    my ($nivel2) = C4::AR::Nivel2::getNivel2FromId1($self->getId1(), $self->db);

    if ($nivel2){
        foreach my $n2 (@$nivel2){
          $n2->eliminar();
        }
    }

    #elimino los registros que puedan existir en la tabla de analiticas
    my ($nivel1_analiticas_array_ref) = C4::AR::Nivel2::getAllAnaliticasById1($self->getId1(), $self->db);

    eval{
        foreach my $n1 (@$nivel1_analiticas_array_ref){
            $n1->eliminar();
        }
    };

    $self->delete();  
}

sub getCDU{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

#     C4::AR::Debug::debug("CatRegistroMarcN1 => CDU ".$marc_record->subfield("080","a"));

    return $marc_record->subfield("080","a");
}

# sub getAutoresSecundarios{
#     my ($self)      = shift;
#
#     my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());
#
# #     C4::AR::Debug::debug("CatRegistroMarcN1 => autores secundarios ".$marc_record->subfield("700","a"));
#
#     return $marc_record->subfield("700","a");
# }

# sub getAutoresSecundariosObject{
#     my ($self)      = shift;
#
#     #obtengo la referencia del autor secundario
#     my $ref_autor   = $self->getAutoresSecundarios();
#     my $ref         = C4::AR::Catalogacion::getRefFromStringConArrobas($ref_autor);
# #     C4::AR::Debug::debug("CatRegistroMarcN1 => getAutorObject()=> ref_autor => ".$ref_autor);
# #     C4::AR::Debug::debug("CatRegistroMarcN1 => getAutorObject()=> ref => ".$ref);
#
#     my $autor       = C4::Modelo::CatAutor->getByPk($ref);
#
#     if(!$autor){
#         C4::AR::Debug::debug("CatRegistroMarcN1 => getAutoresSecundariosObject()=> EL OBJECTO (ID) AUTOR NO EXISTE");
#         $autor = C4::Modelo::CatAutor->new();
#     }
#
#     return ($autor);
# }

sub getAutoresSecundarios{
    my ($self)      = shift;

    my @colaboradores_array;
    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());
    my $autor;


    my @campos_array = $marc_record->field("700");

    foreach my $campo (@campos_array){
        my $ref         = C4::AR::Catalogacion::getRefFromStringConArrobas($campo->subfield("a"));
        my $colaborador = C4::Modelo::CatAutor->getByPk($ref);

        if ($colaborador){
            if ($campo->subfield("e")) {
                my $ref         = C4::AR::Catalogacion::getRefFromStringConArrobas($campo->subfield("e"));
                my $funcion     = C4::Modelo::RefColaborador->getByPk($ref);
                if ($funcion) {
                    $funcion = $funcion->getDescripcion;
                }
                else{
                    $funcion = $campo->subfield("e");
                }

                $autor = $colaborador->getCompleto()." (".$funcion.")";
            }
            else {
                 $autor = $colaborador->getCompleto();
            }

            push (@colaboradores_array, $autor);
        }
    }

    return (@colaboradores_array);
}

sub getTemas{
    my ($self)      = shift;

    my @temas;
    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());


    my @campos_array = $marc_record->field("650");

    foreach my $campo (@campos_array){
#         C4::AR::Debug::debug("CatRegistroMarcN1 => getTemas ".$campo->subfield("a"));
        my $ref     = C4::AR::Catalogacion::getRefFromStringConArrobas($campo->subfield("a"));
        my $tema    = C4::Modelo::CatTema->getByPk($ref);

        push (@temas, $tema)
    }

    return (@temas);
}


sub getTema{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

#     C4::AR::Debug::debug("CatRegistroMarcN1 => temas ".$marc_record->subfield("700","a"));

    return $marc_record->subfield("650","a");
}

sub getTemaObject{
    my ($self)      = shift;

    #obtengo la referencia del autor secundario
    my $ref_tema   = $self->getTema();
    my $ref         = C4::AR::Catalogacion::getRefFromStringConArrobas($ref_tema);
#     C4::AR::Debug::debug("CatRegistroMarcN1 => getTemasObject()=> ref_tema => ".$ref_tema);
#     C4::AR::Debug::debug("CatRegistroMarcN1 => getTemasObject()=> ref => ".$ref);

    my $autor       = C4::Modelo::CatTema->getByPk($ref);

    if(!$autor){
        C4::AR::Debug::debug("CatRegistroMarcN1 => getTemasObject()=> EL OBJECTO (ID) TEMA NO EXISTE");
        $autor = C4::Modelo::CatTema->new();
    }

    return ($autor);
}

sub getNombreGeografico{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

#     C4::AR::Debug::debug("CatRegistroMarcN1 => nombre geografico ".$marc_record->subfield("651","a"));

    return $marc_record->subfield("651","a");
}

sub getNombreGeograficoObject{
    my ($self)      = shift;

    #obtengo la referencia del autor secundario
    my $ref_pais    = $self->getNombreGeografico();
    my $ref         = C4::AR::Catalogacion::getRefFromStringConArrobas($ref_pais);
#     C4::AR::Debug::debug("CatRegistroMarcN1 => getNombreGeograficoObject()=> ref_tema => ".$ref_pais);
#     C4::AR::Debug::debug("CatRegistroMarcN1 => getNombreGeograficoObject()=> ref => ".$ref);

    my $pais        = C4::Modelo::RefPais::Manager->get_ref_pais (
                                                                      query     => [  'iso' => { eq => $ref } ]
                                                        );

    if(!$pais){
        C4::AR::Debug::debug("CatRegistroMarcN1 => getNombreGeograficoObject()=> EL OBJECTO (ID) PAIS NO EXISTE");
        $pais = C4::Modelo::RefPais->new();

        return ($pais);
    } else {
        return ($pais->[0]);
    }


}


sub getTerminoNoControlado{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

#     C4::AR::Debug::debug("CatRegistroMarcN1 => termino no contralado ".$marc_record->subfield("653","a"));

    return $marc_record->subfield("653","a");
}

sub getEntradaNoControlado{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

#     C4::AR::Debug::debug("CatRegistroMarcN1 => entrada no contralado ".$marc_record->subfield("720","a"));

    return $marc_record->subfield("720","a");
}

sub getTitulo{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

#     C4::AR::Debug::debug("CatRegistroMarcN1 => titulo ".$marc_record->subfield("245","a"));

    return $marc_record->subfield("245","a");
}

sub getTituloStringEscaped {
    my ($self)      = shift;
    my $titulo = $self->getTitulo();
    return C4::AR::Utilidades::escapeData($titulo);
}

sub getRestoDelTitulo{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

    return $marc_record->subfield("245","b");
}

sub getRestoDelTituloStringEscaped{
    my ($self)      = shift;

    my $titulo = $self->getRestoDelTitulo();
    return C4::AR::Utilidades::escapeData($titulo);
}


sub getAutorObject{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

    #obtengo la referencia al autor
    my $ref_autor   = $marc_record->subfield("100","a");
    my $ref         = C4::AR::Catalogacion::getRefFromStringConArrobas($ref_autor);
#     C4::AR::Debug::debug("CatRegistroMarcN1 => getAutorObject()=> ref => ".$ref_autor);

    my $autor       = C4::Modelo::CatAutor->getByPk($ref);
    # C4::AR::Debug::debug("CatRegistroMarcN1 => getAutorObject()=> AUTOR 100a ".$autor->getCompleto()."-");
    # C4::AR::Debug::debug("CatRegistroMarcN1 => getAutorObject()=> AUTOR 100a ".$autor);
    # C4::AR::Debug::debug("CatRegistroMarcN1 => getAutorObject()=> AUTOR 100a ref ".$ref);

    if(C4::AR::Utilidades::trim($autor->getCompleto()) eq ""){
        $ref_autor      = $marc_record->subfield("110","a");
        $ref            = C4::AR::Catalogacion::getRefFromStringConArrobas($ref_autor);
        # C4::AR::Debug::debug("CatRegistroMarcN1 => getAutorObject()=> AUTOR 110a ref ".$ref);
        $autor          = C4::Modelo::CatAutor->getByPk($ref);
        # C4::AR::Debug::debug("CatRegistroMarcN1 => getAutorObject()=> AUTOR 110a ".$autor->getCompleto()."-");
        # C4::AR::Debug::debug("CatRegistroMarcN1 => getAutorObject()=> AUTOR 110a ".$autor);
    }

    if(C4::AR::Utilidades::trim($autor->getCompleto()) eq ""){
        $ref_autor      = $marc_record->subfield("111","a");
        $ref            = C4::AR::Catalogacion::getRefFromStringConArrobas($ref_autor);
        # C4::AR::Debug::debug("CatRegistroMarcN1 => getAutorObject()=> AUTOR 111a ref ".$ref);
        $autor          = C4::Modelo::CatAutor->getByPk($ref);
        # C4::AR::Debug::debug("CatRegistroMarcN1 => getAutorObject()=> AUTOR 111a ".$autor->getCompleto()."-");
        # C4::AR::Debug::debug("CatRegistroMarcN1 => getAutorObject()=> AUTOR 111a ".$autor);
    }

    if(!$autor){
        C4::AR::Debug::debug("CatRegistroMarcN1 => getAutorObject()=> EL OBJECTO (ID) AUTOR NO EXISTE");
        $autor = C4::Modelo::CatAutor->new();
    }

    return ($autor);
}

=head2 sub getAutor
  Devuelve solo el completo del autor
=cut
sub getAutor{
    my ($self)      = shift;

    my $autor = $self->getAutorObject();

    return ($autor->getCompleto());
}


sub getAutorStringEscaped {
    my ($self)      = shift;
    my $autor = $self->getAutor();
    return C4::AR::Utilidades::escapeData($autor);
}

=head2 sub getNivelBibliografico
Recupera el Nivel Bibliografico (el code), bit 7 del LEADER
=cut
sub getNivelBibliografico{
    my ($self)      = shift;

# bit 7 del Leader
    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

#     C4::AR::Debug::debug("CatRegistroMarcN1 => getNivautorelBibliografico => LEADER !!!!!!!!!!!!!!!! ".substr ($marc_record->leader(),7,1));
    return substr ($marc_record->leader(),7,1);
}

sub getNivelBibliograficoObject{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());
    my $code        = $self->getNivelBibliografico();

    my $nivel_bibliografico = C4::Modelo::RefNivelBibliografico::Manager->get_ref_nivel_bibliografico( query => [ code => { eq => $code }]);

    C4::AR::Debug::debug($nivel_bibliografico->[0]);

    return ($nivel_bibliografico->[0]);
}

=head2 sub toMARC

=cut
sub toMARC{
    my ($self) = shift;

    #obtengo el marc_record del NIVEL 1
    my $marc_record             = MARC::Record->new_from_usmarc($self->getMarcRecord());

    my $params;
    $params->{'nivel'}          = '1';
    $params->{'id_tipo_doc'}    = $self->getTemplate()||'ALL';
    my $MARC_result_array       = &C4::AR::Catalogacion::marc_record_to_meran_por_nivel($marc_record, $params);

    return ($MARC_result_array);
}


=head2 sub toMARC_Intra
    se utiliza para la visualizacion del detalle en la INTRA
=cut
sub toMARC_Intra{
    my ($self) = shift;

    #obtengo el marc_record del NIVEL 1
    my $marc_record             = MARC::Record->new_from_usmarc($self->getMarcRecord());


    my $params;
    $params->{'nivel'}          = '1';
    $params->{'id_tipo_doc'}    = $self->getTemplate()||'ALL';
    $params->{'id1'}            = $self->getId1();
    my $MARC_result_array       = &C4::AR::Catalogacion::marc_record_to_intra_view($marc_record, $params, $self->db);

    return ($MARC_result_array);
}


=head2 sub toMARC_Opac
    se utiliza para la visualizacion del detalle en el OPAC
=cut
sub toMARC_Opac{
    my ($self) = shift;

    #obtengo el marc_record del NIVEL 1
    my $marc_record             = MARC::Record->new_from_usmarc($self->getMarcRecord());

    my $params;
    $params->{'nivel'}          = '1';
    $params->{'id_tipo_doc'}    = $self->getTemplate()||'ALL';
    my $MARC_result_array       = C4::AR::Catalogacion::marc_record_to_opac_view($marc_record, $params);

    return ($MARC_result_array);
}


=head2 sub getMarcRecordFull
    Construye un registro MARC y le agrega los grupos (que vienen con los ejemplares)
=cut
sub getMarcRecordFull{
    my ($self) = shift;

    #obtengo el marc_record
    my $marc_record             = $self->getMarcRecordObject();

    #obtengo los grupos
    my $grupos = $self->getGrupos();

    #de los grupos saco su marc record con los ejemplares
    foreach my $nivel2 (@$grupos){
        my $marc_record_n2  =$nivel2->getMarcRecordFull();
        $marc_record->append_fields($marc_record_n2->fields());
        }

    return $marc_record;
}

=head2 sub getMarcRecordConDatos
    Construye un registro MARC con datos referenciados
=cut
sub getMarcRecordConDatos{
    my ($self) = shift;

    #obtengo el marc_record del NIVEL 1
    my $marc_record             = MARC::Record->new_from_usmarc($self->getMarcRecord());

    my $params;
    $params->{'nivel'}          = '1';
    $params->{'id_tipo_doc'}    = $self->getTemplate()||'ALL';

    my $MARC_record       = C4::AR::Catalogacion::marc_record_with_data($marc_record, $params->{'id_tipo_doc'}, $params->{'tipo'}, $params->{'nivel'});
    return ($MARC_record);
}



=head2 sub getMarcRecordConDatosForRobleExportRELAP
    Construye un registro MARC con datos referenciados con el formato pedido por roble para las Revistas (RELAP)
    
    ID: 100  << id2
    
    Número normalizado-tipo: 15^t << ISSN
    Número normalizado: 15^n <<  022, a NIVEL 1
    Título clave: 35 <<  245, a NIVEL 1
    Título informativo: 36 <<  245, b NIVEL 1
    Título abreviado: 37 <<  210, a NIVEL 1
    Dirección web: 88 << 856, u NIVEL 1
    
    Idioma: 40 << 041, h NIVEL 1
    País de edición: 45 << 043, a NIVEL 1
    
    Frecuencia: 48 << 310, a NIVEL 2
    
    Responsabilidad: 39  AUTOR??? << 110,a NIVEL 1
    
    
    Lugar de edición: 44^l << 260, a NIVEL 2
    Editor: 44^e << 260, b NIVEL 2

    Suplementos: 82 <<  NIVEL 2?
    Relaciones con otras publicaciones: 85 (Ej: continuación de, continuada por) ??
    Notas: 54  << 500, a NIVEL 2
    
    Clasificación temática: 60 
    Término tope: 62
    Descriptores: 65
    Indizado en:  50
    Incluido en: 51
    
    Sigla Bca. Cooperante: 80^c << se arma 
    
    Disponibilidad: 80^d ????
    Procedencia: 80^p ????
    Existencias: 80^e << ESTADO DE COLECCION 
    Responsable del alta: 90
    Fecha de alta: 03


=cut

sub getMarcRecordConDatosForRobleExportRELAP {
    my ($self) = shift;

    #obtengo el marc_record del NIVEL 1 con datos
    my $marc_record_n1             = $self->getMarcRecordConDatos();
        
    my $marc_record_relap = MARC::Record->new();
        
    #Nivel1
    MARC::Field->allow_controlfield_tags('100','035','036','037','039','040','045','048','082','085','054','088','060','062','065','050','051','090');
    
    if($marc_record_n1->subfield('245',"a")){
        $marc_record_relap->append_fields(MARC::Field->new( '035', $marc_record_n1->subfield('245',"a")));
    }
    if($marc_record_n1->subfield('245',"b")){
        $marc_record_relap->append_fields(MARC::Field->new( '036', $marc_record_n1->subfield('245',"b")));
    }
    if($marc_record_n1->subfield('210',"a")){
        $marc_record_relap->append_fields(MARC::Field->new( '037', $marc_record_n1->subfield('210',"a")));
    }
    if($marc_record_n1->subfield('856',"u")){
        $marc_record_relap->append_fields(MARC::Field->new( '088', $marc_record_n1->subfield('856',"u")));
    }
    if($marc_record_n1->subfield('041',"h")){
        $marc_record_relap->append_fields(MARC::Field->new( '040', $marc_record_n1->subfield('041',"h")));
    }
    if($marc_record_n1->subfield('043',"a")){
        $marc_record_relap->append_fields(MARC::Field->new( '045', $marc_record_n1->subfield('043',"a")));
    }
    if($marc_record_n1->subfield('110',"a")){
        $marc_record_relap->append_fields(MARC::Field->new( '039', $marc_record_n1->subfield('110',"a")));
    }
    #Agregamos el estado de coleccion
    my $field080 =MARC::Field->new("080","","","e" => $self->getEstadoDeColeccion());
   $marc_record_relap->append_fields($field080);
        
    C4::AR::Debug::debug("RELAP => ".$marc_record_relap->as_formatted());
    
    return $marc_record_relap;
}

=head2 sub getEstadoDeColeccion
    Arma el estado de colección de un registro 
=cut
sub getEstadoDeColeccion{
    my ($self) = shift;

    use C4::AR::Busquedas;
    my $estadoDeColeccion = C4::AR::Busquedas::obtenerEstadoDeColeccion($self->getId1);
    
=item

    [% FOREACH anio IN estadoDeColeccion.keys.sort %]
    [% IF estadoDeColeccion.$anio.keys %]
    <li>
        [% IF anio != '#' %]<b>[% anio %]</b>[% END %]
        [% FOREACH volumen IN estadoDeColeccion.$anio.keys.sort %]
            [% IF volumen != '#' %][% volumen  %][% END %]
            (
            [% FOREACH fasciculo IN estadoDeColeccion.$anio.$volumen.keys.sort %]

                 [% PERL %]
                    print C4::AR::Filtros::link_to( text =>     "[% HTML.escape(fasciculo) %]",
                                                    url=>"[% url_prefix %]/catalogacion/estructura/detalle.pl", 
                                                    params =>   ["id1=[% id1 %]","id2=[% estadoDeColeccion.$anio.$volumen.$fasciculo %]"],
                                                    title =>    "[% 'Mostrar Detalle del Registro' | i18n %]",
                                                    class => 	"link_to_detail"
                                                ) ;
                 [% END %]
  
            [% END %]
            )
        [% END %]
       </li>
    [% END %]
    [% END %]
    
=cut    

    my $estadoResultado="";
    while (my ($anio, $volumen) = each(%$estadoDeColeccion)){
        if (($anio ne '#')&&($anio ne '')){
            if ($estadoResultado ne ""){$estadoResultado.=" ";}
            $estadoResultado.=$anio;
        }
        while (my($vol, $fasciculo) = each(%$volumen)){
            if (($vol ne '#')&&($vol ne '')){
                if ($estadoResultado ne ""){$estadoResultado.=" ";}
                $estadoResultado.=$vol;
        }
         if ($estadoResultado ne ""){$estadoResultado.=" ";}
        $estadoResultado.="( ";
        foreach my $fasc (sort (keys(%$fasciculo))) {
            $estadoResultado.=" ".$fasc." ";
        }
        $estadoResultado.=" )";

        }
    }
    return $estadoResultado;
}


=head2 sub getMarcRecordConDatosForRobleExport
    Construye un registro MARC con datos referenciados con el formato pedido por roble
    
    IGUALES:

    Palabras claves: 653^a <<< 650a
    
=cut
sub getMarcRecordConDatosForRobleExport{
    my ($self) = shift;

    #obtengo el marc_record del NIVEL 2 con datos
    my $marc_record_n1             = $self->getMarcRecordConDatos();

    my @temas = $marc_record_n1->field("650");
    foreach my $tema (@temas){
        my $field_653  = MARC::Field->new("653","","","a" => $tema->subfield("a"));
        $marc_record_n1->append_fields($field_653); 
        $marc_record_n1->delete_fields($tema);
    }
    return $marc_record_n1;
       
}

=head2 sub getMarcRecordConDatosFull
    Construye un registro MARC con datos referenciados y le agrega los grupos (que vienen con los ejemplares)
=cut
sub getMarcRecordConDatosFull{
    my ($self) = shift;

    #obtengo el marc_record del NIVEL 2
    my $marc_record             = $self->getMarcRecordConDatos();

    my $grupos = $self->getGrupos();

    foreach my $nivel2 (@$grupos){
        my $marc_record_n2  =$nivel2->getMarcRecordConDatosFull();
        $marc_record->append_fields($marc_record_n2->fields());
        }

    return $marc_record;
}


=head2 sub toMARC_OAI
    Construye un registro MARC con datos referenciados
=cut
sub toMARC_OAI{
    my ($self) = shift;

    #obtengo el marc_record del NIVEL 1
    my $marc_record             = MARC::Record->new_from_usmarc($self->getMarcRecord());

    my $params;
    $params->{'nivel'}          = '1';
    $params->{'id_tipo_doc'}    = $self->getTemplate()||'ALL';

    $marc_record =  C4::AR::Catalogacion::filtrarVisualizacionOAI($marc_record, $params);

    my $MARC_record       = C4::AR::Catalogacion::marc_record_to_oai($marc_record, $params->{'id_tipo_doc'}, $params->{'tipo'}, $params->{'nivel'});

    return ($MARC_record);
}
=head2 sub getGrupos
    Recupero todos los grupos del nivel 1.
    Retorna la referencia a un arreglo de objetos
=cut
sub getGrupos {
    my ($self) = shift;

    #recupero todos los grupos de nivel 1
    my ($nivel2_object_array) = C4::Modelo::CatRegistroMarcN2::Manager->get_cat_registro_marc_n2(
                                                                        query => [ id1 => { eq => $self->getId1 } ]
                                                                   );
    return $nivel2_object_array;
}

=head2 sub tienePrestamos
    Verifica si el nivel 1  tiene ejemplares con prestamos o no
=cut
sub tienePrestamos{
    my ($self) = shift;

    my $cant = 0;
    #recupero todos los grupos del nivel 1
    my ($nivel2_object_array) = $self->getGrupos();

    #recorro los id2 del nivel 1 para verificar si tienen prestamos o no
    foreach my $nivel2 (@$nivel2_object_array){
        if($nivel2->tienePrestamos){
            return 1;
        }
    }
    return 0;
}

=head2 sub tienePrestamos
    Verifica si el nivel 1  tiene ejemplares con reservas o no
=cut
sub tieneReservas{
    my ($self) = shift;

    my $cant = 0;
    #recupero todos los grupos del nivel 1
    my ($nivel2_object_array) = $self->getGrupos();

    #recorro los id2 del nivel 1 para verificar si tienen prestamos o no
    foreach my $nivel2 (@$nivel2_object_array){
        if($nivel2->tieneReservas){
            return 1;
        }
    }
    return 0;
}

sub getInvolvedCount{

    my ($self) = shift;
    my ($tabla, $value)= @_;

    my ($filter_string,$filtros) = $self->getInvolvedFilterString($tabla, $value);
    my $cat_registro_marc_n1_count = C4::Modelo::CatRegistroMarcN1::Manager->get_cat_registro_marc_n1_count( query => $filtros );

    return ($cat_registro_marc_n1_count);
}



sub getReferenced{

    my ($self) = shift;
    my ($tabla, $value)= @_;

    my ($filter_string,$filtros) = $self->getInvolvedFilterString($tabla, $value);

    my $cat_registro_marc_n1 = C4::Modelo::CatRegistroMarcN1::Manager->get_cat_registro_marc_n1( query => $filtros );
    return ($cat_registro_marc_n1);
}

=head2 sub generarIndice
    Genera el índice para este nivel 1
    Actualiza el registro de Gener
    Retorna la referencia a un arreglo de objetos
=cut

sub generarIndice {
    my ($self) = shift;

    my $dato;
    my $dato_ref;
    my $campo;
    my $subcampo;

    my $marc_record = $self->getMarcRecordFull();
    my $marc_record_datos = MARC::Record->new();


    #my $new_marc_record =   MARC::Record->new();

    #foreach my $field ($marc_record->fields) {
        #if(! $field->is_control_field){
            #my %hash;
            #my $campo                       = $field->tag;
            #my $indicador_primario_dato     = $field->indicator(1);
            #my $indicador_secundario_dato   = $field->indicator(2);
            ##proceso todos los subcampos del campo
            #foreach my $subfield ($field->subfields()) {
                #my %hash_temp;

                #my $subcampo                        = $subfield->[0];
                #my $dato                            = $subfield->[1];
                #$dato                               = getRefFromStringConArrobasByCampoSubcampo($campo, $subcampo, $dato, $itemtype, $nivel, $db);
                #my $valor_referencia                = getDatoFromReferencia($campo, $subcampo, $dato, $itemtype, $nivel, $db);
                #my $field = MARC::Field->new($campo,'','',$subcampo => $valor_referencia);
                #$new_marc_record->append_fields($field);
            #}



    #Titulo
    my $titulo                  = $marc_record->subfield("245","a");
    #Armo el superstring
    my $superstring             = "";

    #recorro los campos
    foreach my $field ($marc_record->fields){
        $campo = $field->tag;
        my $new_field;
        #recorro los subcampos
        foreach my $subfield ($field->subfields()) {

            $subcampo                       = $subfield->[0];
            $dato                           = $subfield->[1];
            eval{
#                 $self->debug("DATO ANTES ".$dato);
                my $nivel                       = C4::AR::EstructuraCatalogacionBase::getNivelFromEstructuraBaseByCampoSubcampo($campo, $subcampo);
                $dato_ref                       = C4::AR::Catalogacion::getRefFromStringConArrobasByCampoSubcampo($campo, $subcampo, $dato,$self->getTemplate,$nivel);
                $dato                           = C4::AR::Catalogacion::getDatoFromReferencia($campo, $subcampo, $dato_ref, $self->getTemplate,$nivel);
#                 $self->debug("REF".$dato_ref."->".$dato);
                if (($dato)&&($dato ne 'NULL')){
                    #Guardo el dato en el marc record solamente
                    if ($new_field){
                            $new_field->add_subfields( $subcampo  => $dato );
                        }
                    else {
                        $new_field = MARC::Field->new($campo,'','',$subcampo => $dato);
                        $marc_record_datos->append_fields($new_field);
                        }
                }

            }; #END eval
            if ($@){
                $self->debug("ERROR AL OBTENER UNA REFERENCIA DE ". $self->getId1." !!! ( campo: ".$campo." subcampo:".$subcampo." template:".$self->getTemplate." ".$@." )");
                next;
            }
            next if ($dato eq 'NO_TIENE');
            next if ($dato eq '');
            next if (!$dato);

    ###################REFERENCIAS################REFERENCIAS##################REFERENCIAS##################

            #aca van todas las excepciones que no son referencias pero son necesarios para las busquedas
            if (($campo eq "020") && ($subcampo eq "a")){
                $dato = 'isbn%'.$dato;
            }

            if (($campo eq "995") && ($subcampo eq "o")){
                $dato = 'ref_disponibilidad%'.$dato;
                $dato .= ' ref_disponibilidad_code%'.$dato_ref;
            }

            if (($campo eq "995") && ($subcampo eq "e")){
                $dato = 'ref_estado%'.C4::AR::Utilidades::getNombreFromEstadoByCodigo($dato_ref);
                $dato .= ' ref_estado_code%'.$dato_ref;
            }

            if (($campo eq "995") && ($subcampo eq "f")){
                $dato = 'barcode%'.$dato;
            }

            if (($campo eq "995") && ($subcampo eq "t")){
                $dato = 'signatura%'.$dato;
            }

            if (($campo eq "650") && ($subcampo eq "a")){
                $dato = 'cat_tema%'.$dato;
            }

            if (($campo eq "910") && ($subcampo eq "a")){
                $dato .= ' cat_ref_tipo_nivel3%'.$dato_ref;
            }

            if ($superstring eq "") {
                $superstring            = $dato;
            } else {
                $superstring .= " ".$dato;
            }
        } #END foreach my $subfield ($field->subfields())
    } #END foreach my $field ($marc_record->fields)

#      $self->debug("C4::AR::Sphinx::generar_indice => superstring!!!!!!!!!!!!!!!!!!! => ".$superstring);
#      $self->debug("C4::AR::Sphinx::generar_indice => marc_record_datos!!!!!!!!!!!!!!!!!!! => ".$marc_record_datos->as_usmarc);

    ###################AUTORES################AUTORES##################AUTORES##################
    my @autores;
    my $autor = $marc_record_datos->subfield("100","a");
    if ($autor){
            push (@autores,$autor);
    }

       $autor = $marc_record_datos->subfield("110","a");
    if ($autor){
            push (@autores,$autor);
    }

       $autor = $marc_record_datos->subfield("111","a");
    if ($autor){
            push (@autores,$autor);
    }

    #Ahora los adicionales
    my @field700 =$marc_record_datos->field("700");
    foreach my $f700 (@field700){
        my @autores_adicionales = $f700->subfield("a");

        foreach my $autor (@autores_adicionales){
            if ($autor){
                    push (@autores,$autor);
            }
        }
    }

      my @field700 =$marc_record_datos->field("710");
       foreach my $f710 (@field700){
          my @autores_adicionales =$f710->subfield("a");
          foreach my $autor (@autores_adicionales){
              if ($autor){
                    push (@autores,$autor);
              }
          }
      }

    $autor = join(' | ',@autores);


    my $indice_busqueda = $self->estaEnIndice;

    if(!$indice_busqueda) {
        #Si no existe lo creo
        $indice_busqueda = C4::Modelo::IndiceBusqueda->new();
        $indice_busqueda->setId($self->getId1);
        }

        $indice_busqueda->setTitulo($titulo);
        $indice_busqueda->setAutor($autor);
        $indice_busqueda->setPromoted($self->getCountPromoted);
        $indice_busqueda->setString($superstring);
        $indice_busqueda->setMarcRecord($marc_record_datos->as_usmarc);
        $indice_busqueda->save();


#         C4::AR::Debug::debug("C4::AR::Sphinx::generar_indice => UPDATE => id1 => ".$registro_marc_n1->{'id'});
}

sub getNombreTipoDoc{
	my($self) = shift;

    my $id_tipo_doc = $self->getTemplate();
    use C4::Modelo::CatRefTipoNivel3::Manager;
    
    my @filtros;
    
    push (@filtros,(id_tipo_doc => {eq => $id_tipo_doc,}));
    
    my $cat_ref_tipo_nivel3 = C4::Modelo::CatRefTipoNivel3::Manager->get_cat_ref_tipo_nivel3(
                                                                                          query => \@filtros,
                                                                                       );   
    
    my $doc = $cat_ref_tipo_nivel3->[0];
    
    if ($doc){
        return $doc->getNombre;
    }else{
        return $id_tipo_doc;
    }
}

sub estaEnIndice{
    my($self) = shift;

    my @filtros;
    
    push (@filtros,(id => {eq => $self->getId1,}));

    my $indice_result = C4::Modelo::IndiceBusqueda::Manager->get_indice_busqueda(
                                                                                    query => \@filtros,
                                                                                );

    return ($indice_result->[0]);

}

=head2 sub getCountPromoted
    Cuenta la cantidad de grupos promovidos para ponderar en el índice
=cut
sub getCountPromoted{
    my ($self) = shift;

    my $promoted = 0;

    #obtengo los grupos
    my $grupos = $self->getGrupos();

    #cuento promovidos
    foreach my $nivel2 (@$grupos){
        if ($nivel2->isPromoted()){
            $promoted++;
        }
    }

    return $promoted;
}
1;
