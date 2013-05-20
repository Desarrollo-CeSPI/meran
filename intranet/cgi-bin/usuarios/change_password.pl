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

use JSON;
use CGI;

my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user({
                                    template_name   => "changepassword.tmpl",
                                    query           => $input,
                                    type            => "intranet",
                                    authnotrequired => 0,
                                    change_password => 1, #-> indicamos a checkauth que ya estamos cambiando la password
                                    flagsrequired   => { 
                                                        ui              => 'ANY', 
                                                        tipo_documento  => 'ANY', 
                                                        accion          => 'CONSULTA', 
                                                        entorno         => 'undefined'},
                                    changepassword => 1,
                              });


my $nro_socio                       = C4::AR::Auth::getSessionNroSocio();
my $socio                           = C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);

if ( $socio->getChange_password() ){
    $t_params->{'cambioForzado'}    = 1;
}

if ($input->param('error')){
    $t_params->{'mensaje'}          = C4::AR::Mensajes::getMensaje($session->param("codMsg"),'INTRA',[]);
}
$t_params->{'plainPassword'}        = C4::Context->config('plainPassword');
$t_params->{'nroRandom'}            = C4::AR::Auth::getSessionNroRandom();

#preferencias para generar nueva password
$t_params->{'minPassLength'}        = C4::AR::Preferencias::getValorPreferencia('minPassLength');
$t_params->{'minPassSymbol'}        = C4::AR::Preferencias::getValorPreferencia('minPassSymbol');
$t_params->{'minPassAlpha'}         = C4::AR::Preferencias::getValorPreferencia('minPassAlpha');
$t_params->{'minPassNumeric'}       = C4::AR::Preferencias::getValorPreferencia('minPassNumeric');

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);