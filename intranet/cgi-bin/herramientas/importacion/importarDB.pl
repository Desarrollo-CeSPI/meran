#!/usr/bin/perl
#
# Meran - MERAN UNLP is a ILS (Integrated Library System) wich provides Catalog,
# Circulation and User's Management. It's written in Perl, and uses Apache2
# Web-Server, MySQL database and Sphinx 2 indexing.
# Copyright (C) 2009-2013 Grupo de desarrollo de Meran CeSPI-UNLP
#
# This file is part of Meran.
#
# Meran is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Meran is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Meran.  If not, see <http://www.gnu.org/licenses/>.
#

use strict;
use C4::AR::Auth;
use C4::AR::ImportacionIsoMARC;
use CGI;
use JSON;

my $input           = new CGI;
my $authnotrequired = 0;
my $obj             = $input->param('obj');
$obj                = C4::AR::Utilidades::from_json_ISO($obj);
my $tipoAccion      = $obj->{'tipoAccion'}||"BUSQUEDA";

=item
    Se elimina el Proveedor
=cut

if($tipoAccion eq "ELIMINAR"){

        my ($userid, $session, $flags) = checkauth( $input,
                                            $authnotrequired,
                                            {   ui              => 'ANY',
                                                tipo_documento  => 'ANY',
                                                accion          => 'BAJA',
                                                tipo_permiso => 'catalogo',
                                                entorno => 'undefined'},
                                                "intranet"
                                    );

        my $id_importacion        = $obj->{'id_importacion'};

        my ($Message_arrayref)  = C4::AR::ImportacionIsoMARC::eliminarImportacion($id_importacion);
        my $infoOperacionJSON   = to_json $Message_arrayref;

        C4::AR::Auth::print_header($session);
        print $infoOperacionJSON;

    } #end if($tipoAccion eq "ELIMINAR_Importacion")

elsif($tipoAccion eq "DETALLE"){

#Detalle de una importacion
    my ($template, $session, $t_params)= get_template_and_user({
                                    template_name => "/herramientas/importacion/lista_registros_importacion.tmpl",
                                    query => $input,
                                    type => "intranet",
                                    authnotrequired => 0,
                                    flagsrequired => {  ui => 'ANY',
                                                        tipo_documento => 'ANY',
                                                        accion => 'CONSULTA',
                                                        tipo_permiso => 'catalogo',
                                                        entorno => 'undefined'},
                                    debug => 1,
            });



  my $funcion   = $obj->{'funcion'} || 'changePage';
  my $ini       = $obj->{'ini'} || 1;
  my $id_importacion   = $obj->{'id_importacion'};
  my $search    = $obj->{'search'} || undef;
  my $record_filter   = $obj->{'record_filter'};

  my ($ini,$pageNumber,$cantR) = C4::AR::Utilidades::InitPaginador($ini);
  my ($cantidad,$registros,$id_esquema) = C4::AR::ImportacionIsoMARC::getRegistrosFromImportacion($id_importacion,$record_filter,$ini,$cantR,$search);

      $t_params->{'paginador'} = C4::AR::Utilidades::crearPaginador($cantidad,$cantR, $pageNumber,$funcion,$t_params);
      $t_params->{'resultsloop'}        = $registros;
      $t_params->{'cantidad'}           = $cantidad;
      $t_params->{'id_importacion'}     = $id_importacion;
      $t_params->{'id_esquema'}         = $id_esquema;
      $t_params->{'record_filter'}      = $record_filter;
      $t_params->{'jobID'}              = C4::AR::ImportacionIsoMARC::getImportacionById($id_importacion)->jobID;


    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);


 }

elsif($tipoAccion eq "DETALLE_REGISTRO"){

#Detalle de una importacion
    my ($template, $session, $t_params)= get_template_and_user({
                                    template_name => "/herramientas/importacion/detalleRegistroMARC.tmpl",
                                    query => $input,
                                    type => "intranet",
                                    authnotrequired => 0,
                                    flagsrequired => {  ui => 'ANY',
                                                        tipo_documento => 'ANY',
                                                        accion => 'CONSULTA',
                                                        tipo_permiso => 'catalogo',
                                                        entorno => 'undefined'},
                                    debug => 1,
            });

  my $id   = $obj->{'id'};
  my ($registro_importacion) = C4::AR::ImportacionIsoMARC::getRegistroFromImportacionById($id);
      $t_params->{'registro_importacion'} = $registro_importacion;

  my $vista_previa = C4::AR::ImportacionIsoMARC::detalleCompletoRegistro($id);
     
      $t_params->{'nivel1'}           = $vista_previa->{'nivel1'};
      $t_params->{'nivel1_template'}  = $vista_previa->{'nivel1_template'};
      $t_params->{'cantItemN1'}       = $vista_previa->{'cantItemN1'};
      $t_params->{'nivel2'}           = $vista_previa->{'nivel2'};
    
      
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

 }

elsif($tipoAccion eq "BUSQUEDA"){
#Lista de Importaciones por defecto
    my ($template, $session, $t_params)= get_template_and_user({
                                    template_name => "/herramientas/importacion/lista_importaciones.tmpl",
                                    query => $input,
                                    type => "intranet",
                                    authnotrequired => 0,
                                    flagsrequired => {  ui => 'ANY',
                                                        tipo_documento => 'ANY',
                                                        accion => 'CONSULTA',
                                                        tipo_permiso => 'catalogo',
                                                        entorno => 'undefined'},
                                    debug => 1,
            });

  my $orden     = $obj->{'orden'}||'fecha_upload';
  my $funcion   = $obj->{'funcion'};
  my $inicial   = $obj->{'inicial'};
  my $busqueda  = $obj->{'nombre_importacion'};
  my $ini       = $obj->{'ini'} || 1;

  my ($ini,$pageNumber,$cantR) = C4::AR::Utilidades::InitPaginador($ini);
  my ($cantidad,$importaciones) = C4::AR::ImportacionIsoMARC::getImportacionLike($busqueda,$orden,$ini,$cantR,$inicial);

      $t_params->{'paginador'} = C4::AR::Utilidades::crearPaginador($cantidad,$cantR, $pageNumber,$funcion,$t_params);
      $t_params->{'resultsloop'}        = $importaciones;
      $t_params->{'cantidad'}           = $cantidad;
      $t_params->{'importacion_busqueda'} = $busqueda;


C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);


}
elsif($tipoAccion eq "GENERAR_ARREGLO_CAMPOS_ESQUEMA_ORIGEN"){
        my ($user, $session, $flags)= checkauth(    $input,
                                                  $authnotrequired,
                                                  {   ui => 'ANY',
                                                      tipo_documento => 'ANY',
                                                      accion => 'CONSULTA',
                                                      entorno => 'datos_nivel1'},
                                                  'intranet'
                                      );

      my $campoX            = $obj->{'campoX'};
      my $id_esquema        = $obj->{'id_esquema'};
      my ($campos_array)    = C4::AR::ImportacionIsoMARC::getCamposXFromEsquemaOrigenLike($id_esquema,$campoX);
      my $info              = C4::AR::Utilidades::arrayObjectsToJSONString($campos_array);
      my $infoOperacionJSON = $info;

      C4::AR::Auth::print_header($session);
      print $infoOperacionJSON;
    }

    elsif($tipoAccion eq "GENERAR_ARREGLO_SUBCAMPOS_ESQUEMA_ORIGEN"){
        my ($user, $session, $flags)= checkauth(    $input,
                                                  $authnotrequired,
                                                  {   ui => 'ANY',
                                                      tipo_documento => 'ANY',
                                                      accion => 'CONSULTA',
                                                      entorno => 'datos_nivel1'},
                                                  'intranet'
                                      );
      my $campo             = $obj->{'campo'};
      my $id_esquema        = $obj->{'id_esquema'};

      my ($campos_array)    = C4::AR::ImportacionIsoMARC::getSubCamposFromEsquemaOrigenLike($id_esquema,$campo);

      my $info              = C4::AR::Utilidades::arrayObjectsToJSONString($campos_array);

      my $infoOperacionJSON = $info;

      C4::AR::Auth::print_header($session);
      print $infoOperacionJSON;
    }
    elsif($tipoAccion eq "RELACION_REGISTRO_EJEMPLARES"){
        my ($user, $session, $flags)= checkauth(    $input,
                                                  $authnotrequired,
                                                  {   ui => 'ANY',
                                                      tipo_documento => 'ANY',
                                                      accion => 'CONSULTA',
                                                      entorno => 'datos_nivel1'},
                                                  'intranet'
                                      );

      my $Message_arrayref = C4::AR::ImportacionIsoMARC::procesarRelacionRegistroEjemplares($obj);
      my $infoOperacionJSON   = to_json $Message_arrayref;

      C4::AR::Auth::print_header($session);
      print $infoOperacionJSON;
    }
    elsif($tipoAccion eq "REGLAS_MATCHEO"){
        my ($user, $session, $flags)= checkauth(    $input,
                                                  $authnotrequired,
                                                  {   ui => 'ANY',
                                                      tipo_documento => 'ANY',
                                                      accion => 'CONSULTA',
                                                      entorno => 'datos_nivel1'},
                                                  'intranet'
                                      );
      my $Message_arrayref = C4::AR::ImportacionIsoMARC::procesarReglasMatcheo($obj);
      my $infoOperacionJSON   = to_json $Message_arrayref;

      C4::AR::Auth::print_header($session);
      print $infoOperacionJSON;
    }
        elsif($tipoAccion eq "CAMBIAR_ESTADO_REGISTRO"){
        my ($user, $session, $flags)= checkauth(    $input,
                                                  $authnotrequired,
                                                  {   ui => 'ANY',
                                                      tipo_documento => 'ANY',
                                                      accion => 'CONSULTA',
                                                      entorno => 'datos_nivel1'},
                                                  'intranet'
                                      );

      my $id   = $obj->{'id'};
      my ($registro_importacion) = C4::AR::ImportacionIsoMARC::getRegistroFromImportacionById($id);
      $registro_importacion->setEstado($obj->{'estado'});
      $registro_importacion->save;
      my $Message_arrayref = C4::AR::Mensajes::create();
      my $infoOperacionJSON   = to_json $Message_arrayref;

      C4::AR::Auth::print_header($session);
      print $infoOperacionJSON;
    }
        elsif($tipoAccion eq "QUITAR_MATCHEO_REGISTRO"){
        my ($user, $session, $flags)= checkauth(    $input,
                                                  $authnotrequired,
                                                  {   ui => 'ANY',
                                                      tipo_documento => 'ANY',
                                                      accion => 'CONSULTA',
                                                      entorno => 'datos_nivel1'},
                                                  'intranet'
                                      );

      my $id   = $obj->{'id'};
      my ($registro_importacion) = C4::AR::ImportacionIsoMARC::getRegistroFromImportacionById($id);
      $registro_importacion->setMatching(0);
      $registro_importacion->setIdMatching(0);
      $registro_importacion->save();
      my $Message_arrayref = C4::AR::Mensajes::create();
      my $infoOperacionJSON   = to_json $Message_arrayref;

      C4::AR::Auth::print_header($session);
      print $infoOperacionJSON;
    }
  elsif($tipoAccion eq "COMENZAR_IMPORTACION"){
        my ($user, $session, $flags)= checkauth(    $input,
                                                  $authnotrequired,
                                                  {   ui => 'ANY',
                                                      tipo_documento => 'ANY',
                                                      accion => 'CONSULTA',
                                                      entorno => 'datos_nivel1'},
                                                  'intranet'
                                      );

      my $id   = $obj->{'id'};


      C4::AR::Debug::debug("IMPORTAR ".$id);
      C4::AR::ImportacionIsoMARC::procesarImportacion($id);

      my $Message_arrayref = C4::AR::Mensajes::create();
      my $infoOperacionJSON   = to_json $Message_arrayref;

      C4::AR::Auth::print_header($session);
      print $infoOperacionJSON;
    }  
    elsif($tipoAccion eq "CANCELAR_IMPORTACION"){
        my ($user, $session, $flags)= checkauth(    $input,
                                                  $authnotrequired,
                                                  {   ui => 'ANY',
                                                      tipo_documento => 'ANY',
                                                      accion => 'CONSULTA',
                                                      entorno => 'datos_nivel1'},
                                                  'intranet'
                                      );

      my $id       = $obj->{'id'};
      my $jobID    = $obj->{'jobID'};

      C4::AR::Debug::debug("CANCELAR IMPORTACION ".$id);
      my $msg_object        =C4::AR::ImportacionIsoMARC::cancelarImportacion($id,$jobID);

      my $infoOperacionJSON = to_json $msg_object;

      C4::AR::Auth::print_header($session);
      print $infoOperacionJSON;
    }