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
use C4::AR::Catalogacion;
use JSON;

my ($template, $session, $t_params);
my $input   = new CGI;
my $obj     = $input->param('obj') || 0;

if ($obj){

    ($template, $session, $t_params) = get_template_and_user({
                    template_name => "includes/partials/modificar_value_input.tmpl",
                    query => $input,
                    type => "intranet",
                    authnotrequired => 0,
                    flagsrequired => {  ui => 'ANY', 
                                        tipo_documento => 'ANY', 
                                        accion => 'MODIFICACION', 
                                        entorno => 'estructura_catalogacion_n3'},
                    debug => 1,
            });


    $obj = C4::AR::Utilidades::from_json_ISO($obj);
    my $tipoAccion  = $obj->{'tipoAccion'};
    my $tipoN3      = $obj->{'id_tipo_doc'};
    
    if ($tipoAccion eq "ELECCION_BARCODE"){
        $t_params->{'id_tipo_doc'} = $tipoN3;
        $t_params->{'tipo_doc'}     = C4::AR::Referencias::translateTipoNivel3($tipoN3);
        ($t_params->{'value'},$t_params->{'long_value'}) = C4::AR::Catalogacion::getBarcodeFormat($tipoN3,"NO");
        $t_params->{'function'}    = 'actualizarBarcode();';

        C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
        
    }
    elsif($tipoAccion eq "MODIFICACION_BARCODE"){
        my $format                  = $obj->{'barcode_format'};
        my $long                    = $obj->{'barcode_long'};
        my ($Message_arrayref)      = C4::AR::Catalogacion::updateBarcodeFormat($tipoN3,$format,$long);
        my $infoOperacionJSON       = to_json $Message_arrayref;
        
        C4::AR::Auth::print_header($session);
        print $infoOperacionJSON;
                    	
    }
    
    
}else{
	
	($template, $session, $t_params) = get_template_and_user({
	                template_name => "catalogacion/configuracion/barcode_gen_setup.tmpl",
				    query => $input,
				    type => "intranet",
				    authnotrequired => 0,
				    flagsrequired => {  ui => 'ANY', 
	                                    tipo_documento => 'ANY', 
	                                    accion => 'MODIFICACION', 
	                                    entorno => 'estructura_catalogacion_n3'},
				    debug => 1,
		    });
	
	my %params_combo;
	$params_combo{'onChange'}       = 'eleccionDeBarcodeFormat()';
	$params_combo{'class'}          = 'horizontal';
	my $comboTiposNivel3            = C4::AR::Utilidades::generarComboTipoNivel3(\%params_combo);
	$t_params->{'selectItemType'}   = $comboTiposNivel3;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}