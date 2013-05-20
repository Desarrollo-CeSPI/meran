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
use C4::AR::Z3950;
use C4::AR::Auth;

use MARC::Record;
use C4::AR::PortadasRegistros;
use JSON;

my $input=new CGI;
my $authnotrequired= 0;
my $Messages_arrayref;
my $obj=$input->param('obj');
   $obj=C4::AR::Utilidades::from_json_ISO($obj);
my $tipo= $obj->{'tipo'};

if($tipo eq "BUSCAR"){

    my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'ALTA', 
                                                    entorno => 'undefined' },
                                                'intranet'
                               );


	my $termino = $obj->{'termino'};
	my $busqueda = $obj->{'busqueda'};
    
    my ($Message_arrayref)=C4::AR::Z3950::encolarBusquedaZ3950($termino,$busqueda);
    my $infoOperacionJSON=to_json $Message_arrayref;
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;

}
elsif($tipo eq "VER_BUSQUEDAS"){

    my ($template, $session, $t_params) = get_template_and_user(
            {template_name => "z3950/verBusquedasZ3950.tmpl",
                    query => $input,
                    type => "intranet",
                    authnotrequired => 0,
                    flagsrequired => {  ui => 'ANY', 
                                        tipo_documento => 'ANY', 
                                        accion => 'CONSULTA', 
                                        entorno => 'undefined'},
                    });

    my $busquedas = C4::AR::Z3950::getBusquedas();
    if($busquedas){
        $t_params->{'cant_busquedas'}= @$busquedas;
        $t_params->{'BUSQUEDAS'}= $busquedas;
    }
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
elsif($tipo eq "VER_RESULTADO"){

    my ($template, $session, $t_params) = get_template_and_user(
            {template_name => "z3950/resultadoFiltradoZ3950.tmpl",
                    query => $input,
                    type => "intranet",
                    authnotrequired => 0,
                    flagsrequired => {  ui => 'ANY', 
                                        tipo_documento => 'ANY', 
                                        accion => 'CONSULTA', 
                                        entorno => 'undefined'},
                    });

    my $id_busqueda = $obj->{'id_busqueda'};
    my $busqueda = C4::AR::Z3950::getBusqueda($id_busqueda);
    if($busqueda){
        $t_params->{'cant_resultados'}= $busqueda->getCantResultados;
        $t_params->{'RESULTADO'}= $busqueda;
    }
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
elsif($tipo eq "VER_DETALLE_MARC"){

    my ($template, $session, $t_params) = get_template_and_user(
            {template_name => "z3950/MARCDetalle.tmpl",
                    query => $input,
                    type => "intranet",
                    authnotrequired => 0,
                    flagsrequired => {  ui => 'ANY', 
                                        tipo_documento => 'ANY', 
                                        accion => 'CONSULTA', 
                                        entorno => 'undefined'},
                    });

    my $id_resultado = $obj->{'id_resultado'};

    my $resultado = C4::AR::Z3950::getResultado($id_resultado);
    if($resultado){
        my $marc=$resultado->getRegistroMARC();
        my $MARCDetail_array = C4::AR::Z3950::detalleMARC($marc);
        $t_params->{'MARCDetail_array'}= $MARCDetail_array;
        $t_params->{'id_resultado'}= $id_resultado;
    }
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
elsif($tipo eq "IMPORTAR_MARC"){

    my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'ALTA', 
                                                    entorno => 'undefined' },
                                                'intranet'
                               );

    my $infoOperacionJSON;

    my $id_resultado = $obj->{'id_resultado'};
    my $resultado = C4::AR::Z3950::getResultado($id_resultado);
    if($resultado){
        my $marc = $resultado->getRegistroMARC();
        my ($Messages_arrayref, $id1) = C4::AR::Catalogacion::Z3950_to_meran($marc);
        $infoOperacionJSON=to_json $Messages_arrayref;

        C4::AR::Auth::print_header($session);
        print $infoOperacionJSON;
    
    }

}