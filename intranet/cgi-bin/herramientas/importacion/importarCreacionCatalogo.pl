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
use C4::AR::ImportacionXML;

my $input = new CGI;

my %params_combo;

my $obj     = $input->Vars; 

my $accion  = $obj->{'tipoAccion'} || undef;

my ($template, $session, $t_params) = get_template_and_user({
                                    template_name   => 'catalogacion/estructura/datosDocumento.tmpl',
                                    query           => $input,
                                    type            => "intranet",
                                    authnotrequired => 0,
                                    flagsrequired   => {  ui    => 'ANY', 
                                                        accion  => 'CONSULTA', 
                                                        entorno => 'undefined'},
                                    debug => 1,
                });

if ($accion eq "IMPORT"){

    my $msg_object  = C4::AR::ImportacionXML::importarCreacionCatalogo($obj, $input->upload('fileImported'));

    my $codMsg      = C4::AR::Mensajes::getFirstCodeError($msg_object);
    
    $t_params->{'mensaje'} = C4::AR::Mensajes::getMensaje($codMsg,'INTRA');

    if (C4::AR::Mensajes::hayError($msg_object)){
        $t_params->{'mensaje_class'} = "alert-error";
    }else{
        $t_params->{'mensaje_class'} = "alert-success";
    }
}

my $post_params                 = $input->Vars;
#estos parametros se usan cuando se viene desde otra pagina y se intenta modificar algun nivel
my $id1                         = $input->param('id1')||0;
my $id2                         = $input->param('id2')||0;
my $id3                         = $input->param('id3')||0;
my $tipoAccion                  = $input->param('tipoAccion');
$t_params->{'id1'}              = $id1;
$t_params->{'id2'}              = $id2;
$t_params->{'id3'}              = $id3;
$t_params->{'tipoAccion'}       = $tipoAccion;
$t_params->{'tiene_nivel_2'}    = 0;
my $nivel                       = 1;
my %params_combo;
my $template_catalogo           = "ALL";


if(($tipoAccion eq "MODIFICAR_NIVEL_1")||($tipoAccion eq "MODIFICAR_NIVEL_3_ALL")){
# se verifica si tiene nivel 2, sino hay q mostrar el comboTiposNivel3 para q selecione el tipo de documento (esquema)
    $t_params->{'tiene_nivel_2'}        = C4::AR::Catalogacion::cantNivel2($t_params->{'id1'});
    my @n3_array;
    my @split_array;

    while ( my ($key, $value) = each(%$post_params) ) {

          my $result = rindex($key, "n3_");

          if( $result != -1){
              push (@n3_array, $value);
          }
    }

    $t_params->{'cant'}                             = $input->param('cant');
    $t_params->{'n3_array'}                         = \@n3_array;
}

if($tipoAccion eq "MODIFICAR_NIVEL_1"){
    my $nivel1      = C4::AR::Nivel1::getNivel1FromId1($id1);

    if($nivel1){
        $template_catalogo      = $nivel1->getTemplate();
        $t_params->{'nivel1'}   = $nivel1;
    }

}elsif($tipoAccion eq "MODIFICAR_NIVEL_2"){
    my $nivel2  = C4::AR::Nivel2::getNivel2FromId2($id2);

    if($nivel2){
        $template_catalogo          = $nivel2->getTemplate();
        $t_params->{'indice_data'}  = $nivel2->getIndice() || "";
        $t_params->{'nivel1'}       = $nivel2->nivel1;
    }
    
}elsif($tipoAccion eq "MODIFICAR_NIVEL_3"){
    my $nivel3  = C4::AR::Nivel3::getNivel3FromId3($id3);

    if($nivel3){
        $template_catalogo          = $nivel3->getTemplate();
        $t_params->{'indice_data'}  = C4::AR::Nivel2::getNivel2FromId1($id1)->[0]->getIndice() || "";
        $t_params->{'nivel1'}       = $nivel3->nivel1;
    }

}elsif($tipoAccion eq "AGREGAR_EDICION"){
    my $nivel1      = C4::AR::Nivel1::getNivel1FromId1($id1);

    if($nivel1){
        $template_catalogo      = $nivel1->getTemplate();
        $t_params->{'nivel1'}   = $nivel1;
    }

}elsif($tipoAccion eq "AGREGAR_ANALITICA"){

    my $nivel1      = C4::AR::Nivel1::getNivel1FromId1($id1);

    if($nivel1){
        $template_catalogo      = $nivel1->getTemplate();
        $t_params->{'nivel1'}   = $nivel1;
    }
}


$t_params->{'template_catalogo'}                = $template_catalogo;
$params_combo{'onChange'}                       = 'seleccionar_esquema()';
$params_combo{'default'}                        = C4::AR::Preferencias::getValorPreferencia("defaultTipoNivel3");#'SIN SELECCIONAR';
$t_params->{'comboTipoDocumento'}               = &C4::AR::Utilidades::generarComboTipoNivel3(\%params_combo);
$t_params->{'nivel'}                            = $nivel;
$params_combo{'onChange'}                       = '';
$params_combo{'default'}                        = C4::AR::Preferencias::getValorPreferencia("defaultlevel");#'SIN SELECCIONAR';
$t_params->{'comboTipoNivelBibliografico'}      = &C4::AR::Utilidades::generarComboNivelBibliografico(\%params_combo);
$t_params->{'page_sub_title'}                   = C4::AR::Filtros::i18n("Catalogaci&oacute;n - Datos del documento");
$t_params->{'unload_alert'}                     = 1;

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);