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

use C4::AR::Sanciones;
use C4::AR::Prestamos;
use JSON;

my $input = new CGI;
my $obj=$input->param('obj');
$obj=C4::AR::Utilidades::from_json_ISO($obj);

my $accion = $obj->{'tipoAccion'};
my $authnotrequired= 0;


if($accion eq "TIPOS_PRESTAMOS_SANCIONADOS"){
		my ($template, $session, $t_params)  = get_template_and_user({
								template_name   => "admin/circulacion/sanciones_tipo_de_prestamos.tmpl",
								query           => $input,
								type            => "intranet",
								authnotrequired => 0,
								flagsrequired   => {    ui => 'ANY', 
                                                        tipo_documento => 'ANY', 
                                                        accion => 'CONSULTA', 
                                                        entorno => 'undefined'},
								debug           => 1,
					});
	
		my $tipo_prestamo               = $obj->{'tipo_prestamo'};
		my $categoria_socio             = $obj->{'categoria_socio'};
		my $tipo_sancion                = C4::AR::Sanciones::getTipoSancion($tipo_prestamo, $categoria_socio);
		
		if(!$tipo_sancion){
		#Para que no dé mas error por falta de datos, cuando no se encuentra el tipo de sación, se crea una automaticamente
			 $tipo_sancion = C4::Modelo::CircTipoSancion->new();
			 $tipo_sancion->setCategoria_socio($categoria_socio);
			 $tipo_sancion->setTipo_prestamo($tipo_prestamo);
			 $tipo_sancion->save();
		}
		
		C4::AR::Debug::debug("tipos sancion        ".$tipo_sancion);
		
		$t_params->{'tipo_sancion'}     = $tipo_sancion;

		my $tipo_prestamos              = C4::AR::Prestamos::getTiposDePrestamos();
		
		
		$t_params->{'TIPOS_PRESTAMOS'}  = $tipo_prestamos;

		C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}#end if($accion eq "TIPOS_PRESTAMOS_SANCIONADOS")

elsif ($accion eq "GUARDAR_TIPOS_PRESTAMOS_QUE_APLICA") {

	my ($userid, $session, $flags) = checkauth( $input, 
                                            $authnotrequired,
                                            {   ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'BAJA', 
                                                entorno => 'undefined'},
                                            "intranet"
                                );

	my $tipos_que_aplica=$obj->{'tipos_que_aplica'};
	my $tipo_prestamo=$obj->{'tipo_prestamo'};
	my $categoria_socio=$obj->{'categoria_socio'};

    my $Message_arrayref = C4::AR::Sanciones::actualizarTiposPrestamoQueAplica($tipo_prestamo,$categoria_socio,$tipos_que_aplica);
    my $infoOperacionJSON=to_json $Message_arrayref;
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}

elsif($accion eq "REGLAS_SANCIONES"){
    my ($template, $session, $t_params)  = get_template_and_user({
                            template_name => "admin/circulacion/sanciones_reglas.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'CONSULTA', 
                                                entorno => 'undefined'},
                            debug => 1,
                });

    my $tipo_prestamo=$obj->{'tipo_prestamo'};
    my $categoria_socio=$obj->{'categoria_socio'};

    my $tipo_sancion= C4::AR::Sanciones::getTipoSancion($tipo_prestamo, $categoria_socio);
    my $reglas_tipo_sancion;
    my $cantidad = 0;

    if($tipo_sancion){
      $t_params->{'tipo_sancion'}= $tipo_sancion;
      ($reglas_tipo_sancion)= C4::AR::Sanciones::getReglasTipoSancion($tipo_sancion);
      $t_params->{'REGLAS_TIPOS_SANCIONES'}= $reglas_tipo_sancion;
      if ($reglas_tipo_sancion){
        $cantidad = scalar(@$reglas_tipo_sancion);
      }
      $t_params->{'cantidad'}= $cantidad;
      $t_params->{'tipos_prestamo_aplica'} = $tipo_sancion->tiposPrestamoQueAplica();


    }

    ######################Combos de las reglas de sancion##################################
    my $reglas_sancion= C4::AR::Sanciones::getReglasSancionNoAplicadas($tipo_sancion);
    if ($reglas_sancion) {
    my %regla_sancionlabels;
    my @regla_sancionvalues;
    foreach my $regla (@$reglas_sancion) {
        push @regla_sancionvalues, $regla->getRegla_sancion;
        $regla_sancionlabels{$regla->getRegla_sancion} = "Dias de demora: ".$regla->getDias_demora.". Dias de sancion: ".$regla->getDias_sancion;
    }
    my $CGIregla_sancion=CGI::scrolling_list(
                            -name => 'regla_sancion',
                            -id => 'regla_sancion',
                            -values   => \@regla_sancionvalues,
                            -labels   => \%regla_sancionlabels,
                            -size     => 1,
                            -multiple => 0 );

    $t_params->{'reglas_de_sancion'}= $CGIregla_sancion;
    }
    ######################Combos Orden##################################
    my %orden;
    my @orden;
    for (my $i=1; $i < 21; $i++) {
            push @orden, $i;
            $orden{$i} = $i;
    }
    my $sugestedOrder= 0; #Maximo +1
    if($reglas_tipo_sancion){
    foreach my $mi_regla (@$reglas_tipo_sancion) { 
        if($mi_regla->getOrden > $sugestedOrder){
            $sugestedOrder=$mi_regla->getOrden;
        } 
    }
    }
    $sugestedOrder++;

    my $CGIorden=CGI::scrolling_list(
                            -name => 'orden',
                            -id => 'orden',
                            -values   => \@orden,
                            -labels   => \%orden,
                            -default => $sugestedOrder,
                            -size     => 1,
                            -multiple => 0 );

    $t_params->{'ordenes'}= $CGIorden;

    ######################Combos Cantidades##################################
    my %cantidad;
    my @cantidad;
    push @cantidad, 0;
    $cantidad{0} = "Infinito";
    for (my $i=1; $i < 21; $i++) {
            push @cantidad, $i;
            $cantidad{$i} = $i;
    }

    my $CGIcantidad=CGI::scrolling_list(
                            -name => 'cantidad', 
                            -id => 'cantidad',
                            -values   => \@cantidad,
                            -labels   => \%cantidad,
                            -default => 1,
                            -size     => 1,
                            -multiple => 0 );

    $t_params->{'cantidades'}= $CGIcantidad;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}#end if($accion eq "REGLAS_SANCIONES")


elsif ($accion eq "ELIMINAR_REGLA_TIPO_SANCION") {

    my ($userid, $session, $flags) = checkauth( $input, 
                                            $authnotrequired,
                                            {   ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'BAJA', 
                                                entorno => 'undefined'},
                                            "intranet"
                                );

    my $tipo_sancion=$obj->{'tipo_sancion'};
    my $regla_sancion=$obj->{'regla_sancion'};

    my $Message_arrayref = &C4::AR::Sanciones::eliminarReglaTipoSancion($tipo_sancion,$regla_sancion);
    my $infoOperacionJSON=to_json $Message_arrayref;
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}

elsif ($accion eq "AGREGAR_REGLA_TIPO_SANCION") {

    my ($userid, $session, $flags) = checkauth( $input, 
                                            $authnotrequired,
                                            {   ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'BAJA', 
                                                entorno => 'undefined'},
                                            "intranet"
                                );

    my $orden=$obj->{'orden'};
    my $regla_sancion=$obj->{'regla_sancion'};
    my $cantidad=$obj->{'cantidad'};
    my $tipo_prestamo=$obj->{'tipo_prestamo'};
    my $categoria_socio=$obj->{'categoria_socio'};

    my $Message_arrayref = &C4::AR::Sanciones::agregarReglaTipoSancion($regla_sancion,$orden,$cantidad,$tipo_prestamo, $categoria_socio);
    my $infoOperacionJSON=to_json $Message_arrayref;
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}

elsif($accion eq "MODIFICAR_REGLAS"){
        my ($template, $session, $t_params)  = get_template_and_user({
                                template_name => "admin/circulacion/sanciones_editar_reglas.tmpl",
                                query => $input,
                                type => "intranet",
                                authnotrequired => 0,
                                flagsrequired => {  ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'undefined'},
                                debug => 1,
                    });
        my $reglas_sancion=&C4::AR::Sanciones::getReglasSancion();
        $t_params->{'REGLAS_SANCIONES'}= $reglas_sancion;

        C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}#end if($accion eq "MODIFICAR_REGLAS")


elsif ($accion eq "ELIMINAR_REGLA_SANCION") {

    my ($userid, $session, $flags) = checkauth( $input, 
                                            $authnotrequired,
                                            {   ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'BAJA', 
                                                entorno => 'undefined'},
                                            "intranet"
                                );

    my $regla_sancion=$obj->{'regla_sancion'};

    my $Message_arrayref = &C4::AR::Sanciones::eliminarReglaSancion($regla_sancion);
    my $infoOperacionJSON=to_json $Message_arrayref;
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}

elsif ($accion eq "AGREGAR_REGLA_SANCION") {

    my ($userid, $session, $flags) = checkauth( $input, 
                                            $authnotrequired,
                                            {   ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'BAJA', 
                                                entorno => 'undefined'},
                                            "intranet"
                                );

    my $dias_sancion=$obj->{'dias_sancion'};
    my $dias_demora=$obj->{'dias_demora'};

    my $Message_arrayref = &C4::AR::Sanciones::agregarReglaSancion($dias_sancion,$dias_demora);
    my $infoOperacionJSON=to_json $Message_arrayref;
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}