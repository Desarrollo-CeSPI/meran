#!/usr/bin/perl

#En este modulo se va hacer los llamados a funciones para insertar los sinonimos de
#autores, temas, ..

use strict;
use CGI;
use C4::AR::Auth;

use C4::AR::ControlAutoridades;
use C4::AR::Utilidades;
use JSON;

my $input = new CGI;
my $authnotrequired= 0;
# my ($userid, $session, $flags) = checkauth($input, 0,{ editcatalogue => 1});


my $obj=$input->param('obj');
$obj=C4::AR::Utilidades::from_json_ISO($obj);

my $tipo = $obj->{'tipo'};
my $tabla = $obj->{'tabla'};
my $seudonimo = $obj->{'tablasSelectSeudonimo'};
my $id = $obj->{'id'};
my $seudonimoDelete = $obj->{'idDelete'};
my $accion = $obj->{'accion'};
my $sinonimoDelete_string = $obj->{'sinonimoDelete_string'};
my %infoRespuesta;

my ($template, $session, $t_params);
my ($user,$flags);
my ($msg_object);

C4::AR::Validator::validateParams('U389',$obj,['tipo','tabla']);

if($tabla eq 'autores'){
#****************************SEUDONIMOS***************************************
	if($tipo eq 'eliminarSeudonimos'){

    ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'BAJA', 
                                                    entorno => 'control_de_autoridades'}, 
                                                'intranet'
                                    );

		($msg_object)=&C4::AR::ControlAutoridades::t_eliminarSeudonimosAutor(
												$id,
												$seudonimoDelete
							);

        my $infoRespuestaJSON = to_json $msg_object;
         C4::AR::Auth::print_header($session);
		#se envia en JSON al cliente
		print $infoRespuestaJSON;
	}

	if($tipo eq 'insertarSeudonimos'){

    ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'ALTA', 
                                                    entorno => 'control_de_autoridades'}, 
                                                'intranet'
                                    );

		my $id=  $obj->{'id'};
		my $seudonimos_arrayref=  $obj->{'seudonimos'};
		($msg_object)=&C4::AR::ControlAutoridades::t_insertSeudonimosAutor(
										$seudonimos_arrayref, 
										$id
							);

        my $infoRespuestaJSON = to_json $msg_object;
    	C4::AR::Auth::print_header($session);
		#se envia en JSON al cliente
		print $infoRespuestaJSON;
	}
#******************************SINONIMOS**************************************

	if($tipo eq 'eliminarSinonimos'){

    ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'BAJA', 
                                                    entorno => 'control_de_autoridades'}, 
                                                'intranet'
                                    );

		my $id=  $obj->{'id'};
		my $sinonimoDelete_string=  $obj->{'sinonimoDelete_string'};
		($msg_object)= &C4::AR::ControlAutoridades::t_eliminarSinonimosAutor(
											$id,
											$sinonimoDelete_string
								);
		#se convierte el arreglo de respuesta en JSON
		my $infoRespuestaJSON = to_json $msg_object;
    	C4::AR::Auth::print_header($session);
		#se envia en JSON al cliente
		print $infoRespuestaJSON;

	}
	if($tipo eq 'insertarSinonimos'){

    ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'ALTA', 
                                                    entorno => 'control_de_autoridades'}, 
                                                'intranet'
                                    );

		my $sinonimos_arrayref= $obj->{'sinonimos'};
		my $id= $obj->{'id'};

		($msg_object)= &C4::AR::ControlAutoridades::t_insertSinonimosAutor(
											$sinonimos_arrayref, 
											$id
							);

        my $infoRespuestaJSON = to_json $msg_object;
    	C4::AR::Auth::print_header($session);
		#se envia en JSON al cliente
		print $infoRespuestaJSON;

	}
	if($tipo eq 'UpdateSinonimo'){

    ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'MODIFICACION', 
                                                    entorno => 'control_de_autoridades'}, 
                                                'intranet'
                                    );

		my $idSinonimo= $obj->{'idSinonimo'}||" ";
		my $nombre= $obj->{'nombre'};
		my $nombreViejo= $obj->{'nombreViejo'};

		($msg_object)= &C4::AR::ControlAutoridades::t_updateSinonimosAutores(
											$idSinonimo, 
											$nombre, 
											$nombreViejo
							);

		#se convierte el arreglo de respuesta en JSON
        my $infoRespuestaJSON = to_json $msg_object;
    	C4::AR::Auth::print_header($session);
		#se envia en JSON al cliente
		print $infoRespuestaJSON;
	}

}

if($tabla eq 'temas'){
#****************************SEUDONIMOS***************************************
	if($tipo eq 'eliminarSeudonimos'){

    ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'BAJA', 
                                                    entorno => 'control_de_autoridades'}, 
                                                'intranet'
                                    );

		($msg_object)=&C4::AR::ControlAutoridades::t_eliminarSeudonimosTema(
											$id,
											$seudonimoDelete
							);


        my $infoRespuestaJSON = to_json $msg_object;
    C4::AR::Auth::print_header($session);
		#se envia en JSON al cliente
		print $infoRespuestaJSON;
	}

	if($tipo eq 'insertarSeudonimos'){

    ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'ALTA', 
                                                    entorno => 'control_de_autoridades'}, 
                                                'intranet'
                                    );

		my $id=  $obj->{'id'};
		my $seudonimos_arrayref=  $obj->{'seudonimos'};
		($msg_object)=&C4::AR::ControlAutoridades::t_insertSeudonimosTemas(
										$seudonimos_arrayref, 
										$id
								);
        my $infoRespuestaJSON = to_json $msg_object;
    	C4::AR::Auth::print_header($session);
		#se envia en JSON al cliente
		print $infoRespuestaJSON;
	}
#******************************SINONIMOS**************************************
	if($tipo eq 'eliminarSinonimos'){

    ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'BAJA', 
                                                    entorno => 'control_de_autoridades'}, 
                                                'intranet'
                                    );

		($msg_object)=&C4::AR::ControlAutoridades::t_eliminarSinonimosTema(
											$id,
											$sinonimoDelete_string
								);

        my $infoRespuestaJSON = to_json $msg_object;
    C4::AR::Auth::print_header($session);
		#se envia en JSON al cliente
		print $infoRespuestaJSON;
	}

	if($tipo eq 'insertarSinonimos'){

    ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'ALTA', 
                                                    entorno => 'control_de_autoridades'}, 
                                                'intranet'
                                    );

		my $id= $obj->{'id'};
		my $sinonimos_arrayref= $obj->{'sinonimos'};
		($msg_object)=&C4::AR::ControlAutoridades::t_insertSinonimosTemas(
											$sinonimos_arrayref, 
											$id
								);

        my $infoRespuestaJSON = to_json $msg_object;
    	C4::AR::Auth::print_header($session);
		#se envia en JSON al cliente
		print $infoRespuestaJSON;
	}
	if($tipo eq 'UpdateSinonimo'){

    ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'MODIFICACION', 
                                                    entorno => 'control_de_autoridades'}, 
                                                'intranet'
                                    );

		my $idSinonimo= $obj->{'idSinonimo'}||" ";
		my $nombre= $obj->{'nombre'};
		my $nombreViejo= $obj->{'nombreViejo'};
		($msg_object)=&C4::AR::ControlAutoridades::t_updateSinonimosTemas(
										$idSinonimo, 
										$nombre, 
										$nombreViejo
								);


        my $infoRespuestaJSON = to_json $msg_object;
    	C4::AR::Auth::print_header($session);
		#se envia en JSON al cliente
		print $infoRespuestaJSON;
	}

}

if($tabla eq 'editoriales'){
#****************************SEUDONIMOS***************************************
	if($tipo eq 'eliminarSeudonimos'){

    ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'BAJA', 
                                                    entorno => 'control_de_autoridades'}, 
                                                'intranet'
                                    );

		($msg_object)=&C4::AR::ControlAutoridades::t_eliminarSeudonimosEditorial(
											$id,
											$seudonimoDelete
								);


        my $infoRespuestaJSON = to_json $msg_object;
    	C4::AR::Auth::print_header($session);
		#se envia en JSON al cliente
		print $infoRespuestaJSON;
	}

	if($tipo eq 'insertarSeudonimos'){

    ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'ALTA', 
                                                    entorno => 'control_de_autoridades'}, 
                                                'intranet'
                                    );

		my $id=  $obj->{'id'};
		my $seudonimos_arrayref=  $obj->{'seudonimos'};
		($msg_object)=&C4::AR::ControlAutoridades::t_insertSeudonimosEditoriales(
										$seudonimos_arrayref, 
										$id
								);

        my $infoRespuestaJSON = to_json $msg_object;
    	C4::AR::Auth::print_header($session);
		#se envia en JSON al cliente
		print $infoRespuestaJSON;
	}
#******************************SINONIMOS**************************************
	if($tipo eq 'eliminarSinonimos'){

    ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'BAJA', 
                                                    entorno => 'control_de_autoridades'}, 
                                                'intranet'
                                    );

		($msg_object)=&C4::AR::ControlAutoridades::t_eliminarSinonimosEditorial(
																						$id,
																						$sinonimoDelete_string
										);


        my $infoRespuestaJSON = to_json $msg_object;
		C4::AR::Auth::print_header($session);
		#se envia en JSON al cliente
		print $infoRespuestaJSON;
	}
	if($tipo eq 'insertarSinonimos'){

    ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'ALTA', 
                                                    entorno => 'control_de_autoridades'}, 
                                                'intranet'
                                    );

		my $sinonimos= $obj->{'sinonimos'}||" ";
		my $sinonimos_arrayref= from_json_ISO($sinonimos);
		($msg_object)=&C4::AR::ControlAutoridades::t_insertSinonimosEditoriales(
											$sinonimos_arrayref, 
											$id
								);


        my $infoRespuestaJSON = to_json $msg_object;
    C4::AR::Auth::print_header($session);
		#se envia en JSON al cliente
		print $infoRespuestaJSON;

	}
	if($tipo eq 'UpdateSinonimo'){

    ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'MODIFICACION', 
                                                    entorno => 'control_de_autoridades'}, 
                                                'intranet'
                                    );

		my $idSinonimo= $obj->{'idSinonimo'}||" ";
		my $nombre= $obj->{'nombre'};
		my $nombreViejo= $obj->{'nombreViejo'};
		($msg_object)=&C4::AR::ControlAutoridades::t_updateSinonimosEditoriales(
											$idSinonimo, 
											$nombre, 
											$nombreViejo
								);


        my $infoRespuestaJSON = to_json $msg_object;
    	C4::AR::Auth::print_header($session);
		#se envia en JSON al cliente
		print $infoRespuestaJSON;
	}

}

#*********************************************Tablas Sinonimos************************************************
my $sinonimo= $obj->{'sinonimo'};
#Para consultar los sinonimos de un Autor
# if( (($tipo eq 'consultaTablasSinonimos')||($tipo eq 'eliminarSinonimos'))&&($tabla eq 'autores')){
if( ($tipo eq 'consultaTablasSinonimos') && ($tabla eq 'autores') ){

($template, $session, $t_params) = get_template_and_user({
            template_name => "catalogacion/configuracion/controlAutoridades/controlAutoridadesSinonimosResult.tmpl",
			query => $input,
			type => "intranet",
			authnotrequired => 0,
			flagsrequired => {  ui => 'ANY', 
                                tipo_documento => 'ANY', 
                                accion => 'CONSULTA', 
                                entorno => 'undefined'},
			debug => 1,
});

	my ($cant, $results) = C4::AR::ControlAutoridades::traerSinonimosAutor($sinonimo);

$t_params->{'RESULTSLOOP'}= $results,

}
#Para consultar los sinonimos de un Autor
# if((($tipo eq 'consultaTablasSinonimos')||($tipo eq 'eliminarSinonimos'))&&($tabla eq 'temas')){
if( ($tipo eq 'consultaTablasSinonimos')&&($tabla eq 'temas') ){

($template, $session, $t_params) = get_template_and_user({
            template_name => "catalogacion/configuracion/controlAutoridades/controlAutoridadesSinonimosResult.tmpl",
            query => $input,
            type => "intranet",
            authnotrequired => 0,
            flagsrequired => {  ui => 'ANY', 
                                tipo_documento => 'ANY', 
                                accion => 'CONSULTA', 
                                entorno => 'undefined'},
            debug => 1,
});


my ($cant, $results) = C4::AR::ControlAutoridades::traerSinonimosTemas($sinonimo);

$t_params->{'RESULTSLOOP'}= $results,


}


#Para consultar los sinonimos de un Autor
# if( (($tipo eq 'consultaTablasSinonimos')||($tipo eq 'eliminarSinonimos'))&&($tabla eq 'editoriales')){
if( ($tipo eq 'consultaTablasSinonimos')&&($tabla eq 'editoriales') ){

($template, $session, $t_params) = get_template_and_user({
            template_name => "catalogacion/configuracion/controlAutoridades/controlAutoridadesSinonimosResult.tmpl",
            query => $input,
            type => "intranet",
            authnotrequired => 0,
            flagsrequired => {  ui => 'ANY', 
                                tipo_documento => 'ANY', 
                                accion => 'CONSULTA', 
                                entorno => 'undefined'},
            debug => 1,
});


	#Armo el combo para mostrar los sinonimos de los autores
	my ($cant, $results) = C4::AR::ControlAutoridades::traerSinonimosEditoriales($sinonimo);

    $t_params->{'RESULTSLOOP'}= $results,
}

#***********************************************************************************************



#*********************************************Tablas Seudonimos************************************************
my $idSeudonimo= $obj->{'seudonimo'};
#Para consultar los seudonimos de un Autor
# if( (($tipo eq 'consultaTablasSeudonimos')||($tipo eq 'eliminarSeudonimos'))&&($tabla eq 'autores')){
if( ($tipo eq 'consultaTablasSeudonimos') && ($tabla eq 'autores') ){

    ($template, $session, $t_params) = get_template_and_user({
                template_name => "catalogacion/configuracion/controlAutoridades/controlAutoridadesSeudonimosResult.tmpl",
                query => $input,
                type => "intranet",
                authnotrequired => 0,
                flagsrequired => {  ui => 'ANY', 
                                    tipo_documento => 'ANY', 
                                    accion => 'CONSULTA', 
                                    entorno => 'undefined'},
                debug => 1,
    });
    
    my ($cant, $results) = C4::AR::ControlAutoridades::traerSeudonimosAutor($idSeudonimo);
    
    $t_params->{'RESULTSLOOP'}= $results,
}

#Para consultar los seudonimos de un Tema
# if((($tipo eq 'consultaTablasSeudonimos')||($tipo eq 'eliminarSeudonimos'))&&($tabla eq 'temas')){
if( ($tipo eq 'consultaTablasSeudonimos')&&($tabla eq 'temas') ){

    ($template, $session, $t_params) = get_template_and_user({
                template_name => "catalogacion/configuracion/controlAutoridades/controlAutoridadesSeudonimosResult.tmpl",
                query => $input,
                type => "intranet",
                authnotrequired => 0,
                flagsrequired => {  ui => 'ANY', 
                                    tipo_documento => 'ANY', 
                                    accion => 'CONSULTA', 
                                    entorno => 'undefined'},
                debug => 1,
    });
    
    my ($cant, $results) = C4::AR::ControlAutoridades::traerSeudonimosTema($idSeudonimo);
    
    $t_params->{'RESULTSLOOP'}= $results,

}


#Para consultar los seudonimos de una Editorial
# if( (($tipo eq 'consultaTablasSeudonimos')||($tipo eq 'eliminarSeudonimos'))&&($tabla eq 'editoriales')){
if( ($tipo eq 'consultaTablasSeudonimos')&&($tabla eq 'editoriales') ){	

    ($template, $session, $t_params) = get_template_and_user({
                template_name => "catalogacion/configuracion/controlAutoridades/controlAutoridadesSeudonimosResult.tmpl",
                query => $input,
                type => "intranet",
                authnotrequired => 0,
                flagsrequired => {  ui => 'ANY', 
                                    tipo_documento => 'ANY', 
                                    accion => 'CONSULTA', 
                                    entorno => 'undefined'},
                debug => 1,
    });
    
    my ($cant, $results) = C4::AR::ControlAutoridades::traerSeudonimosEditoriales($idSeudonimo);
    
    $t_params->{'RESULTSLOOP'}= $results,
}

#***********************************************************************************************

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
