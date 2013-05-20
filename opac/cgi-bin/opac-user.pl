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
use C4::AR::Sanciones;
use Date::Manip;
use C4::AR::Usuarios;

my $query = new CGI;

my ($template, $session, $t_params)= get_template_and_user({
									template_name => "opac-user.tmpl",
									query => $query,
									type => "opac",
									authnotrequired => 0,
									flagsrequired => {  ui => 'ANY', 
                                                        tipo_documento => 'ANY', 
                                                        accion => 'CONSULTA', 
                                                        entorno => 'undefined'},
									debug => 1,
			     });


my $dateformat = C4::Date::get_date_format();

my $socio = C4::AR::Usuarios::getSocioInfoPorNroSocio($session->param('userid'));
my $persona=$socio->getPersona;


$t_params->{'socio'}=$socio;
$t_params->{'persona'}=$persona;

#### Verifica si la foto ya esta cargada
my $picturesDir= C4::Context->config("picturesdir");
my $foto;
if (opendir(DIR, $picturesDir)) {
        my $pattern= $session->param('userid')."[.].";
        my @file = grep { /$pattern/ } readdir(DIR);
        $foto= join("",@file);
        closedir DIR;
} else {
        $foto= 0;
}

#### Verifica si hay problemas para subir la foto
my $msgFoto=$query->param('msg');
($msgFoto) || ($msgFoto=0);
####

$t_params->{'foto_name'} = $foto;
$t_params->{'mensaje_error_foto'} = $msgFoto;

$t_params->{'UploadPictureFromOPAC'}= C4::AR::Preferencias::getValorPreferencia("UploadPictureFromOPAC");

$t_params->{'pagetitle'}= "Usuarios";


C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);