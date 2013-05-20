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
use C4::Date;
use C4::AR::Reservas;
use CGI;

my $input = new CGI;

my ($template, $session, $t_params) =  get_template_and_user ({
							template_name	=> 'usuarios/reales/historialReservas.tmpl',
							query		    => $input,
							type		    => "intranet",
							authnotrequired	=> 0,
							flagsrequired	=> {    ui              => 'ANY', 
                                                    tipo_documento  => 'ANY', 
                                                    accion          => 'CONSULTA', 
                                                    entorno         => 'undefined'},
    });


my $obj = C4::AR::Utilidades::from_json_ISO($input->param('obj'));
C4::AR::Validator::validateParams('U389',$obj,['nro_socio'] );

my $nro_socio                   = $obj->{'nro_socio'};
my $orden                       = 'id DESC';
my $ini                         = $obj->{'ini'};
my $funcion                     = $obj->{'funcion'};

my ($ini,$pageNumber,$cantR)    = C4::AR::Utilidades::InitPaginador($ini);
my ($cant,$reservas_array_ref)  = C4::AR::Reservas::getHistorialReservasParaTemplate($nro_socio,$ini,$cantR,$orden);

$t_params->{'paginador'}        = C4::AR::Utilidades::crearPaginador($cant,$cantR, $pageNumber,$funcion,$t_params);
$t_params->{'cantidad'}         = $cant;
$t_params->{'nro_socio'}        = $nro_socio;
$t_params->{'loop_reading'}     = $reservas_array_ref;

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);