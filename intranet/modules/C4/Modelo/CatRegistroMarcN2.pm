package C4::Modelo::CatRegistroMarcN2;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'cat_registro_marc_n2',

    columns => [
        id                  => { type => 'serial', overflow => 'truncate', not_null => 1 },
        marc_record         => { type => 'text', overflow => 'truncate' },
        id1                 => { type => 'integer', overflow => 'truncate', not_null => 1 },
        indice              => { type => 'text', overflow => 'truncate' },
        indice_file_path    => { type => 'varchar', overflow => 'truncate', not_null => 0, length => 255, },
        template            => { type => 'varchar', overflow => 'truncate', not_null => 1 },
        promoted            => { type => 'tinyint', default => 0,},
    ],

    primary_key_columns => [ 'id' ],

    relationships => [
        nivel1  => {
            class       => 'C4::Modelo::CatRegistroMarcN1',
            key_columns => { id1 => 'id' },
            type        => 'one to one',
        },
    ],
);

use C4::Modelo::CircReserva;
use C4::Modelo::CircReserva::Manager;
use MARC::Record; #FIXME creo que esta funcion es interna qw(new_from_usmarc);
use C4::AR::Catalogacion qw(getRefFromStringConArrobas);
use C4::Modelo::CatRegistroMarcN3::Manager qw(get_cat_registro_marc_n3_count);
# use C4::Modelo::CatRegistroMarcN2::Manager qw(get_cat_registro_marc_n2);
use C4::Modelo::CatRegistroMarcN2::Manager;
use C4::Modelo::CatRegistroMarcN2Analitica::Manager;
# use vars qw(@EXPORT_OK @ISA);
#
# @ISA=qw(Exporter);
#
# @EXPORT_OK = qw(
#                   &getRefFromStringConArrobas
# );


sub getId2{
    my ($self)  = shift;

    return $self->id;
}

sub getId1{
    my ($self)  = shift;

    return $self->id1;
}

sub setId1{
    my ($self)  = shift;
    my ($id1)   = @_;

    $self->id1($id1);
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

sub getIndice{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->indice));
}

sub setIndice{
    my ($self)      = shift;
    my ($indice)    = @_;
    
    $self->indice($indice);
}

sub getIndiceFilePath{
    my ($self) = shift;
    return ($self->indice_file_path);
}

sub setIndiceFilePath{
    my ($self)      = shift;
    my ($indice_file_path)    = @_;
    
    $self->indice_file_path($indice_file_path);
}

sub tieneArchivoIndice{
    my ($self)      = shift;

    my $status = C4::AR::Utilidades::validateString($self->getIndiceFilePath);
    my $edocsDir = C4::Context->config("edocsdir");
    
    if ($status){
        my $path = $edocsDir."/".$self->getIndiceFilePath;

      if ( -e $path ){
          $status =  $self->getIndiceFilePath;
      }else{
          $status = undef;
      }            
    }
    
    return $status; 
}

sub getIndiceFileType{
  
  my ($self)      = shift;
  
  my $edocsDir = C4::Context->config("edocsdir");
  my $path = $edocsDir."/".$self->getIndiceFilePath;
  my $isValidFileType = C4::AR::Utilidades::isValidFile($path);
  
  return ($isValidFileType);
  
}

sub tiene_indice {
    my ($self) = shift;

    return (C4::AR::Utilidades::validateString($self->getIndice));
}

sub agregar{
    my ($self)                          = shift;
    my ($params, $marc_record, $db)     = @_;

    $self->setId1($params->{'id1'});
    $self->setMarcRecord($marc_record);
    $self->setTemplate($params->{'id_tipo_doc'});

    $self->save();
}


sub modificar{
    my ($self)              = shift;
    my ($params, $marc_record, $db)  = @_;

    $self->setMarcRecord($marc_record);

    $self->save();
}

=item
    Llama a la misma funcion en el Nivel3.
    Es por el ticket #4226
=cut
sub getDetalleDisponibilidadNivel3{
     my ($self)      = shift;

    return C4::AR::Nivel3::detalleDisponibilidadNivel3($self->getId2);
}

sub eliminar{
    my ($self)      = shift;
    my ($params)    = @_;

    #HACER ALGO SI ES NECESARIO

    #elimino los ejemplares del grupo
    my ($nivel3) = C4::AR::Nivel3::getNivel3FromId2($self->getId2(), $self->db);

    C4::AR::Nivel2::eliminarReviewsDeNivel2($self->getId2,$self->db);

    foreach my $n3 (@$nivel3){
        $n3->eliminar();
    }

    my $cat_registro_marc_n2_analitica = C4::AR::Nivel2::getAllAnaliticasById2($self->getId2(), $self->db);

    #elimino las analíticas de "cat_registro_marc_n2_analitica" si es que existen
    if ($cat_registro_marc_n2_analitica){
      foreach my $n2_analitica (@$cat_registro_marc_n2_analitica){
          $n2_analitica->delete();
      }
    }
    
    $self->delete();
}

sub getAnalitica{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

#     C4::AR::Debug::debug("getAnalitica =>>>>>>>>>>>>>>> ".$marc_record->subfield("773","a"));

    return C4::AR::Catalogacion::getRefFromStringConArrobas($marc_record->subfield("773","a"));
}

sub getAnaliticas{
    my ($self)      = shift;

#     C4::AR::Debug::debug("C4::AR::CatRegistroMarcN2::getAnaliticas del grupo ".$self->getId2());

    my $db = C4::Modelo::CatRegistroMarcN2->new()->db();

    my $nivel2_analiticas_array_ref = C4::Modelo::CatRegistroMarcN2Analitica::Manager->get_cat_registro_marc_n2_analitica(
                                                                        db => $db,
                                                                        query => [
                                                                                    cat_registro_marc_n2_id => { eq => $self->getId2() },
                                                                            ]
                                                                );

#     C4::AR::Debug::debug("C4::AR::CatRegistroMarcN2::getAnaliticas => el grupo ".$self->getId2()." tiene ".scalar(@$nivel2_analiticas_array_ref)." analiticas");

    # if( scalar(@$nivel2_analiticas_array_ref) > 0){
    return ($nivel2_analiticas_array_ref);
    # }else{
        # return 0;
    # }
}

sub getSignaturas{
    my ($self)          = shift;

    my $array_nivel3 = C4::AR::Nivel3::getNivel3FromId2($self->getId2);

    my @signaturas;

    foreach my $nivel3 (@$array_nivel3){
        my $signatura_nivel3 = $nivel3->getSignatura;
        if (!C4::AR::Utilidades::existeInArray($signatura_nivel3,@signaturas)){
            push (@signaturas, $signatura_nivel3);
        }
    }

    return (\@signaturas);
}

sub getPrimerSignatura {
    my ($self)          = shift;

    my $signaturas_array_ref = $self->getSignaturas();

    (scalar(@$signaturas_array_ref) > 0)? return $signaturas_array_ref->[0]: return 0;
}

=head2
sub getISBN

Funcion que devuelve el isbn
=cut

sub getISBN{
     my ($self)      = shift;

     my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

     return $marc_record->subfield("020","a");
}

=head2
sub getVolumen

Funcion que devuelve el volumen del grupo
=cut

sub getVolumen{
     my ($self)      = shift;

     my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());
     
     return $marc_record->subfield("505","g");
}

=head2
sub getVolumenDesc

Funcion que devuelve la desc del volumen del grupo
=cut

sub getVolumenDesc{
     my ($self)      = shift;

     my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());
     
     return $marc_record->subfield("505","t");
}

sub getAllImage {
    my ($self)      = shift;

    my %result  = {};
    my $isbn            = $self->getISBN();
    if (C4::AR::Utilidades::validateString($isbn)) {
        my $portada     = C4::AR::PortadasRegistros::getPortadaByIsbn($isbn);

        if ($portada){
            $result{'S'}    = $portada->getSmall();
            $result{'M'}    = $portada->getMedium();
            $result{'L'}    = $portada->getLarge();
            return \%result;
        }
    }

    return undef;
}

=head2
sub getISSN

Funcion que devuelve el issn
=cut

sub getISSN{
     my ($self)      = shift;

     my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

     return $marc_record->subfield("022","a");
}

=head2
sub getSeriesTitulo

Funcion que devuelve el series_titulo
=cut

sub getSeriesTitulo{
     my ($self)      = shift;

     my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

     return $marc_record->subfield("440","a");
}

sub getNombreSubSerie{
     my ($self)      = shift;

     my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

     return $marc_record->subfield("440","p");
}

sub getNumeroSerie{
     my ($self)      = shift;

     my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

     return $marc_record->subfield("440","v");
}

sub getNotaGeneral{
     my ($self)      = shift;

     my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

     return C4::AR::Utilidades::escapeData($marc_record->subfield("500","a"));
}

=head2
sub getTipoDocumento

Funcion que devuelve la referencia al tipo de Documento
=cut
sub getTipoDocumento{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());
    my $tipo_doc    = $marc_record->subfield("910","a");

#     C4::AR::Debug::debug("CatRegistroMarcN2 => getTipoDocumento => ".$tipo_doc);
#     C4::AR::Debug::debug("CatRegistroMarcN2 => getTipoDocumento => ".C4::AR::Catalogacion::getRefFromStringConArrobas($tipo_doc));
    return C4::AR::Catalogacion::getRefFromStringConArrobas($tipo_doc);
}

=head2
sub getTipoDocumentoObject

Funcion que devuelve un objeto tipo de documento de acuerdo al id de referencia a TipoDocumento que tiene
=cut

sub getTipoDocumentoObject{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());
    my $tipo_doc    = C4::AR::Catalogacion::getRefFromStringConArrobas($marc_record->subfield("910","a"));

    my $tipo_doc_object = C4::Modelo::CatRefTipoNivel3::Manager->get_cat_ref_tipo_nivel3 ( query => [  'id_tipo_doc' => { eq => $tipo_doc } ] );

    if(scalar(@$tipo_doc_object) > 0){
        return $tipo_doc_object->[0];
    } else {
#         C4::AR::Debug::debug("CatRegistroMarcN2 => getTipoDocumentoObject()=> EL OBJECTO (ID) CatRefTipoNivel3 NO EXISTE");
        $tipo_doc = C4::Modelo::CatRefTipoNivel3->new();
    }


# C4::AR::Debug::debug("CatRegistroMarcN2 => getTipoDocumentoObject()=> EL OBJECTO (ID) CatRefTipoNivel3 eXISTE???".$tipo_doc->getNombre());
    return $tipo_doc;
}


sub getEditor{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

    my $editor      = $marc_record->subfield("260","b");
#     C4::AR::Debug::debug("CatRegistroMarcN2 => getEditor => editor => ".$editor);
    return ($editor);
}

sub getDescripcionFisica{
    my ($self)          = shift;

    my $marc_record     = MARC::Record->new_from_usmarc($self->getMarcRecord());
    my $descripcion     = $marc_record->subfield("300","a");
#     C4::AR::Debug::debug("CatRegistroMarcN2 => getDescripcionFisica => $descripcion => ".$$descripcion);
    return ($descripcion);
}

=head2 sub getSoporte

=cut
sub getSoporte{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

    my $soporte     = $marc_record->subfield("245","h");
#     C4::AR::Debug::debug("CatRegistroMarcN2 => getSoporte => soporte => ".$soporte);
    return $soporte;
}

=head2 getSoporteObject

=cut
sub getSoporteObject{
    my ($self)          = shift;

    my $marc_record     = MARC::Record->new_from_usmarc($self->getMarcRecord());
    my $ref             = C4::AR::Catalogacion::getRefFromStringConArrobas($self->getSoporte());

    my $soporte_object  = C4::Modelo::RefSoporte->getByPk($ref);

    if(!$soporte_object){
            C4::AR::Debug::debug("CatRegistroMarcN2 => getSoporteObject()=> EL OBJECTO (ID) RefSoporte NO EXISTE => ".$ref);
            $soporte_object = C4::Modelo::RefSoporte->new();
    }

    return $soporte_object;
}

=head2 sub getCiudadPublicacion
Recupera la Ciudad de Publicacion segun el MARC 260,a
=cut
sub getCiudadPublicacion{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

    return $marc_record->subfield("260","a");
}

=head2 sub getEditor
Recupera la Editor segun el MARC 260,b
=cut
# sub getEditor{
#     my ($self)      = shift;
#
#     my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());
#
#     return $marc_record->subfield("260","b");
# }

=head2 getCiudadObject

=cut
sub getCiudadObject{
    my ($self)          = shift;

    my $marc_record     = MARC::Record->new_from_usmarc($self->getMarcRecord());
    my $ref             = C4::AR::Catalogacion::getRefFromStringConArrobas($self->getCiudadPublicacion);

    my $ciudad_object   = C4::Modelo::RefLocalidad->getByPk($ref);

    if(!$ciudad_object){
            C4::AR::Debug::debug("CatRegistroMarcN2 => getCiudadObject()=> EL OBJECTO (ID) RefLocalidad NO EXISTE");
            $ciudad_object = C4::Modelo::RefLocalidad->new();
    }

    return $ciudad_object;
}

=head2 sub getIdioma
Recupera el Idioma segun el MARC 041,h
=cut
sub getIdioma{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

    return $marc_record->subfield("041","h");
}

=head2 sub getIdiomaObject
    Recupera el objeto
=cut
sub getIdiomaObject{
    my ($self)          = shift;

    my $marc_record     = MARC::Record->new_from_usmarc($self->getMarcRecord());
    my $ref             = C4::AR::Catalogacion::getRefFromStringConArrobas($self->getIdioma());

#     C4::AR::Debug::debug("CatRegistroMarcN2 => getIdioma => ".$self->getIdioma());
#     C4::AR::Debug::debug("CatRegistroMarcN2 => getIdiomaObject()=> ref => ".$ref);
    my ($cant_idiomas_array_ref, $idiomas_array_ref) = C4::Modelo::RefIdioma->getIdiomaById($ref);
    my $idioma_object   = $idiomas_array_ref->[0];


    if(!$idioma_object){
            C4::AR::Debug::debug("CatRegistroMarcN2 => getIdiomaObject()=> EL OBJECTO (ID) RefIdioma NO EXISTE");
            $idioma_object = C4::Modelo::RefIdioma->new();
    }

    return $idioma_object;
}

=head2 sub getAnio_publicacion
 Recupera la ciudad de la publicacion segun el MARC 260,c
=cut
sub getAnio_publicacion{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

    return C4::AR::Utilidades::trim($marc_record->subfield("260","c"));
}


=head2 REVISTAS
 Para las Revistas:
 De la lista del Formato Marc21 Fondos/Existencias/Datos de fondos, Campos de enumeración y cronología:
    863 a: Volumen
    863 b: Número
    863 i: Año

    http://www.loc.gov/marc/holdings/echdspa.html
=cut

sub getVolumenRevista{
     my ($self)      = shift;

     my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

     return $marc_record->subfield("863","a");
}

sub getNumeroRevista{
     my ($self)      = shift;

     my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

     return $marc_record->subfield("863","b");
}

sub getAnioRevista{
     my ($self)      = shift;

     my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

     return $marc_record->subfield("863","i");
}



=head2 sub tienePrestamos
    Verifica si el nivel 2 pasado por parametro tiene ejemplares con prestamos o no
=cut
sub tienePrestamos {
    my ($self) = shift;

    my $cant = C4::AR::Prestamos::getCountPrestamosDeGrupo($self->getId2);

    return ($cant > 0)?1:0;
}


sub obtenerValorCampo {
  my ($self) = shift;
  my ($campo,$id) = @_;

  my $ref_valores = C4::Modelo::CatRegistroMarcN2::Manager->get_cat_registro_marc_n2
                        ( select   => [$campo],
                          query =>[ id => { eq => $id} ]);

#   C4::AR::Debug::debug("CatRgistroMarcN2 => obtenerValorCampo => campo tabla => ".$campo);
#   C4::AR::Debug::debug("CatRgistroMarcN2 => obtenerValorCampo => id tabla => ".$id);


  if(scalar(@$ref_valores) > 0){
    return ($ref_valores->[0]->getCampo($campo));
  }else{
    #no se pudo recuperar el objeto por el id pasado por parametro
    return undef;
  }
}

sub getCampo{
    my ($self) = shift;
    my ($campo)=@_;

    if ($campo eq "id") {return $self->getId2;}
#     if ($campo eq "nombre") {return $self->getNombre;}

    return (0);
}

=head2 sub toMARC_Opac
    se utiliza para la visualizacion del detalle en el OPAC
=cut
sub toMARC_Opac{
    my ($self) = shift;

    #obtengo el marc_record del NIVEL 2
    my $marc_record             = MARC::Record->new_from_usmarc($self->getMarcRecord());

    my $params;
    $params->{'nivel'}          = '2';
    $params->{'id_tipo_doc'}    = $self->getTemplate()||'ALL';
    my $MARC_result_array       = C4::AR::Catalogacion::marc_record_to_opac_view($marc_record, $params,$self->db);

    return ($MARC_result_array);
}


=head2 sub toMARC

=cut
sub toMARC{
    my ($self) = shift;

    #obtengo el marc_record del NIVEL 2
    my $marc_record             = MARC::Record->new_from_usmarc($self->getMarcRecord());

    my $params;
    $params->{'nivel'}          = '2';
    $params->{'id_tipo_doc'}    = $self->getTemplate()||'ALL';
    my $MARC_result_array       = &C4::AR::Catalogacion::marc_record_to_meran_por_nivel($marc_record, $params);

    return ($MARC_result_array);
}

=head2 sub toMARC_Intra
    se utiliza para la visualizacion del detalle en la INTRA
=cut
sub toMARC_Intra{
    my ($self) = shift;

    #obtengo el marc_record del NIVEL 2
    my $marc_record             = MARC::Record->new_from_usmarc($self->getMarcRecord());

    my $params;
    $params->{'nivel'}          = '2';
    $params->{'id_tipo_doc'}    = $self->getTemplate()||'ALL';
    $params->{'id2'}            = $self->getId2();
    my $MARC_result_array       = C4::AR::Catalogacion::marc_record_to_intra_view($marc_record, $params, $self->db);

    return ($MARC_result_array);
}

#==================================================VERRRRRRRRRRRRRRRRRR==========================================================


=item
retorna la canitdad de items prestados para el grupo pasado por parametro
=cut
sub getCantPrestados{
    my ($self)  = shift;
    my ($id2)   = @_;

    my ($cantPrestamos_count) = C4::AR::Nivel2::getCantPrestados($id2);

    return $cantPrestamos_count;
}


=head2 sub tieneReservas
    Devuelve 1 si tiene ejemplares reservados en el grupo, 0 caso contrario
=cut
sub tieneReservas {
    my ($self) = shift;
    my @filtros;
    push(@filtros, ( id2    => { eq => $self->getId2}));

    my ($reservas_array_ref) = C4::Modelo::CircReserva::Manager->get_circ_reserva( query => \@filtros);

    if (scalar(@$reservas_array_ref) > 0){
        return 1;
    }else{
        return 0;
    }
}

=head2 sub getEjemplares
retorna los de ejemplares del grupo
=cut
sub getEjemplares{
    my ($self) = shift;

    my $ejemplares = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3(

                                                                query => [  'id1' => { eq => $self->getId1 },
                                                                            'id2' => { eq => $self->getId2 }
                                                                         ],

                                        );


    return $ejemplares;
}

=head2 sub getCantEjemplares
retorna la canitdad de ejemplares del grupo
=cut
sub getCantEjemplares{
    my ($self) = shift;

    my $cantEjemplares_count = C4::Modelo::CatRegistroMarcN3::Manager->get_cat_registro_marc_n3_count(

                                                                query => [  'id1' => { eq => $self->getId1 },
                                                                            'id2' => { eq => $self->getId2 }
                                                                         ],

                                        );


    return $cantEjemplares_count;
}


sub getEdicion{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

    return C4::AR::Utilidades::trim($marc_record->subfield("250","a"));
}

sub getNroSerie{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

    return $marc_record->subfield("440","v");
}


sub getPais{
    my ($self)      = shift;

    my $marc_record = MARC::Record->new_from_usmarc($self->getMarcRecord());

    return $marc_record->subfield("043","c");
}

sub isPromoted{
    my ($self) = shift;
    return ($self->promoted);
}

sub promote{
    my ($self) = shift;
    return ($self->promoted(1));
}

sub unPromote{
    my ($self) = shift;
    return ($self->promoted(0));
}


sub getInvolvedCount{

    my ($self) = shift;
    my ($tabla, $value)= @_;

    my ($filter_string,$filtros) = $self->getInvolvedFilterString($tabla, $value);
    my $cat_registro_marc_n2_count = C4::Modelo::CatRegistroMarcN2::Manager->get_cat_registro_marc_n2_count( query => $filtros );

    return ($cat_registro_marc_n2_count);
}


sub getReferenced{

    my ($self) = shift;
    my ($tabla, $value)= @_;

    my ($filter_string,$filtros) = $self->getInvolvedFilterString($tabla, $value);

    my $cat_registro_marc_n2 = C4::Modelo::CatRegistroMarcN2::Manager->get_cat_registro_marc_n2( query => $filtros );
    return ($cat_registro_marc_n2);
}



sub toString {
    my ($self) = shift;
    my $string="";

    if ($self->getTipoDocumento){
        $string.= $self->getTipoDocumentoObject->getNombre." - ";
    }

    $string.= $self->getDetalleGrupo();
    return ($string);
}

=head2 sub getMarcRecordFull
    Construye un registro MARC y le agrega los ejemplares
=cut
sub getMarcRecordFull{
    my ($self) = shift;

    #obtengo el marc_record del NIVEL 2
    my $marc_record = $self->getMarcRecordObject();

    my $ejemplares = $self->getEjemplares();

    foreach my $nivel3 (@$ejemplares){
        my $marc_record_n3  =$nivel3->getMarcRecordObject();
        $marc_record->append_fields($marc_record_n3->fields());
        }

    return $marc_record;
}



=head2 sub getMarcRecordForExport
    Construye un registro MARC para exportar con su nivel 1 y si es requerido sus ejemplares
=cut
sub getMarcRecordForRobleExport {
    my ($self) = shift;
   my ($exportar_ejemplares)=@_;
   
           #obtengo el marc_record del NIVEL 1
        my $marc_record = $self->nivel1->getMarcRecordConDatosForRobleExport();
        #obtengo el marc_record del NIVEL 2
        my $marc_record_n2 = $self->getMarcRecordConDatosForRobleExport();
        $marc_record->append_fields($marc_record_n2->fields());

        if($exportar_ejemplares){
            my $ejemplares = $self->getEjemplares();

            foreach my $nivel3 (@$ejemplares){
                my $marc_record_n3  =$nivel3->getMarcRecordConDatosForRobleExport();
                $marc_record->append_fields($marc_record_n3->fields());
                }
        }
        return $marc_record;
        
}


=head2 sub getMarcRecordConDatosForRobleExport
    Construye un registro MARC con datos referenciados con el formato pedido por roble
    
    IGUALES:
    
    ISBN:20^a 
    Nro. de edición: 250^a
    Lugar de edición: 260^a
    Editorial: 260^b
    Fecha de publicación: 260^c
    Pag.: 300^a si tienen otros detalles fisicos como ilustraciones color, tablas, graficos, ej. ^b il. Y las dimensiones van en ^c 23 cm.
    Título de la serie: 490^a
    Nro. de volumen: 490^b
    
    CAMBIAN:
    
    País de edición: 44^a <<< 43c
    Idioma: 41^a          <<< 41h
    Palabras claves: 653^a <<< 650a
    
    Código Bca. Cooperante: 910^a puede ir acompañada de signatura topografica si la hay. Ej. 910 ^aDEO 650.3 ART
    Código Bca. Cooperante: 999 (solo la sigla. Ej. 999:DEO)

=cut

sub getMarcRecordConDatosForRobleExport{
    my ($self) = shift;
    
     #obtengo el marc_record del NIVEL 2 con datos
    my $marc_record_n2             = $self->getMarcRecordConDatos();

        
    my $pais = $marc_record_n2->subfield("043","c");    
    if ($pais){
        $marc_record_n2->delete_fields($marc_record_n2->field("043"));
        my $field_044  = MARC::Field->new("044","","","a" => $pais);
        $marc_record_n2->append_fields($field_044);    
    }
    
    
    my $idioma = $self->getIdiomaObject();

    if ($idioma->getId){
        
        my $codigo= $idioma->getIdLanguage;
        
        #C4::AR::Debug::debug("IDIOMAAAA =>>>>>>>>>>>>>>> ".$idioma->getMarcCode ."=".$idioma->getIdLanguage);
        
        if($idioma->getMarcCode()){
            $codigo= $idioma->getMarcCode;
            }
        
        $marc_record_n2->delete_fields($marc_record_n2->field("041"));
        my $field_041  = MARC::Field->new("041","","","a" => $codigo);
        $marc_record_n2->append_fields($field_041);
    }

    &C4::AR::Catalogacion::moverCampoMarcRecord($marc_record_n2,'440','490');
    
    return $marc_record_n2;
}

=head2 sub getMarcRecordConDatos
    Construye un registro MARC con datos referenciados
=cut
sub getMarcRecordConDatos{
    my ($self) = shift;

    #obtengo el marc_record del NIVEL 2
    my $marc_record             = MARC::Record->new_from_usmarc($self->getMarcRecord());

    my $params;
    $params->{'nivel'}          = '2';
    $params->{'id_tipo_doc'}    = $self->getTemplate()||'ALL';

    my $MARC_record       = C4::AR::Catalogacion::marc_record_with_data($marc_record, $params->{'id_tipo_doc'}, $params->{'tipo'}, $params->{'nivel'});

        #Agregamos el indice
        if ($self->getIndice){
            $MARC_record->append_fields(MARC::Field->new(865, '', '', 'a' => $self->getIndice));
        }
    return ($MARC_record);
}


=head2 sub getMarcRecordConDatosFull
    Construye un registro MARC con datos referenciados y le agrega los ejemplares
=cut
sub getMarcRecordConDatosFull{
    my ($self) = shift;

    #obtengo el marc_record del NIVEL 2
    my $marc_record             = $self->getMarcRecordConDatos();

    my $ejemplares = $self->getEjemplares();

    foreach my $nivel3 (@$ejemplares){
        my $marc_record_n3  =$nivel3->getMarcRecordConDatos();
        $marc_record->append_fields($marc_record_n3->fields());
        }

    return $marc_record;
}

sub getNavString{
  my ($self) = shift;
  my $string = "";
  my $tipo_doc = $self->getTipoDocumento();
    
    use Switch;
    
    switch ($tipo_doc){
      case 'REV' {
            my $anio = C4::AR::Utilidades::trim($self->getAnioRevista);
            my $vol  = C4::AR::Utilidades::trim($self->getVolumen);
            my $num  = C4::AR::Utilidades::trim($self->getNumeroRevista);
            if ($anio){
                 $string .= $anio;
                }
            if ($vol){
                if($string){$string .= " ";}
                 $string .= $vol;
                }
            if ($num){
                if($string){$string .= " ";}
                 $string .= "(". $num. ")";
                }
            }
        else { #Caso por defecto => LIBRO
            my $anio = C4::AR::Utilidades::trim($self->getAnio_publicacion);
            my $vol  = C4::AR::Utilidades::trim($self->getVolumen);
            my $ed   = C4::AR::Utilidades::trim($self->getEdicion);
            
            if ($vol){
                 $string .= "v." . $vol;
                }
            if ($ed){
                if($string){$string .= " - ";}
                 $string .= $ed;
                }
            if ($anio){
                if($string){$string .= " ";}
                 $string .= "(". $anio. ")";
                }
            }
    };
    
    if(!$string){
        $string = $self->getId2;
    }
    
    return ($string)
}

sub getAll{

    my ($self) = shift;
    my ($limit,$offset,$matchig_or_not,$filtro)=@_;
    $matchig_or_not = $matchig_or_not || 0;
    my @filtros;

    if ($filtro){
        my @filtros_or;
        push(@filtros_or, (id => {eq => '%'.$filtro.'%'}) );
        push(@filtros, (or => \@filtros_or) );
    }
    my $ref_valores;
    if ($matchig_or_not){ #ESTOY BUSCANDO SIMILARES, POR LO TANTO NO TENGO QUE LIMITAR PARA PERDER RESULTADOS
        push(@filtros, ($self->getPk => {ne => $self->getPkValue}) );
        $ref_valores = C4::Modelo::CatRegistroMarcN2::Manager->get_cat_registro_marc_n2(query => \@filtros,);
    }else{
        $ref_valores = C4::Modelo::CatRegistroMarcN2::Manager->get_cat_registro_marc_n2(query => \@filtros,
                                                                    limit => $limit, 
                                                                    offset => $offset, 
                                                                   );
    }
    my $ref_cant = C4::Modelo::CatRegistroMarcN2::Manager->get_cat_registro_marc_n2_count(query => \@filtros,);

    return($ref_cant,$ref_valores);
}

sub getCountPortadasEdicion{
    my ($self) = shift;

    use C4::AR::PortadaNivel2;

    return C4::AR::PortadaNivel2::getCountPortadasEdicion($self->id);
}

sub getPortadasEdicion{
    my ($self) = shift;

    use C4::AR::PortadaNivel2;

    return C4::AR::PortadaNivel2::getPortadasEdicion($self->id);
}


sub getDetalleGrupo {
    my ($self) = shift;
    my $string="";
 
    if ($self->getTipoDocumento eq "REV"){
      #Es una revista va Año Volumen(Fascículo)
      $string .= "Número: ";

      if ($self->getAnioRevista){
        if($string){$string.=" ";}
        $string.= $self->getAnioRevista;
      }
      if ($self->getVolumenRevista){
        if($string){$string.=" ";}
        $string.= $self->getVolumenRevista;
      }
      if ($self->getNumeroRevista){
        if($string){$string.=" ";}
        $string.= "(".$self->getNumeroRevista.")";
      }
    }else{
      #Es otra cosa Serie Edicion Volumen (Año)
      $string .= "Edición: ";
      
      if ($self->getNroSerie){
      if($string){$string.=" ";}
      $string.= $self->getNroSerie;
      }

      if ($self->getEdicion){
      if($string){$string.=" ";}
      $string.= $self->getEdicion;
      }

      if ($self->getVolumen){
      if($string){$string.=" ";}
      $string.= $self->getVolumen;
      }

      if ($self->getAnio_publicacion){
      if($string){$string.=" ";}
      $string.= "(".$self->getAnio_publicacion.")";
      }
    }

    return ($string);
}

=head2 sub estaEnEstante
    Devuelve 1 si tiene el restro se encuentra en un estante, 0 caso contrario
=cut
sub estaEnEstante {
    my ($self) = shift;
    my @filtros;
    push(@filtros, ( id2    => { eq => $self->getId2}));

    my ($contenido_array_ref) = C4::Modelo::CatContenidoEstante::Manager->get_cat_contenido_estante( query => \@filtros);

    if (scalar(@$contenido_array_ref) > 0){
        return 1;
    }else{
        return 0;
    }
}

1;
