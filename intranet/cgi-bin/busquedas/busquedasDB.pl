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
use JSON;
use Time::HiRes;
use CGI;
use C4::AR::Busquedas qw(busquedaPorBarcode armarBuscoPor busquedaCombinada_newTemp);

my $input           = new CGI;

my $template_name   = 'busquedas/busquedaResult.tmpl';

my $authnotrequired = 0;
my $obj             = $input->param('obj');
$obj                = C4::AR::Utilidades::from_json_ISO($obj);

#si se rompio C4::AR::Utilidades::from_json_ISO viene un 0
#solo lo hacemos con una linea y ya basta
eval{    
    my $ini             = $obj->{'ini'};     
};

if($@){
    C4::AR::Utilidades::redirectAndAdvice('B460');
}

    my $ini             = $obj->{'ini'};     
    my $orden           = $obj->{'orden'};
    my $sentido_orden   = $obj->{'sentido_orden'};
    my $tipoAccion      = $obj->{'tipoAccion'}||"";




    if($tipoAccion eq "BUSQUEDA_POR_ESTANTE"){
       $template_name = 'busquedas/estante.tmpl';
    } elsif ($tipoAccion eq "BUSQUEDA_ESTANTE_DE_GRUPO"){
       $template_name = 'estantes/estantesGrupo.tmpl';
    }   

    my ($template, $session, $t_params) = get_template_and_user ({
                                template_name   => $template_name,
                                query           => $input,
                                type            => "intranet",
                                authnotrequired => 0,
                                flagsrequired   =>  {   ui              => 'ANY', 
                                                        tipo_documento  => 'ANY', 
                                                        accion          => 'CONSULTA', 
                                                        entorno         => 'undefined'},
                            });


    $t_params->{'orden'}  = $orden;
    $t_params->{'sentido_orden'}  = $sentido_orden;
  
    my $start                   = [ Time::HiRes::gettimeofday( ) ]; #se toma el tiempo de inicio de la busqueda
    my $dateformat              = C4::Date::get_date_format();
    my ($ini,$pageNumber,$cantR)= C4::AR::Utilidades::InitPaginador($ini);

    $t_params->{'ini'}          = $obj->{'ini'} = $ini;
    $t_params->{'cantR'}        = $obj->{'cantR'} = $cantR;
    $obj->{'type'}              = 'INTRA';

    my $only_available          = $obj->{'only_available'};

    if (C4::AR::Utilidades::validateString($tipoAccion)){
        if($tipoAccion eq "BUSQUEDA_POR_AUTOR"){

    #       $t_params->{'com'}            = $obj->{'completo'};
          $t_params->{'session'}            = $session;
          my ($cantidad, $resultId1)        = C4::AR::Busquedas::filtrarPorAutor($obj, $session);
          $t_params->{'paginador'}          = C4::AR::Utilidades::crearPaginador($cantidad,$cantR, $pageNumber,$obj->{'funcion'},$t_params);
          $t_params->{'cantidad'}           = $cantidad;  
          $t_params->{'SEARCH_RESULTS'}     = $resultId1;

        }elsif($tipoAccion eq "BUSQUEDA_COMBINADA"){
        
            my $outside                     = $input->param('outside');
            my $keyword                     = $obj->{'keyword'};
            my $tipo_documento              = $obj->{'tipo_nivel3_name'};
            
            my $search;
            $search->{'keyword'}            = $keyword;
            $search->{'class'}              = $tipo_documento;
            my %sphinx_options              = {};

            $sphinx_options{'only_sphinx'}       = 0;
            $sphinx_options{'only_available'}    = $only_available;
            
            my ($cantidad, $resultId1, $suggested)      = C4::AR::Busquedas::busquedaCombinada_newTemp($search->{'keyword'}, $session, $obj,\%sphinx_options);
            $t_params->{'paginador'}        = C4::AR::Utilidades::crearPaginador($cantidad, $cantR, $pageNumber, $obj->{'funcion'}, $t_params);
            $t_params->{'suggested'}        = $suggested;

            $t_params->{'SEARCH_RESULTS'}   = $resultId1;
            $t_params->{'cantidad'}         = $cantidad;
            if($outside) {
                $t_params->{'HEADERS'}      = 1;
            }
            
        }elsif($tipoAccion eq "BUSQUEDA_AVANZADA"){

        my $funcion                     = $obj->{'funcion'};
        my $ini                         = ($obj->{'ini'}||'');
        $obj->{'only_sphinx'}           = 1;

        my ($cantidad, $array_nivel1)   = C4::AR::Busquedas::busquedaAvanzada_newTemp($obj, $session);
            
        $obj->{'cantidad'}              = $cantidad;
        $t_params->{'paginador'}        = C4::AR::Utilidades::crearPaginador($cantidad,$cantR, $pageNumber,$funcion,$t_params);
        $t_params->{'SEARCH_RESULTS'}   = $array_nivel1;
            $t_params->{'cantidad'}         = $cantidad;
            $t_params->{'signatura_filter'} = $obj->{'signatura'} || 0;

        }elsif($tipoAccion eq "BUSQUEDA_POR_BARCODE"){
            my $funcion                     = $obj->{'funcion'};
            my $ini                         = ($obj->{'ini'}||'');
            $obj->{'only_sphinx'}           = 1;
            
            my ($cantidad, $array_nivel1)   = C4::AR::Busquedas::busquedaAvanzada_newTemp($obj, $session);
            
            $obj->{'cantidad'}              = $cantidad;
            $t_params->{'paginador'}        = C4::AR::Utilidades::crearPaginador($cantidad,$cantR, $pageNumber,$funcion,$t_params);
            $t_params->{'SEARCH_RESULTS'}   = $array_nivel1;
            $t_params->{'cantidad'}         = $cantidad;

        }elsif($tipoAccion eq "BUSQUEDA_POR_ISBN"){
            my $funcion                     = $obj->{'funcion'};
            my $ini                         = ($obj->{'ini'}||'');
            
            my ($cantidad, $array_nivel1)   = C4::AR::Busquedas::busquedaPorISBN($obj->{'isbn'}, $session, $obj);
            
            $obj->{'cantidad'}              = $cantidad;
            $t_params->{'paginador'}        = C4::AR::Utilidades::crearPaginador($cantidad,$cantR, $pageNumber,$funcion,$t_params);
            $t_params->{'SEARCH_RESULTS'}   = $array_nivel1;
            $t_params->{'cantidad'}         = $cantidad;

        }elsif($tipoAccion eq "BUSQUEDA_POR_TEMA"){
            my $funcion                     = $obj->{'funcion'};
            my $ini                         = ($obj->{'ini'}||'');
            $obj->{'only_sphinx'}           = 1;
            
            my ($cantidad, $array_nivel1)   = C4::AR::Busquedas::busquedaAvanzada_newTemp($obj, $session);
            
            $obj->{'cantidad'}              = $cantidad;
            $t_params->{'paginador'}        = C4::AR::Utilidades::crearPaginador($cantidad,$cantR, $pageNumber,$funcion,$t_params);
            $t_params->{'SEARCH_RESULTS'}   = $array_nivel1;
            $t_params->{'cantidad'}         = $cantidad;

        }elsif($tipoAccion eq "BUSQUEDA_POR_ESTANTE"){
            my $funcion                     = $obj->{'funcion'};
            
            my ($cantidad, $array_estantes)   = C4::AR::Busquedas::busquedaPorEstante($obj->{'estante'}, $session, $obj);
            
            $obj->{'cantidad'}              = $cantidad;
            $t_params->{'paginador'}        = C4::AR::Utilidades::crearPaginador($cantidad,$cantR, $pageNumber,$funcion,$t_params);
            $t_params->{'SEARCH_RESULTS'}   = $array_estantes;
            $t_params->{'cantidad'}         = $cantidad;
        }
        elsif($tipoAccion eq "BUSQUEDA_ESTANTE_DE_GRUPO"){
            my $funcion                     = $obj->{'funcion'};
            
            my ($cantidad, $array_estantes)   = C4::AR::Busquedas::busquedaEstanteDeGrupo($obj->{'estantes_grupo'}, $session, $obj);
            
            $obj->{'cantidad'}              = $cantidad;
            $t_params->{'paginador'}        = C4::AR::Utilidades::crearPaginador($cantidad,$cantR, $pageNumber,$funcion,$t_params);
            $t_params->{'SEARCH_RESULTS'}   = $array_estantes;
            $t_params->{'cantidad'}         = $cantidad;
        }

        #se arma el string para mostrar en el cliente lo que a buscado, ademas escapa para evitar XSS
        $t_params->{'buscoPor'} = Encode::encode('utf8' ,C4::AR::Busquedas::armarBuscoPor($obj));
        C4::AR::Debug::debug("BUSCO POR===========================================================".$t_params->{'buscoPor'});
        my $elapsed             = Time::HiRes::tv_interval( $start );
        $t_params->{'timeSeg'}  = $elapsed;
        #C4::AR::Busquedas::logBusqueda($t_params, $session);
        
        C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
    }