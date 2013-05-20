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
use C4::AR::Utilidades;
use JSON;
use C4::AR::AyudaMarc;

my $input           = new CGI;
my $obj             = $input->param('obj');

$obj                = C4::AR::Utilidades::from_json_ISO($obj);

my $tipoAccion      = $obj->{'tipoAccion'} || "";

my $authnotrequired = 0;

if($tipoAccion eq "LISTAR"){

    my ($template, $session, $t_params) = get_template_and_user({
                  template_name       => "admin/ayudaMarcAjax.tmpl",
                  query               => $input,
                  type                => "intranet",
                  authnotrequired     => 0,
                  flagsrequired       => {    ui              => 'ANY', 
                                              tipo_documento  => 'ANY', 
                                              accion          => 'CONSULTA', 
                                              entorno         => 'usuarios'},
                  debug               => 1,
          });

    my ($ayudasMarc,$cant)    = C4::AR::AyudaMarc::getAyudaMarc();

    $t_params->{'cant'}       = $cant;    
    $t_params->{'ayudasMarc'}   = $ayudasMarc;
    $t_params->{'selectCampoX'} = C4::AR::Utilidades::generarComboCampoX('eleccionCampoX()');

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

}elsif($tipoAccion eq "AGREGAR_VISUALIZACION"){

    my ($user, $session, $flags)= checkauth(  $input, 
                                              $authnotrequired, 
                                              {   ui                => 'ANY', 
                                                  tipo_documento    => 'ANY', 
                                                  accion            => 'CONSULTA', 
                                                  entorno           => 'datos_nivel1'}, 
                                              'intranet'
                                  );

    my ($Message_arrayref)  = C4::AR::AyudaMarc::agregarAyudaMarc($obj);
    my $infoOperacionJSON   = to_json $Message_arrayref;

    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;

}elsif ($tipoAccion eq "SHOW_MOD_AYUDA"){

    my $ayuda = C4::AR::AyudaMarc::getAyudaMarcById($obj->{'idAyuda'});

    my ($template, $session, $t_params) = get_template_and_user({
                                        template_name   => "admin/ayudaMarcMod.tmpl",
                                        query           => $input,
                                        type            => "intranet",
                                        authnotrequired => 0,
                                        flagsrequired   => {  ui => 'ANY', 
                                                            accion => 'TODOS', 
                                                            entorno => 'usuarios'},
                                        debug => 1,
                    });
    
    $t_params->{'ayuda'}    = $ayuda;
    $t_params->{'idAyuda'}  = $obj->{'idAyuda'};

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

}elsif ($tipoAccion eq "MOD_VISUALIZACION"){

    my ($user, $session, $flags)= checkauth(  $input, 
                                              $authnotrequired, 
                                              {   ui                => 'ANY', 
                                                  tipo_documento    => 'ANY', 
                                                  accion            => 'CONSULTA', 
                                                  entorno           => 'datos_nivel1'}, 
                                              'intranet'
                                  );

    my ($Message_arrayref)  = C4::AR::AyudaMarc::modificarAyudaMarc($obj);

    my $infoOperacionJSON   = to_json $Message_arrayref;

    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;

}elsif ($tipoAccion eq "ELIMINAR"){

    my ($user, $session, $flags)= checkauth(  $input, 
                                              $authnotrequired, 
                                              {   ui                => 'ANY', 
                                                  tipo_documento    => 'ANY', 
                                                  accion            => 'CONSULTA', 
                                                  entorno           => 'datos_nivel1'}, 
                                              'intranet'
                                  );

    my ($Message_arrayref)  = C4::AR::AyudaMarc::eliminarAyudaMarc($obj->{'idAyuda'});

    my $infoOperacionJSON   = to_json $Message_arrayref;

    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;

}    