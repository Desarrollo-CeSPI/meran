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
use C4::AR::Estantes;
use C4::AR::Auth;

use JSON;
my $input=new CGI;
my $authnotrequired= 0;
my $Messages_arrayref;
my $obj=$input->param('obj');
$obj=C4::AR::Utilidades::from_json_ISO($obj);
my $tipo= $obj->{'tipo'};

if($tipo eq "VER_ESTANTES"){

    my ($template, $session, $t_params) = get_template_and_user(
            {template_name => "includes/verEstante.inc",
                    query => $input,
                    type => "intranet",
                    authnotrequired => 0,
                    flagsrequired => {  ui => 'ANY', 
                                        tipo_documento => 'ANY',  
                                        accion => 'CONSULTA', 
                                        entorno => 'undefined'},
                    });

    my $estantes_publicos = C4::AR::Estantes::getListaEstantesPublicos();
    $t_params->{'cant_estantes'}= @$estantes_publicos;
    $t_params->{'ESTANTES'}= $estantes_publicos;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

} elsif($tipo eq "VER_SUBESTANTE"){

	my ($template, $session, $t_params) = get_template_and_user(
            {template_name => "estantes/subEstante.tmpl",
					query => $input,
					type => "intranet",
					authnotrequired => 0,
					flagsrequired => {  ui => 'ANY', 
                                        tipo_documento => 'ANY', 
                                        accion => 'CONSULTA',  
                                        entorno => 'undefined'},
					});
	
    my $id_estante                     = $obj->{'estante'};

    if($id_estante ne 0){
	    my $estante                    = C4::AR::Estantes::getEstante($id_estante);
	    $t_params->{'estante'}         = $estante;
    }

    my $subEstantes                     = C4::AR::Estantes::getSubEstantes($id_estante);
    $t_params->{'SUBESTANTES'}          = $subEstantes;
    $t_params->{'cant_subestantes'}     = @$subEstantes;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
    
} elsif($tipo eq "VER_ESTANTE_BY_ID"){

	my ($template, $session, $t_params) = get_template_and_user(
            {template_name => "estantes/subEstante.tmpl",
					query => $input,
					type => "intranet",
					authnotrequired => 0,
					flagsrequired => {  ui => 'ANY', 
                                        tipo_documento => 'ANY', 
                                        accion => 'CONSULTA',  
                                        entorno => 'undefined'},
					});
	
    my $id_estante= $obj->{'estante'};
    if($id_estante ne 0){
	    my $estante= C4::AR::Estantes::getEstante($id_estante);
	    $t_params->{'estante'}= $estante;
    }

    my $subEstantes= C4::AR::Estantes::getSubEstantes($id_estante);

    $t_params->{'SUBESTANTES'}= $subEstantes;
    $t_params->{'cant_subestantes'}= @$subEstantes;
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
elsif($tipo eq "BORRAR_ESTANTES"){
    my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'BAJA', 
                                                    entorno => 'undefined' },
                                                'intranet'
                               );

    my $estantes_array_ref= $obj->{'estantes'};
    ($Messages_arrayref)= &C4::AR::Estantes::borrarEstantes($estantes_array_ref);

    my $infoOperacionJSON=to_json $Messages_arrayref;

    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}
elsif($tipo eq "CLONAR_ESTANTE"){
    my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'BAJA', 
                                                    entorno => 'undefined' },
                                                'intranet'
                               );

    my $estante_a_clonar= $obj->{'estante'};
    ($Messages_arrayref)= &C4::AR::Estantes::clonarEstante($estante_a_clonar);
    my $infoOperacionJSON=to_json $Messages_arrayref;
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}
elsif($tipo eq "MODIFICAR_ESTANTE"){
    my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'MODIFICACION', 
                                                    entorno => 'undefined' },
                                                'intranet'
                               );

    my $id_estante= $obj->{'estante'};
    my $valor= $obj->{'valor'};
    ($Messages_arrayref)= &C4::AR::Estantes::modificarEstante($id_estante,$valor);

    my $infoOperacionJSON=to_json $Messages_arrayref;

    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}
elsif($tipo eq "AGREGAR_SUBESTANTE"){
    my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'ALTA', 
                                                    entorno => 'undefined' },
                                                'intranet'
                               );

    my $id_estante= $obj->{'estante'};
    my $valor= $obj->{'valor'};
    ($Messages_arrayref)= &C4::AR::Estantes::agregarSubEstante($id_estante,$valor);

    my $infoOperacionJSON=to_json $Messages_arrayref;

    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}
elsif($tipo eq "AGREGAR_ESTANTE"){
    my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'ALTA', 
                                                    entorno => 'undefined' },
                                                'intranet'
                               );

    my $valor= $obj->{'estante'};
    ($Messages_arrayref)= &C4::AR::Estantes::agregarEstante($valor);

    my $infoOperacionJSON=to_json $Messages_arrayref;

    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}
elsif($tipo eq "BUSCAR_CONTENIDO"){

    my ($template, $session, $t_params) = get_template_and_user(
                        {   template_name => "estantes/contenidoEstante.tmpl",
        					query => $input,
        					type => "intranet",
        					authnotrequired => 0,
        					flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'CONSULTA', 
                                                entorno => 'undefined'},
    					});
					
    my $ini= $obj->{'ini'};
    my ($ini,$pageNumber,$cantR)    = C4::AR::Utilidades::InitPaginador($ini);
    $t_params->{'ini'}              = $obj->{'ini'} = $ini;
    $t_params->{'cantR'}            = $obj->{'cantR'} = $cantR;
    $obj->{'type'}                  = 'INTRA';
    my $valor                       = $obj->{'valor'};
    my $search;
    $search->{'keyword'}            = $valor;
    my ($cantidad, $resultId1, $suggested)      = C4::AR::Busquedas::busquedaCombinada_newTemp($search->{'keyword'}, $session, $obj);
    $t_params->{'paginador'}        = C4::AR::Utilidades::crearPaginador($cantidad, $cantR, $pageNumber, $obj->{'funcion'}, $t_params);
    $obj->{'cantidad'}              = $cantidad;
    $t_params->{'sentido_orden'}    = $obj->{'sentido_orden'}; 
    $t_params->{'orden'}            = $obj->{'orden'};


    C4::AR::Debug::debug("SENTIDO: ".$obj->{'sentido_orden'} );
    C4::AR::Debug::debug("ORDEN: ".$obj->{'orden'});

    $t_params->{'SEARCH_RESULTS'}   = $resultId1;
    $t_params->{'cantidad'}         = $cantidad;
    $t_params->{'socio_busqueda'}   = $valor;
    
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
elsif($tipo eq "BUSCAR_ESTANTO_POR_CONTENIDO"){

    my ($template, $session, $t_params) = get_template_and_user(
                        {   template_name => "estantes/contenidoEstanteResult.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'CONSULTA', 
                                                entorno => 'undefined'},
                        });
                    
    my $ini= $obj->{'ini'};
    my ($ini,$pageNumber,$cantR)    = C4::AR::Utilidades::InitPaginador($ini);
    $t_params->{'ini'}              = $obj->{'ini'} = $ini;
    $t_params->{'cantR'}            = $obj->{'cantR'} = $cantR;
    $obj->{'type'}                  = 'INTRA';
    my $valor                       = $obj->{'valor'};
    my $search;
    $search->{'keyword'}            = $valor;
    my ($cantidad, $resultId1, $suggested)      = C4::AR::Busquedas::busquedaCombinada_newTemp($search->{'keyword'}, $session, $obj);
    $t_params->{'paginador'}        = C4::AR::Utilidades::crearPaginador($cantidad, $cantR, $pageNumber, $obj->{'funcion'}, $t_params);
    $obj->{'cantidad'}              = $cantidad;
    $t_params->{'sentido_orden'}    = $obj->{'sentido_orden'}; 
    $t_params->{'orden'}            = $obj->{'orden'};


    C4::AR::Debug::debug("SENTIDO: ".$obj->{'sentido_orden'} );
    C4::AR::Debug::debug("ORDEN: ".$obj->{'orden'});

    $t_params->{'SEARCH_RESULTS'}   = $resultId1;
    $t_params->{'cantidad'}         = $cantidad;
    $t_params->{'socio_busqueda'}   = $valor;
    
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
elsif($tipo eq "AGREGAR_CONTENIDO"){
    my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'ALTA', 
                                                    entorno => 'undefined' },
                                                'intranet'
                               );

    my $estante= $obj->{'estante'};
    my $id2= $obj->{'id2'};
    ($Messages_arrayref)= &C4::AR::Estantes::agregarContenidoAEstante($estante,$id2);

    my $infoOperacionJSON=to_json $Messages_arrayref;

    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}
elsif($tipo eq "BORRAR_CONTENIDO"){
    my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'BAJA', 
                                                    entorno => 'undefined' },
                                                'intranet'
                               );

    my $id_estante= $obj->{'estante'};
    my $contenido_array_ref;

    if ($obj->{'eliminar_uno'}){
          my @array_contenido;
          @array_contenido=$obj->{'contenido'};
            
          ($Messages_arrayref)= &C4::AR::Estantes::borrarContenido($id_estante,\@array_contenido);

    } else {

          $contenido_array_ref= $obj->{'contenido'};
          ($Messages_arrayref)= &C4::AR::Estantes::borrarContenido($id_estante,$contenido_array_ref);
    }


    my $infoOperacionJSON=to_json $Messages_arrayref;

    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;


}  