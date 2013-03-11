#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;
use JSON;
use C4::AR::Z3950;

my $input           = new CGI;
my $obj             = $input->param('obj');
$obj                = C4::AR::Utilidades::from_json_ISO($obj);
my $accion          = $obj->{'tipoAccion'};
my $authnotrequired = 0;


if($accion eq "ACTUALIZAR_TABLA_SERVERS"){

    my ($template, $session, $t_params)  = get_template_and_user({
                        	template_name   => "z3950/z3950Result.tmpl",
							query           => $input,
							type            => "intranet",
							authnotrequired => 0,
							flagsrequired   => {    ui              => 'ANY', 
                                                    tipo_documento  => 'ANY', 
                                                    accion          => 'CONSULTA', 
                                                    entorno         => 'undefined'},
							debug           => 1,
			     });
			     
	my $servers_array_ref           = C4::AR::Z3950::getAllServidoresZ3950();

	$t_params->{'servers'}          = $servers_array_ref;
	
	C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
	
}#end if($accion eq "ACTUALIZAR_TABLA_SERVERS")

elsif($accion eq "AGREGAR_SERVIDOR"){

    my ($template, $session, $t_params)  = get_template_and_user({
                        	template_name   => "z3950/addServer.tmpl",
							query           => $input,
							type            => "intranet",
							authnotrequired => 0,
							flagsrequired   => {    ui              => 'ANY', 
                                                    tipo_documento  => 'ANY', 
                                                    accion          => 'CONSULTA', 
                                                    entorno         => 'undefined'},
							debug           => 1,
			     });
			     
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);			     

}#end if($accion eq "AGREGAR_SERVIDOR")

elsif($accion eq "GUARDAR_NUEVO_SERVIDOR"){

    my ($userid, $session, $flags) = checkauth( $input, 
                                            $authnotrequired,
                                            {   ui              => 'ANY', 
                                                tipo_documento  => 'ANY', 
                                                accion          => 'BAJA', 
                                                entorno         => 'undefined'},
                                            "intranet"
                                );
                                



    my $Message_arrayref    = C4::AR::Z3950::agregarServidorZ3950($obj);
    my $infoOperacionJSON   = to_json $Message_arrayref;
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;

}#end if($accion eq "GUARDAR_NUEVO_SERVIDOR")

elsif($accion eq "EDITAR_SERVIDOR"){

    my ($template, $session, $t_params)  = get_template_and_user({
                        	template_name   => "z3950/addServer.tmpl",
							query           => $input,
							type            => "intranet",
							authnotrequired => 0,
							flagsrequired   => {    ui              => 'ANY', 
                                                    tipo_documento  => 'ANY', 
                                                    accion          => 'CONSULTA', 
                                                    entorno         => 'undefined'},
							debug           => 1,
			     });
			     
	$t_params->{'editing'}          = 1;
	$t_params->{'servidor'}         = C4::AR::Z3950::getServidorPorId($obj->{'id_servidor'});
    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);	

}#end if($accion eq "EDITAR_SERVIDOR")

elsif($accion eq "ELIMINAR_SERVIDOR"){

    my ($userid, $session, $flags) = checkauth( $input, 
                                            $authnotrequired,
                                            {   ui              => 'ANY', 
                                                tipo_documento  => 'ANY', 
                                                accion          => 'BAJA', 
                                                entorno         => 'undefined'},
                                            "intranet"
                                );
                                



    my $Message_arrayref    = C4::AR::Z3950::eliminarServidorZ3950($obj->{'id_servidor'});
    my $infoOperacionJSON   = to_json $Message_arrayref;
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;

}#end if($accion eq "ELIMINAR_SERVIDOR")

elsif($accion eq "GUARDAR_MODIFICACION_SERVIDOR"){

    my ($userid, $session, $flags) = checkauth( $input, 
                                            $authnotrequired,
                                            {   ui              => 'ANY', 
                                                tipo_documento  => 'ANY', 
                                                accion          => 'BAJA', 
                                                entorno         => 'undefined'},
                                            "intranet"
                                );
                                



    my $Message_arrayref    = C4::AR::Z3950::editarServidorZ3950($obj->{'id_servidor'},$obj);
    my $infoOperacionJSON   = to_json $Message_arrayref;
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;


}#end if($accion eq "GUARDAR_MODIFICACION_SERVIDOR")

elsif ($accion eq "DESHABILITAR_SERVIDOR"){

    my ($userid, $session, $flags) = checkauth( $input, 
                                            $authnotrequired,
                                            {   ui              => 'ANY', 
                                                tipo_documento  => 'ANY', 
                                                accion          => 'BAJA', 
                                                entorno         => 'undefined'},
                                            "intranet"
                                );
                                



    my $Message_arrayref    = C4::AR::Z3950::deshabilitarServerZ3950($obj->{'id_servidor'});
    my $infoOperacionJSON   = to_json $Message_arrayref;
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;


}#end if($accion eq "DESHABILITAR_SERVIDOR")
