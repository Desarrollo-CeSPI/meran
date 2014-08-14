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
use C4::AR::Nivel3 qw(detalleCompletoINTRA);

my $input=new CGI;
my $ajax = $input->param('ajax') || 0;
my ($template, $session, $t_params) = get_template_and_user({
                            template_name   => ('catalogacion/estructura/detalle.tmpl'),
                            query           => $input,
                            type            => "intranet",
                            authnotrequired => 0,
                            flagsrequired   => {    ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'datos_nivel1'},
                        });

my $id1                         = $input->param('id1');
$t_params->{'id2'}              = $input->param('id2') || 0;
$t_params->{'page'}             = $input->param('page') || 0;


my $nivel1                      = C4::AR::Nivel1::getNivel1FromId1($id1);

if (!$nivel1){
    C4::AR::Utilidades::redirectAndAdvice('U614');
}

#si ponen un id que no existe muestra internal server error 
#eval{ 
    my ($cant_total)            =  C4::AR::Nivel3::detalleCompletoINTRA($id1, $t_params);
    $t_params->{'cant_total'}   = $cant_total;
#};

if($@){
    C4::AR::Utilidades::redirectAndAdvice('U614');
}


$t_params->{'template_nivel1'}                      = $nivel1->getTemplate();
$t_params->{'per_page'}                             = C4::Context->config("cant_grupos_per_query") || 5;
$t_params->{'ajax'}                                 = $ajax;
$t_params->{'page_sub_title'}                       = C4::AR::Filtros::i18n("Catalogaci&oacute;n - Detalle del &iacute;tem");
$t_params->{'mensaje'}                              = $input->url_param('msg_file');
$t_params->{'mensaje_group'}                        = $input->url_param('msg_file_group');
$t_params->{'pref_e_documents'}                     = C4::AR::Preferencias::getPreferencia("e_documents");
$t_params->{'auto_generar_comprobante_prestamo'}    = C4::AR::Preferencias::getValorPreferencia('auto_generar_comprobante_prestamo');
$t_params->{'nav_elements'}                         = C4::AR::Nivel2::buildNavForGroups($t_params);

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);