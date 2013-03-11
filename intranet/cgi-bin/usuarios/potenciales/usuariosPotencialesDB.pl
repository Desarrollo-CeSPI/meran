#!/usr/bin/perl

# $Id: actualizarPersonas.pl,v 1.0 2005/05/3 10:44:45 tipaul Exp $

#script para actualizar los datos de los posibles usuarios
#written 3/05/2005  by einar@info.unlp.edu.ar

use strict;
use C4::AR::Auth;

use CGI;
use JSON;

my $input = new CGI;
my $authnotrequired= 0;


my $obj=C4::AR::Utilidades::from_json_ISO($input->param('obj'));

my $id_personas_array_ref= $obj->{'id_personas'};
my $Messages_arrayref;

if($obj->{'tipoAccion'} eq "HABILITAR_PERSON"){
    C4::AR::Validator::validateParams('U389',$obj,['id_personas'] );
    my ($userid, $session, $flags) = checkauth( $input, 
                                            $authnotrequired,
                                            {   ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'MODIFICACION', 
                                                entorno => 'usuarios'
                                            },
                                            "intranet"
                                );

	($Messages_arrayref)= C4::AR::Usuarios::habilitarPersona($id_personas_array_ref);

	my $infoOperacionJSON=to_json $Messages_arrayref;

    C4::AR::Auth::print_header($session);
	print $infoOperacionJSON;

}elsif($obj->{'tipoAccion'} eq "DESHABILITAR_PERSON"){
    my ($userid, $session, $flags) = checkauth( $input, 
                                                $authnotrequired,
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'MODIFICACION', 
                                                    entorno => 'usuarios'
                                                },
                                                "intranet"
                                    );

	($Messages_arrayref)= &C4::AR::Usuarios::deshabilitarPersona($id_personas_array_ref);

	my $infoOperacionJSON=to_json $Messages_arrayref;
	
    C4::AR::Auth::print_header($session);
	print $infoOperacionJSON;

}elsif($obj->{'tipoAccion'} eq "ELIMINAR_PERMANENTEMENTE"){
	C4::AR::Validator::validateParams('U389',$obj,['nro_socio'] );
	
    my ($userid, $session, $flags) = checkauth( $input, 
                                                $authnotrequired,
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'MODIFICACION', 
                                                    entorno => 'usuarios'
                                                },
                                                "intranet"
                                    );

    my $nro_socio = $obj->{'nro_socio'};
    ($Messages_arrayref)= C4::AR::Usuarios::eliminarPotencial($nro_socio);

    my $infoOperacionJSON=to_json $Messages_arrayref;
    
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;

}

