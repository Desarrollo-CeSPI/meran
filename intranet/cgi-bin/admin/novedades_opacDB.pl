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
use C4::AR::Novedades;
my $input       = new CGI;
my $obj         = $input->param('obj') || 0;
$obj            = C4::AR::Utilidades::from_json_ISO($obj);
my $tipoAccion  = $obj->{'tipoAccion'}||"";
my $funcion     = $obj->{'funcion'}||"";
my $accion      = $tipoAccion;
my $ini         = $obj->{'ini'} || 1;
my $url         = C4::AR::Utilidades::getUrlPrefix()."/admin/novedades_opac.pl?token=".$obj->{'token'}."&tipoAccion=".$obj->{'tipoAccion'};

if ($accion eq 'ELIMINAR'){
    my ($template, $session, $t_params) = get_template_and_user({
                                        template_name       => "admin/novedades_opac_ajax.tmpl",
                                        query               => $input,
                                        type                => "intranet",
                                        authnotrequired     => 0,
                                        flagsrequired       => {  ui        => 'ANY', 
                                                            tipo_documento  => 'ANY', 
                                                            accion          => 'CONSULTA', 
                                                            entorno         => 'usuarios'},
                                        debug               => 1,
    });
    
    my $id_novedad = $obj->{'id'} || 0;
    
    C4::AR::Novedades::eliminar($id_novedad);
    
    my ($ini,$pageNumber,$cantR)    = C4::AR::Utilidades::InitPaginador($ini);
    my ($cant_novedades,$novedades) = C4::AR::Novedades::listar($ini,$cantR);

    $t_params->{'paginador'}        = C4::AR::Utilidades::crearPaginadorOPAC($cant_novedades,$cantR, $pageNumber,$url,$t_params);
    $t_params->{'novedades'}        = $novedades;
    $t_params->{'cant_novedades'}   = $cant_novedades;


    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
elsif ($accion eq 'LISTAR'){

    my ($template, $session, $t_params) = get_template_and_user({
                                        template_name       => "admin/novedades_opac_ajax.tmpl",
                                        query               => $input,
                                        type                => "intranet",
                                        authnotrequired     => 0,
                                        flagsrequired       => {  ui            => 'ANY', 
                                                            tipo_documento      => 'ANY', 
                                                            accion              => 'CONSULTA', 
                                                            entorno             => 'usuarios'},
                                        debug               => 1,
    });
    my ($ini,$pageNumber,$cantR)    = C4::AR::Utilidades::InitPaginador($ini);
    my ($cant_novedades,$novedades) = C4::AR::Novedades::listar($ini,$cantR);

    $t_params->{'paginador'}        = C4::AR::Utilidades::crearPaginador($cant_novedades,$cantR, $pageNumber,$funcion,$t_params);
    # $t_params->{'paginador'}        = C4::AR::Utilidades::crearPaginadorOPAC($cant_novedades,$cantR, $pageNumber,$url,$t_params);
    $t_params->{'novedades'}        = $novedades;
    $t_params->{'cant_novedades'}   = $cant_novedades;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}