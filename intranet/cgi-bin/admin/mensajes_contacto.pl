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
use CGI;
use C4::AR::MensajesContacto;
my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user({
									template_name   => "admin/mensajes_contacto.tmpl",
									query           => $input,
									type            => "intranet",
									authnotrequired => 0,
									flagsrequired   => {  ui => 'ANY', 
                                                        accion => 'TODOS', 
                                                        entorno => 'usuarios'},
									debug => 1,
			    });


my %hash_temp   = {};
my $obj         = \%hash_temp;
my $accion      = $obj->{'tipoAccion'} = $input->param('tipoAccion');
my $ini         = $obj->{'ini'} = $input->param('page') || 0;
my $id_mensaje  = $input->param('id') || 0;
my $url         = C4::AR::Utilidades::getUrlPrefix()."/admin/mensajes_contacto.pl?token=".$input->param('token')."&tipoAccion=".$obj->{'tipoAccion'};

if ($accion eq 'eliminar'){
    C4::AR::MensajesContacto::eliminar($id_mensaje);
	$t_params->{'mensaje'}        = C4::AR::Mensajes::getMensaje('U982','INTRA');
	$t_params->{'mensaje_class'}  = "alert-info";

}

my ($ini,$pageNumber,$cantR)            = C4::AR::Utilidades::InitPaginador($ini);
my ($cant_mensajes,$mensajes_contacto)  = C4::AR::MensajesContacto::listar(0,$ini,$cantR);

$t_params->{'paginador'}                = C4::AR::Utilidades::crearPaginadorOPAC($cant_mensajes,$cantR, $pageNumber,$url,$t_params);
$t_params->{'mensajes_contacto'}        = $mensajes_contacto;
$t_params->{'cant_mensajes'}            = $cant_mensajes;

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);