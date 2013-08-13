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

$data_hash{'auth_nombre'}           = $input->param('nombre_autorizado');
$data_hash{'auth_dni'}              = $input->param('dni_autorizado');
$data_hash{'auth_telefono'}         = $input->param('telefono_autorizado');
$data_hash{'eliminar_autorizado'}   = $input->param('eliminar_autorizado');

$data_hash{'actual_password'}       = $input->param('actual_password');
$data_hash{'new_password1'}         = $input->param('new_password1');
$data_hash{'new_password2'}         = $input->param('new_password2');
$data_hash{'key'}                   = $input->param('key');

if($input->param('remindFlag') eq "on"){
    $data_hash{'remindFlag'}        = 1;
}else{
    $data_hash{'remindFlag'}        = 0;
}


my $fields_to_check;

my $update_password = C4::AR::Utilidades::validateString($data_hash{'actual_password'});

if ($update_password){
    $fields_to_check = ['nombre','apellido','direccion','numero_telefono','id_ciudad','email', 'actual_password','new_password1','new_password2'];
}

if ($data_hash{'eliminar_autorizado'}){
     $socio->desautorizarTercero();
}

if (C4::AR::Validator::checkParams('VA002',\%data_hash,$fields_to_check)){
	my $cod_msg = undef;
	
    if ($update_password){
        $data_hash{'nro_socio'} = $socio->getNro_socio;
        $msg_object = C4::AR::Auth::cambiarPassword(\%data_hash);
        $cod_msg    = C4::AR::Mensajes::getFirstCodeError($msg_object);
    }

    if (!$msg_object->{'error'}){
    	eval {
    	    #recargamos el objeto socio para que no pise la password nueva
    	    $socio->load();
	        $socio->persona->modificarVisibilidadOPAC(\%data_hash);
	        $socio->remindFlag($data_hash{'remindFlag'});
	        $socio->save();
            $cod_msg = 'U338';
            $t_params->{'mensaje_class'} = "alert-success";
    	};
    	
    	if (@$){
    		$cod_msg = 'U339';
            $t_params->{'mensaje_class'} = "alert-error";
    	}
    }

    C4::AR::Mensajes::add($msg_object, {'codMsg'=> $cod_msg, 'params' => []} ) ;
    $t_params->{'mensaje'} = C4::AR::Mensajes::getMensaje($cod_msg);
    
    if ($data_hash{'tema'}){
        #recargamos el objeto socio para que no pise la password nueva
        $socio->load();
        $socio->setThemeSave($data_hash{'tema'});
        $socio->save();
    }

    $t_params->{'foto_name'}        = $socio->tieneFoto();
    $t_params->{'partial_template'} = "opac-mis_datos.inc";
    
}else{
    $t_params->{'mensaje_class'}    = "alert-error";
    $t_params->{'mensaje'}          = C4::AR::Mensajes::getMensaje('VA002','opac');
    $t_params->{'partial_template'} = "opac-modificar_datos.inc";
}

$t_params->{'socio'}= $socio;
$t_params->{'opac'} = 1;

if ($update_password && (!$msg_object->{'error'})){
    #si cambio la pass, destruimos la sesion obligando un nuevo logueo
    C4::AR::Auth::redirectTo(C4::AR::Utilidades::getUrlPrefix().'/sessionDestroy.pl');
}

C4::AR::Auth::updateLoggedUserTemplateParams($session,$t_params,$socio);
C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);