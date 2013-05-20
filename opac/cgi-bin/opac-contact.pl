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
use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use CGI;

my $query = new CGI;

my ($template, $session, $t_params)= get_template_and_user({
                                template_name   => "opac-main.tmpl",
                                query           => $query,
                                type            => "opac",
                                authnotrequired => 1,
                                flagsrequired   => {  ui            => 'ANY', 
                                                    tipo_documento  => 'ANY', 
                                                    accion          => 'CONSULTA', 
                                                    entorno         => 'undefined'},
            });

$t_params->{'opac'};
$t_params->{'content_title'}    = C4::AR::Filtros::i18n("Formulario de contacto");

my $post = $query->param('post_message') || 0;

if ($post){

    use C4::Modelo::Contacto;
    my ($contacto)  = C4::Modelo::Contacto->new();
    my $params_hash = $query->Vars;
    $t_params->{'mensaje_error'} = 0;
        #verificamos que los campos requeridos tengan valor
    if( ($params_hash->{'nombre'} eq "") || ($params_hash->{'apellido'} eq "") || ($params_hash->{'email'} eq "") || ($params_hash->{'mensaje'} eq "") ){
        $t_params->{'mensaje_error'} = 1;
        $t_params->{'mensaje_class'} = 'alert-error ';
        $t_params->{'mensaje'} = C4::AR::Mensajes::getMensaje('VA002','opac');
        $t_params->{'partial_template'} = "opac-contact.inc";
    }else{
  	    $contacto->agregar($params_hash);
        $t_params->{'mensaje_class'} = 'alert-success';
        $t_params->{'mensaje'} = C4::AR::Mensajes::getMensaje('U608','opac');
        $t_params->{'no_submit'} = 1;
        $t_params->{'partial_template'} = "opac-contact.inc";
    }
    
    $t_params->{'params_form'} = $params_hash;
    
}else{
    $t_params->{'partial_template'} = "opac-contact.inc";
}

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);