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
use JSON;

my $input           = new CGI;
my $obj             = $input->param('obj');
$obj                = C4::AR::Utilidades::from_json_ISO($obj);
my $tabla           = $obj->{'tabla'};
my $tipo            = $obj->{'tipo'};
my $accion          = $obj->{'accion'};
my $authnotrequired = 0;


if($accion eq "BUSCAR_PREFERENCIAS"){
#Busca las preferencias segun lo ingresado como parametro y luego las muestra

my ($template, $session, $t_params)  = get_template_and_user({
                        	template_name   => "admin/global/preferenciasResults.tmpl",
							query           => $input,
							type            => "intranet",
							authnotrequired => 0,
							flagsrequired   => {    ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
		                                            entorno => 'preferencias',
		                                            tipo_permiso => 'general'
							},
							debug           => 1,
			     });

	my $buscar                  = $obj->{'buscar'};
	my $orden                   = $obj->{'orden'};
	my $categoria               = $obj->{'categoria'};
	my ($cant,$preferencias)    = C4::AR::Preferencias::getPreferenciaLikeConCategoria($buscar,$orden,$categoria);
	$t_params->{'preferencias'} = $preferencias;
	$t_params->{'cant'}         = $cant;
	
	C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}#end if($accion eq "BUSCAR_PREFERENCIAS")

if($accion eq "MODIFICAR_VARIABLE"){
#Muestra el tmpl para modificar una preferencias

    my ($template, $session, $t_params) = get_template_and_user({
				template_name   => "admin/global/modificarPreferencia.tmpl",
				query           => $input,
				type            => "intranet",
				authnotrequired => 0,
				flagsrequired   => { 
					                                   ui => 'ANY', 
				                                       tipo_documento => 'ANY', 
				                                       accion => 'MODIFICACION', 
					                                   entorno => 'preferencias',
                                                       tipo_permiso => 'general'
},
				debug           => 1,
				});

	my $infoVar;
	my $valor       = "";
	my $op          = "";
	my $campo       = "";
	my $categoria   = $obj->{'categoria'}||"";
	my $variable    = $obj->{'variable'};
	$infoVar        = C4::AR::Preferencias::getPreferencia(&C4::AR::Utilidades::trim($variable));
	
	if($infoVar){
	    $valor      = $infoVar->getValue;
	    $op         = $infoVar->getOptions;
	    my $tipo    = $infoVar->getType;
	    
	    if($op ne ""){		    
		    if($tipo eq "referencia"){	    
		            my @array;
				    @array = split(/\|/,$op);
				    $tabla = $array[0];
				    $campo = $array[1];			    
			}
			elsif($tipo eq "valAuto"){
		            $categoria=$op
		    }
	    }
	
	    $t_params->{'variable'}     = &C4::AR::Utilidades::trim($variable);
	    $t_params->{'explicacion'}  = &C4::AR::Utilidades::trim($infoVar->getExplanation);
	    $t_params->{'tabla'}        = $tabla;
	    $t_params->{'categoria'}    = $categoria;
	    $t_params->{'campo'}        = $campo;

	    my $nuevoCampo;
	    my %labels;
	    my @values;
	
	    if($tipo eq "bool"){
		    push(@values,1);
		    push(@values,0);
		    $labels{1}  = "Si";
		    $labels{0}  = "No";
		    $nuevoCampo = &C4::AR::Utilidades::crearComponentes("radio","valor",\@values,\%labels,$valor);
	    }
	    elsif($tipo eq "texta"){
		    $nuevoCampo = &C4::AR::Utilidades::crearComponentes("texta","valor",58,4,$valor);
	    }
	    elsif($tipo eq "valAuto"){
		    %labels     = &C4::AR::Utilidades::obtenerDatosValorAutorizado($categoria);
		    @values     = keys(%labels);
		    $nuevoCampo = &C4::AR::Utilidades::crearComponentes("combo","valor",\@values,\%labels,$valor);
		    $t_params->{'categoria'} = $categoria;

	    }
	    elsif($tipo eq "referencia"){
		    my $orden = $campo;
		    my ($cantidad,$valores) = &C4::AR::Referencias::obtenerValoresTablaRef($tabla,$campo,$orden);
		    foreach my $val(@$valores){
			    $labels{$val->{"clave"}} = $val->{"valor"};	
			    push(@values,$val->{"clave"});
		    }
		    $nuevoCampo = &C4::AR::Utilidades::crearComponentes("combo","valor",\@values,\%labels,$valor);
		    $t_params->{'tabla'} = $tabla;
		    $t_params->{'campo'} = $campo;

	    }	elsif($tipo eq "text"){
		    $nuevoCampo = &C4::AR::Utilidades::crearComponentes("text","valor",50,0,$valor);
	    }

	    $t_params->{'tipo'}  = $tipo;
	    $t_params->{'valor'} = $nuevoCampo;

	    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
	}#No existe la variable
	else{
	    my $msg_object = C4::AR::Mensajes::create();
	    $msg_object->{'error'}= 1;
	    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP006', 'params' => []} ) ;
	    my $infoOperacionJSON = to_json $msg_object;
        C4::AR::Auth::print_header($session);
    	print $infoOperacionJSON;
	}
} #end if($accion eq "MODIFICAR_VARIABLE")

if($accion eq "GUARDAR_MODIFICACION_VARIABLE"){
#Guarda la modificacion realizada a la preferencia
    my ($userid, $session, $flags) = checkauth(   $input, 
                                            $authnotrequired, 
                                            {   ui              => 'ANY', 
                                                tipo_documento  => 'ANY', 
                                                accion          => 'MODIFICACION', 
                                                entorno => 'preferencias',
                                                tipo_permiso => 'general'
                                            }, 
                                            'intranet'
                                    );



 	my $variable    = $obj->{'variable'};
 	my $valor       = &C4::AR::Utilidades::trim($obj->{'valor'});
 	my $expl        = $obj->{'explicacion'};
    my $categoria   = $obj->{'categoria'};

	my $Message_arrayref  = C4::AR::Preferencias::t_modificarVariable($variable,$valor,$expl,$categoria);
    
    my $infoOperacionJSON = to_json $Message_arrayref;
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;

} #end GUARDAR_MODIFICACION_VARIABLE

if($accion eq "SELECCION_CAMPO"){
    my ($userid, $session, $flags)= checkauth(   $input, 
                                            $authnotrequired, 
                                            {   ui              => 'ANY', 
                                                tipo_documento  => 'ANY', 
                                                accion          => 'CONSULTA', 
                                                entorno => 'preferencias',
                                                tipo_permiso => 'general'
                                            }, 
                                            'intranet'
                                    );


	my $guardar = $obj->{'guardar'};
	my $tipo    = $obj->{'tipo'};
	my $strjson = "";
	if($tipo eq "referencia"){
		if($tabla){
		#Se buscan los campos de la tabla seleccionada
		my $campos = &C4::AR::Referencias::getCamposDeTablaRef($tabla);
		$strjson   = C4::AR::Utilidades::arrayToJSONString($campos);
		}
		else{
		#Se buscan las tablas de referencia
			my $tablas = &C4::AR::Referencias::obtenerTablasDeReferencia();
			$strjson   = C4::AR::Utilidades::arrayObjectsToJSONString($tablas);
		}
	}
	else{
		#Se buscan los valores autorizados
		my $valAuto = &C4::AR::Utilidades::obtenerValoresAutorizados();
		$strjson    = C4::AR::Utilidades::arrayObjectsToJSONString($valAuto);

	}
    C4::AR::Auth::print_header($session);
	print $strjson;
}#end SELECCION_CAMPO

if($accion eq "NUEVA_VARIABLE"){
#Muestra el tmpl para agregar una preferencias

my ($template, $session, $t_params) = 
	get_template_and_user({
				template_name   => "admin/global/modificarPreferencia.tmpl",
				query           => $input,
				type            => "intranet",
				authnotrequired => 0,
				flagsrequired   => {    ui => 'ANY', 
                                        tipo_documento => 'ANY', 
                                        accion => 'ALTA', 
                                        entorno => 'preferencias',
                                        tipo_permiso => 'general'
				},
				debug           => 1,
				});



	my $valor = "";
	my $op    = "";
	my $nuevoCampo;
	my %labels;
	my @values;
	
	if($tipo eq "bool"){
		push(@values,1);
		push(@values,0);
		$labels{1}  = "Si";
		$labels{0}  = "No";
		$nuevoCampo = &C4::AR::Utilidades::crearComponentes("radio","valor",\@values,\%labels,$valor);
	}
	elsif($tipo eq "texta"){
		$nuevoCampo = &C4::AR::Utilidades::crearComponentes("texta","valor",60,4,$valor);
	}
	elsif($tipo eq "valAuto"){
		my $categoria = $obj->{'categoria'}||$op;
		%labels       = &C4::AR::Utilidades::obtenerDatosValorAutorizado($categoria);
		@values       = keys(%labels);
		$nuevoCampo   = &C4::AR::Utilidades::crearComponentes("combo","valor",\@values,\%labels,$valor);
		$t_params->{'categoria'} = $categoria;
	}
	elsif($tipo eq "referencia"){
		my $campo = $obj->{'campo'}||$op;
		my $orden = $campo;
		my ($cantidad,$valores) = &C4::AR::Referencias::obtenerValoresTablaRef($tabla,$campo,$orden);
		foreach my $val(@$valores){
			$labels{$val->{"clave"}} = $val->{"valor"};	
			push(@values,$val->{"clave"});
		}
		$nuevoCampo = &C4::AR::Utilidades::crearComponentes("combo","valor",\@values,\%labels,$valor);
		$t_params->{'tabla'} = $tabla;
		$t_params->{'campo'} = $campo;
	}	elsif($tipo eq "text"){
		$nuevoCampo = &C4::AR::Utilidades::crearComponentes("text","valor",60);
	}

    $t_params->{'tipo'}  = $tipo;
    $t_params->{'nueva'} = 1;
	$t_params->{'valor'} = $nuevoCampo;

	C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}#end NUEVA_VARIABLE


if($accion eq "GUARDAR_NUEVA_VARIABLE"){
    my ($userid, $session, $flags)= checkauth(   $input, 
                                            $authnotrequired, 
                                            {   ui              => 'ANY', 
                                                tipo_documento  => 'ANY', 
                                                accion          => 'ALTA', 
                                                entorno => 'preferencias',
                                                tipo_permiso => 'general'
                                            }, 
                                            'intranet'
                                    );


#Se guarda la nueva preferencias

	my $variable = $obj->{'variable'};
	my $valor    = &C4::AR::Utilidades::trim($obj->{'valor'});
	my $expl     = &C4::AR::Utilidades::trim($obj->{'explicacion'});
	my $opciones = "";

	if($tipo eq "referencia"){$opciones=$obj->{'tabla'}."|".$obj->{'campo'};}

	if($tipo eq "valAuto"){ $opciones=$obj->{'categoria'};}

	my $Message_arrayref = C4::AR::Preferencias::t_guardarVariable($variable,$valor,$expl,$tipo,$opciones);
 
	my $infoOperacionJSON = to_json $Message_arrayref;

    C4::AR::Auth::print_header($session);
	print $infoOperacionJSON;

}#end GUARDAR_NUEVA_VARIABLE

if($accion eq "ACTUALIZAR_TABLA_CATALOGO"){

    my ($template, $session, $t_params) = 
	                                get_template_and_user({
				                                template_name   => "admin/global/catalogoResultConfig.tmpl",
				                                query           => $input,
				                                type            => "intranet",
				                                authnotrequired => 0,
				                                flagsrequired   => {    ui => 'ANY', 
                                                                        tipo_documento => 'ANY', 
                                                                        accion => 'CONSULTA', 
                                                                        entorno => 'preferencias',
                                                                        tipo_permiso => 'general'
				                                },
				                                debug           => 1,
				                                });

    my $preferencias_catalogo       = C4::AR::Preferencias::getPreferenciasByCategoria('catalogo');
    $t_params->{'preferencias'}     = $preferencias_catalogo;
    $t_params->{'page_sub_title'}   = C4::AR::Filtros::i18n("Preferencias del Cat&aacute;logo");  
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}#end ACTUALIZAR_TABLA_CATALOGO

if($accion eq "ACTUALIZAR_TABLA_CIRCULACION"){

    my ($template, $session, $t_params) = 
	                                get_template_and_user({
				                                template_name   => "admin/global/circResultConfig.tmpl",
				                                query           => $input,
				                                type            => "intranet",
				                                authnotrequired => 0,
				                                flagsrequired   => {    ui => 'ANY', 
                                                                        tipo_documento => 'ANY', 
                                                                        accion => 'CONSULTA', 
					                                                    entorno => 'preferencias',
					                                                    tipo_permiso => 'general'
				                                },
				                                debug           => 1,
				                                });

    my $preferencias_circulacion       = C4::AR::Preferencias::getPreferenciasByCategoria('circulacion');
    $t_params->{'preferencias'}        = $preferencias_circulacion;
    $t_params->{'page_sub_title'}      = C4::AR::Filtros::i18n("Preferencias de Circulaci&oacute;n");  
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}#end ACTUALIZAR_TABLA_CIRCULACION