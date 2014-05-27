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
use C4::AR::Permisos;
use JSON;

my $input = new CGI;
my $obj=$input->param('obj');

C4::AR::Debug::debug("obj => ".$obj);

$obj=C4::AR::Utilidades::from_json_ISO($obj);

my $accion;
if ($obj != 0){
    $accion = $obj->{'accion'};
    $obj->{'tipo_documento'} = 'ALL'; #FIX PARA FERNANDA QUE DICE QUE ESTO NO HACE FALTA
}else{
    $accion = $input->param('action') || undef;
}

if ($accion eq "OBTENER_PERMISOS_CATALOGO"){

    my $nro_socio = $obj->{'nro_socio'};
    my $id_ui = $obj->{'id_ui'};
    my $tipo_documento = $obj->{'tipo_documento'};

    my ($template, $session, $t_params)  = get_template_and_user({  
                        template_name   => "admin/permisos/detalle_permisos_catalogo.tmpl",
                        query           => $input,
                        type            => "intranet",
                        authnotrequired => 0,
                        flagsrequired   => {  ui            => 'ANY', 
                                            tipo_documento  => 'ANY', 
                                            accion          => 'CONSULTA', 
                                            entorno         => 'permisos', 
                                            tipo_permiso    => 'general'
                        },
                        debug           => 1,
                    });

    my $perfil                  = $obj->{'perfil'} || 0;
    my ($permisos,$newUpdate)   = C4::AR::Permisos::obtenerPermisosCatalogo($nro_socio,$id_ui,$tipo_documento,$perfil);

    $t_params->{'permisos'}     = $permisos;

    if (!$permisos){
        $permisos = C4::AR::Permisos::armarPerfilCatalogo('E');
        $permisos = C4::AR::Permisos::parsearPermisos($permisos);
    }

    $t_params->{'permisos_nivel1'} = C4::AR::Filtros::crearCheckButtonsBootstrap($permisos->{'datos_nivel1'}, 'datos_nivel1');

    $t_params->{'permisos_nivel2'} = C4::AR::Filtros::crearCheckButtonsBootstrap($permisos->{'datos_nivel2'}, 'datos_nivel2');

    $t_params->{'permisos_nivel3'} = C4::AR::Filtros::crearCheckButtonsBootstrap($permisos->{'datos_nivel3'}, 'datos_nivel3');

    $t_params->{'permisos_estantes_virtuales'} = C4::AR::Filtros::crearCheckButtonsBootstrap($permisos->{'estantes_virtuales'}, 'estantes_virtuales');

    $t_params->{'permisos_estructura_catalogacion_n1'} = C4::AR::Filtros::crearCheckButtonsBootstrap($permisos->{'estructura_catalogacion_n1'}, 'estructura_catalogacion_n1');

    $t_params->{'permisos_estructura_catalogacion_n2'} = C4::AR::Filtros::crearCheckButtonsBootstrap($permisos->{'estructura_catalogacion_n2'}, 'estructura_catalogacion_n2');

    $t_params->{'permisos_estructura_catalogacion_n3'} = C4::AR::Filtros::crearCheckButtonsBootstrap($permisos->{'estructura_catalogacion_n3'}, 'estructura_catalogacion_n3');

    $t_params->{'permisos_tablas_de_refencia'} = C4::AR::Filtros::crearCheckButtonsBootstrap($permisos->{'tablas_de_refencia'}, 'tablas_de_refencia');
    
    $t_params->{'permisos_control_de_autoridades'} = C4::AR::Filtros::crearCheckButtonsBootstrap($permisos->{'control_de_autoridades'}, 'control_de_autoridades');

    $t_params->{'permisos_usuarios'} = C4::AR::Filtros::crearCheckButtonsBootstrap($permisos->{'usuarios'}, 'usuarios');

    $t_params->{'permisos_sistema'} = C4::AR::Filtros::crearCheckButtonsBootstrap($permisos->{'sistema'}, 'sistema');

    $t_params->{'permisos_undefined'} = C4::AR::Filtros::crearCheckButtonsBootstrap($permisos->{'undefined'}, 'undefined');
    
    if ($newUpdate){
        $t_params->{'nuevoPermiso'}=1;
    }

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
elsif ($accion eq "ACTUALIZAR_PERMISOS_CATALOGO"){

    my $nro_socio = $obj->{'nro_socio'};
    my $id_ui = $obj->{'id_ui'};
    my $tipo_documento = $obj->{'tipo_documento'};
    my $permisos = $obj->{'permisos'};

    my ($template, $session, $t_params)  = get_template_and_user({  
                            template_name => "admin/permisos/detalle_permisos_catalogo.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'MODIFICACION', 
                                                entorno => 'permisos', 
                                                tipo_permiso => 'general'
                            },
                            debug => 1,
                    });

      my ($Message_arrayref)= C4::AR::Permisos::actualizarPermisosCatalogo($nro_socio,$id_ui,$tipo_documento,$permisos);

      my $infoOperacionJSON=to_json $Message_arrayref;

      C4::AR::Auth::print_header($session);
      print $infoOperacionJSON;

}
elsif ($accion eq "NUEVO_PERMISO_CATALOGO"){

    my $nro_socio = $obj->{'nro_socio'};
    my $id_ui = $obj->{'id_ui'};
    my $tipo_documento = $obj->{'tipo_documento'};
    my $permisos = $obj->{'permisos'};

    my ($template, $session, $t_params)  = get_template_and_user({  
                            template_name => "admin/permisos/detalle_permisos_catalogo.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'ALTA', 
                                                entorno => 'permisos', 
                                                tipo_permiso => 'general'
                            },
                            debug => 1,
                    });

    
    my ($Message_arrayref)= C4::AR::Permisos::nuevoPermisoCatalogo($nro_socio,$id_ui,$tipo_documento,$permisos);

    my $infoOperacionJSON=to_json $Message_arrayref;
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}
elsif ($accion eq "SHOW_NUEVO_PERMISO_CATALOGO"){

    my ($template, $session, $t_params)  = get_template_and_user({  
                            template_name => "admin/permisos/detalle_permisos_catalogo.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'CONSULTA', 
                                                entorno => 'permisos', 
                                                tipo_permiso => 'general'
                            },
                            debug => 1,
                    });

    $t_params->{'nuevoPermiso'}=1;
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

} elsif ($accion eq "OBTENER_PERMISOS_GENERAL"){

    my $nro_socio = $obj->{'nro_socio'};
    my $id_ui = $obj->{'id_ui'};
    my $tipo_documento = $obj->{'tipo_documento'};

    my ($template, $session, $t_params)  = get_template_and_user({  
                        template_name => "admin/permisos/detalle_permisos_general.tmpl",
                        query => $input,
                        type => "intranet",
                        authnotrequired => 0,
                        flagsrequired => {  ui => 'ANY', 
                                            tipo_documento => 'ANY', 
                                            accion => 'CONSULTA', 
                                            entorno => 'permisos', 
                                            tipo_permiso => 'general'
                        },
                        debug => 1,
                    });
    my $perfil = $obj->{'perfil'} || 0;

    my ($permisos,$newUpdate) = C4::AR::Permisos::obtenerPermisosGenerales($nro_socio,$id_ui,$tipo_documento,$perfil);

    $t_params->{'permisos'}     = $permisos;

    if (!$permisos){
        $permisos = C4::AR::Permisos::armarPerfilGeneral('E');
        $permisos = C4::AR::Permisos::parsearPermisos($permisos);
    }
    
    $t_params->{'reportes'} = C4::AR::Filtros::crearCheckButtonsBootstrap($permisos->{'reportes'}, 'reportes');
    
    $t_params->{'preferencias'} = C4::AR::Filtros::crearCheckButtonsBootstrap($permisos->{'preferencias'}, 'preferencias');

    $t_params->{'permisosButton'} = C4::AR::Filtros::crearCheckButtonsBootstrap($permisos->{'permisos'}, 'permisos');

    $t_params->{'adq_opac'} = C4::AR::Filtros::crearCheckButtonsBootstrap($permisos->{'adq_opac'}, 'adq_opac');

    $t_params->{'adq_intra'} = C4::AR::Filtros::crearCheckButtonsBootstrap($permisos->{'adq_intra'}, 'adq_intra');

    if ($newUpdate){
        $t_params->{'nuevoPermiso'}=1;
    }
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

}
elsif ($accion eq "ACTUALIZAR_PERMISOS_GENERAL"){

    my $nro_socio = $obj->{'nro_socio'};
    my $id_ui = $obj->{'id_ui'};
    my $tipo_documento = $obj->{'tipo_documento'};
    my $permisos = $obj->{'permisos'};

    my ($template, $session, $t_params)  = get_template_and_user({  
                            template_name => "admin/permisos/detalle_permisos_catalogo.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'MODIFICACION', 
                                                entorno => 'permisos', 
                                                tipo_permiso => 'general'
                            },
                            debug => 1,
                    });

    my ($Message_arrayref)= C4::AR::Permisos::actualizarPermisosGeneral($nro_socio,$id_ui,$tipo_documento,$permisos);

    my $infoOperacionJSON=to_json $Message_arrayref;

    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}
elsif ($accion eq "NUEVO_PERMISO_GENERAL"){

    my $nro_socio = $obj->{'nro_socio'};
    my $id_ui = $obj->{'id_ui'};
    my $tipo_documento = $obj->{'tipo_documento'};
    my $permisos = $obj->{'permisos'};

    my ($template, $session, $t_params)  = get_template_and_user({  
                            template_name => "admin/permisos/detalle_permisos_catalogo.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'ALTA',   
                                                entorno => 'permisos', 
                                                tipo_permiso => 'general'
                            },
                            debug => 1,
                    });

    my ($Message_arrayref)= C4::AR::Permisos::nuevoPermisoGeneral($nro_socio,$id_ui,$tipo_documento,$permisos);

    my $infoOperacionJSON=to_json $Message_arrayref;

    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;

} elsif ($accion eq "SHOW_NUEVO_PERMISO_GENERAL"){

    my ($template, $session, $t_params)  = get_template_and_user({  
                            template_name => "admin/permisos/detalle_permisos_catalogo.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'CONSULTA', 
                                                entorno => 'permisos', 
                                                tipo_permiso => 'general'
                            },
                            debug => 1,
                    });

    $t_params->{'nuevoPermiso'}=1;
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

} elsif ($accion eq "OBTENER_PERMISOS_CIRCULACION"){

    my $nro_socio = $obj->{'nro_socio'};
    my $id_ui = $obj->{'id_ui'};
    my $tipo_documento = $obj->{'tipo_documento'};

    my ($template, $session, $t_params)  = get_template_and_user({  
                        template_name => "admin/permisos/detalle_permisos_circulacion.tmpl",
                        query => $input,
                        type => "intranet",
                        authnotrequired => 0,
                        flagsrequired => {  ui => 'ANY', 
                                            tipo_documento => 'ANY', 
                                            accion => 'CONSULTA', 
                                            entorno => 'permisos', 
                                            tipo_permiso => 'general'
                        },
                        debug => 1,
                    });
    my $perfil = $obj->{'perfil'} || 0;

    my ($permisos,$newUpdate) = C4::AR::Permisos::obtenerPermisosCirculacion($nro_socio,$id_ui,$tipo_documento,$perfil);

    $t_params->{'permisos'}     = $permisos;

    if (!$permisos){
        $permisos = C4::AR::Permisos::armarPerfilCirculacion('E');
        $permisos = C4::AR::Permisos::parsearPermisos($permisos);
    }
    
    $t_params->{'prestamos'} = C4::AR::Filtros::crearCheckButtonsBootstrap($permisos->{'prestamos'}, 'prestamos');

    $t_params->{'circ_opac'} = C4::AR::Filtros::crearCheckButtonsBootstrap($permisos->{'circ_opac'}, 'circ_opac');

    $t_params->{'circ_prestar'} = C4::AR::Filtros::crearCheckButtonsBootstrap($permisos->{'circ_prestar'}, 'circ_prestar');

    $t_params->{'circ_renovar'} = C4::AR::Filtros::crearCheckButtonsBootstrap($permisos->{'circ_renovar'}, 'circ_renovar');

    $t_params->{'circ_devolver'} = C4::AR::Filtros::crearCheckButtonsBootstrap($permisos->{'circ_devolver'}, 'circ_devolver');

    $t_params->{'circ_sanciones'} = C4::AR::Filtros::crearCheckButtonsBootstrap($permisos->{'circ_sanciones'}, 'circ_sanciones');

    if ($newUpdate){
        $t_params->{'nuevoPermiso'}=1;
    }

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

}
elsif ($accion eq "ACTUALIZAR_PERMISOS_CIRCULACION"){

    my $nro_socio = $obj->{'nro_socio'};
    my $id_ui = $obj->{'id_ui'};
    my $tipo_documento = $obj->{'tipo_documento'};
    my $permisos = $obj->{'permisos'};
    
    C4::AR::Debug::debug("entrooooooooooooooooooooooooooooooooooooooooooooooooo");

    my ($template, $session, $t_params)  = get_template_and_user({  
                            template_name => "admin/permisos/detalle_permisos_circulacion.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'MODIFICACION', 
                                                entorno => 'permisos', 
                                                tipo_permiso => 'general'
                            },
                            debug => 1,
                    });

    my ($Message_arrayref)= C4::AR::Permisos::actualizarPermisosCirculacion($nro_socio,$id_ui,$tipo_documento,$permisos);

    my $infoOperacionJSON=to_json $Message_arrayref;

    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}
elsif ($accion eq "NUEVO_PERMISO_CIRCULACION"){

    my $nro_socio = $obj->{'nro_socio'};
    my $id_ui = $obj->{'id_ui'};
    my $tipo_documento = $obj->{'tipo_documento'};
    my $permisos = $obj->{'permisos'};

    my ($template, $session, $t_params)  = get_template_and_user({  
                            template_name => "admin/permisos/detalle_permisos_circulacion.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'ALTA', 
                                                entorno => 'permisos', 
                                                tipo_permiso => 'general'
                            },
                            debug => 1,
                    });

    my ($Message_arrayref)= C4::AR::Permisos::nuevoPermisoCirculacion($nro_socio,$id_ui,$tipo_documento,$permisos);

    my $infoOperacionJSON=to_json $Message_arrayref;

    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;

}
elsif ($accion eq "SHOW_NUEVO_PERMISO_CIRCULACION"){

    my ($template, $session, $t_params)  = get_template_and_user({  
                            template_name => "admin/permisos/detalle_permisos_circulacion.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'CONSULTA', 
                                                entorno => 'permisos', 
                                                tipo_permiso => 'general'
                            },
                            debug => 1,
                    });

    $t_params->{'nuevoPermiso'}=1;
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
elsif ($accion eq "VER_PERMISOS_ACTUALES"){

    my $nro_socio = $obj->{'nro_socio'};
    my $socio = C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);
    my $id_ui = $obj->{'id_ui'} || $socio->getId_ui();
    my $tipo_documento = $obj->{'tipo_documento'};

    my ($template, $session, $t_params)  = get_template_and_user({  
                        template_name   => "admin/permisos/ver_permisos_actuales.tmpl",
                        query           => $input,
                        type            => "intranet",
                        authnotrequired => 0,
                        flagsrequired   => {  ui            => 'ANY', 
                                            tipo_documento  => 'ANY', 
                                            accion          => 'CONSULTA', 
                                            entorno         => 'permisos', 
                                            tipo_permiso    => 'general'
                        },
                        debug           => 1,
                    });
   
    $t_params->{'socio'}  = $socio;
    
    my $perfil                  =  0;
    my ($permisos,$newUpdate)   = C4::AR::Permisos::obtenerPermisosCatalogo($nro_socio,$id_ui,$tipo_documento,$perfil);
    if($permisos){
        $t_params->{'permisos_nivel1'} = C4::AR::Filtros::showPermisosActuales($permisos->{'datos_nivel1'}, 'datos_nivel1');
        $t_params->{'permisos_nivel2'} = C4::AR::Filtros::showPermisosActuales($permisos->{'datos_nivel2'}, 'datos_nivel2');
        $t_params->{'permisos_nivel3'} = C4::AR::Filtros::showPermisosActuales($permisos->{'datos_nivel3'}, 'datos_nivel3');
        $t_params->{'permisos_estantes_virtuales'} = C4::AR::Filtros::showPermisosActuales($permisos->{'estantes_virtuales'}, 'estantes_virtuales');
        $t_params->{'permisos_estructura_catalogacion_n1'} = C4::AR::Filtros::showPermisosActuales($permisos->{'estructura_catalogacion_n1'}, 'estructura_catalogacion_n1');
        $t_params->{'permisos_estructura_catalogacion_n2'} = C4::AR::Filtros::showPermisosActuales($permisos->{'estructura_catalogacion_n2'}, 'estructura_catalogacion_n2');
        $t_params->{'permisos_estructura_catalogacion_n3'} = C4::AR::Filtros::showPermisosActuales($permisos->{'estructura_catalogacion_n3'}, 'estructura_catalogacion_n3');
        $t_params->{'permisos_tablas_de_refencia'} = C4::AR::Filtros::showPermisosActuales($permisos->{'tablas_de_refencia'}, 'tablas_de_refencia');
        $t_params->{'permisos_control_de_autoridades'} = C4::AR::Filtros::showPermisosActuales($permisos->{'control_de_autoridades'}, 'control_de_autoridades');
        $t_params->{'permisos_usuarios'} = C4::AR::Filtros::showPermisosActuales($permisos->{'usuarios'}, 'usuarios');
        $t_params->{'permisos_sistema'} = C4::AR::Filtros::showPermisosActuales($permisos->{'sistema'}, 'sistema');
        $t_params->{'permisos_undefined'} = C4::AR::Filtros::showPermisosActuales($permisos->{'undefined'}, 'undefined');
    }

    my ($permisos,$newUpdate) = C4::AR::Permisos::obtenerPermisosCirculacion($nro_socio,$id_ui,$tipo_documento,$perfil);
    if($permisos){
        $t_params->{'prestamos'} = C4::AR::Filtros::showPermisosActuales($permisos->{'prestamos'}, 'prestamos');
        $t_params->{'circ_opac'} = C4::AR::Filtros::showPermisosActuales($permisos->{'circ_opac'}, 'circ_opac');
        $t_params->{'circ_prestar'} = C4::AR::Filtros::showPermisosActuales($permisos->{'circ_prestar'}, 'circ_prestar');
        $t_params->{'circ_renovar'} = C4::AR::Filtros::showPermisosActuales($permisos->{'circ_renovar'}, 'circ_renovar');
        $t_params->{'circ_devolver'} = C4::AR::Filtros::showPermisosActuales($permisos->{'circ_devolver'}, 'circ_devolver');
        $t_params->{'circ_sanciones'} = C4::AR::Filtros::showPermisosActuales($permisos->{'circ_sanciones'}, 'circ_sanciones');
    }

    my ($permisos,$newUpdate) = C4::AR::Permisos::obtenerPermisosGenerales($nro_socio,$id_ui,$tipo_documento,$perfil);
    if ($permisos){
        $t_params->{'reportes'} = C4::AR::Filtros::showPermisosActuales($permisos->{'reportes'}, 'reportes');
        $t_params->{'preferencias'} = C4::AR::Filtros::showPermisosActuales($permisos->{'preferencias'}, 'preferencias');
        $t_params->{'permisosButton'} = C4::AR::Filtros::showPermisosActuales($permisos->{'permisos'}, 'permisos');
        $t_params->{'adq_opac'} = C4::AR::Filtros::showPermisosActuales($permisos->{'adq_opac'}, 'adq_opac');
        $t_params->{'adq_intra'} = C4::AR::Filtros::showPermisosActuales($permisos->{'adq_intra'}, 'adq_intra');
    }

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}