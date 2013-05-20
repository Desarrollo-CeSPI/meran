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
use Template;
use C4::AR::Sanciones;
use C4::AR::Utilidades;

my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user({
                        template_name   => "admin/circulacion/sanciones.tmpl",
                        query           => $input,
                        type            => "intranet",
                        authnotrequired => 0,
                        flagsrequired   => {  ui => 'ANY', 
                                            tipo_documento => 'ANY', 
                                            accion => 'CONSULTA', 
                                            entorno => 'undefined'},
                        debug           => 1,
			    });

my $params;
$params->{'onChange'}                   = 'buscarTiposPrestamosSancionados()';
$params->{'no_default'}                 = 1;

my $CGIusr_ref_categoria_socio          = C4::AR::Utilidades::generarComboCategoriasDeSocioConCodigoCat($params);
my $CGIcirc_ref_tipo_prestamo           = C4::AR::Utilidades::generarComboTipoPrestamo($params);
$t_params->{'categorias_de_socio'}      = $CGIusr_ref_categoria_socio;
$t_params->{'tipos_de_prestamos'}       = $CGIcirc_ref_tipo_prestamo;


$t_params->{'page_sub_title'}           = C4::AR::Filtros::i18n("Circulaci&oacute;n - Sanciones");

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);