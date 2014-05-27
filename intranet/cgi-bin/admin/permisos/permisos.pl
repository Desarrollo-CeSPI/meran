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
use CGI;
use C4::AR::Auth;
use C4::AR::Preferencias;
use C4::AR::Permisos;

my $input   = new CGI;
my $obj     = $input->param('obj');
my $socio   = "";
if ($input->param('nro_socio')){
     $socio = C4::AR::Usuarios::getSocioInfoPorNroSocio($input->param('nro_socio'));
     C4::AR::Debug::debug("socio string : " . $socio->persona->getApeYNom);
}

my ($template, $session, $t_params)  = get_template_and_user({  
                    template_name => "admin/permisos/permisos.tmpl",
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


if ($socio){
     $t_params->{'socio_permisos'}           = $socio;
}
my %params_combo                        = {};
$params_combo{'default'}                = 'ALL';

my $combo_tipoDoc                       = C4::AR::Utilidades::generarComboTipoNivel3(\%params_combo);
$t_params->{'combo_tipoDoc'}            = $combo_tipoDoc;

my %params_options;
$params_options{'optionALL'}            = 1;

my $combo_UI                            = C4::AR::Utilidades::generarComboUI(\%params_options);
$t_params->{'combo_UI'}                 = $combo_UI;

my $combo_permisos                      = C4::AR::Utilidades::generarComboPermisos();
$t_params->{'combo_permisos'}           = $combo_permisos;

my $combo_perfiles                      = C4::AR::Utilidades::generarComboPerfiles();
$t_params->{'combo_perfiles'}           = $combo_perfiles;

my %params_combo                        = {};
$params_combo{'onChange'}                = 'changeTipoPermiso()';
my $combo_tipo_permisos                 = C4::AR::Utilidades::generarComboTipoPermisos(\%params_combo);
$t_params->{'combo_tipo_permisos'}      = $combo_tipo_permisos;

$t_params->{'page_sub_title'}           = C4::AR::Filtros::i18n("Permisos de Cat&aacute;logo");

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);