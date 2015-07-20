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
use C4::Output;
use JSON;
use C4::AR::Busquedas;
use Time::HiRes;
use Encode;
use URI::Escape;
use C4::AR::PdfGenerator;

my $input                   = new CGI;
my $string                  = ($input->param('string')) || "";
my $to_pdf;


if ($input->param('export')== "1"){
	$to_pdf                  = $input->param('export');
} else{
	$to_pdf = undef;
}


my ($template, $session, $t_params);


#se escapea algun tag html si existe, evita XSS 
#Guardo los parametros q vienen por URL
my $obj; 
$obj->{'string'}            = $string;
$obj->{'keyword'}           = $obj->{'string'};
$obj->{'tipoAccion'}        = CGI::escapeHTML($input->param('tipoAccion'));
$obj->{'titulo'}            = ($input->param('titulo'));
$obj->{'autor'}             = ($input->param('autor'));
$obj->{'isbn'}              = ($input->param('isbn'));
$obj->{'estantes'}          = ($input->param('estantes'));
$obj->{'estantes_grupo'}    = CGI::escapeHTML($input->param('estantes_grupo'));
$obj->{'tema'}              = ($input->param('tema'));
$obj->{'tipo'}              = ($input->param('tipo'));    
$obj->{'only_available'}    = CGI::escapeHTML($input->param('only_available')) || 0;
$obj->{'from_suggested'}    = CGI::escapeHTML($input->param('from_suggested'));
$obj->{'tipo_nivel3_name'}  = ($input->param('tipo_nivel3_name'));
$obj->{'tipoBusqueda'}      = 'all';
$obj->{'token'}             = CGI::escapeHTML($input->param('token'));
$obj->{'orden'}             = $input->param('orden')|| undef;
$obj->{'primera_vez'}       = $input->param('primera_vez') || "2";



if ($obj->{'primera_vez'} eq "2"){
		  $obj->{'sentido_orden'}   = 0;
		  $obj->{'primera_vez'} = "1";
} else {
		  $obj->{'sentido_orden'}     = $input->param('sentido_orden');
} 

C4::AR::Validator::validateParams('U389',$obj,['tipoAccion']);

#se corta el parametro page en 6 numeros nada mas, sino rompe error 500
my $page                    = ($input->param('page'));
my $ini                     = $obj->{'ini'} = substr($page,0,5);

#se toma el tiempo de inicio de la búsqueda
my $start                   = [ Time::HiRes::gettimeofday() ]; 

my $cantidad;
my $suggested;
my $resultsarray;

$obj->{'type'}              = 'OPAC';
$obj->{'session'}           = $session;

my ($ini,$pageNumber,$cantR)= C4::AR::Utilidades::InitPaginador($ini);

#actualizamos el ini del $obj para que pagine correctamente
$obj->{'ini'}               = $ini;
$obj->{'cantR'}             = $cantR;

# Se filtran los registros sin disponibilidad?

my %sphinx_options;
$sphinx_options{'opac_only_state_available'} 	= C4::AR::Preferencias::getValorPreferencia('opac_only_state_available');
$obj->{'opac_only_state_available'}             = $sphinx_options{'opac_only_state_available'};

C4::AR::Debug::debug("SOLO DISPONIBLES EN OPAC?? ".$sphinx_options{'opac_only_state_available'});

my $url;
my $url_todos;
my $token;

if ($to_pdf){

	$obj->{'ini'}               = 0;
	$obj->{'cantR'}             = "";
	($template, $session, $t_params) = get_template_and_user({
							template_name => "includes/opac-busquedaResult_XLS.inc",
							query => $input,
							type => "opac",
							authnotrequired => 1,
							flagsrequired => {  ui => 'ANY', 
												tipo_documento => 'ANY', 
												accion => 'CONSULTA', 
												entorno => 'undefined'},
		 
	 });


	($cantidad, $resultsarray)=C4::AR::Busquedas::busquedaSinPaginar($session, $obj);


	$t_params->{'SEARCH_RESULTS'}       = $resultsarray;
	$t_params->{'cantidad'}             = $cantidad;
	$t_params->{'exported'}             = 1;

	my $out= C4::AR::Auth::get_html_content($template, $t_params);
	my $filename= C4::AR::PdfGenerator::pdfFromHTML($out);
	print C4::AR::PdfGenerator::pdfHeader();
	C4::AR::PdfGenerator::printPDF($filename);

} else {
	($template, $session, $t_params)    = get_template_and_user({
			  template_name   => "opac-main.tmpl",
			  query           => $input,
			  type            => "opac",
			  authnotrequired => 1,
			  flagsrequired   => {  ui            => 'ANY', 
								  tipo_documento  => 'ANY', 
								  accion          => 'CONSULTA', 
								  entorno         => 'undefined'},
	});

	if  ($obj->{'tipoAccion'} eq 'BUSQUEDA_AVANZADA'){

		if ($obj->{'estantes'}){

			#Busqueda por Estante Virtual
			$url = C4::AR::Utilidades::getUrlPrefix()."/opac-busquedasDB.pl?token=".$obj->{'token'}."&estantes=".$obj->{'estantes'}."&tipoAccion=".$obj->{'tipoAccion'};

			$url_todos = C4::AR::Utilidades::getUrlPrefix()."/opac-busquedasDB.pl?token=".$obj->{'token'};

			$url_todos = C4::AR::Utilidades::addParamToUrl($url_todos,"estantes",$obj->{'estantes'});
			$url_todos = C4::AR::Utilidades::addParamToUrl($url_todos,"tipoAccion",$obj->{'tipoAccion'});

			($cantidad, $resultsarray)   = C4::AR::Busquedas::busquedaPorEstante($obj->{'estantes'}, $session, $obj);

			#Sino queda en el buscoPor
			$obj->{'tipo_nivel3_name'} = -1; 
		  } else {
				if($obj->{'estantes_grupo'}){

					#Busqueda por Estante Virtual
					$url = C4::AR::Utilidades::getUrlPrefix()."/opac-busquedasDB.pl?token=".$obj->{'token'}."&estantes_grupo=".$obj->{'estantes_grupo'}."&tipoAccion=".$obj->{'tipoAccion'};
					$url_todos = C4::AR::Utilidades::getUrlPrefix()."/opac-busquedasDB.pl?token=".$obj->{'token'};
				
					$url_todos = C4::AR::Utilidades::addParamToUrl($url_todos,"estantes_grupo",$obj->{'estantes_grupo'});
					$url_todos = C4::AR::Utilidades::addParamToUrl($url_todos,"tipoAccion",$obj->{'tipoAccion'});
				
					($cantidad, $resultsarray)   = C4::AR::Busquedas::busquedaEstanteDeGrupo($obj->{'estantes_grupo'}, $session, $obj);
				
					my $nivel_1= C4::AR::Nivel1::getNivel1FromId2($obj->{'estantes_grupo'});

					$obj->{'titulo_nivel_1'} = $nivel_1->getTitulo;

					#Sino queda en el buscoPor
					$obj->{'tipo_nivel3_name'} = -1; 
				
				} else {
			
					$url = C4::AR::Utilidades::getUrlPrefix()."/opac-busquedasDB.pl?token=".$obj->{'token'}."&titulo=".$obj->{'titulo'}."&autor=".$obj->{'autor'}."&tipo=".$obj->{'tipo'}."&tipo_nivel3_name=".$obj->{'tipo_nivel3_name'}."&tipoAccion=".$obj->{'tipoAccion'}."&only_available=".$obj->{'only_available'};
					$url_todos = C4::AR::Utilidades::getUrlPrefix()."/opac-busquedasDB.pl?token=".$obj->{'token'};
					

					$url = C4::AR::Utilidades::addParamToUrl($url,"titulo",$obj->{'titulo'});
					$url = C4::AR::Utilidades::addParamToUrl($url,"tipo_nivel3_name",$obj->{'tipo_nivel3_name'});
					$url = C4::AR::Utilidades::addParamToUrl($url,"tipoAccion",$obj->{'tipoAccion'});
					$url = C4::AR::Utilidades::addParamToUrl($url,"isbn",$obj->{'isbn'});
					$url = C4::AR::Utilidades::addParamToUrl($url,"tema",$obj->{'tema'});
					$url = C4::AR::Utilidades::addParamToUrl($url,"autor",$obj->{'autor'});
					$url = C4::AR::Utilidades::addParamToUrl($url,"orden",$obj->{'orden'});
					$url = C4::AR::Utilidades::addParamToUrl($url,"sentido_orden",$obj->{'sentido_orden'});
					$url = C4::AR::Utilidades::addParamToUrl($url,"only_available",$obj->{'only_available'});

					$url_todos = C4::AR::Utilidades::addParamToUrl($url_todos,"titulo",$obj->{'titulo'});
					$url_todos = C4::AR::Utilidades::addParamToUrl($url_todos,"tipo_nivel3_name",$obj->{'tipo_nivel3_name'});
					$url_todos = C4::AR::Utilidades::addParamToUrl($url_todos,"tipoAccion",$obj->{'tipoAccion'});
					$url_todos = C4::AR::Utilidades::addParamToUrl($url_todos,"isbn",$obj->{'isbn'});
					$url_todos = C4::AR::Utilidades::addParamToUrl($url_todos,"tema",$obj->{'tema'});
					$url_todos = C4::AR::Utilidades::addParamToUrl($url_todos,"autor",$obj->{'autor'});
					$url_todos = C4::AR::Utilidades::addParamToUrl($url_todos,"orden",$obj->{'orden'});
					$url_todos = C4::AR::Utilidades::addParamToUrl($url_todos,"sentido_orden",$obj->{'sentido_orden'});
					$url_todos = C4::AR::Utilidades::addParamToUrl($url_todos,"only_available",0);
					$url_todos = C4::AR::Utilidades::addParamToUrl($url_todos,"tipo",$obj->{'tipo'});
					
					#para que limite los resultados
					$obj->{'only_sphinx'} = 1;
					
					($cantidad, $resultsarray)= C4::AR::Busquedas::busquedaAvanzada_newTemp($obj,$session);
				}
		}      
	}  else {

		$url = C4::AR::Utilidades::getUrlPrefix()."/opac-busquedasDB.pl?token=".$obj->{'token'}."&string=".$obj->{'string'}."&tipoAccion=".$obj->{'tipoAccion'}."&only_available=".$obj->{'only_available'}."&orden=".$obj->{'orden'}."&sentido_orden=".$obj->{'sentido_orden'};
		$url_todos = C4::AR::Utilidades::getUrlPrefix()."/opac-busquedasDB.pl?token=".$obj->{'token'}."&string=".$obj->{'string'}."&tipoAccion=".$obj->{'tipoAccion'};

		($cantidad, $resultsarray,$suggested)  = C4::AR::Busquedas::busquedaCombinada_newTemp($string,$session,$obj,\%sphinx_options);   

	} 

		if ($obj->{'estantes'}||$obj->{'estantes_grupo'}){
		
			$t_params->{'partial_template'}     = "opac-busquedaEstantes.inc";

		}else{
				
			$t_params->{'partial_template'}     = "opac-busquedaResult.inc";
			$t_params->{'search_term'}          = $obj->{'string'};
		}

		$t_params->{'suggested'}                = $suggested;
		$t_params->{'tipoAccion'}               = $obj->{'tipoAccion'};
		$t_params->{'url_todos'}                = $url_todos;
		$t_params->{'only_available'}           = $obj->{'only_available'};
		$t_params->{'paginador'}                = C4::AR::Utilidades::crearPaginadorOPAC($cantidad,$cantR, $pageNumber,$url,$t_params);

		$t_params->{'combo_tipo_documento'}     = C4::AR::Utilidades::generarComboTipoNivel3();

		my $elapsed                             = Time::HiRes::tv_interval( $start );

		$t_params->{'timeSeg'}                  = $elapsed;
		$obj->{'nro_socio'}                     = $session->param('nro_socio');
		$t_params->{'SEARCH_RESULTS'}           = $resultsarray;
		$obj->{'keyword'}                       = $obj->{'string'};
		$t_params->{'keyword'}                  = $obj->{'string'};

		if ($obj->{'tipoAccion'} eq 'BUSQUEDA_AVANZADA'){
			$t_params->{'buscoPor'}                 = C4::AR::Busquedas::armarBuscoPor($obj);
		}

		$t_params->{'cantidad'}                 = $cantidad || 0;
		$t_params->{'show_search_details'}      = 1;


		# Se usan para poder ordenar la tabla segun el campo seleccionado (se pasan todos para poder realizar la busqueda por los mismos criterios)
		$t_params->{'tipoAccion'}   = $obj->{'tipoAccion'};
		$t_params->{'titulo'}       = $obj->{'titulo'}; 
		$t_params->{'autor'}        = $obj->{'autor'}; 
		$t_params->{'isbn'}         = $obj->{'isbn'};
		$t_params->{'estantes'}     = $obj->{'estantes'};
		$t_params->{'estantes_grupo'}     = $obj->{'estantes_grupo'}; 
		$t_params->{'tema'}     = $obj->{'tema'};
		$t_params->{'tipo'}     = $obj->{'tipo'}; 
		$t_params->{'only_available'}     = $obj->{'only_available'} || 0;
		$t_params->{'from_suggested'}     = $obj->{'from_suggested'};
		$t_params->{'tipo_nivel3_name'}   = $obj->{'tipo_nivel3_name'};
		$t_params->{'tipoBusqueda'}   = $obj->{'tipoBusqueda'};
		$t_params->{'token'}   = $obj->{'token'};
		$t_params->{'orden'}   = $obj->{'orden'};   
		$t_params->{'primera_vez'}   = $obj->{'primera_vez'}; 
		$t_params->{'sentido_orden'}   = $obj->{'sentido_orden'};   
		
		C4::AR::Debug::debug($t_params->{'sentido_orden'});
		C4::AR::Debug::debug( $t_params->{'primera_vez'} );
		C4::AR::Debug::debug($t_params->{'orden'});

		$t_params->{'pdf_titulo'}             = $obj->{'titulo'};
		$t_params->{'pdf_autor'}              = $obj->{'autor'};
		$t_params->{'pdf_isbn'}               = $obj->{'isbn'};
		$t_params->{'pdf_estantes'}           = $obj->{'estantes'};
		$t_params->{'pdf_estantes_grupo'}     = $obj->{'estantes_grupo'};
		$t_params->{'pdf_tipo'}               = $obj->{'tipo'};
		$t_params->{'pdf_onlyAvailable'}      = $obj->{'only_available'};
		$t_params->{'pdf_tipo_nivel3_name'}   = $obj->{'tipo_nivel3_name'};
		$t_params->{'pdf_token'}              = $obj->{'token'};

		$t_params->{'external_search'}          = C4::AR::Preferencias::getValorPreferencia('external_search') || 0;
		
		my $cant_servidores =   $t_params->{'cant_external_servers'} = $t_params->{'external_search'}?C4::AR::Busquedas::cantServidoresExternos():0;

		if ($cant_servidores){
			$t_params->{'external_servers'} = C4::AR::Busquedas::getServidoresExternos();
		}
		
		$t_params->{'show_search_details'}      = 1;

		C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
