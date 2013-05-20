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
use C4::Context;
use C4::AR::Recomendaciones;
use JSON;
use CGI;

my $input = new CGI;

my $obj   = $input->param('obj');
$obj = C4::AR::Utilidades::from_json_ISO($obj);

my ($template, $session, $t_params) = get_template_and_user({
    template_name => "opac-main.tmpl",
    query => $input,
    type => "opac",
    authnotrequired => 0,
    flagsrequired => {  ui => 'ANY', 
                        tipo_documento => 'ANY', 
                        accion => 'ALTA', 
                        tipo_permiso => 'general',
                        entorno => 'adq_opac'},
    debug => 1,
});

# my $input_params = $input->Vars;

my $usr_socio_id= C4::AR::Usuarios::getSocioInfoPorNroSocio(C4::AR::Auth::getSessionUserID($session))->getId_socio();

my $status = C4::AR::Recomendaciones::agregarRecomendacion($obj,$usr_socio_id);

# FIXME  iterar por cada detalle agregado al a recomendacion (por ahora agrega solo un detalle)




#


# TODO MOSTRAR MENSAJE

$t_params->{'message'}= $status->{'messages'}[0]->{'message'};

# if ($status){
#     C4::AR::Auth::redirectTo(C4::AR::Utilidades::getUrlPrefix().'/opac-recomendaciones.pl?token'.$input->param('token'));
# }