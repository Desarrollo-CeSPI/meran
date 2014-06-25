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

use C4::AR::UploadFile;
use C4::AR::Usuarios;
use JSON;
use CGI;

my $input = new CGI;
my $authnotrequired= 0;
my $editing = $input->param('edit');
my $elemEdit=  $input->param('id') || "";

if ($editing){


        
        if ($elemEdit eq 'nota'){
           
          my %params = {};

          my $value = $input->param('value');

          my ($template, $session, $t_params)  = get_template_and_user({  
                              template_name => "includes/partials/modificar_value.tmpl",
                              query => $input,
                              type => "intranet",
                              authnotrequired => 0,
                              flagsrequired => {  ui => 'ANY', 
                                                  tipo_documento => 'ANY', 
                                                  accion => 'MODIFICACION', 
                                                  entorno => 'usuarios', 
                                                  },
                              debug => 1,
                          });
          $params{'nro_socio'} = $input->param('nro_socio');
          $params{'value'} = $value;
#           C4::AR::Validator::validateParams('U389',\%params,['nro_socio'] );

          C4::AR::Debug::debug($value);

          my ($value)= C4::AR::Usuarios::editarNote(\%params);


          $t_params->{'value'} = $value;
        
          C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);


        } else {

              # if(($editing) && ($elemEdit ne 'nota')) {
                  my ($template, $session, $t_params)  = get_template_and_user({  
                                      template_name => "includes/partials/modificar_value.tmpl",
                                      query => $input,
                                      type => "intranet",
                                      authnotrequired => 0,
                                      flagsrequired => {  ui => 'ANY', 
                                                          tipo_documento => 'ANY', 
                                                          accion => 'CONSULTA', 
                                                          entorno => 'permisos',  
                                                          tipo_permiso => 'general'},
                                      debug => 1,
                                  });
                  my %params = {};

                  $params{'action'} = $input->param('action');
                  $params{'edit'} = $input->param('edit');
                  $params{'id'} = $input->param('id');
                  $params{'nro_socio'} = $input->param('nro_socio');
                  $params{'value'} = $input->param('value');
                  C4::AR::Validator::validateParams('U389',\%params,['nro_socio'] );

                  my ($value)= C4::AR::Usuarios::editarAutorizado(\%params);

                  $t_params->{'value'} = $value;
                  C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

        }
} else {

        my $obj=$input->param('obj');
        $obj=C4::AR::Utilidades::from_json_ISO($obj);

        my $tipoAccion= $obj->{'tipoAccion'}||"";

        my $nro_socio = $obj->{'nro_socio'};
# 
#     =item
#         Aca se maneja el resteo de password del usuario
#     =cut
        ## TODO tambien se podria hacer que el sistema genere la pass y se la envie por correo al socio, esto deberia ser una preferencia 
        ## resetPassword = [0 | 1]
        ## autoGeneratePassword = [0 | 1]
        if($tipoAccion eq "RESET_PASSWORD"){
            my ($userid, $session, $flags) = checkauth( $input, 
                                                $authnotrequired,
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'MODIFICACION', 
                                                    entorno => 'usuarios'},
                                                "intranet"
                                    );

            my %params;
            $params{'nro_socio'}= $obj->{'nro_socio'};

            C4::AR::Validator::validateParams('U389',$obj,['nro_socio'] );

            my ($Message_arrayref)= C4::AR::Usuarios::resetPassword(\%params);
            my $infoOperacionJSON=to_json $Message_arrayref;

            C4::AR::Auth::print_header($session);
            print $infoOperacionJSON;

        } #end if($tipoAccion eq "RESET_PASSWORD")

        elsif($tipoAccion eq "CAMBIAR_NRO_SOCIO"){
            my ($userid, $session, $flags) = checkauth( $input, 
                                                $authnotrequired,
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'MODIFICACION', 
                                                    entorno => 'usuarios'},
                                                "intranet"
                                    );

            C4::AR::Validator::validateParams('U389',$obj,['nro_socio'] );

            my ($Message_arrayref)= C4::AR::Usuarios::cambiarNroSocio($obj);
            my $infoOperacionJSON=to_json $Message_arrayref;

            C4::AR::Auth::print_header($session);
            print $infoOperacionJSON;

        }

        elsif($tipoAccion eq "AGREGAR_AUTORIZADO"){
            my ($userid, $session, $flags) = checkauth( $input, 
                                                $authnotrequired,
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'MODIFICACION', 
                                                    entorno => 'usuarios'},
                                                "intranet"
                                    );

            C4::AR::Validator::validateParams('U389',$obj,['nro_socio'] );

            my ($Message_arrayref)= C4::AR::Usuarios::agregarAutorizado($obj);
            my $infoOperacionJSON=to_json $Message_arrayref;

            C4::AR::Auth::print_header($session);
            print $infoOperacionJSON;

        }

        elsif($tipoAccion eq "VALIDAR_DATOS_CENSALES"){
            my ($userid, $session, $flags) = checkauth( $input, 
                                                $authnotrequired,
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'MODIFICACION', 
                                                    entorno => 'usuarios'},
                                                "intranet"
                                    );

            C4::AR::Validator::validateParams('U389',$obj,['nro_socio'] );

            my ($Message_arrayref)= C4::AR::Usuarios::updateUserDataValidation($obj->{'nro_socio'},"intranet");
            my $infoOperacionJSON=to_json $Message_arrayref;

            C4::AR::Auth::print_header($session);
            print $infoOperacionJSON;

        }

        elsif($tipoAccion eq "MOSTRAR_VENTANA_AGREGAR_AUTORIZADO"){
            my $flagsrequired;
            $flagsrequired->{permissions}=1;

            my ($template, $session, $t_params) = get_template_and_user({
                                            template_name => "includes/popups/agregarAutorizado.inc",
                                            query => $input,
                                            type => "intranet",
                                            authnotrequired => 0,
                                            flagsrequired => {  ui => 'ANY', 
                                                                tipo_documento => 'ANY', 
                                                                accion => 'CONSULTA', 
                                                                entorno => 'usuarios'},
                                            debug => 1,
                        });

            C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

        } 

        elsif($tipoAccion eq "ELIMINAR_AUTORIZADO"){
            my ($userid, $session, $flags) = checkauth( $input, 
                                                $authnotrequired,
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'BAJA', 
                                                    entorno => 'usuarios'},
                                                "intranet"
                                    );

            my %params;
            $params{'nro_socio'}= $obj->{'nro_socio'};

            C4::AR::Validator::validateParams('U389',$obj,['nro_socio'] );

            my ($Message_arrayref)= C4::AR::Usuarios::desautorizarTercero(\%params);
            my $infoOperacionJSON=to_json $Message_arrayref;

            C4::AR::Auth::print_header($session);
            print $infoOperacionJSON;

        } 

=item
Se elimina el usuario
=cut
        elsif($tipoAccion eq "ELIMINAR_USUARIO"){
            my ($userid, $session, $flags) = checkauth( $input, 
                                                $authnotrequired,
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'BAJA', 
                                                    entorno => 'usuarios'},
                                                    "intranet"
                                    );

            my %params;
            my $nro_socio= $obj->{'nro_socio'};

            C4::AR::Validator::validateParams('U389',$obj,['nro_socio'] );

            my ($Message_arrayref)= C4::AR::Usuarios::eliminarUsuario($nro_socio);
            my $infoOperacionJSON=to_json $Message_arrayref;

            C4::AR::Auth::print_header($session);
            print $infoOperacionJSON;

        } #end if($tipoAccion eq "ELIMINAR_USUARIO")

# 
#     =item
#     Se agrega el usuario
#     =cut
        elsif($tipoAccion eq "AGREGAR_USUARIO"){
            my ($user, $session, $flags) = checkauth( $input, 
                                                $authnotrequired,
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'ALTA', 
                                                    entorno => 'usuarios'},
                                                "intranet"
                                    );

            
            my $Message_arrayref=C4::AR::Usuarios::agregarPersona($obj);
            my $infoOperacionJSON=to_json $Message_arrayref;

            C4::AR::Auth::print_header($session);
            print $infoOperacionJSON;

        } #end if($tipoAccion eq "AGREGAR_USUARIO")

# 
#     =item
#     Se guarda la modificacion los datos del usuario
#     =cut
        elsif($tipoAccion eq "GUARDAR_MODIFICACION_USUARIO"){
            my ($user, $session, $flags) = checkauth( 
                                                                    $input, 
                                                                    $authnotrequired,
                                                                    {   ui => 'ANY', 
                                                                        tipo_documento => 'ANY', 
                                                                        accion => 'MODIFICACION', 
                                                                        entorno => 'usuarios'},
                                                                    "intranet"
                                    );	

            #C4::AR::Validator::validateParams('U389',$obj,['nro_socio','nombre','nacimiento','ciudad','apellido','id_ui','sexo'] );

            my ($Message_arrayref)= C4::AR::Usuarios::actualizarSocio($obj);
            my $infoOperacionJSON=to_json $Message_arrayref;

            C4::AR::Auth::print_header($session);
            print $infoOperacionJSON;

        } #end if($tipoAccion eq "GUARDAR_MODIFICACION_USUARIO")


#     =item
#     Se genra la ventana para modificar los datos del usuario
#     =cut
        elsif($tipoAccion eq "MODIFICAR_USUARIO"){

            my ($template, $session, $t_params, $socio) = get_template_and_user({
                                            template_name   => "usuarios/reales/agregarUsuario.tmpl",
                                            query           => $input,
                                            type            => "intranet",
                                            authnotrequired => 0,
                                            flagsrequired   => {    ui => 'ANY', 
                                                                    tipo_documento => 'ANY', 
                                                                    accion => 'MODIFICACION', 
                                                                    entorno => 'usuarios'},
                                            debug           => 1,
            });

            my $msg_object  = C4::AR::Mensajes::create();

            $t_params->{'nro_socio'}        = $nro_socio;
            C4::AR::Validator::validateParams('U389',$obj,['nro_socio'] );
            #Obtenemos los datos del borrower
            my $socio                       = &C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);
            #SI NO EXISTE EL SOCIO IMPRIME 0, PARA INFORMAR AL CLIENTE QUE ACCION REALIZAR
            C4::AR::Validator::validateObjectInstance($socio);
            my %params;
            $params{'default'}              = $socio->getId_categoria;
            #se genera el combo de categorias de usuario
            my $comboDeCategorias           = C4::AR::Utilidades::generarComboCategoriasDeSocio(\%params);

            $params{'default'}              = $socio->persona->documento->getId;
            #se genera el combo de tipos de documento
            my $comboDeTipoDeDoc            = C4::AR::Utilidades::generarComboTipoDeDocConValuesIds(\%params);
            
            eval{
                $params{'default'}              = $socio->ui->getId_ui();
            };
            if ($@){
                C4::AR::Debug::debug("\nERROR AL OBTENER UNIDAD DE INFORMACION "+ $socio->getId_ui()+" DEL USUARIO "+ $socio->getNro_socio);
            }

            #se genera el combo de las bibliotecas
            my $comboDeUI                   = C4::AR::Utilidades::generarComboUI(\%params);
            
            $params{'default'}              = $socio->getId_estado;
            my $comboDeEstados              = C4::AR::Utilidades::generarComboDeEstados(\%params);


            $t_params->{'socio_modificar'}  = $socio;
            my $comboDeCredentials          = C4::AR::Utilidades::generarComboDeCredentials($t_params); #llama a getSocioInfoPorNroSocio
            
            $t_params->{'comboDeCredentials'}   = $comboDeCredentials;
            $t_params->{'combo_tipo_documento'} = $comboDeTipoDeDoc;
            $t_params->{'comboDeEstados'}       = $comboDeEstados;
            $t_params->{'comboDeCategorias'}    = $comboDeCategorias;
            $t_params->{'comboDeUI'}            = $comboDeUI;
            $t_params->{'addBorrower'}          = 0;
            $t_params->{'cumple_requisito_on'}  = C4::AR::Preferencias::getValorPreferencia("requisito_necesario")||0;
            
            if ($socio->getNro_socio eq C4::AR::Auth::getSessionNroSocio() ){
                C4::AR::Auth::updateLoggedUserTemplateParams($session,$t_params,$socio);
            }
            
            C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
        } #end if($tipoAccion eq "MODIFICAR_USUARIO")

        elsif($tipoAccion eq "ELIMINAR_FOTO"){
            my ($user, $session, $flags) = checkauth( 
                                                                    $input, 
                                                                    $authnotrequired,
                                                                    {   ui => 'ANY', 
                                                                        tipo_documento => 'ANY', 
                                                                        accion => 'MODIFICACION', 
                                                                        entorno => 'usuarios'},
                                                                    "intranet"
                                    );  

            my $foto_name           = $obj->{'foto_name'};

            C4::AR::Validator::validateParams('U389',$obj,['foto_name'] );

            my ($Message_arrayref)  = &C4::AR::UploadFile::deletePhoto($foto_name);
            my $infoOperacionJSON   = to_json $Message_arrayref;

            my $socio                       = &C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);

            if ($socio->getNro_socio eq C4::AR::Auth::getSessionNroSocio() ){
                C4::AR::Auth::updateLoggedUserTemplateParams($session,$obj,$socio);
            }
            
            C4::AR::Auth::print_header($session);
            print $infoOperacionJSON;
        }


        elsif($tipoAccion eq "PRESTAMO_INTER_BIBLIO"){

            my ($template, $session, $t_params) = get_template_and_user({
                                            template_name => "usuarios/reales/printPrestInterBiblio.tmpl",
                                            query => $input,
                                            type => "intranet",
                                            authnotrequired => 0,
                                            flagsrequired => {  ui => 'ANY', 
                                                                tipo_documento => 'ANY', 
                                                                accion => 'CONSULTA', 
                                                                entorno => 'usuarios'},
                                            debug => 1,
            });
            C4::AR::Validator::validateParams('U389',$obj,['nro_socio'] );


            my $socio= C4::AR::Usuarios::getSocioInfoPorNroSocio($obj->{'nro_socio'});

            #SI NO EXISTE EL SOCIO IMPRIME 0, PARA INFORMAR AL CLIENTE QUE ACCION REALIZAR
            C4::AR::Validator::validateObjectInstance($socio);

            my $comboDeUI= &C4::AR::Utilidades::generarComboUI();

            $t_params->{'comboDeUI'}= $comboDeUI;
            $t_params->{'nro_socio'}= $socio->getNro_socio;
            $t_params->{'id_socio'}= $obj->{'id_socio'};

            C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

        }
        elsif($tipoAccion eq "GENERAR_LIBRE_DEUDA"){

            my ($user, $session, $flags) = checkauth( 
                                                                    $input, 
                                                                    $authnotrequired,
                                                                    {   ui => 'ANY', 
                                                                        tipo_documento => 'ANY', 
                                                                        accion => 'CONSULTA', 
                                                                        entorno => 'usuarios'},
                                                                    "intranet"
                                    );  

            C4::AR::Validator::validateParams('U389',$obj,['nro_socio'] );


            my $socio= C4::AR::Usuarios::getSocioInfoPorNroSocio($obj->{'nro_socio'});

            #SI NO EXISTE EL SOCIO IMPRIME 0, PARA INFORMAR AL CLIENTE QUE ACCION REALIZAR
            C4::AR::Validator::validateObjectInstance($socio);

            my $msg_object = C4::AR::Usuarios::_verificarLibreDeuda($obj->{'nro_socio'});

            if (!($msg_object->{'error'})){
                # Se puede generar el Libre Deuda
                my $socio= C4::AR::Usuarios::getSocioInfoPorNroSocio($obj->{'nro_socio'});
                my $url = C4::AR::Utilidades::getUrlPrefix().'/usuarios/libreDeuda.pl?nro_socio='.$obj->{'nro_socio'}.'&token='.$session->param('token');
                my $boton ="<a href='".$url."'>Imprimir</a>";
                C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U423', 'params' => [Encode::decode_utf8($socio->persona->getApeYNom),$boton]} ) ;
            }

                my $infoOperacionJSON=to_json $msg_object;
                C4::AR::Auth::print_header($session);
                print $infoOperacionJSON;

        }
        elsif($tipoAccion eq "CAMBIAR_CREDENCIAL"){

            my ($template, $session, $t_params, $socio) = get_template_and_user({
                                            template_name   => "usuarios/reales/modificarCredenciales.tmpl",
                                            query           => $input,
                                            type            => "intranet",
                                            authnotrequired => 0,
                                            flagsrequired   => {    ui              => 'ANY', 
                                                                    tipo_documento  => 'ANY', 
                                                                    accion          => 'MODIFICACION', 
                                                                    entorno         => 'usuarios',
                                                                    tipo_permiso    => 'catalogo'},
                                            debug           => 1,
            });

            $t_params->{'nro_socio'}            = $nro_socio;
            C4::AR::Validator::validateParams('U389',$obj,['nro_socio'] );
            #Obtenemos los datos del borrower
            my $socio                           = C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);
            #SI NO EXISTE EL SOCIO IMPRIME 0, PARA INFORMAR AL CLIENTE QUE ACCION REALIZAR
            C4::AR::Validator::validateObjectInstance($socio);

            #se genera el combo de credenciales de usuario
            $t_params->{'default'}              = $socio->getCredentialType();
            my $comboDeCredenciales             = C4::AR::Utilidades::generarComboDeCredentials($t_params);
            $t_params->{'comboDeCredenciales'}  = $comboDeCredenciales;


            C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
        }
        elsif($tipoAccion eq "GUARDAR_MODIFICACION_CREDENCIALES"){

            my ($template, $session, $t_params, $socio) = get_template_and_user({
                                            template_name   => "usuarios/reales/modificarCredenciales.tmpl",
                                            query           => $input,
                                            type            => "intranet",
                                            authnotrequired => 0,
                                            flagsrequired   => {    ui              => 'ANY', 
                                                                    tipo_documento  => 'ANY', 
                                                                    accion          => 'MODIFICACION', 
                                                                    entorno         => 'usuarios',
                                                                    tipo_permiso    => 'catalogo'},
                                            debug           => 1,
            });

#            $obj->{'nro_socio'}
            my $Message_arrayref  = C4::AR::Usuarios::modificarCredencialesSocio($obj);
            my $infoOperacionJSON = to_json $Message_arrayref;

            C4::AR::Auth::print_header($session);
            print $infoOperacionJSON;
        } elsif($tipoAccion eq "SANCION_MANUAL"){

            my ($template, $session, $t_params, $socio) = get_template_and_user({
                                            template_name   => "usuarios/reales/sancionManual.tmpl",
                                            query           => $input,
                                            type            => "intranet",
                                            authnotrequired => 0,
                                            flagsrequired   => {    ui              => 'ANY', 
                                                                    tipo_documento  => 'ANY', 
                                                                    accion          => 'ALTA', 
                                                                    entorno         => 'circ_sanciones',
                                                                    tipo_permiso    => 'circulacion'},
                                            debug           => 1,
            });

            $t_params->{'nro_socio'}            = $nro_socio;
            C4::AR::Validator::validateParams('U389',$obj,['nro_socio'] );
            #Obtenemos los datos del borrower
            my $socio                           = C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);
            #SI NO EXISTE EL SOCIO IMPRIME 0, PARA INFORMAR AL CLIENTE QUE ACCION REALIZAR
            C4::AR::Validator::validateObjectInstance($socio);


            C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
        }
        elsif($tipoAccion eq "APLICAR_SANCION_MANUAL"){

            my ($template, $session, $t_params, $socio) = get_template_and_user({
                                            template_name   => "usuarios/reales/sancionManual.tmpl",
                                            query           => $input,
                                            type            => "intranet",
                                            authnotrequired => 0,
                                            flagsrequired   => {    ui              => 'ANY', 
                                                                    tipo_documento  => 'ANY', 
                                                                    accion          => 'ALTA', 
                                                                    entorno         => 'circ_sanciones',
                                                                    tipo_permiso    => 'circulacion'},
                                            debug           => 1,
            });

            $obj->{'responsable'}            = $socio->getNro_socio;
            my $Message_arrayref  = C4::AR::Sanciones::aplicarSancionManualSocio($obj);
            my $infoOperacionJSON = to_json $Message_arrayref;

            C4::AR::Auth::print_header($session);
            print $infoOperacionJSON;
        }
    }