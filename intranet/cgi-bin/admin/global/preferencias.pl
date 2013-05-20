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

my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user({
                        template_name   => "admin/global/preferenciasResults.tmpl",
                        query           => $input,
                        type            => "intranet",
                        authnotrequired => 0,
                        flagsrequired   => {  ui            => 'ANY', 
                                            tipo_documento  => 'ANY', 
                                            accion          => 'CONSULTA', 
                                            entorno         => 'preferencias',
                                            tipo_permiso    => 'general'
                        },
                        debug           => 1,
                });


my $preferenciasSistema     = C4::AR::Preferencias::getPreferenciasByCategoria('sistema');

#trae las preferencias que son renderizadas como un radio button de bootstrap
my $preferenciasBooleanas   = C4::AR::Preferencias::getPreferenciasBooleanas('sistema');

#si estamos haciendo el post del form hay que guardar los cambios
if($input->param('editando')){

    my $msg_object = C4::AR::Mensajes::create();
    my $tmp;
    
    foreach my $preferencia (@$preferenciasSistema){ 
        $tmp = C4::AR::Preferencias::setVariable($preferencia->getVariable,$input->param($preferencia->getVariable));
    }
    
    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP000', 'params' => []} ) ;

    $t_params->{'mensaje'} = C4::AR::Mensajes::getMensaje('SP000','intranet');
    $t_params->{'mensaje_class'}    = 'alert-success';
    
}

#hay que recargarlas de nuevo para mostrar los valores actualizados
$preferenciasSistema = C4::AR::Preferencias::getPreferenciasByCategoria('sistema');

my @arrayPreferencias;
my $campo       = "";
my $tabla       = "";

#armamos la data para pasar al template
foreach my $preferencia (@$preferenciasSistema){
        
    if($preferencia->getOptions ne ""){         
        if($preferencia->getType eq "referencia"){      
                my @array;
                @array = split(/\|/,$preferencia->getOptions);
                $tabla = $array[0];
                $campo = $array[1];             
        }
    }
    
    my $nuevoCampo;
    my @labels;
    my @values;
    my %labels;
    my %hash;
    
    $hash{'preferencia'} = $preferencia;

    if($preferencia->getType eq "bool"){
        push(@values, 1);
        push(@values, 0);
        push(@labels, C4::AR::Filtros::i18n('Si'));
        push(@labels, C4::AR::Filtros::i18n('No'));
        $nuevoCampo = C4::AR::Utilidades::crearRadioButtonBootstrap($preferencia->getVariable,\@values,\@labels,$preferencia->getValue);
    
    }
    
    elsif($preferencia->getType eq "texta"){
        $nuevoCampo = C4::AR::Utilidades::crearComponentes("texta",$preferencia->getVariable,58,4,$preferencia->getValue);
    }
     
    elsif($preferencia->getType eq "referencia"){
        my $orden = $campo;
        my ($cantidad,$valores) = C4::AR::Referencias::obtenerValoresTablaRef($tabla,$campo,$orden);
        foreach my $val(@$valores){
            $labels{$val->{"clave"}} = $val->{"valor"}; 
            push(@values,$val->{"valor"});
        }
        $nuevoCampo = C4::AR::Utilidades::crearComponentes("combo",$preferencia->getVariable,\@values,\%labels,$preferencia->getValue);
        $hash{'tabla'} = $tabla;
        $hash{'campo'} = $campo;

    }   elsif($preferencia->getType eq "text"){
        $nuevoCampo = C4::AR::Utilidades::crearComponentes("text",$preferencia->getVariable,50,0,$preferencia->getValue);
    }

    $hash{'tipo'}  = $preferencia->getType;
    $hash{'valor'} = $nuevoCampo;
    
    push(@arrayPreferencias, \%hash);
}

$t_params->{'preferencias'}             = \@arrayPreferencias;
$t_params->{'preferenciasBooleanas'}    = $preferenciasBooleanas;
$t_params->{'page_sub_title'}           = C4::AR::Filtros::i18n("Configuraci&oacute;n de Sistema");

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);