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


my $nro_socio           = C4::AR::Auth::getSessionNroSocio();
my ($socio, $flags)     = C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);
my $review              = $input->param('review') || 0;
my $id2                 = $input->param('id2');
my %params              = {};

$params{'review'}       = $input->param('review');
$params{'id2'}          = $input->param('id2');
$params{'nro_socio'}    = $nro_socio;

if ($review){
	my ($template, $session, $t_params)= get_template_and_user({
                                    template_name   => "opac-main.tmpl",
                                    query           => $query,
                                    type            => "opac",
                                    authnotrequired => 0,
                                    flagsrequired   => {ui              => 'ANY', 
                                                        tipo_documento  => 'ANY', 
                                                        accion          => 'CONSULTA', 
                                                        entorno         => 'undefined'},
             });
             
    C4::AR::Validator::validateParams('VA002',\%params,['nro_socio', 'id2', 'review']);
    C4::AR::Nivel2::reviewNivel2($id2,$review,$nro_socio);

}

$t_params->{'portada_registro_medium'}  =  C4::AR::PortadasRegistros::getImageForId2($id2,'M');
$t_params->{'portada_registro_big'}     =  C4::AR::PortadasRegistros::getImageForId2($id2,'L');

eval{

    my $nivel2                          = C4::AR::Nivel2::getNivel2FromId2($id2);

    $t_params->{'nivel2'}               = $nivel2->toMARC_Opac;
    $t_params->{'titulo'}               = $nivel2->nivel1->getTitulo;
    $t_params->{'id1'}                  = $nivel2->nivel1->getId1;
    $t_params->{'reviews'}              = C4::AR::Nivel2::getReviews($id2);
    $t_params->{'partial_template'}     = "reviews.inc";
    $t_params->{'id2'}                  = $id2;
    $t_params->{'nivel2_obj'}           = $nivel2;
};
 
if ($@){
    $t_params->{'mensaje'}              = C4::AR::Filtros::i18n("Ha ocurrido un error viendo las revisiones");
}else{
    if ($review){
        $t_params->{'mensaje'}              = C4::AR::Filtros::i18n("Hemos recibido tu comentario. Cuando el personal de la Biblioteca lo apruebe, va a ser visible.");
        $t_params->{'mensaje_class'}        = "alert-success";
    }
}

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);