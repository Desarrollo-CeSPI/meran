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
require Exporter;
use CGI;
use C4::AR::Auth;
use C4::Date;
use C4::Context;

my $query = new CGI;

my $input = $query;

my ($template, $session, $t_params) = get_template_and_user({
                                    template_name   => "opac-main.tmpl",
                                    query           => $query,
                                    type            => "opac",
                                    authnotrequired => 1,
                                    flagsrequired   => {ui              => 'ANY', 
                                                        tipo_documento  => 'ANY', 
                                                        accion          => 'CONSULTA', 
                                                        entorno         => 'undefined'},
             });


my $nro_socio                       = C4::AR::Auth::getSessionNroSocio();
my ($socio, $flags)                 = C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);

C4::AR::Validator::validateObjectInstance($socio);

my %data_hash;
my $msg_object                      = C4::AR::Mensajes::create();
$data_hash{'nombre'}                = $input->param('nombre');
$data_hash{'apellido'}              = $input->param('apellido');
$data_hash{'direccion'}             = $input->param('direccion');
$data_hash{'numero_telefono'}       = $input->param('telefono');
$data_hash{'id_ciudad'}             = $input->param('id_ciudad');
$data_hash{'email'}                 = $input->param('email');

my $fields_to_check = ['nombre','apellido','direccion','numero_telefono','id_ciudad','email'];

if (C4::AR::Validator::checkParams('VA002',\%data_hash,$fields_to_check)){
        eval {
            # Seteamos fecha de actualización
            my ($Message_arrayref) = C4::AR::Usuarios::updateUserDataValidation($nro_socio,'opac');
            
            # Cargamos el uaurio actualizado
            $socio->load();
            if(C4::AR::Mensajes::hayError($Message_arrayref)){
                $t_params->{'mensaje'}          = C4::AR::Mensajes::getMensaje(C4::AR::Mensajes::getFirstCodeError($Message_arrayref),'opac');
                $t_params->{'mensaje_class'} = "alert-error";
                $t_params->{'partial_template'} = "opac-modificar_datos_censales.inc";
            }
            else{
                # Actualizamos datos
                $socio->persona->modificarDatosDeOPAC(\%data_hash);
                $socio->save();

                # Marcamos en la session 
                $session->param('modificar_datos_censales', 0);

                $t_params->{'mensaje'}          = C4::AR::Mensajes::getMensaje('U338','opac');
                $t_params->{'mensaje_class'} = "alert-success";
                $t_params->{'foto_name'}        = $socio->tieneFoto();
                $t_params->{'partial_template'} = "opac-mis_datos.inc";
            }
        };
        
        if (@$){
            $t_params->{'mensaje'}          = C4::AR::Mensajes::getMensaje('U339','opac');
            $t_params->{'mensaje_class'} = "alert-error";
            $t_params->{'partial_template'} = "opac-modificar_datos_censales.inc";
        }


    
}else{
    $t_params->{'mensaje_class'}    = "alert-error";
    $t_params->{'mensaje'}          = C4::AR::Mensajes::getMensaje('VA002','opac');
    $t_params->{'partial_template'} = "opac-modificar_datos_censales.inc";
}

$t_params->{'socio'}= $socio;
$t_params->{'opac'} = 1;

C4::AR::Auth::updateLoggedUserTemplateParams($session,$t_params,$socio);
C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);