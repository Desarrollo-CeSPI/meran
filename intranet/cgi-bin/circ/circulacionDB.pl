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
use C4::AR::Utilidades;
use C4::AR::PdfGenerator;
# use C4::AR::Mensajes;
use JSON;

my $input           = new CGI;
my $obj             = $input->param('obj');
$obj                = C4::AR::Utilidades::from_json_ISO($obj);
my $authnotrequired = 0;
#tipoAccion = PRESTAMO, RESREVA, DEVOLUCION, CONFIRMAR_PRESTAMO
my $tipoAccion      = C4::AR::Utilidades::trim($obj->{'tipoAccion'})||"";
my $nro_socio       = C4::AR::Utilidades::trim($obj->{'nro_socio'});
#C4::AR::Debug::debug("ACCION -> ".$tipoAccion);
#C4::AR::Debug::debug("SOCIO -> ".$nro_socio);

#***************************************************DEVOLUCION**********************************************
if($tipoAccion eq "DEVOLUCION" || $tipoAccion eq "RENOVACION"){

    my ($user, $session, $flags, $usuario_logueado) = checkauth(    $input, 
                                                                    $authnotrequired, 
                                                                    {   ui => 'ANY', 
                                                                        tipo_documento => 'ANY', 
                                                                        accion => 'ALTA', 
                                                                        entorno => 'circ_renovar',
                                                                        tipo_permiso => 'circulacion'}, 
                                                                        'intranet'
                                        );
#items a devolver o renovar
#aca se arma el div para mostrar los items que se van a devolver o renovar

    my $id_prestamo;
    my $prestamo;
	my $array_ids   = $obj->{'datosArray'};
	my $loop        = scalar(@$array_ids);

	my @infoDevRen                  = ();
	$infoDevRen[0]->{'nro_socio'}   = $user;
	$infoDevRen[0]->{'accion'}      = $tipoAccion;

	for(my $i=0;$i<$loop;$i++){
 		$id_prestamo = $array_ids->[$i];
        $prestamo = C4::AR::Prestamos::getInfoPrestamo($id_prestamo);

        if ($prestamo){
            $infoDevRen[$i]->{'id_prestamo'}    = $id_prestamo;
            $infoDevRen[$i]->{'id3'}            = $prestamo->getId3;
            $infoDevRen[$i]->{'barcode'}        = $prestamo->nivel3->getBarcode;
            $infoDevRen[$i]->{'autor'}          = $prestamo->nivel3->nivel1->getAutor;
            $infoDevRen[$i]->{'titulo'}         = $prestamo->nivel3->nivel1->getTitulo;
            $infoDevRen[$i]->{'unititle'}       = "";
            $infoDevRen[$i]->{'edicion'}        = $prestamo->nivel3->nivel2->getEdicion;
        }
	}

	my $infoDevRenJSON = to_json \@infoDevRen;
    C4::AR::Auth::print_header($session);
	print $infoDevRenJSON;
}
#*************************************************************************************************************

#************************************************CONFIRMAR PRESTAMO*******************************************
elsif($tipoAccion eq "CONFIRMAR_PRESTAMO"){
	
    my ($user, $session, $flags, $usuario_logueado) = checkauth(    $input, 
                                                                    $authnotrequired, 
                                                                    {   ui => 'ANY', 
                                                                        tipo_documento => 'ANY', 
                                                                        accion => 'ALTA', 
                                                                        entorno => 'circ_prestar',
                                                                        tipo_permiso => 'circulacion'}, 
                                                                    'intranet'
                                    );
#SE CREAN LOS COMBO PARA SELECCIONAR EL ITEM Y EL TIPO DE PRESTAMO
	my $array_ids3_a_prestar    = $obj->{'datosArray'};
	my $cant                    = scalar(@$array_ids3_a_prestar);
	my @infoPrestamo            = ();

	$infoPrestamo[0]->{'accion'}      = $tipoAccion;

	for(my $i=0;$i<$cant;$i++){
		my $id3_a_prestar                       = $array_ids3_a_prestar->[$i];
		my $nivel3aPrestar                      = C4::AR::Nivel3::getNivel3FromId3($id3_a_prestar);
    
#         C4::AR::Debug::debug("lajsdlsakjdlaksjdl".$nivel3aPrestar);
		#Busco ejemplares no prestados con estado disponible e igual disponibilidad que el que se quiere prestar
		my $items_array_ref                     = C4::AR::Nivel3::buscarNivel3PorDisponibilidad($nivel3aPrestar);
		#Busco los tipos de prestamo habilitados y con la misma disponibilidad del nivel 3 a prestar
		my ($tipoPrestamos)                     = C4::AR::Prestamos::prestamosHabilitadosPorTipo($nivel3aPrestar->getIdDisponibilidad,$nro_socio);

		$infoPrestamo[$i]->{'id3Old'}           = $id3_a_prestar;
		my ($nivel2)                            = C4::AR::Nivel2::getNivel2FromId2($nivel3aPrestar->nivel2->getId2);
        $infoPrestamo[$i]->{'autor'}            = $nivel2->nivel1->getAutor;
 		$infoPrestamo[$i]->{'titulo'}           = $nivel3aPrestar->nivel2->nivel1->getTitulo;
		$infoPrestamo[$i]->{'unititle'}         = '';
		$infoPrestamo[$i]->{'edicion'}          = $nivel3aPrestar->nivel2->getEdicion;
		$infoPrestamo[$i]->{'items'}            = $items_array_ref;
		$infoPrestamo[$i]->{'tipoPrestamo'}     = $tipoPrestamos;
	}

    my $infoPrestamoJSON                        = to_json \@infoPrestamo;

    C4::AR::Auth::print_header($session);
	print $infoPrestamoJSON;
}
#*************************************************************************************************************

#***************************************************PRESTAMO*************************************************
elsif($tipoAccion eq "PRESTAMO"){
    my ($user, $session, $flags, $usuario_logueado)= checkauth(     $input, 
                                                                    $authnotrequired, 
                                                                    {   ui => 'ANY', 
                                                                        tipo_documento => 'ANY', 
                                                                        accion => 'ALTA', 
                                                                        entorno => 'circ_prestar',
                                                                        tipo_permiso => 'circulacion'}, 
                                                                    'intranet'
                                );	
#se realizan los prestamos
	my $array_ids3=$obj->{'datosArray'};
	my $loop=scalar(@$array_ids3);

	my $id3='';
	my $id3Old;
	my $id2;
	my $tipoPrestamo;
	my %infoOperacion;
	my @infoOperacionArray;
	my @infoMessages;
	my @infoTickets;
	my @errores;
	my $msg_object; 
C4::AR::Debug::debug("SE PRESTAN ".$loop." EJEMPLARES");
	
	for(my $i=0;$i<$loop;$i++){
		#obtengo el id3 de un item a prestar
 		$id3            = $array_ids3->[$i]->{'id3'};
		$tipoPrestamo   = $array_ids3->[$i]->{'tipoPrestamo'};
		$id3Old         = $array_ids3->[$i]->{'id3Old'}; #Esto nunca viene

#Presta 1 o mas al mismo tiempo
		if($id3 ne ""){

C4::AR::Debug::debug("SE VA A PRESTAR ID3:".$id3." (ID3VIEJO: ".$id3Old.") CON EL TIPO :".$array_ids3->[$i]->{'descripcionTipoPrestamo'}." Y BARCODE ".$array_ids3->[$i]->{'barcode'});

			my $nivel3aPrestar                  = C4::AR::Nivel3::getNivel3FromId3($id3);
			my %params;
			$params{'id1'}                      = $nivel3aPrestar->nivel2->nivel1->getId1;
			$params{'id2'}                      = $nivel3aPrestar->nivel2->getId2;
			$params{'id3'}                      = $nivel3aPrestar->getId3;
			$params{'barcode'}                  = $nivel3aPrestar->getBarcode;
			$params{'id3Old'}                   = $id3Old;
			$params{'descripcionTipoPrestamo'}  = $array_ids3->[$i]->{'descripcionTipoPrestamo'};
			$params{'nro_socio'}                = $nro_socio;
			$params{'responsable'}              = $user;
			$params{'id_ui'}                    = C4::AR::Preferencias::getValorPreferencia('defaultUI');
			$params{'id_ui_prestamo'}           = C4::AR::Preferencias::getValorPreferencia('defaultUI');
			$params{'tipo'}                     = "INTRA";
			$params{'tipo_prestamo'}            = $tipoPrestamo;
		
			$msg_object                   = C4::AR::Prestamos::t_realizarPrestamo(\%params);
			
			my $ticketObj                       = 0;

			if(!$msg_object->{'error'}){
			#Se crean los ticket para imprimir.
				C4::AR::Debug::debug("SE PRESTO SIN ERROR --> SE CREA EL TICKET");
				$ticketObj = C4::AR::Prestamos::crearTicket($id3,$nro_socio,$user);
			}

        
			#guardo los errores
			push (@infoMessages, $msg_object);
			
			my %infoOperacion = (
						ticket  => $ticketObj,
			);
	
			push (@infoTickets, \%infoOperacion);

		}
	} #end for

	#se arma la info para enviar al cliente
	my %infoOperaciones;
	$infoOperaciones{'tickets'}     = \@infoTickets;
	$infoOperaciones{'messages'}    = \@infoMessages;

	my $infoOperacionJSON           = to_json \%infoOperaciones;

    C4::AR::Auth::print_header($session);
	print $infoOperacionJSON;

}
#**********************************************FIN*****PRESTAMO**********************************************
elsif($tipoAccion eq "REALIZAR_DEVOLUCION"){
    my ($user, $session, $flags, $usuario_logueado) = checkauth(    $input, 
                                                                    $authnotrequired, 
                                                                    {   ui => 'ANY', 
                                                                        tipo_documento => 'ANY', 
                                                                        accion => 'ALTA', 
                                                                        entorno => 'circ_devolver',
                                                                        tipo_permiso => 'circulacion'}, 
                                                                      'intranet'
                                );

    $obj->{'nro_socio'}        = $nro_socio;
	$obj->{'responsable'}      = $user;
    
	my ($Message_arrayref)     = C4::AR::Prestamos::t_devolver($obj);


   	my %info;
    $info{'Messages_arrayref'}  = $Message_arrayref;

    C4::AR::Auth::print_header($session);
    print to_json \%info;
}


elsif($tipoAccion eq "REALIZAR_RENOVACION"){
    my ($user, $session, $flags, $usuario_logueado) = checkauth(    $input, 
                                                                    $authnotrequired, 
                                                                    {   ui => 'ANY', 
                                                                        tipo_documento => 'ANY', 
                                                                        accion => 'ALTA', 
                                                                        entorno => 'circ_renovar',
                                                                        tipo_permiso => 'circulacion'}, 
                                                                    'intranet'
                                );

    $obj->{'responsable'}           = $user;
    $obj->{'type'}           = $session->param('type');
    my ($infoTickets,$msg_object)   = C4::AR::Prestamos::t_renovar($obj);
    
    my %info;
    $info{'tickets'}                = $infoTickets;
    $info{'messages'}               = $msg_object;

    C4::AR::Auth::print_header($session);
	print to_json \%info;
}
#******************************************FIN***DEVOLVER_RENOVAR*********************************************


#******************************************CANCELAR RESERVA***************************************************
elsif($tipoAccion eq "CANCELAR_RESERVA"){

    my ($user, $session, $flags, $usuario_logueado) = checkauth(    $input, 
                                                                    $authnotrequired, 
                                                                    {   ui => 'ANY', 
                                                                        tipo_documento => 'ANY', 
                                                                        accion => 'BAJA', 
                                                                        entorno => 'circ_prestar',
                                                                        tipo_permiso => 'circulacion'}, 
                                                                    'intranet'
                                );
		
	my %params;
	$params{'id_reserva'}   = $obj->{'id_reserva'};
	$params{'nro_socio'}    = $obj->{'nro_socio'};
	$params{'responsable'}  = $user;
	$params{'tipo'}         = "INTRA";

    my $enabled                = C4::AR::Preferencias::getValorPreferencia('cancelar_reservas_intranet');	
    
    my ($msg_object);
    
    if ($enabled){
	   ($msg_object)     = C4::AR::Reservas::t_cancelar_reserva(\%params);
    }else{
    	$msg_object = C4::AR::Mensajes::create();
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U308b', 'params' => []} ) ;
    }
    
    
	my $infoOperacionJSON=to_json $msg_object;
	
    C4::AR::Auth::print_header($session);
	print $infoOperacionJSON;
}
#******************************************FIN***CANCELAR RESERVA*********************************************

elsif($tipoAccion eq "CIRCULACION_RAPIDA"){

    my ($user, $session, $flags, $usuario_logueado) = checkauth(    $input, 
                                                                    $authnotrequired, 
                                                                    {   ui => 'ANY', 
                                                                        tipo_documento => 'ANY', 
                                                                        accion => 'ALTA', 
                                                                        entorno => 'circ_prestar',
                                                                        tipo_permiso => 'circulacion'}, 
                                                                    'intranet'
                                );
		
	my $Message_arrayref;
	my %params;
	$params{'barcode'}              = $obj->{'barcode'};
	$params{'nro_socio'}            = $obj->{'nro_socio'};
	$params{'operacion'}            = $obj->{'operacion'};
	$params{'responsable'}          = $user;
	$params{'tipo_prestamo'}        = $obj->{'tipoPrestamo'};
	$params{'datosArray'}           = $obj->{'datosArray'};
    $params{'adicional_selected'}   = $obj->{'adicional_selected'};

	
	if($params{'operacion'} eq "renovar"){	
        C4::AR::Debug::debug("circulacionDB.pl => circulacion rapida => renovar barcode: ".$params{'datosArray'});	
        ($Message_arrayref)   = C4::AR::Prestamos::renovarYGenerarTicket(\%params);
	}
	elsif($params{'operacion'} eq "devolver"){

		($Message_arrayref)     = C4::AR::Prestamos::t_devolver(\%params);	
	}
	elsif($params{'operacion'} eq "prestar"){
		($Message_arrayref)     = C4::AR::Prestamos::prestarYGenerarTicket(\%params);
	}
	
	my $infoOperacionJSON       = to_json $Message_arrayref;

    C4::AR::Auth::print_header($session);
	print $infoOperacionJSON;
}
elsif($tipoAccion eq "CIRCULACION_RAPIDA_OBTENER_TIPOS_DE_PRESTAMO"){

    my ($user, $session, $flags, $usuario_logueado) = checkauth(    $input, 
                                                                    $authnotrequired, 
                                                                    {   ui => 'ANY', 
                                                                        tipo_documento => 'ANY', 
                                                                        accion => 'CONSULTA', 
                                                                        entorno => 'circ_prestar',
                                                                        tipo_permiso => 'circulacion'}, 
                                                                    'intranet'
                                );

	#obtengo el objeto de nivel3 segun el barcode que se quiere prestar
	my ($nivel3aPrestar) = C4::AR::Nivel3::getNivel3FromBarcode($obj->{'barcode'});

    if($nivel3aPrestar){

        C4::AR::Debug::debug("nivel3aPrestar disponibilidad=> ".$nivel3aPrestar->getIdDisponibilidad());
	    #obtengo los tipos de prestmos segun disponibilidad del ejemplar y el usuario
	    my ($tipoPrestamos_array_hash_ref)  = &C4::AR::Prestamos::prestamosHabilitadosPorTipo(   $nivel3aPrestar->getIdDisponibilidad(),
                                                                                                 $obj->{'nro_socio'}
                                                                                        );
	    my %tiposPrestamos;
	    $tiposPrestamos{'tipoPrestamo'}     = $tipoPrestamos_array_hash_ref;
        # checkeamos si el socio tiene sanciones, y que tipos de prestamo puede realizar
	    my $sanciones_array_ref             = C4::AR::Sanciones::tieneSanciones($obj->{'nro_socio'});
	    
	    #tiene sanciones?
	     $tiposPrestamos{'tieneSancion'} = $sanciones_array_ref?1:0;

	    my $infoOperacionJSON               = to_json \%tiposPrestamos;
    
        C4::AR::Auth::print_header($session);
	    print $infoOperacionJSON;
    }
}
elsif($tipoAccion eq "CIRCULACION_RAPIDA_OBTENER_DATOS_EJEMPLAR"){

    my ($template, $session, $t_params) = get_template_and_user({
                                            template_name       => "circ/mostrarDatosEjemplar.tmpl",
                                            query               => $input,
                                            type                => "intranet",
                                            authnotrequired     => 0,
                                            flagsrequired       => {  ui => 'ANY', 
                                                                      tipo_documento => 'ANY', 
                                                                      accion => 'CONSULTA', 
                                                                      entorno => 'circ_prestar',
                                                                      tipo_permiso => 'circulacion'},
                                            debug               => 1,
                });

    #obtengo el objeto de nivel3 segun el barcode que se quiere prestar
    my ($nivel3) = C4::AR::Nivel3::getNivel3FromBarcode($obj->{'barcode'}, 1);

    if($nivel3){

        my $socio                       = C4::AR::Prestamos::getSocioFromPrestamo($nivel3->getId3());
        my $socio_reserva               = C4::AR::Reservas::getSocioFromReserva($nivel3->getId3());
    
        $t_params->{'titulo'}           = $nivel3->nivel2->nivel1->getTitulo();
        $t_params->{'autor'}            = $nivel3->nivel2->nivel1->getAutor();
        $t_params->{'nivel3'}           = $nivel3;
        $t_params->{'socio_prestamo'}   = $socio;
        $t_params->{'socio_reserva'}    = $socio_reserva;         

        C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
    }
}
elsif($tipoAccion eq "CIRCULACION_RAPIDA_OBTENER_SOCIO"){

    my ($user, $session, $flags, $usuario_logueado) = checkauth(    $input, 
                                                                    $authnotrequired, 
                                                                    {   ui => 'ANY', 
                                                                        tipo_documento => 'ANY', 
                                                                        accion => 'CONSULTA', 
                                                                        entorno => 'circ_prestar',
                                                                        tipo_permiso => 'circulacion'}, 
                                                                    'intranet'
                                );

	#obtengo el objeto de nivel3 segun el barcode que se quiere prestar
	my ($socio)= C4::AR::Prestamos::getSocioFromID_Prestamo($obj->{'prestamo'});
	
	my %infoSocio;
	if($socio){
		$infoSocio{'apeYNom'}= $socio->persona->getApeYNom;
		$infoSocio{'nro_socio'}= $socio->getNro_socio;
	}

	my $infoOperacionJSON=to_json \%infoSocio;

    C4::AR::Auth::print_header($session);
	print $infoOperacionJSON;
}
elsif($tipoAccion eq "CIRCULACION_RAPIDA_TIENE_AUTORIZADO"){

#     my ($user, $session, $flags, $usuario_logueado) = checkauth(    $input, 
#                                                                     $authnotrequired, 
#                                                                     {   ui => 'ANY', 
#                                                                         tipo_documento => 'ANY', 
#                                                                         accion => 'CONSULTA', 
#                                                                         entorno => 'undefined'}, 
#                                                                     'intranet'
#                                 );

    my ($template, $session, $t_params) = get_template_and_user({
                                    template_name => "circ/mostrarAdicional.tmpl",
                                    query => $input,
                                    type => "intranet",
                                    authnotrequired => 0,
                                    flagsrequired => {  ui => 'ANY', 
                                                        tipo_documento => 'ANY', 
                                                        accion => 'CONSULTA', 
                                                        entorno => 'circ_prestar',
                                                        tipo_permiso => 'circulacion'},
                                    debug => 1,
                });
		
	my $Message_arrayref;
	my %params;
	$params{'barcode'}      = $obj->{'barcode'};
	$params{'nro_socio'}    = $obj->{'nro_socio'};
	$params{'operacion'}    = $obj->{'operacion'};
	
	my $socio               = C4::AR::Usuarios::getSocioInfoPorNroSocio($params{'nro_socio'});
# 	my $flag                = 0;

# 	if($socio){
# 		$flag = $socio->tieneAutorizado;
# 	}

    $t_params->{'socio'} = $socio;

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

#     C4::AR::Auth::print_header($session);
# 	print $flag;
}
elsif($tipoAccion eq "CIRCULACION_RAPIDA_ES_REGULAR"){

    my ($user, $session, $flags, $usuario_logueado) = checkauth(    $input, 
                                                                    $authnotrequired, 
                                                                    {   ui => 'ANY', 
                                                                        tipo_documento => 'ANY', 
                                                                        accion => 'CONSULTA', 
                                                                        entorno => 'circ_prestar',
                                                                        tipo_permiso => 'circulacion'},
                                                                    'intranet'
                                );

	my $socio= C4::AR::Usuarios::getSocioInfoPorNroSocio($obj->{'nro_socio'});

	my $regular= 1;
    if ($socio){
		$regular= $socio->esRegular;
	}
	
    C4::AR::Auth::print_header($session);
	print $regular;
}

elsif ( $tipoAccion eq "IMPRIMIR_COMPROBANTE" ) {

            my ($template, $session, $t_params) =  get_template_and_user ({
                    template_name   => 'circ/ticket.tmpl',
                    query       => $input,
                    type        => "intranet",
                    authnotrequired => 0,
                    flagsrequired   => {    ui => 'ANY', 
                                            tipo_documento => 'ANY', 
                                            accion => 'ALTA', 
                                            entorno => 'circ_prestar',
                                            tipo_permiso => 'circulacion'},
            });

            my %env;
            my @comprobantes;
     
            my $ref_array= $obj->{'comprobantes'};

            foreach my $elem (@$ref_array) {
                    my %hash;    
                    my $ticket= $elem->{'ticket'};
    
                    $hash{'socio'} =    C4::AR::Usuarios::getSocioInfoPorNroSocio($ticket->{'socio'});
                    $hash{'responsable'} = C4::AR::Usuarios::getSocioInfoPorNroSocio($ticket->{'responsable'});                
                    $hash{'prestamo'} = C4::AR::Prestamos::getPrestamoDeId3($ticket->{'id3'});
                    $hash{'adicional_selected'}   = $ticket->{'adicional_selected'};
                    push(@comprobantes,\%hash);
                   
            }
      
        
            $t_params->{'comprobantes'}   = \@comprobantes;
            $t_params->{'pageSize'}   = "A5";
           
   
            my $out= C4::AR::Auth::get_html_content($template, $t_params, $session);
            my $filename= C4::AR::PdfGenerator::pdfFromHTML($out, $t_params);

            my $public_report = C4::AR::Utilidades::moveFileToReports($filename);
# 
#             my $out= C4::AR::Auth::get_html_content($template, $t_params, $session);
#             my $filename= C4::AR::PdfGenerator::pdfFromHTML($out, $t_params);
#             print C4::AR::PdfGenerator::pdfHeader();
#             C4::AR::PdfGenerator::printPDF($filename);
            
            C4::AR::Auth::print_header($session);
            print $public_report;
#           
           
} 