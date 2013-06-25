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
use C4::AR::Logos;

my $input       = new CGI;
my $obj         = $input->param('obj') || 0;
$obj            = C4::AR::Utilidades::from_json_ISO($obj);
my $tipoAccion  = $obj->{'tipoAccion'}||"";
my $ini         = $obj->{'ini'} = $input->param('page') || 0;
my $url         = C4::AR::Utilidades::getUrlPrefix()."/admin/logos.pl?token=".$obj->{'token'}."&tipoAccion=".$obj->{'tipoAccion'};


if ($tipoAccion eq 'LISTAR'){

    my ($template, $session, $t_params) = get_template_and_user({
                                        template_name       => "admin/logos_ajax.tmpl",
                                        query               => $input,
                                        type                => "intranet",
                                        authnotrequired     => 0,
                                        flagsrequired       => {  ui            => 'ANY', 
                                                            tipo_documento      => 'ANY', 
                                                            accion              => 'CONSULTA', 
                                                            entorno             => 'usuarios'},
                                        debug               => 1,
    });
    
    my ($cant_logos,$logos)         = C4::AR::Logos::listar();

    $t_params->{'logos'}            = $logos;
    $t_params->{'cant_logos'}       = $cant_logos;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
    
}elsif($tipoAccion eq 'LISTAR_UI'){

    my ($template, $session, $t_params) = get_template_and_user({
                                        template_name       => "admin/logos_ajax_ui.tmpl",
                                        query               => $input,
                                        type                => "intranet",
                                        authnotrequired     => 0,
                                        flagsrequired       => {  ui            => 'ANY', 
                                                            tipo_documento      => 'ANY', 
                                                            accion              => 'CONSULTA', 
                                                            entorno             => 'usuarios'},
                                        debug               => 1,
    });
    
    my ($cant_logos,$logos)         = C4::AR::Logos::listarUI();

    $t_params->{'logos'}            = $logos;
    $t_params->{'cant_logos'}       = $cant_logos;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

}elsif($tipoAccion eq 'SHOW_MOD_LOGO_UI'){

    my $logo    = C4::AR::Logos::getLogoById($obj->{'idLogo'});      
    my $editing = 1;

    my ($template, $session, $t_params) = get_template_and_user({
                                        template_name   => "includes/formAgregarLogoUI.inc",
                                        query           => $input,
                                        type            => "intranet",
                                        authnotrequired => 0,
                                        flagsrequired   => {  ui    => 'ANY', 
                                                            accion  => 'TODOS', 
                                                            entorno => 'usuarios'},
                                        debug           => 1,
                    });
    
    $t_params->{'editing'}  = $editing;
    $t_params->{'logo'}     = $logo;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

}elsif($tipoAccion eq 'SHOW_MOD_LOGO'){

    my $logo    = C4::AR::Logos::getLogoById($obj->{'idLogo'});      
    my $editing = 1;

	my ($template, $session, $t_params) = get_template_and_user({
	                                    template_name   => "includes/formAgregarLogo.inc",
	                                    query           => $input,
	                                    type            => "intranet",
	                                    authnotrequired => 0,
	                                    flagsrequired   => {  ui    => 'ANY', 
	                                                        accion  => 'TODOS', 
	                                                        entorno => 'usuarios'},
	                                    debug           => 1,
	                });
	
	$t_params->{'editing'}  = $editing;
    $t_params->{'logo'}     = $logo;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

}elsif ($tipoAccion eq 'DEL_LOGO'){

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
    
    my $msg_object                  = C4::AR::Logos::eliminarLogo($obj);
    my $codMsg                      = C4::AR::Mensajes::getFirstCodeError($msg_object); 
    $t_params->{'mensaje'}          = C4::AR::Mensajes::getMensaje($codMsg,'INTRA');
    
    if (C4::AR::Mensajes::hayError($msg_object)){
        $t_params->{'mensaje_class'} = "alert-error";
    }else{
        $t_params->{'mensaje_class'} = "alert-success";
    }
    
    my ($cant_logos,$logos)         = C4::AR::Logos::listar();

    $t_params->{'logos'}            = $logos;
    $t_params->{'cant_logos'}       = $cant_logos;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

}elsif ($tipoAccion eq 'DEL_LOGO_UI'){

    my ($template, $session, $t_params) = get_template_and_user({
                                        template_name       => "admin/novedades_opac_ajax_ui.tmpl",
                                        query               => $input,
                                        type                => "intranet",
                                        authnotrequired     => 0,
                                        flagsrequired       => {  ui        => 'ANY', 
                                                            tipo_documento  => 'ANY', 
                                                            accion          => 'CONSULTA', 
                                                            entorno         => 'usuarios'},
                                        debug               => 1,
    });
    
    my $msg_object                  = C4::AR::Logos::eliminarLogoUI($obj);
    my $codMsg                      = C4::AR::Mensajes::getFirstCodeError($msg_object);
    $t_params->{'mensaje'}          = C4::AR::Mensajes::getMensaje($codMsg,'INTRA');
    
    if (C4::AR::Mensajes::hayError($msg_object)){
        $t_params->{'mensaje_class'} = "alert-error";
    }else{
        $t_params->{'mensaje_class'} = "alert-success";
    }
    
    my ($cant_logos,$logos)         = C4::AR::Logos::listarUI();

    $t_params->{'logos'}            = $logos;
    $t_params->{'cant_logos'}       = $cant_logos;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}