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

# use strict;
use C4::AR::Auth;
use CGI;

my $input=new CGI;

my $token = $input->url_param('token');

my ($template, $session, $t_params) =  C4::AR::Auth::get_template_and_user ({
			                    template_name	=> 'usuarios/potenciales/datosUsuario.tmpl',
			                    query		=> $input,
			                    type		=> "intranet",
			                    authnotrequired	=> 0,
			                    flagsrequired	=> {    ui => 'ANY', 
                                                        tipo_documento => 'ANY', 
                                                        accion => 'CONSULTA', 
                                                        entorno => 'usuarios'},
                    });


# FIXME en el cliente, siempre queda PERSONA para que se entienda, pero aca no es más que un socio DESHABILITADO
my $nro_socio= $input->param('nro_socio');
my $mensaje=$input->param('mensaje');#Mensaje que viene desde libreDeuda si es que no se puede imprimir

$t_params->{'nro_socio'}= $nro_socio;

C4::AR::Validator::validateParams('U389',$t_params,['nro_socio'] );

my $socio=C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio) || C4::AR::Utilidades::redirectAndAdvice('U353');

$t_params->{'socio'}= $socio;


if (!$socio->getActivo()){
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}else{
    C4::AR::Auth::redirectTo(C4::AR::Utilidades::getUrlPrefix()."/usuarios/reales/datosUsuario.pl?nro_socio=".$socio->getNro_socio."&token=".$token);
}