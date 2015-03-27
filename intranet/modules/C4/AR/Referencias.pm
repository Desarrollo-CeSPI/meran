package C4::AR::Referencias;

#Este modulo provee funcionalidades varias sobre las tablas de referencias en general
#Escrito el 8/9/2006 por einar@info.unlp.edu.ar
#
#Copyright (C) 2003-2006  Linti, Facultad de Informática, UNLP
#This file is part of Koha-UNLP
#
#This program is free software; you can redistribute it and/or
#modify it under the terms of the GNU General Public License
#as published by the Free Software Foundation; either version 2
#of the License, or (at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program; if not, write to the Free Software
#Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

use strict;
require Exporter;
use C4::Context;
use C4::Date;
use C4::Modelo::PrefTablaReferencia;
use C4::Modelo::PrefEstructuraSubcampoMarc::Manager;
use C4::Modelo::PrefEstructuraSubcampoMarc;
use C4::Modelo::PrefTablaReferenciaRelCatalogo::Manager;
use C4::Modelo::AdqProveedor::Manager;
use C4::Modelo::PrefInformacionReferencia::Manager;
use C4::Modelo::AdqTipoMaterial::Manager;
use C4::Modelo::AdqFormaEnvio::Manager;
use C4::Modelo::AdqPresupuesto::Manager;
use C4::Modelo::RefColaborador;
use C4::Modelo::RefSignatura;
use C4::Modelo::RefAcm;


use JSON;
use Switch;

use vars qw(@EXPORT_OK @ISA);
@ISA        = qw(Exporter);
@EXPORT_OK  = qw(
                    obtenerFormasDeEnvio
                    obtenerTiposDeMaterial
                    obtenerTiposDeDocumentos
                    obtenerCategoriaDeSocio
                    getCamposDeTablaRef
                    obtenerValoresTablaRef
                    obtenerTablasDeReferencia
                    obtenerTiposNivel3
                    obtenerProveedores
                    translateTipoNivel3
                    obtenerEstantes
                    obtenerUIByIdUi
                    obtenerDefaultUI
                    obtenerEstados
                    idCategoriaDeSocio
        );


#Este modulo provee funcionalidades varias sobre las tablas de referencias en general
#Escrito el 8/9/2006 por einar@info.unlp.edu.ar
#
#Copyright (C) 2003-2006  Linti, Facultad de Informática, UNLP
#This file is part of Koha-UNLP
#
#This program is free software; you can redistribute it and/or
#modify it under the terms of the GNU General Public License
#as published by the Free Software Foundation; either version 2
# #of the License, or (at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program; if not, write to the Free Software
#Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

=item
    sub getInformacionReferenciaFromId
    
    retorna un objeto PrefInformacionReferencia si existe la informacion de referencia segun el id pasado por parametro
=cut
sub getInformacionReferenciaFromId {
    my ($db, $id) = @_;

    my $informacion_referencia_array_ref = C4::Modelo::PrefInformacionReferencia::Manager->get_pref_informacion_referencia(
                                                                db      => $db,
                                                                query   => [ idinforef => { eq => $id } ]
                                            );
    
    if(scalar(@$informacion_referencia_array_ref) > 0){
      return $informacion_referencia_array_ref->[0];
    }else{
      return 0;
    }
}

=item
Esta funcion devuelve un arreglo de objetos tipo de documento
=cut
sub obtenerTiposDeDocumentos {
    my $tiposDoc = C4::Modelo::UsrRefTipoDocumento::Manager->get_usr_ref_tipo_documento;
    my @results;

    foreach my $tipo_doc (@$tiposDoc) {
        push (@results, $tipo_doc);
    }

    return(\@results);
}



=item
Esta funcion devuelve un arreglo de objetos formas de envio
=cut
sub obtenerFormasDeEnvio {
    my $formasEnvio = C4::Modelo::AdqFormaEnvio::Manager->get_adq_forma_envio;
    my @results;

    foreach my $forma_envio (@$formasEnvio) {
        push (@results, $forma_envio);
    }

    return(\@results);
}

=item
Esta funcion devuelve un arreglo de objetos tipo de material
=cut
sub obtenerTiposDeMaterial {
    my $tiposMaterial = C4::Modelo::AdqTipoMaterial::Manager->get_adq_tipo_material;
    my @results;

    foreach my $tipo_material (@$tiposMaterial) {
        push (@results, $tipo_material);
    }

    return(\@results);
}

sub obtenerProveedores {
    my $proveedores = C4::Modelo::AdqProveedor::Manager->get_adq_proveedor;
    my @results;

    foreach my $prov (@$proveedores) {
        push (@results, $prov);
    }

    return(\@results);
}

=item
Esta funcion devuelve un arreglo de objetos con los tipos de nivel3
=cut
sub obtenerTiposNivel3 {
    my $tiposNivel3 = C4::Modelo::CatRefTipoNivel3::Manager->get_cat_ref_tipo_nivel3(sort_by => ['NOMBRE ASC']);
    my @results;

    foreach my $tipo_nivel3 (@$tiposNivel3) {
        push (@results, $tipo_nivel3);
    }

    return(\@results);
}

=item
Esta funcion devuelve un arreglo de objetos con los tipos de nivel3 filtrado por "enable_from_new_register"
=cut
sub obtenerEsquemaParaAltaRegistro{
    my ($enable) = @_;
    my @results;

    my $esquema_array_ref = C4::Modelo::CatRefTipoNivel3::Manager->get_cat_ref_tipo_nivel3(
                                                                query => [ enable_from_new_register => { eq => $enable } ]
                                            );

    foreach my $tipo_nivel3 (@$esquema_array_ref) {
        push (@results, $tipo_nivel3);
    }

    return(\@results);
}

=item
Esta funcion devuelve un arreglo de objetos de categorias de socios
=cut
sub obtenerCategoriaDeSocio {
    my $categorias_array_ref = C4::Modelo::UsrRefCategoriaSocio::Manager->get_usr_ref_categoria_socio;
    my @results;

    foreach my $objeto_categoria (@$categorias_array_ref) {
        push (@results, $objeto_categoria);
    }

    return(\@results);
}

=item
    Esta funcion retorca el categorycode de la categoria de un usuario apartir del ID de la categoria
=cut
sub getCategoryCodeById {
    my ($id) = @_;

    my @filtros;
    
    push (@filtros, (id => {eq => $id}) );

    my $categorias_array_ref = C4::Modelo::UsrRefCategoriaSocio::Manager->get_usr_ref_categoria_socio(query => \@filtros,);
    my @results;

    return($categorias_array_ref->[0]);
}

sub idCategoriaDeSocio {
	my ($codigo) = @_;

    my @filtros;
    
    push (@filtros, (categorycode => {eq =>$codigo}) );

    my $categorias_array_ref = C4::Modelo::UsrRefCategoriaSocio::Manager->get_usr_ref_categoria_socio(query => \@filtros,);
    my @results;

    return($categorias_array_ref->[0]);
}

=item
Devuelve un arreglo de objetos Unidades de Informacion
=cut
sub obtenerUnidadesDeInformacion {
    my $unidades_array_ref = C4::Modelo::PrefUnidadInformacion::Manager->get_pref_unidad_informacion;
    my @results;

    foreach my $objeto_ui (@$unidades_array_ref) {
        push (@results, $objeto_ui);
    }

    return(\@results);
}

=item
Devuelve un objeto PrefUnidadInformacion con la defaultUI
=cut
sub obtenerDefaultUI {

    my @filtros;
    my $defaultUI =  C4::AR::Preferencias::getValorPreferencia("defaultUI");
     
    push (@filtros, (id_ui => {eq =>$defaultUI}) );
    my $unidades_array_ref = C4::Modelo::PrefUnidadInformacion::Manager->get_pref_unidad_informacion(
                                                                                                        query => \@filtros,
                                                                                                    );

    return ($unidades_array_ref->[0]);
}

sub getFirstDefaultUI {

    my $unidades_array_ref = C4::Modelo::PrefUnidadInformacion::Manager->get_pref_unidad_informacion();

    return ($unidades_array_ref->[0]);
}

=item
Devuelve un arreglo de objetos Nivel Bibliografico
=cut
sub obtenerNivelesBibliograficos {
    my $niveles_array_ref = C4::Modelo::RefNivelBibliografico::Manager->get_ref_nivel_bibliografico(sort_by => ['DESCRIPTION ASC']);
    my @results;

    foreach my $objeto_nivel (@$niveles_array_ref) {
        push (@results, $objeto_nivel);
    }

    return(\@results);
}

=item
Devuelve un arreglo de objetos Autor
=cut
sub obtenerAutores {
    my $autores_array_ref = C4::Modelo::CatAutor::Manager->get_cat_autor;
    my @results;

    foreach my $objeto_autor (@$autores_array_ref) {
        push (@results, $objeto_autor);
    }

    return(\@results);
}

=item
Devuelve un arreglo de objetos Autor
=cut
sub obtenerAutoresLike {
	my ($autor) = @_;

    my $autores_array_ref = C4::Modelo::CatAutor::Manager->get_cat_autor(
																query => [ completo => { like => '%'.$autor.'%' } ],
                                                                sort_by => 'completo',
                                                                
											);
    my @results;

    foreach my $objeto_autor (@$autores_array_ref) {
        push (@results, $objeto_autor);
    }

    return(\@results);
}

=item
Devuelve un arreglo de de objetos CatRegistroMarcN2
=cut
sub obtenerNivel2Like {
    my ($nivel2) = @_;

    my $n2_array_ref = C4::Modelo::CatRegistroMarcN2::Manager->get_cat_registro_marc_n2(
                                                                query => [ id => { like => '%'.$nivel2.'%' } ],
                                                                sort_by => 'id ASC',
                                            );
    my @results;

    foreach my $objeto_n2 (@$n2_array_ref) {
        push (@results, $objeto_n2);
    }

    return(\@results);
}

=item
Devuelve un arreglo de objetos UI
=cut
sub obtenerUILike {
    my ($nombre) = @_;

    my $uis_array_ref = C4::Modelo::PrefUnidadInformacion::Manager->get_pref_unidad_informacion(
                                                                query => [ nombre => { like => '%'.$nombre.'%' } ],
                                                                sort_by => 'nombre ASC',
                                            );
    my @results;

    foreach my $objeto_ui (@$uis_array_ref) {
        push (@results, $objeto_ui);
    }

    return(\@results);
}

=item
Devuelve un objeto UI o 0 sino lo encuentra
=cut
sub obtenerUIByIdUi{
    my ($nombre) = @_;

    my $uis_array_ref = C4::Modelo::PrefUnidadInformacion::Manager->get_pref_unidad_informacion(
                                                                query => [ id_ui => { eq => $nombre } ]
                                            );
    if(scalar($uis_array_ref) > 0){
        return ($uis_array_ref->[0]);
    }else{
        return 0;
    }
}

=item
Devuelve un objeto UI o 0 sino lo encuentra
=cut
sub obtenerEsquemaById{
    my ($id) = @_;

    my $esquema_array_ref = C4::Modelo::CatRefTipoNivel3::Manager->get_cat_ref_tipo_nivel3(
                                                                query => [ id => { eq => $id } ]
                                            );
    if(scalar($esquema_array_ref) > 0){
#         C4::AR::Debug::debug("ESQUEMA => ".$esquema_array_ref->[0]->getId_tipo_doc());
        return ($esquema_array_ref->[0]->getId_tipo_doc());
    }else{
        return 0;
    }
}

=item
Devuelve un arreglo de objetos Unidades de Informacion
=cut
sub obtenerDisponibilidades {
    my $disponibilidades_array_ref = C4::Modelo::RefDisponibilidad::Manager->get_ref_disponibilidad;
    my @results;

    foreach my $objeto_disponibilidad (@$disponibilidades_array_ref) {
        push (@results, $objeto_disponibilidad);
    }

    return(\@results);
}


=item
Devuelve un arreglo de objetos PrefTablaReferencia
=cut
sub obtenerTablasDeReferencia {
    my $referencias_array_ref = C4::Modelo::PrefTablaReferencia::Manager->get_pref_tabla_referencia;
    my @results;

    foreach my $objeto_ref (@$referencias_array_ref) {
		  push (@results, $objeto_ref);
    }

    return(\@results);
}

=item
Devuelve un arreglo de los alias de objetos PrefTablaReferencia en string
=cut
sub obtenerTablasDeReferenciaAsString {
   
    my $referencias_array_ref = obtenerTablasDeReferencia();
    my @results;

    foreach my $objeto_ref (@$referencias_array_ref) {
        push (@results, $objeto_ref->getAlias_tabla);
    }

    return(\@results);
}



sub getCamposDeTablaRef{
    # (Chain Of Responsibility Object Pattern)
    my ($tableAlias) = @_;
    C4::AR::Debug::debug("Referencias => getCamposDeTablaRef => ".$tableAlias);

    my $db = C4::Modelo::PrefTablaReferencia->new();
       $db = $db->createFromAlias($tableAlias);
    if ($db){
        my @JSON_array_ref = $db->getCamposAsHash();
        return \@JSON_array_ref;
    }else{
        return (0);
    }
}


=item
obtenerValoresTablaRef
Obtiene las tuplas con los campos requeridos de la tabla a la cual se esta haciendo referencia. Devuelve un string json y una hash.
=cut
sub obtenerValoresTablaRef{
    my ($tableAlias,$campo, $orden)=@_;

#     C4::AR::Debug::debug("Referencias => obtenerValoresTablaRef => tableAlias: ".$tableAlias);
#     C4::AR::Debug::debug("Referencias => obtenerValoresTablaRef => campo: ".$campo);
#     C4::AR::Debug::debug("Referencias => obtenerValoresTablaRef => orden: ".$orden);
    
    my $ref = C4::Modelo::PrefTablaReferencia->new();
	  my ($cantidad, $valores, $default_value) = $ref->obtenerValoresTablaRef($tableAlias,$campo, $orden);

#     C4::AR::Debug::debug("Referencias => obtenerValoresTablaRef => cantidad: ".$cantidad);
#     C4::AR::Debug::debug("Referencias => obtenerValoresTablaRef => valores: ".$valores);
    return($cantidad, $valores, $default_value);

}

=item
obtenerIdentTablaRef
Obtiene el campo clave de la tabla a la cual se esta asi referencia
=cut
sub obtenerIdentTablaRef{
    my ($tableAlias)=@_;

    my $ref = C4::Modelo::PrefTablaReferencia->new();

    return($ref->obtenerIdentTablaRef($tableAlias));
}



=item
Devuelve un arreglo de objetos PrefEstructuraCampoMarc
=cut
sub obtenerCamposLike {
	my ($campo) = @_;

    my $campos_marc_array_ref = C4::Modelo::PrefEstructuraCampoMarc::Manager->get_pref_estructura_campo_marc(
																query => [  
																			or => [ 
                                                                                    campo => { like => '%'.$campo.'%' }, 
																					liblibrarian => { like => '%'.$campo.'%' }
																				]
																		],
                                                                  sort_by => 'campo ASC',
                                  
											);
    my @results;

    foreach my $objeto_campo_marc (@$campos_marc_array_ref) {
        push (@results, $objeto_campo_marc);
    }

    return(\@results);
}


=item sub getTablasDeReferenciaLike
Devuelve un objeto PrefTablaReferencia (SI EXISTE) segun las tablas pasadas por parametro
=cut
sub getTablaDeReferenciaLike {
    my ($tabla) = @_;

    my $referencias_array_ref = C4::Modelo::PrefTablaReferencia::Manager->get_pref_tabla_referencia(
                                                      query => [  
                                                                  or => [ nombre_tabla => { like => '%'.$tabla.'%' } ]
                                                                ]
                      );

    if(scalar(@$referencias_array_ref) > 0){
      return $referencias_array_ref->[0];
    }else{
      return 0;
    }
}

=item
Devuelve un arreglo de objetos PrefEstructuraCampoMarc
=cut
sub obtenerSubCamposDeCampo {
	my ($campo) = @_;

    my $campos_marc_array_ref = C4::Modelo::PrefEstructuraSubcampoMarc::Manager->get_pref_estructura_subcampo_marc(
																query => [ campo => { eq => $campo } ]
											);
    my @results;

    foreach my $objeto_campo_marc (@$campos_marc_array_ref) {
        push (@results, $objeto_campo_marc);
    }

    return(\@results);
}

sub getTabla{
    
    my ($alias,$filtro,$limit,$offset) = @_;
    my $tabla = C4::Modelo::PrefTablaReferencia->new();
       $tabla = $tabla->createFromAlias($alias);

    $limit = $limit || 20;
    $offset = $offset || 0;
    my ($cantidad,$datos) = $tabla->getAll($limit,$offset,0,$filtro,1);
    my $campos = $tabla->getCamposAsArray();
    my $clave = $tabla->meta->primary_key;

    $tabla = $tabla->getAlias;
    return ($cantidad,$clave,$tabla,$datos,$campos);
}


sub getTablaInstanceByAlias{
    
    my ($alias) = @_;
    
    my $tabla = C4::Modelo::PrefTablaReferencia->new();
       $tabla = $tabla->createFromAlias($alias);


    my $clave;

    if ($tabla){
      $clave = $tabla->meta->primary_key;
      
    }

    return ($clave,$tabla);
}

sub getTablaInstanceByTableName{ 
    my ($name) = @_;
   
    my $tabla;

   switch ($name) {
      case "cat_registro_marc_n1" { $tabla = C4::Modelo::CatRegistroMarcN1->new()  }
      case "cat_registro_marc_n2" { $tabla = C4::Modelo::CatRegistroMarcN2->new()  }
      case "cat_registro_marc_n3" { $tabla = C4::Modelo::CatRegistroMarcN3->new()  }
      case "usr_socio" { $tabla = C4::Modelo::UsrSocio->new()  }
      case "usr_persona" { $tabla = C4::Modelo::UsrPersona->new()  }
      case "circ_prestamo" { $tabla = C4::Modelo::CircPrestamo->new()  }
      case "cat_visualizacion_opac" { $tabla = C4::Modelo::CatVisualizacionOpac->new()  }
      case "usr_estado" { $tabla = C4::Modelo::UsrEstado->new()  }
      case "usr_regularidad" { $tabla = C4::Modelo::UsrRegularidad->new()  }
      case "usr_ref_categoria_socio" { $tabla = C4::Modelo::UsrRefCategoriaSocio->new()  }

      else { C4::AR::Debug::debug("getTablaInstanceByTableName()========================================= >TABLA POR NOMBRE INEXISTENTE") }
  }

    my $clave = $tabla->getPk;

    return ($clave,$tabla);
}

sub mostrarReferenciasParaCatalogo{

    my ($alias,$value_id,$data_array) = @_;

    my $global_references_count = 0;

    my @tablas_matching = ('cat_registro_marc_n1','cat_registro_marc_n2','cat_registro_marc_n3');
    my ($clave_tabla_referencia, $tabla_referencia) = getTablaInstanceByAlias($alias);
    foreach my $tabla (@tablas_matching){
        my %table_data = {};
        my ($clave,$tabla_referente) = getTablaInstanceByTableName($tabla);
        my $involved_count = $tabla_referente->getInvolvedCount($tabla_referencia,$value_id);
        $table_data{"tabla"} = $tabla_referente->meta->table;
        $table_data{"tabla_object"} = $tabla_referente;
        $table_data{"cantidad"} = $involved_count;
        $table_data{"tabla_catalogo"} = 1;
        $global_references_count += $involved_count;
        push (@$data_array, \%table_data);
    }
    return ($global_references_count);
}


sub mostrarReferencias{

    my ($alias,$value_id) = @_;
    my @filtros;

    my @data_array;

    push (  @filtros, ( alias_tabla => { eq => $alias },) );

    my $tablas_matching = C4::Modelo::PrefTablaReferenciaRelCatalogo::Manager->get_pref_tabla_referencia_rel_catalogo(
                                                                                   query => \@filtros,
                                                                                );
    my $global_references_count = mostrarReferenciasParaCatalogo($alias,$value_id,\@data_array);
    my ($clave_tabla_referer_involved,$tabla_referer_involved) = getTablaInstanceByAlias($alias);
    my $referer_involved = $tabla_referer_involved->getByPk($value_id);
    if (scalar(@$tablas_matching)){
        my ($clave_original,$tabla_original) = getTablaInstanceByAlias($tablas_matching->[0]->getAlias_tabla);
        #ESTE ES EL REFERIDO ORIGINAL, PARA MOSTRARLO EN EL CLIENTE
        C4::AR::Debug::debug("================== REFERER INVOLVED ==== ".$referer_involved->meta->table);
        $referer_involved = $tabla_original->getByPk($value_id);
        C4::AR::Debug::debug("================== REFERER INVOLVED ByPK ==== ".$referer_involved->getPkValue);

        foreach my $tabla (@$tablas_matching){
            my %table_data = {};
            my $alias_tabla = $tabla->getAlias_tabla;
            #NO TIENE ALIAS PORQUE NO ES UNA TABLA DE REFERENCIA, IGUAL ESTA POR VERSE SI LE PONEMOS ALIAS A TODAS O NO
            my ($clave_referente,$tabla_referente) = getTablaInstanceByTableName($tabla->getTabla_referente);
      
            if ($tabla_referente){
                my $involved_count;
                C4::AR::Debug::debug("ENTERING INVOLVED COUNT ");
                C4::AR::Debug::debug("TABLA REFERENTE ".$tabla_referente);
                $involved_count = $tabla_referente->getInvolvedCount($tabla,$value_id);
                C4::AR::Debug::debug("EXITING INVOLVED COUNT ");
                $table_data{"tabla"} = $tabla->getTabla_referente;
                $table_data{"tabla_object"} = $tabla;
                $table_data{"cantidad"} = $involved_count;
                $global_references_count += $involved_count;
                push (@data_array, \%table_data);
            }
        }
    }
#     C4::AR::Debug::debug("REFERER INVOLVED: ".$referer_involved);
    return ($global_references_count,$referer_involved,\@data_array);
}

sub mostrarSimilares{

    my ($alias,$value_id) = @_;

    my ($clave,$tabla) = getTablaInstanceByAlias($alias);
  
    if ($tabla){
        my $refered = $tabla->getByPk($value_id);
    
        my $related_referers = $refered->getRelated;
        
        my $tabla_related = $refered->getAlias();
    
        return ($tabla_related,$related_referers);
    }
    
    return (undef,undef);
}

sub asignarReferencia{

    my ($alias_tabla,$related_id,$referer_involved) = @_;

    my ($clave,$tabla) = getTablaInstanceByAlias($alias_tabla);

    my $status = 0;

    if ($tabla){
        my $old_pk = $tabla->getByPk($referer_involved);
        
        my $new_instance = $tabla->getByPk($related_id);
        
        $related_id =   $new_instance->get_key_value();
        
        $status = $old_pk->replaceByThis($related_id);
    }
    
    asignarReferenciaParaCatalogo($alias_tabla,$related_id,$referer_involved);

    return ($status);
}


sub asignarReferenciaParaCatalogo{

  my ($alias_tabla,$related_id,$referer_involved) = @_;
  my ($clave,$tabla) = getTablaInstanceByAlias($alias_tabla);
  my $nombre_tabla = $tabla->meta->table;

  use C4::AR::Sphinx;

  my $id_viejo = $referer_involved;
  my $id_nuevo = $related_id;
  my @id1_to_generate = ();
 #Nivel 1 
  my $nivel = C4::Modelo::CatRegistroMarcN1->new();
  my $registros = $nivel->getReferenced($tabla,$referer_involved);

  foreach my $registro (@$registros){
      my $marc = $registro->getMarcRecord;
      $marc =~ s/$nombre_tabla\@$id_viejo/$nombre_tabla\@$id_nuevo/g;
      $registro->setMarcRecord($marc);
      $registro->save();
      push (@id1_to_generate,$registro->getId1());
  }
  
 #Nivel 2 
  my $nivel = C4::Modelo::CatRegistroMarcN2->new();
  my $registros = $nivel->getReferenced($tabla,$referer_involved);

  foreach my $registro (@$registros){
      my $marc = $registro->getMarcRecord;
      $marc =~ s/$nombre_tabla\@$id_viejo/$nombre_tabla\@$id_nuevo/g;
      $registro->setMarcRecord($marc);
      $registro->save();
      if (!C4::AR::Utilidades::existeInArray($registro->getId1(),@id1_to_generate)){
            push (@id1_to_generate,$registro->getId1());
      }
  }
  
 #Nivel 3 
  my $nivel = C4::Modelo::CatRegistroMarcN3->new();
  my $registros = $nivel->getReferenced($tabla,$referer_involved);

  foreach my $registro (@$registros){
      my $marc = $registro->getMarcRecord;
      $marc =~ s/$nombre_tabla\@$id_viejo/$nombre_tabla\@$id_nuevo/g;
      $registro->setMarcRecord($marc);
      $registro->save();
      if (!C4::AR::Utilidades::existeInArray($registro->getId1(),@id1_to_generate)){
            push (@id1_to_generate,$registro->getId1());
      }
  } 
  #Se regenera el indice para todos los Id1
  
  foreach my $id1 (@id1_to_generate){
        C4::AR::Sphinx::generar_indice($id1, 'R_PARTIAL', 'UPDATE');
  }
  
}


sub eliminarReferencia{

    my ($alias_tabla,$referer_involved) = @_;

    my ($clave,$tabla) = getTablaInstanceByAlias($alias_tabla);
    my $status = 0;
    C4::AR::Debug::debug("===============================SE VA A ELIMINAR LA REFERENCIA============================");
    if ($tabla){
        my ($used_or_not) = mostrarReferencias($alias_tabla,$referer_involved);

        if (!$used_or_not){

            my $old_pk = $tabla->getByPk($referer_involved);

  
            $status = $old_pk->delete();

            C4::AR::Debug::debug("===============================SE ELIMINO LA REFERENCIA============================");
        }else{
            $status = 0;
        }
    }
    my $msg_object= C4::AR::Mensajes::create();
    if (!$status){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'REF0', 'params' => []} );
    }else{
        $msg_object->{'error'}= 0;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'REF1', 'params' => []} );
    }


    return ($msg_object);
}

sub asignarYEliminarReferencia{

    my ($alias_tabla,$related_id,$referer_involved) = @_;

    my $status_asignar = asignarReferencia($alias_tabla,$related_id,$referer_involved);
    
    my $status_eliminar = eliminarReferencia($alias_tabla,$referer_involved);

    return ($status_asignar && $status_eliminar);
}

sub editarReferencia{

    my ($string_ref,$value) = @_;

    my @values = split('___',$string_ref);

        my ($clave,$tabla) = getTablaInstanceByAlias(@values[0]);
        my $campo = @values[1];
        my $id_tabla = @values[2];
        
        my $object = $tabla->getByPk($id_tabla);
        $object->modifyFieldValue($campo,$value);

        return ($object->{$campo});

}

sub agregarRegistro{

    my ($alias,$filtro) = @_;
    my $tabla  = C4::Modelo::PrefTablaReferencia->new();
    my $object = $tabla = $tabla->createFromAlias($alias);

    _deleteUniqueCodigoCategoria();

    eval{
        $object = $tabla->addNewRecord();
    };

    $tabla = $tabla->createFromAlias($alias);

    my @array;

    push (@array,$object);
    C4::AR::Debug::debug("OBJECT TABLA ADDNEWRECORD ======================== ".$tabla);
    my $campos = $object->getCamposAsArray();
    my $clave = $object->meta->primary_key;

    $tabla = $object->getAlias;
    return ($clave,$tabla,\@array,$campos);
}

sub _deleteUniqueCodigoCategoria {
    my @filtros;

    push ( @filtros, ( categorycode => { eq => '_S' },) );

    my $tiposNivel3 = C4::Modelo::UsrRefCategoriaSocio::Manager->delete_usr_ref_categoria_socio(where => \@filtros);
                                                                                       
}

sub getValidadores{
    
    my %validadores;    
    $validadores{'solo_texto'}          = C4::AR::Filtros::i18n('Solo letras');
    $validadores{'digits'}              = C4::AR::Filtros::i18n('Solo numeros');
    $validadores{'alphanumeric_total'}  = C4::AR::Filtros::i18n('Letras y numeros');
    $validadores{'combo'}               = C4::AR::Filtros::i18n('Lista desplegable');
    # $validadores{'anio'}                = C4::AR::Filtros::i18n('Anual');
    # $validadores{'rango_anio'}          = C4::AR::Filtros::i18n('Anual rango');
    $validadores{'calendar'}            = C4::AR::Filtros::i18n('Calendario');
    $validadores{'auto'}                = C4::AR::Filtros::i18n('Autocompletable');
    $validadores{'texto_area'}          = C4::AR::Filtros::i18n('Texto grande');

    return \%validadores;
}

sub getTipoNivel3ByCodigo{
    my ($tipo_nivel3) = @_;
    
    my @filtros;

    push (  @filtros, ( id_tipo_doc => { eq => $tipo_nivel3 },) );

    my $tiposNivel3 = C4::Modelo::CatRefTipoNivel3::Manager->get_cat_ref_tipo_nivel3(query => \@filtros);

    if (scalar(@$tiposNivel3)){
    	return ($tiposNivel3->[0]);
    }else{
    	return 0;
    }
}

sub translateTipoNivel3{
    my ($tipo_nivel3) = @_;
    
    my @filtros;

    push (  @filtros, ( id_tipo_doc => { eq => $tipo_nivel3 },) );

    my $tiposNivel3 = C4::Modelo::CatRefTipoNivel3::Manager->get_cat_ref_tipo_nivel3(query => \@filtros);

    if (scalar(@$tiposNivel3)){
    	return ($tiposNivel3->[0]->getNombre);
    }else{
    	return ($tipo_nivel3);
    }
}

sub obtenerEstantes{
	
	use C4::Modelo::CatEstante::Manager;
	
	my $estantes = C4::Modelo::CatEstante::Manager->get_cat_estante();
	
	return ($estantes);
	
	
}


sub obtenerEstados{
    
    use C4::Modelo::UsrEstado::Manager;
    
    my $estados = C4::Modelo::UsrEstado::Manager->get_usr_estado();
    
    return ($estados);
    
    
}



sub obtenerEstadosEjemplares{
    
    use C4::Modelo::RefEstado::Manager;
    
    my $estados = C4::Modelo::RefEstado::Manager->get_ref_estado();
    
    return ($estados);
    
    
}
END { }       # module clean-up code here (global destructor)

1;
__END__
