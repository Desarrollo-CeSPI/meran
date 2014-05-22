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
use C4::AR::Referencias;
# use C4::AR::Utilidades;
use JSON;

my $input = new CGI;
my $obj=$input->param('obj');

my $editing = $input->param('value') || $input->param('id');

$obj=C4::AR::Utilidades::from_json_ISO($obj);

C4::AR::Utilidades::printHASH($obj);

C4::AR::Debug::debug($editing);

my $accion;

if ($obj != 0){
    $accion = $obj->{'accion'};
}else{
    $accion = $input->param('action') || undef;
    C4::AR::Debug::debug($accion);
}

if ($editing){
    my $string_ref = $input->param('id');
    my $value = $input->param('value');

C4::AR::Debug::debug($string_ref);
C4::AR::Debug::debug($value);

    my $valor = C4::AR::Referencias::editarReferencia($string_ref,$value);

    my ($template, $session, $t_params)  = get_template_and_user({  
                        template_name => "includes/partials/modificar_value.tmpl",
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

    $t_params->{'value'} = C4::AR::Utilidades::escapeData($value);

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
elsif ($accion eq "OBTENER_TABLAS"){

    my $alias_tabla= $obj->{'alias_tabla'};
    my $filtro= $obj->{'filtro'} || 0;
    my $ini=$obj->{'ini'};
    my $funcion=$obj->{'funcion'};
    my $inicial=$obj->{'inicial'};
    my ($template, $session, $t_params)  = get_template_and_user({  
                        template_name => "admin/referencias/detalle_tabla.tmpl",
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

    my ($ini,$pageNumber,$cantR)=C4::AR::Utilidades::InitPaginador($ini);

    my ($cantidad,$clave,$tabla,$datos,$campos) = C4::AR::Referencias::getTabla($alias_tabla,$filtro,$cantR,$ini);

    $t_params->{'paginador'}= C4::AR::Utilidades::crearPaginador($cantidad,$cantR, $pageNumber,$funcion,$t_params);
    
    $t_params->{'mostrar_asignar'}  = $obj->{'asignar'} || 1;
    $t_params->{'campos'}           = $campos;

    $t_params->{'datos'}            = $datos;
    $t_params->{'tabla'}            = $tabla;
    $t_params->{'cantidad_total'}   = $cantidad;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

} elsif ($accion eq "AGREGAR_REGISTRO"){

    my $alias_tabla= $obj->{'alias_tabla'};

    my ($template, $session, $t_params)  = get_template_and_user({  
                        template_name => "admin/referencias/detalle_tabla.tmpl",
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


    my ($clave,$tabla,$datos,$campos) = C4::AR::Referencias::agregarRegistro($alias_tabla);
    
    $t_params->{'mostrar_asignar'} = $obj->{'asignar'} || 0;
    $t_params->{'agregar'} = 0;
    $t_params->{'campos'} = $campos;
    $t_params->{'datos'} = $datos;
    $t_params->{'tabla'} = $tabla;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

}
elsif ($accion eq "MOSTRAR_REFERENCIAS"){

    my $alias_tabla= $obj->{'alias_tabla'};
    my $value_id = $obj->{'value_id'};

    my ($template, $session, $t_params)  = get_template_and_user({  
                            template_name => "admin/referencias/detalle_referencias.tmpl",
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

    my ($used_or_not,$referer_involved,$items_involved) = C4::AR::Referencias::mostrarReferencias($alias_tabla,$value_id);
    if ($items_involved){
        my ($tabla_related,$related_referers) = C4::AR::Referencias::mostrarSimilares($alias_tabla,$value_id);
    
        $t_params->{'involved'} = $items_involved;
        $t_params->{'involved_count'} = scalar(@$items_involved);
        $t_params->{'used'} = $used_or_not;
        $t_params->{'mostrar_asignar'} = $obj->{'asignar'} || 0;
        $t_params->{'referer_involved'} = $referer_involved;
        $t_params->{'related_referers'} = $related_referers;
        $t_params->{'related_referers_count'} = scalar(@$related_referers);
        $t_params->{'tabla_related'} = $tabla_related;
    }
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
elsif ($accion eq "ASIGNAR_REFERENCIA"){

    my $alias_tabla= $obj->{'alias_tabla'};
    my $related_id = $obj->{'related_id'};
    my $referer_involved = $obj->{'referer_involved'};

    my ($template, $session, $t_params)  = get_template_and_user({  
                            template_name => "admin/referencias/detalle_referencias.tmpl",
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

    C4::AR::Referencias::asignarReferencia($alias_tabla,$related_id,$referer_involved);
    my ($used_or_not,$referer_involved,$items_involved)=C4::AR::Referencias::mostrarReferencias($alias_tabla,$related_id);
    my ($tabla_related,$related_referers) = C4::AR::Referencias::mostrarSimilares($alias_tabla,$related_id);


    $t_params->{'involved'} = $items_involved;
    $t_params->{'used'} = $used_or_not;
    $t_params->{'mostrar_asignar'} = $obj->{'asignar'} || 0;
    $t_params->{'referer_involved'} = $referer_involved;
    $t_params->{'related_referers'} = $related_referers;
    $t_params->{'tabla_related'} = $tabla_related;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
elsif ($accion eq "ASIGNAR_Y_ELIMINAR_REFERENCIA"){

    my $alias_tabla= $obj->{'alias_tabla'};
    my $related_id = $obj->{'related_id'};
    my $referer_involved = $obj->{'referer_involved'};

    my ($template, $session, $t_params)  = get_template_and_user({  
                            template_name => "admin/referencias/detalle_referencias.tmpl",
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
    C4::AR::Referencias::asignarYEliminarReferencia($alias_tabla,$related_id,$referer_involved);
    my ($used_or_not,$referer_involved,$items_involved)=C4::AR::Referencias::mostrarReferencias($alias_tabla,$related_id);
    my ($tabla_related,$related_referers) = C4::AR::Referencias::mostrarSimilares($alias_tabla,$related_id);

    $t_params->{'mostrar_asignar'} = $obj->{'asignar'} || 0;
    $t_params->{'involved'} = $items_involved;
    $t_params->{'used'} = $used_or_not;

    $t_params->{'referer_involved'} = $referer_involved;
    $t_params->{'related_referers'} = $related_referers;
    $t_params->{'tabla_related'} = $tabla_related;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}

elsif ($accion eq "ELIMINAR_REFERENCIA"){

    my $alias_tabla= $obj->{'alias_tabla'};
    my $item_id = $obj->{'item_id'};

    my ($template, $session, $t_params)  = get_template_and_user({  
                            template_name => "admin/referencias/detalle_referencias.tmpl",
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

    my ($msj_object) = C4::AR::Referencias::eliminarReferencia($alias_tabla,$item_id);
    my $infoOperacionJSON=to_json $msj_object;
    
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}