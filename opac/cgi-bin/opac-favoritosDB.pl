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
require Exporter;

use CGI;
use C4::AR::Auth;
use C4::Date;;
use Date::Manip;
use C4::AR::Busquedas;

my $input = new CGI;

my ($template, $session, $t_params)= get_template_and_user({
                                    template_name => "includes/opac-favoritosResult.inc",
                                    query => $input,
                                    type => "opac",
                                    authnotrequired => 1,
                                    flagsrequired => {  ui => 'ANY', 
                                                        tipo_documento => 'ANY', 
                                                        accion => 'CONSULTA', 
                                                        entorno => 'undefined'},
});


my $obj=$input->param('obj');
$obj=C4::AR::Utilidades::from_json_ISO($obj);
my $action = $obj->{'action'};
my $id1 = $obj->{'id1'};
my $nro_socio = C4::AR::Auth::getSessionNroSocio();

$t_params->{'no_content_message'}= C4::AR::Filtros::i18n("No has marcado nada como favorito!");

if ($action eq "add_favorite"){
    print $session->header;
    my $result = C4::AR::Nivel1::addToFavoritos($id1,$nro_socio);
    if ($result){
                                      print C4::AR::Filtros::action_button( 
                                                                      button    => "btn btn-info click",
                                                                      action    => 'deleteFavorite('.$id1.',"fav_'.$id1.'",1);',
                                                                      id        => "button_favorite_id1",
                                                                      icon      => "icon-minus icon-white",
                                                                      disabled  => 1,
                                                                  ) ;
    	
    }else{
        print $result;	
    }
}
elsif ($action eq "delete_favorite"){

    my $result = C4::AR::Nivel1::removeFromFavoritos($id1,$nro_socio);
    
    if ($obj->{'from_busqueda'}){
    	if ($result){
    		                          print $session->header;
                                      print C4::AR::Filtros::action_button( 
                                                                      button    => "btn btn-primary click",
                                                                      action    => 'addFavorite('.$id1.',"fav_'.$id1.'");',
                                                                      id        => "button_favorite_id1",
                                                                      icon      => "icon-heart icon-white",
                                                                  ) ;
    		
    	}
    }else{
    
	    my ($cantidad,$resultsarray)= C4::AR::Nivel1::getFavoritos($nro_socio);
	
	    $t_params->{'cantidad'}= $cantidad;
	    $t_params->{'nro_socio'}= $session->param('nro_socio');
	    $t_params->{'SEARCH_RESULTS'}= $resultsarray;
	    $t_params->{'content_title'}= C4::AR::Filtros::i18n("Sus favoritos: ".$cantidad);
	    
	    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
    }
}
elsif ($action eq "get_favoritos"){

    my $nro_socio = C4::AR::Auth::getSessionNroSocio();
    my ($socio, $flags) = C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);
    C4::AR::Validator::validateObjectInstance($socio);


    my ($cantidad,$resultsarray)= C4::AR::Nivel1::getFavoritos($nro_socio);
    $t_params->{'cantidad'}= $cantidad;
    $t_params->{'nro_socio'}= $session->param('nro_socio');
    $t_params->{'SEARCH_RESULTS'}= $resultsarray;
    $t_params->{'content_title'}= C4::AR::Filtros::i18n("Sus favoritos: ".$cantidad);

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}

1;