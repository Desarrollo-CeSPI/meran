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
use C4::Date;
use C4::AR::Prestamos;
use Date::Manip;
use C4::Date;
use C4::AR::Sanciones;

my $input=new CGI;

my ($template, $session, $t_params) =  get_template_and_user ({
							template_name	=> 'usuarios/reales/detallePrestamos.tmpl',
							query		    => $input,
							type		    => "intranet",
							authnotrequired	=> 0,
							flagsrequired	=> {    ui              => 'ANY', 
                                                    tipo_documento  => 'ANY', 
                                                    accion          => 'CONSULTA', 
                                                    entorno         => 'undefined'},
    });

my $obj = $input->param('obj');
$obj    = C4::AR::Utilidades::from_json_ISO($obj);
C4::AR::Validator::validateParams('U389',$obj,['nro_socio'] );

my $nro_socio                   						= $obj->{'nro_socio'};
my ($prestamos_array_ref_count, $prestamos_array_ref)   = C4::AR::Prestamos::obtenerPrestamosDeSocio($nro_socio);

$t_params->{'PRESTAMOS'}        						= $prestamos_array_ref;
$t_params->{'prestamos_cant'}   						= $prestamos_array_ref_count;

C4::AR::Debug::debug("detallePrestamos => prestamos_cant => " .$prestamos_array_ref_count);

my $algunoSeRenueva             						= 0;
my $vencidos                    						= 0;

foreach my $prestamo (@$prestamos_array_ref) {
	if($prestamo->estaVencido){$vencidos++;}
	if($prestamo->sePuedeRenovar){$algunoSeRenueva=1;}
}

$t_params->{'vencidos'}         = $vencidos;
$t_params->{'algunoSeRenueva'}  = $algunoSeRenueva;

#se ferifica si la preferencia "circularDesdeDetalleUsuario" esta seteada
$t_params->{'circularDesdeDetalleUsuario'} = C4::AR::Preferencias::getValorPreferencia('circularDesdeDetalleUsuario');

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);