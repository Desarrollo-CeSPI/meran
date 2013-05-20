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
use CGI;
use C4::AR::Novedades;
use C4::AR::Utilidades;
use Encode;
use C4::AR::Social;
my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user({
									template_name      => "admin/agregar_novedad.tmpl",
									query              => $input,
									type               => "intranet",
									authnotrequired    => 0,
									flagsrequired      => { ui              => 'ANY', 
                                                            tipo_documento  => 'ANY', 
                                                            accion          => 'CONSULTA', 
                                                            entorno         => 'usuarios'},
									debug              => 1,
			    });

my $action          = $input->param('action') || 0;
my $twitter_enabled = C4::AR::Social::twitterEnabled();
my $contenido       = $input->param('contenido');
my $cont;

#estamos agregando
if ($action){

    #------------ data de los inputs-------------
    $t_params->{'titulo'}       = $input->param('titulo');
    $t_params->{'categoria'}    = $input->param('categoria');
    $t_params->{'contenido'}    = $input->param('contenido');
    $t_params->{'twiter'}       = $input->param('check_publicar');
    $t_params->{'nombreAdjunto'}= $input->param('nombreAdjunto');
    $t_params->{'links'}        = $input->param('links');
    #--------- FIN data de los inputs -----------

    #--------- imagenes nuevas -----------
    my @arrayFiles;
    
    #copio la referencia de la hash
    my $hash        = $input->{'param'};

    my $imagenes    = $hash->{'imagenes'};

    foreach my $file ( @$imagenes ){

        if($file){
            push(@arrayFiles, $file);
        }
        
    }
    #-------- FIN imagenes nuevas ----------
    
    
    #--------- links -----------
    my $linksTodos  = C4::AR::Utilidades::trim($input->param('links'));  
    my @links       = split('\ ', $linksTodos);   
    my $linksFinal  = "";
    
    foreach my $link (@links){
    
        if($link !~ /^http/){
            $linksFinal .= " http://" . $link;
        }else{
            $linksFinal .= " " . $link;
        }
    }
    #------- FIN links ---------
    
    my %novedad;
    
    $novedad{'titulo'}          = $input->param('titulo');
    $novedad{'contenido'}       = $input->param('contenido');
    $novedad{'links'}           = $linksFinal;
    $novedad{'categoria'}       = $input->param('categoria');
    $novedad{'nombreAdjunto'}   = $input->param('nombreAdjunto');
     
    my %paramHash;
    
    $paramHash{'datosNovedad'} = \%novedad;
    $paramHash{'arrayFiles'}   = \@arrayFiles;
    $paramHash{'adjunto'}      = $input->upload('adjunto');
     
    my ($Message_arrayref, $novedad) = C4::AR::Novedades::agregar(\%paramHash);
    
    if($Message_arrayref->{'error'} == 0){
   
        if ($input->param('check_publicar')){

              my $link      = C4::AR::Social::shortenUrl($novedad->getId());

              $cont         = $novedad->getResumen();
              $cont         = Encode::decode_utf8($cont);
              my $post      = C4::AR::Preferencias::getValorPreferencia('prefijo_twitter')." ".$cont."... Ver mas en: ".$link;

              #  Posteo en twitter. En C4::AR::Social::sendPost se verifica si la preferencia twitter_enabled esta activada
              my $mensaje   = C4::AR::Social::sendPost($post);
        }

        C4::AR::Debug::debug("mensajeee : " . $Message_arrayref->{'messages'}[0]->{'message'});

        C4::AR::Auth::redirectTo(C4::AR::Utilidades::getUrlPrefix().'/admin/novedades_opac.pl?token='.$input->param('token'));
        
    }else{
    
        $t_params->{'mensaje'} = $Message_arrayref->{'messages'}[0]->{'message'};
        
    }
}

$t_params->{'twitter_enabled'}  = $twitter_enabled; 
$t_params->{'page_sub_title'}   = C4::AR::Filtros::i18n("Agregar Novedad");
C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);